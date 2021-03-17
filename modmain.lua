GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end})
local G = GLOBAL
G.getmetatable(G.TheSim).__index.ShouldWarnModsLoaded = function() return false end
G.KnownModIndex.GetIsSpecialEventModWarningDisabled = function() return true end


TUNING.xiaoyao = GetModConfigData

PrefabFiles = {

}

Assets ={
 
}



GLOBAL.TUNING.MAX_SERVER_SIZE = GetModConfigData("服务器人数")


modimport("xiaoyao/jichulvjing")------滤镜兼容


if GetModConfigData("四季滤镜") then
table.insert(Assets,Asset("IMAGE","images/colour_cubes/sw_mild_day_cc.tex"))
table.insert(Assets,Asset("IMAGE","images/colour_cubes/SW_mild_dusk_cc.tex"))
table.insert(Assets,Asset("IMAGE","images/colour_cubes/SW_mild_night_cc.tex"))
table.insert(Assets,Asset("IMAGE","images/colour_cubes/SW_wet_day_cc.tex"))
table.insert(Assets,Asset("IMAGE","images/colour_cubes/SW_wet_dusk_cc.tex"))
table.insert(Assets,Asset("IMAGE","images/colour_cubes/SW_wet_night_cc.tex"))
table.insert(Assets,Asset("IMAGE","images/colour_cubes/sw_green_day_cc.tex"))
table.insert(Assets,Asset("IMAGE","images/colour_cubes/sw_green_dusk_cc.tex"))
table.insert(Assets,Asset("IMAGE","images/colour_cubes/SW_dry_day_cc.tex"))
table.insert(Assets,Asset("IMAGE","images/colour_cubes/SW_dry_dusk_cc.tex"))
table.insert(Assets,Asset("IMAGE","images/colour_cubes/SW_dry_night_cc.tex"))
modimport("xiaoyaoziti/sijilvjing")------四季滤镜
end

modimport("xiaoyao/xianshiwenjianming")-------显示模组文件位置

if GetModConfigData("仇恨与跟随目标显示") then
modimport("xiaoyao/1chouhenxians")--仇恨与跟随目标显示
end

if GetModConfigData("攻击技能间隔显示") then
modimport("xiaoyao/2gongjidaojishi")--攻击技能间隔显示
end

if GetModConfigData("游戏中模组设置") then
modimport("xiaoyao/3dakaikehuduan")--游戏中模组设置
end

if GetModConfigData("自动填充燃料") then
modimport("xiaoyao/4zidongtianchong")--自动填充燃料
end

if GetModConfigData("自动填充燃料") then
modimport("xiaoyao/4zidongtianchong2")--自动填充燃料
end

if GetModConfigData("自动走A") then
modimport("xiaoyao/5zidongzoua")--自动走A
end

if GetModConfigData("幽灵玩家") then
table.insert(PrefabFiles,"ghostchars")
modimport("xiaoyao/6youlingwanjia")--幽灵玩家
end

if GetModConfigData("坐标系统") then
modimport("xiaoyao/7zuobiaoxitong")--坐标系统
end

if GetModConfigData("更多图标") then
modimport("xiaoyao/7zuobiaoxitong2")--更多图标有bug会导致很多生物静音
end

if GetModConfigData("坐标系统") then
table.insert(PrefabFiles,"flagplacer")
table.insert(Assets,Asset("ATLAS", "images/icon.xml"))---1
table.insert(Assets,Asset("IMAGE", "images/icon.tex"))--------2
table.insert(Assets,Asset("ATLAS", "images/flag.xml"))---------3
table.insert(Assets,Asset("IMAGE", "images/flag.tex"))-----------4
table.insert(Assets,Asset("ATLAS", "images/flagmini.xml"))---------5
table.insert(Assets,Asset("IMAGE", "images/flagmini.tex"))---------6
table.insert(Assets,Asset("ATLAS", "images/white.xml"))
table.insert(Assets,Asset("IMAGE", "images/white.tex"))
table.insert(Assets,Asset("ATLAS", "images/npanel.xml"))
table.insert(Assets,Asset("IMAGE", "images/npanel.tex"))
table.insert(Assets,Asset("ATLAS", "images/npanelbg.xml"))
table.insert(Assets,Asset("IMAGE", "images/npanelbg.tex"))
table.insert(Assets,Asset("ATLAS", "images/ninput.xml"))
table.insert(Assets,Asset("IMAGE", "images/ninput.tex"))
table.insert(Assets,Asset("ATLAS", "images/nline.xml"))
table.insert(Assets,Asset("IMAGE", "images/nline.tex"))
table.insert(Assets,Asset("ATLAS", "images/nuiwp.xml"))
table.insert(Assets,Asset("IMAGE", "images/nuiwp.tex"))
modimport("xiaoyao/7zuobiaoxit")--坐标系统
end

