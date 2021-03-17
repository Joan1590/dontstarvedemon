
local variable = require 'lw_mod_camera'

local Image = require "widgets/image"
local Text = require "widgets/text"
local TextButton = require "widgets/textbutton"
local Widget = require "widgets/widget"
local Bar = require "lw_cameraUI/bar"

local uifn = require "lw_cameraUI/util"

local UNIT = 'lw_cameraUI/unit'

local Pitch = Class(Widget, function(self)
	Widget._ctor(self, "LwCamera sub -> pitch")
	uifn.setGridPara({x = -220})
	self.AddUIat = uifn.addUIat

	local _title = self:AddUIat('Title', 1, 1, '倾角', '调整摄像头的倾斜程度')

	uifn.insertHeight(40)

	-------------------------------------------------------------------

	local _lock = self:AddUIat(UNIT, 2, 1, '*锁死*', {
		enable = {fn = variable.get('pitch.triggerlock'), default = false},
		hint = '使倾角不随摄像头高度变化而进行自动调整\n(必须开启, 否则下方的控制将无法生效)'
	})

	local function _autoset(v)
		if v then
			_lock.enable_bt:ForceSet(true)
		end
	end

	local _keyctrl = self:AddUIat(UNIT, 3, 1, '键盘控制', {
		enable = {fn = function(v) variable.call('pitch.ctrl.key', v) _autoset(v) end, default = false},
		hint = '按住shift键, 同时按 ↑ 或 ↓ 键, 改变镜头倾角',
	})

	local _mousectrl = self:AddUIat(UNIT, 3, 3, '鼠标控制', {
		enable = {fn = function(v) variable.call('pitch.ctrl.mouse', v) _autoset(v) end, default = false},
		hint = '按住shift键, 同时将鼠标\n移到屏幕边缘来倾斜镜头(FPS)',
	})

	-------------------------------------------------------------------
	local _sensitivity = self:AddUIat(Bar, 4, 1, '灵敏度:', 0, 10, 5)
	_sensitivity.ondelta = function(v) variable.call('pitch.ctrl.sensitivity', v*2) end

	-------------------------------------------------------------------
	local _fast = self:AddUIat('Text', 6, 1, '快捷设置')
	local allparas = {
		{90, 80, 70, 60, 50, 40},
		{30, 20, 10, 0, -5, 'None'},
	}
	for row, paras in ipairs(allparas)do
		for line, para in ipairs(paras)do
			local _bt = self:AddUIat('TextButton', 6+row, line*0.9, tostring(para))
			_bt:SetOnClick(function()
				if type(para) == 'string' then
					_lock.enable_bt:ForceSet(false)
				else
					_lock.enable_bt:ForceSet(true)
					variable.call('pitch.setoverride', para)
				end
			end)
		end
	end

	local _lineBt = self:AddUIat("Line", 10, 1)
	local _curpitch = self:AddUIat('Text', 11, 1, '当前倾角: ')
	local _curpitch_num = self:AddUIat('Text', 11, 1.8, '')
	_curpitch_num:SetColour(0.25, 0.5, 1, 1)
	_curpitch_num.inst:DoPeriodicTask(0, function()
		_curpitch_num:SetString(string.format("%3d°", variable.call('C.GetTruePitch')))
	end)
	
	self.SetDefault = function(self)
		_lock.enable_bt:SetDefault()
		_keyctrl.enable_bt:SetDefault()
		_mousectrl.enable_bt:SetDefault()
		_sensitivity:SetDefault()
	end		
end)

return Pitch
