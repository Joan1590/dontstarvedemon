---RemapSoundEvent("hookline_2/common/Shells_v5_FX_dst-001", "")
--宠物饥饿禁声
if TUNING.xiaoyao("pet") == 1 then

    RemapSoundEvent("dontstarve_DLC001/creatures/together/kittington/disstress", "")--猫
    RemapSoundEvent("dontstarve/creatures/together/pupington/bark", "")--狗
    RemapSoundEvent("dontstarve/creatures/together/sheepington/angry", "")--羊
    RemapSoundEvent("dontstarve_DLC001/creatures/together/dragonling/angry", "")--龙蝇
    RemapSoundEvent("dontstarve_DLC001/creatures/together/glomling/vomit_voice", "")--小格罗姆
    RemapSoundEvent("dontstarve/creatures/together/perdling/distress", "")--小鸡
    RemapSoundEvent("dontstarve/creatures/together/perdling/distress_long", "")
    RemapSoundEvent("turnoftides/creatures/together/lunarmothling/distress", "")--月蛾
    RemapSoundEvent("dontstarve_DLC001/creatures/together/puft/vomit_voice", "")
end


--低san禁声
if TUNING.xiaoyao("Insanity Sounds") == 1 then
    RemapSoundEvent("dontstarve/sanity/gonecrazy_stinger", "")
    RemapSoundEvent("dontstarve/sanity/sanity", "")
end


--恶魔门禁声
if TUNING.xiaoyao("spawnportal") == 1 then
    RemapSoundEvent("dontstarve/common/together/spawn_vines/spawnportal_idle_LP", "")
    RemapSoundEvent("dontstarve/common/together/spawn_vines/spawnportal_idle", "")--火烟
    RemapSoundEvent("dontstarve/common/together/spawn_vines/spawnportal_scratch", "")
    RemapSoundEvent("dontstarve/common/together/spawn_vines/spawnportal_jacob", "")
    RemapSoundEvent("dontstarve/common/together/spawn_vines/spawnportal_blink", "")--眨眼睛
    RemapSoundEvent("dontstarve/common/together/spawn_vines/vines", "")--葡萄藤
end


--格罗姆禁声
if TUNING.xiaoyao("SilentGlommer") == 1 then
    RemapSoundEvent("dontstarve_DLC001/creatures/glommer/sleep_voice", "")
    RemapSoundEvent("dontstarve_DLC001/creatures/glommer/idle_voice", "")
    RemapSoundEvent("dontstarve_DLC001/creatures/glommer/flap","")
    RemapSoundEvent("dontstarve_DLC001/creatures/glommer/bounce_voice","")
    RemapSoundEvent("dontstarve_DLC001/creatures/glommer/bounce_ground","")
end


--曼德拉草禁声
if TUNING.xiaoyao("SilentMandrake") == 1 then
    RemapSoundEvent("dontstarve/creatures/mandrake/walk", "")
end


--灭火器禁声
if TUNING.xiaoyao("SilentFiresuppressor") == 1 then
    RemapSoundEvent("dontstarve_DLC001/common/firesupressor_chuff", "")
    RemapSoundEvent("dontstarve_DLC001/common/firesupressor_idle_LP", "")
    RemapSoundEvent("dontstarve_DLC001/common/firesupressor_idle", "")
    RemapSoundEvent("dontstarve_DLC001/common/firesupressor_shoot", "")
    RemapSoundEvent("dontstarve_DLC001/common/firesupressor_spin", "")
--RemapSoundEvent("dontstarve_DLC001/common/firesupressor_impact", "")--溅射
end


--大便苍蝇禁声
if TUNING.xiaoyao("poop") == 1 then
    RemapSoundEvent("dontstarve/common/flies", "")
end


--机器人系统过载禁声
if TUNING.xiaoyao("wx78") == 1 then
    RemapSoundEvent("dontstarve/characters/wx78/charged", "")
end


--蜜蜂禁声
if TUNING.xiaoyao("bee") == 1 then
    RemapSoundEvent("dontstarve/bee/bee_takeoff", "")
    RemapSoundEvent("dontstarve/bee/bee_fly_LP", "")
	RemapSoundEvent("dontstarve/bee/bee_box_LP", "")
	--RemapSoundEvent("dontstarve/common/bee_box_craft", "")
