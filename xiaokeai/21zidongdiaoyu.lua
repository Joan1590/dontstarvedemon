local _G = GLOBAL

local UpvalueHacker = _G.require("upvaluehacker")

local MODCONFIG_OPTIMUMPOS = TUNING.xiaoyao("optimumpos")
local MODCONFIG_AUTOREEL = TUNING.xiaoyao("autoreel")
local MODCONFIG_FISHTIPS = TUNING.xiaoyao("fishtips")

local LURES, FISHES

-- 获取玩家手上的鱼竿实体
local function GetFishingRodInHands()
    local fishingrod = _G.ThePlayer.replica.inventory:GetEquippedItem(
                           _G.EQUIPSLOTS.HANDS)
    if fishingrod and fishingrod.replica.oceanfishingrod then
        return fishingrod
    end
end

-- 获取当前饵料实体
local function GetLureNowUse()
    local fishingrod = GetFishingRodInHands()
    local lure
	if fishingrod then
		lure = fishingrod.replica.container:GetItems()[2]
	end
	return lure
end

-- 获取某种鱼饵针对某种鱼的效力,同时考虑是否抖饵
function GetLureEffFish(lureprefab, fishprefab, notreel)
    if not (lureprefab and fishprefab) then return 0 end

    -- 获取饵料本身效力因素
    lureprefab = lureprefab == "berries_juicy" and "berries" or lureprefab
    local lure = LURES[lureprefab]
    if lure == nil then lure = TUNING.OCEANFISHING_LURE.HOOK end

    -- 获取鱼种类对效力的影响因素
    local fish_lure_prefs
    if FISHES[fishprefab] ~= nil then
        fish_lure_prefs = FISHES[fishprefab].lures
    elseif fishprefab == "wobster_sheller" then
        fish_lure_prefs = TUNING.OCEANFISH_LURE_PREFERENCE.WOBSTER
    elseif fishprefab == "wobster_moonglass" then
        fish_lure_prefs = TUNING.OCEANFISH_LURE_PREFERENCE.WOBSTER
    end

    local weather = _G.TheWorld.state.israining and "raining" or
                        _G.TheWorld.state.issnowing and "snowing" or "default"

    local mod = (lure.timeofday ~= nil and
                    lure.timeofday[_G.TheWorld.state.phase] or 0) *
                    (fish_lure_prefs == nil and 1 or lure.style ~= nil and
                        fish_lure_prefs[lure.style] or 0) *
                    (lure.weather ~= nil and lure.weather[weather] or
                        TUNING.OCEANFISHING_LURE_WEATHER_DEFAULT[weather] or 1)

    local reel_charm = lure.reel_charm or 0
    local reel_eff = (lure.charm + reel_charm) * mod
    local notreel_eff = lure.charm * mod

    local eff = notreel and notreel_eff or reel_eff
    eff = eff and eff < 0 and 0 * 0 or eff

    return eff
end

-- 获取已知所有饵料针对某种鱼的效果列表
local function GetAllLureEffs(fishprefab, treeltype)
    if not fishprefab then return end
    local eff_treel = {}
    local eff_nottreel = {}
    local eff_mergetreel = {}
    local eff_mergetreel_cache = {}

    for k, v in pairs(LURES) do
        if v then
            local efficiency = GetLureEffFish(k, fishprefab, nil)
            table.insert(eff_treel, {prefab = k, efficiency = efficiency})
        end
    end

    for k, v in pairs(LURES) do
        if v then
            local efficiency = GetLureEffFish(k, fishprefab, true)
            table.insert(eff_nottreel, {prefab = k, efficiency = efficiency})
        end
    end

    for k, v in pairs(Tab_MergeTables(eff_treel, eff_nottreel)) do
        if v and v.prefab then
            local efficiency = v.efficiency
            local efficiency_cache = eff_mergetreel_cache[v.prefab] or -1 / 0
            if efficiency > efficiency_cache then
                eff_mergetreel_cache[v.prefab] = efficiency
            end
        end
    end

    for k, v in pairs(eff_mergetreel_cache) do
        if v then
            table.insert(eff_mergetreel, {prefab = k, efficiency = v})
        end
    end

    if treeltype == 1 then
        return eff_treel
    elseif treeltype == 2 then
        return eff_nottreel
    else
        return eff_mergetreel
    end

