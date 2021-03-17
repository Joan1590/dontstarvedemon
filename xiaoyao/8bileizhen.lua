local RECIPETABS = GLOBAL.RECIPETABS
local Vector3 = GLOBAL.Vector3
local TECH = GLOBAL.TECH
local TheNet = GLOBAL.TheNet
local require = GLOBAL.require
require "prefabutil"



local TUNING = GLOBAL.TUNING
TUNING.lightning_rod_range = {
    onclick = TUNING.xiaoyao("ONCLICK"),
    onclick_timer = TUNING.xiaoyao("ONCLICK_TIME"),
    onbuild = TUNING.xiaoyao("ONBUILD"),
    onhelp = TUNING.xiaoyao("ONHELP")
}

local function LightningRodOnRemove(inst)
	if inst.helper_2 ~= nil then
        inst.helper_2:Remove()
        inst.helper_2 = nil
    end
end

local function LightningRodShowRange(inst)
	if inst.helper_2 == nil then
        local x, y, z = inst.Transform:GetWorldPosition()
		inst.helper_2 = GLOBAL.SpawnPrefab("lightning_rod_range")
        inst.helper_2.owner = inst
		inst.helper_2.Transform:SetPosition(x, y, z)
	end
end

if TUNING.lightning_rod_range.onclick then
    local controller = GLOBAL.require "components/playercontroller"
    local old_OnLeftClick = controller.OnLeftClick
    function controller:OnLeftClick(down,...)
        if (not down) and self:UsingMouse() and self:IsEnabled() and not GLOBAL.TheInput:GetHUDEntityUnderMouse() then
            local item = GLOBAL.TheInput:GetWorldEntityUnderMouse()
            if item and item.prefab == "lightning_rod" then
                LightningRodShowRange(item)
            end
        end
        return old_OnLeftClick(self,down,...)
    end

    local old_fn = controller.DoInspectButton
    function controller:DoInspectButton(...)
        local entity = self:GetControllerTarget()
        if entity and entity.prefab == "lightning_rod" then
            LightningRodShowRange(entity)
        end
        old_fn(self, ...)
    end
end

function LightningRodPostInit(inst)
    inst:ListenForEvent("onremove", LightningRodOnRemove)
end

AddPrefabPostInit("lightning_rod", LightningRodPostInit)