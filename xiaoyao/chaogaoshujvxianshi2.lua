

local _G = GLOBAL
local require = _G.require
local setmetatable = _G.setmetatable
local GetString = _G.GetString

local AutoSaveManager = require("autosavemanager")
local ChargeBadge = require("widgets/chargebadge")
local WxChargeSaver = nil

local MOD_SETTINGS = {
	FORMAT_CHARGE = TUNING.xiaoyao("机器电池"),
}

--------------------------------------------------------------------------------

-- Mod compatibility stuff by rezecib (https://steamcommunity.com/profiles/76561198025931302)
local CHECK_MODS = {
	["workshop-376333686"] = "COMBINED_STATUS",
	["workshop-1583765151"] = "VICTORIAN_HUD",
	["workshop-1824509831"] = "FORGE_HUD",
	["workshop-343753877"] = "STATUS_ANNOUNCEMENTS",
}
local HAS_MOD = {}
--If the mod is already loaded at this point
for mod_name, key in pairs(CHECK_MODS) do
	HAS_MOD[key] = HAS_MOD[key] or (GLOBAL.KnownModIndex:IsModEnabled(mod_name) and mod_name)
end
--If the mod hasn't loaded yet
for k, v in pairs(GLOBAL.KnownModIndex:GetModsToLoad()) do
	local mod_type = CHECK_MODS[v]
	if mod_type then
		HAS_MOD[mod_type] = v
	end
end

--------------------------------------------------------------------------------

-- Frame and background of the Victorian themed badge by reD (http://steamcommunity.com/profiles/76561198022694259)
if HAS_MOD.VICTORIAN_HUD then
	table.insert(Assets, Asset("ANIM", "anim/vic_charge_meter.zip"))
end
-- Frame and background of the Forge themed badge by reD (http://steamcommunity.com/profiles/76561198022694259)
if HAS_MOD.FORGE_HUD then
	table.insert(Assets, Asset("ANIM", "anim/forge_charge_meter.zip"))
end

--------------------------------------------------------------------------------
--[[
Use status announcements statusannouncer to add the stat (https://steamcommunity.com/sharedfiles/filedetails/?id=343753877).
Status Announcements uses the function PlayerHud:SetMainCharacter to call "SetCharacter", then "RegisterCommonStats" immediatly after it.
SetCharacter clears existing stats, so no point making a stat before StatusAnnouncer and PlayerHud:SetMainCharacter run.
RegisterCommonStats doesn't have an obvious add callback for custom stats.
This implementation is based off https://steamcommunity.com/sharedfiles/filedetails/?id=1206117282
]]

if HAS_MOD.STATUS_ANNOUNCEMENTS then
	AddPrefabPostInit("world", function()
		local StatusAnnouncer = require("statusannouncer")
		
		local S = _G.STRINGS._STATUS_ANNOUNCEMENTS
		S._.STAT_NAMES.Charge = "Charge"
		S._.STAT_EMOJI.Charge = "lightbulb"
		S.WX78.CHARGE = {
			FULL = "POWER STATUS: OVERLOADED",
			HIGH = "POWER STATUS: SUFFICIENT",
			MID = "POWER STATUS: DRAINING",
			LOW = "POWER STATUS: NEAR DEPLETION",
			EMPTY = "POWER STATUS: CONCERNING",
			DYING = "POWER STATUS: DYING",
			STUCK = "POWER STATUS: AWAITING DEMISE",
		}
		S.UNKNOWN.CHARGE = { -- no one else should have charge
			FULL = "Fully charged.",
			HIGH = "Highly charged.",
			MID = "Roughly half charged.",
			LOW = "Slightly charged.",
			EMPTY = "Barely charged.",
			DYING = "Lights fading, limbs growing cold.",
			STUCK = "Charge unknown. At least a minute remains.",
		}
		
		--                     {"STUCK",  "DYING",  "EMPTY",  "LOW",  "MID",  "HIGH",  "FULL"}
		local realthresholds = {         0,        0,      .15,    .35,     .55,    .75,     }
		local thresholds = {}
		local metatable = { __index = function(_, key)
			if not _G.ThePlayer or not _G.ThePlayer.components.strikecounter then return 1 end 
			local charge = _G.ThePlayer.components.strikecounter:GetCharge()
			
			if key == 1 and charge == 60 then
				return 1
			elseif key == 2 and charge < 60 then
				return 1
			else
				return realthresholds[key]
			end
		end}
		setmetatable(thresholds, metatable)
		
		-- Status Announcements clears stats before calling RegisterCommonStats, so we hijack RegisterCommonStats.
		local old_RegisterCommonStats = StatusAnnouncer.RegisterCommonStats
		StatusAnnouncer.RegisterCommonStats = function(self, HUD, prefab, hunger, sanity, health, moisture, beaverness, ...)
			old_RegisterCommonStats(self, HUD, prefab, hunger, sanity, health, moisture, beaverness, ...)
			
			-- This is kinda lazy however ThePlayer is nil at this point, we can't check if we have the charge component.
			if prefab == "wx78" then
				self:RegisterStat(
					"Charge",
					HUD.controls.status.charge,
					_G.CONTROL_ROTATE_LEFT, -- Left Bumper, same as log meter
					thresholds,
				  --{       1/0,      1/0,      .15,    .35,     .55,    .75,     }
					{"STUCK",  "DYING",  "EMPTY",  "LOW",  "MID",  "HIGH",  "FULL"},
					function(ThePlayer)
						return	ThePlayer.components.strikecounter:GetCharge(),
								ThePlayer.components.strikecounter:GetMaxCharge()
					end,
					nil
				)
			end
		end
	end)
end

--------------------------------------------------------------------------------

AddSimPostInit(function(self)
	_G.TheWorld:ListenForEvent("playeractivated", function(_TheWorld, _ThePlayer)
		if not _ThePlayer or _ThePlayer.prefab ~= "wx78" or _ThePlayer ~= _G.ThePlayer then return end
		local ThePlayer = _G.ThePlayer
		
		WxChargeSaver = AutoSaveManager("wxcharge", function()
			if ThePlayer and ThePlayer.prefab == "wx78" and ThePlayer.components.strikecounter then
				local val = ThePlayer.components.strikecounter:GetCharge()
				local max = ThePlayer.components.strikecounter:GetMaxCharge()
				
				return { val = val, max = max }
			end
			
			return nil
		end)
		WxChargeSaver:StartAutoSave()
		
		if not ThePlayer.components.strikecounter then
			local charge_data = WxChargeSaver:LoadData()
			
			-- Backwards compatibility.
			if type(charge_data) ~= "table" then
				charge_data = {}
			end
			if type(charge_data.val) ~= "number" then
				charge_data.val = 0
			end
			if type(charge_data.max) ~= "number" then
				charge_data.max = 0
			end
			
			ThePlayer:AddComponent("strikecounter")
			ThePlayer.components.strikecounter:SetMaxCharge(charge_data.max)
			ThePlayer.components.strikecounter:SetCharge(charge_data.val)
		end
		
		-- AddClassPostConstruct("talker", function(self) end) has problems understanding what ThePlayer is... Hopefully this is a temp fix.
		if ThePlayer.components.talker and not ThePlayer.components.talker.counting_strikes then
			local talker = ThePlayer.components.talker
			talker.counting_strikes = true
			
			local OldSay = talker.Say
			function talker:Say(script, time, noanim, force, nobroadcast, colour, ...)
				if talker.inst == ThePlayer and ThePlayer.prefab == "wx78" and colour == nil then
					if script == GetString("wx78", "ANNOUNCE_CHARGE") then
						ThePlayer:DoTaskInTime(0.1, function() -- ThePlayer talks before the lightning spawns :|
							if ThePlayer and ThePlayer.components.strikecounter then
								ThePlayer.components.strikecounter:TryAddCharge()
							end
						end)
					elseif script == GetString("wx78", "ANNOUNCE_DISCHARGE") then
						ThePlayer.components.strikecounter:SetCharge(0)
					end
				end
				
				OldSay(talker, script, time, noanim, force, nobroadcast, colour, ...)
			end
		end
	end)
end)

AddClassPostConstruct("widgets/statusdisplays", function(self)
	if not self.owner or self.owner.prefab ~= "wx78" then return end
	
	self.UpdateBoatChargePosition = function(self) -- Charge badge is at the top. Boat badge goes as high as possible.
		if not self.boatmeter then return end
		
		if HAS_MOD.COMBINED_STATUS then -- Values based off combined status
			if self.charge.shown then self.boatmeter:SetPosition(-62, -139) -- temp position until status announcements is updated
			else self.boatmeter:SetPosition(-62, -52) end -- temp position until status announcements is updated
		else -- values based off defaults 
			if self.charge.shown then self.boatmeter:SetPosition(-80, -113)
			else self.boatmeter:SetPosition(-80, -40) end
		end
	end
	
	self.charge = self:AddChild(ChargeBadge(self, MOD_SETTINGS.FORMAT_CHARGE))
	self.charge:SetPosition(-80, -40)
	self.charge:Hide()
	
	self.onchargedelta = function(owner, data) self:ChargeDelta(data) end
	self.inst:ListenForEvent("chargechange", self.onchargedelta, self.owner)
	
	function self:SetChargePercent(val, max, stuck)
		self.charge:SetPercent(val, max, stuck)
	end
	
	function self:ChargeDelta(data)
		self:SetChargePercent(data.newval, data.max, data.stuck)
		
		if data.jump then
			self.charge:PulseRed()
			
			if self.owner then
				self.owner.SoundEmitter:PlaySound("dontstarve/characters/wx78/levelup")
			end
		end
		
		if data.newval <= 0 then
			self.charge:Hide()
		elseif data.newval > data.oldval then
			if not self.charge.shown then
				self.charge:Show()
			end
			
			self.charge:PulseGreen()
			_G.TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/health_up")
		end
	end
	
	local old_SetGhostMode = self.SetGhostMode
	self.SetGhostMode = function(self, ghostmode)
		if not self.isghostmode == not ghostmode then
			-- pass on to old_SetGhostMode
		elseif ghostmode then
			self.charge:Hide()
			self.charge:StopWarning()
		end
		
		old_SetGhostMode(self, ghostmode)
	end
	
	if self.boatmeter then -- Lazy way to make the boatmeter look good with the charge
		if not self.boatmeter.owner then self.boatmeter.owner = self end
		self.boatmeter.OnHide = function(self) self.owner:UpdateBoatChargePosition() end
		self.boatmeter.OnShow = function(self) self.owner:UpdateBoatChargePosition() end
		self.charge.OnHide = function(self) self.owner:UpdateBoatChargePosition() end
		self.charge.OnShow = function(self) self.owner:UpdateBoatChargePosition() end
		self:UpdateBoatChargePosition()
	end
	
	if HAS_MOD.COMBINED_STATUS then
		self.charge:SetPosition(-62, -52)
	end
	
	if HAS_MOD.VICTORIAN_HUD then -- Frame and background of the Victorian themed badge in Vitorian HUD
		self.charge.anim:GetAnimState():SetBank("vic_charge_meter")
		self.charge.anim:GetAnimState():SetBuild("vic_charge_meter")
		self.charge.anim:GetAnimState():PlayAnimation("anim")
	end
	if HAS_MOD.FORGE_HUD then -- Frame and background of the Forge themed badge in Forge HUD
		self.charge.anim:GetAnimState():SetBank("forge_charge_meter")
		self.charge.anim:GetAnimState():SetBuild("forge_charge_meter")
		self.charge.anim:GetAnimState():PlayAnimation("anim")
	end
end)

--------------------------------------------------------------------------------