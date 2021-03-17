require "prefabutil"
require "modutil"

local assets = {
    Asset("ANIM", "anim/lightning_rod_placer.zip"),
}

local SCALE = 2.53

local function fn()
    local inst = CreateEntity()
    inst.persists = false

    inst.entity:AddTransform()
    inst.entity:AddAnimState()

    inst:AddTag("CLASSIFIED")
    inst:AddTag("NOCLICK")
    inst:AddTag("FX")
    inst:AddTag("placer")

    inst.Transform:SetScale(SCALE, SCALE, SCALE)
    
    inst.AnimState:SetBank("lightning_rod_placer")
    inst.AnimState:SetBuild("lightning_rod_placer")
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(3)

    inst:DoTaskInTime(TUNING.lightning_rod_range.onclick_timer, function()
        inst:Remove()
        if inst.owner ~= nil then
            inst.owner.helper_2 = nil
        end
    end)
    return inst
end

return Prefab("lightning_rod_range", fn, assets)