if GetModConfigData("微型地图") then
table.insert(Assets,Asset("ATLAS", "images/smallmap_ui.xml"))
modimport("xiaoyao/11dituxitou")--地图系统
end

if GetModConfigData("锁定地图") then
table.insert(Assets,Asset("ATLAS", "images/arrow.xml"))
modimport("xiaoyao/11dituxitou2")--地图系统
end

if GetModConfigData("显示攻击范围") then
table.insert(PrefabFiles,"xiaoyaofanweixianshi")
modimport("xiaoyao/8gongjifanwei")--攻击范围显示
end

if GetModConfigData("显示攻击范围") then
table.insert(PrefabFiles,"xiaoyaofanweixianshi")
modimport("xiaoyao/8gongjifanwe2")--攻击范围显示
end
if GetModConfigData("显示攻击范围") then
table.insert(Assets,Asset("IMAGE", "images/Animal_Track.tex"))
table.insert(Assets,Asset("ATLAS", "images/Animal_Track.xml"))
modimport("xiaoyao/8gongjifanwe233")--攻击范围显示
end
if GetModConfigData("显示攻击范围") then
table.insert(PrefabFiles,"xiaoyaofanweixianshi")
modimport("xiaoyao/8gongjifanwei111")--攻击范围显示
end
if GetModConfigData("显示攻击范围") then
table.insert(Assets,Asset("ANIM", "anim/eyepos.zip"))
modimport("xiaoyao/8gongjifanwei112")--攻击范围显示
end

if GetModConfigData("避雷针") then
table.insert(Assets,Asset("ANIM", "anim/lightning_rod_placer.zip"))
table.insert(PrefabFiles,"lightningrod")
table.insert(PrefabFiles,"lightning_rod_range")
modimport("xiaoyao/8bileizhen")--避雷针
end

if GetModConfigData("显示攻击范围") then
table.insert(PrefabFiles,"xiaoyaofanweixianshi")
modimport("xiaoyao/8gongjifanwei8848")--攻击范围显示
end

if GetModConfigData("高亮显示") then
modimport("xiaoyao/8gongjifanwei9999")--高亮显示
end

if GetModConfigData("显示攻击范围") then
table.insert(Assets,Asset("ATLAS", "images/mod_bossindicators_icons.xml"))
table.insert(Assets,Asset("IMAGE", "images/mod_bossindicators_icons.tex"))
modimport("xiaoyao/9bossweizhi")--boss位置
end

if GetModConfigData("袭击警示") then
modimport("xiaoyao/9xijijingshi")--袭击警示
end

if GetModConfigData("显示人物攻击范围") then
table.insert(PrefabFiles,"xiaoyaofanweixianshi")
modimport("xiaoyao/9renwufanwei1")--人物范围显示
end


if GetModConfigData("显示人物攻击范围") then
table.insert(PrefabFiles,"xiaoyaofanweixianshi")
modimport("xiaoyao/9renwufanwei2")--人物范围显示
end

if GetModConfigData("夜视全图滤镜处理") then
modimport("xiaoyao/10yeshilvjing")--夜视滤镜
end
if GetModConfigData("夜视全图滤镜处理") then
modimport("xiaoyao/10yeshilvjing2")--夜视滤镜
end
if GetModConfigData("夜视全图滤镜处理2") then
modimport("xiaoyao/10yeshilvjing3")--OB视角
end



