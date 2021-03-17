local playeractionpicker
local playercontroller
local combat
local delay=TUNING.xiaoyao("Default_delay")
local keyframe=TUNING.xiaoyao("Default_keyframe")

local function CheckMod(name)
  for k,v in pairs(GLOBAL.ModManager.mods) do
    if v.modinfo.name == name then
      return true
    end
  end
end

local function IsDefaultScreen()
  local screen = GLOBAL.TheFrontEnd:GetActiveScreen()
  local screenName = screen and screen.name or ""
  return screenName:find("HUD") ~= nil and not CheckMod("ReForged")
end

local function CheckDebugString(target,string)
  local debugstring=target.entity:GetDebugString()
  if  debugstring and string=="" then 
    GLOBAL.print(debugstring)
  end
  return debugstring and string.find(debugstring,string)
end

local function Hit(target,px,pz,mod)
  local function cb()
    if mod=="mouse" then
      GLOBAL.SendRPCToServer(GLOBAL.RPC.LeftClick, GLOBAL.ACTIONS.ATTACK.code, px, pz, target, nil, 10, true)
    elseif mod=="keyboard" then
      GLOBAL.SendRPCToServer(GLOBAL.RPC.AttackButton,target,true)
    end
  end
  local function DoAction()
    if playercontroller:CanLocomote() then
      local action = GLOBAL.BufferedAction(GLOBAL.ThePlayer, target, GLOBAL.ACTIONS.ATTACK)
      action.preview_cb = cb()
      playercontroller:DoAction(action)
    else
      cb()
    end
  end
  DoAction()
end

local function Run(px,pz,tx,tz,distance,tr,pa)
  local function cb()
    if GLOBAL.math.abs(tr-pa)<=180 and distance <= 2 then
      GLOBAL.SendRPCToServer(GLOBAL.RPC.LeftClick, GLOBAL.ACTIONS.WALKTO.code, px+(px-tx)/distance/4, pz+(pz-tz)/distance/4)
    else 
      GLOBAL.SendRPCToServer(GLOBAL.RPC.LeftClick, GLOBAL.ACTIONS.WALKTO.code, px-(px-tx)/distance/4, pz-(pz-tz)/distance/4)
    end
  end
  local function DoAction()
    if playercontroller:CanLocomote() then
      local action = GLOBAL.BufferedAction(GLOBAL.ThePlayer,nil,GLOBAL.ACTIONS.WALKTO,nil,GLOBAL.Vector3(px+(px-tx)/distance/4,0,pz+(pz-tz)/distance/4))
      playercontroller:DoAction(action)
    else
      cb()
    end
  end
  DoAction()
end

