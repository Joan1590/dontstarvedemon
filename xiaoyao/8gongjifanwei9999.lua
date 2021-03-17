


local liangliangliang = {"spider_web_spit","batcave","blue_mushroom","opalpreciousgem","green_mushroom","red_mushroom","bluegem","deer","walrus","monkeybarrel","monkey","spider_warrior","spider_spitter","snurtle","redgem","greengem","purplegem","orangegem","yellowgem","opalpreciousgem","gears","animal_track","nightmarefuel","abigail_flower","crawlinghorror","ghostflower","terrorbeak","tentacle","wormlight_plant","knight_nightmare","bishop_nightmare","rook_nightmare","dirtpile"}		--让你的物品发光

for _,v in  ipairs(liangliangliang) do
	AddPrefabPostInit(v, function(inst) 
		if inst.AnimState then
			inst.AnimState:SetLightOverride(1)
			
if TUNING.xiaoyao("光照模式") then
			inst.entity:AddLight()
			inst.Light:SetFalloff(0.7)
			inst.Light:SetIntensity(.5)
			inst.Light:SetRadius(5)			---光范围
			inst.Light:SetColour(237/255, 237/255, 209/255)
			inst.Light:Enable(true)
end	
			-- inst.AnimState:SetMultColour(0 / 255, 255 / 255, 0/ 255, 1 )
		end
	end)
end

	
