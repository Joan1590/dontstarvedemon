local Text = require "widgets/text"
local Widget = require "widgets/widget"
local ImageButton = require "widgets/imagebutton"
local Image = require "widgets/image"
local TEMPLATES = require "widgets/templates"
local screen_size_x,screen_size_y, last_update
local button_realplayers = TUNING.xiaoyao("幽灵玩家按钮") 

local function SavePlayerPositionManagerData(data)
    local toreplace
    local table_size = 0
    local positionmanager_list = ThePlayer and ThePlayer.MOD_LastSeen_data or {}
    for i,_ in pairs((positionmanager_list)) do 
        table_size = table_size + 1
        --print(i,_)
    end
    
    for k,info in pairs(positionmanager_list) do
        --print(info.netid,data.netid)
       if (info.netid ~= 0 and data.netid ~= 0 and info.netid == data.netid) or info.info["科雷ID"] == data.info["科雷ID"] then-- netid should be prioritized as it can't be changed easily by the user.
           toreplace = tostring(k)
           break
       end
    end
    positionmanager_list[toreplace or tostring(table_size+2)] = data
    --print(toreplace,table_size)
    if ThePlayer then
        ThePlayer.MOD_LastSeen_data = positionmanager_list
    end
end

local PlayerPositionManager = Class(Widget,function(self,owner,ispersistent,data)
        Widget._ctor(self,"PlayerPositionManager")
        screen_size_x,screen_size_y = TheSim:GetScreenSize()
        self.owner = owner
        self._ispersistent = ispersistent
        self._data = data
        self.clothing = {}
        self.equip = {}
        self.pos = {0,0,0}
        self.skin = ""
        self.prefab = "wilson"
        self._isghost = false
        self.info = {}
        self.netid = 0
        self.text_toggle = false
        self._isshown = true
        self.text = self:AddChild(Text(BODYTEXTFONT,16))
        self.text:SetString("")
        self.text:SetPosition(0,130)
        self.text:Hide()
        self.button = self:AddChild(ImageButton("images/ui.xml","yellow_exclamation.tex","yellow_exclamation.tex","yellow_exclamation.tex"))
        self.button:SetPosition(0,130)
        self.button:SetOnClick(function() self:ToggleText() end)
        self.netprofilebutton = self:AddChild(TEMPLATES.IconButton("images/button_icons.xml", "steam.tex", "", false, false, function() if self.netid ~= 0 then TheNet:ViewNetProfile(self.netid) end end ))
        self.netprofilebutton:SetScale(.35)
        self.netprofilebutton:SetPosition(30,130)
        self.netprofilebutton:Hide()
        
        self.body = self.text:AddChild(Image())
        self.body:SetPosition(50,-190)
        self.body:SetScale(.5)
        self.body:SetClickable(false)
        self.hat = self.text:AddChild(Image())
        self.hat:SetPosition(50,-110)
        self.hat:SetScale(.5)
        self.hat:SetClickable(false)
        self.hand = self.text:AddChild(Image())
        self.hand:SetPosition(50,-150)
        self.hand:SetScale(.5)
        self.hand:SetClickable(false)
        local scale = 1.25
        self.button:SetScale(scale,scale,scale)
        self:UpdatePlayerData()
        self:SetDataFromPersistent()-- Loaded at the mostly end to be able to index the children.
        self.onremovefn = function() 
            if self.owner == ThePlayer then 
                ThePlayer:RemoveEventCallback("onremove",self.onremovefn) 
                --print("Removed Event onremove for ThePlayer") 
                return 
            end--ThePlayer doesn't need an onremove trigger as he won't disappear from himself and everything should get loaded in if the player changes shards/reconnects.
            
            self:UpdatePlayerData() 
            self:SpawnGhostAtLastPosition() 
            SavePlayerPositionManagerData({ ["clothing"] = self.clothing, ["equip"] = self.equip, ["pos"] = self.pos, ["skin"] = self.skin, ["prefab"] = self.prefab, ["_isghost"] = self._isghost, ["info"] = self.info, ["netid"] = self.netid,}) 
        end
        if owner then
            owner:ListenForEvent("onremove", self.onremovefn)--Yes! It triggers when the player goes out of sight.
        end
        self.onvisibilitychangefn = function()
            self:OnVisibilityChange()
        end
        if button_realplayers and self:IsPlayer() then
            self:Show()
        else
            self:Hide()
        end
        if ThePlayer then
           ThePlayer:ListenForEvent("LastSeen_visibilitychange",self.onvisibilitychangefn) 
        end
        self:MoveToBack()
        self:OnVisibilityChange()
        self:StartUpdating()
    end)

