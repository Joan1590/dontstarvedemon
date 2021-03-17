local _G = GLOBAL

local function ImportModulesForConfig(configs, moudules)
    configs = type(configs) == "table" and configs or { configs }
    if moudules == nil then
        moudules = { configs[1] }
    elseif type(moudules) ~= "table" then
        moudules = { moudules }
    end
    for _, config in ipairs(configs) do
        if TUNING.xiaoyao(config) then
            for _, moudule_name in ipairs(moudules) do
                modimport("scripts/modules/"..moudule_name..".lua")
            end
            return
        end
    end
end

local common_feature_configs = {
    "attack_lureplant",
    "fish_killer",
    "repeat_drop",
    "batch_move_items",
    "quick_craftslot_moving",


    "aq_changes",
    "better_fw_fight",
    "auto_reequip_weapons",



    "dont_click_it",
    "cave_clock",
    "honey_collector",



    "repeat_compare_fishes",

    "no_flower_picking",
    "no_winch_using",
    "unblocked_castspell",
    "drop_actionpicker",
    "modsscreen_lag_reducer",
}
for _, v in ipairs(common_feature_configs) do
    ImportModulesForConfig(v)
end
ImportModulesForConfig({"bundle_first", "stewer_first"})
ImportModulesForConfig({"easy_steering_boat", "easy_anchor_using"}, "easy_boat_stuff_using")
-- if TUNING.xiaoyao("ia_strings") then modimport("strings/ia_str_init.lua") end

-- if TUNING.xiaoyao("night_vision") then modimport("scripts/modules/night_vision.lua") end
-- if TUNING.xiaoyao("attack_lureplant") then modimport("scripts/modules/attack_lureplant.lua") end
-- if TUNING.xiaoyao("fish_killer") then modimport("scripts/modules/fish_killer.lua") end
-- if TUNING.xiaoyao("repeat_drop") then modimport("scripts/modules/repeat_drop.lua") end
-- if TUNING.xiaoyao("batch_move_items") then modimport("scripts/modules/batch_move_items.lua") end
-- if TUNING.xiaoyao("quick_craftslot_moving") then modimport("scripts/modules/quick_craftslot_moving.lua") end
-- if TUNING.xiaoyao("lock_equipslots_in_void") then modimport("scripts/modules/lock_equipslots_in_void.lua") end
-- if TUNING.xiaoyao("modified_sort_key") then modimport("scripts/modules/modified_sort_key.lua") end
-- if TUNING.xiaoyao("bundle_first") or TUNING.xiaoyao("stewer_first") then
--     modimport("scripts/modules/bundle_first.lua")
-- end
-- if TUNING.xiaoyao("aq_changes") then modimport("scripts/modules/aq_changes.lua") end
-- if TUNING.xiaoyao("better_fw_fight") then modimport("scripts/modules/better_fw_fight.lua") end
-- if TUNING.xiaoyao("auto_reequip_weapons") then modimport("scripts/modules/auto_reequip_weapons.lua") end
-- if TUNING.xiaoyao("farm_lag_reducer") then modimport("scripts/modules/farm_lag_reducer.lua") end
-- if TUNING.xiaoyao("auto_unequip") then modimport("scripts/modules/auto_unequip.lua") end
-- if TUNING.xiaoyao("show_modfolder") then modimport("scripts/modules/show_modfolder.lua") end

-- if TUNING.xiaoyao("free_skins") then modimport("scripts/modules/free_skins.lua") end
-- if TUNING.xiaoyao("dont_click_it") then modimport("scripts/modules/dont_click_it.lua") end
-- if TUNING.xiaoyao("cave_clock") then modimport("scripts/modules/cave_clock.lua") end

-- if TUNING.xiaoyao("honey_collector") then modimport("scripts/modules/honey_collector.lua") end

-- -- if TUNING.xiaoyao("re_enable_mods") then modimport("scripts/modules/re_enable_mods.lua") end

-- if TUNING.xiaoyao("fireflies_catcher") then modimport("scripts/modules/fireflies_catcher.lua") end
-- if TUNING.xiaoyao("book_rain_reader") then modimport("scripts/modules/book_rain_reader.lua") end

-- if TUNING.xiaoyao("auto_bone_armor_switching") then modimport("scripts/modules/auto_bone_armor_switching.lua") end

-- if TUNING.xiaoyao("repeat_compare_fishes") then modimport("scripts/modules/repeat_compare_fishes.lua") end
-- if TUNING.xiaoyao("easy_steering_boat") or TUNING.xiaoyao("easy_anchor_using") then
--     modimport("scripts/modules/easy_boat_stuff_using.lua")
-- end