end

-- 获取身上饵料效果最高的饵料包括已经装备的饵料
local function GetBetterLureInInv(fishprefab)
    if not fishprefab then return end
    local lureefflist = GetAllLureEffs(fishprefab, nil)
    local best = {0, nil}
    local lures = _G.ThePlayer.replica.inventory:GetItems()
    local nowlure = GetLureNowUse()
    table.insert(lures, nowlure)
    for _, v in pairs(lures) do
        if v:HasTag("oceanfishing_lure") then
            local efficiency = 0
            if v and v.prefab then
                for _, v2 in pairs(lureefflist) do
                    if v2 and v2.prefab and v2.prefab == v.prefab then
                        efficiency = v2.efficiency
                        break
                    end
                end
            end
            if best[1] < efficiency then best = {efficiency, v} end
        end
    end
    return best and best[2]
end

local function GetBetterLureSortTab(fishprefab)
    if not fishprefab then return end
    local lureefflist = GetAllLureEffs(fishprefab, nil)

    table.sort(lureefflist, function(a, b)
        a = a.efficiency
        b = b.efficiency
        return a > b
    end)

    return lureefflist
end

local function FindFishes(x, z)
    local fishess = _G.TheSim:FindEntities(x, 0, z, 4, {"oceanfishable"},
                                        {"INLIMBO"})
    return fishess and _G.next(fishess) and fishess[1] or nil
end

local function GetPrefabFancyName(prefab)
    return _G.STRINGS.NAMES[string.upper(prefab)] or prefab
end

local function OutMessage(x, z)
    local fish = FindFishes(x, z)
    if fish then
        local nowlure = GetLureNowUse()
        local best_now = GetBetterLureInInv(fish.prefab)
        local best_list = GetBetterLureSortTab(fish.prefab)

        local fishname = fish and fish:GetBasicDisplayName() or "uk"

        local nowlurename = nowlure and nowlure:GetBasicDisplayName()
        nowlurename = nowlurename and nowlurename .. " " ..
                          GetLureEffFish(nowlure.prefab, fish.prefab) .. "/" ..
                          GetLureEffFish(nowlure.prefab, fish.prefab, true) or
                          "uk"

        local best_now_name = best_now and best_now:GetBasicDisplayName()
        best_now_name = best_now_name and best_now_name .. " " ..
                            GetLureEffFish(best_now.prefab, fish.prefab) .. "/" ..
                            GetLureEffFish(best_now.prefab, fish.prefab, true) or
                            "uk"

        local best_list_name
        for k, v in ipairs(best_list) do
            local addtext = string.format("%s %s\n",
                                          GetPrefabFancyName(v.prefab),
                                          GetLureEffFish(v.prefab, fish.prefab) ..
                                              "/" ..
                                              GetLureEffFish(v.prefab,
                                                             fish.prefab, true))
            best_list_name = best_list_name and best_list_name .. addtext or
                                 addtext
            if k == 10 then break end
        end
        best_list_name = best_list_name or "uk"

        local text = [[
目标鱼类:%s
当前使用鱼饵:%s
推荐使用鱼饵:%s
当前该鱼类全鱼饵综合排名(前10):
(斜杠后为不抖饵时的吸引度)
 
名称 抖饵效果\不抖饵效果
%s
]]
        text = string.format(text, fishname, nowlurename, best_now_name,
                             best_list_name)
        print(text)

        local best_list_name2
        for k, v in ipairs(best_list) do
            local addtext = string.format("%s %s\n",
                                          GetPrefabFancyName(v.prefab),
                                          GetLureEffFish(v.prefab, fish.prefab) ..
                                              "/" ..
                                              GetLureEffFish(v.prefab,
                                                             fish.prefab, true))
            best_list_name2 = best_list_name2 and best_list_name2 .. addtext or
                                  addtext
            if k == 4 then break end
        end
        best_list_name2 = best_list_name2 or "uk"

        local textsay = string.format("%s N:%s\n%s", fishname, nowlurename,
                                      best_list_name2)

        _G.ThePlayer.components.talker:Say(textsay)
    end
