local toggle_key = GetModConfigData("repeat_compare_fishes")

local _G = GLOBAL
local SendRPCToServer = _G.SendRPCToServer
local RPC = _G.RPC
local ACTIONS = _G.ACTIONS
local BufferedAction = _G.BufferedAction
local FindEntity = _G.FindEntity
local Sleep = _G.Sleep
local FRAMES = _G.FRAMES
local TheInput = _G.TheInput

local comparingthread
local done_list = {}

local function InGame()
    return ThePlayer and ThePlayer.HUD and not ThePlayer.HUD:HasInputFocus()
end

local function Say(str)
    local talker = ThePlayer.components.talker
    if talker then
        talker:Say(str)
    end
end

local function SendAction(target, item)
    local playercontroller = ThePlayer.components.playercontroller
    local act = BufferedAction(ThePlayer, target, ACTIONS.COMPARE_WEIGHABLE, item)
    --local action_code = ACTIONS.COMPARE_WEIGHABLE.code
    if not (playercontroller and item) then return end

    local pos = ThePlayer:GetPosition()
    if playercontroller.ismastersim then
        playercontroller:ClearControlMods()
        ThePlayer.components.inventory:ControllerUseItemOnSceneFromInvTile(item, target, action_code)
    else
        playercontroller:RemoteControllerUseItemOnSceneFromInvTile(act, item)
        --SendRPCToServer(RPC.ControllerUseItemOnSceneFromInvTile, action_code, item, target)
    end
end

local function GetItem(tag)

    local function check(items)
        for _, v in pairs(items) do
            if v:HasTag(tag) and not done_list[v] then
                return v
            end
        end
    end

    local active_item = ThePlayer.replica.inventory:GetActiveItem()
    local final = active_item and check({active_item}) or check(ThePlayer.replica.inventory:GetItems())
    if not final then
        for container,v in pairs(ThePlayer.replica.inventory:GetOpenContainers()) do
            if container and container.replica and container.replica.container then
                final = check(container.replica.container:GetItems())
                if final then break end
            end
        end
    end
    return final or false

end

local function StopThread()
    if comparingthread then
        comparingthread:SetList(nil)
    end
    comparingthread = nil
    done_list = {}
end

local function fn()
    
    if not InGame() then return end
    if comparingthread then StopThread() return end
    if ThePlayer:HasTag("playerghost") then return end

    comparingthread = ThePlayer:StartThread(function()

        while ThePlayer:IsValid() do

            local trophyscale = FindEntity(ThePlayer, 30, function(inst)
                return inst.prefab == "trophyscale_fish"
            end, {"structure"}, {"INLIMBO", "burnt"})
            if not trophyscale then StopThread() return end

            local inv = ThePlayer.replica.inventory
            if not inv then StopThread() return end

            local item = GetItem("weighable_fish")
            if not item then Say("done") StopThread() return end

            SendAction(trophyscale, item)
            repeat
                Sleep(3 * FRAMES)
                if ThePlayer:HasTag("giving") then done_list[item] = true end
            until not (ThePlayer.sg and ThePlayer.sg:HasStateTag("moving")) and not ThePlayer:HasTag("moving")
                and ThePlayer:HasTag("idle") and not ThePlayer.components.playercontroller:IsDoingOrWorking()
                and (not GetItem("weighable_fish") or (trophyscale:IsValid() and trophyscale.AnimState:IsCurrentAnimation("fish_idle"))) --Wait until it can accept item again
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
        if InGame() and (interrupt_control or mouse_control and not TheInput:GetHUDEntityUnderMouse()) then
            if down and comparingthread then
                StopThread()
            end
        end
        PlayerControllerOnControl(self, control, down)
    end
end)

toggle_key = _G[toggle_key]
_G.TheInput:AddKeyUpHandler(toggle_key,fn)