local _G = GLOBAL
local TheInput = GLOBAL.TheInput
local TheWorld = GLOBAL.TheWorld
local RPC = GLOBAL.RPC
local SendRPCToServer = GLOBAL.SendRPCToServer
local ACTIONS = GLOBAL.ACTIONS
local TheNet = GLOBAL.TheNet
local TheSim = GLOBAL.TheSim
local EQUIPSLOTS = GLOBAL.EQUIPSLOTS
local Sleep = _G.Sleep
local FRAMES = _G.FRAMES
local ThePlayer
local y_offset = 2
local default_font = 12
local MUSTHAVE_TAGS = TUNING.xiaoyao("show_critterowner") and {} or {"_combat"}
local CANTHAVE_TAGS = {"bird","wall","glommer","butterfly","berrythief","rabbit","mole","grassgekko","chester","hutch","player"}
local MUSTONEOF_TAGS = TUNING.xiaoyao("show_critterowner") and {"_combat","critter","woby"} or {"_health"}
local show_specialcolours = TUNING.xiaoyao("show_specialcolours")
local colour_mobaggroyou = TUNING.xiaoyao("colour_mobaggroyou")
local colour_mobaggroplayer = TUNING.xiaoyao("colour_mobaggroplayer")
local colour_mobfriendyou = TUNING.xiaoyao("colour_mobfriendyou")
local colour_mobfriendother = TUNING.xiaoyao("colour_mobfriendother")
local colour_mobaggrofollower = TUNING.xiaoyao("colour_mobaggrofollower")
--local default_showaggro = TUNING.xiaoyao("默认仇恨")
--local default_befriended = TUNING.xiaoyao("default_befriended")

fanweixianshi = TUNING.xiaoyao("范围显示")

local function InGame()
return GLOBAL.ThePlayer and GLOBAL.ThePlayer.HUD and not GLOBAL.ThePlayer.HUD:HasInputFocus()
end

local function IsHUDScreen()
	local defaultscreen = false
	if TheFrontEnd:GetActiveScreen() and TheFrontEnd:GetActiveScreen().name and type(TheFrontEnd:GetActiveScreen().name) == "string" and TheFrontEnd:GetActiveScreen().name == "HUD" then
		defaultscreen = true
	end
	return defaultscreen
end

TheInput:AddKeyDownHandler(fanweixianshi, function() 
	if not TheWorld then return end
	if not IsHUDScreen() then return end
	xianshi = not xianshi
	TheWorld:PushEvent("开关攻击范围") 
	
end)