end

local function Fishing_Act(rpc, act, rod, pos)
    if not (rpc and act and pos) then return end

    local playercontroller = _G.ThePlayer.components.playercontroller
    local bufferact = _G.BufferedAction(_G.ThePlayer, nil, act, rod, pos)
    local function cb() _G.SendRPCToServer(rpc, act.code, pos.x, pos.z) end
    if _G.ThePlayer.components.locomotor then
        bufferact.preview_cb = cb
        playercontroller:DoAction(bufferact)
    else
        cb()
    end
end

local function Fishing_IsLineTensionHigh()
    local fishingrod = GetFishingRodInHands()
    if fishingrod then
        return fishingrod.replica.oceanfishingrod:IsLineTensionHigh()
    end
end

local function Fishing_GetFishingTarget()
    local fishingrod = GetFishingRodInHands()
	if fishingrod then
		return fishingrod.replica.oceanfishingrod:GetTarget()
	end
end

local function Fishing_PeriodTask()
    local fishingrod = GetFishingRodInHands()
    if fishingrod then
		local fish = Fishing_GetFishingTarget()
		if fish and fish:HasTag("oceanfishable") then
			if not Fishing_IsLineTensionHigh() then
				local pos = fish:GetPosition()
				if fish:HasTag("oceachfishing_catchable") then
					Fishing_Act(_G.RPC["RightClick"],
								_G.ACTIONS.OCEAN_FISHING_CATCH, fishingrod,pos)
				else
					Fishing_Act(_G.RPC["RightClick"], _G.ACTIONS.OCEAN_FISHING_REEL,fishingrod,
								pos)
				end
			end
		end
	end
end

local function GetBetterPos(px, pz, tx, tz)
    if not (px and pz and tx and tz) then return end

    local pt_d = _G.math.sqrt((tx - px) * (tx - px) + (tz - pz) * (tz - pz))

    for i = 0, 5, 0.001 do
        local nx = (tx - px) * i / pt_d + px
        local nz = (tz - pz) * i / pt_d + pz
        if _G.distsq(px, pz, nx, nz) >= 7.4 then return nx, nz end
    end
    return nil
end

local function ChoosePos(tx, tz)
    local p1x, _, p1z = _G.ThePlayer.Transform:GetWorldPosition()

    if _G.math.sqrt((p1x - tx) * (p1x - tx) + (p1z - tz) * (p1z - tz)) <= 4 then
        local x, z = GetBetterPos(p1x, p1z, tx, tz)
        if x and z then
			local pos = _G.Vector3(x, 0, z)
			local fishingrod = GetFishingRodInHands()
			if fishingrod then
				Fishing_Act(_G.RPC["RightClick"], _G.ACTIONS.OCEAN_FISHING_CAST, fishingrod,pos)
			end
            return true
        end
    end
    return false

end

