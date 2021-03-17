GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end})


--一些变量(主要是函数)
local variable = require 'lw_mod_camera'
variable.set('GetPlayer', function() return ThePlayer or GetPlayer() end)
variable.set('KEY', TUNING.xiaoyao('偷拍摄像头'))


--递归搜索处于编辑状态的UI
local function _HasEditingUI(self)
	if self.editing and self.inst.TextEditWidget then 
		return true
	else
		for _,v in pairs(self.children)do
			if _HasEditingUI(v) then return true end
		end
	end
end

--判断当前是否处于输入状态
local function IsEditing() 
	local s = TheFrontEnd:GetActiveScreen()
	return s and _HasEditingUI(s)
end

AddClassPostConstruct( "widgets/controls", function(self)
	if TheNet:IsDedicated() then return end
	
	self.LwCamera_Main = self.containerroot:AddChild(require('lw_cameraUI/main')())
	self.LwCamera_Main:Hide()
end)

TheInput:AddKeyUpHandler(TUNING.xiaoyao('偷拍摄像头'), function()
	if IsEditing() then return end
	local player = variable.call('GetPlayer')
	--仅测试用
	--[[
	local player = variable.call('GetPlayer')
	local ui = player and player.HUD and player.HUD.controls
	if ui then
		if ui.LwCamera_Main then 
			ui.LwCamera_Main:Kill()
			ui.LwCamera_Main = nil
		else
			ui.LwCamera_Main = ui.containerroot:AddChild(require('lw_cameraUI/main')())
		end
	end
	--]]
	---[[
	local ui = player and player.HUD and player.HUD.controls and player.HUD.controls.LwCamera_Main
	if ui then
		ui:OnKey()
	else
		print("I can't find that widget!")
	end
	--]]
end)

modimport 'mouse.lua'
modimport 'followcamera.lua'
modimport 'sky.lua'
modimport 'rgb.lua'
--modimport 'hotupdate.lua'

