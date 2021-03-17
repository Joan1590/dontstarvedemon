
table.insert(Assets, Asset("ANIM", 'anim/lw_cameraUI.zip'))

local variable = require 'lw_mod_camera'

local function _CreateBG(data)
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    
    anim:SetBank(data[1])
    anim:SetBuild(data[2])
    anim:PlayAnimation(data[3])
    anim:SetLayer(LAYER_BACKGROUND)
    anim:SetLightOverride(1)

    inst:AddTag('FX')
    inst.persists = false

    return inst
end

AddSimPostInit(function(inst)
    if TheNet:IsDedicated() then return end

    local sky = _CreateBG({'lw_cameraUI','lw_cameraUI','sky'})
    sky.AnimState:SetMultColour(0.25, 0.75, 1, 1)
    sky.AnimState:SetSortOrder(1)
    sky.Transform:SetScale(16,4,1)

    --sky:DoPeriodicTask(1, function() print(sky.AnimState:GetMultColour()) end)

    local skyheight = 0
    local skydist = 50
    local skydir = 0

    local function updateskypos()
        local ori = TheCamera.targetpos
        local a = skydir
        local r = -skydist
        local offset = Vector3(math.cos(a)*r, skyheight, math.sin(a)*r)
        sky.Transform:SetPosition((ori+offset):Get())
    end

    --颜色
    variable.set('sky.SetColour', function(r,g,b,a)
        if type(r) == 'table' then
            r,g,b,a = unpack(r)
        end
        sky.AnimState:SetMultColour(r,g,b,a or 1)
    end)

    variable.set('sky.GetColour', function()
        return sky.AnimState:GetMultColour()
    end)

    --角度(需要与摄像机保持一致)
    variable.set('sky.SetDir', function(v)
        skydir = v
        updateskypos()
    end)

    --高度
    variable.set('sky.SetH', function(h)
        skyheight = h
        updateskypos()
    end)

    --与摄像机焦点的距离
    variable.set('sky.SetDist', function(d)
        skydist = d
        updateskypos()
    end)

    --显示 or 隐藏
    variable.set('sky.Show', function(v)
        if v then sky:Show() else sky:Hide() end
    end)

    local skyline = _CreateBG({'lw_cameraUI', 'lw_cameraUI', 'skyline'})
    skyline.entity:SetParent(sky.entity)
    skyline.AnimState:SetSortOrder(2)
    skyline.AnimState:Pause()
    skyline.AnimState:SetMultColour(1, 1, 1, 1)

    local lineheight = 0
    local linescale = 1
    local linealpha = 1

    variable.set('skyline.SetColour', function(r,g,b,a)
        if type(r) == 'table' then
            r,g,b = unpack(r)
        end
        skyline.AnimState:SetMultColour(r,g,b,linealpha)
    end)

    variable.set('skyline.GetColour', function()
        return skyline.AnimState:GetMultColour()
    end)

    variable.set('skyline.SetAlpha', function(a)
        local r,g,b = skyline.AnimState:GetMultColour()
        linealpha = a or 1
        skyline.AnimState:SetMultColour(r,g,b,linealpha)
    end)

    variable.set('skyline.GetAlpha', function()
        local t = skyline.AnimState:GetMultColour()
        return t[4]
    end)

    variable.set('skyline.Show', function(v)
        if v then skyline:Show() else skyline:Hide() end
    end)

    variable.set('skyline.SetH', function(h)
        lineheight = h
        skyline.Transform:SetPosition(0,h,0)
    end)

    variable.set('skyline.SetScale', function(s)
        linescale = s
        --skyline.Transform:SetScale(1,s,1)
        skyline.AnimState:SetPercent('skyline', 1-s)
    end)
end)

AddClassPostConstruct('cameras/followcamera', function (self)
    local old_app = self.Apply
    function self:Apply(...)
        old_app(self, ...)
        local pos = self.currentpos

        variable.softcall('sky.SetDir', self.heading*DEGREES)
    end
end)
