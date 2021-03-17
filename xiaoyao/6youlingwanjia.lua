local _G = GLOBAL
local require = _G.require
local TheSim = _G.TheSim
local TheNet = _G.TheNet
local SendRPCToServer = _G.SendRPCToServer
local ACTIONS = _G.ACTIONS
local EQUIPSLOTS = _G.EQUIPSLOTS
local TheInput = _G.TheInput
local KnownModIndex = _G.KnownModIndex
local PlayerPositionManager = require("widgets/playerpositionmanager")
local PlayerData = require("persistentlastseenplayerdata")
local hide = TUNING.xiaoyao("隐蔽幽灵玩家")
local default = TUNING.xiaoyao("默认开启关闭幽灵玩家")




local function ApplyWidgetToPlayersOnLoad()
	local pos = _G.ThePlayer:GetPosition()
	for _,player in pairs(TheSim:FindEntities(pos.x,0,pos.z,80,{"player"},{"extra_spooky"})) do
		for _,ghost in pairs(_G.ThePlayer._known_positionmanagers or {}) do
			if ghost and ghost._tempid and ghost._tempid == player.userid then
				ghost:PushEvent("attempt_rebind",player)
				break
			end
		end
	end
	if _G.ThePlayer and _G.ThePlayer.HUD then
		for k,v in pairs(TheSim:FindEntities(pos.x,0,pos.z,80,{"player"},{"extra_spooky"})) do
			if v.userid and not v._positionmanagerisadded then
				_G.ThePlayer.HUD:AddChild(PlayerPositionManager(v))
				v._positionmanagerisadded = true
			end
		end
	end
end

local function SavePersistentData()
	--print(KnownModIndex:GetModActualName("Last Seen")..": Attempting save")
	if not _G.ThePlayer then return end
	local my_data = _G.ThePlayer.MOD_LastSeen_data
	if not my_data then
		--_G.assert(my_data ~= nil,"Error: no existing data on player of persistent player info")
	else
		local seed = _G.TheWorld and ((_G.TheWorld:HasTag("cave") and _G.TheWorld.meta.seed.."_caves") or tostring(_G.TheWorld.meta.seed)) or nil
		--_G.assert(seed ~= nil,"Error: Seed is a nil value")
		if seed == nil then return end
		
		local data_id = PlayerData("xiaoyaoooooo")
		local g_data = data_id:Load()
		g_data[seed] = _G.ThePlayer.MOD_LastSeen_data
		data_id:ChangePersistData(g_data)
		data_id:Save()
		--print(KnownModIndex:GetModActualName("Last Seen")..": Data saved successfully")
	end
end

local function ForceGhostSpawn()--Push this event to have persistent data of players that were in the area as the "onremove" event wont trigger if you leave.
	if not _G.ThePlayer then return end
	local pos = _G.ThePlayer:GetPosition()
	if pos then
		for _,player in pairs(TheSim:FindEntities(pos.x,0,pos.z,80,{"player"},{"extra_spooky"})) do
			if player ~= _G.ThePlayer then
				player:PushEvent("onremove")
			end
		end
	end
end


local function OnLoad()
		local seed = _G.TheWorld and ((_G.TheWorld:HasTag("cave") and _G.TheWorld.meta.seed.."_caves") or tostring(_G.TheWorld.meta.seed)) or nil
	if seed then
		local data = PlayerData("xiaoyaoooooo"):Load()
		_G.ThePlayer.MOD_LastSeen_data = data[seed] or {}
		--print(KnownModIndex:GetModActualName("Last Seen")..": Data loaded successfully")
		if _G.ThePlayer.HUD then
			for k,v in pairs(_G.ThePlayer.MOD_LastSeen_data or {}) do
				_G.ThePlayer.HUD:AddChild(PlayerPositionManager(nil,true,v))
			end
		end
		_G.TheWorld:RemoveEventCallback("seasontick",SavePersistentData)
		_G.TheWorld:RemoveEventCallback("playerdeactivated",SavePersistentData)
		_G.TheWorld:RemoveEventCallback("playerdeactivated",ForceGhostSpawn)
		_G.TheWorld:RemoveEventCallback("LastSeen_player_restarting",SavePersistentData)
		_G.TheWorld:RemoveEventCallback("LastSeen_player_restarting",ForceGhostSpawn)
		
		_G.TheWorld:ListenForEvent("seasontick",SavePersistentData)--On day start
		_G.TheWorld:ListenForEvent("playerdeactivated",ForceGhostSpawn)
		_G.TheWorld:ListenForEvent("playerdeactivated",SavePersistentData)--Enters/leaves caves; Rollback; Regen
		_G.TheWorld:ListenForEvent("LastSeen_player_restarting",ForceGhostSpawn)
		_G.TheWorld:ListenForEvent("LastSeen_player_restarting",SavePersistentData)--Quits game via disconnect button; Migrates to another server
	end
