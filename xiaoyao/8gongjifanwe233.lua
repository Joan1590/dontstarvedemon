_G = GLOBAL
SHORTCUT_KEY = TUNING.xiaoyao("动物跟踪器快捷键")
SHORTCUT_KEY_LOST_TOY = TUNING.xiaoyao("丢失的玩具跟踪器快捷键")

if _G.LanguageTranslator.defaultlang == 'cht' then
	_G.STRINGS.UI.ANIMAL_TRACKER = {
		FOUND_TRACK_FMT = "发现一个%s...",
		TRACKING_FMT = "正在搜索%s...",
		NOT_FOUND = "没有发现足迹！",
		NO_TOY_FOUND = "没有发现遗失的玩具！"
	}
else
	_G.STRINGS.UI.ANIMAL_TRACKER = {
		FOUND_TRACK_FMT = "发现一个%s...",
		TRACKING_FMT = "正在搜索%s...",
		NOT_FOUND = "没有发现足迹！",
		NO_TOY_FOUND = "没有发现遗失的玩具！"
	}
end
-- _G.LanguageTranslator.defaultlang
-- _G.LanguageTranslator.languages["cht"]["STRINGS.UI.ANIMAL_TRACKER.FOUND_TRACK_FMT"]

local function IsHUDScreen()
	local defaultscreen = false
	if TheFrontEnd:GetActiveScreen() and TheFrontEnd:GetActiveScreen().name and type(TheFrontEnd:GetActiveScreen().name) == "string" and TheFrontEnd:GetActiveScreen().name == "HUD" then
		defaultscreen = true
	end
	return defaultscreen
end

STRINGS = _G.STRINGS
_G.ANIMAL_TRACKER = {
	UI = nil, 
	tracking_anim = TUNING.xiaoyao("跟踪动画"), 
	notification_sound_found = (TUNING.xiaoyao("通知声音")==1 or TUNING.xiaoyao("通知声音")==3), 
	notification_sound_lose = (TUNING.xiaoyao("通知声音")==2 or TUNING.xiaoyao("通知声音")==3), 
	nearby_tracks = {}, 
	num_nearby_tracks = function(inst) 
		local count = 0
		for _ in pairs(inst.nearby_tracks) do
			count = count + 1
		end
		return count
	end, 
}

local ThePlayer
local function PlayerControllerPostInit(self)
    ThePlayer = self.inst
end
AddComponentPostInit("playercontroller", PlayerControllerPostInit)

local AnimalTracker = _G.require "widgets/AnimalTracker"

local function switchUI(onoff)
	if onoff then
		controls.AnimalTracker:Show() 
		if _G.ANIMAL_TRACKER.notification_sound_found and not controls.AnimalTracker.isShown then
			_G.TheFocalPoint.SoundEmitter:PlaySound("dontstarve/common/researchmachine_lvl1_ding")
		end
	else
		controls.AnimalTracker:Hide() 
		if _G.ANIMAL_TRACKER.notification_sound_lose and controls.AnimalTracker.isShown then
			_G.TheFocalPoint.SoundEmitter:PlaySound("dontstarve/common/nightmareAddFuel")
		end
	end
	controls.AnimalTracker.isShown = onoff 
end

local function checkAndSwitchUI(inst) 
	switchUI(_G.ANIMAL_TRACKER:num_nearby_tracks() > 0)
end 

AddClassPostConstruct("widgets/controls", function(self)
	controls = self
	controls.AnimalTracker = controls.bottomright_root:AddChild(AnimalTracker()) 
	_G.ANIMAL_TRACKER.UI = controls.AnimalTracker 
	switchUI(false)
end)

local function onnear(inst)
	_G.ANIMAL_TRACKER.nearby_tracks[inst.GUID] = true
	checkAndSwitchUI(inst) 
end

local function onfar(inst)
	_G.ANIMAL_TRACKER.nearby_tracks[inst.GUID] = nil
	inst:DoTaskInTime(0.1, checkAndSwitchUI)
end

function onremove(inst)
	_G.ANIMAL_TRACKER.nearby_tracks[inst.GUID] = nil
	checkAndSwitchUI(inst)
end

AddPrefabPostInit("dirtpile", function(inst)
	-- return when it's server side
	if _G.TheWorld.ismastersim then
	    return inst
	end
	-- only apply on client side
	inst:AddComponent("playerprox")
	inst.components.playerprox:SetDist(64,64)
	inst.components.playerprox:SetOnPlayerNear(onnear)
	inst.components.playerprox:SetOnPlayerFar(onfar)
	inst:DoTaskInTime(0.1, function(inst) inst.components.playerprox:SetTargetMode(inst.components.playerprox.TargetModes.SpecificPlayer, ThePlayer, true) end)
	inst:ListenForEvent("onremove", onremove)
	return inst
end)


AddPrefabPostInit("animal_track", function(inst)
	-- return when it's server side
	if _G.TheWorld.ismastersim then
	    return inst
	end
	-- only apply on client side
	inst:AddComponent("playerprox")
	inst.components.playerprox:SetDist(64,64)
	inst.components.playerprox:SetOnPlayerNear(onnear)
	inst.components.playerprox:SetOnPlayerFar(onfar)
	inst:DoTaskInTime(0.1, function(inst) inst.components.playerprox:SetTargetMode(inst.components.playerprox.TargetModes.SpecificPlayer, ThePlayer, true) end)
	inst:ListenForEvent("onremove", onremove)
end)


----[[ Shortcut Key ]]----
function KeyHandler(key, down)
if not IsHUDScreen() then return end
	if down then
		if _G.ConsoleCommandPlayer() then
			if SHORTCUT_KEY and key == SHORTCUT_KEY then
				local ret = AnimalTracker:FollowTrack()
				switchUI(ret)
			elseif SHORTCUT_KEY_LOST_TOY and key == SHORTCUT_KEY_LOST_TOY then
				print("FindLostToy")
				local ret = AnimalTracker:FindLostToy()
				print("ret", ret)
				-- switchUI(ret)
			end
		end
	end
end

	
function gamepostinit()	
	_G.TheInput:AddKeyHandler(KeyHandler)
end

AddGamePostInit(gamepostinit)