local mob_fontsize = {
    --[[["eyeplant"] = 10,
    ["spider"] = 10,
    ["spider_warrior"] = 10,
    ["spider_hider"] = 10,
    ["spider_spitter"] = 10,
    ["spider_dropper"] = 10,
    ["spider_moon"] = 10,
    ["shadowtentacle"] = 10,
    ["birchnutdrake"] = 10,
    ["cookiecutter"] = 10,
    ["little_walrus"] = 10,
    ["abigail"] = 12,
    ["bee"] = 12,
    ["killerbee"] = 12,
    ["mosquito"] = 12,
    ["abigail"] = 12,
    ["ghost"] = 14,
    ["hound"] = 14,
    ["firehound"] = 14,
    ["icehound"] = 14,
    ["moonhound"] = 14,
    ["mutatedhound"] = 14,
    ["bat"] = 16,
    ["beefalo"] = 16,
    ["bunnyman"] = 16,
    ["bishop"] = 16,
    ["bishop_nightmare"] = 16,
    ["knight"] = 16,
    ["knight_nightmare"] = 16,
    ["rook"] = 16,
    ["rook_nightmare"] = 16,
    ["worm"] = 16,
    ["rocky"] = 16,
    ["spiderqueen"] = 16,
    ["antlion"] = 16,
    ["minotaur"] = 18,
    ["spat"] = 18,
    ["koalefant_summer"] = 18,
    ["koalefant_winter"] = 18,
    ["eyeturret"] = 18,
    ["krampus"] = 18,
    ["warg"] = 18,
    ["deerclops"] = 28,
    ["bearger"] = 28,
    ["dragonfly"] = 28,
    ["moose"] = 28,
    ["stalker"] = 28,
    ["stalker_atrium"] = 28,
    ["klaus"] = 28,
    ["crabking"] = 28,]]--This wasn't applying properly, however it seems that it was a good thing. The fonts can be annoyingly big and even though some were too big for small mobs like spiders, it was still ok.
    ["default"] = 18,
}
--[[
local function ChangeMobFont(aggressor)
  if aggressor.prefab == "abigail" or aggressor.prefab == "bee" or aggressor.prefab == "killerbee" or aggressor.prefab == "mosquito" or aggressor.prefab == "abigail" or aggressor.prefab == "abigail" then
    default_font = 12
  elseif aggressor.prefab == "minotaur" or aggressor.prefab == "spat" or aggressor.prefab == "koalefant_summer" or "koalefant_winter" or aggressor.prefab == "eyeturret" or aggressor.prefab == "krampus" or aggressor.prefab == "warg" then
    default_font = 18
elseif aggressor.prefab == "bat" or aggressor.prefab == "beefalo" or aggressor.prefab == "bunnyman" or aggressor.prefab == "bishop" or aggressor.prefab == "bishop_nightmare" or aggressor.prefab == "knight" or aggressor.prefab == "knight_nightmare" or aggressor.prefab == "rook" or aggressor.prefab == "rook_nightmare" or aggressor.prefab == "worm" or aggressor.prefab == "rocky" or aggressor.prefab == "spiderqueen" or aggressor.prefab == "antlion" then
    default_font = 16
elseif aggressor.prefab == "deerclops" or aggressor.prefab == "bearger" or aggressor.prefab == "dragonfly" or aggressor.prefab == "moose" or aggressor.prefab == "stalker" or aggressor.prefab == "stalker_atrium" or aggressor.prefab == "klaus" or aggressor.prefab == "crabking" then
    default_font = 28
elseif aggressor.prefab == "ghost" or aggressor.prefab == "hound" or aggressor.prefab == "firehound" or aggressor.prefab == "icehound" or aggressor.prefab == "moonhound" or aggressor.prefab == "mutatedhound" then
    default_font = 14
elseif aggressor.prefab == "little_walrus" then
    default_font = 10
elseif aggressor.prefab == "eyeplant" or aggressor.prefab == "spider" or aggressor.prefab == "spider_warrior" or aggressor.prefab == "spider_hider" or aggressor.prefab == "spider_spitter" or aggressor.prefab == "spider_dropper" or aggressor.prefab == "spider_moon" or aggressor.prefab == "shadowtentacle" or aggressor.prefab == "birchnutdrake" or aggressor.prefab == "cookiecutter" then
    default_font = 0.5
elseif aggressor.prefab == "" then

else
default_font = 12
  end
end
]]
--elseif aggressor.prefab == "eyeplant" or aggressor.prefab == "cookiecutter" then
local mob_offset = {
    ["eyeplant"] = 1,
    ["cookiecutter"] = 1,
    ["wobysmall"] = 1,
    ["bee"] = 1.5,
    ["killerbee"] = 1.5,
    ["worm"] = 1.5,
    ["frog"] = 1.5,
    ["mosquito"] = 1.5,
    ["spider"] = 1.5,
    ["spider_warrior"] = 1.5,
    ["spider_hider"] = 1.5,
    ["spider_spitter"] = 1.5,
    ["spider_dropper"] = 1.5,
    ["spider_moon"] = 1.5,
    ["smallbird"] = 1.5,
    ["catcoon"] = 1.5,
    ["birchnutdrake"] = 1.5,
    ["lavae"] = 1.5,
    ["fruitdragon"] = 1.5,
    ["little_walrus"] = 2.5,
    ["merm"] = 2.5,
    ["mermguard"] = 2.5, 
    ["pigman"] = 2.5,
    ["pigguard"] = 2.5,
    ["moonpig"] = 2.5,
    ["bat"] = 3,
    ["beefalo"] = 3,
    ["bunnyman"] = 3,
    ["knight"] = 3,
    ["knight_nightmare"] = 3,
    ["rook"] = 3,
    ["rook_nightmare"] = 3,
    ["rocky"] = 3,
    ["crawlinghorror"] = 3,
    ["crawlingnightmare"] = 3,
    ["deer_red"] = 3,
    ["deer_blue"] = 3,
    ["wobybig"] = 3,
    ["walrus"] = 3.5,
    ["abigail"] = 3.8,
    ["bishop"] = 4,
    ["bishop_nightmare"] = 4,
    ["spat"] = 4,
    ["ghost"] = 4,
    ["koalefant_summer"] = 4,
    ["koalefant_winter"] = 4,
    ["eyeturret"] = 4,
    ["krampus"] = 4,
    ["nightmarebeak"] = 4,
    ["terrorbeak"] = 4,
    ["spiderqueen"] = 4,
    ["teenbird"] = 4,
    ["warg"] = 4,
    ["lightninggoat"] = 4,
    ["antlion"] = 4,
    ["minotaur"] = 5,
    ["tallbird"] = 5,
    ["toadstool"] = 6,
    ["toadstool_dark"] = 6,
    ["klaus"] = 6,
    ["dragonfly"] = 8,
    ["beequeen"] = 8,
    ["leif"] = 8,
    ["leif_sparse"] = 8,
    ["stalker"] = 8,
    ["stalker_atrium"] = 8,
    ["crabking"] = 8,
    ["deerclops"] = 10,
    ["bearger"] = 10,
    ["malbatross"] = 10,
    ["moose"] = 14,
    ["default"] = 2,
    -------Forge-------
    ["crocommander_rapidfire"] = 3,
    ["crocommander"] = 3,
    ["scorpeon"] = 3,
    ["boarilla"] = 4,
    ["rhinocebro"] = 4,
    ["rhinocebro2"] = 4,
    ["boarrior"] = 5,
    ["swineclops"] = 5,
    -------------------
}
--[[
local function ChangeMobOffset(aggressor)
  if aggressor.prefab == "abigail" then
    y_offset = 3.8
  elseif aggressor.prefab == "minotaur" or aggressor.prefab == "tallbird" then
    y_offset = 5
elseif aggressor.prefab == "bat" or aggressor.prefab == "beefalo" or aggressor.prefab == "bunnyman" or aggressor.prefab == "knight" or aggressor.prefab == "knight_nightmare" or aggressor.prefab == "rook" or aggressor.prefab == "rook_nightmare" or aggressor.prefab == "rocky" or aggressor.prefab == "crawlinghorror" or aggressor.prefab == "crawlingnightmare" or aggressor.prefab == "deer_red" or aggressor.prefab == "deer_blue" then
    y_offset = 3
elseif aggressor.prefab == "bishop" or aggressor.prefab == "bishop_nightmare" or aggressor.prefab == "spat" or aggressor.prefab == "ghost" or aggressor.prefab == "koalefant_summer" or aggressor.prefab == "koalefant_winter" or aggressor.prefab == "eyeturret" or aggressor.prefab == "krampus" or aggressor.prefab == "nightmarebeak" or aggressor.prefab == "terrorbeak" or aggressor.prefab == "spiderqueen" or aggressor.prefab == "teenbird" or aggressor.prefab == "warg" or aggressor.prefab == "lightninggoat" or aggressor.prefab == "antlion" then
    y_offset = 4
elseif aggressor.prefab == "bee" or aggressor.prefab == "killerbee" or aggressor.prefab == "worm" or aggressor.prefab == "frog" or aggressor.prefab == "mosquito"  or aggressor.prefab == "spider" or aggressor.prefab == "spider_warrior" or aggressor.prefab == "spider_hider" or aggressor.prefab == "spider_spitter" or aggressor.prefab == "spider_dropper" or aggressor.prefab == "spider_moon" or aggressor.prefab == "smallbird" or aggressor.prefab == "catcoon" or aggressor.prefab == "birchnutdrake" or aggressor.prefab == "lavae" or aggressor.prefab == "fruitdragon" then
    y_offset = 1.5
elseif aggressor.prefab == "deerclops" or aggressor.prefab == "bearger" or aggressor.prefab == "malbatross" then
    y_offset = 10
elseif aggressor.prefab == "dragonfly" or aggressor.prefab == "beequeen" or aggressor.prefab == "leif" or aggressor.prefab == "leif_sparse" or aggressor.prefab == "stalker" or aggressor.prefab == "stalker_atrium" or aggressor.prefab == "crabking" then
    y_offset = 8
elseif aggressor.prefab == "toadstool" or aggressor.prefab == "toadstool_dark" or aggressor.prefab == "klaus" then
    y_offset = 6
elseif aggressor.prefab == "moose" then --Tallboi
    y_offset = 14
elseif aggressor.prefab == "walrus" then
    y_offset = 3.5
elseif aggressor.prefab == "little_walrus" or aggressor.prefab == "merm" or aggressor.prefab == "mermguard" or aggressor.prefab == "pigman" or aggressor.prefab == "pigguard" or aggressor.prefab == "moonpig" then
    y_offset = 2.5
elseif aggressor.prefab == "eyeplant" or aggressor.prefab == "cookiecutter" then
    y_offset = 1
------The Forge-------------
elseif aggressor.prefab == "crocommander_rapidfire" or aggressor.prefab == "crocommander" or aggressor.prefab == "scorpeon" then
y_offset = 3
elseif aggressor.prefab == "boarilla" or aggressor.prefab == "rhinocebro" or aggressor.prefab == "rhinocebro2" then
y_offset = 4
elseif aggressor.prefab == "boarrior" or aggressor.prefab == "swineclops" then
y_offset = 5
----------------------------
  
else
y_offset = 2
  end
  end
]]
local missingname_name = {
    ["stalker_forest"] = "森林守护者",
    ["stalker"] = "复活的骨架",
    ["stalker_atrium"] = "暗影中庭",
    ["shadowminer"] = "暗影矿工",
    ["shadowdigger"] = "暗影挖掘者",
    ["shadowlumber"] = "暗影伐木工",
    ["shadowduelist"] = "暗影角斗士",
    ["wobster_sheller_land"] = "龙虾",
    ["wobster_moonglass_land"] = "月光龙虾",
}
--[[
      if aggressee.prefab == "stalker_forest" or aggressee.prefab == "stalker" or aggressee.prefab == "stalker_atrium" then
      v.entity:AddLabel():SetText(string.format("Aggro: %s","Reanimated Skeleton"))
    elseif aggressee.prefab == "shadowminer" then
      v.entity:AddLabel():SetText(string.format("Aggro: %s","Shadow Miner"))
    elseif aggressee.prefab == "shadowdigger" then
      v.entity:AddLabel():SetText(string.format("Aggro: %s","Shadow Digger"))
    elseif aggressee.prefab == "shadowlumber" then
    v.entity:AddLabel():SetText(string.format("Aggro: %s","Shadow Logger"))
    elseif aggressee.prefab == "shadowduelist" then
      v.entity:AddLabel():SetText(string.format("Aggro: %s","Shadow Duelist"))
    elseif aggressee.prefab == "wobster_sheller_land" then
      v.entity:AddLabel():SetText(string.format("Aggro: %s","Wobster"))
    elseif aggressee.prefab == "wobster_moonglass_land" then
      v.entity:AddLabel():SetText(string.format("Aggro: %s","Lunar Wobster"))
      end
]]
  
