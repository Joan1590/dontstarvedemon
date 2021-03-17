local _G = GLOBAL

local force_open_caveclock = GetModConfigData("cave_clock") == "default_on" and true or false
-- local clock_focus = false
-- AddClassPostConstruct("screens/playerhud", function(self)
--     local Old_OnMouseButton = self.OnMouseButton
--     self.OnMouseButton = function(self, button, down, ...)
--         if down and button == _G.MOUSEBUTTON_LEFT then
--             if clock_focus and self.controls.clock and self.controls.clock:IsCaveClock() then
--                 local ThePlayer = _G.ThePlayer
--                 if ThePlayer then
--                     force_open_caveclock = not force_open_caveclock
--                     ThePlayer.components.talker:Say("Cave Clock : "..(force_open_caveclock and "Force On" or "Normal"))
--                 end
--             end
--         end
--         Old_OnMouseButton(self, button, down, ...)
--     end
-- end)

AddClassPostConstruct("widgets/uiclock", function(self)
    local Old_UpdateCaveClock = self.UpdateCaveClock
    self.UpdateCaveClock = function(self, owner)
        if force_open_caveclock then
            --print("force_opening_caveclock")
            self:OpenCaveClock()
        else
            Old_UpdateCaveClock(self, owner)
        end
    end

    -- local Old_OnGainFocus = self.OnGainFocus
    -- self.OnGainFocus = function(self)
    --     clock_focus = true
    --     return Old_OnGainFocus(self)
    -- end
    -- local Old_OnLoseFocus = self.OnLoseFocus
    -- self.OnLoseFocus = function(self)
    --     clock_focus = false
    --     return Old_OnLoseFocus(self)
    -- end

    local Old_OnControl = self.OnControl
    self.OnControl = function(self, control, down)
        -- print("down ->", down, "control ->", control, "self.focus ->", self.focus, "self:IsCaveClock ->", self:IsCaveClock())
        if down and control == _G.CONTROL_ACCEPT and self.focus and self:IsCaveClock() then
            local ThePlayer = _G.ThePlayer
            if ThePlayer then
                force_open_caveclock = not force_open_caveclock
                ThePlayer.components.talker:Say("Cave Clock : "..(force_open_caveclock and "Force On" or "Normal"))
            end
        end
        return Old_OnControl(self, control, down)
    end
end)