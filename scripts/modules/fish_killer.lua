local toggle_key = GetModConfigData("fish_killer")

local _G = GLOBAL
local SendRPCToServer = _G.SendRPCToServer
local RPC = _G.RPC
local FRAMES = _G.FRAMES
local ACTIONS = _G.ACTIONS
local BufferedAction = _G.BufferedAction
local Sleep = _G.Sleep
local TheInput = _G.TheInput
local ThePlayer

local killingthread

local fish_list = {"pondfish", "pondeel"}

local function InGame()
    return ThePlayer and ThePlayer.HUD and not ThePlayer.HUD:HasInputFocus()
end

local function UseItemSelf(item)
    if not item then return end
    local inventory = ThePlayer.components.inventory
    local playercontroller = ThePlayer.components.playercontroller
    local murder_actioncode = ACTIONS.MURDER.code
    if inventory then
        local playercontroller_deploy_mode = playercontroller.deploy_mode
        playercontroller:ClearControlMods()
        playercontroller.deploy_mode = false
        inventory:ControllerUseItemOnSelfFromInvTile(item, murder_actioncode)
        playercontroller.deploy_mode = playercontroller_deploy_mode
    else
        SendRPCToServer(RPC.ControllerUseItemOnSelfFromInvTile, murder_actioncode, item)
    end
end

local function GetItem(item)
    if not ThePlayer and ThePlayer.replica.inventory then return false end
    for container,v in pairs(ThePlayer.replica.inventory:GetOpenContainers()) do
        if container and container.replica and container.replica.container
        --and container:HasTag("backpack")
        then
            local items_container = container.replica.container:GetItems()
            for k,v in pairs(items_container) do
                if v.prefab == item then
                    return v, k, container.replica.container
                end
            end
        end
    end
    for k,v in pairs(ThePlayer.replica.inventory:GetItems()) do
        if v.prefab == item then
            return v, k, ThePlayer.replica.inventory
        end
    end
    return false
end

local function StopKilling()
    if killingthread then
        killingthread:SetList(nil)
    end
    killingthread = nil
end

local function fn()
    
    if not InGame() then return end
    if killingthread then StopKilling() return end
    if ThePlayer:HasTag("playerghost") then return end
    --if ThePlayer.replica.inventory:GetActiveItem() then return end

    local function GetFish()
        for i, v in ipairs(fish_list) do
            if GetItem(v) then
                return GetItem(v)
            end
        end
    end

    --local item = GetFish()
    --if not item then return end

    killingthread = ThePlayer:StartThread(function()

        while ThePlayer:IsValid() do

            local active_item = ThePlayer.replica.inventory:GetActiveItem()

            if active_item then
                if table.contains(fish_list, active_item.prefab) then
                    --ThePlayer.replica.inventory:ControllerUseItemOnSceneFromInvTile(active_item)
                    local act = BufferedAction(ThePlayer, ThePlayer, ACTIONS.MURDER, active_item)
                    if ThePlayer.components.playercontroller and ThePlayer.components.playercontroller.ismastersim then
                        ThePlayer.components.playercontroller:DoAction(act)
                    else
                        local pos = ThePlayer:GetPosition()
                        SendRPCToServer(RPC.LeftClick, act.action.code, pos.x, pos.z, ThePlayer, true)
                    end
                elseif active_item:HasTag("fishmeat") then
                    local item, slot, container = GetFish()
                    if not item then StopKilling() return end
                    container:SwapActiveItemWithSlot(slot)
                else
                    StopKilling()
                    return
                end
            else
                local item = GetFish()
                if not item then StopKilling() return end
                --ThePlayer.replica.inventory:ControllerUseItemOnSelfFromInvTile(item)
                -- ThePlayer.replica.inventory:UseItemFromInvTile(item)
                UseItemSelf(item)
            end
            Sleep(FRAMES * 2)

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
    
    ThePlayer:ListenForEvent("aqp_threadstart", function(inst) StopKilling() end)

    local mouse_controls = {[_G.CONTROL_PRIMARY] = true, [_G.CONTROL_SECONDARY] = true}

    local PlayerControllerOnControl = self.OnControl
    self.OnControl = function(self, control, down)
        local mouse_control = mouse_controls[control]
        local interrupt_control = interrupt_controls[control]
        if InGame() and (interrupt_control or mouse_control and not TheInput:GetHUDEntityUnderMouse()) then
            if down and killingthread then
                StopKilling()
            end
        end
        PlayerControllerOnControl(self, control, down)
    end
end)

toggle_key = _G[toggle_key]
_G.TheInput:AddKeyUpHandler(toggle_key,fn)