local function GetColour(number)
    local r,g,b = 1,1,1
    if number == 1 then --Red
        r,g,b = 1,0,0
    elseif number == 2 then --Green
        r,g,b = 0,1,0  
    elseif number == 3 then --Dark Green
        r,g,b = 0,51/255,0
    elseif number == 4 then --Blue
        r,g,b = 0,0,1
    elseif number == 5 then --Light Blue
        r,g,b = 102/255,178/255,1
    elseif number == 6 then --Orange
        r,g,b = 1,165/255,0
    elseif number == 7 then --Orangered
        r,g,b = 1,69/255,0
    elseif number == 8 then --Yellow
        r,g,b = 1,1,0
    elseif number == 9 then --Purple
        r,g,b = 153/255,0,153/255
    elseif number == 10 then --Pink
        r,g,b = 1,102/255,178/255
    elseif number == 11 then --Gray
        r,g,b = 192/255,192/255,192/255

    end  
    return r,g,b
end
  

local function GetAggroOfMob(mob)
    local target
    if mob and mob:IsValid() and mob.replica.combat then
        target = mob.replica.combat:GetTarget()
    else
        target = nil
    end
    return target
end

local function GetLeaderOfMob(mob)
    local leader
    if mob and mob:IsValid() and mob.replica.follower then
        leader = mob.replica.follower:GetLeader()
    else
        leader = nil
    end
    return leader
