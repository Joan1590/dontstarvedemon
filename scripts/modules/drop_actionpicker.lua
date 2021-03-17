AddComponentPostInit("playeractionpicker", function(self, inst)
    local GetInventoryActions = self.GetInventoryActions
    self.GetInventoryActions = function(self, useitem, right)
        local IsControlPressed = self.inst.components.playercontroller.IsControlPressed
        self.inst.components.playercontroller.IsControlPressed = function(self, control)
            if control == GLOBAL.CONTROL_FORCE_TRADE then
                return false
            else
                return IsControlPressed(self, control)
            end
        end
        local actions = GetInventoryActions(self, useitem, right)
        self.inst.components.playercontroller.IsControlPressed = IsControlPressed
        return actions
    end
end)