--Keep track of the players stats from time to time. When the player isn't available, spawn a dummy ghost copy and apply known skin and clothing, because why not.

--[[function PlayerPositionManager:ApplyAllEquipmentToGhost()
    --local item = "pickaxe"
    --self.owner.AnimState:OverrideSymbol("swap_object", "swap_"..item, "swap_"..item)
    --local hat_name = "top"
    --self.owner.AnimState:OverrideSymbol("swap_hat", "hat_"..hat_name, "swap_hat")
    --local body_name = "armor_bramble"-- or "swap_backpack"
    --self.owner.AnimState:OverrideSymbol("swap_body",body_name,"swap_body")
end--]]

function PlayerPositionManager:SetDataFromPersistent()
    if self._data and self._ispersistent then
        local data = self._data
        for pointer,stat in pairs(data) do
            self[pointer] = stat
        end
        self._data = nil
        self._ispersistent = nil
        self:SpawnGhostAtLastPosition()
       --[[self.clothing = data.clothing
       self.equip = data.equip
       self.pos = data.pos
       self.skin = data.skin
       self.prefab = data.prefab
       self.info = data.info
       self.netid = data.netid--]]
    end
end

function PlayerPositionManager:OnVisibilityChange()
    if ThePlayer and ThePlayer.MOD_LastSeen_tohide then
        if self.owner and self.owner:HasTag("extra_spooky") then
            self.owner.AnimState:SetMultColour(0,0,0,0) 
        end
        self:Hide()
        self._isshown = false
    else
        if self.owner and self.owner:HasTag("extra_spooky") then
            self.owner.AnimState:SetMultColour(1,1,1,.25)
        end
        if button_realplayers or (not button_realplayers and not self:IsPlayer()) then
            self:Show()
        end
        self._isshown = true
    end
end

function PlayerPositionManager:UpdateEquipment()
    local equipment_slot = 
    {--Default order is body=>hat=>hand, but I switched it up to keep things consistent with the in-game profile.
        [1] = "body",
        [2] = "hand",
        [3] = "hat",
    }
    for k,slot in pairs(equipment_slot) do
        local equipment = self.equip[k]
        if equipment and equipment ~= "" then
            self[slot]:Show()
            local atlas = GetInventoryItemAtlas(equipment..".tex")
            local tex = equipment..".tex"
            self[slot]:SetTexture(atlas,tex)
        elseif slot == "hand" then
            self[slot]:SetTexture("images/hud.xml","equip_slot_hud.tex")
        elseif slot == "hat" then
            self[slot]:SetTexture("images/hud.xml","equip_slot_head_hud.tex")
        elseif slot == "body" then
            self[slot]:SetTexture("images/hud.xml","equip_slot_body_hud.tex")
        end
    end
end

function PlayerPositionManager:ConstantUpdateData()
    if self:IsPlayer() then
        local user_info = self.owner and self.owner.components and self.owner.components.playeravatardata and self.owner.components.playeravatardata:GetData()
        local x,y,z = unpack(self.pos or {0,0,0})
        if user_info then
            self.equip = {
                [1] = user_info.equip[1] or "",
                [2] = user_info.equip[3] or "",--Ordering changed to match image setup of BODY=>HAND=>HEAD
                [3] = user_info.equip[2] or "",
            }
            self:UpdateEquipment()
        end
        local save_data = self.owner:GetSaveRecord()
        local player_day = save_data.age
        self.info["Player Day"] = player_day
        self.info["X"] = tonumber(string.format("%.2f",x)).."  Z:"..tonumber(string.format("%.2f",z))
    end
end

function PlayerPositionManager:ApplyAllSkinsToGhost()
    --Wolfgang:
    --Mighty: "mighty_skin"; Normal: "normal_skin"; Wimpy: "wimpy_skin";
    --Wormwood:
    --Build: "wilson"; Bloom(n): "stage_n"; Skin has to be reapplied for some reason.
    --Wurt:
    --KingBuffed: "powerup";
    --None at all: "BASE_NONE"
    --For use with Skinner:SetSkinMode(skintype,default_build)
    if not self:IsPlayer() then
        local real_prefab = string.match(self.owner.prefab,"%w+",6)
        local skinner = self.owner.components.skinner
        if not skinner then
            self.owner:AddComponent("skinner")
        end
        local old_prefab = self.owner.prefab
        self.owner.prefab = real_prefab --To stop SetClothing from printing stuff, shouldn't break anything important.
        for k,v in pairs(self.clothing) do
            skinner:SetClothing(v)
        end
        if self._isghost then
            self.owner.AnimState:SetBank("ghost")-- Spooky!
            self.owner.AnimState:SetMultColour(1,1,0,.25)
            self.owner.AnimState:PlayAnimation("idle",false) -- Don't loop to reduce spookiness
            skinner:SetSkinMode("ghost_skin","ghost_"..real_prefab.."_build")--DLC character builds aren't available locally for some reason.
        end
        skinner:SetSkinName(self.skin)
        self.owner.prefab = old_prefab
        self.owner:RemoveTag("player")--Ghosts get removed when they rebind, so we don't care if the spawned ghost keeps his "player" tag after skins are applied.
    end