end


--捕鸟器禁声
if TUNING.xiaoyao("birdtrap") == 1 then
    RemapSoundEvent("dontstarve/common/birdtrap_rustle", "")
end


--鸟禁声
if TUNING.xiaoyao("bird") == 1 then
    RemapSoundEvent("dontstarve/creatures/smallbird/wings", "")
    RemapSoundEvent("dontstarve/creatures/smallbird/chirp", "")
    RemapSoundEvent("dontstarve/creatures/smallbird/blink", "")
    RemapSoundEvent("dontstarve/creatures/smallbird/chirp_short", "")
--RemapSoundEvent("dontstarve/creatures/smallbird/attack", "")
    RemapSoundEvent("dontstarve/creatures/smallbird/hurt", "")
    RemapSoundEvent("dontstarve/birds/flyin", "")
    RemapSoundEvent("dontstarve/birds/chirp_crow", "")
    RemapSoundEvent("dontstarve/birds/takeoff_crow", "")
    RemapSoundEvent("dontstarve/birds/chirp_robin", "")
    RemapSoundEvent("dontstarve/birds/takeoff_robin", "")
    RemapSoundEvent("dontstarve/birds/chirp_junco", "")
    RemapSoundEvent("dontstarve/birds/takeoff_junco", "")
    RemapSoundEvent("dontstarve/birds/chirp_canary", "")
    RemapSoundEvent("dontstarve/birds/takeoff_canary", "")
end


--露西斧禁声
if TUNING.xiaoyao("lucy") == 1 then
    RemapSoundEvent("dontstarve/characters/woodie/lucytalk_LP", "")
end


--青蛙禁声
if TUNING.xiaoyao("frog") == 1 then
    RemapSoundEvent("dontstarve/frog/walk", "")
    RemapSoundEvent("dontstarve/frog/attack_spit", "")
    RemapSoundEvent("dontstarve/frog/grunt", "")
    RemapSoundEvent("dontstarve/frog/attack_voice", "")
    RemapSoundEvent("dontstarve/frog/wake", "")
end


--桦树精禁声
if TUNING.xiaoyao("deciduous") == 1 then
    RemapSoundEvent("dontstarve_DLC001/creatures/deciduous/rustle", "")
    RemapSoundEvent("dontstarve_DLC001/creatures/deciduous/angry", "")
    RemapSoundEvent("dontstarve_DLC001/creatures/deciduous/whip_move", "")
    RemapSoundEvent("dontstarve_DLC001/creatures/deciduous/whip_pop", "")
    RemapSoundEvent("dontstarve_DLC001/creatures/deciduous/whip", "")
    RemapSoundEvent("dontstarve_DLC001/creatures/deciduous/drake_pop_small", "")
    RemapSoundEvent("dontstarve_DLC001/creatures/deciduous/drake_pop_large", "")
    RemapSoundEvent("dontstarve_DLC001/creatures/deciduous/drake_run_voice", "")
    RemapSoundEvent("dontstarve_DLC001/creatures/deciduous/drake_run_rustle", "")
    RemapSoundEvent("dontstarve_DLC001/creatures/deciduous/drake_run_jump", "")
    RemapSoundEvent("dontstarve_DLC001/creatures/deciduous/drake_intoground", "")
    RemapSoundEvent("dontstarve_DLC001/creatures/deciduous/drake_attack", "")
    RemapSoundEvent("dontstarve_DLC001/creatures/deciduous/drake_die", "")
    RemapSoundEvent("dontstarve_DLC001/creatures/deciduous/hurt_chop", "")
    RemapSoundEvent("dontstarve_DLC001/creatures/deciduous/death", "")
    RemapSoundEvent("dontstarve_DLC001/creatures/deciduous/transform_voicew", "")
    RemapSoundEvent("dontstarve_DLC001/creatures/deciduous/transform_in", "")
end


