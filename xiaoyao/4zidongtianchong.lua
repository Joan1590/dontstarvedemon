local _G = GLOBAL

local amulet_prefab = {
    yellowamulet =  "nightmarefuel",
	armorskeleton =  "nightmarefuel",
	minerhat =  "lightbulb",
	lantern	=  "lightbulb",
	molehat	=  "wormlight",
	molehat	=  "wormlight_lesser",
	thurible  =  "nightmarefuel",

}

local modconfig_autoaddfuelpercent = TUNING.xiaoyao("自动填充")
local modconfig_couldaddtwice = false
local AddFuelThread

local function GetItemPercentused(item)
    local classified = item.replica and item.replica._ and
                           item.replica._.inventoryitem and
                           item.replica._.inventoryitem.classified

    local percentused = classified and classified.percentused:value() or nil
    return percentused
end

local function GetItemFromPlayerInvAndBack(prefab)
    local invitems = _G.ThePlayer.replica.inventory:GetItems()
    local backpack
    if _G.EQUIPSLOTS.BACK then
        backpack = _G.ThePlayer.replica.inventory:GetEquippedItem(
                       _G.EQUIPSLOTS.BACK)
    else
        backpack = _G.ThePlayer.replica.inventory:GetEquippedItem(
                       _G.EQUIPSLOTS.BODY)
    end
    local packitems = backpack and backpack.replica.container and
                          backpack.replica.container:GetItems() or nil
    local itemlist = {}
    if invitems then
        for k, v in pairs(invitems) do
            if v.prefab == prefab then table.insert(itemlist, v) end
        end
    end
    if packitems then
        for k, v in pairs(packitems) do
            if v.prefab == prefab then table.insert(itemlist, v) end
        end
    end
    return itemlist
end

local function AddFuelAct(item, fuel)

    if item == nil or fuel == nil then return end

    local actions = fuel:GetIsWet() and _G.ACTIONS.ADDWETFUEL or
                        _G.ACTIONS.ADDFUEL

    local playercontroller = _G.ThePlayer.components.playercontroller
    local act = _G.BufferedAction(_G.ThePlayer, item, actions, fuel)
    local function cb()
        _G.SendRPCToServer(_G.RPC.ControllerUseItemOnItemFromInvTile,
                           actions.code, item, fuel)
    end
    if _G.ThePlayer.components.locomotor then
        act.preview_cb = cb
    else
        cb()
    end
    playercontroller:DoAction(act)
end

-- https://steamcommunity.com/sharedfiles/filedetails/?id=1581892848
local function Unequip(inst)
    if inst.replica.equippable:IsEquipped() then
        _G.ThePlayer.replica.inventory:ControllerUseItemOnSelfFromInvTile(inst)
    end

    if not inst.replica.equippable:IsEquipped() and inst.unequiptask ~= nil then
        inst.unequiptask:Cancel()
        inst.unequiptask = nil
    end

end

local function KillAddFuelThread()
    if AddFuelThread then
        AddFuelThread:SetList(nil)
        AddFuelThread = nil
    end
end

local function StartAddFuelThread(inst)
    KillAddFuelThread()
	if not _G.ThePlayer then return end
    AddFuelThread = _G.ThePlayer:StartThread(
                        function()
            while true do

                local item = inst.entity and inst.entity:GetParent()
                local percentused = item and GetItemPercentused(item) or 0

                if item and _G.ThePlayer.replica.inventory:IsHolding(item) and
                    item.replica.equippable:IsEquipped() and percentused <=
                    modconfig_autoaddfuelpercent then

                    local fuel = GetItemFromPlayerInvAndBack(amulet_prefab[item.prefab])

					if _G.next(fuel) then
						if percentused <= 3 then -- 3%强制取下
							item.unequiptask =
								item:DoPeriodicTask(0, function()
									Unequip(item)
								end)
							Unequip(item)
							break
						elseif percentused <= 50 then -- 小于50%强制加燃料
							AddFuelAct(item, fuel[1])
							break
						elseif not _G.ThePlayer:HasTag("moving") then -- 正常情况下不移动时加燃料
							AddFuelAct(item, fuel[1])
							break
						end
					end
				else
					break
                end
                _G.Sleep(0)

            end
        end)
end

local function fn(inst)
    local item = inst.entity:GetParent()

    if item and amulet_prefab[item.prefab] ~= nil then
        inst:ListenForEvent("percentuseddirty",
                            function(inst) StartAddFuelThread(inst) end)

    end
end

AddPrefabPostInit("inventoryitem_classified", function(inst)
    inst:DoTaskInTime(0, function() fn(inst) end)
end)
