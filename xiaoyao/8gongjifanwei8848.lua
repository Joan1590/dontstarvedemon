

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
	{ 0 / 255, 255 / 255, 0/ 255, 1 },	--------绿色
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
	if self and self.lvseqvanvan2 then
		if rangeNum ~= nil and rangeNum > 0 then
			self.lvseqvanvan2.Transform:SetScale(hitrangescale/s1, hitrangescale/s2, hitrangescale/s3 )
		else
			self.lvseqvanvan2.Transform:SetScale(0.001,0.001,0.001)
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
local function Createlvseqvanvan2(self)
	if self and self.lvseqvanvan2 == nil then
		self.lvseqvanvan2 = GLOBAL.SpawnPrefab("xiaoyaofanweixianshi")
		self.lvseqvanvan2.entity:SetParent(self.entity)
		self.lvseqvanvan2.AnimState:SetLightOverride(1)
		self.lvseqvanvan2.AnimState:SetSortOrder(1)
		self.lvseqvanvan2:ListenForEvent("开关攻击范围", function()
			showornot(self.lvseqvanvan2)
		end,TheWorld)
		showornot(self.lvseqvanvan2)
		if yansebiao[colour] ~= nil then
			self.lvseqvanvan2.AnimState:SetMultColour(unpack(yansebiao[colour]))
		end
	end
end

-----给予某个物品绿色的圈圈
local lvseqvanvan = {
gears = 3,  --齿轮
animal_track = 3,  --足迹
dirtpile = 3,--可疑土堆
nightmarefuel = 3,--燃料
wormlight_plant = 3,--发光植物
ghostflower = 3,--哀悼荣耀
abigail_flower = 3,--温蒂花
bluegem = 3,--宝石
redgem = 3,--宝石
greengem = 3,--宝石
purplegem = 3,--宝石
orangegem = 3,--宝石
yellowgem = 3,--宝石
opalpreciousgem = 3,--宝石
blue_mushroom = 3,--蘑菇
green_mushroom = 3,--蘑菇
red_mushroom = 3,--蘑菇
}


-- local liangliangliang = {"spider_web_spit","batcave","blue_mushroom","opalpreciousgem","green_mushroom","red_mushroom","bluegem","deer","walrus","monkeybarrel","monkey","spider_warrior","spider_spitter","snurtle","redgem","greengem","purplegem","orangegem","yellowgem","opalpreciousgem","gears","animal_track","nightmarefuel","abigail_flower","crawlinghorror","ghostflower","terrorbeak","tentacle","wormlight_plant","knight_nightmare","bishop_nightmare","rook_nightmare","dirtpile"}		--让你的物品发光

-- for _,v in  ipairs(liangliangliang) do
	-- AddPrefabPostInit(v, function(inst) 
		-- if inst.AnimState then
			-- inst.AnimState:SetLightOverride(1)
			
			-- inst.entity:AddLight()
			-- inst.Light:SetFalloff(0.7)
			-- inst.Light:SetIntensity(.5)
			-- inst.Light:SetRadius(0.5)
			-- inst.Light:SetColour(237/255, 237/255, 209/255)
			-- inst.Light:Enable(true)
			
			-- inst.AnimState:SetMultColour(0 / 255, 255 / 255, 0/ 255, 1 )
		-- end
	-- end)
-- end

	

AddPrefabPostInitAny(function(inst)
	if lvseqvanvan[inst.prefab] ~= nil  then
		Createlvseqvanvan2(inst)
		rangeScale(inst, lvseqvanvan[inst.prefab])
	end
end)