--过冷过热禁声
if TUNING.xiaoyao("overheat") == 1 then
    RemapSoundEvent("dontstarve_DLC001/common/HUD_hot_level1", "")
    RemapSoundEvent("dontstarve_DLC001/common/HUD_hot_level2", "")
    RemapSoundEvent("dontstarve_DLC001/common/HUD_hot_level3", "")
    RemapSoundEvent("dontstarve_DLC001/common/HUD_hot_level4", "")
	
	RemapSoundEvent("dontstarve/winter/freeze_2nd", "")
    RemapSoundEvent("dontstarve/winter/freeze_3rd", "")
    RemapSoundEvent("dontstarve/winter/freeze_4th", "")
    RemapSoundEvent("dontstarve/winter/freeze_1st", "")
end


--猎狗袭击前的声音
if TUNING.xiaoyao("houndwarning") == 1 then
    RemapSoundEvent("dontstarve/creatures/hound/distant", "")
end

--禁止夏天的某种音效
if TUNING.xiaoyao("summer-ABM") == 1 then
    RemapSoundEvent("dontstarve_DLC001/summer/summerforestAMB", "")
	--RemapSoundEvent("dontstarve_DLC001/summer/summerwaves", "")
	--RemapSoundEvent("dontstarve_DLC001/summer/summerrockyAMB", "")
	--RemapSoundEvent("dontstarve_DLC001/summer/summerbadlandAMB", "")
	--RemapSoundEvent("dontstarve_DLC001/summer/summergrasslandAMB", "")
	--RemapSoundEvent("dontstarve_DLC001/summer/summermeadowAMB", "")
	--RemapSoundEvent("dontstarve_DLC001/summer/summermarshAMB", "")
	--RemapSoundEvent("dontstarve_DLC001/summer/summerchessAMB", "")
end


--蜘蛛喊叫的声音
if TUNING.xiaoyao("spider") == 1 then
    --RemapSoundEvent("dontstarve/creatures/spider/spider_egg_sack", "")
	--RemapSoundEvent("dontstarve/creatures/spider/spiderLair_grow", "")
	--RemapSoundEvent("dontstarve/creatures/spider/spidernest_LP", "")
	RemapSoundEvent("dontstarve/creatures/spider/scream", "")
	--RemapSoundEvent("dontstarve/creatures/spider/walk_spider", "")
	--RemapSoundEvent("dontstarve/creatures/spider/fallAsleep", "")
	--RemapSoundEvent("dontstarve/creatures/spider/sleeping", "")
	--RemapSoundEvent("dontstarve/creatures/spider/Attack", "")
	--RemapSoundEvent("dontstarve/creatures/spider/attack_grunt", "")
	--RemapSoundEvent("dontstarve/creatures/spider/die", "")
	
	RemapSoundEvent("dontstarve/creatures/spiderwarrior/scream", "")
	--RemapSoundEvent("dontstarve/creatures/spiderwarrior/walk_spider", "")
	--RemapSoundEvent("dontstarve/creatures/spiderwarrior/fallAsleep", "")
	--RemapSoundEvent("dontstarve/creatures/spiderwarrior/sleeping", "")
	--RemapSoundEvent("dontstarve/creatures/spiderwarrior/Attack", "")
	--RemapSoundEvent("dontstarve/creatures/spiderwarrior/attack_grunt", "")
	--RemapSoundEvent("dontstarve/creatures/spiderwarrior/die", "")
end

--鬼魂（包括阿比盖尔）禁声
if TUNING.xiaoyao("ghosts") == 1 then
    RemapSoundEvent("dontstarve/ghost/ghost_girl_howl_LP", "")
	RemapSoundEvent("dontstarve/ghost/ghost_girl_howl", "")
	RemapSoundEvent("dontstarve/ghost/ghost_girl_attack_LP", "")
	RemapSoundEvent("dontstarve/ghost/ghost_girl_attack", "")
	RemapSoundEvent("dontstarve/ghost/ghost_girl_redux", "")
	RemapSoundEvent("dontstarve/ghost/ghost_howl", "")
	RemapSoundEvent("dontstarve/ghost/ghost_attack_LP", "")
	RemapSoundEvent("dontstarve/ghost/ghost_haunt", "")
end


--蚊子禁声
if TUNING.xiaoyao("mosquito") == 1 then
    RemapSoundEvent("dontstarve/creatures/mosquito/mosquito_fly_LP", "")
	RemapSoundEvent("dontstarve/creatures/mosquito/mosquito_hurt", "")
	--RemapSoundEvent("dontstarve/creatures/mosquito/mosquito_attack", "")
