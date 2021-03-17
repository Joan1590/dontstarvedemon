local _G = GLOBAL

local zoom_step = GetModConfigData("quick_zoom")

local TheInput = _G.TheInput
AddComponentPostInit("playercontroller", function(self, inst)
    local Old_DoCameraControl = self.DoCameraControl
    self.DoCameraControl = function(self)
        Old_DoCameraControl(self)
        if not _G.TheCamera:CanControl()
            or (self.inst.HUD ~= nil and
                self.inst.HUD:IsCraftingOpen()) then
            return
        end
        
        if TheInput:IsKeyDown(_G.KEY_LSHIFT) then
            if TheInput:IsControlPressed(_G.CONTROL_ZOOM_IN) then
                _G.TheCamera:ZoomIn(zoom_step)
            elseif TheInput:IsControlPressed(_G.CONTROL_ZOOM_OUT) then
                _G.TheCamera:ZoomOut(zoom_step)
            end
        end
    end
end)