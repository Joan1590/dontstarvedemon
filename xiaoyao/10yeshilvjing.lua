local obc_eagleMode = false
local nightsightMode = false
local lastFov = 35
local CIRCLE_STATE = nil
local G = GLOBAL
local showP = TUNING.xiaoyao("夜视全图滤镜处理")

local function MakeCircle(inst, n, scale)
	local circle = G.CreateEntity()

	circle.entity:SetCanSleep(false)
	circle.persists = false

	circle.entity:AddTransform()
	circle.entity:AddAnimState()

	circle:AddTag("CLASSIFIED")
	circle:AddTag("NOCLICK")
	circle:AddTag("placer")

	circle.Transform:SetRotation(n)
	-- 大小
	circle.Transform:SetScale(scale, scale, scale)

	circle.AnimState:SetBank("firefighter_placement")
	circle.AnimState:SetBuild("firefighter_placement")
	circle.AnimState:PlayAnimation("idle")
	circle.AnimState:SetLightOverride(1)
	circle.AnimState:SetOrientation(G.ANIM_ORIENTATION.OnGround)
	circle.AnimState:SetLayer(G.LAYER_BACKGROUND)
	circle.AnimState:SetSortOrder(3.1)
	-- 颜色
	circle.AnimState:SetAddColour(0, 255, 0, 0)

	circle.entity:SetParent(inst.entity)
	return circle
end

local function IsDefaultScreen()
	local screen = GLOBAL.TheFrontEnd:GetActiveScreen()
	local screenName = screen and screen.name or ""
	return screenName:find("HUD") ~= nil and GLOBAL.ThePlayer ~= nil
end

local function SetCamera(zoomstep, mindist, maxdist, mindistpitch, maxdistpitch, distance, distancetarget)
	if GLOBAL.TheCamera ~= nil then
		local camera = GLOBAL.TheCamera
		camera.zoomstep = zoomstep or camera.zoomstep
		camera.mindist = mindist or camera.mindist
		camera.maxdist = maxdist or camera.maxdist
		camera.mindistpitch = mindistpitch or camera.mindistpitch
		camera.maxdistpitch = maxdistpitch or camera.maxdistpitch
		camera.distance = distance or camera.distance
		camera.distancetarget = distancetarget or camera.distancetarget
	end
end

local function SetDefaultView()
	if GLOBAL.TheWorld ~= nil then
		if GLOBAL.TheWorld:HasTag("cave") then
			SetCamera(4, 15, 35, 25, 40, 25, 25)
		else
			SetCamera(4, 15, 50, 30, 60, 30, 30)
		end
	end
end


local function SetVerticalView()
	if GLOBAL.TheWorld ~= nil then
		if GLOBAL.TheWorld:HasTag("cave") then
			SetCamera(10, 10, 180, 90, 90, 80, 80)
		else
			SetCamera(10, 10, 180, 90, 90, 80, 80)
		end
	end
end
-- 鹰眼
local function EagleViewMode()
	local player = G.ThePlayer
    if IsDefaultScreen() then
		if obc_eagleMode then
			-- 视角
            obc_eagleMode = false
            SetDefaultView()
			GLOBAL.TheCamera.fov = lastFov
			-- 画圆
			if showP then
				for _,circle in pairs(CIRCLE_STATE) do circle:Remove() end
				CIRCLE_STATE = nil
			end
			-- 说话
			GLOBAL.ThePlayer.components.talker:Say("关闭")
		else
			-- 视角
            lastFov = GLOBAL.TheCamera.fov
			obc_eagleMode = true
			SetVerticalView()
			GLOBAL.TheCamera.fov = 165
			-- 画圆
			if showP then
				CIRCLE_STATE = {}
				table.insert(CIRCLE_STATE, MakeCircle(player, 0, 2))
				table.insert(CIRCLE_STATE, MakeCircle(player, 2, 2))
			end
			-- 说话
			GLOBAL.ThePlayer.components.talker:Say("全图")
		end
	end
end


-- 夜视
local function  Nightsight()
    if GLOBAL.ThePlayer and not GLOBAL.ThePlayer.HUD:IsChatInputScreenOpen() and not GLOBAL.ThePlayer.HUD:IsConsoleScreenOpen() and not GLOBAL.ThePlayer.HUD.writeablescreen then
        nvk = not nvk
        nightsightMode = not nightsightMode
        GLOBAL.ThePlayer.components.playervision:ForceNightVision(nvk)
        if nightsightMode then
            GLOBAL.ThePlayer.components.talker:Say("夜视开启")
        else
            GLOBAL.ThePlayer.components.talker:Say("夜视关闭")
        end
    end
    return true
end


GLOBAL.TheInput:AddKeyDownHandler(TUNING.xiaoyao("鹰眼全图"), EagleViewMode)
GLOBAL.TheInput:AddKeyDownHandler(TUNING.xiaoyao("夜视开关"), Nightsight)