end


--矮星极光禁声
if TUNING.xiaoyao("staff") == 1 then
    --RemapSoundEvent("dontstarve/common/staff_star_create", "")
	RemapSoundEvent("dontstarve/common/staff_star_LP", "")
	RemapSoundEvent("dontstarve/common/staff_coldlight_LP", "")
end

--切斯特走路禁声
if TUNING.xiaoyao("chester") == 1 then
    --RemapSoundEvent("dontstarve/creatures/chester/pant", "")
	RemapSoundEvent("dontstarve/creatures/chester/boing", "")
	--RemapSoundEvent("dontstarve/creatures/chester/open", "")
	--RemapSoundEvent("dontstarve/creatures/chester/close", "")
	--RemapSoundEvent("dontstarve/creatures/chester/hurt", "")
	--RemapSoundEvent("dontstarve/creatures/chester/raise", "")
end


--食人花禁声
if TUNING.xiaoyao("lureplants") == 1 then
    RemapSoundEvent("dontstarve/creatures/eyeplant/eye_retract", "")
	RemapSoundEvent("dontstarve/creatures/eyeplant/eye_bite", "")
	RemapSoundEvent("dontstarve/creatures/eyeplant/eye_emerge", "")
	RemapSoundEvent("dontstarve/creatures/eyeplant/eye_bite", "")
	RemapSoundEvent("dontstarve/creatures/eyeplant/vine_emerge", "")
end


--打雷禁声
if TUNING.xiaoyao("thunder") == 1 then
    RemapSoundEvent("dontstarve/rain/thunder_close", "")
	RemapSoundEvent("dontstarve/rain/thunder_far", "")
end

--火鸡禁声
if TUNING.xiaoyao("perd") == 1 then
    RemapSoundEvent("dontstarve/creatures/perd/gobble", "")
	RemapSoundEvent("dontstarve/creatures/perd/scream", "")
	RemapSoundEvent("dontstarve/creatures/perd/run", "")
	RemapSoundEvent("dontstarve/creatures/perd/sleep", "")
	RemapSoundEvent("dontstarve/creatures/perd/gobble", "")
end

--秃鹫禁声
if TUNING.xiaoyao("buzzard") == 1 then
    RemapSoundEvent("dontstarve_DLC001/creatures/buzzard/death", "")
	RemapSoundEvent("dontstarve_DLC001/creatures/buzzard/taunt", "")
	RemapSoundEvent("dontstarve_DLC001/creatures/buzzard/squack", "")
	RemapSoundEvent("dontstarve_DLC001/creatures/buzzard/flap", "")
	RemapSoundEvent("dontstarve_DLC001/creatures/buzzard/attack", "")
	RemapSoundEvent("dontstarve_DLC001/creatures/buzzard/flyout", "")
	RemapSoundEvent("dontstarve_DLC001/creatures/buzzard/hurt", "")
end


--抓火黑手禁声
if TUNING.xiaoyao("shadowhand") == 1 then
    RemapSoundEvent("dontstarve/sanity/shadowhand_snuff", "")
	RemapSoundEvent("dontstarve/sanity/shadowhand_creep", "")
	RemapSoundEvent("dontstarve/sanity/shadowhand_retreat", "")
end


--火炉禁声
if TUNING.xiaoyao("dragonflyfurnace") == 1 then
    RemapSoundEvent("dontstarve/common/together/dragonfly_furnace/fire_LP", "")
	RemapSoundEvent("dontstarve/common/together/dragonfly_furnace/light", "")
	--RemapSoundEvent("dontstarve/common/together/dragonfly_furnace/place", "")
end

--兔子禁声
if TUNING.xiaoyao("rabbit") == 1 then
    RemapSoundEvent("dontstarve/rabbit/hop", "")
	RemapSoundEvent("dontstarve/rabbit/scream", "")
	RemapSoundEvent("dontstarve/rabbit/beardscream", "")
	RemapSoundEvent("dontstarve/rabbit/scream_short", "")
	RemapSoundEvent("dontstarve/rabbit/winterscream", "")
	RemapSoundEvent("dontstarve/rabbit/winterscream_short", "")
	RemapSoundEvent("dontstarve/rabbit/beardscream", "")
	RemapSoundEvent("dontstarve/rabbit/beardscream", "")
	RemapSoundEvent("dontstarve/rabbit/beardscream", "")
	RemapSoundEvent("dontstarve/rabbit/beardscream", "")
