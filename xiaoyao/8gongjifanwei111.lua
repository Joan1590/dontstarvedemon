

local colour = TUNING.xiaoyao("攻击范围显示")
fanweixianshi = TUNING.xiaoyao("范围显示")


local xianshi = true


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

local yansebiao  ={
	{ 255 / 255, 0 / 255, 0/ 255, 1 },	--------红色
	{ 204 / 255, 131 / 255, 57 / 255, 2 },
	{ 204 / 255, 131 / 255, 57 / 255, 3 },
	{ 204 / 255, 131 / 255, 57 / 255, 4 },
	{ 204 / 255, 131 / 255, 57 / 255, 5 },
	{ 204 / 255, 131 / 255, 57 / 255, 6 },
	{ 204 / 255, 131 / 255, 57 / 255, 7 },
}

local function rangeScale(self, rangeNum)
	local hitrangescale = math.sqrt(rangeNum * 300 / 1900)
	local s1, s2, s3 = self.Transform:GetScale()
	if self and self.xiaoyaofanwei then
		if rangeNum ~= nil and rangeNum > 0 then
			self.xiaoyaofanwei.Transform:SetScale(hitrangescale/s1, hitrangescale/s2, hitrangescale/s3 )
		else
			self.xiaoyaofanwei.Transform:SetScale(0.001,0.001,0.001)
		end
	end
end

local function showornot(self)
	if xianshi then
		self:Show()
	else
		self:Hide()
	end
end
local function Createxiaoyaofanwei(self)
	if self and self.xiaoyaofanwei == nil then
		self.xiaoyaofanwei = GLOBAL.SpawnPrefab("xiaoyaofanweixianshi")
		self.xiaoyaofanwei.entity:SetParent(self.entity)
		self.xiaoyaofanwei.AnimState:SetLightOverride(1)
		self.xiaoyaofanwei.AnimState:SetSortOrder(1)
		self.xiaoyaofanwei:ListenForEvent("开关攻击范围", function()
			showornot(self.xiaoyaofanwei)
		end,TheWorld)
		showornot(self.xiaoyaofanwei)
		if yansebiao[colour] ~= nil then
			self.xiaoyaofanwei.AnimState:SetMultColour(unpack(yansebiao[colour]))
		end
	end
end


