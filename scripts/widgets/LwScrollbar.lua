local Image = require "widgets/image"
local Text = require "widgets/text"
local TextButton = require "widgets/textbutton"
local Widget = require "widgets/widget"
local ImageButton = require "widgets/imagebutton"
--默认是横的

local Bar = Class(Widget, function(self, min, max, default, uilen)
	Widget._ctor(self, "bar")

	self.bar_rt = self:AddChild(Widget('rt'))
	self.bar_rt:SetRotation(90)
	self.bar = self.bar_rt:AddChild(Image("images/global_redux.xml", "scrollbar_bar.tex"))
	
	self.handle = self:AddChild(Image("images/global_redux.xml", 'scrollbar_handle.tex'))
	self.handle:SetScale(0.5)

	local p1 = self:AddChild(Widget('p1'))
	p1:SetPosition(100,0)
	local p2 = self:AddChild(Widget('p2'))
	p2:SetPosition(-100,0)
	local scale = math.sqrt(distsq(p1:GetWorldPosition(), p2:GetWorldPosition())) / 200
	self.scrollscale = scale

	self:Init(min, max, default, uilen)
	self:StartUpdating()
end)

function Bar:GetNum()
	return self.current
end

function Bar:GetDisplayedNum()
	return self.displayfn and self.displayfn(self.current) or self.current
end

function Bar:Init(min, max, default, uilen)
	self.min = min 
	self.max = max 
	self.default = default or self.min
	self.current = self.default
	self.uilen = uilen or 200

	self.bar:SetSize(10, self.uilen)
	self:Delta(0)
end

function Bar:SetHandle()
	self.handle:SetPosition(Remap(self.current, self.min, self.max, -self.uilen/2, self.uilen/2), 0)
end

function Bar:Delta(num)
	self.current = math.clamp(self.current + num, self.min, self.max)
	self:SetHandle()
	if self.ondelta then
		self.ondelta(self.current, num)
	end
end

function Bar:Click()
	return 
end

function Bar:OnControl(control, down)
	if control == CONTROL_ACCEPT then
		if down and self.handle.focus then
			self.handle._draging = true
		elseif down then 
			self:Click()
		else
			self.handle._draging = false
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
	if self.handle._draging then
		local pos = TheInput:GetScreenPosition()
		if self.oldpos then
			local dx = (pos - self.oldpos).x * self.scrollscale
			local dnum = dx * (self.max - self.min) / self.uilen
			self:Delta(dnum) 
			self.oldpos = pos
		else
			self.oldpos = pos 
		end
		if not TheInput:IsMouseDown(MOUSEBUTTON_LEFT) then 
			self.handle._draging = false
		end
	else
		self.oldpos = nil
	end
end

return Bar
