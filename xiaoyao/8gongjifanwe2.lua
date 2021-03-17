

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
	{ 255 / 255, 255 / 255, 255/ 255, 1 },	--------白
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
	if self and self.xiaoyao333 then
		if rangeNum ~= nil and rangeNum > 0 then
			self.xiaoyao333.Transform:SetScale(hitrangescale/s1, hitrangescale/s2, hitrangescale/s3 )
		else
			self.xiaoyao333.Transform:SetScale(0.001,0.001,0.001)
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
local function Createxiaoyao333(self)
	if self and self.xiaoyao333 == nil then
		self.xiaoyao333 = GLOBAL.SpawnPrefab("xiaoyaofanweixianshi")
		self.xiaoyao333.entity:SetParent(self.entity)
		self.xiaoyao333.AnimState:SetLightOverride(1)
		self.xiaoyao333.AnimState:SetSortOrder(1)
		self.xiaoyao333:ListenForEvent("开关攻击范围", function()
			showornot(self.xiaoyao333)
		end,TheWorld)
		showornot(self.xiaoyao333)
		if yansebiao[colour] ~= nil then
			self.xiaoyao333.AnimState:SetMultColour(unpack(yansebiao[colour]))
		end
	end
end


local chufafanwei = {
	lureplant = 12,  --食人花
	deer_red = 15.1,  --无眼鹿
	deer_blue = 15.1,  --无眼鹿
	dragonfly = 15,  --蜻蜓龙
	toadstool = 10,  --毒菌蟾蜍
	mushroombomb = 4,  --毒菌蟾蜍蘑菇
	toadstool_dark = 10,  --悲痛毒菌蟾蜍
	mushroombomb_bark = 4,  --悲痛毒菌蟾蜍蘑菇
	minotaur = 25,  --犀牛
	wasphive = 10,	---杀人蜂巢穴
	bishop = 12,	---发条主教
	rook = 12,	---发条战车
	knight = 10,	---发条骑士
	bishop_nightmare = 12,	---发条主教
	rook_nightmare = 12,	---发条战车
	knight_nightmare = 10,	---发条骑士
	klaus = 7.1,  --克劳斯
	spat = 10,  --刚羊
	spat_bomb = 3,  --刚羊
	warg = 10,  --座狼	
	claywarg = 10,  --黏土座狼	
	gingerbreadwarg = 10,  --姜饼座狼
	spiderqueen = 10,  --蜘蛛女王	
	beequeen = 10,  --蜂王
}

AddPrefabPostInitAny(function(inst)
	if chufafanwei[inst.prefab] ~= nil  then
		Createxiaoyao333(inst)
		rangeScale(inst, chufafanwei[inst.prefab])
	end
end)