end


--鼹鼠禁声
if TUNING.xiaoyao("mole") == 1 then
    RemapSoundEvent("dontstarve_DLC001/creatures/mole/death", "")
	RemapSoundEvent("dontstarve_DLC001/creatures/mole/sleep", "")
	RemapSoundEvent("dontstarve_DLC001/creatures/mole/emerge", "")
	RemapSoundEvent("dontstarve_DLC001/creatures/mole/emerge_voice", "")
	RemapSoundEvent("dontstarve_DLC001/creatures/mole/sniff", "")
	RemapSoundEvent("dontstarve_DLC001/creatures/mole/jump", "")
	RemapSoundEvent("dontstarve_DLC001/creatures/mole/retract", "")
end


--浣熊猫禁声
if TUNING.xiaoyao("catcoon") == 1 then
    RemapSoundEvent("dontstarve_DLC001/creatures/catcoon/pickup", "")
	RemapSoundEvent("dontstarve_DLC001/creatures/catcoon/hiss_pre", "")
	RemapSoundEvent("dontstarve_DLC001/creatures/catcoon/hurt", "")
	RemapSoundEvent("dontstarve_DLC001/creatures/catcoon/swipe_tail", "")
	RemapSoundEvent("dontstarve_DLC001/creatures/catcoon/hairball_hack", "")
	RemapSoundEvent("dontstarve_DLC001/creatures/catcoon/hairball_vomit", "")
	RemapSoundEvent("dontstarve_DLC001/creatures/catcoon/pickup", "")
	RemapSoundEvent("dontstarve_DLC001/creatures/catcoon/pounce_pre", "")
	RemapSoundEvent("dontstarve_DLC001/creatures/catcoon/pounce", "")
	RemapSoundEvent("dontstarve_DLC001/creatures/catcoon/hiss", "")
	RemapSoundEvent("dontstarve_DLC001/creatures/catcoon/attack", "")
	RemapSoundEvent("dontstarve_DLC001/creatures/catcoon/swipe", "")
	RemapSoundEvent("dontstarve_DLC001/creatures/catcoon/swipe_pre", "")
	RemapSoundEvent("dontstarve_DLC001/creatures/catcoon/swipe_whoosh", "")
	RemapSoundEvent("dontstarve_DLC001/creatures/catcoon/death", "")
	RemapSoundEvent("dontstarve_DLC001/creatures/catcoon/yawn", "")
	RemapSoundEvent("dontstarve_DLC001/creatures/catcoon/sleep", "")
end

--靠近科技禁声
if TUNING.xiaoyao("researchmachine") == 1 then
    RemapSoundEvent("dontstarve/common/researchmachine_lvl3_idle", "")
	RemapSoundEvent("dontstarve/common/researchmachine_lvl3_idle_LP", "")
	RemapSoundEvent("dontstarve/common/researchmachine_lvl2_idle_LP", "")
	RemapSoundEvent("dontstarve/HUD/research_available", "")
end

--草蜥蜴禁声
if TUNING.xiaoyao("grassgekko") == 1 then
    RemapSoundEvent("dontstarve/creatures/together/grass_gekko/hit", "")
	RemapSoundEvent("dontstarve/creatures/together/grass_gekko/tail_off", "")
	RemapSoundEvent("dontstarve/creatures/together/grass_gekko/tail_regrow", "")
	RemapSoundEvent("dontstarve/wilson/pickup_reeds", "")
	RemapSoundEvent("dontstarve/creatures/together/grass_gekko/emerge", "")
	RemapSoundEvent("dontstarve/creatures/together/grass_gekko/death", "")
	RemapSoundEvent("dontstarve/creatures/together/grass_gekko/body_fall", "")
	RemapSoundEvent("dontstarve/creatures/together/grass_gekko/sleep_pre", "")
	RemapSoundEvent("dontstarve/creatures/together/grass_gekko/sleep", "")
end