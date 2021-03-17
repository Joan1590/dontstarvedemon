local upvalueutil = require("upvalueutil")
local getval = upvalueutil.GetUpvalue
local setval = upvalueutil.SetUpvalue

AddComponentPostInit("playercontroller", function(self, inst)
    if inst ~= GLOBAL.ThePlayer then return end

    local GetPickupAction = getval(self.GetActionButtonAction, "GetPickupAction")
    setval(self.GetActionButtonAction, "GetPickupAction", function(self, target, tool)
        if target.prefab == "winch" then
            local _HasTag = target.HasTag
            target.HasTag = function(self, tag)
                if tag == "inactive" then return false end
                return _HasTag(self, tag)
            end
            local result = GetPickupAction(self, target, tool)
            target.HasTag = _HasTag
            return result
        else
            return GetPickupAction(self, target, tool)
        end
    end)
end)