local imagePaths = {}

-------中立生物
imagePaths["anim"] = {
	"animal_track",--翻开的脚印
	"babybeefalo",--小牛
	"beefalo",--牛
	"deer",--无眼鹿
	"dirtpile",--未翻开的脚印
	---"fireflies",--萤火虫
	"grassgekko",--草蜥蜴
	"koalefant_summer",--大象
	"koalefant_winter",--冬象
	"lightninggoat",--电羊
	"mandrake_planted",--长在地上的曼德拉草
	"molehill",--鼹鼠洞
	"mooseegg",--鹿鹅蛋
	"rabbithole",--兔子洞
	"rocky",--石虾
}
-------boss
imagePaths["boss"] = {
	"antlion",--蚁狮
	"bearger",--獾熊
	"beequeen",--蜂后
	"deerclops",--巨鹿
	"dragonfly",--龙蝇
	"leif",--松树精
	"leif_sparse",--稀有树精
	"minotaur",--犀牛
	"moose",--鹿鹅
	"spat",--钢羊
	"spiderqueen",--蜘蛛女王
	"stalker",--远古狩猎者
	"stalker_atrium",--远古影织者
	"stalker_forest",--森林守护者
	"warg",--座狼
}
-------植物
imagePaths["botany"] = {
	"blue_mushroom",--蓝蘑菇
	"flower_cave_double",--双朵洞穴花
	"flower_cave_triple",--三朵洞穴花
	"green_mushroom",--绿蘑菇
	"red_mushroom",--红蘑菇
	"stalker_berry",--小发光浆果
}
-------物品
imagePaths["inventory"] = {
	"chester_eyebone",--切斯特眼骨
	"glommerflower",--格罗姆花
	"houndbone",--狗骨
	"hutch_fishbowl",--星空
	"mermhead",--鱼人头
	"pighead",--猪人头
	"pigtorch",--猪人火炬
	--"sculpture_bishophead",--可疑的大理石，主教头
	--"sculpture_knighthead",--可疑的大理石，骑士头
	--"sculpture_rooknose",--可疑的大理石--战车鼻子
	"skeleton",--尸骨
	"wall_hay",--草墙
	"wall_moonrock",--月石墙
	"wall_ruins",--铥矿墙
	"wall_stone",--石墙
	"wall_wood",--木墙
}
-------矿物
imagePaths["mineral"] = {
	"bluegem",--红宝石
	"greengem",--蓝宝石
	"opalpreciousgem",--彩虹宝石
	"orangegem",--紫宝石
	"purplegem",--绿宝石
	"redgem",--橙宝石
	"yellowgem",--黄宝石
}
-------怪物
imagePaths["monster"] = {
	"bishop",--发条主教
	"bishop_nightmare",--损坏的发条主教
	"knight",--发条骑士
	"knight_nightmare",--损坏的发条骑士
	"rook",--发条战车
	"rook_nightmare",--损坏的发条战车
	"tentacle",--触手
	"tentacle_pillar",--大触手
	"worm",--蠕虫
}







function AddIconsMap(name)
	for i = 1, #imagePaths[name] do
		local entity = imagePaths[name][i]
        table.insert(Assets, Asset("IMAGE", "images/"..name.."/" .. entity .. ".tex"))
        table.insert(Assets, Asset("ATLAS", "images/"..name.."/" .. entity .. ".xml"))
        AddMinimapAtlas("images/"..name.."/" .. entity .. ".xml")
        AddPrefabPostInit(entity, function (inst) inst.entity:AddMiniMapEntity():SetIcon(inst.prefab .. ".tex") end)
	end
end


for k,v in pairs(imagePaths) do
    AddIconsMap(k)
end