-- if TUNING.xiaoyao("show_all_head_skins") then modimport("scripts/modules/show_all_head_skins.lua") end

-- if TUNING.xiaoyao("no_flower_picking") then modimport("scripts/modules/no_flower_picking.lua") end

-- if TUNING.xiaoyao("no_winch_using") then modimport("scripts/modules/no_winch_using.lua") end

-- if TUNING.xiaoyao("unblocked_castspell") then modimport("scripts/modules/unblocked_castspell.lua") end
-- if TUNING.xiaoyao("drop_actionpicker") then modimport("scripts/modules/drop_actionpicker.lua") end

-- if TUNING.xiaoyao("ia_strings") then modimport("strings/ia_str_init.lua") end

-- if TUNING.xiaoyao("modsscreen_lag_reducer") then modimport("scripts/modules/modsscreen_lag_reducer.lua") end

-- if TUNING.xiaoyao("link_steam_first") then -- From Cosson Wool's Hide Stuff
    -- local ModManager_GetLinkForMod = _G.ModManager.GetLinkForMod
    -- _G.ModManager.GetLinkForMod = function(self, mod_name, ...)
        -- if _G.PLATFORM == "WIN32_RAIL" or not _G.IsWorkshopMod(mod_name) then
            -- return ModManager_GetLinkForMod(self, mod_name, ...)
        -- end
        
        -- local mod_name_info = _G.KnownModIndex:GetModInfo(mod_name)
        -- local thread = mod_name_info and mod_name_info.forumthread or ""
        
        -- if thread ~= "" then
            -- print("[Hide Stuff] [".._G.KnownModIndex:GetModFancyName(mod_name).."] Klei forum url: http://forums.kleientertainment.com/index.php?"..thread)
        -- end
        
        -- return function() _G.VisitURL("http://steamcommunity.com/sharedfiles/filedetails/?id=".._G.GetWorkshopIdNumber(mod_name)) end, false
    -- end
-- end

local rescue_key = TUNING.xiaoyao("rescue_key")
if rescue_key then
    _G.TheInput:AddKeyUpHandler(_G[rescue_key], function()
        local ThePlayer = _G.ThePlayer
        if not (ThePlayer and ThePlayer.HUD and not ThePlayer.HUD:HasInputFocus()) then return end
        _G.TheNet:SendSlashCmdToServer("rescue")
    end)
end

--Display Changes--
-- if TUNING.xiaoyao("no_lightning_flash") then modimport("scripts/modules/no_lightning_flash.lua") end
-- if TUNING.xiaoyao("snow_tile_disabler") then modimport("scripts/modules/snow_tile_disabler.lua") end
-- if TUNING.xiaoyao("sanddustover_disabler") then modimport("scripts/modules/sanddustover_disabler.lua") end
-----------------------无低san 冲突
-- if TUNING.xiaoyao("no_insane_anim") then
    -- AddClassPostConstruct("screens/playerhud", function(self)
        -- self.GoInsane = function(self)
            -- self:GoSane()
        -- end
    -- end)
-- end
-----------------------------------------------------
-- if TUNING.xiaoyao("no_nutrientsover") then
    -- AddClassPostConstruct("widgets/nutrientsover", function(self, ...) -- From Sorry Late's Remove Purple Overlay
        -- self.ToggleNutrients = function(self, ...)
            -- self:Hide()
        -- end
    -- end)
-- end
--Display Changes--

--Camera Tweaks--
-- if TUNING.xiaoyao("focalpoint_disabler") then
    -- AddComponentPostInit("focalpoint", function(self, inst)
        -- self.StartFocusSource = function() --[[disabled]] end
    -- end)
    -- From eXiGe's Camera Tweaks
-- end

-- local followcamera_tweaks = {"camera_maxdist_tweak", "camera_cave_pitch_tweak"}
-- for i, v in ipairs(followcamera_tweaks) do
    -- if TUNING.xiaoyao(v) then
        -- AddClassPostConstruct("cameras/followcamera",function(self)
            -- local Old_SetDefault = self.SetDefault
            -- self.SetDefault = function(self)
                -- Old_SetDefault(self)

                -- if TUNING.xiaoyao("camera_maxdist_tweak") then
                    -- self.maxdist = 225
                -- end
                -- if TUNING.xiaoyao("camera_cave_pitch_tweak") then
                    -- local TheWorld = GLOBAL.TheWorld
                    -- if TheWorld ~= nil and TheWorld:HasTag("cave") then
                        -- self.mindistpitch = 30
                        -- self.maxdistpitch = 60
                    -- end
                -- end
            -- end
        -- end)
        -- break
    -- end
