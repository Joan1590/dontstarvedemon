local _G = GLOBAL
local GetTime = _G.GetTime
local Sleep = _G.Sleep
local BufferedAction = _G.BufferedAction
local RPC = _G.RPC
local ACTIONS = _G.ACTIONS
local SendRPCToServer = _G.SendRPCToServer
local TheInput = _G.TheInput
local orderedPairs = _G.orderedPairs
local CONTROL_FORCE_STACK = _G.CONTROL_FORCE_STACK
local CONTROL_FORCE_TRADE = _G.CONTROL_FORCE_TRADE
local CONTROL_ACCEPT = _G.CONTROL_ACCEPT
local CONTROL_SECONDARY = _G.CONTROL_SECONDARY
local CONTROL_PRIMARY = _G.CONTROL_PRIMARY
local ThePlayer

local double_click_speed = GetModConfigData("double_click_speed")
local drop_options_cfg = GetModConfigData("repeat_drop")
local drop_on_grid = drop_options_cfg == "drop_on_grid"
local drop_on_grid_leftclick = drop_options_cfg == "drop_on_grid_leftclick"

local workingthread

local morph_checker = _G.kleiloadlua(MODROOT.."scripts/morph_checker.lua") -- Basically modimport, but we need the return value
_G.setfenv(morph_checker, env)
morph_checker = morph_checker()
local IsRightItem = morph_checker.IsRightItem

local function InGame()
    return ThePlayer and ThePlayer.HUD and not ThePlayer.HUD:HasInputFocus()
end

local function StopThread()
    if workingthread then
        workingthread:SetList(nil)
    end
    workingthread = nil
end

local function DropActiveItemOnGrid(pos, active_item, single_item)
    local playercontroller = ThePlayer.components.playercontroller

    pos.x, pos.z = math.floor(pos.x) + 0.5, math.floor(pos.z) + 0.5

    local act = BufferedAction(ThePlayer, nil, ACTIONS.DROP, active_item, pos)
    if single_item ~= nil then
        act.options.wholestack = not single_item
    else
        act.options.wholestack = not TheInput:IsControlPressed(CONTROL_FORCE_STACK)
    end
    local control_mod = act.options.wholestack and 0 or 10

    if playercontroller.locomotor then
        --act.options.wholestack = not TheInput:IsControlPressed(CONTROL_FORCE_STACK)
        act.preview_cb = function()
            SendRPCToServer(RPC.LeftClick, ACTIONS.DROP.code, pos.x, pos.z, nil, true, control_mod, nil, act.action.mod_name)
        end
        playercontroller:DoAction(act)
    else
        SendRPCToServer(RPC.LeftClick, ACTIONS.DROP.code, pos.x, pos.z, nil, true, control_mod, act.action.canforce, act.action.mod_name)
    end
end

local function DropItemFromSlot(slot, item, single_item)
    local inventory = ThePlayer.replica.inventory
    local inventoryitem = item.replica.inventoryitem
    if drop_on_grid
        and not inventory:GetActiveItem()
        and inventoryitem:CanGoInContainer() and not inventoryitem:CanOnlyGoInPocket() then

        if slot.equipslot then
            inventory:TakeActiveItemFromEquipSlot(slot.equipslot)
        elseif slot.num then
            slot.container:TakeActiveItemFromAllOfSlot(slot.num)
        end
        DropActiveItemOnGrid(ThePlayer:GetPosition(), item, single_item)
    else
        inventory:DropItemFromInvTile(item, single_item)
        return true
    end
end