end

function PlayerPositionManager:UpdatePlayerData()--Update: On Save, Player used wardrobe, player seen once(AddPlayerPostInit), player join, player left. DONT update it every frame or something similar to that.
    if self:IsPlayer() then --self:IsPlayer()
        local user_info = self.owner and self.owner.components and self.owner.components.playeravatardata and self.owner.components.playeravatardata:GetData()
        local save_data = self.owner:GetSaveRecord()
        local name = self.owner:GetBasicDisplayName() or "Error"
        local user_id = self.owner.userid or "Error"--This won't change for the same player, but whatever.
        local character_name = STRINGS.NAMES[string.upper(save_data.prefab)] or "Error" --STRINGS.CHARACTER_NAMES[save_data.prefab] or "Error"
        local player_day = save_data.age ~= 0 and save_data.age or (user_info and user_info.playerage) or self.info["Player Day"] or "Error"
        local last_seen_day = TheWorld.state.cycles+1
        local is_ghost = self.owner and self.owner:HasTag("playerghost") or false
        local x,y,z = unpack(self.pos or {0,0,0})
        self._isghost = is_ghost
        self.prefab = self.owner.prefab
        if user_info then
            self.netid = user_info.netid --For use with TheNet:ViewNetProfile(netid)
            self.equip = {
                [1] = user_info.equip[1] or "",
                [2] = user_info.equip[3] or "",--Ordering changed to match image setup of BODY=>HAND=>HEAD
                [3] = user_info.equip[2] or "",
                }
            self:UpdateEquipment()
            self.skin = user_info.base_skin
            self.clothing = {
                ["body"] = user_info.body_skin,
                ["hand"] = user_info.hand_skin,
                ["legs"] = user_info.legs_skin,
                ["feet"] = user_info.feet_skin,
            }
        end
        self.info = {
            ["用户名"] = name,
            ["科雷ID"] = user_id,
            ["角色"] = character_name,
            ["游戏天数"] = player_day,
            ["最后见面"] = last_seen_day,
            ["是否在线"] = "在线",
            ["X"] = tonumber(string.format("%.2f",x)).."  Z:"..tonumber(string.format("%.2f",z)),
            --["Is Ghost"] = is_ghost
            }
    end
    if not self:IsPlayer() then
        if self.info["科雷ID"] then
            for _,playerdata in pairs(TheNet:GetClientTable() or {}) do
                if playerdata.userid == self.info["科雷ID"] then
                    self.info["是否在线"] = "在线"
                    break
                else
                    self.info["是否在线"] = "离线"
                end
            end
        end
    end
    --self.info["Debug_Owner"] = tostring(self.owner)
end

