local require = GLOBAL.require
local BossIndicator = require ("widgets/bossindicator")


GLOBAL.MOD_BOSSINDICATORS = {}

GLOBAL.MOD_BOSSINDICATORS.BOSSES = {}

local function RGB(r, g, b)
    return { r / 255, g / 255, b / 255, 1 }
end

local BOSS_COLOURS =
{
	deerclops 			= RGB(255,255,255),
	bearger 			= RGB(100,100,100),
	dragonfly 			= RGB(0,220,60),
	moose 				= RGB(200,180,140),
	minotaur 			= RGB(180,160,120),
	toadstool			= RGB(170,80,255),
	toadstool_cap 		= RGB(170,80,255),
	antlion 			= RGB(255,140,0),
	klaus 				= RGB(240,70,70),
	klaus_sack 			= RGB(255,255,255)
}

AddClassPostConstruct("screens/playerhud", function(self)

	self.AddBossIndicator = function(self, target)
		if not self.bossindicators then
			self.bossindicators = {}
		end

		local bi = self.under_root:AddChild(BossIndicator(self.owner, target, BOSS_COLOURS[target.prefab]))
		table.insert(self.bossindicators, bi)
	end
		
	self.HasBossIndicator = function(self, target)
		if not self.bossindicators then return end

		for i,v in pairs(self.bossindicators) do
			if v and v:GetTarget() == target then
				return true
			end
		end
		return false
	end
	
	self.RemoveBossIndicator = function(self, target)
		 if not self.bossindicators then return end

		local index = nil
		for i,v in pairs(self.bossindicators) do
			if v and v:GetTarget() == target then
				index = i
				break
			end
		end
		if index then
			local bi = table.remove(self.bossindicators, index)
			if bi then bi:Kill() end
		end
	end
end)

AddPlayerPostInit(function(inst)
	inst:AddComponent("playerbossindicator")
end)

local Bosses = {"deerclops", "bearger", "dragonfly", "moose", "minotaur", "toadstool", "antlion", "klaus", "klaus_sack"}

local function AddBossToIndicatorTable(inst)
	table.insert(GLOBAL.MOD_BOSSINDICATORS.BOSSES, inst)
end

local function RemoveBossFromIndicatorTable(inst)
	local index = nil
	for i,v in ipairs(GLOBAL.MOD_BOSSINDICATORS.BOSSES) do
		if v == inst then
			index = i
			break
		end
	end
	if index then table.remove(GLOBAL.MOD_BOSSINDICATORS.BOSSES, index) end
end

local function SetupBossIndicator(inst)
	AddBossToIndicatorTable(inst)
	inst:ListenForEvent("onremove", function(inst)
		RemoveBossFromIndicatorTable(inst)
	end)
end

for i,v in ipairs(Bosses) do
	AddPrefabPostInit(v, function(inst)
		print("I exist", inst)
		SetupBossIndicator(inst)
	end)
end

local Toadstool_Cap = nil

AddPrefabPostInit("toadstool", function(inst)
	AddBossToIndicatorTable(inst)
	-- Remove toadstool_cap indicator
	if Toadstool_Cap then
		RemoveBossFromIndicatorTable(Toadstool_Cap)
	end
	
	inst:ListenForEvent("onremove", function(inst)
		RemoveBossFromIndicatorTable(inst)
		
		-- Re-add toadstool_cap indicator
		if Toadstool_Cap then
			AddBossToIndicatorTable(Toadstool_Cap)
		end
	end)
end)

AddPrefabPostInit("toadstool_cap", function(inst)
	inst:DoTaskInTime(0.1, function(inst)
		if inst._state:value() > 0 then
			AddBossToIndicatorTable(inst)
			Toadstool_Cap = inst
		end
	end)
end)
