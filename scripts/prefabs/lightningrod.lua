require "prefabutil"
require "modutil"

local assets =
{
    Asset("ANIM", "anim/lightning_rod.zip"),
    Asset("ANIM", "anim/lightning_rod_fx.zip"),
	Asset("MINIMAP_IMAGE", "lightningrod"),
}

local prefabs =
{
    "lightning_rod_fx",
    "collapse_small",
}

local function onhammered(inst, worker)
    inst.components.lootdropper:DropLoot()
    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("metal")
    inst:Remove()
end

local function onhit(inst, worker)
    inst.AnimState:PlayAnimation("hit")
    inst.AnimState:PushAnimation("idle", false)
end

local function dozap(inst)
    if inst.zaptask ~= nil then
        inst.zaptask:Cancel()
    end

    inst.SoundEmitter:PlaySound("dontstarve/common/lightningrod")
    SpawnPrefab("lightning_rod_fx").Transform:SetPosition(inst.Transform:GetWorldPosition())

    inst.zaptask = inst:DoTaskInTime(math.random(10, 40), dozap)
end

local ondaycomplete

local function discharge(inst)
    if inst.charged then
        inst:StopWatchingWorldState("cycles", ondaycomplete)
        inst.AnimState:ClearBloomEffectHandle()
        inst.charged = false
        inst.chargeleft = nil
        inst.Light:Enable(false)
        if inst.zaptask ~= nil then
            inst.zaptask:Cancel()
            inst.zaptask = nil
        end
    end
end

local function ondaycomplete(inst)
    dozap(inst)
    if inst.chargeleft > 1 then
        inst.chargeleft = inst.chargeleft - 1
    else
        discharge(inst)
    end
end

local function setcharged(inst, charges)
    if not inst.charged then
        inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
        inst.Light:Enable(true)
        inst:WatchWorldState("cycles", ondaycomplete)
        inst.charged = true
    end
    inst.chargeleft = math.max(inst.chargeleft or 0, charges)
    dozap(inst)
end

local function onlightning(inst)
    onhit(inst)
    setcharged(inst, 3)
end

local function OnSave(inst, data)
    if inst.charged then
        data.charged = inst.charged
        data.chargeleft = inst.chargeleft
    end
end

local function OnLoad(inst, data)
    if data ~= nil and data.charged and data.chargeleft ~= nil and data.chargeleft > 0 then
        setcharged(inst, data.chargeleft)
    end
end

local function getstatus(inst)
    return inst.charged and "CHARGED" or nil
end

local function onbuilt(inst)
    inst.AnimState:PlayAnimation("place")
    inst.AnimState:PushAnimation("idle")
    inst.SoundEmitter:PlaySound("dontstarve/common/lightning_rod_craft")
end

local SCALE = 2.53

local function OnEnableHelper(mother_inst, enabled)
    if enabled then
        if mother_inst.helper == nil then
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

            local x, y, z = mother_inst.Transform:GetWorldPosition()
            inst.Transform:SetPosition(x, y, z)
            mother_inst.helper = inst
        end
    elseif mother_inst.helper ~= nil then
        mother_inst.helper:Remove()
        mother_inst.helper = nil
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState() 
    inst.entity:AddMiniMapEntity()
    inst.entity:AddLight()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.MiniMapEntity:SetIcon("lightningrod.png")

    inst.Light:Enable(false)
    inst.Light:SetRadius(1.5)
    inst.Light:SetFalloff(1)
    inst.Light:SetIntensity(.5)
    inst.Light:SetColour(235/255,121/255,12/255)

    inst:AddTag("structure")
    inst:AddTag("lightningrod")

    inst.AnimState:SetBank("lightning_rod")
    inst.AnimState:SetBuild("lightning_rod")
    inst.AnimState:PlayAnimation("idle")

    MakeSnowCoveredPristine(inst)


    if not TheNet:IsDedicated() and TUNING.lightning_rod_range.onhelp then
        inst:AddComponent("deployhelper")
        inst.components.deployhelper.onenablehelper = OnEnableHelper
    end

    if not TheWorld.ismastersim then
        return inst
    end

    inst.entity:SetPristine()

    inst:ListenForEvent("lightningstrike", onlightning)

    inst:AddComponent("lootdropper")
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
    inst.components.workable:SetOnFinishCallback(onhammered)
    inst.components.workable:SetOnWorkCallback(onhit)

    inst:AddComponent("inspectable")
    inst.components.inspectable.getstatus = getstatus

    MakeSnowCovered(inst)
    inst:ListenForEvent("onbuilt", onbuilt)

    MakeHauntableWork(inst)

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad

    return inst
end

local function placer_post_init(inst)
    --Show the flingo placer on top of the flingo range ground placer

    local placer2 = CreateEntity()

    --[[Non-networked entity]]
    placer2.entity:SetCanSleep(false)
    placer2.persists = false

    placer2.entity:AddTransform()
    placer2.entity:AddAnimState()

    placer2:AddTag("CLASSIFIED")
    placer2:AddTag("NOCLICK")
    placer2:AddTag("placer")

    local s = 1 / SCALE
    placer2.Transform:SetScale(s, s, s)

    placer2.AnimState:SetBank("lightning_rod")
    placer2.AnimState:SetBuild("lightning_rod")
    placer2.AnimState:PlayAnimation("idle")
    placer2.AnimState:SetLightOverride(1)

    placer2.entity:SetParent(inst.entity)

    inst.components.placer:LinkEntity(placer2)
end

if TUNING.lightning_rod_range.onbuild then
    return Prefab("lightning_rod", fn, assets, prefabs),
        MakePlacer("lightning_rod_placer",
            "lightning_rod_placer",
            "lightning_rod_placer",
            "idle",
            true,
            nil,
            nil,
            SCALE,
            nil,
            nil,
            placer_post_init)
else
    return Prefab("lightning_rod", fn, assets, prefabs),
    MakePlacer("lightning_rod_placer", "lightning_rod", "lightning_rod", "idle")
end
