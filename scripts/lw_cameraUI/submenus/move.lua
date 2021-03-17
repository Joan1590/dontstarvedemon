
local variable = require 'lw_mod_camera'

local Image = require "widgets/image"
local Text = require "widgets/text"
local TextButton = require "widgets/textbutton"
local Widget = require "widgets/widget"
local Bar = require "lw_cameraUI/bar"

local uifn = require "lw_cameraUI/util"

local UNIT = 'lw_cameraUI/unit'

local Move = Class(Widget, function(self)
	Widget._ctor(self, "LwCamera sub -> move")
	uifn.setGridPara({x = -220})
	self.AddUIat = uifn.addUIat

	local _title = self:AddUIat('Title', 1, 1, '偏移', '调整摄像头的相对位置')

	uifn.insertHeight(40)

	-------------------------------------------------------------------

	local _keyctrl = self:AddUIat(UNIT, 2, 1, '键盘控制', {
		enable = {fn = variable.get('move.ctrl.key'), default = false},
		hint = '按住 ↑ ↓ ← → 键移动镜头',
	})

	local _mousectrl = self:AddUIat(UNIT, 2, 3, '鼠标控制', {
		enable = {fn = variable.get('move.ctrl.mouse'), default = false},
		hint = '将鼠标移到屏幕边缘来移动镜头(RTS)',
	})

	-------------------------------------------------------------------
	local _sensitivity = self:AddUIat(Bar, 3, 1, '灵敏度:', 1, 16, 4)
	_sensitivity.ondelta = variable.get('move.ctrl.sensitivity')

	-------------------------------------------------------------------
	local _automove = self:AddUIat(UNIT, 5, 1, '匀速推镜', {
		hint = '解放双手, 让镜头自动飘移!',
	})

	local _open = self:AddUIat('TextButton', 5, 2.6, '开')
	_open:SetOnClick(variable.get('move.auto.open'))

	local _close = self:AddUIat('TextButton', 5, 3.3, '关')
	_close:SetOnClick(variable.get('move.auto.close'))

	local _open3 = self:AddUIat('TextButton', 5, 4.5, '延迟3秒后开')
	_open3:SetOnClick(variable.get('move.auto.open3'))

	-------------------------------------------------------------------
	local _speed = self:AddUIat(Bar, 6, 1, '速度:', -10, 10, 0)
	_speed.ondelta = variable.get('move.auto.speed')

	-------------------------------------------------------------------
	local _dir = self:AddUIat(Bar, 7, 1, '方向:', -180, 180, 0)
	_dir.ondelta = variable.get('move.auto.dir')
	_dir.displayfn = function(v) return string.format("%d", v) end
	-------------------------------------------------------------------

	local _reset = self:AddUIat('TextButton', 9, 1.2, '清除偏移量')
	_reset:SetOnClick(variable.get('move.reset'))

	-------------------------------------------------------------------

	local _lineBt = self:AddUIat("Line", 10, 1)
	local _curoff = self:AddUIat('Text', 11, 1, '当前偏移: ')
	local _curoff_num = self:AddUIat('Text', 11, 2.2, '')
	_curoff_num:SetColour(0.25, 0.5, 1, 1)
	_curoff_num.inst:DoPeriodicTask(2*FRAMES, function()
		local vec = TheCamera.targetoffset or Vector3(0,0,0)
		_curoff_num:SetString(string.format("(%.1f, %.1f)", vec.x, vec.z))
	end)

	self.SetDefault = function(self)
		_keyctrl.enable_bt:SetDefault()
		_mousectrl.enable_bt:SetDefault()
		_sensitivity:SetDefault()
		_speed:SetDefault()
		_dir:SetDefault()
		_open.onclick()
		_reset.onclick()
	end
end)

return Move
