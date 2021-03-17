local Image = require "widgets/image"
local Text = require "widgets/text"
local TextButton = require "widgets/textbutton"
local Widget = require "widgets/widget"
local WriteableWidget = require "screens/TMI_writeablewidget"
--local TMI_menubar = require "widgets/TMI_menubar"
local MyText = Class(Text, function(self, text)
	Text._ctor(self, DEFAULTFONT, 25, text)
	self.image = self:AddChild(Image("images/ui.xml", "blank.tex"))
    self.image:SetSize(self:GetRegionSize())
end)
local MyTextButton = Class(TextButton, function(self, text)
	TextButton._ctor(self)
	self:SetText(text)
	self:SetTextSize(25)
end)
local _ui = {
	Widget = Widget,
	Text = MyText,
	TextButton = MyTextButton,
	MyBar = require 'widgets/LwScrollbar',
}
local function getUIpos(row, line)
	return Vector3(line * 70 - 500, -row * 35 + 230, 0)
end

local function addUIat(self, name, row, line, ...)
	local ui = self.root:AddChild(_ui[name](...))
	ui:SetPosition(getUIpos(row, line))
	return ui
end

local function MakeUIselectable(self, defalut)
	defalut = defalut or 1
	local i = 0
	while 1 do
		i = i + 1
		local sel = self['sel'..i]
		if not sel then 
			break
		end
		sel.id = i
		sel:SetOnClick(function()	
			local old_sel = self._sel
			local new_sel = sel.id
			if old_sel ~= new_sel then
				self._sel = new_sel
				if old_sel then
					self['sel'..old_sel]:SetSelected(false)
				end
				sel:SetSelected(true)
				self:OnSelect(sel.id)
			end
		end)
		sel.SetSelected = function(self, vel)
			if self.SetTextColour then 
				self:SetTextColour(vel and {1,1,1,1} or {0.6,0.3,0.3,1})
			end
		end
		sel:SetSelected(false)
	end
	--初始化
	self['sel'..defalut].onclick()
end

local utilfn = require 'Lwfollowcamera'

local Extra = Class(Widget, function(self)
	Widget._ctor(self, "Extra")
	self.AddUIat = addUIat

	self.root = self:AddChild(Widget("ROOT"))
	self.root:SetVAnchor(ANCHOR_MIDDLE)
	self.root:SetHAnchor(ANCHOR_MIDDLE)
	self.root:SetScaleMode(SCALEMODE_PROPORTIONAL)
	self.root:SetPosition(400,0,0)

	self.shieldpos_x = -300
	self.shieldsize_x = 400
	self.shieldsize_y = 480
	self.shield = self.root:AddChild( Image("images/ui.xml", "black.tex") )
	self.shield:SetScale(1,1,1)
	self.shield:SetPosition(self.shieldpos_x,0,0)
	self.shield:SetSize(self.shieldsize_x, self.shieldsize_y)
	self.shield:SetTint(1,1,1,0.6)

	self.scalemain = self:AddUIat("Text", 1, 1, '灵敏度  ')
	self.scalemain:SetTooltip('设置控制摄像头的灵敏度')

	self.moving_scale = self:AddUIat('Text', 2, 0.9, '平移')
	self.moving_scale_num = self:AddUIat('Text', 2, 1.6, '')
	self.moving_scale_num:SetColour(0.2,1,0.2,1)
	self.moving_scale_bar = self:AddUIat('MyBar', 2, 3.4, 2, 16, 4)
	self.moving_scale_bar.ondelta = function(cur, dt)
		self.moving_scale_num:SetString(('%5.1f'):format(cur))
		utilfn.SetMovingScale(cur)
	end
	self.moving_scale_bar:Delta(0)

	self.rot_scale = self:AddUIat('Text', 3, 0.9, '旋转')
	self.rot_scale_num = self:AddUIat('Text', 3, 1.6, '')
	self.rot_scale_num:SetColour(0.2,1,0.2,1)
	self.rot_scale_bar = self:AddUIat('MyBar', 3, 3.4, 8, 50, 15)
	self.rot_scale_bar.ondelta = function(cur, dt)
		self.rot_scale_num:SetString(('%5.1f'):format(cur))
		utilfn.SetRotScale(cur)
	end
	self.rot_scale_bar:Delta(0)

	self.pitch_scale = self:AddUIat('Text', 4, 0.9, '倾斜')
	self.pitch_scale_num = self:AddUIat('Text', 4, 1.6, '')
	self.pitch_scale_num:SetColour(0.2,1,0.2,1)
	self.pitch_scale_bar = self:AddUIat('MyBar', 4, 3.4, 8, 40, 15)
	self.pitch_scale_bar.ondelta = function(cur, dt)
		self.pitch_scale_num:SetString(('%5.1f'):format(cur))
		utilfn.SetPitchScale(cur)
	end
	self.pitch_scale_bar:Delta(0)

	self.automove = self:AddUIat('Text', 6, 1, '自动推镜')
	self.automove:SetTooltip('匀速平移摄像头')
	--1--
	self.automove_dir = self:AddUIat('Text', 7, 0.9, '方向')
	self.automove_dir_num = self:AddUIat('Text', 7, 1.6, '')
	self.automove_dir_num:SetColour(0.2,0.2,1,1)
	self.automove_dir_bar = self:AddUIat('MyBar', 7, 3.4, -180*DEGREES, 180*DEGREES, 0)
	self.automove_dir_bar.displayfn  = function(a) return a*RADIANS end
	self.automove_dir_bar.ondelta = function(cur, dt)
		self.automove_dir_num:SetString(('%5d'):format(self.automove_dir_bar:GetDisplayedNum()))
		utilfn.SetAutoMoveDir(cur)
	end
	self.automove_dir_bar:Delta(0)
	--2--
	self.automove_speed = self:AddUIat('Text', 8, 0.9, '速度')
	self.automove_speed_num = self:AddUIat('Text', 8, 1.6, '')
	self.automove_speed_num:SetColour(0.2,0.2,1,1)
	self.automove_speed_bar = self:AddUIat('MyBar', 8, 3.4, -10, 10, 0)
	self.automove_speed_bar.ondelta = function(cur, dt)
		self.automove_speed_num:SetString(('%5.1f'):format(cur))
		utilfn.SetAutoMoveSpeed(cur)
	end
	self.automove_speed_bar:Delta(0)

	self.automove_ctrl1 = self:AddUIat('TextButton', 9, 1, '锁定    ')
	self.automove_ctrl1:SetOnClick(function() utilfn.EnableAutoMove(false) end)
	self.automove_ctrl2 = self:AddUIat('TextButton', 9, 2, '解锁    ')
	self.automove_ctrl2:SetOnClick(function() utilfn.EnableAutoMove(true) end)
	self.automove_ctrl3 = self:AddUIat('TextButton', 9, 3, '3秒后解锁')
	self.automove_ctrl3:SetOnClick(function() utilfn.DelayEnableAutoMove(3)end)
	self.automove_ctrl5 = self:AddUIat('TextButton', 9, 5, '重置偏移 ')
	self.automove_ctrl5:SetOnClick(utilfn.Reset)

end)

function Extra:OnKey()
	if ThePlayer and ThePlayer.HUD then
		ThePlayer.HUD:Show()
	end
	if self.shown then
		self:Hide()
	else
		self:Show()
	end
end

function Extra:OnRawKey(key, down)
	if Extra._base.OnRawKey(self, key, down) then return true end
end

return Extra
