local _G = GLOBAL
local EntityScript = _G.EntityScript
local ACTIONS = _G.ACTIONS
local debug = _G.debug

local upvalueutil = require("upvalueutil")
local getval = upvalueutil.GetUpvalue
local setval = upvalueutil.SetUpvalue

local change_list = {}
local config = GetModConfigData("no_flower_picking")
local no_evilflower = GetModConfigData("no_leftclick_evilflower")
if config == "evil_only" then
    change_list.flower_evil = no_evilflower
elseif config == "normal_only" then
    change_list.flower = false
else
    change_list.flower = false
    change_list.flower_evil = no_evilflower
end

for prefab, boolean in pairs(change_list) do
    AddPrefabPostInit(prefab, function(inst)
        inst.nfp_no_actionbutton_pick = true
        if boolean then inst.nfp_nopick = true end
    end)
end

AddComponentPostInit("playercontroller", function(self, inst)
    if inst ~= _G.ThePlayer then return end

    local GetPickupAction = getval(self.GetActionButtonAction, "GetPickupAction")
    setval(self.GetActionButtonAction, "GetPickupAction", function(self, target, tool)
        if target.nfp_no_actionbutton_pick then
            local _HasTag = target.HasTag
            target.HasTag = function(self, tag)
                if tag == "pickable" then return false end
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

local COMPONENT_ACTIONS = getval(EntityScript.CollectActions, "COMPONENT_ACTIONS")
local pickable_fn = COMPONENT_ACTIONS and COMPONENT_ACTIONS.SCENE and COMPONENT_ACTIONS.SCENE.pickable
if pickable_fn then
    COMPONENT_ACTIONS.SCENE.pickable = function(inst, doer, actions)
        if inst.nfp_nopick then return end
        pickable_fn(inst, doer, actions)
    end

    setval(EntityScript.CollectActions, "COMPONENT_ACTIONS", COMPONENT_ACTIONS)
end