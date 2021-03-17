local _G = GLOBAL
local ACTIONS = _G.ACTIONS
local CONTROL_FORCE_INSPECT = _G.CONTROL_FORCE_INSPECT

local no_keepnone = GetModConfigData("no_keepnone")

local function IsLowPriorityAction(act, extra_actions)
    local force_inspect = _G.ThePlayer.components.playercontroller ~= nil and _G.ThePlayer.components.playercontroller:IsControlPressed(CONTROL_FORCE_INSPECT)
    if act and extra_actions then
        for _, action in ipairs(extra_actions) do
            if act.action == ACTIONS[action] then
                return true
            end
        end
    end
    return act == nil
        or act.action == ACTIONS.WALKTO
        or (act.action == ACTIONS.LOOKAT and not force_inspect)
end

local function CanMouseThrough(inst, extra_actions, keepnone)
    local ThePlayer = _G.ThePlayer
    if not inst:HasTag("fire") and ThePlayer ~= nil and ThePlayer.components.playeractionpicker ~= nil then
        local lmb, rmb = ThePlayer.components.playeractionpicker:DoGetMouseActions(inst:GetPosition(), inst)
        return IsLowPriorityAction(rmb, extra_actions) and IsLowPriorityAction(lmb, extra_actions), keepnone and not no_keepnone
    end
end

local function is_active_item_deployable()
    local inv = _G.ThePlayer.replica.inventory
    local active_item = inv and inv:GetActiveItem()
    return active_item and active_item:IsValid() and active_item.replica.inventoryitem:IsDeployable(_G.ThePlayer)
end

local function do_change(prefabs, master_fn, keepnone)
    for _, prefab in ipairs(prefabs) do
        AddPrefabPostInit(prefab, function(inst)
            inst.CanMouseThrough = master_fn or function(inst) return CanMouseThrough(inst, nil, keepnone) end
        end)
    end
end

local function do_change_by_tag(tag, master_fn, keepnone)
    AddPrefabPostInitAny(function(inst)
        if inst and inst:HasTag(tag) then
            inst.CanMouseThrough = master_fn or function(inst) return CanMouseThrough(inst, nil, keepnone) end
        end
    end)
end

local common_keepnone_list = {"eyeturret", "eyeturret_base", "fireflies"}
do_change(common_keepnone_list, nil, true)

local common_list = {"moondial"}
do_change(common_list)

local cookwares = {"cookpot", "portablecookpot"}
do_change(cookwares)

local mushlight_list = {"mushroom_light", "mushroom_light2"}
do_change(mushlight_list, function(inst)
    return CanMouseThrough(inst, {"RUMMAGE", "STORE"})
end)

do_change_by_tag("player")
do_change_by_tag("critter") -- Pets
do_change_by_tag("shadowminion", nil, true) -- Maxwell's shadow minons

do_change_by_tag("shadowcreature", nil, true)
do_change_by_tag("nightmarecreature", nil, true)

do_change_by_tag("bird", function(inst)
    return inst:HasTag("flight")
end, true)

do_change_by_tag("farm_plant", function(inst)
    return CanMouseThrough(inst, nil, is_active_item_deployable())
end)


AddPrefabPostInit("minisign", function(inst)
    local MinisignCanMouseThrough = inst.CanMouseThrough
    inst.CanMouseThrough = function(inst, ...)
        return MinisignCanMouseThrough(inst, ...) or CanMouseThrough(inst, {"FAN"}) -- Not sure will it be more compatible tho
    end
end)

AddPlayerPostInit(function(inst)
    inst:DoTaskInTime(0, function(inst)
        if inst ~= _G.ThePlayer then return end
        inst.CanMouseThrough = function(inst)
            return CanMouseThrough(inst, nil, true)
        end
    end)
end)
