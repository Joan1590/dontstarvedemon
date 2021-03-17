local _G = GLOBAL
local FindEntity = _G.FindEntity
local ThePlayer


local function HasShadowChanneler(prefab,range,tag)
	if	tag ~= nil then
		return FindEntity(ThePlayer, range, function(inst) return inst:HasTag(tag ) end)		
	else
		return FindEntity(ThePlayer, range, function(inst) return inst.prefab == prefab end)		
	end
end


local abababaaba  ={
    stalker_atrium = {"shadowchanneler",50},	-----如果有黑暗手 就不打中庭
	spider_hider = {"spider_spitter",2.5},			------如果有喷射蜘蛛，就不打岩石蜘蛛
	dragonfly = {"hound",8},			------有狗不打蜻蜓
	shadow_rook = {"shadow_bishop",9},		--------当主教存在则不打战车
	shadow_bishop = {"shadow_knight",9},	--------当骑士存在 则不大主教
	---dragonfly = {"lavae",5},			-------有虫子打打蜻蜓
	lavae = {"hound",8},				------有狗不打虫子
	sandblock = {"antlion",15},
	sandspike_med = {"antlion",15},	
	sandspike_short = {"antlion",15},
	sandspike_tall = {"antlion",15},				----------优先打蚁狮
	sandspike = {nil,9,"sandspike"},			----老子就不打沙刺!
	lureplant = {"lureplant",9},	
}



local mytags = {"wall","sandspike"}		---"bird"鸟就移除啦~

if TUNING.xiaoyao("是否打鸟") then
table.insert(mytags,"bird")
end

local function ReplaceIsAlly(self, inst)

    if inst ~= _G.ThePlayer then return end
    ThePlayer = _G.ThePlayer

    local IsAlly_original = self.IsAlly

	self.IsAlly = function(self, guy, ...)
		for _, v in ipairs(mytags) do
			if guy:HasTag(v) then
				return true
			end
		end
		if abababaaba[guy.prefab] ~= nil  then	
            return HasShadowChanneler(abababaaba[guy.prefab][1],abababaaba[guy.prefab][2],abababaaba[guy.prefab][3])
        end

        return IsAlly_original(self, guy, ...)
    end
end

AddClassPostConstruct("components/combat_replica", ReplaceIsAlly)