end

local function CreateLabel(aggressor)
    local label = aggressor.entity:AddLabel()
    default_font = (mob_fontsize[aggressor.prefab]) or mob_fontsize["default"]
    label:SetFontSize(default_font)
    label:SetFont(GLOBAL.BODYTEXTFONT)
    y_offset = mob_offset[aggressor.prefab] or mob_offset["default"]
    label:SetWorldOffset(0,y_offset,0)
    label:SetColour(1,1,1)
    label:Enable(true)
    return label
end

local function GetAggressorEntities()
    if not _G.ThePlayer then return nil,"No ThePlayer for positions" end
  local playerpos = _G.ThePlayer:GetPosition()
  local entity_table = TheSim:FindEntities(playerpos.x,0,playerpos.z,80,MUSTHAVE_TAGS,CANTHAVE_TAGS,MUSTONEOF_TAGS)
  return entity_table
end

  local function ApplyColour(mob)
    if show_specialcolours == true then
        if GetLeaderOfMob(mob) and GetLeaderOfMob(mob) == GLOBAL.ThePlayer then
            mob.entity:AddLabel():SetColour(GetColour(colour_mobfriendyou))
        elseif GetAggroOfMob(mob) and GetAggroOfMob(mob) == GLOBAL.ThePlayer then
            mob.entity:AddLabel():SetColour(GetColour(colour_mobaggroyou))
        elseif GetAggroOfMob(mob) and (GetAggroOfMob(mob).prefab == "bernie_active" or GetAggroOfMob(mob).prefab == "bernie_big" or GetAggroOfMob(mob).prefab == "abigail" or GetAggroOfMob(mob).prefab == "shadowdigger" or GetAggroOfMob(mob).prefab == "shadowlumber" or GetAggroOfMob(mob).prefab == "shadowduelist" or GetAggroOfMob(mob).prefab == "shadowminer") then
            mob.entity:AddLabel():SetColour(GetColour(colour_mobaggrofollower))
        elseif GetAggroOfMob(mob) and GetAggroOfMob(mob):HasTag("player") and GetAggroOfMob(mob) ~= GLOBAL.ThePlayer then
            mob.entity:AddLabel():SetColour(GetColour(colour_mobaggroplayer))
        elseif GetLeaderOfMob(mob) and GetLeaderOfMob(mob):HasTag("player") and not (GetLeaderOfMob(mob) == GLOBAL.ThePlayer) then
            mob.entity:AddLabel():SetColour(GetColour(colour_mobfriendother))
        else
        mob.entity:AddLabel():SetColour(1,1,1)
        end
    else
        mob.entity:AddLabel():SetColour(1,1,1)
    end
  end
  
  