if GetModConfigData("超高数据显示") then
table.insert(Assets,Asset("ATLAS", "images/status_bgs.xml"))
table.insert(Assets,Asset("ATLAS", "images/rain.xml"))
table.insert(Assets,Asset("ANIM", "anim/moon_waning_phases.zip"))
table.insert(Assets,Asset("ANIM", "anim/moon_aporkalypse_waning_phases.zip"))
modimport("xiaoyao/chaogaoshujvxianshi")--超高数据显示
end
if GetModConfigData("超高数据显示") then
table.insert(Assets,Asset("IMAGE", "images/charge_meter_stuck_bg.tex"))
table.insert(Assets,Asset("ATLAS", "images/charge_meter_stuck_bg.xml"))
table.insert(Assets,Asset("ANIM", "anim/charge_meter.zip"))
modimport("xiaoyao/chaogaoshujvxianshi2")--超高数据显示
end
if GetModConfigData("超高数据显示") then
table.insert(Assets,Asset("ANIM", "anim/nigthmarephaseindicator.zip"))
modimport("xiaoyao/chaogaoshujvxianshi3")--超高数据显示
end

if GetModConfigData("超高数据显示") then
modimport("xiaoyao/chaogaoshujvxianshi4")--超高数据显示
end

if GetModConfigData("操作提升") then
modimport("xiaoyao/12caozuotisheng")--操作提升
end

if GetModConfigData("操作提升2") then
modimport("xiaoyao/12caozuotisheng2")--操作提升
end

if GetModConfigData("输入优化") then
modimport("xiaoyao/13shuruyouhua")--输入优化
end

if GetModConfigData("几何布局") then
modimport("xiaoyao/wupengzhuangtiji")--无碰撞体积
end
if GetModConfigData("几何布局") then
table.insert(PrefabFiles,"actiongridplacer")
table.insert(PrefabFiles,"buildgridplacer")
table.insert(Assets,Asset("ANIM", "anim/geo_gridplacer.zip"))
table.insert(Assets,Asset("ANIM", "anim/buildgridplacer.zip"))
modimport("xiaoyao/jihebujv")--几何布局
end

if GetModConfigData("快捷制作栏") then
table.insert(Assets,Asset("ATLAS", "images/favrecipesinventoryimages.xml"))
table.insert(Assets,Asset("IMAGE", "images/favrecipesinventoryimages.tex"))
table.insert(Assets,Asset("ATLAS", "images/favrecipes_check.xml"))
table.insert(Assets,Asset("IMAGE", "images/favrecipes_check.tex"))
modimport("xiaoyao/kuaijiezhizuo")--快捷制作
end


if GetModConfigData("农场辅助") then
table.insert(Assets,Asset("ATLAS", "images/nutrientBTN.xml"))
table.insert(Assets,Asset("IMAGE", "images/nutrientBTN.tex"))
table.insert(Assets,Asset("ATLAS", "images/registerBTN.xml"))
table.insert(Assets,Asset("IMAGE", "images/registerBTN.tex"))
table.insert(Assets,Asset("ATLAS", "images/Empty.xml"))
table.insert(Assets,Asset("IMAGE", "images/Empty.tex"))
modimport("xiaoyao/nongchangfuzhu")--农场辅助
end


---------------------------------------------------简单功能
if GetModConfigData("名称显示") then
modimport("xiaokeai/14mingzixianshi")--名称显示
end

if GetModConfigData("智能锅") then
table.insert(Assets,Asset("ATLAS", "images/food_tags.xml"))
table.insert(Assets,Asset("ATLAS", "images/recipe_hud.xml"))
modimport("xiaokeai/15zhinengcanguo")--智能锅
end

if GetModConfigData("快捷宣告") then
modimport("xiaokeai/16kuaijiexvangao")--快捷宣告
end

if GetModConfigData("快捷宣告") then
modimport("xiaokeai/16kuaijiexvangao")--快捷宣告
end


if GetModConfigData("G键表情") then
table.insert(Assets,Asset("IMAGE", "images/gesture_bg.tex"))
table.insert(Assets,Asset("ATLAS", "images/gesture_bg.xml"))
modimport("xiaokeai/17kuaijiebiaoqing")--快捷宣告
end