function PlayerPositionManager:SpawnGhostAtLastPosition()
    if not button_realplayers and self._isshown then
        self:Show()
    end
    local character_prefab = self.prefab
    local ghost = DebugSpawn("ghost_"..self.prefab)
	    if not ghost  then
        print("无法生成这个鬼魂！！！！"..self.prefab)
        return
    end
    ghost.Transform:SetPosition(unpack(self.pos or {}))
    --[[if ThePlayer and ThePlayer.MOD_LastSeen_tohide then
        ghost.AnimState:SetMultColour(1,1,1,0)--Even spookier if the ghost cannot be seen!
    end-]]
    ghost:ListenForEvent("attempt_rebind",function(src,player) self:RebindToPlayer(player) end)
    self.owner = ghost
    self.owner._tempid = self.info["科雷ID"]
    self:ApplyAllSkinsToGhost()
    self:UpdateEquipment()
    self:OnVisibilityChange()
    if ThePlayer and ThePlayer._known_positionmanagers then
        table.sort(ThePlayer._known_positionmanagers,function(a,b) return a ~= nil and b == nil end)
        table.insert(ThePlayer._known_positionmanagers,#ThePlayer._known_positionmanagers+1,self.owner)
    elseif ThePlayer and not ThePlayer._known_positionmanagers then
        ThePlayer._known_positionmanagers = {}
        table.insert(ThePlayer._known_positionmanagers,1,self.owner)
    end
end

function PlayerPositionManager:RebindToPlayer(bind_player)
    --print(bind_player)
    local pos = ThePlayer:GetPosition()
    if bind_player then
        local table_replica = ThePlayer._known_positionmanagers or {}
        for k,ghost in pairs(table_replica) do
           if ghost == self.owner then
               table.remove(ThePlayer._known_positionmanagers,k)
               break
           end
        end
        self.owner:Remove()
        self.owner = bind_player
        if not button_realplayers then
            self:Hide()
        end
        self.owner:ListenForEvent("onremove", self.onremovefn)
        self:UpdatePlayerData()
        self.owner._positionmanagerisadded = true
    end
    
    --[[for _,player in pairs(TheSim:FindEntities(pos.x,0,pos.z,80,{"player"},{"extra_spooky"})) do
       if player.userid and player.userid == self.owner._tempid then
          if self.owner:HasTag("extra_spooky") then
              local table_rep = ThePlayer._known_positionmanagers or {}
              for k,ghost in pairs(table_rep) do 
                 if ghost == self.owner then
                    table.remove(ThePlayer._known_positionmanagers,k)--Modifying the table you're going through via for loop is a really bad habit.
                    break
                 end
              end
              self.owner:Remove()
              self.owner = player
              self.owner:ListenForEvent("onremove", self.onremovefn)--Don't forget that the player lost this event once the "onremove" event triggered. The widget won't re-add it so you shouldn't forget to do it!
              player._positionmanagerisadded = true
              break
          end
       end
    end--]]
end

function PlayerPositionManager:ToggleText()-- Update text and toggle it
        local equipment_slot = {
        [1] = "body",
        [2] = "hat",
        [3] = "hand",
        }
    local n_lines = 0
    local text = ""
    self:UpdatePlayerData()
    for k,v in pairs(self.info) do 
        n_lines = n_lines + 1
        text = text.."\n"..k..": "..tostring(v)
    end
    self.text:SetString(text)
    self.text:SetPosition(0,130+10*n_lines)
    if self.text_toggle then
        self.text_toggle = false
        self.text:Hide()
        self.netprofilebutton:Hide()
    else
        self.text_toggle = true
        self.text:Show()
        self.netprofilebutton:Show()
    end
    
end

function PlayerPositionManager:UpdateText()
    local n_lines = 0
    local text = ""
    for k,v in pairs(self.info) do 
        n_lines = n_lines + 1
        text = text.."\n"..k..": "..tostring(v)
    end
    self.text:SetString(text)
    self.text:SetPosition(0,130+10*n_lines)
end


function PlayerPositionManager:UpdatePositions()
    if self.owner and self:IsPlayer() then
        local a,b,c = self.owner.Transform:GetWorldPosition()
        self.pos = a and b and c and {a,b,c} or self.pos
        local x,y,z = TheSim:GetScreenPos(unpack(self.pos or {0,0,0}))
        if x and y and TheCamera then
            self:SetPosition(x,y,0)
        end
    else
        local x,y,z = TheSim:GetScreenPos(unpack(self.pos or {0,0,0}))
        if x and y then
            self:SetPosition(x,y,0)
        end
    end
end

function PlayerPositionManager:UpdateScaling()
    local dist = TheCamera and TheCamera.distance or 30
    local scale = (35/dist)
    self:SetScale(scale,scale,scale)
    
end

function PlayerPositionManager:IsPlayer()
    return self.owner and self.owner.userid and self.owner.userid ~= ""
end



function PlayerPositionManager:OnUpdate(dt)
    if (self.owner and not self._ispersistent and not self.owner:IsValid()) or ((self.owner and not (self.owner.userid or self.owner._tempid)) and not self._ispersistent) then
        --Where were you when widget died?
        --I was in code running, when condition ring
        print("widget is kil")
        print("no")
        self:Kill()
    end
    --//Constant updater; Not that useful but some players might want it.
    --[[last_update = last_update and last_update+dt or dt
    if self.text_toggle and self:IsPlayer() and last_update >= FRAMES*6 then--We're usually gonna be updating nothing:
        --You only need to update equipment and X,Z, though it's all the same text, which sucks as you have to redo the text.
        --People don't change equipment that often so there's that.
        --X,Z coordinates won't change if player isn't moving.
        last_update = 0
        local x,y,z = TheSim:GetScreenPos(unpack(self.pos or {0,0,0}))
        if not (x<0 or y<0 or x>screen_size_x or y>screen_size_y) then
            self:ConstantUpdateData()
            self:UpdateText()
        end
    end--]]
    
    --\\
    --self:MoveToBack()--Keep it at the back of other widgets such as containerwidget, playeravatarpopup widget
    --self:OnVisibilityChange()
    self:UpdatePositions()
    self:UpdateScaling()
end

return PlayerPositionManager