--[[local function DisableUpdateLabelBefriendAggro()
  if switcher == 1 and switcher_befriend == 0 then
  
local EnableUpdateLabel = function ()
  if switcher_befriend == 1 then
    DisableUpdateLabelBefriend()
    EnableUpdateLabelBefriendAggro()
  else
  GLOBAL.ThePlayer.updateaggro_task = GLOBAL.ThePlayer:DoPeriodicTask(1/30,function()
for _,v in pairs(GetAggressorEntities()) do
if v then
  if v.AnimState and v.AnimState:IsCurrentAnimation("death") then
    v.entity:AddLabel():Enable(false)
    else
  CreateLabel(v)
aggressee = GetAggroOfMob(v)
  if aggressee ~= nil then
    if aggressee.name =="MISSING NAME" then
      local name = missingname_name[aggressee.prefab] or aggressee.prefab
      v.entity:AddLabel():SetText(string.format("Aggro: %s",name))
      else
    v.entity:AddLabel():SetText(string.format("Aggro: %s",aggressee.name))
  end
  ApplyColour(v)
else
v.entity:AddLabel():SetText("")
end
end
end
end
if switcher == 0 then
DisableUpdateLabel()
end
end)
end
end

EnableUpdateLabel()

elseif switcher == 0 and switcher_befriend == 1 then

local EnableUpdateLabelBefriend = function ()
  if switcher == 1 then --Aggro list is enabled
    DisableUpdateLabel()
    EnableUpdateLabelBefriendAggro()
  else
    GLOBAL.ThePlayer.updatebefriend_task = GLOBAL.ThePlayer:DoPeriodicTask(1/30,function() 
for _,v in pairs(GetAggressorEntities()) do
if v then

  CreateLabel(v)
leader = GetLeaderOfMob(v)
  if leader ~= nil then
    v.entity:AddLabel():SetText(string.format("Leader: %s",leader.name))
  end
  ApplyColour(v)
else
v.entity:AddLabel():SetText("")
end
end
if switcher_befriend == 0 then
DisableUpdateLabelBefriend()
end
end)
end
  
end
EnableUpdateLabelBefriend()

end
if GLOBAL.ThePlayer.updatebefriendaggro_task then
    GLOBAL.ThePlayer.updatebefriendaggro_task:Cancel()
    GLOBAL.ThePlayer.updatebefriendaggro_task = nil
  end
  for k,v in pairs(GetAggressorEntities()) do
    if v then
      v.entity:AddLabel():Enable(false)
      v.entity:AddLabel():SetText("")
      end
    end


end
]]
--[[local function DisableUpdateLabel()
  if GLOBAL.ThePlayer.updateaggro_task then
    GLOBAL.ThePlayer.updateaggro_task:Cancel()
    GLOBAL.ThePlayer.updateaggro_task = nil
  end
  for k,v in pairs(GetAggressorEntities()) do
    if v then
      v.entity:AddLabel():Enable(false)
      v.entity:AddLabel():SetText("")
      end
    end
  end
  ]]
