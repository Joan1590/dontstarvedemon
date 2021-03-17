local _G = GLOBAL
local SendRPCToServer = _G.SendRPCToServer
local RPC = _G.RPC
local ACTIONS = _G.ACTIONS
local BufferedAction = _G.BufferedAction
local FindEntity = _G.FindEntity

local ThePlayer

local function InGame()
    return ThePlayer and ThePlayer.HUD and not ThePlayer.HUD:HasInputFocus()
end

AddComponentPostInit("playercontroller", function(self, inst)
    if inst ~= _G.ThePlayer then return end
    ThePlayer = _G.ThePlayer
end)

local function SendAction(act)
    local playercontroller = ThePlayer.components.playercontroller
    if not playercontroller then return end
    local pos = ThePlayer:GetPosition()
    local function cb()
        SendRPCToServer(RPC.LeftClick, act.action.code, pos.x, pos.z, act.target, true)
    end
    if playercontroller:CanLocomote() then
        act.preview_cb = cb
        playercontroller:DoAction(act)
    else
        cb()
    end
end

local function SteerBoat()
    if not InGame() then return end
    local target = FindEntity(ThePlayer, 5, nil, {"steeringwheel"}, {"INLIMBO", "burnt", "occupied", "fire"})
    if target then
        if ThePlayer:HasTag("steeringboat") then
            SendAction(BufferedAction(ThePlayer, nil, ACTIONS.STOP_STEERING_BOAT))
        else
            SendAction(BufferedAction(ThePlayer, target, ACTIONS.STEER_BOAT))
        end
    end
end

local function UseAnchor()
    if not InGame() then return end
    local target = FindEntity(ThePlayer, 5, nil, nil, {"INLIMBO", "burnt"}, {"anchor_raised", "anchor_lowered"})
    if target then
        local action
        if not target:HasTag("anchor_raised") or target:HasTag("anchor_transitioning") then
            action = ACTIONS.RAISE_ANCHOR
        elseif target:HasTag("anchor_raised") then
            action = ACTIONS.LOWER_ANCHOR
        end
        if action then
            if ThePlayer:HasTag("steeringboat") then
                SendAction(BufferedAction(ThePlayer, nil, ACTIONS.STOP_STEERING_BOAT))
                ThePlayer:DoTaskInTime(0, function() SendAction(BufferedAction(ThePlayer, target, action)) end)
            else
                SendAction(BufferedAction(ThePlayer, target, action))
            end
        end
    end
end

_G.TheInput:AddKeyUpHandler(GetModConfigData("easy_steering_boat") and _G[GetModConfigData("easy_steering_boat")] or -1, SteerBoat)
_G.TheInput:AddKeyUpHandler(GetModConfigData("easy_anchor_using") and _G[GetModConfigData("easy_anchor_using")] or -1, UseAnchor)