-- end
if TUNING.xiaoyao("quick_zoom") then modimport("scripts/modules/quick_zoom.lua") end
--Camera Tweaks--

--Disable Sounds--
if TUNING.xiaoyao("remove_think_tank_noise") then RemapSoundEvent("turnoftides/common/together/seafaring_prototyper/LP", "") end
if TUNING.xiaoyao("remove_overcharge_noise") then RemapSoundEvent("dontstarve/characters/wx78/charged", "") end
if TUNING.xiaoyao("remove_sandstorm_noise") then RemapSoundEvent("dontstarve/common/together/sandstorm", "") end
if TUNING.xiaoyao("remove_dry_noise") then RemapSoundEvent("dontstarve/common/together/put_meat_rack", "") end
if TUNING.xiaoyao("remove_pets_noise") then
    local pet_sounds = {
        "dontstarve/creatures/together/sheepington/angry",          -- Lamb
        "dontstarve_DLC001/creatures/together/kittington/disstress",-- Kitten
        "dontstarve_DLC001/creatures/together/dragonling/angry",    -- Dragonling
        "turnoftides/creatures/together/lunarmothling/distress",    -- Lunarmothling
        "dontstarve_DLC001/creatures/together/glomling/vomit_voice",-- Glomling
        "dontstarve_DLC001/creatures/together/puft/vomit_voice",    -- Glomling's puft skin
        "dontstarve/creatures/together/perdling/distress_long",     -- Perdling
        "dontstarve/creatures/together/rooster/distress_long",      -- Perdling's rooslet skin
        "dontstarve/creatures/together/pupington/bark",             -- Puppy, unfortunately it will also mute some other sounds
    }
    for _, path in ipairs(pet_sounds) do
        RemapSoundEvent(path, "")
    end
end

if TUNING.xiaoyao("remove_lucy_noise") then
    local lucy_sounds = {
        "dontstarve/characters/woodie/lucytalk_LP",
        "dontstarve/characters/woodie/lucy_transform",
        "dontstarve/characters/woodie/lucy_warn_1",
        "dontstarve/characters/woodie/lucy_warn_2",
        "dontstarve/characters/woodie/lucy_warn_3",
    }
    for _, path in ipairs(lucy_sounds) do
        RemapSoundEvent(path, "")
    end
end

if TUNING.xiaoyao("remove_friendlyfruitfly_noise") then
    local friendlysounds = {
        "farming/creatures/fruitfly/LP",
        "farming/creatures/fruitfly/sleep",
        "farming/creatures/fruitfly/hit", -- Unfortunately it will also mute it's hurt sound
    }
    for _, path in ipairs(friendlysounds) do
        RemapSoundEvent(path, "")
    end
end
--Disable Sounds--

AddClassPostConstruct("widgets/textedit", function(self)
    local Old_AddWordPredictionDictionary = self.AddWordPredictionDictionary
    self.AddWordPredictionDictionary = function(self, dictionary, ...)
        if dictionary.delim == "c_" then
            local more_commands = {"select", "connect", "rollback"}
            dictionary.words = _G.JoinArrays(dictionary.words, more_commands)
        end
        Old_AddWordPredictionDictionary(self, dictionary, ...)
    end
end)

-- if TUNING.xiaoyao("quick_movement_prediction_toggle") then
    -- local sended_enable = false
    -- _G.TheInput:AddKeyUpHandler(_G[TUNING.xiaoyao("quick_movement_prediction_toggle")], function()
        -- local ThePlayer = _G.ThePlayer
        -- if not (ThePlayer and ThePlayer.HUD and not ThePlayer.HUD:HasInputFocus()) then return end
        -- ThePlayer.components.talker:Say("Sending "..(sended_enable and "MovementPredictionDisabled" or "MovementPredictionEnabled"))
        -- _G.SendRPCToServer(sended_enable and _G.RPC.MovementPredictionDisabled or _G.RPC.MovementPredictionEnabled)
        -- sended_enable = not sended_enable
    -- end)
-- end

local common_modules = {
    "extra_emotes",
    "better_textedit",
    "better_keyconfig",
}
for _, v in ipairs(common_modules) do
    modimport("scripts/modules/"..v..".lua")
end
