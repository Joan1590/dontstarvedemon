

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
	if self and self.renwufanwei then
		if rangeNum ~= nil and rangeNum > 0 then
			self.renwufanwei.Transform:SetScale(hitrangescale/s1, hitrangescale/s2, hitrangescale/s3 )
		else
			self.renwufanwei.Transform:SetScale(0.001,0.001,0.001)
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
local function Createrenwufanwei(self)
	if self and self.renwufanwei == nil then
		self.renwufanwei = GLOBAL.SpawnPrefab("xiaoyaofanweixianshi")
		self.renwufanwei.entity:SetParent(self.entity)
		self.renwufanwei.AnimState:SetLightOverride(1)
		self.renwufanwei.AnimState:SetSortOrder(1)
		self.renwufanwei:ListenForEvent("开关攻击范围", function()
			showornot(self.renwufanwei)
		end,TheWorld)
		showornot(self.renwufanwei)
		if yansebiao[colour] ~= nil then
			self.renwufanwei.AnimState:SetMultColour(unpack(yansebiao[colour]))
		end
	end
end


local renwufanwei = {
wilson = 2,  --威尔逊
willow = 2,  --薇洛
wolfgang = 2,  --沃尔夫冈
wendy = 2,  --温蒂
abigail = 3,  --阿比盖尔
wx78 = 2,  --WX-78
wickerbottom = 2,  --薇克巴顿
woodie = 2,  --伍迪
wortox = 2,  --沃拓克斯
warly = 2,  --沃利
winona = 2,  --薇诺娜
wathgrithr = 2,  --薇格弗德
webber = 2,  --韦伯
waxwell = 2,  --麦斯威尔
wes = 2,  --韦斯
wormwood = 2,  --沃姆伍德
wurt = 2,  --沃特
walter = 2,  --沃尔特
}

AddPrefabPostInitAny(function(inst)
	if renwufanwei[inst.prefab] ~= nil  then
		Createrenwufanwei(inst)
		rangeScale(inst, renwufanwei[inst.prefab])
	end
end)