--[[local function DisableUpdateLabelBefriend()
    if GLOBAL.ThePlayer.updatebefriend_task then
    GLOBAL.ThePlayer.updatebefriend_task:Cancel()
    GLOBAL.ThePlayer.updatebefriend_task = nil
  end
  for k,v in pairs(GetAggressorEntities()) do
    if v then
      v.entity:AddLabel():Enable(false)
      v.entity:AddLabel():SetText("")
      end
    end
end
]]
--[[local function EnableUpdateLabelBefriendAggro()
    GLOBAL.ThePlayer.updatebefriendaggro_task = GLOBAL.ThePlayer:DoPeriodicTask(1/30,function() 
for _,v in pairs(GetAggressorEntities()) do
if v then

  CreateLabel(v)
leader = GetLeaderOfMob(v)
aggressee = GetAggroOfMob(v)
if leader ~= nil then
leader_name = leader.name
else
leader_name = nil
end
if aggressee ~= nil then
aggressee_name = aggressee.name
    if aggressee_name =="MISSING NAME" then
      aggressee_name = missingname_name[aggressee.prefab] or aggressee.prefab
    else
    v.entity:AddLabel():SetText(string.format("Aggro: %s",aggressee.name))
  end
else
aggressee_name = nil
end
if aggressee_name and leader_name then
      v.entity:AddLabel():SetText(string.format("Aggro: %s ; Leader: %s",aggressee_name, leader_name))
  elseif aggressee_name and not leader_name then
        v.entity:AddLabel():SetText(string.format("Aggro: %s", aggressee_name))
  elseif leader_name and not aggressee_name then
        v.entity:AddLabel():SetText(string.format("Leader: %s",leader_name))
  elseif (not leader_name) and (not aggressee_name) then
        v.entity:AddLabel():SetText("")
  end
  ApplyColour(v)
else
v.entity:AddLabel():SetText("")
end
end
if switcher == 0 or switcher_befriend == 0 then
DisableUpdateLabelBefriendAggro()
end
end)
end
]]
--[[local EnableUpdateLabel = function ()
  if switcher_befriend == 1 then
    DisableUpdateLabelBefriend()
    EnableUpdateLabelBefriendAggro()
  else
  GLOBAL.ThePlayer.updateaggro_task = GLOBAL.ThePlayer:DoPeriodicTask(1/30,function()
for _,v in pairs(GetAggressorEntities()) do
if v then
  if v.AnimState and v.AnimState:IsCurrentAnimation("death") then
    v.entity:AddLabel():Enable(false)
    else
  CreateLabel(v)
aggressee = GetAggroOfMob(v)
  if aggressee ~= nil then
    if aggressee.name =="MISSING NAME" then
      
      if aggressee.prefab == "stalker_forest" or aggressee.prefab == "stalker" or aggressee.prefab == "stalker_atrium" then
      v.entity:AddLabel():SetText(string.format("Aggro: %s","Reanimated Skeleton"))
    elseif aggressee.prefab == "shadowminer" then
      v.entity:AddLabel():SetText(string.format("Aggro: %s","Shadow Miner"))
    elseif aggressee.prefab == "shadowdigger" then
      v.entity:AddLabel():SetText(string.format("Aggro: %s","Shadow Digger"))
    elseif aggressee.prefab == "shadowlumber" then
    v.entity:AddLabel():SetText(string.format("Aggro: %s","Shadow Logger"))
    elseif aggressee.prefab == "shadowduelist" then
      v.entity:AddLabel():SetText(string.format("Aggro: %s","Shadow Duelist"))
elseif aggressee.prefab == "wobster_sheller_land" then
      v.entity:AddLabel():SetText(string.format("Aggro: %s","Wobster"))
elseif aggressee.prefab == "wobster_moonglass_land" then
      v.entity:AddLabel():SetText(string.format("Aggro: %s","Lunar Wobster"))
      end
      else
    v.entity:AddLabel():SetText(string.format("Aggro: %s",aggressee.name))
  end
  ApplyColour(v)
else
v.entity:AddLabel():SetText("")
end
end
end
end
if switcher == 0 then
DisableUpdateLabel()
end
end)
end
end
]]
local function StopShowAggroThread()
 -- print("关闭1")
    if _G.ThePlayer and _G.ThePlayer.showaggro_thread then
        _G.KillThreadsWithID(_G.ThePlayer.showaggro_thread.id)
        _G.ThePlayer.showaggro_thread:SetList(nil)
        _G.ThePlayer.showaggro_thread = nil
     --   print("关闭2")
        for _,ent in pairs(GetAggressorEntities() or {}) do--Ents should have their labels reset if the player despawns.
          if ent then
              ent.entity:AddLabel():SetText("")
              ent.entity:AddLabel():Enable(false)
          end
       end
    end