local gongjirange = {
tentacle = 4,  --潮湿的 触手
waterplant = 18,  --海草
wasphive = 6,  --杀人蜂蜂窝
fruitdragon = 2,  --沙拉蝾螈
spiderden = 3,  --蜘蛛巢
beefalo = 3,  --皮弗娄牛
beehive = 3,  --蜂窝
knight = 3,  --发条骑士
crabking = 5,  --帝王蟹
lightninggoat = 3,  --伏特羊
houndmound = 3,  --猎犬丘
rook = 3,  --发条战车
rabbit = 3,  --兔子
mole = 3,  --鼹鼠
pigman = 3,  --罗穆卢斯
---gears = 3,  --齿轮
--animal_track = 3,  --足迹
---dirtpile = 3,
tallbird = 3,  --高脚鸟
-- 
butterfly = 3,  --蝴蝶
mutated_penguin = 2.5,  --月岩企鸥
mutatedhound = 3,  --恐怖猎犬
nightmarebeak = 3,  --梦魇尖喙
penguin = 2.5,  --企鸥
perd = 3,  --火鸡
crawlinghorror = 3,  --爬行恐惧
fossilspike = 2,  --化石笼子
mosquito = 1.75,  --蚊子
pigelite1 = 0.7,  --韦德
pigelite2 = 0.7,  --伊格内修斯
pigelite3 = 0.7,  --德米特里
pigelite4 = 0.7,  --索耶
frog = 3,  --青蛙

pumpkin_lantern = 3,  --南瓜灯
bunnyman = 3,  --防风草


rocky = 4,  --石虾
rook_nightmare = 3,  --损坏的发条战车
ruins_chair = 3,  --废墟
ruins_bowl = 3,  --废墟
ruins_chipbowl = 3,  --废墟
shadow_bishop = 4,  --暗影主教
shadow_rook = 8,  --暗影战车
shadowdigger = 2,  --影子分身
shadowlumber = 2,  --影子分身
shark = 3,  --岩石大白鲨
shadowminer = 2,  --影子分身
slurper = 8,  --啜食者
slurtle = 2.5,  --蛞蝓龟
smallbird = 3,  --小鸟
slurtlehole = 3,  --蛞蝓龟窝
snurtle = 3,  --蜗牛龟
spat = 3,  --钢羊
spider_spitter = 5,  --喷射蜘蛛
spider_moon = 6,  --破碎蜘蛛
spider_hider = 3,  --洞穴蜘蛛
spider_dropper = 6,  --穴居悬蛛
spider = 3,  --蜘蛛
spider_warrior = 6,  --蜘蛛战士
moonspider_spike = 3,  --破碎蜘蛛
spiderqueen = 5,  --蜘蛛女王
squid = 2,  --鱿鱼
stalker = 2.4,  --复活的骨架
stalker_atrium = 2.4,  --远古织影者
stalker_forest = 3,  --复活的骨架
stalker_minion2 = 3,  --编织暗影
stalker_minion1 = 3,  --编织暗影
teenbird = 3,  --小高脚鸟
toadstool_dark = 7,  --悲惨的毒菌蟾蜍
toadstool = 7,  --毒菌蟾蜍

walrus = 15,  --海象
warg = 5,  --座狼
sporecloud = 3,  --孢子云
hound = 3,  --猎犬
wobster_moonglass_land = 3,  --月光龙虾
worm = 3,  --潮湿的 土堆
wobster_sheller_land = 3,  --龙虾
wurt = 2,  --沃特
tentacle = 4,  --潮湿的 触手
wasphive = 6,  --杀人蜂蜂窝
waterplant = 18,  --海草
beehive = 3,  --蜂窝
spiderden = 3,  --蜘蛛巢
fruitdragon = 2,  --沙拉蝾螈
beefalo = 3,  --皮弗娄牛
houndmound = 3,  --猎犬丘
rook = 3,  --发条战车
knight = 3,  --发条骑士
lightninggoat = 3,  --伏特羊
crabking = 5,  --帝王蟹
rabbit = 3,  --兔子
pigman = 3,  --卡斯塔德
mole = 3,  --鼹鼠

tallbird = 3,  --高脚鸟

butterfly = 3,  --蝴蝶

abigail = 3,  --阿比盖尔
babybeefalo = 3,  --小皮弗娄牛
spider_moon = 6,  --破碎蜘蛛
bat = 1.5,  --洞穴蝙蝠
bearger = 6,  --熊獾
moonspider_spike = 3,  --破碎蜘蛛
bee = 0.6,  --蜜蜂
beeguard = 1.5,  --嗡嗡蜜蜂
killerbee = 0.6,  --杀人蜂
beequeen = 4,  --蜂王
birchnutdrake = 2.5,  --桦栗果精
bishop_nightmare = 6,  --损坏的发条主教
bishop = 6,  --发条主教
bunnyman = 3,  --木耳
buzzard = 2,  --秃鹫


catcoon = 4,  --浣猫
claywarg = 5,  --黏土座狼
clayhound = 3,  --黏土猎犬
chester = 3,  --切斯特
crabking_claw = 0,  --巨钳
crawlingnightmare = 3,  --爬行梦魇
deer_red = 3,  --无眼鹿

deer = 3,  --无眼鹿
eyeplant = 2.5,  --眼球草
eyeturret = 15,  --眼睛炮塔
spider_dropper = 6,  --穴居悬蛛

ghost = 3,  --幽灵
gingerbreadpig = 3,  --姜饼猪
gingerbreadwarg = 5,  --姜饼座狼
glommer = 3,  --格罗姆
gnarwail = 9,  --一角鲸
grassgekko = 3,  --草壁虎
hound = 3,  --猎犬
hutch = 3,  --哈奇
icehound = 3,  --蓝色猎犬
deer_blue = 3,  --无眼鹿
klaus = 3,  --克劳斯
mutatedhound = 3,  --恐怖猎犬
knight_nightmare = 3,  --损坏的发条骑士
koalefant_winter = 3,  --考拉象
krampus = 3,  --坎普斯
leif = 3,  --树精守卫
little_walrus = 15,  --小海象
lureplant = 3,  --食人花
merm = 3,  --潮湿的 鱼人
mermguard = 3,  --潮湿的 忠诚鱼人守卫
carrat = 3,  --胡萝卜鼠
mermking = 3,  --潮湿的 鱼人之王
minotaur = 3,  --远古守护者
monkey = 3,  --暴躁猴
moonbutterfly = 3,  --月蛾
moonpig = 3,  --奥瑞利安
moonhound = 3,  --猎犬
moose = 5.5,  --麋鹿鹅
mossling = 2,  --麋鹿鹅幼崽
mosquito = 1.75,  --蚊子
waterplant = 18,  --海草
beefalo = 3,  --皮弗娄牛
tentacle = 4,  --潮湿的 触手
bishop = 6,  --发条主教
beehive = 3,  --蜂窝
spiderden = 3,  --蜘蛛巢
fruitdragon = 2,  --沙拉蝾螈
lightninggoat = 3,  --伏特羊
houndmound = 3,  --猎犬丘
crabking = 5,  --帝王蟹
wasphive = 6,  --杀人蜂蜂窝
knight = 3,  --发条骑士
icehound = 3,  --蓝色猎犬
mole = 3,  --鼹鼠
rabbit = 3,  --兔子
pigman = 3,  --伽列里乌斯
tallbird = 3,  --高脚鸟


butterfly = 3,  --蝴蝶
frog = 3,  --青蛙
bee = 0.6,  --蜜蜂

cookiecutter = 3,  --饼干切割机
ruins_bowl = 3,  --废墟
ruins_chair = 3,  --废墟
ruins_chipbowl = 3,  --废墟
ruins_rubble_vase = 3,  --损毁的废墟
ruins_rubble_table = 3,  --损毁的废墟
ruins_rubble_chair = 3,  --损毁的废墟



shadowtentacle_root = 2,  --MISSING NAME

shadowtentacle_root = 2,  --MISSING NAME
shadowtentacle = 2,  --暗影触手
mosquito = 1.75,  --蚊子

eyeturret = 15,  --眼睛炮塔
winona_catapult = 15,  --薇诺娜的投石机
chester = 3,  --切斯特
hutch = 3,  --哈奇
glommer = 3,  --格罗姆
lavae_pet = 3,  --超级可爱岩浆虫
abigail = 3,  --阿比盖尔
shadowdigger = 2,  --影子分身
shadowlumber = 2,  --影子分身
shadowminer = 2,  --影子分身
shadowduelist = 2,  --影子分身
killerbee = 0.6,  --杀人蜂
bat = 1.5,  --洞穴蝙蝠
spider_moon = 6,  --破碎蜘蛛
spider_hider = 3,  --洞穴蜘蛛
spider = 3,  --蜘蛛
stalker_minion1 = 3,  --编织暗影
stalker_minion2 = 3,  --编织暗影
birchnutdrake = 2.5,  --桦栗果精
crabking_claw = 0,  --巨钳
moonpig = 3,  --巴尔比努斯
moonhound = 3,  --猎犬
gingerbreadpig = 3,  --姜饼猪
pigelite4 = 0.7,  --索耶
pigelite3 = 0.7,  --德米特里
pigelite2 = 0.7,  --伊格内修斯
pigelite1 = 0.7,  --韦德
merm = 3,  --潮湿的 鱼人
mermguard = 3,  --潮湿的 忠诚鱼人守卫
mermking = 3,  --潮湿的 鱼人之王
mutatedhound = 3,  --恐怖猎犬
babybeefalo = 3,  --小皮弗娄牛
bearger = 6,  --熊獾
beeguard = 1.5,  --嗡嗡蜜蜂
beequeen = 4,  --蜂王
bishop_nightmare = 6,  --损坏的发条主教
bunnyman = 3,  --芹菜

catcoon = 4,  --浣猫
clayhound = 3,  --黏土猎犬
claywarg = 5,  --黏土座狼
crawlingnightmare = 3,  --爬行梦魇


deer = 3,  --无眼鹿
deerclops = 8,  --独眼巨鹿
deer_blue = 3,  --无眼鹿
dragonfly = 4,  --龙蝇
firehound = 3,  --红色猎犬
ghost = 3,  --幽灵
gnarwail = 9,  --一角鲸
hound = 3,  --猎犬
deer_red = 3,  --无眼鹿
klaus = 3,  --克劳斯
knight_nightmare = 3,  --损坏的发条骑士
koalefant_summer = 3,  --考拉象
krampus = 3,  --坎普斯
leif_sparse = 3,  --树精守卫
leif = 3,  --树精守卫
malbatross = 5,  --邪天翁
lureplant = 3,  --食人花
mandrake_active = 3,  --曼德拉草
monkey = 3,  --暴躁猴
moonbutterfly = 3,  --月蛾
mossling = 2,  --麋鹿鹅幼崽
mutated_penguin = 2.5,  --月岩企鸥
nightmarebeak = 3,  --梦魇尖喙
perd = 3,  --火鸡
pigguard = 3,  --贝果
pumpkin_lantern = 3,  --南瓜灯
-- 
rocky = 4,  --石虾
rook = 3,  --发条战车
rook_nightmare = 3,  --损坏的发条战车
ruins_plate = 3,  --废墟
shadow_bishop = 4,  --暗影主教
shadow_rook = 8,  --暗影战车
shark = 3,  --岩石大白鲨
slurtlehole = 3,  --蛞蝓龟窝
slurper = 8,  --啜食者
slurtle = 2.5,  --蛞蝓龟
smallbird = 3,  --小鸟
snurtle = 3,  --蜗牛龟
spider_spitter = 5,  --喷射蜘蛛
spider_warrior = 6,  --蜘蛛战士
stalker = 2.4,  --复活的骨架
stalker_atrium = 2.4,  --远古织影者
stalker_forest = 3,  --复活的骨架
teenbird = 3,  --小高脚鸟
tentacle_pillar = 3,  --潮湿的 大触手
tentacle_pillar_arm = 3,  --潮湿的 小触手
toadstool_dark = 7,  --悲惨的毒菌蟾蜍
toadstool = 7,  --毒菌蟾蜍
walrus = 15,  --海象
waterplant_bomb = 1.5,  --种壳
	beefalo = 3,  --皮弗娄牛
waterplant = 18,  --海草
tentacle = 4,  --潮湿的 触手
rabbit = 3,  --兔子
pigman = 3,  --奇维
mole = 3,  --鼹鼠
beehive = 3,  --蜂窝
fruitdragon = 2,  --沙拉蝾螈
lightninggoat = 3,  --伏特羊
houndmound = 3,  --猎犬丘
spiderden = 3,  --蜘蛛巢
bunnyman = 3,  --补骨脂
tallbird = 3,  --高脚鸟
bishop_nightmare = 6,  --损坏的发条主教
knight = 3,  --发条骑士
knight_nightmare = 3,  --损坏的发条骑士
perd = 3,  --火鸡
crabking = 5,  --帝王蟹
spider_spitter = 5,  --喷射蜘蛛
rook_nightmare = 3,  --损坏的发条战车
bishop = 6,  --发条主教
wasphive = 6,  --杀人蜂蜂窝
mermking = 3,  --潮湿的 鱼人之王
frog = 3,  --青蛙
rook = 3,  --发条战车
clayhound = 3,  --黏土猎犬
spider_moon = 6,  --破碎蜘蛛
merm = 3,  --潮湿的 鱼人

butterfly = 3,  --蝴蝶
mermguard = 3,  --潮湿的 忠诚鱼人守卫
little_walrus = 15,  --小海象
walrus = 15,  --海象
spider = 3,  --蜘蛛
spider_hider = 3,  --洞穴蜘蛛
spider_dropper = 6,  --穴居悬蛛
hound = 3,  --猎犬
moonspider_spike = 3,  --破碎蜘蛛
mutatedhound = 3,  --恐怖猎犬
icehound = 3,  --蓝色猎犬
firehound = 3,  --红色猎犬
catcoon = 4,  --浣猫
bat = 1.5,  --洞穴蝙蝠
gnarwail = 9,  --一角鲸
shark = 3,  --岩石大白鲨
-- 




buzzard = 2,  --秃鹫
smallbird = 3,  --小鸟
koalefant_summer = 3,  --考拉象
babybeefalo = 3,  --小皮弗娄牛
mutated_penguin = 2.5,  --月岩企鸥
penguin = 2.5,  --企鸥
teenbird = 3,  --小高脚鸟
koalefant_winter = 3,  --考拉象
tentacle_pillar_arm = 3,  --潮湿的 小触手
tentacle_pillar = 3,  --潮湿的 大触手
bee = 0.6,  --蜜蜂
killerbee = 0.6,  --杀人蜂
carrat = 3,  --胡萝卜鼠
grassgekko = 3,  --草壁虎
moonbutterfly = 3,  --月蛾
mosquito = 1.75,  --蚊子
lureplant = 3,  --食人花
eyeplant = 2.5,  --眼球草
mandrake_active = 3,  --曼德拉草
worm = 3,  --潮湿的 土堆
slurper = 8,  --啜食者
rocky = 4,  --石虾
snurtle = 3,  --蜗牛龟
slurtle = 2.5,  --蛞蝓龟
monkey = 3,  --暴躁猴
krampus = 3,  --坎普斯
ghost = 3,  --幽灵
crawlingnightmare = 3,  --爬行梦魇
nightmarebeak = 3,  --梦魇尖喙
stalker_minion2 = 3,  --编织暗影
beeguard = 1.5,  --嗡嗡蜜蜂
mossling = 2,  --麋鹿鹅幼崽
lavae = 6,  --岩浆虫
deer_blue = 3,  --无眼鹿
deer_red = 3,  --无眼鹿
deer = 3,  --无眼鹿
waterplant_projectile = 1.5,  --海草
stalker_minion1 = 3,  --编织暗影
birchnutdrake = 2.5,  --桦栗果精
crabking_claw = 0,  --巨钳
moonpig = 3,  --马库斯
moonhound = 3,  --猎犬
gingerbreadpig = 3,  --姜饼猪
pigelite4 = 0.7,  --索耶
pigelite3 = 0.7,  --德米特里
pigelite2 = 0.7,  --伊格内修斯
pigelite1 = 0.7,  --韦德
archive_centipede = 3,  --远古哨兵蜈蚣
archive_centipede_husk = 3,  --哨兵蜈蚣壳
balloon = 3,  --气球
bernie_big = 3,  --伯尼！
molebat = 2,  --裸鼹鼠蝙蝠
waterplant = 18,  --海草
wasphive = 6,  --杀人蜂蜂窝
tentacle = 4,  --潮湿的 触手
beehive = 3,  --蜂窝
beefalo = 3,  --皮弗娄牛
spiderden = 3,  --蜘蛛巢
lightninggoat = 3,  --伏特羊
fruitdragon = 2,  --沙拉蝾螈
houndmound = 3,  --猎犬丘
pigman = 3,  --朱利安
merm = 3,  --潮湿的 鱼人
knight = 3,  --发条骑士
crabking = 5,  --帝王蟹
rabbit = 3,  --兔子
mole = 3,  --鼹鼠

tallbird = 3,  --高脚鸟
frog = 3,  --青蛙
butterfly = 3,  --蝴蝶

-- 
-- 
dummytarget = 3,  --MISSING NAME
dustmoth = 3,  --尘蛾
tentacle = 4,  --潮湿的 触手
waterplant = 18,  --海草
spiderden = 3,  --蜘蛛巢
beehive = 3,  --蜂窝
houndmound = 3,  --猎犬丘
lightninggoat = 3,  --伏特羊
beefalo = 3,  --皮弗娄牛
wasphive = 6,  --杀人蜂蜂窝
pigman = 3,  --克丽丝
fruitdragon = 2,  --沙拉蝾螈
merm = 3,  --潮湿的 鱼人
crabking = 5,  --帝王蟹
knight = 3,  --发条骑士
rabbit = 3,  --兔子
mole = 3,  --鼹鼠

tallbird = 3,  --高脚鸟
butterfly = 3,  --蝴蝶
frog = 3,  --青蛙
-- 
fossilspike = 2,  --化石笼子
fossilspike2 = 3,  --MISSING NAME
friendlyfruitfly = 3,  --友好果蝇
fruitfly = 1,  --果蝇
gestalt = 2.5,  --虚影
gestalt_guard = 3.5,  --大虚影
gnarwail_attack_horn = 3,  --一角鲸
lightflier = 3,  --球状光虫
knight_nightmare = 3,  --损坏的发条骑士
ivy_snare = 3,  --缠绕根须

lordfruitfly = 2,  --果蝇王
molebat = 2,  --裸鼹鼠蝙蝠
minotaur = 3,  --远古守护者
monkey = 3,  --暴躁猴
moonspider_spike = 3,  --破碎蜘蛛
mushgnome = 15,  --蘑菇地精
spore_moon = 3,  --月亮孢子

oceanhorror = 4.1,  --恐怖利爪
pigelitefighter2 = 2,  --伊格内修斯
pigelitefighter1 = 2,  --韦德
pigelitefighter3 = 2,  --德米特里
pigelitefighter4 = 2,  --索耶
rook_nightmare = 3,  --损坏的发条战车
ruins_table = 3,  --废墟
ruins_vase = 3,  --废墟
sandspike_med = 3,  --沙刺
sandspike_tall = 3,  --沙刺
sandblock = 3,  --沙堡
sandspike_short = 3,  --沙刺
shadowchanneler = 3,  --看不见的手
shadowtentacle = 2,  --暗影触手
slurper = 8,  --啜食者
sporecloud = 3,  --孢子云
terrorbeak = 3,  --恐怖尖喙
wall_ruins_2 = 3,  --档案馆铥墙
wall_stone_2 = 3,  --档案馆石墙
waterplant_projectile = 1.5,  --海草
winona_catapult_projectile = 1.25,  --薇诺娜的投石机
worm = 3,  --潮湿的 神秘植物
	spider = 3, --蜘蛛3
	bee = 0.6, 
	frig = 3,
	tallbird = 3,
	smallbird = 3,
	penguin = 2.5,
	mutated_penguin = 2.5,
	babybeefalo = 3,
	beefalo = 3,
	koalefant_summer = 3,
	koalefant_winter = 3,  --考拉象
	lightninggoat = 3,  --伏特羊
	tentacle_pillar_arm = 3,  --潮湿的 小触手
	tentacle = 4,  --潮湿的 触手
	tentacle_pillar = 3,  --潮湿的 大触手
	killerbee = 0.6,  --杀人蜂	
	bee = 0.6,  --蜜蜂
	mosquito = 1.75,  --蚊子	
	grassgekko = 3,  --草壁虎	
	carrat = 3,  --胡萝卜鼠	
	fruitdragon = 2,  --沙拉蝾螈
	lureplant = 3,  --食人花	
	eyeplant = 2.5,  --眼球草	
	mandrake_active = 3,  --曼德拉草
	monkey = 3,  --暴躁猴
	slurtle = 2.5,  --蛞蝓龟
	snurtle = 3,  --蜗牛龟
	rocky = 4,  --石虾
	slurper = 8,  --啜食者
	worm = 3,  --潮湿的 洞穴蠕虫
	krampus = 3,  --坎普斯
	ghost = 3,  --幽灵
	waterplant = 18,  --海草
	crawlingnightmare = 3,  --爬行梦魇
	nightmarebeak = 3,  --梦魇尖喙
	deer = 3,  --无眼鹿
	lavae = 6,  --岩浆虫
	mossling = 2,  --麋鹿鹅幼崽
	beeguard = 1.5,  --嗡嗡蜜蜂
	stalker_minion2 = 3,  --编织暗影
	stalker_minion1 = 3,  --编织暗影
	birchnutdrake = 2.5,  --桦栗果精
	crabking_claw = 1.5,  --巨钳	
	moonpig = 3,  --马约里安	
	moonhound = 3,  --猎犬
	pigelite1 = 0.7,  --韦德
	mutatedhound = 3,  --恐怖猎犬
	pigelite3 = 0.7,  --德米特里	
	pigelite2 = 0.7,  --伊格内修斯
	pigelite4 = 0.7,  --索耶
	gingerbreadpig = 3,  --姜饼猪
	
	pigman = 3,  --马克森提乌斯
	pigguard = 3,  --查夫
	bunnyman = 3,  --香菇
	merm = 3,  --潮湿的 鱼人
	mermguard = 3,  --潮湿的 忠诚鱼人守卫
	mermking = 3,  --潮湿的 鱼人之王
	little_walrus = 15,  --小海象
	walrus = 15,  --海象
	knight = 3.5,  --发条骑士
	bishop = 6,  --发条主教
	rook = 4,  --发条战车
	knight_nightmare = 3.5,  --损坏的发条骑士
	bishop_nightmare = 6,  --损坏的发条主教
	rook_nightmare = 4,  --损坏的发条战车
	spider = 3,  --蜘蛛
	spider_warrior = 6,  --蜘蛛战士
	spider_hider = 3,  --洞穴蜘蛛
	spider_spitter = 5,  --喷射蜘蛛
	spider_dropper = 6,  --穴居悬蛛
	spider_moon = 6,  --破碎蜘蛛
	hound = 3,  --猎犬
	firehound = 3,  --红色猎犬
	icehound = 3,  --蓝色猎犬
	clayhound = 3,  --黏土猎犬
	rabbit = 3,  --兔子
	butterfly = 1,  --蝴蝶
	frog = 3,  --青蛙	
	perd = 3,  --火鸡
	catcoon = 4,  --浣猫
	mole = 1,  --鼹鼠
	bat = 1.5,  --洞穴蝙蝠
	squid = 2,  --鱿鱼
	wobster_sheller_land = 3,  --龙虾
	wobster_moonglass_land = 3,  --月光龙虾
	shark = 3.5,  --岩石大白鲨
	gnarwail = 9,  --一角鲸
	-- 
	buzzard = 2,  --秃鹫
	-- 
	
	
	moose = 5.5,  --麋鹿鹅
	bearger = 6,  --熊獾
	deerclops = 8,  --独眼巨鹿
	dragonfly = 6.5,  --龙蝇
	malbatross = 5,  --邪天翁
	beequeen = 5,  --蜂王
	klaus = 3.2,  --克劳斯
	crabking = 7,  --帝王蟹
	toadstool = 7,  --毒菌蟾蜍
	toadstool_dark = 7,  --悲惨的毒菌蟾蜍
	minotaur = 3,  --远古守护者
	stalker = 2.4,  --复活的骨架	
	stalker_forest = 3,  --复活的骨架
	shadow_knight = 4,  --暗影骑士
	shadow_rook = 8,  --暗影战车
	shadow_bishop = 5,  --暗影主教
	leif = 3,  --树精守卫
	leif_sparse = 3,  --树精守卫		
	
	spiderqueen = 5,  --蜘蛛女王
	warg = 5,  --座狼
	claywarg = 5,  --黏土座狼	
	gingerbreadwarg = 5,  --姜饼座狼	
	spat = 3,  --钢羊	
	pitpig = 3,  --战猪
	crocommander = 5,  --鳄鱼指挥官
	battlestandard_heal = 3,  --战旗
	snortoise = 2,  --坦克龟
	scorpeon = 2,  --蝎子
	boarilla = 4,  --野猪猩
	battlestandard_shield = 3,  --战旗
	boarrior = 3,  --大熔炉猪战士
	rhinocebro2 = 3.5,  --平檐帽犀牛兄弟
	swineclops = 4,  --地狱独眼巨猪
	bishop_charge = 1.2, --光球
	beequeen = 6,  --蜂王
	--winona_catapult_projectile = 1,	--石头
	spider_web_spit = 2,  --蜘蛛的石头
	deciduous_root = 3,  --桦栗树根
	
}

if TUNING.xiaoyao("显示鸟范围") then
gongjirange.canary_poisoned = 3  --金丝雀
gongjirange.robin_winter = 3  --雪雀
gongjirange.robin = 3  --红雀
gongjirange.canary = 3  --金丝雀
gongjirange.crow = 3  --乌鸦
gongjirange.puffin = 3  --海鹦鹉
end

AddPrefabPostInitAny(function(inst)
	if gongjirange[inst.prefab] ~= nil  then
		Createxiaoyaofanwei(inst)
		rangeScale(inst, gongjirange[inst.prefab])
	end
end)