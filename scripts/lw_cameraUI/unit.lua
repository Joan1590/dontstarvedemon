local Image = require "widgets/image"
local Text = require "widgets/text"
local TextButton = require "widgets/textbutton"
local Widget = require "widgets/widget"
local ImageButton = require "widgets/imagebutton"

local atlas = 'images/lw_cameraUI.xml'

--"文字"  [图标1] [图标2] [图标3]
local Unit = Class(Widget, function(self, text, data)
	Widget._ctor(self, "bar")
	local this = self

	self.text = self:AddChild(Text(DEFAULTFONT, 25, text))

	if data.enable then 
		--启用/禁用
		self.enable_bt = self:AddChild(Image(atlas, 'enable2.tex'))
		this._default = data.enable.default
		this._isenabled = data.enable.default or false
		if not this._isenabled then self.enable_bt:SetTint(1,1,1,0.2) end
		self.enable_bt.OnControl = function(self, control, down)
			if not self.focus then return end
			if control == CONTROL_ACCEPT then
				if down then
					TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/click_move")
					if this._isenabled then 
						data.enable.fn(false)
						this._isenabled = false
						self:SetTint(1,1,1,0.2)
					else
						data.enable.fn(true)
						this._isenabled = true
						self:SetTint(1,1,1,1)
					end
				end
			end
		end
		self.enable_bt.ForceSet = function(self, val)
			if this._isenabled == val then
				return
			else
				this._isenabled = val
				data.enable.fn(val)
				self:SetTint(1,1,1,val and 1 or 0.2)
			end
		end
		self.enable_bt.SetDefault = function(self)
			self:ForceSet(this._default)
		end
	end
	if data.trigger then
		self.trigger_bt = self:AddChild(Image(atlas, 'trigger2.tex'))
		self.trigger_bt.OnControl = function(self, control, down)
			if not self.focus then return end
			if control == CONTROL_ACCEPT and down then
				TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/click_move")
				data.trigger.fn()
			end
		end
		self.text.OnControl = self.trigger_bt.OnControl
	end
	if data.submenu then
		--更多的设置
		self.submenu_bt = self:AddChild(Image(atlas, 'submenu2.tex'))
		self.submenu_bt.OnControl = function(self, control, down)
			if not self.focus then return end
			if control == CONTROL_ACCEPT then 
				if down then 
					TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/click_move")
					if this.parent and this.parent and this.parent.PushSubMenu then
						this.parent:PushSubMenu(data.submenu.name)
					end
				end
			end
		end
	end
	if data.hint then
		--提示
		self.hint_icon = self:AddChild(Image(atlas, 'hint2.tex'))
		self.hint_icon:SetTooltip(data.hint)
	end

	self:Finalize()
end)

function Unit:Finalize(xoffset, xinterval, yoffset)
	xoffset = xoffset or 18
	xinterval = xinterval or 25
	yoffset = yoffset or 0
	local x, y = self.text:GetRegionSize()
	local i = 0
	for _, v in ipairs({'enable_bt', 'submenu_bt', 'hint_icon', 'trigger_bt'})do
		if self[v] ~= nil then
			self[v]:SetScale(0.35)
			self[v]:SetPosition(x/2 + i*xinterval + xoffset, yoffset)
			i = i + 1
		end
	end
end

return Unit
