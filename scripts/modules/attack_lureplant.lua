local actionkey = GetModConfigData("attack_lureplant")

local _G = GLOBAL
local FindEntity = _G.FindEntity
local SendRPCToServer = _G.SendRPCToServer
local Sleep = _G.Sleep
local TheInput = _G.TheInput
local RPC = _G.RPC
local ACTIONS = _G.ACTIONS
local ThePlayer


local attackthread

local function InGame()
    return ThePlayer and ThePlayer.HUD and not ThePlayer.HUD:HasInputFocus()
end

local function StopAttacking()
    if attackthread then
        attackthread:SetList(nil)
    end
    attackthread = nil
    SendRPCToServer(RPC.StopControl, _G.CONTROL_ATTACK)
end

local function fn()

    attackthread = ThePlayer:StartThread(function()
        
        local lureplant = FindEntity(ThePlayer, 20, function(inst) 
            return inst.prefab == "lureplant" 
            and inst:IsValid() 
            and (inst.replica.combat ~= nil and
            inst.replica.health ~= nil and
            not inst.replica.health:IsDead())
        end, {"_combat"}, {"INLIMBO"})

        if not lureplant then StopAttacking() return end
        local pos = ThePlayer:GetPosition()
        repeat
            SendRPCToServer(RPC.LeftClick,ACTIONS.ATTACK.code,pos.x,pos.z,lureplant,false,10,true)
            Sleep(0.1)
        until (ThePlayer.sg and ThePlayer.sg:HasStateTag("moving")) or ThePlayer:HasTag("moving")
        or not ThePlayer:HasTag("idle") or ThePlayer.components.playercontroller:IsDoingOrWorking()
        StopAttacking()
    end)

end

local interrupt_controls = {}
for control = _G.CONTROL_ATTACK, _G.CONTROL_MOVE_RIGHT do
    interrupt_controls[control] = true
end

AddComponentPostInit("playercontroller", function(self, inst)
    if inst ~= _G.ThePlayer then return end
    ThePlayer = _G.ThePlayer
    local mouse_controls = {[_G.CONTROL_PRIMARY] = true, [_G.CONTROL_SECONDARY] = true}

    local PlayerControllerOnControl = self.OnControl
    self.OnControl = function(self, control, down)
        local mouse_control = mouse_controls[control]
        local interrupt_control = interrupt_controls[control]
        if interrupt_control or mouse_control and not TheInput:GetHUDEntityUnderMouse() then
            if down and attackthread and InGame() then
                StopAttacking()
            end
        end
        PlayerControllerOnControl(self, control, down)
    end
end)

actionkey = _G[actionkey]
TheInput:AddKeyUpHandler(actionkey,function()
    if not InGame() then return end
    fn()
end)