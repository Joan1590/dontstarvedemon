local G = GLOBAL
local GA = G.ACTIONS

local auto_key = G[TUNING.xiaoyao("key_autoheal")]

-- Print debug messages if the player desires them.
local function DebugPrint(Message)
	if TUNING.xiaoyao("debug") then
		print("[修复键绑定调试] - "..Message)
	end
end

-- Stat lookup table (Will be populated later)
local PrefabToStats = {}

--[[
	
	item.replica.inventoryitem.classified.perish:value() /62

	<= 0.2 = Spoiled
	>0.2 <= 0.5 = Stale
	> 0.5 = Fresh

	Spoiled Modifiers:
		HP: 0x
		Hunger: 0.5x

	Stale Modifiers:
		HP: 0.333x
		Hunger: 0.667x


]]

-- Standard diet that most characters use
local function MakeDiet() return { herb = true, carn = true, none = true } end

-- Character facts table (Will be populated later)
-- (Yes, it's a carfax pun.)
local CharFacts = {}

-- Simple function which prevents the mod from attempting to edit a nil table
local function AlterDiet(Player,Type,Value)
	if CharFacts[Player] then
		CharFacts[Player].diet[Type] = Value
	end
end

-- Wait a bit so we can detect modded characters.
G.scheduler:ExecuteInTime(G.FRAMES*10,function()

	local NotCharacters = {random = true, unknown = true}
	local chars = {}
	for prefab,_ in pairs(G.STRINGS.CHARACTER_NAMES) do if not NotCharacters[prefab] then chars[#chars+1] = prefab end end
	for _,Char in pairs(chars) do
		CharFacts[Char] = {
			diet = MakeDiet(),
		}
	end

	-- Make some modifications to certain diets
	AlterDiet("wx78","gears",true)
	AlterDiet("wathgrithr","herb",false)
	AlterDiet("wurt","carn",false)

	-- Mod Compatibility
		-- Whimsy the Cheerful Sunflower
		AlterDiet("whimsy","herb",false)
		AlterDiet("whimsy","carn",false)


end)

-- These characters ignore spoilage factoring.
local SpoilageBeDamned = {
	["wx78"] = true,
}

-- Create a stat table
local function Stats(Health,Hunger,Sanity,Priority,Action,FoodType)
	return {hunger = Hunger or 0, sanity = Sanity or 0, health = Health or 0, priority = Priority or 1, action = Action or "EAT", foodtype = FoodType or "none",}
end

-- Clean function for assigning a stat table to a prefab
local function Add(Prefab,Health,Hunger,Sanity,Priority,Action,FoodType)
	PrefabToStats[Prefab] = Stats(Health,Hunger,Sanity,Priority,Action,FoodType)
	DebugPrint("Added "..Prefab.."!")
end

-- Item information gets added here

-- Prefab, Health, Hunger, Sanity, Priority, Action, Food Type

-- add jerky

-- Harmful Food
Add("blue_cap",20,12.5,-15,10,"EAT","herb")
Add("glommerfuel",40,9.375,-40,11,"EAT","herb")

-- Herbivores can eat these
Add("butterflywings",8,9.375,0,2,"EAT","herb")
Add("moonbutterflywings",8,9.375,15,4,"EAT","herb")
Add("butterflymuffin",20,37.5,5,1,"EAT","herb")
Add("butter",40,25,0,2,"EAT","herb")
Add("dragonpie",40,75,5,1,"EAT","herb")
Add("waffles",60,37.5,5,1,"EAT","herb")
Add("flowersalad",40,12.5,5,1,"EAT","herb")
Add("trailmix",30,12.5,5,1,"EAT","herb")
Add("fruitmedley",20,25,5,2,"EAT","herb")

-- Carnivores can eat these
Add("baconeggs",20,75,5,4,"EAT","carn")
Add("guacamole",20,37.5,0,2,"EAT","carn")
Add("turkeydinner",20,75,5,2,"EAT","carn")
Add("frogglebunwich",20,37.5,5,2,"EAT","carn")
Add("honeyham",30,75,5,2,"EAT","carn")
Add("perogies",40,37.5,5,1,"EAT","carn")
Add("fishsticks",40,37.5,5,1,"EAT","carn")
Add("honeynuggets",20,37.5,5,4,"EAT","carn")
Add("hotchili",20,37.5,0,5,"EAT","carn")
Add("meat_dried",20,25,15,1,"EAT","carn")
Add("smallmeat_dried",8,12.5,10,1,"EAT","carn")

-- Items
Add("spidergland",8,0,0,15,"HEAL","none")
Add("mosquitosack",8,0,0,15,"HEAL","none")
Add("healingsalve",20,0,0,15,"HEAL","none")
Add("bandage",30,0,0,15,"HEAL","none")

-- Check whether or not an item is in the player's diet
local function CanUseItem(Item)
	local P = G.ThePlayer.prefab
	return CharFacts[P].diet[PrefabToStats[Item.prefab].foodtype]
end

-- Break up a table for easy use
local function UnpackStats(str)
	local t = PrefabToStats[str]
	return t.health or 0,t.hunger or 0,t.sanity or 0,t.priority or 10,t.action or "EAT",t.foodtype or "none"
end

-- This priority list is based on spoilage & consumption speed.
-- I'm not sure how productive it is to use two priority systems simultaneously. but at this point, the code is too tangled for me to care.
local TypePriority = { ["none"] = 3, ["carn"] = 2, ["herb"] = 1 }
local function GetTypePriority(Item)
	if not Item then return 9 end
	return TypePriority[PrefabToStats[Item.prefab].foodtype]
end

-- When selecting a healing item, factor in spoilage!
local function GetModifiers(Item)
	local perish = Item.replica.inventoryitem.classified.perish:value() / 62
	local hp,hun,san = UnpackStats(Item.prefab)
	if SpoilageBeDamned[G.ThePlayer.prefab] or perish > 0.5 then -- fresh
		return hp,hun,san
	elseif perish > 0.2 then -- stale
		return hp*0.333,hun*0.667,0
	else -- spoiled
		return 0,hun*0.5,0
	end

end

-- Provide audio feedback if the player desires it
local function DoSound(Sound)
	if TUNING.xiaoyao("sound") and G.TheFrontEnd and G.TheFrontEnd.GetSound then
		G.TheFrontEnd:GetSound():PlaySound(Sound)
	end
end

-- A surprise tool that will help us later
local OldMaxHP = 0
local OldCurHP = 0
local MaxHP = 0
local CurHP = 0
local Itms = {}

-- When the player is deleted, reset all variables.
local function ResetEverything()
	DebugPrint("玩家删除检测-重置所有变量！")
	OldMaxHP,OldCurHP,MaxHP,CurHP,Itms = 0,0,0,0,{}
end

-- Check if something still exists
local function Exists(Ent)
	return Ent and Ent.IsValid and Ent:IsValid()
end

local function GetStackSize(Item)
	if Exists(Item) then
		if Item.replica and Item.replica.stackable and Item.replica.stackable._stacksize then
			return Item.replica.stackable._stacksize:value()
		else
			return 1
		end
	else
		return 2147483647
	end
end

-- Shorthand for seeing if the player is ingame yet
local function PE()
	return Exists(G.ThePlayer)
end

-- Stops keybind from activating while you're in menus
local function CanControl()
	return PE() and G.TheFrontEnd:GetActiveScreen().name == "HUD"
end

-- Clean function for getting healing item priority
local function GetPriority(fab)
	return PrefabToStats[fab].priority or 1
end

-- Deep-search containers for items.
local function AddItemsToTable(From,To)
	for _,Item in pairs(From) do
		if Item.replica.container then
			for _,SubItem in pairs(Item.replica.container:GetItems()) do
				if PrefabToStats[SubItem.prefab] then
					To[SubItem.GUID] = SubItem
				end
			end
		end
		if PrefabToStats[Item.prefab] then
			To[Item.GUID] = Item
		end
	end
end

-- Update the simplified inventory table
local function UpdateInv()
	if not PE() then return end

	Itms = {}
	local ActiveItem = G.ThePlayer.replica.inventory:GetActiveItem()

	AddItemsToTable(G.ThePlayer.replica.inventory:GetItems(),Itms)
	AddItemsToTable(G.ThePlayer.replica.inventory:GetEquips(),Itms)
	if ActiveItem and PrefabToStats[ActiveItem.prefab] then Itms[ActiveItem.GUID] = ActiveItem end

	DebugPrint("库存更新！")
end

--[[
-- Update when stack sizes are changed.
local function OnStackChanged(Player,Data)
	DebugPrint("Stack size changed for "..Data.item.prefab.."!")
end

-- Update when new items are picked up.
local function OnGetItem(Player,Data)
	DebugPrint("Obtained "..Data.item.prefab.."!")
end

-- Update when items are dropped.
local function OnLoseItem(Player,Data)
	if type(Data) == "table" and Data.slot then
		DebugPrint("Lost item in slot "..Data.slot.."! Prefab unknown. :(")
	end
end
]]

-- Update HP Variables every time the player's HP changes.
local function UpdateHP()
	if not PE() or OldCurHP == G.ThePlayer.replica.health:GetCurrent() then return end

	OldMaxHP = MaxHP
	OldCurHP = CurHP
	MaxHP = G.ThePlayer.replica.health:Max()
	CurHP = G.ThePlayer.replica.health:GetCurrent()

	DebugPrint("HP更新！"..OldCurHP.."/"..OldMaxHP.."更改为 "..CurHP.."/"..MaxHP)
end

-- Search through the simplified item table we made earlier for healing items.
local function FindHealingItem()
	UpdateInv()
	UpdateHP()
	local Healer = nil
	local Missing = math.ceil(MaxHP - CurHP)+0.51
	local Heal = 0

	for GUID,Item in pairs(Itms) do
		if CanUseItem(Item) and GetTypePriority(Item) <= GetTypePriority(Healer) then
			local hp,hun,san = GetModifiers(Item)
			if hp >= Heal and hp < Missing then
				if not Healer or (GetPriority(Healer.prefab) >= GetPriority(Item.prefab) and (Item.prefab ~= Healer.prefab or GetStackSize(Item) <= GetStackSize(Healer))) then
					Heal = hp
					Healer = Item
				end
			end
		end
	end

	return Healer
end

-- This code runs on keypress
local function DoAutoHeal()
	if not CanControl() then return end
	DebugPrint("治疗键按下！")
	local Item = FindHealingItem()

	if not Item then
		DebugPrint("要么没有找到物品，要么你的生命已经处于理想状态！")
		DoSound("不要在控制器上拖动/HUD/单击鼠标")
		return
	end

	DebugPrint("找到最佳治疗物品: "..Item.prefab.."!")
	DoSound("不暂停/HUD/单击“移动”")

	-- Some items require a different action.
	local sa = PrefabToStats[Item.prefab].action

	local rpc = G.RPC.ControllerUseItemOnSelfFromInvTile
	local action = G.BufferedAction(G.ThePlayer, nil, GA[sa], Item)

	if G.TheWorld.ismastersim then
		if G.ThePlayer.components.eater or sa ~= "EAT" then
			DebugPrint("运行服务器端代码，因为你是服务器！")
			G.ThePlayer.components.playercontroller:DoAction(action)
		else
			DebugPrint("无法运行服务器端代码-播放器缺少Eater组件")
		end
	else
		DebugPrint("正在将RPC发送到服务器！")
		G.SendRPCToServer(rpc,GA[sa].code,Item)
	end
end

G.TheInput:AddKeyDownHandler(auto_key,DoAutoHeal)

AddPlayerPostInit(function(p)
	-- Delay the function so G.ThePlayer has time to update
	p:DoTaskInTime(0,function()
		if PE() and p == G.ThePlayer then
			--DebugPrint("Player detected! - Running startup code!")
			-- These were used to update the inventory & hp, but then I realized how inefficient that was.
			-- It makes much more sense to update on keypress.
			--UpdateInv()
			--UpdateHP()
			--p:ListenForEvent("healthdelta",UpdateHP)
			--p:ListenForEvent("stacksizechange",OnStackChanged)
			--p:ListenForEvent("itemget",OnGetItem)
			--p:ListenForEvent("itemlose",OnLoseItem)

			p:ListenForEvent("onremove",ResetEverything)
		end
	end)
end)