local Image = require "widgets/image"
local Text = require "widgets/text"
local TextButton = require "widgets/textbutton"
local Widget = require "widgets/widget"
local ImageButton = require "widgets/imagebutton"

local _ui = {
	Text = Class(Text, function(self, text, font, size)
		Text._ctor(self, font or UIFONT, size or 25, text or '')
	end),

	TextClickable = Class(Text, function(self, text, font, size)
		Text._ctor(self, font or UIFONT, size or 25, text or '')
		self.image = self:AddChild(Image("images/ui.xml", "blank.tex"))
	    self.image:SetSize(self:GetRegionSize())
	    self.OnControl = function(self, ctrl, down)
	    	if self.shown and self.focus and ctrl == CONTROL_ACCEPT then
	    		if down then
	    			TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/click_move")
	    		else
	    			if self.onclick then self.onclick() end
	    		end
	    	end
	    end
	end),

	TextSwitch = Class(TextButton, function(self, data, font,size)
		TextButton._ctor(self)
		self:SetText(data[1].text)
		self:SetTextSize(25)
		self:SetFont(font or UIFONT)

		self._state = 1

		self:SetOnClick(function()
			if self._state == 1 then
				if data[1].fn then data[1].fn() end
				self._state = 2
				self:SetText(data[2].text)
			else
				if data[2].fn then data[2].fn() end
				self._state = 1
				self:SetText(data[1].text)
			end
			if self.onchanged then
				self.onchanged(self._state)
			end
		end)
	end),

	TextButton = Class(TextButton, function(self, text, font, size)
		TextButton._ctor(self)
		self:SetText(text or '')
		self:SetTextSize(25)
		self:SetFont(font or UIFONT)
	end),

	Title = Class(Widget, function(self, text, text2)
		Widget._ctor(self, 'Title: '..tostring(text))
		self.text = self:AddChild(Text(TITLEFONT, 35, text))
		self.text:SetPosition(155, 0)
		self.text:SetHAlign(ANCHOR_LEFT)
	    self.text:SetVAlign(ANCHOR_TOP)
		self.text:SetRegionSize(380, 60)

		self.line = self:AddChild(Image("images/lw_cameraUI.xml", "crossline.tex"))
		self.line:SetSize(400, 15)

		if text2 then
			self.text2 = self:AddChild(Text(UIFONT, 25, text2))
			self.text2:SetPosition(155, -40)
			self.text2:SetHAlign(ANCHOR_LEFT)
	    	self.text2:SetVAlign(ANCHOR_TOP)
			self.text2:SetRegionSize(380, 60)
			self.text2:EnableWordWrap(true)

			self.line:SetPosition(145, -45)
		else
			self.line:SetPosition(145, -10)
		end
	end),

	Line = Class(Widget, function(self, width, offset)
		Widget._ctor(self, 'crossline')
		self.line = self:AddChild(Image("images/lw_cameraUI.xml", "crossline.tex"))
		self.line:SetSize(width or 400, 15)
		self.line:SetPosition(offset or (width or 400)/2 - 55, 0)
	end),

	SubMenuClicker = Class(TextButton, function(self, text, submenuname)
		TextButton._ctor(self)
		self:SetText(text or '')
		self:SetTextSize(25)
		self:SetFont(UIFONT)
		self.submenuname = submenuname
		self:SetOnClick(function()
			if self.parent and self.parent.PushSubMenu then
				self.parent:PushSubMenu(submenuname, text)
			end
		end)
	end),

}

local x, y, yoff = -200, 230, 0
local w, h = 70, 35

local function setGridPara(data)
	x, y, w, h = data.x or x, data.y or y, data.w or w, data.h or h
	yoff = 0
end

local function insertHeight(v) --偷懒用的
	yoff = yoff - v
end

local function getUIpos(row, line)
	return Vector3(line * w + x, -row * h + y + yoff, 0)
end

local function addUIat(self, name, row, line, ...)
	local _class = name
	if type(name) == 'string' then
		_class = _ui[name] or require(name)
	end
	local ui = self:AddChild(_class(...))
	ui:SetPosition(getUIpos(row, line))
	return ui
end

local function SetLText(self, w, h)
	self:SetHAlign(ANCHOR_LEFT)
    self:SetVAlign(ANCHOR_TOP)
	self:SetRegionSize(w or 380, h or 60)
	self:EnableWordWrap( true )
end

return {
	setGridPara = setGridPara,
	insertHeight = insertHeight,
	getUIpos = getUIpos,
	addUIat = addUIat,
	SetLText = SetLText,
}