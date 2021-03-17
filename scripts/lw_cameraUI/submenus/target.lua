
local variable = require 'lw_mod_camera'

local Image = require "widgets/image"
local Text = require "widgets/text"
local TextButton = require "widgets/textbutton"
local Widget = require "widgets/widget"
local Bar = require "lw_cameraUI/bar"

local uifn = require "lw_cameraUI/util"

local UNIT = 'lw_cameraUI/unit'

local TargetBlock = Class(Widget, function(self)
	Widget._ctor(self, 'target block')

	--self.bg = self:AddChild(Image('images/lw_cameraUI.xml', 'white.tex'))
	--self.bg:SetSize(360, 30)
	--self.bg:SetTint(0.1, 0.1, 0.0, 0.8)
	--self.bg:SetPosition(180, -15, 0)

	self.text = self:AddChild(TextButton(''))
	self.text:SetPosition(160, 0)
	self.text:SetTextSize(25)
	self.text.text:SetHAlign(ANCHOR_LEFT)
	self.text.text:SetVAlign(ANCHOR_TOP)
	self.text.text:SetRegionSize(380, 50)
	self.text:SetOnClick(function()
		if self.targetent and self.targetent:IsValid() then
			variable.call('target.on_click_block', self)
		else
			self:SelectTargetMode() 
		end
	end)

	self.cancel = self:AddChild(TextButton('×'))
	self.cancel:SetTextSize(40)
	self.cancel:SetText('×')
	self.cancel:SetPosition(300, 10)
	self.cancel:SetOnClick(function() self:Clear() end)
	self.cancel:Hide()

	self:Clear(true)

	
end)

function TargetBlock:Clear(init)
	self.targetent = nil
	if self.task then
		self.task:Cancel()
		self.task = nil
	end
	self.text:SetText('添加目标+')
	self.text:SetColour(0.9,0.8,0.6,1)
	self.cancel:Hide()
	if not init and self.id == self.parent.blocks.current then
		variable.call('target.to_player')
	end
end

function TargetBlock:SetTarget(ent)
	if ent and ent:IsValid() then
		self.targetent = ent
		self.task = self.inst:DoPeriodicTask(0, function()
			if not (self.targetent and self.targetent:IsValid()) then
				self:Clear()
			else 
				if self.targetent.inlimbo then
					self.text:SetColour(1,0,0,1)
				else
					self.text:SetColour(0,1,0,1)
				end
			end
		end)

		self.text:SetText(string.format("%d - %s", ent.GUID, ent:GetDisplayName()))
		self.cancel:Show()
		if ent.inlimbo then
			self.text:SetColour(1,0,0,1)
		else
			self.text:SetColour(0,1,0,1)
		end
	end
end

function TargetBlock:SelectTargetMode()
	self.parent._toadd = self
	self.parent:HideMain()
	variable.call('target.set_look_for_new')
end

local Target = Class(Widget, function(self)
	Widget._ctor(self, "LwCamera sub -> target")
	uifn.setGridPara({x = -220})
	self.AddUIat = uifn.addUIat

	local _title = self:AddUIat('Title', 1, 1, '目标', '改变摄像头跟随的实体')

	uifn.insertHeight(40)

	-------------------------------------------------------------------

	local _free = self:AddUIat(UNIT, 2, 1, '不跟随', {
		enable = {fn = variable.get('CutScene'), default = false},
		hint = '点一下, 再按一下方向键, 你就懂了',
	})

	local _listtitle = self:AddUIat('Text', 3, 1, '选择目标')

	self.blocks = {current = 1}
	for i = 1, 5 do
		local _block = self:AddUIat(TargetBlock, i+4-0.6, 1)
		self.blocks[i] = _block
		_block.id = i
		if i == 1 then
			_block:SetTarget(variable.call('GetPlayer'))
			_block.cancel:Hide()
			variable.set('target.to_player', function()
				variable.call('target.on_click_block', _block)
			end)
		end
	end

	local _selector = self:AddChild(Image('images/lw_cameraUI.xml', 'selector_rect.tex')) --浮动的
	_selector:SetScale(1,0.4)
	_selector:SetTint(1,1,1,1)
	_selector:SetClickable(false)

	variable.set('target.on_set_new', function(ent)
		if self._toadd  then
			self._toadd:SetTarget(ent)
			variable.call('target.on_click_block', self._toadd)
		end
	end)
	variable.set('target.on_click_block', function(ui, nofade)
		local offset = Vector3(155,12,0)
		if nofade then
			_selector:SetPosition(ui:GetPosition()+offset)
		else
			_selector:MoveTo(_selector:GetPosition(), ui:GetPosition()+offset, 0.1)
		end
		self.blocks.current = ui.id
		variable.call('target.set_target', ui.targetent)
	end)
	variable.call('target.on_click_block', self.blocks[1])
	
	local _clearall = self:AddUIat('TextButton', 10, 1, '清空')
	_clearall:SetColour(1,0,0,1)
	_clearall:SetOnClick(function()
		for i = 2, 5 do self.blocks[i]:Clear() end 
	end)

	self.canswitch = true
	local _quickchange = self:AddUIat(UNIT, 11, 1, '快捷切换', {
		enable = {fn = function(v) self.canswitch = v end, default = true},
		hint = '按 [ 和 ] 在列表中切换目标',
	})

	self.SetDefault = function(self)
		_quickchange.enable_bt:SetDefault()
		_free.enable_bt:SetDefault()

		_clearall.onclick()
	end

	self.keyhandler_L = TheInput:AddKeyDownHandler(KEY_LEFTBRACKET, function()self:ListUp()end)
	self.keyhandler_R = TheInput:AddKeyDownHandler(KEY_RIGHTBRACKET, function()self:ListDown()end)
end)

function Target:HideMain()
	self.parent:HideMain()
end

function Target:ListDt(num)
	if not self.canswitch then return end
	num = num or 1
	local dt = num > 0 and 1 or -1
	local steps = num * dt
	local id = self.blocks.current
	while true do
		id = (id + dt - 1) % 5 + 1
		if self.blocks[id].targetent and self.blocks[id].targetent:IsValid() then
			steps = steps - 1
			if steps == 0 then break end
		end
	end
	local ui = self.blocks[id]
	variable.call('target.on_click_block', ui)
end

function Target:ListDown()
	self:ListDt(1)
end

function Target:ListUp()
	self:ListDt(-1)
end

return Target
