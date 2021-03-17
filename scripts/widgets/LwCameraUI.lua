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
local ScrollUI = Class(MyText, function(self, data)
	MyText._ctor(self, '')
	self:SetSize(20)
	self.LB = self:AddChild()
	self.RB = self:AddChild()
end)
local _ui = {
	Widget = Widget,
	Text = MyText,
	TextButton = MyTextButton,
}
local function getUIpos(row, line)
	return Vector3(line * 70 - 530, -row * 35 + 230, 0)
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

local LwCameraUI = Class(Widget, function(self)
	Widget._ctor(self, "LwCameraUI")
	self.AddUIat = addUIat

	self.root = self:AddChild(Widget("ROOT"))
	self.root:SetVAnchor(ANCHOR_MIDDLE)
	self.root:SetHAnchor(ANCHOR_MIDDLE)
	self.root:SetScaleMode(SCALEMODE_PROPORTIONAL)
	self.root:SetPosition(0,0,0)

	self.shieldpos_x = -340
	self.shieldsize_x = 370
	self.shieldsize_y = 480
	self.shield = self.root:AddChild( Image("images/ui.xml", "black.tex") )
	self.shield:SetScale(1,1,1)
	self.shield:SetPosition(self.shieldpos_x,0,0)
	self.shield:SetSize(self.shieldsize_x, self.shieldsize_y)
	self.shield:SetTint(1,1,1,0.6)

	self.focusplayer = self:AddUIat('Text', 1, 1, '自由控制')
	self.focusplayer:SetTooltip('用 ↑ ↓ ← → shift 按键移动和旋转镜头')
	self.focusplayer.sel1 = self:AddUIat('TextButton', 1, 2, '是')
	self.focusplayer.sel2 = self:AddUIat('TextButton', 1, 3, '否')
	self.focusplayer.sel_reset = self:AddUIat('TextButton', 1, 4, '     重置偏移')
	self.focusplayer.sel_reset:SetOnClick(utilfn.Reset)
	self.focusplayer.OnSelect = function(_, i)
		if i == 1 then
			utilfn.FreeCamera(true)
		elseif i  == 2 then
			utilfn.FreeCamera(false)
		end
	end
	MakeUIselectable(self.focusplayer, 2)

	self.cutscene = self:AddUIat('Text', 2, 1, '镜头跟随')
	self.cutscene:SetTooltip('使摄像头位置随目标移动而移动')

	self.cutscene.sel1 = self:AddUIat('TextButton', 2, 2, '是')
	self.cutscene.sel2 = self:AddUIat('TextButton', 2, 3, '否')
	self.cutscene.OnSelect = function(_, i)
		if i == 1 then
			utilfn.CutScene(false)
		else
			utilfn.CutScene(true)
		end
	end
	MakeUIselectable(self.cutscene)

	self.anothertarget = self:AddUIat('Text', 3, 1, '锁定目标')
	self.anothertarget:SetTooltip('选择摄像头追踪的目标')
	self.anothertarget.sel1 = self:AddUIat('TextButton', 3, 2, '玩家')
	self.anothertarget.sel2 = self:AddUIat('TextButton', 3, 3, '点选')
	self.anothertarget.sel3 = self:AddUIat('TextButton', 3, 4, '上一个')
	self.anothertarget.sel4 = self:AddUIat('TextButton', 3, 4.8, '下一个')

	self.anothertarget.sel1:SetOnClick(function()utilfn.Focus(ThePlayer) end)
	self.anothertarget.sel2:SetOnClick(utilfn.NewFocus)
	self.anothertarget.sel3:SetOnClick(utilfn.FocusPrevious)
	self.anothertarget.sel4:SetOnClick(utilfn.FocusLatter)

	self.distance_override = self:AddUIat('Text', 5, 1, '自定义高度')
	self.distance_override:SetTooltip('设置并锁定摄像头高度')
	local _val = {
		40, 50, 60, 80, 100, 150,
		1, 2, 4, 8,   15,   nil,
	}
	for i = 0,1 do
		for j = 0,5 do
			local sel = self:AddUIat('TextButton', 5+i, 2+j*0.5, tostring(_val[i*6+j+1]))
			sel:SetTextSize(20)
			self.distance_override['sel'..i*6+j+1] = sel
		end
	end
	self.distance_override.OnSelect = function(_, i)
		utilfn.SetDistOver(_val[i])
	end
	MakeUIselectable(self.distance_override, 12)

	self.pitch_override = self:AddUIat('Text', 7, 1, '自定义倾角')
	self.pitch_override:SetTooltip('设置并锁定摄像头倾角')
	local _val = {
		0, 5, 10, 20, 30, 40,
		50, 60, 70, 80, 90, nil,
	}
	for i = 0,1 do
		for j = 0,5 do
			local sel = self:AddUIat('TextButton', 7+i, 2+j*0.5, tostring(_val[i*6+j+1]))
			sel:SetTextSize(20)
			self.pitch_override['sel'..i*6+j+1] = sel
		end
	end
	self.pitch_override.OnSelect = function(_, i)
		utilfn.SetPitchOver(_val[i])
	end
	MakeUIselectable(self.pitch_override, 12)



	--self.firstplayer = self:AddUIat('TextButton', 3, 1, '第一人称')


	self.hidehud = self:AddUIat('TextButton', 4, 1, '隐藏界面')
	self.hidehud:SetOnClick(function() if ThePlayer and ThePlayer.HUD then ThePlayer.HUD:Hide() end end)

	local _isplayershown = true
	local function _hideplayer()
		if not ThePlayer then return end
		if _isplayershown then
			ThePlayer:Hide()
			ThePlayer.DynamicShadow:Enable(false)
		else
			ThePlayer:Show()
			ThePlayer.DynamicShadow:Enable(true)
		end
		_isplayershown = not _isplayershown
	end
	self.hideplayer = self:AddUIat('TextButton', 4, 2.4, '隐藏玩家')
	self.hideplayer:SetOnClick(_hideplayer)

	local _iscloudshown = true
	local function _hidecloud()
		if ThePlayer and ThePlayer.HUD and ThePlayer.HUD.clouds then
			ThePlayer.HUD.clouds:GetAnimState():SetBuild(_iscloudshown and 'log' or 'clouds_ol')
		end
		_iscloudshown = not _iscloudshown
	end
	self.hidecloud = self:AddUIat('TextButton', 4, 3.8, '隐藏云层')
	self.hidecloud:SetOnClick(_hidecloud)
	

	--更多设置
	self.extraUI = self:AddChild(require('widgets/LwCameraUI_extra')())
	self.extraUI:Hide()
	self.extraUI:MoveToBack()

	self.extra_bt = self:AddUIat('TextButton', 13-0.5, 0.5, '更多')
	self.extra_bt:SetOnClick(function()
		self.extraUI[self.extraUI.shown and 'Hide' or 'Show'](self.extraUI)
	end)

	self.cancel_bt = self:AddUIat('TextButton', 13-0.5, 1.5, '关闭')
	self.cancel_bt:SetOnClick(function()
		self:Hide()
	end)

	self:Hide()

end)

function LwCameraUI:OnKey()
	if ThePlayer and ThePlayer.HUD then
		ThePlayer.HUD:Show()
	end
	if self.shown then
		self:Hide()
	else
		self:Show()
	end
end

function LwCameraUI:OnRawKey(key, down)
	if LwCameraUI._base.OnRawKey(self, key, down) then return true end
end

return LwCameraUI
