local toggle_key = GetModConfigData("honey_collector")

local _G = GLOBAL
local SendRPCToServer = _G.SendRPCToServer
local RPC = _G.RPC
local ACTIONS = _G.ACTIONS
local BufferedAction = _G.BufferedAction
local TUNING = _G.TUNING
local Sleep = _G.Sleep
local TheInput = _G.TheInput
local TheSim = _G.TheSim
local FindEntity = _G.FindEntity

local FRAMES = _G.FRAMES

local collectorthread

local function InGame()
    return ThePlayer and ThePlayer.HUD and not ThePlayer.HUD:HasInputFocus()
end

local function GetItem(tag)
    if not ThePlayer and ThePlayer.replica.inventory then return false end
    for slot, item in pairs(ThePlayer.replica.inventory:GetItems()) do
        if item:HasTag(tag) then
            return item, slot, ThePlayer.replica.inventory
        end
    end
    for container in pairs(ThePlayer.replica.inventory:GetOpenContainers()) do
        if container and container.replica and container.replica.container
        --and container:HasTag("backpack")
        then
            local items_container = container.replica.container:GetItems()
            for slot, item in pairs(items_container) do
                if item:HasTag(tag) then
                    return item, slot, container.replica.container
                end
            end
        end
    end
    return false
end

local function SendAction(act)
    local target = act.target
    local action_code = act.action.code
    local x, y, z = ThePlayer:GetPosition():Get()

    local playercontroller = ThePlayer.components.playercontroller
    if playercontroller.ismastersim then
        local inventory = ThePlayer.components.inventory
        if inventory and act.action == ACTIONS.LIGHT then
            playercontroller:ClearControlMods()
            inventory:ControllerUseItemOnSceneFromInvTile(act.invobject, target, action_code)
        else
            ThePlayer.components.combat:SetTarget(nil)
            playercontroller:DoAction(act)
        end
        return
    end

    if act.action == ACTIONS.LIGHT then
        SendRPCToServer(RPC.ControllerUseItemOnSceneFromInvTile, action_code, act.invobject, target)
    elseif act.action == ACTIONS.HARVEST then
        if ThePlayer.replica.inventory and ThePlayer.replica.inventory:GetActiveItem() then
            SendRPCToServer(RPC.ActionButton, action_code, target, true) --If you're too far away (dist > 6) from target, it still can't handle that
        else
            SendRPCToServer(RPC.LeftClick, action_code, x, z, target, true)
        end
    end
end

local function Wait(time)
    repeat
        Sleep(time or FRAMES * 3)
    until not (ThePlayer.sg and ThePlayer.sg:HasStateTag("moving")) and not ThePlayer:HasTag("moving")
end

local function SendActionAndWait(act, time)
    SendAction(act)
    Wait(time)
end

local function StopThread()
    if collectorthread then
        collectorthread:SetList(nil)
    end
    collectorthread = nil
end

local function FindNearestTarget(entities) -- From Action Queue Reborn
    local mindistsq, target
    for _, ent in pairs(entities) do
        local curdistsq = ThePlayer:GetDistanceSqToInst(ent)
        if not mindistsq or curdistsq < mindistsq then
            mindistsq = curdistsq
            target = ent
        end
    end
    return target
end

local function FindBestBeebox(beeboxes)
    local available_beeboxes = {}
    for _, beebox in ipairs(beeboxes) do
        if FindEntity(beebox, TUNING.FIRE_DETECTOR_RANGE, function(inst) return inst.prefab == "firesuppressor" end, {"turnedon"}, {"INLIMBO"}) then
            table.insert(available_beeboxes, beebox)
        end
    end
    local more_honey_beebox_anim = {"honey3", "hit_honey3", "honey2", "hit_honey2"}
    local more_honey_beeboxes = {}
    for _, beebox in ipairs(available_beeboxes) do
        for _, anim in ipairs(more_honey_beebox_anim) do
            if beebox.AnimState:IsCurrentAnimation(anim) then
                table.insert(more_honey_beeboxes, beebox)
            end
        end
    end
    return FindNearestTarget(more_honey_beeboxes) or FindNearestTarget(available_beeboxes)
end

local function fn()

    local TheWorld = _G.TheWorld
    local worldstate = TheWorld and TheWorld.components.worldstate
    local iswinter = worldstate and worldstate.data.iswinter

    if not InGame() or ThePlayer:HasTag("playerghost") then return end
    if collectorthread then StopThread() return end

    collectorthread = ThePlayer:StartThread(function()

        while ThePlayer:IsValid() do
            local target
            if iswinter then
                target = FindEntity(ThePlayer, 30, nil, {"harvestable", "beebox"}, {"INLIMBO", "burnt"})
                if not target then return end
            else
                local lighter = GetItem("lighter")
                if not lighter then StopThread() return end
                local armor = ThePlayer.replica.inventory and ThePlayer.replica.inventory:GetEquippedItem(_G.EQUIPSLOTS.BODY)
                if ThePlayer.prefab ~= "willow" and not (armor and armor.prefab == "armordragonfly") then return end

                local x, y, z = ThePlayer:GetPosition():Get()
                local available_beeboxes = TheSim:FindEntities(x, y, z, 30, {"harvestable", "beebox"}, {"INLIMBO", "burnt"})
                target = FindBestBeebox(available_beeboxes)
                if not target then return end

                local act = BufferedAction(ThePlayer, target, ACTIONS.LIGHT, lighter)
                while target:IsValid() and target:HasTag("canlight") do
                    SendActionAndWait(act)
                end
            end

            local act = BufferedAction(ThePlayer, target, ACTIONS.HARVEST)
            SendActionAndWait(act)
            while target:IsValid() and target:HasTag("harvestable") do
                SendActionAndWait(act)
            end

            --Sleep(FRAMES * 3)
        end
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
        if collectorthread and down
        and InGame() and (interrupt_control or mouse_control and not TheInput:GetHUDEntityUnderMouse()) then
            StopThread()
        end
        PlayerControllerOnControl(self, control, down)
    end
end)

toggle_key = _G[toggle_key]
_G.TheInput:AddKeyUpHandler(toggle_key,fn)