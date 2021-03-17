local _G = GLOBAL
local TheNet = _G.TheNet
local TheSim = _G.TheSim
local ACTIONS = _G.ACTIONS
local BufferedAction = _G.BufferedAction
local FRAMES = _G.FRAMES
local SendRPCToServer = _G.SendRPCToServer
local RPC = _G.RPC
local GetTime = _G.GetTime
local Sleep = _G.Sleep
local JoinArrays = _G.JoinArrays
local shallowcopy = _G.shallowcopy
local orderedPairs = _G.orderedPairs

local upvalueutil = require("upvalueutil")
local getval = upvalueutil.GetUpvalue
local setval = upvalueutil.SetUpvalue

local morph_checker = _G.kleiloadlua(MODROOT.."scripts/morph_checker.lua") -- Basically modimport, but we need the return value
_G.setfenv(morph_checker, env)
morph_checker = morph_checker()
local IsRightItem = morph_checker.IsRightItem

local allow_all_open_containers = GetModConfigData("allow_all_open_containers")
local rmb_pickup_setting = GetModConfigData("rmb_pickup_setting")
local tilling_spacing_config = GetModConfigData("tilling_spacing")
local is_gorge = TheNet:GetServerGameMode() == "quagmire"
local farm_till_spacing = _G.GetFarmTillSpacing() + 0.01
local tilling_spacing = (is_gorge or tilling_spacing_config == "min") and farm_till_spacing or tilling_spacing_config

local DEPLOY_IGNORE_TAGS = { "NOBLOCK", "player", "FX", "INLIMBO", "DECOR", "WALKABLEPLATFORM" }
local TILLSOIL_IGNORE_TAGS = { "NOBLOCK", "player", "FX", "INLIMBO", "DECOR", "WALKABLEPLATFORM", "soil" }

local auto_collect_tag_blacklist = {"bundle", "fan", "irreplaceable", "singingshell"}
local auto_collect_blacklist = {
    "waxwelljournal", "firecrackers", "miniflare", "ash", "moonrockcrater",
    "purplemooneye", "bluemooneye", "yellowmooneye", "redmooneye", "orangemooneye", "greenmooneye",
    "pumpkin_lantern", "heatrock"
}

local till_shape = {
    {-1,  1},  {0,  1},  {1,  1},
    {-1,  0},  {0,  0},  {1,  0},
    {-1, -1},  {0, -1},  {1, -1},
}

local function is_eating(self)
    return self.inst.AnimState:IsCurrentAnimation("eat_pre")
        or self.inst.AnimState:IsCurrentAnimation("eat")
        or self.inst.AnimState:IsCurrentAnimation("quick_eat_pre")
        or self.inst.AnimState:IsCurrentAnimation("quick_eat")
end
local function is_atk(self)
    return self.inst.AnimState:IsCurrentAnimation("player_atk") -- When riding
        or self.inst.AnimState:IsCurrentAnimation("atk")
end
local function is_onframe(self, frame, allowed_bias)
    frame = frame * FRAMES
    allowed_bias = allowed_bias or FRAMES
    local ping = TheNet:GetPing() / 1000
    local cur_time = self.inst.AnimState:GetCurrentAnimationTime()
    if not _G.TheWorld.ismastersim then
        frame = math.max(0, frame - math.max(FRAMES, ping))
    end
    return cur_time >= frame and cur_time <= frame + allowed_bias
end

local function not_mastersim(target)
    return not _G.TheWorld.ismastersim
end

local function has_component(target, cmp)
    if not (target and target.actioncomponents) then return end
    local ACTION_COMPONENT_IDS = getval(target.RegisterComponentActions, "ACTION_COMPONENT_IDS")
    return ACTION_COMPONENT_IDS
        and ACTION_COMPONENT_IDS[cmp]
        and table.contains(target.actioncomponents, ACTION_COMPONENT_IDS[cmp])
end

local function has_action(actions, action)
    for _, v in ipairs(actions) do
        if v.action == ACTIONS[action] then
            return true
        end
    end
    return false
end

local last_recipe
local function try_craft(inst)
    if last_recipe and inst.replica.builder:CanBuild(last_recipe.name) then
        inst.replica.builder:MakeRecipeFromMenu(last_recipe)
        return
    end
    for recname, rec in pairs(_G.AllRecipes) do
        if _G.IsRecipeValid(recname)
            and rec.placer == nil
            and rec.tab.shop == nil
            and not (recname == "livinglog" and inst:HasTag("plantkin"))
            and inst.replica.builder:CanBuild(recname) then
            
            inst.replica.builder:MakeRecipeFromMenu(rec)
            return
        end
    end