local Cheatthread
local function Start()
  if not IsDefaultScreen() then return end
  if GLOBAL.ThePlayer == nil then return end
  if GLOBAL.ThePlayer.Cheatthread ~= nil then return end
  playeractionpicker = GLOBAL.ThePlayer.components.playeractionpicker
  playercontroller = GLOBAL.ThePlayer.components.playercontroller
  combat = GLOBAL.ThePlayer.replica.combat
  local target
  local turn
  local range
  local function HitAndRun()
    --CheckDebugString(GLOBAL.ThePlayer,"")
    if target ~= nil 
    and target:IsValid() 
    and target.replica.health ~= nil 
    and not target.replica.health:IsDead() 
    and combat:CanTarget(target) then
      local tx,ty,tz = target:GetPosition():Get()
      local px,py,pz = GLOBAL.ThePlayer:GetPosition():Get()
      if tx==px and tz==pz then tx=tx+0.1 tz=tz+0.1 end
      local distance = GLOBAL.math.sqrt((px-tx)*(px-tx)+(pz-tz)*(pz-tz))
      local tr = target:GetRotation()
      local pa = GLOBAL.math.atan2(tz - pz, px - tx) / GLOBAL.DEGREES
      local keyframestring=(keyframe<=7 and "atk_pre Frame: "..(keyframe-1)..".00") or "atk Frame: "..(keyframe-8)..".00"
      if playercontroller:CanLocomote() then
        if not turn or turn==1 or turn==2 then for i= 1,2 do Hit(target,px,pz,"mouse") end end
        if not turn and CheckDebugString(GLOBAL.ThePlayer,keyframestring)
        or turn == delay then Run(px,pz,tx,tz,distance,tr,pa) turn = 0 end
      else
        Hit(target,px,pz,"mouse")
        if not turn and CheckDebugString(GLOBAL.ThePlayer,keyframestring) or turn == delay
        then Run(px,pz,tx,tz,distance,tr,pa) turn = 0 end
      end
      if not CheckDebugString(GLOBAL.ThePlayer,"player_attacks.zip") and not CheckDebugString(GLOBAL.ThePlayer,"run_pre Frame") then turn=nil end
      if CheckDebugString(GLOBAL.ThePlayer,"hit Frame: 1.00") then Hit(target,px,pz,"keyboard") end
      if turn then turn=turn+1 end
    else
      local retarget=combat:GetTarget()
      local isctrlpressed=GLOBAL.TheInput:IsControlPressed(GLOBAL.CONTROL_FORCE_ATTACK)
      target=playercontroller:GetAttackTarget(isctrlpressed,retarget,retarget~=nil)
      if target then range = combat:GetAttackRangeWithWeapon()+target:GetPhysicsRadius(0) end
      turn=nil
    end
  end
  if Cheatthread==nil then
    Cheatthread=GLOBAL.ThePlayer:DoPeriodicTask(GLOBAL.FRAMES,HitAndRun)
  end
end

local function Stop()
  if IsDefaultScreen() and Cheatthread ~= nil then
    Cheatthread:Cancel()
    Cheatthread=nil
  end
end

local function GetKeyFromConfig(config)
  local key = TUNING.xiaoyao(config, true)
  if type(key) == "string" and GLOBAL:rawget(key) 
  then key = GLOBAL[key] end
  return type(key) == "number" and key or -1
end

if GetKeyFromConfig("Adddelay_key") then
  GLOBAL.TheInput:AddKeyUpHandler(GetKeyFromConfig("Adddelay_key"), function() 
      if IsDefaultScreen() then
        delay = delay + 1
        if delay>12 then delay=12 else lastmovetime=nil end
        GLOBAL.print("delay="..GLOBAL.tostring(delay).."FRAMES")
      end
    end)
end
if GetKeyFromConfig("Reducedelay_key") then
  GLOBAL.TheInput:AddKeyUpHandler(GetKeyFromConfig("Reducedelay_key"), function() 
      if IsDefaultScreen() then
        delay = delay - 1 
        if delay<1 then delay=1 end
        GLOBAL.print("delay="..GLOBAL.tostring(delay).."FRAMES") 
      end
    end)
end
if GetKeyFromConfig("Addkeyframe_key") then
  GLOBAL.TheInput:AddKeyUpHandler(GetKeyFromConfig("Addkeyframe_key"), function() 
      if IsDefaultScreen() then
        keyframe = keyframe + 1
        if keyframe>15 then keyframe=15 end
        GLOBAL.print("keyframe:the "..GLOBAL.tostring(keyframe).." frame") 
      end
    end)
end
if GetKeyFromConfig("Reducekeyframe_key") then
  GLOBAL.TheInput:AddKeyUpHandler(GetKeyFromConfig("Reducekeyframe_key"), function() 
      if IsDefaultScreen() then
        keyframe = keyframe - 1 
        if keyframe<0 then keyframe=0 end
        GLOBAL.print("keyframe:the "..GLOBAL.tostring(keyframe).." frame") 
      end
    end)
end
if GetKeyFromConfig("Attack_key") then
  GLOBAL.TheInput:AddKeyDownHandler(GetKeyFromConfig("Attack_key"), Start)
  GLOBAL.TheInput:AddKeyUpHandler(GetKeyFromConfig("Attack_key"), Stop)
end