end

local function StartShowAggroThread()--Instead of doing a periodic task, it now uses a thread. I also used this opportunity to clean the very unclean code.
    if _G.ThePlayer then
       _G.ThePlayer.showaggro_thread = _G.ThePlayer:StartThread(function()
            while _G.ThePlayer and _G.ThePlayer.showaggro_thread do
                Sleep(FRAMES)
                if  _G.ThePlayer then
                    local ent_table = GetAggressorEntities()
                    if not ent_table then return nil end
                        for _,ent in pairs(ent_table) do
                            if ent then
                                CreateLabel(ent)
                                ApplyColour(ent)
                                local leader = GetLeaderOfMob(ent)
                                local aggro = GetAggroOfMob(ent)
                                local leader_name = leader and ((leader.name ~= "MISSING NAME" and leader.name) or leader.name == "MISSING NAME" and (missingname_name[leader.prefab] or leader.prefab) )
                                local aggro_name = aggro and ((aggro.name ~= "MISSING NAME" and aggro.name) or aggro.name == "MISSING NAME" and (missingname_name[aggro.prefab] or aggro.prefab) )
                                if leader_name and aggro_name  then
                                    ent.entity:AddLabel():SetText(string.format("仇恨: %s ; 跟随: %s",aggro_name, leader_name))
                                elseif leader_name  then
                                    ent.entity:AddLabel():SetText(string.format("跟随: %s",leader_name))
                                elseif aggro_name then
                                    ent.entity:AddLabel():SetText(string.format("仇恨: %s",aggro_name))
                                else
                                    ent.entity:AddLabel():SetText("")
                                end
                            
                            end
                        end
                else
                    for _,ent in pairs(GetAggressorEntities() or {}) do--Ents should have their labels reset if the player despawns.
                       if ent then
                           ent.entity:AddLabel():SetText("")
                           ent.entity:AddLabel():Enable(false)
                       end
                    end
                    StopShowAggroThread()
                end
            end
        end)
        _G.ThePlayer.showaggro_thread.id = "mod_show_aggro_thread"
    end