if GetModConfigData("物品信息") then
table.insert(Assets,Asset("ATLAS", "images/iteminfo_images.xml"))
table.insert(Assets,Asset("IMAGE", "images/iteminfo_images.tex"))
table.insert(Assets,Asset("ATLAS", "images/iteminfo_bg.xml"))
table.insert(Assets,Asset("IMAGE", "images/iteminfo_bg.tex"))
modimport("xiaokeai/18wupinxinxi")--物品信息
end

if GetModConfigData("黑化排队论") then
table.insert(Assets,Asset("ATLAS", "images/selection_square.xml"))
table.insert(Assets,Asset("IMAGE", "images/selection_square.tex"))
modimport("xiaokeai/19heihuapaiduilun")--黑化排队论
end

if GetModConfigData("黑化排队论") then
table.insert(Assets,Asset("ANIM", "anim/snaptillplacer.zip"))
table.insert(PrefabFiles,"snaptillplacer")
modimport("xiaokeai/19heihuapaiduilun2")--黑化排队论
end

if GetModConfigData("自动钓鱼") then
modimport("xiaokeai/20zidongdiaoyu")--自动钓鱼
end
if GetModConfigData("自动海钓") then
modimport("xiaokeai/21zidongdiaoyu")--自动海钓
end

if GetModConfigData("装备固定") then
modimport("xiaokeai/22zhuangbeiguding")--固定装备
end
if GetModConfigData("禁声系统") then
modimport("xiaokeai/23jinshengxitong")--禁声系统
end
if GetModConfigData("透明地图") then
modimport("xiaokeai/24toumingditu")--透明地图
end
if GetModConfigData("自动烹饪") then
modimport("xiaokeai/25zidongpengren")--自动烹饪
end
--------------------------------------------------
-- if GetModConfigData("方正喵呜") then
-- modimport("xiaoyaoziti/fangzhengmiaowu")--方正喵呜
-- end

-- if GetModConfigData("本墨悠圆") then
-- modimport("xiaoyaoziti/benmoyouyuan")--本墨悠圆
-- end

if GetModConfigData("修改字体大小") then
modimport("xiaoyaoziti/zitixiugai")--修改字体大小
end

if GetModConfigData("制作物品美化") then
table.insert(Assets,Asset("ATLAS", "images/locked_nextlevel.xml"))
table.insert(Assets,Asset("ATLAS", "images/slot_locked.xml"))
table.insert(Assets,Asset("ATLAS", "images/locked_highlight.xml"))
table.insert(Assets,Asset("ATLAS", "images/craft_slot_prototype.xml"))
table.insert(Assets,Asset("ATLAS", "images/craft_slot_locked_highlight.xml"))
table.insert(Assets,Asset("ATLAS", "images/craft_slot_missing_mats.xml"))
modimport("xiaoyaoziti/zhizuowupinmeihua")--制作物品美化
end

if GetModConfigData("制作物品美化2") then
local slotAtlas = 'images/slots.xml'
local iconAtlas = 'images/icons.xml'
table.insert(Assets,Asset("ATLAS", slotAtlas))
table.insert(Assets,Asset("IMAGE", "images/slots.tex"))
table.insert(Assets,Asset("ATLAS", iconAtlas))
table.insert(Assets,Asset("IMAGE", "images/icons.tex"))
modimport("xiaoyaoziti/zhizuowupinmeihua2")--制作物品美化2
end

----------------------------------------------------
-- if GetModConfigData("禁止强A") then
-- AddComponentPostInit("playercontroller", function(self)
	-- local oldGetAttackTarget = self.GetAttackTarget
	-- function self:GetAttackTarget(force_attack, force_target, isretarget)
		-- force_attack = false
		-- force_target = nil
		-- isretarget = false
		-- return oldGetAttackTarget(self,force_attack, force_target, isretarget)
	-- end
-- end)
-- end
-----------------------------------------------------

--------------------------------------------------------

if GetModConfigData("快捷制作") then
modimport("xiaokeai/28kuaijiezhizuo")---快捷制作
end

if GetModConfigData("夜视全图滤镜处理") then
table.insert(Assets,Asset( "ATLAS", "images/lw_cameraUI.xml" ))
modimport("xiaokeai/27shexiangtou")---摄像头
end


if GetModConfigData("加宽制作栏") then
modimport("xiaokeai/26zhizuoranyouhua")--加宽制作栏
end