local function main()
    if MODCONFIG_OPTIMUMPOS then
        local function CanCastFishingNetAtPoint(thrower, target_x, target_z)
            local min_throw_distance = 0 -- 2.9 or 2 
            local thrower_x, _, thrower_z = thrower.Transform:GetWorldPosition()

            if _G.TheWorld.Map:IsOceanAtPoint(target_x, 0, target_z) and
                _G.VecUtil_LengthSq(target_x - thrower_x, target_z - thrower_z) >
                min_throw_distance * min_throw_distance then
                return true
            end
            return false
        end

        local _COMPONENT_ACTIONS = UpvalueHacker.GetUpvalue(
                                       _G.EntityScript.CollectActions,
                                       "COMPONENT_ACTIONS")
        UpvalueHacker.SetUpvalue(_COMPONENT_ACTIONS.POINT.oceanfishingrod,
                                 CanCastFishingNetAtPoint,
                                 "CanCastFishingNetAtPoint")
    end

    AddComponentPostInit("playercontroller", function(PlayerController, inst)
        if MODCONFIG_AUTOREEL then
            inst:DoPeriodicTask(.6, Fishing_PeriodTask)
        end

        local old_OnRightClick = PlayerController.OnRightClick
        function PlayerController:OnRightClick(a, ...)
            if a == true then
                local act = PlayerController:GetRightMouseAction()
                local position = _G.TheInput:GetWorldPosition()

                if act and act.action and act.action ==
                    _G.ACTIONS.OCEAN_FISHING_CAST then
                    if MODCONFIG_FISHTIPS then
                        OutMessage(position.x, position.z)
                    end
                    if MODCONFIG_OPTIMUMPOS and
                        ChoosePos(position.x, position.z) then
                        return
                    end
                end
            end
            old_OnRightClick(PlayerController, a, ...)
        end

        local old_OnLeftClick = PlayerController.OnLeftClick
        function PlayerController:OnLeftClick(a, ...)
            if a == true then
                local act = PlayerController:GetRightMouseAction()
                local position = _G.TheInput:GetWorldPosition()

                if act and act.action and act.action.code and act.action.code ==
                    _G.ACTIONS.STOP_STEERING_BOAT.code and
                    GetFishingRodInHands() then
                    if MODCONFIG_FISHTIPS then
                        OutMessage(position.x, position.z)
                    end
                end
            end
            old_OnLeftClick(PlayerController, a, ...)
        end

    end)

    local lures = {}
    local oceanfishinglure = {
        _G.assert(_G.loadfile("prefabs/oceanfishinglure"))()
    }
    if oceanfishinglure then
        for _, v in pairs(oceanfishinglure) do
            local lure = UpvalueHacker.GetUpvalue(v.fn, "name")
            local data = UpvalueHacker.GetUpvalue(v.fn, "v")
            lures[lure] = data.lure_data
        end
    end

    LURES = lures

    for k, v in pairs(TUNING.OCEANFISHING_LURE) do
        if k == "SEED" then
            LURES["seeds"] = v
        elseif k == "BERRY" then
            LURES["berries"] = v
        elseif k == "SPOILED_FOOD" then
            LURES["spoiled_food"] = v
        end
    end

    FISHES = _G.assert(_G.loadfile("prefabs/oceanfishdef"))().fish
end

main()

function Tab_MergeTables(...)
    local tabs = {...}
    if not tabs then return {} end
    local origin = tabs[1]
    for i = 2, #tabs do
        if origin then
            if tabs[i] then
                for k, v in pairs(tabs[i]) do
                    table.insert(origin, v)
                end
            end
        else
            origin = tabs[i]
        end
    end
    return origin
end

--[[
local function canlinetension(x,z,x2,z2)
	local target_dist = _G.math.sqrt((x-x2)*(x-x2)+(z-z2)*(z-z2))
	local line_tension = tension_offset > 0 and math.min(max_tension_rating, (1 + 1/max_offset) - (1 + 1/max_offset)/(tension_offset + 1)) or 0
end

local function GetBetterPos()
    local x, _, z = _G.ThePlayer.Transform:GetWorldPosition()
    local length = 5
	local step = 0.05
	local distance_min = 1/0
	local distance_min_posx
	local distance_min_posz
    for x2 = x-length/2, x+length/2, step do
        for z2 = z-length/2, z+length/2, step do
            local cando = CanCastFishingNetAtPoint(_G.ThePlayer, x2, z2)
            if cando then
				local distance = _G.math.sqrt((x-x2)*(x-x2)+(z-z2)*(z-z2))
				if distance < distance_min then
				distance_min = distance 
				distance_min_posx = x2
				distance_min_posz = z2
				end
			end	
        end
    end
	return distance_min_posx,distance_min_posz
end

_G.TheInput:AddKeyUpHandler(_G.KEY_Z, function()
end)
--]]