local function fn(item, slot, container, single_item, no_grid_drop)

    if not item or workingthread then return end

    workingthread = ThePlayer:StartThread(function()
        
        local drop_on_grid = drop_on_grid
        if no_grid_drop then
            drop_on_grid = false
        end

        local function GetItem()

            local inventory = ThePlayer.replica.inventory
            local check_list = {container}

            local function check()
                for _, container in ipairs(check_list) do
                    for i, v in orderedPairs(container:GetItems()) do
                        if IsRightItem(v, item) then
                            container:GetItems().__orderedIndex = nil
                            return v, i, container
                        end
                    end
                end
            end

            if container.inst == ThePlayer then
                table.insert(check_list, inventory:GetOverflowContainer())
            elseif container.inst:HasTag("backpack") then
                table.insert(check_list, inventory)
            end
            return check()
            
        end

        local function GetSlotOfItem(container, item)
            if type(slot) == "string" then
                for _eslot, _item in pairs(container:GetEquips()) do
                    if item == _item then
                        return _eslot
                    end
                end
            end
            for _slot, _item in pairs(container:GetItems()) do
                if item == _item then
                    return _slot
                end
            end
        end

        while ThePlayer:IsValid() do
            local _item, slot, item_container = nil, nil, nil
            if container:IsHolding(item) then
                _item = item
                slot = GetSlotOfItem(container, item)
                item_container = container
            else
                _item, slot, item_container = GetItem()
            end
            local inventory = ThePlayer.replica.inventory
            local inventoryitem = item.replica.inventoryitem
            local active_item = inventory:GetActiveItem()
            if _item then
                --ThePlayer.replica.inventory:DropItemFromInvTile(_item, single_item)
                if drop_on_grid and not active_item
                    and inventoryitem:CanGoInContainer()
                    and not inventoryitem:CanOnlyGoInPocket() then

                    if type(slot) == "string" then
                        item_container:TakeActiveItemFromEquipSlot(slot)
                    else
                        item_container:TakeActiveItemFromAllOfSlot(slot)
                    end
                elseif drop_on_grid then
                    local pos = ThePlayer:GetPosition()
                    DropActiveItemOnGrid(pos, active_item, single_item)
                else
                    ThePlayer.replica.inventory:DropItemFromInvTile(_item, single_item)
                end
            elseif active_item and IsRightItem(active_item, item) then
                local pos = ThePlayer:GetPosition()
                if drop_on_grid then
                    DropActiveItemOnGrid(pos, active_item, single_item)
                else
                    local playercontroller = ThePlayer.components.playercontroller
                    if playercontroller.ismastersim then
                        ThePlayer.components.combat:SetTarget(nil)
                        local act = BufferedAction(ThePlayer, nil, ACTIONS.DROP, active_item, pos)
                        act.options.wholestack = not single_item
                        playercontroller:DoAction(act)
                    else
                        SendRPCToServer(RPC.LeftClick, ACTIONS.DROP.code, pos.x, pos.z, nil, true, single_item and 10 or nil)
                    end
                end
            else
                break
            end
            Sleep(_G.FRAMES * 2)
        end
        StopThread()

    end)

end

local interrupt_controls = {}
for control = _G.CONTROL_ATTACK, _G.CONTROL_MOVE_RIGHT do
    interrupt_controls[control] = true
end

AddComponentPostInit("playercontroller", function(self, inst)
    if inst ~= _G.ThePlayer then return end
    ThePlayer = _G.ThePlayer

    ThePlayer:ListenForEvent("aqp_threadstart", function(inst) StopThread() end)

    local mouse_controls = {[_G.CONTROL_PRIMARY] = true, [_G.CONTROL_SECONDARY] = true}

    local PlayerControllerOnControl = self.OnControl
    self.OnControl = function(self, control, down)
        local mouse_control = mouse_controls[control]
        local interrupt_control = interrupt_controls[control]
        if interrupt_control or mouse_control and not TheInput:GetHUDEntityUnderMouse() then
            if down and workingthread and InGame() then
                StopThread()
            end
        end
        PlayerControllerOnControl(self, control, down)
    end

    if not (drop_on_grid or drop_on_grid_leftclick) then return end
    ThePlayer:DoTaskInTime(0,function() --Because I need to over write Advanced Controls's this part
        local PlayerControllerOnLeftClick = self.OnLeftClick
        self.OnLeftClick = function(self, down)
            if not down or TheInput:GetHUDEntityUnderMouse() or self:IsAOETargeting() or self.placer_recipe then
                return PlayerControllerOnLeftClick(self, down)
            end
            local act = self:GetLeftMouseAction()
            if act then
                if act.action == ACTIONS.DROP then
                    local active_item = ThePlayer.replica.inventory and ThePlayer.replica.inventory:GetActiveItem()
                    if active_item then
                        DropActiveItemOnGrid(TheInput:GetWorldPosition(), active_item)
                        return
                    end
                end
            end
            PlayerControllerOnLeftClick(self, down)
        end
    end)
end)

local last_rightclick_time = 0
local last_rightclick_inv
local last_rightclick_item
local last_time_no_grid_drop
local function InvSlotPostInit(self)
    local InvSlotOnControl = self.OnControl
    self.OnControl = function(self, control, down)
        if down and TheInput:IsControlPressed(CONTROL_FORCE_TRADE) and control == CONTROL_SECONDARY then
            local current_time = GetTime()
            local single_item = TheInput:IsControlPressed(CONTROL_FORCE_STACK)
            --ThePlayer.replica.inventory:DropItemFromInvTile(self.tile.item, single_item)

            if current_time - last_rightclick_time < double_click_speed and last_rightclick_inv == self and last_rightclick_item then
                --DropItemFromSlot(self, last_rightclick_item, single_item)
                fn(last_rightclick_item, self.num or self.equipslot, self.container or self.equipslot and ThePlayer.replica.inventory, single_item, last_time_no_grid_drop)
            end
            last_rightclick_time = current_time
            last_rightclick_inv = self
            last_rightclick_item = self.tile and self.tile.item

            if self.tile then
                last_time_no_grid_drop = DropItemFromSlot(self, self.tile.item, single_item)
            end
            return true
        end
        return InvSlotOnControl(self, control, down)
    end
end
AddClassPostConstruct("widgets/invslot", InvSlotPostInit)
AddClassPostConstruct("widgets/equipslot", InvSlotPostInit)