end

AddClassPostConstruct("components/builder_replica", function(self)
    local BuilderReplicaMakeRecipeFromMenu = self.MakeRecipeFromMenu
    self.MakeRecipeFromMenu = function(self, recipe, skin, ...)
        last_recipe = recipe
        return BuilderReplicaMakeRecipeFromMenu(self, recipe, skin, ...)
    end
end)

AddComponentPostInit("actionqueuer", function(self, inst)

    self.AddActionList("leftclick", "MIOFUEL", "MIOWETFUEL", "MURDER", "USEKLAUSSACKKEY", "READ", 
    "HACK", "BATHBOMB", "PLANTSOIL", "ADDCOMPOSTABLE", "INTERACT_WITH")

    self.AddActionList("rightclick", "FILL")

    self.AddActionList("allclick", "HACK")

    self.AddActionList("noworkdelay", "PICKUP", "PICK", "FEEDPLAYER", "UNWRAP", "RESETMINE", "DRAW",
    "TURNON", "TURNOFF", "LIGHT", "USEKLAUSSACKKEY", "READ", "FEED", "MURDER", "HACK", "BATHBOMB",
    "PLANTSOIL", "ADDCOMPOSTABLE", "INTERACT_WITH", "TILL", "TAKEITEM")

    self.AddActionList("autocollect", "HACK")

    self.AddAction("noworkdelay", "DEPLOY", not_mastersim)
    self.AddAction("noworkdelay", "POUR_WATER_GROUNDTILE", not_mastersim)

    self.AddAction("collect", "PICKUP", function(target)
        if target.replica.equippable ~= nil then return false end
        if table.contains(auto_collect_blacklist, target.prefab) then return false end
        for _, v in ipairs(auto_collect_tag_blacklist) do
            if target:HasTag(v) then
                return false
            end
        end
        if has_component(target, "book") then return false end
        return true
    end)
    self.AddAction("collect", "HARVEST", function(target)
        return target.prefab == "meatrack"
    end)
    self.RemoveAction("collect", "PICK")

    self.AddAction("leftclick", "SHAVE", function(target) -- For waterplant (Sea Weed)
        return target:HasTag("brushable") or target:HasTag("harvestable")
    end)

    self.AddAction("rightclick", "LIGHT", function(target)
        return not target:HasTag("flower")
    end)

    local function can_fuel(target)
        local not_fuel_items = {
            boatpatch = true,
            featherpencil = true,
        }
        local active_item = self:GetActiveItem()
        return not (active_item and not_fuel_items[active_item.prefab])
    end
    self.AddAction("leftclick", "ADDFUEL", can_fuel)
    self.AddAction("leftclick", "ADDWETFUEL", can_fuel)

    local function is_target_only(target)
        local amount = 0
        for k, v in pairs(self.selected_ents) do
            amount = amount + 1
            if k ~= target or amount > 1 then
                return false
            end
        end
        return true
    end

    self.AddAction("leftclick", "EAT", is_target_only)
    self.AddAction("allclick", "EAT", is_target_only)
    self.RemoveAction("rightclick", "EAT")

    self.AddAction("leftclick", "FEED", is_target_only)
    self.AddAction("rightclick", "FEED", is_target_only)

    self.AddAction("leftclick", "ACTIVATE", function(target) -- Changed prefab test to tag test, mostly for compatible with Island Advantures
        return target:HasTag("dirtpile")
    end)

    self.AddAction("leftclick", "HARVEST", function(target)
        return target.prefab ~= "birdcage"
            and not (target.prefab == "fish_farm"
                and target.current_volume ~= nil
                and target.current_volume:value() == 1)
    end)
    self.AddAction("noworkdelay", "HARVEST", function(target)
        return not (target.prefab == "fish_farm"
            and target.current_volume ~= nil
            and target.current_volume:value() == 2)
    end)

    self.AddAction("single", "CASTSPELL", function(target)
        local hand_item = self:GetEquippedItemInHand()
        return not (hand_item and hand_item.prefab == "greenstaff")
    end)

    self.AddAction("rightclick", "TAKEITEM", function(target)
        return target.prefab ~= "winch"
    end)

    self.AddAction("rightclick", "PICKUP", function(target)
        return rmb_pickup_setting and target:HasTag("heavy") and is_target_only(target)
            and (rmb_pickup_setting == "all" or target.prefab:find("sculpture_"))
    end)

    self.AddAction("noworkdelay", "FILL", function(target)
        return self:GetActiveItem()
            or not has_component(self:GetEquippedItemInHand(), "wateryprotection")
    end)

    self.AddAction("leftclick", "REPAIR_LEAK", function(target)
        return not target.AnimState:IsCurrentAnimation("leak_small_pst")
    end)

    -- self.AddAction("leftclick", "PICK", function(target)
    --     return target.prefab ~= "flower_evil"
    --         and not (target.prefab == "rock_avocado_bush"
    --             and target.AnimState:IsCurrentAnimation("idle4"))
    -- end)

    local SelectionBox = self.SelectionBox
    self.SelectionBox = function(self, rightclick, ...)
        SelectionBox(self, rightclick, ...)
        local update_selection = self.update_selection
        self.update_selection = function()
            local active_item = self:GetActiveItem()
            if active_item and active_item:HasTag("wallbuilder") then
                local unselectable_tags = getval(SelectionBox, "unselectable_tags")
                setval(SelectionBox, "unselectable_tags", JoinArrays(unselectable_tags, {"wall"}))
                update_selection()
                setval(SelectionBox, "unselectable_tags", unselectable_tags)
                return
            end
            update_selection()
        end
    end

    local entity_morph = getval(self.CheckEntityMorph, "entity_morph")
    local extra_morph = { ancient_altar = "ancient_altar_broken" }
    shallowcopy(extra_morph, entity_morph)
    setval(self.CheckEntityMorph, "entity_morph", entity_morph)

    local easy_stack = getval(self.OnUp, "easy_stack")
    local extra_stuff = { lureplantbulb = "lureplant" }
    shallowcopy(extra_stuff, easy_stack)
    setval(self.OnUp, "easy_stack", easy_stack)

    local deploy_spacing = getval(self.SetToothTrapSpacing, "deploy_spacing")
    local extra_custom_spacing = { seed = 4/3 }
    shallowcopy(extra_custom_spacing, deploy_spacing)
    setval(self.SetToothTrapSpacing, "deploy_spacing", deploy_spacing)

    local Wait = self.Wait
    local CheckAllowedActions = getval(self.Wait, "CheckAllowedActions")
    local IsValidEntity = getval(SelectionBox, "IsValidEntity")

    local function base_wait_cond()
        return self.inst:HasTag("idle") and not self.inst.components.playercontroller:IsDoingOrWorking()
            and not (self.inst.sg and self.inst.sg:HasStateTag("moving"))
            and not self.inst:HasTag("moving")
    end

    local function try_pickup_canary(pos)
        local x, y, z = pos:Get()
        local canarys = TheSim:FindEntities(x, y, z, 4, {"canary"}, {"INLIMBO"})
        for _, canary in ipairs(canarys) do
            if canary.prefab == "canary_poisoned" and IsValidEntity(canary) then
                local act = self:GetAction(canary, false)
                if act then
                    self:SelectEntity(canary, false)
                    while IsValidEntity(canary) do
                        local act = self:GetAction(canary, false)
                        if not act or act.action ~= ACTIONS.PICKUP then break end
                        self:SendActionAndWait(act, false, canary)
                    end
                    self:DeselectEntity(canary)
                    return true
                end
            end
        end
    end

    self.Wait = function(self, action, target)
        if action == ACTIONS.PICKUP and CheckAllowedActions("noworkdelay", action, target) then
            local act = nil
            repeat
                Sleep(FRAMES)
                act = IsValidEntity(target) and self:GetAction(target) or nil
            until is_eating(self)
                or self.inst.AnimState:IsCurrentAnimation("staff") -- for using try_pickup_canary function
                or not (act and act.action == ACTIONS.PICKUP)
                or base_wait_cond()
        elseif action == ACTIONS.LOWER_SAIL_BOOST then
            local done_ho = false
            repeat
                Sleep(FRAMES)
                if not done_ho and self.inst:HasTag("switchtoho") then
                    done_ho = true
                    self:SendAction(BufferedAction(self.inst, target, action), false, target)
                end
            until base_wait_cond()
        elseif action == ACTIONS.CASTSPELL then
            local hand_item = self:GetEquippedItemInHand()
            if not (hand_item and target) then
                Wait(self, action, target)
            elseif hand_item:HasTag("veryquickcast") then
                while IsValidEntity(target)
                    and self:GetAction(target, true, target:GetPosition())
                    and self:GetAction(target, true, target:GetPosition()).action == ACTIONS.CASTSPELL
                    and (self.inst:HasTag("idle") or is_atk(self)) do

                    local act = BufferedAction(self.inst, target, action, self:GetEquippedItemInHand())
                    self:SendAction(act, true, target)
                    Sleep(self.action_delay)
                end

                repeat
                    Sleep(FRAMES)
                until is_atk(self) and is_onframe(self, 5)
                    or base_wait_cond()
            elseif self.auto_collect
                and hand_item.prefab == "greenstaff"
                and target.prefab == "sleepbomb" then

                local pos = target:GetPosition()
                Sleep(self.work_delay)
                repeat
                    Sleep(self.action_delay)
                    if self.inst.AnimState:IsCurrentAnimation("staff")
                        and is_onframe(self, 45, self.action_delay + FRAMES) then
                            
                        try_craft(self.inst)
                        Sleep(FRAMES * 0) -- sleep until 4 frames's busy done
                    end
                until try_pickup_canary(pos) or base_wait_cond()

            else
                Wait(self, action, target)
            end
        elseif action == ACTIONS.FILL then
            Wait(self, action, target)
            if self:GetActiveItem() then return end
            local equip_item = self:GetEquippedItemInHand()
            local inventoryitem = equip_item and equip_item.replica.inventoryitem
            if inventoryitem and inventoryitem.classified and inventoryitem.classified.percentused:value() == 100 then
                local item = self:GetNewEquippedItemInHand(equip_item.prefab, function(_item)
                    return _item.replica.inventoryitem
                        and _item.replica.inventoryitem.classified
                        and _item.replica.inventoryitem.classified.percentused:value() < 100
                end)
                if not item then -- Just wanna break the loop, but idk how to do it without tons of override
                    self.inst:DoTaskInTime(0, function()
                        self:DeselectEntity(target)
                        self:ClearActionThread()
                        self:ApplyToSelection()
                    end)
                    Sleep(FRAMES * 0)--2
                end
            end
        elseif action == ACTIONS.ACTIVATE then
            local is_dirtpile = target:HasTag("dirtpile")
            local x, y, z = target.Transform:GetWorldPosition()
            Wait(self, action, target)
            if is_dirtpile then
                local ents = TheSim:FindEntities(x, y, z, TUNING.HUNT_SPAWN_DIST + 1, {"dirtpile"})
                for _, ent in ipairs(ents) do
                    if IsValidEntity(ent) and ent:GetTimeAlive() < 1 then
                        self:SelectEntity(ent, false)
                        break
                    end
                end
            end
        else
            Wait(self, action, target) 
        end
    end

    local function GetSnap(pos) -- Mostly from surg's Snaping Tills
        if self.inst.components.snaptiller then
            return self.inst.components.snaptiller:GetSnap(pos)
        elseif tilling_spacing ~= 1.33 then
            return pos
        end
        local x, _, z = _G.TheWorld.Map:GetTileCenterPoint(pos:Get())
        local pos_list = {}
        for _, coor in ipairs(till_shape) do
            table.insert(pos_list, _G.Vector3(x + coor[1] * 1.33, 0, z + coor[2] * 1.33))
        end
        local min_dist, final_pos
        for _, snap_pos in ipairs(pos_list) do
            local dist = _G.distsq(pos.x, pos.z, snap_pos.x, snap_pos.z)
            if min_dist == nil or dist < min_dist then
                min_dist = dist
                final_pos = snap_pos
            end
        end
        return final_pos
    end

    self.HandleGroundItem = function(self, pos, range, ignore_tags)
        local ents = TheSim:FindEntities(pos.x, 0, pos.z, range, nil, ignore_tags)
        local seeds = {}
        for _, ent in ipairs(ents) do
            if ent.prefab == "seeds" then
                table.insert(seeds, ent)
            else
                return -- Have other blockers, skip
            end
        end
        if #seeds == 0 then return end
        for _, seed in ipairs(seeds) do
            local act = IsValidEntity(seed)
                    and seed.replica.inventoryitem
                    and seed.replica.inventoryitem:CanBePickedUp()
                    and BufferedAction(self.inst, seed, ACTIONS.PICKUP)
            if act then
                self:SelectEntity(seed, false)
                while IsValidEntity(seed) do
                    if self:GetActiveItem() then
                        local playercontroller = self.inst.components.playercontroller
                        if playercontroller.ismastersim then
                            self.inst.components.combat:SetTarget(nil)
                            playercontroller:DoAction(act)
                        else
                            if seed:IsNear(self.inst, 6) then
                                SendRPCToServer(RPC.StopWalking)
                                local cb = function() SendRPCToServer(RPC.ActionButton, ACTIONS.PICKUP.code, seed, true, true) end
                                if playercontroller:CanLocomote() then
                                    act.preview_cb = cb
                                    playercontroller.locomotor:PreviewAction(act, true)
                                else
                                    cb()
                                end
                            else
                                local pos = seed:GetPosition()
                                if playercontroller.locomotor then
                                    playercontroller.locomotor:RunInDirection(self.inst:GetAngleToPoint(pos))
                                end
                                SendRPCToServer(RPC.DragWalking, pos.x, pos.z)
                            end
                        end
                        self:Wait(act.action, seed)
                    else
                        self:SendActionAndWait(act, false, seed)
                    end
                end
                self:DeselectEntity(seed)
            end
        end
        return true
    end
    
    self.TillAtPoint = function(self, pos)
        self:WaitToolReEquip()
        local equip_item = self:GetEquippedItemInHand()
        if not equip_item then return false end
        pos = GetSnap(pos)
        if #TheSim:FindEntities(pos.x, 0, pos.z, 0.05, {"soil"}, {"NOCLICK", "NOBLOCK"}) > 0 then
            return true -- Skip, if already have a good farm soil
        end
        local act = BufferedAction(self.inst, nil, ACTIONS.TILL, equip_item, pos)
        local actions = self.inst.components.playeractionpicker:GetPointActions(pos, equip_item, true)
        if has_action(actions, "TILL") then
            repeat
                self:SendActionAndWait(act, true)
                actions = self.inst.components.playeractionpicker:GetPointActions(pos, equip_item, true)
            until not has_action(actions, "TILL")
                or #TheSim:FindEntities(pos.x, 0, pos.z, 0.05, {"soil"}, {"NOCLICK", "NOBLOCK"}) > 0
        elseif _G.TheWorld.Map:IsFarmableSoilAtPoint(pos.x, 0, pos.z) then
            if self:HandleGroundItem(pos, farm_till_spacing, TILLSOIL_IGNORE_TAGS) then
                self:TillAtPoint(pos) -- Try again
            end
        end
        return true
    end

    local GetDeploySpacing = getval(self.OnUp, "GetDeploySpacing")

    local DeployActiveItem = self.DeployActiveItem
    self.DeployActiveItem = function(self, pos, item, ...)
        local rt = DeployActiveItem(self, pos, item, ...)
        if rt then
            local active_item = self:GetActiveItem()
            local inventoryitem = active_item and active_item:IsValid() and active_item.replica.inventoryitem
            if inventoryitem
                and inventoryitem.classified ~= nil
                and not inventoryitem:CanDeploy(pos, nil, self.inst)
                and (
                    inventoryitem.classified.deploymode:value() ~= _G.DEPLOYMODE.PLANT or
                    _G.TheWorld.Map:CanPlantAtPoint(pos:Get())
                ) then
                
                if self:HandleGroundItem(pos, GetDeploySpacing(active_item) - 0.01, DEPLOY_IGNORE_TAGS) then
                    return DeployActiveItem(self, pos, item, ...) -- Try again
                end
            end
        end
        return rt
    end

    local function needs_water(ent)
        local percent = ent and ent:IsValid() and _G.tonumber(ent:GetDebugString():match("Frame: (.*)/"))
        if percent ~= nil then
            percent = percent / 30
        end
        return percent and percent < 0.9
    end

    local function has_water(item)
        local inventoryitem = item and item.replica.inventoryitem
        return inventoryitem.classified
            and inventoryitem.classified.percentused:value()
            and inventoryitem.classified.percentused:value() > 0
    end

    local TerraformAtPoint = self.TerraformAtPoint
    self.TerraformAtPoint = function(self, pos, item, ...)
        if has_component(item, "wateryprotection") then
            local equip_item = self:GetEquippedItemInHand()
            if not equip_item then return false end
            local nutrients_overlay
            local x, y, z = _G.TheWorld.Map:GetTileCenterPoint(pos:Get())
            for _, ent in ipairs(TheSim:FindEntities(x, y, z, 0.1, {"DECOR", "NOCLICK"})) do
                if ent:IsValid() and ent.prefab == "nutrients_overlay" then
                    nutrients_overlay = ent
                    break
                end
            end
            if not needs_water(nutrients_overlay) then return true end
            repeat
                equip_item = self:GetEquippedItemInHand()
                local act = BufferedAction(self.inst, nil, ACTIONS.POUR_WATER_GROUNDTILE, equip_item, pos)
                local actions = self.inst.components.playeractionpicker:GetPointActions(pos, equip_item, true)
                if has_action(actions, "POUR_WATER_GROUNDTILE") then
                    if not has_water(equip_item) then
                        local new_item = self:GetNewEquippedItemInHand(item.prefab, has_water)
                        if new_item then
                            act.invobject = new_item
                        else
                            return false
                        end
                    end
                    self:SendActionAndWait(act, true)
                else
                    return true
                end
            until not needs_water(nutrients_overlay)
            return true
        end
        return TerraformAtPoint(self, pos, item)
    end

    local OnUp = self.OnUp
    self.OnUp = function(self, rightclick, ...)
        if self.clicked
            and not self.action_thread
            and not self:IsWalkButtonDown()
            and not _G.next(self.selected_ents)
            and rightclick
            and not self:GetActiveItem() then
                
            local equip_item = self:GetEquippedItemInHand()
            if equip_item then
                if has_component(equip_item, "farmtiller")
                    or has_component(equip_item, "quagmire_tiller") then

                    self:ClearSelectionThread()
                    self.clicked = false
                    self:DeployToSelection(self.TillAtPoint, tilling_spacing)
                    return
                elseif has_component(equip_item, "wateryprotection") then
                    self:ClearSelectionThread()
                    self.clicked = false
                    self:DeployToSelection(self.TerraformAtPoint, _G.TILE_SCALE, equip_item) -- Use TerraformAtPoint is bc wanna trigger DeployToSelection's GetAccessibleTilePosition function
                    return
                end
            end
        end
        return OnUp(self, rightclick, ...)
    end
    
    local unselectable_tags = getval(self.CherryPick, "unselectable_tags")

    local CherryPick = self.CherryPick
    self.CherryPick = function(self, rightclick, ...)
        local current_time = GetTime()
        if current_time - self.last_click.time < self.double_click_speed and self.last_click.prefab then
            local x, y, z = self.last_click.pos:Get()
            for _, ent in pairs(TheSim:FindEntities(x, 0, z, self.double_click_range, nil, unselectable_tags)) do
                if IsRightItem(ent.prefab, self.last_click.prefab) and IsValidEntity(ent) and not self:IsSelectedEntity(ent) then -- Changed Part
                    local act, rightclick_ = self:GetAction(ent, rightclick)
                    if act and act.action == self.last_click.action then
                        self:SelectEntity(ent, rightclick_)
                    end
                end
            end
            self.last_click.prefab = nil
            return
        end
        return CherryPick(self, rightclick, ...)
    end

    self.GetItem = function(self, prefab, test_fn)
        local containers = {}
        local inventory = self.inst.replica.inventory
        table.insert(containers, inventory)
        local backpack = inventory:GetOverflowContainer()
        if backpack then
            table.insert(containers, backpack)
        end
        if allow_all_open_containers then
            local open_containers = inventory:GetOpenContainers()
            if open_containers then
                for container in pairs(open_containers) do
                    local container_replica = container.replica.container
                    if container_replica and container_replica ~= backpack then
                        table.insert(containers, container_replica)
                    end
                end
            end
        end
        -- Make its order like: inventory -> backpack -> other opened containers
        for _, inv in pairs(containers) do
            for slot, item in orderedPairs(inv:GetItems()) do
                if IsRightItem(item.prefab, prefab) and (test_fn == nil or test_fn(item, inv, slot)) then
                    inv:GetItems().__orderedIndex = nil
                    return item, inv, slot
                end
            end
        end
    end

    self.GetNewActiveItem = function(self, prefab, test_fn, ...) -- Override
        local item, inv, slot = self:GetItem(prefab, test_fn)
        if item ~= nil then
            inv:TakeActiveItemFromAllOfSlot(slot)
        end
        return item
    end

    self.GetNewEquippedItemInHand = function(self, prefab, test_fn, ...) -- Override
        local item = self:GetItem(prefab, test_fn)
        if item ~= nil then
            self.inst.replica.inventory:UseItemFromInvTile(item)
        end
        return item
    end

    local SendAction = self.SendAction
    self.SendAction = function(self, act, rightclick, target, ...)
        if act.action == ACTIONS.DEPLOY and act.invobject and act.invobject:HasTag("tile_deploy") then
            act.action = ACTIONS.DEPLOY_TILEARRIVE
        end
        return SendAction(self, act, rightclick, target, ...)
    end

end)
