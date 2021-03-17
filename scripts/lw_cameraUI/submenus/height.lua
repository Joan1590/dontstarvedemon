
local variable = require 'lw_mod_camera'

local Image = require "widgets/image"
local Text = require "widgets/text"
local TextButton = require "widgets/textbutton"
local Widget = require "widgets/widget"
local TextEdit = require "widgets/textedit"
local Bar = require "lw_cameraUI/bar"

local uifn = require "lw_cameraUI/util"

local UNIT = 'lw_cameraUI/unit'

local TextInput = Class(Widget, function(self, default, fn)
	Widget._ctor(self, 'text input')
	self.bg = self:AddChild(Image('images/ui.xml', 'blank.tex'))
	self.bg:SetSize(40, 20)

	self.text = self:AddChild(TextEdit(UIFONT, 25, default and tostring(default) or ''))
	self.text:SetColour(0.25,0.75,0.25, 1)
	self.text:SetCharacterFilter('+-*/()^% 1234567890')
	self.text.OnTextEntered = fn
end)

local Pitch = Class(Widget, function(self)
	Widget._ctor(self, "LwCamera sub -> height")
	uifn.setGridPara({x = -220})
	self.AddUIat = uifn.addUIat

	local _title = self:AddUIat('Title', 1, 1, '高度', '调整摄像头和地面的距离')

	uifn.insertHeight(40)
	uifn.insertHeight(-3*30)
	--[[
	local _para = self:AddUIat(UNIT, 2, 1, '变化范围', {
		hint = '设置高度和倾角的最大值与最小值\n(默认情况下, 倾角随高度发生线性变化)'
	})

	local _space = '       '
	
	local function _fn(k)
		local function _set(v)
			TheCamera[k] = pcall(loadstring('return ' ..v))
		end
		return _set
	end
	local _h = self:AddUIat('Text', 3, 1, '高度'.._space..'~')
	local _hmin = self:AddUIat(TextInput, 3, 1.5, TheCamera.mindist, _fn('mindist')) 
	local _hmax = self:AddUIat(TextInput, 3, 2.5, TheCamera.maxdist, _fn('maxdist'))

	local _p = self:AddUIat('Text', 3, 4, '倾角'.._space..'~')
	local _pmin = self:AddUIat(TextInput, 3, 4, TheCamera.mindistpitch, _fn('mindistpitch'))
	local _pmax = self:AddUIat(TextInput, 3, 5, TheCamera.maxdistpitch, _fn('maxdistpitch'))
	--]]
	-------------------------------------------------------------------
	local _auto = self:AddUIat(UNIT, 5, 1, '自动升降', {
		hint = '滚动鼠标滚轮会使该功能失效,\n再次点击"开"即可强制启动',
	})

	local _open = self:AddUIat('TextButton', 5, 2.6, '开')
	_open:SetOnClick(variable.get('height.auto.open'))

	local _close = self:AddUIat('TextButton', 5, 3.3, '关')
	_close:SetOnClick(variable.get('height.auto.close'))

	local _open3 = self:AddUIat('TextButton', 5, 4.5, '延迟3秒后开')
	_open3:SetOnClick(variable.get('height.auto.open3'))

	local _speed = self:AddUIat(Bar, 6, 1, '速度:', -10, 10, 0)
	_speed.ondelta = variable.get('height.auto.speed')

	-------------------------------------------------------------------
	local _fast = self:AddUIat(UNIT, 7, 1, '快捷设置', {
		hint = '单击设置目标高度, 双击跳过过渡',
	})
	local allparas = {
		{200, 150, 100, 75, 50, 40},
		{30, 20, 10, 5, 2.5, 1},
	}
	for row, paras in ipairs(allparas)do
		for line, para in ipairs(paras)do
			local _bt = self:AddUIat('TextButton', 7+row, line*0.9, tostring(para))
			_bt:SetOnClick(function()
				--variable.set('lockdist', true)
				if TheCamera.distancetarget == para then --双击
					TheCamera.distance = para
				else
					TheCamera.distancetarget = para
					TheCamera.time_since_zoom = nil
				end
			end)
		end
	end

	uifn.insertHeight(3*30)

	local _lineBt = self:AddUIat("Line", 10, 1)

	local _curh = self:AddUIat('Text', 11, 1, '当前高度: ')
	local _curh_num = self:AddUIat('Text', 11, 1.8, '')
	_curh_num:SetColour(0.25, 0.5, 1, 1)
	_curh_num.inst:DoPeriodicTask(0, function()
		_curh_num:SetString(string.format("%.1f", TheCamera.distance))
	end)
	local _curpitch = self:AddUIat('Text', 11, 3, '当前倾角: ')
	local _curpitch_num = self:AddUIat('Text', 11, 4.1, '')
	local function _getstring()
		local n = string.format("%d", variable.call('C.GetTruePitch'))
		local l = variable.call('pitch.islocked') and '[锁死]' or '       '
		return n .. ' ' .. l
	end
	_curpitch_num:SetColour(0.25, 0.5, 1, 1)
	_curpitch_num.inst:DoPeriodicTask(0, function()
		_curpitch_num:SetString(_getstring())
	end)

	self.SetDefault = function(self)
		_open.onclick()
		_speed:SetDefault()

		--输入框
	end
end)

return Pitch
