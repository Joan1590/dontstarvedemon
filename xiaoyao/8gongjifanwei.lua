
local colour = TUNING.xiaoyao("攻击范围显示")
xxxxx = TUNING.xiaoyao("范围显示")

local xianshi = true

local function IsHUDScreen()
	local defaultscreen = false
	if TheFrontEnd:GetActiveScreen() and TheFrontEnd:GetActiveScreen().name and type(TheFrontEnd:GetActiveScreen().name) == "string" and TheFrontEnd:GetActiveScreen().name == "HUD" then
		defaultscreen = true
	end
	return defaultscreen
end


TheInput:AddKeyDownHandler(xxxxx, function() 
	if not TheWorld then return end
	if not IsHUDScreen() then return end
	xianshi = not xianshi
	TheWorld:PushEvent("开关攻击范围") 
end)

local yansebiao  ={
	{ 152 / 255, 0 / 255, 255/ 153, 1 },	--------紫色
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
	if self and self.xiaoyao222 then
		if rangeNum ~= nil and rangeNum > 0 then
			self.xiaoyao222.Transform:SetScale(hitrangescale/s1, hitrangescale/s2, hitrangescale/s3 )
		else
			self.xiaoyao222.Transform:SetScale(0.001,0.001,0.001)
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

local function Createxiaoyao222(self)
	if self and self.xiaoyao222 == nil then
		self.xiaoyao222 = GLOBAL.SpawnPrefab("xiaoyaofanweixianshi")
		self.xiaoyao222.entity:SetParent(self.entity)
		self.xiaoyao222.AnimState:SetLightOverride(1)
		self.xiaoyao222.AnimState:SetSortOrder(1)
		self.xiaoyao222:ListenForEvent("开关攻击范围", function()
			showornot(self.xiaoyao222)
		end,TheWorld)
		showornot(self.xiaoyao222)
		if yansebiao[colour] ~= nil then
			self.xiaoyao222.AnimState:SetMultColour(unpack(yansebiao[colour]))
		end
	end
end

AddPrefabPostInitAny(function(inst)
	if inst.replica.combat ~= nil and not inst:HasTag("player") then
		local range = inst.replica.combat._attackrange:value()
		Createxiaoyao222(inst)
		rangeScale(inst, range)
	end
end)