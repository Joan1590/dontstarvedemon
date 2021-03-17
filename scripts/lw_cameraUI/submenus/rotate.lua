
local variable = require 'lw_mod_camera'

local Image = require "widgets/image"
local Text = require "widgets/text"
local TextButton = require "widgets/textbutton"
local Widget = require "widgets/widget"
local Bar = require "lw_cameraUI/bar"

local uifn = require "lw_cameraUI/util"

local UNIT = 'lw_cameraUI/unit'

local Rotate = Class(Widget, function(self)
	Widget._ctor(self, "LwCamera sub -> rotate")
	uifn.setGridPara({x = -220})
	self.AddUIat = uifn.addUIat

	local _title = self:AddUIat('Title', 1, 1, '朝向', '调整摄像头的面向的角度')

	uifn.insertHeight(40)

	-------------------------------------------------------------------

	local _keyctrl = self:AddUIat(UNIT, 2, 1, '键盘控制', {
		enable = {fn = variable.get('rotate.ctrl.key'), default = false},
		hint = '按住shift键, 同时按 ← 或 → 键, 旋转镜头',
	})

	local _mousectrl = self:AddUIat(UNIT, 2, 3, '鼠标控制', {
		enable = {fn = variable.get('rotate.ctrl.mouse'), default = false},
		hint = '按住shift键, 同时将鼠标\n移到屏幕边缘来旋转镜头(FPS)',
	})

	-------------------------------------------------------------------
	local _sensitivity = self:AddUIat(Bar, 3, 1, '灵敏度:', 1, 10, 2.5)
	_sensitivity.ondelta = function(v) variable.call('rotate.ctrl.sensitivity', v*5) end

	-------------------------------------------------------------------
	local _automove = self:AddUIat(UNIT, 5, 1, '匀速旋转', {
		hint = '“雷达模拟器”',
	})

	local _open = self:AddUIat('TextButton', 5, 2.6, '开')
	_open:SetOnClick(variable.get('rotate.auto.open'))

	local _close = self:AddUIat('TextButton', 5, 3.3, '关')
	_close:SetOnClick(variable.get('rotate.auto.close'))

	local _open3 = self:AddUIat('TextButton', 5, 4.5, '延迟3秒后开')
	_open3:SetOnClick(variable.get('rotate.auto.open3'))

	-------------------------------------------------------------------
	local _speed = self:AddUIat(Bar, 6, 1, '速度:', -10, 10, 0)
	_speed.ondelta = function(v) variable.call('rotate.auto.speed', v*3) end

	-------------------------------------------------------------------
	local _align45 = self:AddUIat('TextButton', 7, 1.2, '对齐至45度')
	_align45:SetOnClick(variable.get('rotate.align45'))

	local _align90 = self:AddUIat('TextButton', 7, 2.7, '对齐至90度')
	_align90:SetOnClick(variable.get('rotate.align90'))

	-------------------------------------------------------------------

	local _lineBt = self:AddUIat("Line", 10, 1)
	local _curdir = self:AddUIat('Text', 11, 1, '当前朝向: ')
	local _curdir_num = self:AddUIat('Text', 11, 1.8, '')
	_curdir_num:SetColour(0.25, 0.5, 1, 1)
	_curdir_num.inst:DoPeriodicTask(0, function()
		_curdir_num:SetString(string.format("%3d°", variable.call('C.GetHeading180')))
	end)

	self.SetDefault = function(self)
		_keyctrl.enable_bt:SetDefault()
		_mousectrl.enable_bt:SetDefault()
		_sensitivity:SetDefault()
		_open.onclick()
		_speed:SetDefault()
		_align45.onclick()
	end
end)

return Rotate
