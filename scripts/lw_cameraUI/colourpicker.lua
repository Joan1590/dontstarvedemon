local Image = require "widgets/image"
local Text = require "widgets/text"
local TextButton = require "widgets/textbutton"
local Widget = require "widgets/widget"
local ImageButton = require "widgets/imagebutton"

local variable = require 'lw_mod_camera'

local panradius = 65
local barlen = 130

-- 一个圆形色盘 + 底部横向的明暗调节bar
local ColourPicker = Class(Widget, function(self)
	Widget._ctor(self, "colour picker")
	--色盘
	self.pan = self:AddChild(Image("images/lw_cameraUI.xml", "colourpan.tex"))
	self.pan:SetScale(0.6)
	self.pan:SetRotation(90)
	--self.pan:SetClickable(false)
	--明度盘 0->全黑 1->全透明
	self.pan_black = self.pan:AddChild(Image("images/lw_cameraUI.xml", "colourpan.tex"))
	self.pan_black:SetClickable(false)
	self.pan_black:SetTint(0,0,0,0)
	self.pan_black:SetScale(1.02) --略微大
	--吸色点
	self.colourpicker = self:AddChild(Image("images/lw_cameraUI.xml", "colourpicker.tex"))
	self.colourpicker:SetScale(0.2)
	self.colourpicker:SetClickable(false)
	
	--明度调节杆
	self.bar_root = self:AddChild(Widget('bar_root'))
	self.bar_root:SetPosition(0, -panradius-20)

	self.bar = self.bar_root:AddChild(Image("images/lw_cameraUI.xml", "bar.tex"))
	self.bar.max = 1
	self.bar.min = 0
	self.bar:SetSize(barlen, 10)
	
	self.handle = self.bar_root:AddChild(Image("images/lw_cameraUI.xml", 'handle.tex'))
	self.handle:SetScale(0.3)

	self.barblank = self.bar_root:AddChild(Image("images/ui.xml", "blank.tex"))
	self.barblank:SetSize(barlen+10, 20)

	self.vvalue = 0

	--拖移比例
	local p1 = self:AddChild(Widget('p1')) p1:SetPosition(100,0)
	local p2 = self:AddChild(Widget('p2')) p2:SetPosition(-100,0)
	self.GetDragScale = function() --返回绝对距离与相对距离的比值
		return math.sqrt(distsq(p1:GetWorldPosition(), p2:GetWorldPosition())) / 200
	end

	self.listener = {}

	self:SetHSV({0,0,1}) --明度1, 色盘正中心
	self:StartUpdating()
end)

function ColourPicker:OnColourDirty()
	local rgb = self:GetRGB()
	for k in pairs(self.listener)do
		if k.ChangeColour then 
			k:ChangeColour(rgb)
		end
	end
end

function ColourPicker:GetRGB()
	return variable.call('hsv2rgb', unpack(self:GetHSV()))
end

function ColourPicker:GetHSV()
	local x, y = self.colourpicker:GetPosition():Get()

	local v = self.vvalue
	local angle = (x == 0 and y == 0) and 0 or math.atan2(x, -y)
	local h = (angle + (angle < 0 and 2*PI or 0)) / (2*PI)
	local s = math.sqrt(x*x + y*y) / panradius

	return {h, s, v}
end

function ColourPicker:SetRGB(rgb) --当鼠标选定一个色块时, 将色盘刷新至当前颜色
	self:SetHSV(variable.call('rgb2hsv', unpack(rgb)))
end

function ColourPicker:SetHSV(hsv)
	local h, s, v = unpack(hsv)
	self.vvalue = v
	self:DeltaV(0)
	local angle = h * 2 * PI
	local dist = s * panradius
	local x, y = math.sin(angle) * dist, -math.cos(angle) * dist
	self.colourpicker:SetPosition(x, y)
	self:OnColourDirty()
end

function ColourPicker:DeltaV(delta)
	--修改明度
	self.vvalue = math.clamp(self.vvalue + delta, self.bar.min, self.bar.max)
	--刷新ui
	self.handle:SetPosition(Remap(self.vvalue, self.bar.min, self.bar.max, -barlen/2, barlen/2), 0)
	self.pan_black:SetTint(0,0,0, 1 - self.vvalue)
	--触发其他函数
	self:OnColourDirty()
end

function ColourPicker:MakeHandleAtMouse()
	local mousepos = TheInput:GetScreenPosition()
	local ori = self.bar_root:GetWorldPosition()
	local xoffset = (mousepos.x - ori.x) / self:GetDragScale()
	local v = Remap(xoffset, -barlen/2, barlen/2, self.bar.min, self.bar.max)
	self.vvalue = v
	self:DeltaV(0)
end

function ColourPicker:MakeColourPickerAtMouse()
	local mousepos = TheInput:GetScreenPosition()
	local centerpos = self.pan:GetWorldPosition()
	local absoffset = mousepos - centerpos
	local reloffset = absoffset / self:GetDragScale()

	local lensq = reloffset:LengthSq()
	local r = panradius
	if lensq > r*r then
		reloffset = reloffset * (r / math.sqrt(lensq))
	end
	self.colourpicker:SetPosition(reloffset:Get())
	self:OnColourDirty()
end

function ColourPicker:OnControl(control, down)
	if control == CONTROL_ACCEPT then
		if down then
			if self.barblank.focus then
				self.handle._draging = true
			end
			if self.pan.focus then 
				self.colourpicker._draging = true
				self:MakeColourPickerAtMouse()
			end
		else
			self.handle._draging = false
			self.colourpicker._draging = false
		end
	end
	if control == CONTROL_SCROLLBACK then 
		self:DeltaV((self.bar.max - self.bar.min)*0.2)
	end
	if control == CONTROL_SCROLLFWD then 
		self:DeltaV((self.bar.min - self.bar.max)*0.2)
	end
	return true
end

function ColourPicker:OnUpdate(dt)
	if not TheInput:IsMouseDown(MOUSEBUTTON_LEFT) then
		self.handle._draging = false
		self.colourpicker._draging = false
		return
	end
	if self.handle._draging then
		self:MakeHandleAtMouse()
	end
	if self.colourpicker._draging then 
		self:MakeColourPickerAtMouse()
	end
end

return ColourPicker
