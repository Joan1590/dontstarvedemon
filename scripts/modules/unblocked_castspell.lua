local _G = GLOBAL
local TheInput = _G.TheInput
local SendRPCToServer = _G.SendRPCToServer
local RPC = _G.RPC
local ACTIONS = _G.ACTIONS
local EQUIPSLOTS = _G.EQUIPSLOTS
local CONTROL_SECONDARY = _G.CONTROL_SECONDARY
local KEY_LCTRL = _G.KEY_LCTRL

local action_list = {}
action_list[ACTIONS.CASTSPELL] = true

AddComponentPostInit("playercontroller", function(self, inst)
    if inst ~= _G.ThePlayer then return end

    local GetRightMouseAction = self.GetRightMouseAction
    self.GetRightMouseAction = function(self)
        local act = GetRightMouseAction(self)
        if not (TheInput:GetHUDEntityUnderMouse() or self:IsAOETargeting() or self.placer_recipe)
            and (act == nil or act.action == ACTIONS.LOOKAT) then

            local _act
            local pos = TheInput:GetWorldPosition()
            local useitem = self.inst.replica.inventory:GetActiveItem()
            local equipitem = self.inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
            if useitem and useitem:IsValid() then
                _act = self.inst.components.playeractionpicker:GetPointActions(pos, useitem, true)[1] or act
            elseif equipitem and equipitem:IsValid() then
                _act = self.inst.components.playeractionpicker:GetPointActions(pos, equipitem, true)[1] or act
            end
            -- if (_act == nil or _act == act) and TheInput:IsKeyDown(KEY_LCTRL) then
            --     _act = self.inst.components.playeractionpicker:GetPointSpecialActions(pos, useitem, true)[1] or act
            -- end

            if _act and action_list[_act.action] then
                act = _act
            end
        end
        self.RMBaction = act
        return self.RMBaction
    end

    local OnRightClick = self.OnRightClick
    self.OnRightClick = function(self, down)
        if not down or TheInput:GetHUDEntityUnderMouse() or self:IsAOETargeting() or self.placer_recipe then
            return OnRightClick(self, down)
        end
        local act = self:GetRightMouseAction()
        if act and action_list[act.action] and not act.target then
            local star = nil
            if not TheInput:IsKeyDown(KEY_LCTRL) then
                local ents = TheInput:GetAllEntitiesUnderMouse()
                for _, ent in ipairs(ents) do
                    -- if ent.prefab == "stafflight" or ent.prefab == "staffcoldlight" then
                        star = ent
                        break
                    -- end
                end
            end
            local pos = star and star:GetPosition() or TheInput:GetWorldPosition()
            act.pos = _G.DynamicPosition(pos)
            local platform, pos_x, pos_z = self:GetPlatformRelativePosition(pos.x, pos.z)
            if not self.ismastersim then
                if self.locomotor == nil then
                    self.remote_controls[CONTROL_SECONDARY] = 0
                    SendRPCToServer(RPC.RightClick, act.action.code, pos_x, pos_z, nil, nil, nil, nil, nil, nil, platform, platform ~= nil)
                elseif self:CanLocomote() then
                    act.preview_cb = function()
                        self.remote_controls[CONTROL_SECONDARY] = 0
                        SendRPCToServer(RPC.RightClick, act.action.code, pos_x, pos_z, nil, nil, nil, nil, nil, nil, platform, platform ~= nil)
                    end
                end
            end
            self:DoAction(act)
            return
        end
        OnRightClick(self, down)
    end
end)