
local variable = require 'lw_mod_camera'

local Image = require "widgets/image"
local Text = require "widgets/text"
local TextButton = require "widgets/textbutton"
local Widget = require "widgets/widget"

local uifn = require "lw_cameraUI/util"

local UNIT = 'lw_cameraUI/unit'

local function _Cloud(val)
	local player = variable.call('GetPlayer')
	local HUD = player and player.HUD
	if HUD and HUD.clouds then
		HUD.clouds:GetAnimState():SetBuild(val and 'clouds_ol' or 'log')
	end
end
variable.set('ShowCloud', function() _Cloud(true) end)
variable.set('HideCloud', function() _Cloud(false) end)

local LwCameraUI = Class(Widget, function(self)
	Widget._ctor(self, "LwCamera Main UI")
	local player = variable.call('GetPlayer')
	uifn.setGridPara({x = -200})
	self.AddUIat = function(_, ...) return uifn.addUIat(self.shield, ...) end

	self.root = self:AddChild(Widget("ROOT"))
	self.root:SetVAnchor(ANCHOR_MIDDLE)
	self.root:SetHAnchor(ANCHOR_MIDDLE)
	self.root:SetScaleMode(SCALEMODE_PROPORTIONAL)
	self.root:SetPosition(0,0,0)

	local x, y, w, h = -350, 0, 370, 480
	self.shield = self.root:AddChild( Image("images/ui.xml", "black.tex") )
	self.shield:SetScale(1,1,1)
	self.shield:SetPosition(x, y)
	self.shield:SetSize(w, h)
	self.shield:SetTint(1,1,1,0.6)
	self.shield.PushSubMenu = function(_, ...) return self:PushSubMenu(...) end
	
	local x, y, w, h = 70, 0, 420, 480
	self.submenu_root = self.root:AddChild(Widget("ROOT2"))
	self.submenu_root:SetPosition(x, y)
	self.submenu_root:Hide()
	self.submenu_root.HideMain = function() self:Hide() end
	self.submenu_shield = self.submenu_root:AddChild( Image("images/ui.xml", "black.tex"))
	self.submenu_shield:SetSize(w, h)
	self.submenu_shield:SetTint(1,1,1,0.6)
	self.submenu_name = nil
	self.submenu_cache = {}

	self._title1 = self:AddUIat('Text', 0.9, 2, '调节摄像头参数', TITLEFONT, 35)
	--self._line1 = self:AddUIat('Line', 1.3, 1, 350)

	uifn.insertHeight(40)

	self._move = self:AddUIat('SubMenuClicker', 1, 1, '偏移', 'move')

	self._rotate = self:AddUIat('SubMenuClicker', 1, 2.5, '朝向', 'rotate')

	self._sky = self:AddUIat('SubMenuClicker', 1, 4, '背景', 'sky')

	self._dist = self:AddUIat('SubMenuClicker', 2, 1, '高度', 'height')

	self._pitch = self:AddUIat('SubMenuClicker', 2, 2.5, '倾角', 'pitch')

	self._target = self:AddUIat('SubMenuClicker', 2, 4, '目标', 'target')
	--------------------------------------------------------------
	

	self._resetcurrent = self:AddUIat('TextButton', 4, 1.2, '重置...  ')
	self._resetcurrent:SetClickable(false)
	self._resetcurrent:SetColour(0.5, 0.5, 0.5, 1)
	self._resetcurrent:SetOnClick(function()
		local sm = self.submenu_name and self.submenu_cache[self.submenu_name]
		if sm and sm.shown and sm.SetDefault then sm:SetDefault() end
	end)

	self._default = self:AddUIat('TextButton', 4, 2.5, '恢复默认')
	self._default:SetColour(1, 0.2, 0.2, 1)
	self._default:SetTooltip('一键重置所有参数,\n你确定要这么干吗?')
	self._default:SetOnClick(function() self:SetDefault() end)

	uifn.insertHeight(160)
	self.title2 = self:AddUIat('Text', 0.9, 1.6, '一点小功能', TITLEFONT, 35)

	self._hidehud = self:AddUIat('TextButton', 2, 1.3, '隐藏界面')
	self._hidehud.onclick = function() if player and player.HUD then player.HUD:Hide() end end

	self._hideplayer = self:AddUIat('TextSwitch', 2, 2.6, {
		{text = '隐藏玩家', fn = function() if player then player:Hide() player.DynamicShadow:Enable(false) end end},
		{text = '显示玩家', fn = function() if player then player:Show() player.DynamicShadow:Enable(true) end end},
	})

	self._hidecloud = self:AddUIat('TextSwitch', 2, 3.9, {
		{text = '隐藏云层', fn = variable.get('HideCloud')},
		{text = '显示云层', fn = variable.get('ShowCloud')},
	})

	self._cancel_bt = self:AddUIat('TextButton', 7-0.5, 1, '关闭')
	self._cancel_bt:SetOnClick(function() self:Hide() end)

	--self._connect_author = self:AddUIat('TextButton', 7-0.5, 2, '联系作者')
	--self._connect_author:SetOnClick(function() VisitURL('https://www.jianshu.com/p/a44a61f9e4f9') end)
	--

	--建立缓冲
	self._move.onclick()
	self._rotate.onclick()
	self._sky.onclick()
	self._dist.onclick()
	self._pitch.onclick()
	self._target.onclick()
	
	self:PushSubMenu(nil)
end)

function LwCameraUI:SetSheildAlpha(a)
	self.shield:SetTint(1,1,1,a)
	self.submenu_shield:SetTint(1,1,1,a)
end

function LwCameraUI:SetDefault()
	for k, v in pairs(self.submenu_cache) do
		if v.SetDefault then v:SetDefault() end
	end
	TheCamera:SetDefault()
end

function LwCameraUI:PushSubMenu(name, displayedname)
	if name then
		self.submenu_root:Show()
		name = 'lw_cameraUI/submenus/'..name
		if self.submenu_name == name then
			self.submenu_cache[name]:Hide()
			self.submenu_shield:Hide()
			self.submenu_name = nil
			self._resetcurrent:SetClickable(false)
			self._resetcurrent:SetColour(0.5, 0.5, 0.5, 1)
			self._resetcurrent:SetText('重置...  ')
		else
			if self.submenu_cache[name] then
				self.submenu_cache[name]:Show()
			else
				self.submenu_cache[name] = self.submenu_root:AddChild(require(name)())
			end
			self._resetcurrent:SetClickable(true)
			self._resetcurrent:SetColour(0.25,0.75,0.25,1)
			self._resetcurrent:SetText('重置'..(displayedname or '...  '))
			if self.submenu_cache[self.submenu_name] then
				self.submenu_cache[self.submenu_name]:Hide()
			end
			self.submenu_shield:Show()
			self.submenu_name = name
		end
	else
		self.submenu_root:Hide()
	end
end

function LwCameraUI:OnKey()
	local player = variable.softcall('GetPlayer')
	if player and player.HUD then
		if player.HUD.shown then
			if self.shown then
				self:Hide()
			else
				self:Show()
			end
		else
			player.HUD:Show()
		end
	end
end

function LwCameraUI:OnRawKey(key, down)
	if LwCameraUI._base.OnRawKey(self, key, down) then return true end
end

return LwCameraUI
