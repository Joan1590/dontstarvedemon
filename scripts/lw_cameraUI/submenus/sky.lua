
local variable = require 'lw_mod_camera'

local Image = require "widgets/image"
local Text = require "widgets/text"
local TextButton = require "widgets/textbutton"
local Widget = require "widgets/widget"
local Bar = require "lw_cameraUI/bar"

local uifn = require "lw_cameraUI/util"

local UNIT = 'lw_cameraUI/unit'


local ColourBlock = Class(Image, function(self, rgb)
	Image._ctor(self, 'images/lw_cameraUI.xml', 'colourblock.tex')
	self.rgb = rgb
	local r,g,b = unpack(rgb)
	self:SetTint(r,g,b,1)

	local _sel = self:AddChild(Image('images/lw_cameraUI.xml', 'colourblock_sel.tex'))
	_sel:SetTint(1,1,0.0,1)
	_sel:Hide()

	self.mut = {}

	self.SetSel = function(self, val)
		if val then _sel:Show() else _sel:Hide() end
		if self.onsel then
			self.onsel(val)
		end
	end

	self.OnControl = function(self, ctrl, down)
		if ctrl == CONTROL_ACCEPT and down then
			TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/click_move")
			self:SetSel(true)
			self.parent.colour_selected = self
			self.parent.colourpicker:SetRGB(self.rgb)
			for k, v in pairs(self.mut)do
				if v.SetSel then v:SetSel(false) end
			end

			return true
		end
	end

	self:SetScale(0.4)
end)

local DEFAULT_RGB = {0.25, 0.75, 1}

local Sky = Class(Widget, function(self)
	Widget._ctor(self, "LwCamera sub -> sky")
	uifn.setGridPara({x = -220})
	self.AddUIat = uifn.addUIat

	local _title = self:AddUIat('Title', 1, 1, '背景', '往场景中添加一个天空')

	uifn.insertHeight(40)

	-------------------------------------------------------------------

	local _sky = self:AddUIat(UNIT, 2, 1, '天幕', {
		enable = {fn = variable.get('sky.Show'), default = true},
	})
	local _skycolour = self:AddUIat(ColourBlock, 2, 2, DEFAULT_RGB)
	

	-------------------------------------------------------------------
	local _h = self:AddUIat(Bar, 3, 1, '高度:', -40, 70, 70)
	--_h:AdjustBar(Vector3(30, 0, 0))
	_h.ondelta = variable.get("sky.SetH")

	local _d = self:AddUIat(Bar, 4, 1, '距离:', 10, 70, 50)
	_d.ondelta = variable.get("sky.SetDist")

	-------------------------------------------------------------------

	local _skyline = self:AddUIat(UNIT, 5, 1, '地平线', {
		enable = {fn = variable.get('skyline.Show'), default = true},
	})
	local _skylinecolour = self:AddUIat(ColourBlock, 5, 2.15, {1, 1, 1})

	local _fade = self:AddUIat(Bar, 6, 1, '渐变:', 0, 1, 0.25)
	_fade.ondelta = variable.get('skyline.SetScale')
	_fade.displayfn = function(v) return string.format("%d", math.clamp(v*100, 0, 100))..'%' end

	-------------------------------------------------------------------
	--调色板
	local _picker = self:AddUIat('lw_cameraUI/colourpicker', 9, 1.5)
	self.colourpicker = _picker
	--回调
	_picker.listener[self] = true

	_skycolour.mut[1] = _skylinecolour
	_skylinecolour.mut[1] = _skycolour

	_skycolour.fnname = 'sky.SetColour'
	_skylinecolour.fnname = 'skyline.SetColour'

	_skycolour:OnControl(CONTROL_ACCEPT, true) --默认选定这个色块

	-------------------------------------------------------------------
	self.SetDefault = function(self)
		_sky.enable_bt:SetDefault()
		_skyline.enable_bt:SetDefault()
		_h:SetDefault()
		_d:SetDefault()
		_fade:SetDefault()
		--调色板
		_skylinecolour:OnControl(CONTROL_ACCEPT, true)
		_picker:SetRGB({1,1,1})
		_skycolour:OnControl(CONTROL_ACCEPT, true)
		_picker:SetRGB(DEFAULT_RGB)
	end
end)

function Sky:ChangeColour(rgb)
	if self.colour_selected then
		local r,g,b = unpack(rgb)
		self.colour_selected:SetTint(r,g,b,1)
		self.colour_selected.rgb = rgb
		local fnname = self.colour_selected.fnname
		variable.call(fnname, rgb)
	end
end

return Sky

