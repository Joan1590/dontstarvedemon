local Recipe = GLOBAL.Recipe
local Ingredient = GLOBAL.Ingredient
local RECIPETABS = GLOBAL.RECIPETABS
local STRINGS = GLOBAL.STRINGS
local TUNING = GLOBAL.TUNING
local ACTIONS = GLOBAL.ACTIONS
local require = GLOBAL.require
local TheInput = GLOBAL.TheInput
local ThePlayer = GLOBAL.ThePlayer
local IsServer = GLOBAL.TheNet:GetIsServer()
local Inv = require "widgets/inventorybar"
local containers = GLOBAL.require "containers"
local TheWorld = GLOBAL.TheWorld

_G = GLOBAL; require, rawget, getmetatable, unpack = _G.require, _G.rawget, _G.getmetatable, _G.unpack
TheNet = _G.TheNet; IsServer, IsDedicated = TheNet:GetIsServer(), TheNet:IsDedicated()
TheSim = _G.TheSim
STRINGS = _G.STRINGS
RECIPETABS, TECH, AllRecipes, GetValidRecipe = _G.RECIPETABS, _G.TECH, _G.AllRecipes, _G.GetValidRecipe
EQUIPSLOTS, FRAMES, FOODTYPE, FUELTYPE = _G.EQUIPSLOTS, _G.FRAMES, _G.FOODTYPE, _G.FUELTYPE

State, TimeEvent, EventHandler = _G.State, _G.TimeEvent, _G.EventHandler
ACTIONS, ActionHandler = _G.ACTIONS, _G.ActionHandler
CAMERASHAKE, ShakeAllCameras = _G.CAMERASHAKE, _G.ShakeAllCameras

SpawnPrefab, ErodeAway, FindEntity = _G.SpawnPrefab, _G.ErodeAway, _G.FindEntity
KnownModIndex, Vector3, Remap = _G.KnownModIndex, _G.Vector3, _G.Remap
COMMAND_PERMISSION, BufferedAction, SendRPCToServer, RPC = _G.COMMAND_PERMISSION, _G.BufferedAction, _G.SendRPCToServer, _G.RPC
COLLISION = _G.COLLISION

AllPlayers = _G.AllPlayers





local function getval(fn, path)
	local val = fn
	for entry in path:gmatch("[^%.]+") do
		local i=1
		while true do
			local name, value = GLOBAL.debug.getupvalue(val, i)
			if name == entry then
				val = value
				break
			elseif name == nil then
				return
			end
			i=i+1
		end
	end
	return val
end

local function setval(fn, path, new)
	local val = fn
	local prev = nil
	local i
	for entry in path:gmatch("[^%.]+") do
		i = 1
		prev = val
		while true do
			local name, value = GLOBAL.debug.getupvalue(val, i)
			if name == entry then
				val = value
				break
			elseif name == nil then
				return
			end
			i=i+1
		end
	end
	GLOBAL.debug.setupvalue(prev, i ,new)
end

--local hackpath = "OnFilesLoaded.OnUpdatePurchaseStateComplete.DoResetAction.DoGenerateWorld.DoInitGame"
--local OldLoad = GLOBAL.Profile.Load
--function GLOBAL.Profile:Load(fn)
--	local initfn=getval(fn, hackpath)
--	setval(fn, hackpath, function(savedata, profile)
		GLOBAL.global("currentworld")
--		GLOBAL.currentworld = savedata.map.prefab

--end)
--end

---------------------------------color cube by EvenMr  --------------------------------------------------------------
local resolvefilepath=GLOBAL.resolvefilepath

	AddComponentPostInit("colourcube", function(self)
--		if GLOBAL.currentworld == "forest" then
			for _,v in pairs(GLOBAL.TheWorld.event_listeners["playerdeactivated"][GLOBAL.TheWorld]) do
				if getval(v,"OnOverrideCCTable") then
					setval(v, "OnOverrideCCTable.UpdateAmbientCCTable.SEASON_COLOURCUBES",{
						autumn =
						{
							day = resolvefilepath("images/colour_cubes/sw_mild_day_cc.tex"),
							dusk = resolvefilepath("images/colour_cubes/SW_mild_dusk_cc.tex"),
							night = resolvefilepath("images/colour_cubes/SW_mild_night_cc.tex"),
							full_moon = "images/colour_cubes/purple_moon_cc.tex"
						},
						winter =
						{
							day = resolvefilepath("images/colour_cubes/SW_wet_day_cc.tex"),
							dusk = resolvefilepath("images/colour_cubes/SW_wet_dusk_cc.tex"),
							night = resolvefilepath("images/colour_cubes/SW_wet_night_cc.tex"),
							full_moon = "images/colour_cubes/purple_moon_cc.tex"
						},
						spring =
						{
							day = resolvefilepath("images/colour_cubes/sw_green_day_cc.tex"),
							dusk = resolvefilepath("images/colour_cubes/sw_green_dusk_cc.tex"),
							night = resolvefilepath("images/colour_cubes/sw_green_dusk_cc.tex"),
							full_moon = "images/colour_cubes/purple_moon_cc.tex"
						},
						summer =
						{
							day = resolvefilepath("images/colour_cubes/SW_dry_day_cc.tex"),
							dusk = resolvefilepath("images/colour_cubes/SW_dry_dusk_cc.tex"),
							night = resolvefilepath("images/colour_cubes/SW_dry_night_cc.tex"),
							full_moon = "images/colour_cubes/purple_moon_cc.tex"
						},
					})
					break
				end
			end
--		end
	end)