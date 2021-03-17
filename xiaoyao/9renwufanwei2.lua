

local colour = TUNING.xiaoyao("攻击范围显示")
fanweixianshi = TUNING.xiaoyao("人物范围")


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
	if self and self.renwufanwei2 then
		if rangeNum ~= nil and rangeNum > 0 then
			self.renwufanwei2.Transform:SetScale(hitrangescale/s1, hitrangescale/s2, hitrangescale/s3 )
		else
			self.renwufanwei2.Transform:SetScale(0.001,0.001,0.001)
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
local function Createrenwufanwei2(self)
	if self and self.renwufanwei2 == nil then
		self.renwufanwei2 = GLOBAL.SpawnPrefab("xiaoyaofanweixianshi")
		self.renwufanwei2.entity:SetParent(self.entity)
		self.renwufanwei2.AnimState:SetLightOverride(1)
		self.renwufanwei2.AnimState:SetSortOrder(1)
		self.renwufanwei2:ListenForEvent("开关攻击范围", function()
			showornot(self.renwufanwei2)
		end,TheWorld)
		showornot(self.renwufanwei2)
		if yansebiao[colour] ~= nil then
			self.renwufanwei2.AnimState:SetMultColour(unpack(yansebiao[colour]))
		end
	end
end


local chufafanwei = {
wilson = 9,  --威尔逊
willow = 9,  --薇洛
wolfgang = 9,  --沃尔夫冈
wendy = 9,  --温蒂
abigail = 9,  --阿比盖尔
wx78 = 9,  --WX-78
wickerbottom = 9,  --薇克巴顿
woodie = 9,  --伍迪
wortox = 9,  --沃拓克斯
warly = 9,  --沃利
winona = 9,  --薇诺娜
wathgrithr = 9,  --薇格弗德
webber = 9,  --韦伯
waxwell = 9,  --麦斯威尔
wes = 9,  --韦斯
wormwood = 9,  --沃姆伍德
wurt = 9,  --沃特
walter = 9,  --沃尔特
}

AddPrefabPostInitAny(function(inst)
	if chufafanwei[inst.prefab] ~= nil  then
		Createrenwufanwei2(inst)
		rangeScale(inst, chufafanwei[inst.prefab])
	end
end)