end


--[[local EnableUpdateLabelBefriend = function ()
  if switcher == 1 then --Aggro list is enabled
    DisableUpdateLabel()
    EnableUpdateLabelBefriendAggro()
  else
    GLOBAL.ThePlayer.updatebefriend_task = GLOBAL.ThePlayer:DoPeriodicTask(1/30,function() 
for _,v in pairs(GetAggressorEntities()) do
if v then

  CreateLabel(v)
leader = GetLeaderOfMob(v)
  if leader ~= nil then
    v.entity:AddLabel():SetText(string.format("Leader: %s",leader.name))
  end
  ApplyColour(v)
else
v.entity:AddLabel():SetText("")
end
end
if switcher_befriend == 0 then
DisableUpdateLabelBefriend()
end
end)
end
  
end

]]

local default_showaggro  = true

--if TUNING.xiaoyao("toggle_showaggro") ~= 0 then
    TheInput:AddKeyUpHandler(TUNING.xiaoyao("范围显示"),function() --按键
        if not InGame() then return else 
            if default_showaggro then --如果是true
                default_showaggro = false --那么是false
            elseif not default_showaggro then
                default_showaggro = true --否则就开启
                if not _G.ThePlayer.showaggro_thread then
                    StartShowAggroThread()
                end
            end
            if default_showaggro then
             --   GLOBAL.ThePlayer.components.talker:Say("Enabled:Showing Aggro")
            else
                StopShowAggroThread()
              --  print("关闭")
              --  GLOBAL.ThePlayer.components.talker:Say("Disabled:Hidden Aggro")
            end
        end
    end)
--end

AddPlayerPostInit(function(inst)
  inst:DoTaskInTime(1,function()
    if inst == GLOBAL.ThePlayer then
       -- if default_showaggro or default_befriended then
            StartShowAggroThread()
        --end
    end
end)
end)