end


local old_DoRestart = _G.DoRestart
function _G.DoRestart(val)
	if val == true and _G.TheWorld then
		_G.TheWorld:PushEvent("LastSeen_player_restarting")
	end
	old_DoRestart(val)
end
local old_MigrateToServer = _G.MigrateToServer
function _G.MigrateToServer(ip,port,...)
	if ip and port and _G.TheWorld then
		_G.TheWorld:PushEvent("LastSeen_player_restarting")
	end
	old_MigrateToServer(ip,port,...)
end

local function InGame()
    return _G.ThePlayer and _G.ThePlayer.HUD and not _G.ThePlayer.HUD:HasInputFocus()
end

--[[local function SetSkinForGhost(ghost,skin_name)
    if ghost and ghost.components and ghost.components.skinner then
       local skinner = ghost.components.skinner
       skinner:SetSkinName(skin_name or "")
    end
end--]]

--[[local function SetClothingsForGhost(ghost,body,hand,legs,feet)
    local prefabStart,prefabEnd = ghost and ghost.prefab and string.find(ghost.prefab,"_%w+")
    local real_prefab = ghost and ghost.prefab and string.sub(ghost.prefab,prefabStart+1,prefabEnd)
    if ghost and ghost.components and ghost.components.skinner then
        local skinner = ghost.components.skinner
        skinner:SetClothing(body)
        skinner:SetClothing(hand)
        skinner:SetClothing(legs)
        skinner:SetClothing(feet)
    end
end--]]

AddPlayerPostInit(function(inst) 
	inst:DoTaskInTime(1.1,function()
			if inst == _G.ThePlayer then
				ApplyWidgetToPlayersOnLoad()
				if not default then
					_G.ThePlayer.MOD_LastSeen_tohide = true
					_G.ThePlayer:PushEvent("LastSeen_visibilitychange")
				else
					_G.ThePlayer.MOD_LastSeen_tohide = false
				end
			end
		end)
end)

AddPlayerPostInit(function(inst) 
	inst:DoTaskInTime(1,function()
		if inst == _G.ThePlayer then
			OnLoad()
		end
	end)
end)

AddPlayerPostInit(function(inst)
		if inst and inst.userid and (_G.ThePlayer and _G.ThePlayer.HUD) and not inst._positionmanagerisadded then --and not inst == _G.ThePlayer
			local pos = _G.ThePlayer:GetPosition()
			
			_G.ThePlayer:DoTaskInTime(1,function()--Should be enough time for the player to fully load to grab data.
				for _,ghost in pairs(_G.ThePlayer._known_positionmanagers or {}) do
					if ghost and ghost._tempid and ghost._tempid == inst.userid then
						ghost:PushEvent("attempt_rebind",inst)--Can I somehow add the rebind to this specific player as the input?
						break
					end
				end
				if not inst._positionmanagerisadded then-- attempt_rebind can re-add an already applied widget
					_G.ThePlayer.HUD:AddChild(PlayerPositionManager(inst))
					inst._positionmanagerisadded = true
				end
			end)
		end
	end)
		
if hide and hide ~= 0 then
	TheInput:AddKeyUpHandler(hide, function()
			if not InGame() then return else
				if _G.ThePlayer.MOD_LastSeen_tohide then
					_G.ThePlayer.MOD_LastSeen_tohide = false
				else
					_G.ThePlayer.MOD_LastSeen_tohide = true
				end
				_G.ThePlayer:PushEvent("LastSeen_visibilitychange")
				_G.ThePlayer.components.talker:Say("幽灵玩家: "..tostring(not _G.ThePlayer.MOD_LastSeen_tohide))
			end
		end)
end
		


