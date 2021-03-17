local Image = require "widgets/image"
local Text = require "widgets/text"
local TextButton = require "widgets/textbutton"
local Widget = require "widgets/widget"
local ImageButton = require "widgets/imagebutton"

local function DefaultDisplay(num)
	return string.format("%5.1f", num)
end

--默认是横的
local Bar = Class(Widget, function(self, name, min, max, default, uilen)
	Widget._ctor(self, "bar")

	self.barname = self:AddChild(Text(UIFONT, 25, name or ''))

	self.num = self:AddChild(Text(UIFONT, 25, ''))
	self.num:SetColour(0.25, 0.75, 0.25, 1)
	self.num:SetPosition(50, 0)

	self.bar_rt = self:AddChild(Widget('rt'))

	self.bar = self.bar_rt:AddChild(Image("images/lw_cameraUI.xml", "bar.tex"))
	self.bar:SetClickable(false)
	
	self.handle = self.bar_rt:AddChild(Image("images/lw_cameraUI.xml", 'handle.tex'))
	self.handle:SetScale(0.4)
	self.handle:SetClickable(false)

	self.blank = self.bar_rt:AddChild(Image("images/ui.xml", "blank.tex"))

	self.limit1 = self.bar_rt:AddChild(Widget('p1'))
	self.limit2 = self.bar_rt:AddChild(Widget('p2'))

	self:Init(min, max, default, uilen)
	self:StartUpdating()

	self.displayfn = DefaultDisplay
end)

function Bar:GetValue()
	return self.current
end

function Bar:GetDisplayedValue()
	local v = self:GetValue()
	return self.displayfn and self.displayfn(v) or v
end

function Bar:SetShowValue(v)
	if v then self.num:Show() else self.num:Hide() end
end

function Bar:Init(min, max, default, uilen)
	self.min = min 
	self.max = max 
	self.default = default or self.min
	self.current = self.default
	self.uilen = uilen or 220

	self.bar_rt:SetPosition(self.uilen/2 + 80, 0)
	self.limit1:SetPosition(-self.uilen/2, 0)
	self.limit2:SetPosition(self.uilen/2, 0)
	self.bar:SetSize(self.uilen+5, 10)
	self.blank:SetSize(self.uilen+5, 20)
	--给ondelta函数赋值以后, 才调用Delta
	self.inst:DoTaskInTime(0, function() self:Delta(0) end)
end

function Bar:AdjustBar(vec)
	local pos = self.bar_rt:GetPosition()
	self.bar_rt:SetPosition(pos+vec)
end

function Bar:Delta(num)
	self.current = math.clamp(self.current + num, self.min, self.max)
	self.handle:SetPosition(Remap(self.current, self.min, self.max, -self.uilen/2, self.uilen/2), 0)
	self.num:SetString(self:GetDisplayedValue())
	if self.ondelta then
		self.ondelta(self.current, num)
	end
end

function Bar:SetTo(num)
	self.current = num
	self:Delta(0)
end

function Bar:SetDefault()
	self:SetTo(self.default or self.min or 0)
end

--只能用于横向
function Bar:Click()
	local mousex = TheInput:GetScreenPosition().x
	local lx, rx = self.limit1:GetWorldPosition().x, self.limit2:GetWorldPosition().x
	local p
	if mousex < lx then
		p = 0
	elseif mousex > rx then
		p = 1
	else
		p = (mousex - lx) / (rx - lx)
	end
	local num = Lerp(self.min, self.max, p) 
	self:SetTo(num)
end

function Bar:OnControl(control, down)
	if not self.shown then return end
	if control == CONTROL_ACCEPT then
		if down then
			if self.blank.focus then
				self._draging = true
				self:Click()
			end
		else
			self._draging = false
		end
	end
	if control == CONTROL_SCROLLBACK then 
		self:Delta((self.max - self.min)*0.2)
	end
	if control == CONTROL_SCROLLFWD then 
		self:Delta((self.max - self.min)*(-0.2))
	end
	return true
end

function Bar:OnUpdate(dt) --注意这里不兼容竖排
	if TheInput:IsMouseDown(MOUSEBUTTON_LEFT) then
		if self._draging then 
			self:Click()
		end
	else
		self._draging = false
	end
end

return Bar
