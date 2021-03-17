modimport "lib_ver.lua"

local show_oneself = true
fanweixianshi = TUNING.xiaoyao("范围显示1")

--Показываем ники
if not TUNING.SHOW_PLAYERS_NICKNAMES then
	TUNING.SHOW_PLAYERS_NICKNAMES = true
	AddPlayersAfterInit(function(inst)
		if inst == _G.ThePlayer and not show_oneself then
			return
		end
		inst.GetMyDisplayName = function(inst)
			return inst:GetDisplayName()
		end
		local label = inst.entity:AddLabel()
	   
		inst.kaiqi = true
		label:SetFontSize(18)         
		label:SetFont(_G.BODYTEXTFONT)
		label:SetWorldOffset(0, 2.3, 0)       --
	 
		local Name = inst:GetMyDisplayName()
		--if IsAdmin(Name) then Name ="" end
		label:SetText(Name)              ----default = ""
		label:SetColour(unpack(inst.playercolour or {255/255,255/255,255/255} ))               --  default = "(255/255,255/255,255/255)"
		label:Enable(true)                     --default = "false"
		
		local function IsHUDScreen()
		local defaultscreen = false
		if TheFrontEnd:GetActiveScreen() and TheFrontEnd:GetActiveScreen().name and type(TheFrontEnd:GetActiveScreen().name) == "string" and TheFrontEnd:GetActiveScreen().name == "HUD" then
		defaultscreen = true
		end
		return defaultscreen
		end
		
		TheInput:AddKeyDownHandler(fanweixianshi, function() 
		if not TheWorld then return end
		if not  IsHUDScreen()  then return end
		inst.kaiqi = not inst.kaiqi
		---TheWorld:PushEvent("开关攻击范围") 
		label:Enable(inst.kaiqi)                     --default = "false"
		end)
		
	
		

		--Change name dynamically (because of Health Info mod)
		inst:DoPeriodicTask(0.1+math.random()*0.01,function()
			local new_name = inst:GetMyDisplayName()
			if Name ~= new_name then
				Name = new_name
				label:SetText(Name)
			end
		end)
	end)
end

