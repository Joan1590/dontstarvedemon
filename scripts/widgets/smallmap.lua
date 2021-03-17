--//－－
--[[
local function modprint(...)
	print("SmallMap", ...)
end
local function callbackObjectTree(obj,lmt,cnt,own)
	if type(obj) ~= "table" then return end
	if own == nil then own = {obj} end
	if cnt == nil then cnt = 0 end
	local cmp
	for k, v in pairs(obj) do
		if type(v) == "table" then
			cmp = false
			for kk, vv in ipairs(own) do
				if v == vv then
					cmp = true
					break
				end
			end
			modprint(string.rep("\t",cnt+1),k,v,cmp)
			table.insert(own, v)
			if not cmp and (lmt == nil or lmt>cnt) then callbackObjectTree(v,lmt,cnt+1,own) end
		else
			modprint(string.rep("\t",cnt+1),k,v)
		end
	end
end
--]]


	local Widget = require "widgets/widget"
	local Image = require "widgets/image"
--	local Text = require "widgets/text"

local SmallMap = Class(Widget, function(self, data, atlaslist)
	Widget._ctor(self, "SmallMap")
	self.owner = ThePlayer

	self.minimap = TheWorld.minimap.MiniMap

	self.data = data or {}
	if type(self.data) ~= "table" then self.data = {} end
	self.memory = {}

	self.lastpos = nil
	self.active = nil
	self.activehold = nil
	self.focusafter = nil

	self.uiatlas = "images/smallmap_ui.xml"

--	//
	local controlGainFocus = function(inst)
		inst._base.OnGainFocus(inst)
		self.active = inst
	--	self.active = self:GetDeepestFocus()
		if inst._textures and inst._textures.image_select and (not self.activehold or self.active == self.activehold) then
			inst:SetTexture( inst._textures.atlas or self.uiatlas, inst._textures.image_select )
			inst:MoveToFront()
			if inst == self.mover and not self.mover_lock:IsVisible() then
				self.mover_lock:MoveToFront()
				self.mover_lock:Show()
			end
			if inst == self.resizer then
				if not self.resizer_lock:IsVisible() then
					self.resizer_lock:MoveToFront()
					self.resizer_lock:Show()
				end
				if not self.resizer_lockratio:IsVisible() then
					self.resizer_lockratio:MoveToFront()
					self.resizer_lockratio:Show()
				end
			end
		end
	end
	local controlLoseFocus = function(inst, rebuild)
		inst._base.OnLoseFocus(inst)
		if self.active == inst then
			self.active = nil
		end
		if inst._textures then
			if inst._textures.image_select or rebuild then
				inst:SetTexture( inst._textures.atlas or self.uiatlas, inst._textures.image )
			end
			if rebuild then
				inst._size = Vector3(inst:GetSize())
			end
		end
		if self.mover_lock and not self.mover_lock.focus and not self.mover.focus then
			if self.mover_lock:IsVisible() then self.mover_lock:Hide() end
		end
		if self.resizer_lock and self.resizer_lockratio and not self.resizer_lock.focus and not self.resizer_lockratio.focus and not self.resizer.focus then
			if self.resizer_lock:IsVisible() then self.resizer_lock:Hide() end
			if self.resizer_lockratio:IsVisible() then self.resizer_lockratio:Hide() end
		end
	end

--	//
	self:SetHAnchor(ANCHOR_MIDDLE)
	self:SetVAnchor(ANCHOR_TOP)
	self:SetScaleMode(SCALEMODE_PROPORTIONAL)

	self.root = self:AddChild(Widget("SmallMap root"))

	self.bg = self.root:AddChild(Image( "images/smallmap_ui.xml", "smallmap_bg" ))
	self.bg.inst.ImageWidget:SetBlendMode( self.data.blendmode_bg or BLENDMODE.AlphaBlended )-- , Additive, Premultiplied, InverseAlpha, AlphaAdditive,
--	self.bg:Hide()

	self.img = self.root:AddChild(Image())
	self.img.inst.ImageWidget:SetBlendMode( self.data.blendmode or BLENDMODE.Additive )
	self:UpdateTexture()
	self.img.OnGainFocus = controlGainFocus
	self.img.OnLoseFocus = controlLoseFocus

	self.data.mapscale = self.data.mapscale or 0.2
	self.memory.mapscale = nil

	self.bg._fixinsidefn = function()
		local scx,scy = TheSim:GetScreenSize()
		local scale = self:GetScale()
		if self.data.size_w > scx/scale.x then self.data.size_w = scx/scale.x end
		if self.data.size_h > scy/scale.y then self.data.size_h = scy/scale.y end
		if self.data.pos_x < -scx/2/scale.x + self.data.size_w/2 then
			self.data.pos_x = -scx/2/scale.x + self.data.size_w/2
		elseif self.data.pos_x > scx/2/scale.x - self.data.size_w/2 then
			self.data.pos_x = scx/2/scale.x - self.data.size_w/2
		end
		if self.data.pos_y > -self.data.size_h/2 then
			self.data.pos_y = -self.data.size_h/2
		elseif self.data.pos_y < -scy/scale.y + self.data.size_h/2 then
			self.data.pos_y = -scy/scale.y + self.data.size_h/2
		end
		--//
		self.bg:SetSize( self.data.size_w, self.data.size_h )
	--	self.img:SetScale( self.data.mapscale )
	--	self.img:ScaleToSize( self.data.size_w, self.data.size_h )
		self.img:SetSize( self.data.size_w, self.data.size_h )
		self.root:SetPosition( self.data.pos_x, self.data.pos_y )
		self.memory.mapscale = nil
	end

	if self.data.size_w and self.data.size_h then
		self.data.size_w = self.data.size_w
		self.data.size_h = self.data.size_h
	else
		local w,h = self.img:GetSize()
		self.data.size_w = w*self.data.mapscale
		self.data.size_h = h*self.data.mapscale
	end
	self.data.pos_x = self.data.pos_x or 0
	self.data.pos_y = self.data.pos_y or -self.data.size_h/2
	self.bg._fixinsidefn()

	self.controls = self.root:AddChild(Widget("SmallMap controls"))
--	self.controls:Hide()
--	self.controls:MoveToFront()

	self.changer_pointer = nil--// scope

	self.middler = self.controls:AddChild(Image())
	self.middler._textures = { image = "middler.tex", image_select = "middler_select.tex" }
	self.middler.OnGainFocus = controlGainFocus
	self.middler.OnLoseFocus = controlLoseFocus
	self.middler._controlfn = function(inst, cursor)
		self.activehold = self.middler
		self.minimap:ResetOffset()
	end

	self.slider = self.controls:AddChild(Image())
	self.slider._textures = { image = "slider.tex" }
	self.slider.OnGainFocus = controlGainFocus
	self.slider.OnLoseFocus = controlLoseFocus
	self.slider._controlfn = function(inst, cursor)
		local scale = self:GetScale()
		local pos = self.slider:GetWorldPosition()
		local w,h = self.slider:GetSize()
		local dy = (cursor.y - pos.y) / scale.y
		if dy < 0 then
			dy = 1 + dy / h*2/0.95
		else
			dy = 19 * dy / h*2/0.95 + 1
		end
		self:SetZoom(dy)
	--	local pos2 = self.slider:GetPosition()
	end
	self.handle = self.slider:AddChild(Image( "images/smallmap_ui.xml", "handle.tex" ))

	self.alpha = self.controls:AddChild(Image())
	self.alpha._textures = { image = "alpha.tex" }
	self.alpha.OnGainFocus = controlGainFocus
	self.alpha.OnLoseFocus = controlLoseFocus
	self.alpha._controlfn = function(inst, cursor)
		local scale = self:GetScale()
		local pos = self.alpha:GetWorldPosition()
		local w,h = self.alpha:GetSize()
		local dy = 0.5 - (cursor.y - pos.y)/h / scale.x
		if dy < 0 then dy = 0 end
		if dy > 1 then dy = 1 end
		self.data.bgalpha = dy
		self.bg:SetTint(1,1,1, self.data.bgalpha)
	end

	self.data.bgalpha = self.data.bgalpha or 0.5

	self.mover = self.controls:AddChild(Image())
	self.mover._textures = { image = "mover.tex", image_normal = "mover.tex", image_select = "mover_select.tex", image_lock = "mover_lock.tex" }
	self.mover.OnGainFocus = controlGainFocus
	self.mover.OnLoseFocus = controlLoseFocus
	self.mover._controlfn = function(inst, cursor)
		if self.lastpos and not self.data.lock_move then
			local scale = self:GetScale()
			local pos = self.root:GetPosition()
			self.data.pos_x = (cursor.x - self.lastpos.x) / scale.x + pos.x
			self.data.pos_y = (cursor.y - self.lastpos.y) / scale.y + pos.y
			self.root:SetPosition( self.data.pos_x, self.data.pos_y )
		--	modprint(self.data.pos_x+RESOLUTION_X/2,-self.data.pos_y)
		end
	end
--	self.mover_overlay = self.mover:AddChild(Image( "images/smallmap_ui.xml", "mover_lock.tex" ))
--	self.mover_overlay:Hide()
	self.mover_lock = self.controls:AddChild(Image())
	self.mover_lock._textures = { image = "lock.tex", image_lock = "lock.tex", image_unlock = "unlock.tex", image_select = "lock_select.tex", image_lock_select = "lock_select.tex", image_unlock_select = "unlock_select.tex" }
	self.mover_lock.OnGainFocus = controlGainFocus
	self.mover_lock.OnLoseFocus = controlLoseFocus
	self.mover_lock._chgtexfn = function()
		if self.data.lock_move then
			self.mover._textures.image = self.mover._textures.image_lock
			self.mover_lock._textures.image = self.mover_lock._textures.image_lock
			self.mover_lock._textures.image_select = self.mover_lock._textures.image_lock_select
		else
			self.mover._textures.image = self.mover._textures.image_normal
			self.mover_lock._textures.image = self.mover_lock._textures.image_unlock
			self.mover_lock._textures.image_select = self.mover_lock._textures.image_unlock_select
		end
		self.mover:SetTexture( self.mover._textures.atlas or self.uiatlas, self.mover._textures.image )
		self.mover_lock:SetTexture( self.mover_lock._textures.atlas or self.uiatlas, self.mover_lock._textures.image_select )
	end
	self.mover_lock._controlfn = function(inst, cursor)
		if not self.lastpos then
			self.data.lock_move = self.data.lock_move ~= true
			self.mover_lock._chgtexfn()
		end
	end
	self.data.lock_move = self.data.lock_move or false
	self.mover_lock._chgtexfn()
	self.mover_lock:Hide()

	self.resizer = self.controls:AddChild(Image())
	self.resizer._textures = { image = "resizer.tex", image_select = "resizer_select.tex", image_lock = "resizer_lock.tex", image_lockratio = "resizer_lock_ratio.tex" }
	self.resizer.OnGainFocus = controlGainFocus
	self.resizer.OnLoseFocus = controlLoseFocus
	self.resizer._controlfn = function(inst, cursor)
		if not self.data.lock_resize then
			local scale = self:GetScale()
			local scx,scy = TheSim:GetScreenSize()
			local w,h = self.bg:GetSize()
			local pos = self.root:GetWorldPosition()
			local dx,dy
			if self.lastpos then
				dx = self.lastpos.x
				dy = self.lastpos.y
			else
				dx = (cursor.x - pos.x) / scale.x
				dy = (cursor.y - pos.y) / scale.y
				if dx >= 0 then dx = self.data.size_w/2 - dx else dx = -self.data.size_w/2 - dx end
				if dy >= 0 then dy = self.data.size_h/2 - dy else dy = -self.data.size_h/2 - dy end
			end
			local sx = math.abs( ((cursor.x - pos.x) / scale.x + dx) * 2 )
			local sy = math.abs( ((cursor.y - pos.y) / scale.y + dy) * 2 )
			if sx < self.slider._size.x+self.changer_pointer._size.x+math.max(self.mover._size.x,self.resizer._size.x) then sx = self.slider._size.x+self.alpha._size.x+math.max(self.mover._size.x,self.resizer._size.x) end
			if sy < self.mover._size.y+self.resizer._size.y+math.max(20,self.alpha._size.y*0.4) then sy = self.mover._size.y+self.resizer._size.y+math.max(20,self.alpha._size.y*0.4) end
			self.data.size_w = self.data.lock_ratio and math.max(sx, sy*16/9) or sx
			self.data.size_h = self.data.lock_ratio and math.max(sy, sx*9/16) or sy
			self.bg:SetSize( self.data.size_w, self.data.size_h )
			self.img:SetSize( self.data.size_w, self.data.size_h )
			self.data.mapscale = math.max(sx/scx, sy/scy)
		--	modprint("self.data.mapscale",self.data.mapscale, scale, sx/scx,sy/scy, sx,sy, scx,scy)
			self.memory.mapscale = nil
			self:SetZoom()
			cursor.x = dx
			cursor.y = dy
			cursor.z = 0
		end
	end
	self.resizer_overlay = self.resizer:AddChild(Image())
	self.resizer_overlay._chgtexfn = function()
		if self.data.lock_resize then
			self.resizer_overlay:Show()
			self.resizer_overlay:SetTexture( self.resizer._textures.atlas or self.uiatlas, self.resizer._textures.image_lock )
		elseif self.data.lock_ratio then
			self.resizer_overlay:Show()
			self.resizer_overlay:SetTexture( self.resizer._textures.atlas or self.uiatlas, self.resizer._textures.image_lockratio )
		else
			self.resizer_overlay:Hide()
		end
	end
	self.resizer_lock = self.controls:AddChild(Image())
	self.resizer_lock._textures = { image = "lock.tex", image_lock = "lock.tex", image_unlock = "unlock.tex", image_select = "lock_select.tex", image_lock_select = "lock_select.tex", image_unlock_select = "unlock_select.tex" }
	self.resizer_lock.OnGainFocus = controlGainFocus
	self.resizer_lock.OnLoseFocus = controlLoseFocus
	self.resizer_lock._chgtexfn = function()
		if self.data.lock_resize then
			self.resizer_lock._textures.image = self.resizer_lock._textures.image_lock
			self.resizer_lock._textures.image_select = self.resizer_lock._textures.image_lock_select
		else
			self.resizer_lock._textures.image = self.resizer_lock._textures.image_unlock
			self.resizer_lock._textures.image_select = self.resizer_lock._textures.image_unlock_select
		end
		self.resizer_lock:SetTexture( self.resizer_lock._textures.atlas or self.uiatlas, self.resizer_lock._textures.image_select )
	end
	self.resizer_lock._controlfn = function(inst, cursor)
		if not self.lastpos then
			self.data.lock_resize = self.data.lock_resize ~= true
			self.resizer_lock._chgtexfn()
			self.resizer_overlay._chgtexfn()
		end
	end
	self.resizer_lockratio = self.controls:AddChild(Image())
	self.resizer_lockratio._textures = { image = "lock.tex", image_lock = "lock.tex", image_unlock = "unlock.tex", image_select = "lock_select.tex", image_lock_select = "lock_select.tex", image_unlock_select = "unlock_select.tex" }
	self.resizer_lockratio.OnGainFocus = controlGainFocus
	self.resizer_lockratio.OnLoseFocus = controlLoseFocus
	self.resizer_lockratio._chgtexfn = function()
		if self.data.lock_ratio then
			self.resizer_lockratio._textures.image = self.resizer_lockratio._textures.image_lock
			self.resizer_lockratio._textures.image_select = self.resizer_lockratio._textures.image_lock_select
		else
			self.resizer_lockratio._textures.image = self.resizer_lockratio._textures.image_unlock
			self.resizer_lockratio._textures.image_select = self.resizer_lockratio._textures.image_unlock_select
		end
		self.resizer_lockratio:SetTexture( self.resizer_lockratio._textures.atlas or self.uiatlas, self.resizer_lockratio._textures.image_select )
	end
	self.resizer_lockratio._controlfn = function(inst, cursor)
		if not self.lastpos then
			self.data.lock_ratio = self.data.lock_ratio ~= true
			self.resizer_lockratio._chgtexfn()
			self.resizer_overlay._chgtexfn()
		end
	end
	self.data.lock_resize = self.data.lock_resize or false
	self.data.lock_ratio = self.data.lock_ratio or false
	self.resizer_overlay._chgtexfn()
	self.resizer_lock._chgtexfn()
	self.resizer_lockratio._chgtexfn()
	self.resizer_lock:Hide()
	self.resizer_lockratio:Hide()

	self.data.zoomlevel = self.data.zoomlevel or 0.5
	self.memory.zoom = nil

	self.minimizer = self.root:AddChild(Image())
	self.minimizer._textures = { image = "minimizer.tex", image_select = "minimizer_select.tex" }
	self.minimizer.OnGainFocus = controlGainFocus
	self.minimizer.OnLoseFocus = controlLoseFocus
	self.minimizer._rotatefn = function(mode, mode_before)
		if mode ~= mode_before then
			if mode == FACING_UP then
				self.minimizer:SetRotation(0)
			elseif mode == FACING_DOWN then
				self.minimizer:SetRotation(180)
			elseif mode == FACING_RIGHT then
				self.minimizer:SetRotation(90)
			elseif mode == FACING_LEFT then
				self.minimizer:SetRotation(270)
			else
				self.minimizer:SetRotation(0)
			end
			self.memory.mapscale = nil
		end
	end
	self.minimizer._controlfn = function(inst, cursor)
		if not self.lastpos then
			if self.img:IsVisible() then
				self.img:Hide()
			--	self.bg:SetSize( 0,0 )
				self.bg:Hide()
				self.controls:Hide()
				if self.minimap:IsVisible() then
					self.minimap:ToggleVisibility()
				end
			else
				self.img:Show()
				self.bg:Show()
				self.controls:Show()
			end
			self.memory.mapscale = nil
		else
			local scale = self:GetScale()
			local pos = self.root:GetWorldPosition()
			local w,h = self.bg:GetSize()
			local dx = (cursor.x - pos.x) / scale.x
			local dy = (cursor.y - pos.y) / scale.y
			local radper = math.atan2(dy, dx) / math.pi
			local div = math.atan2(h,w) / math.pi
			local mode = self.data.minimizer_mode
			if math.abs(dx) > w/2 + 30 or math.abs(dy) > h/2 + 30 then
				if     radper >= 1-div then -- left
					self.data.minimizer_mode = FACING_RIGHT--0
				elseif radper >= div then -- up
					self.data.minimizer_mode = FACING_DOWN--3
				elseif radper >= -div then -- right
					self.data.minimizer_mode = FACING_LEFT--2
				elseif radper >= -1+div then -- down
					self.data.minimizer_mode = FACING_UP--1
				else -- left
					self.data.minimizer_mode = FACING_RIGHT--0
				end
			end
			self.minimizer._rotatefn(self.data.minimizer_mode, mode)
		end
	end
	self.data.minimizer_mode = self.data.minimizer_mode or FACING_UP
	self.minimizer._rotatefn(self.data.minimizer_mode, FACING_UP)

	self.changer = self.controls:AddChild(Widget("SmallMap changer"))
--	self.changer:Hide()

	local chgtype_list = {
		{ atlas = "images/hud.xml",         image = "map.tex",        icon = "bgtype_default.tex", icon_atlas = "images/smallmap_ui.xml" },
		{ atlas = "images/smallmap_ui.xml", image = "smallmap_bg",    icon = "bgtype_bg.tex" },
		{ atlas = "images/smallmap_ui.xml", image = "smallmap_frame", icon = "bgtype_frame.tex" },
		{ atlas = "images/smallmap_ui.xml", icon = "uitype_default.tex", ui = true },
	}
	local chgtype_idx = {}
	if type(atlaslist) == "table" then
		for k,v in ipairs(atlaslist) do
			if string.find(v,"^UI|") then
				local atlas = string.gsub(v, "^UI|","")
				table.insert(chgtype_list, { atlas = atlas, icon = "icon", ui = true })
				chgtype_idx[atlas] = #chgtype_list
			else
				table.insert(chgtype_list, { atlas = v, image = "bgimage", icon = "icon" })
				chgtype_idx[v] = #chgtype_list
			end
		end
	end

	self.chgtype_icons = {}
	for k,v in ipairs(chgtype_list) do
		local widget = self.changer:AddChild(Image( v.icon_atlas and v.icon_atlas or v.atlas, v.icon ))
		table.insert( self.chgtype_icons, widget )
		widget._index = k
		widget.OnGainFocus = controlGainFocus
		widget.OnLoseFocus = controlLoseFocus
		if v.ui then
			widget._overlay = widget:AddChild(Image( "images/smallmap_ui.xml", "uitype.tex" ))
			widget._overlay.inst:AddTag("NOCLICK")
		end
	end

	self.changer_pointer = self.controls:AddChild(Image())
	self.changer_pointer._textures = { image = "pointer.tex", image_select = "pointer_select.tex" }
	self.changer_pointer.OnGainFocus = controlGainFocus
	self.changer_pointer.OnLoseFocus = controlLoseFocus
	self.changer_pointer:OnLoseFocus(true)
	self.changer_pointer._chgtexfn = function(chgtype, before, uitype)
		local idx = chgtype_idx[chgtype] or chgtype
		if chgtype ~= before and idx then
		--	modprint("self.changer_pointer._chgtexfn", chgtype, before, uitype, chgtype_idx[chgtype])
			if uitype or chgtype_list[idx].ui then
				self.uiatlas = chgtype_list[idx].atlas
				self.middler:OnLoseFocus(true)
				self.alpha:OnLoseFocus(true)
				self.mover:OnLoseFocus(true)
				self.mover_lock:OnLoseFocus(true)
				self.resizer:OnLoseFocus(true)
				self.resizer_lock:OnLoseFocus(true)
				self.resizer_lockratio:OnLoseFocus(true)
				self.slider:OnLoseFocus(true)
				self.handle:SetTexture( chgtype_list[idx].atlas, "handle.tex" )
				self.minimizer:OnLoseFocus(true)
				self.changer_pointer:OnLoseFocus(true)
				self.changer._rebuild = true
				self.memory.mapscale = nil
			else
				self.bg:SetTexture( chgtype_list[idx].atlas, chgtype_list[idx].image )
				self.bg:SetSize( self.data.size_w, self.data.size_h )
			end
		end
	end
	self.changer_pointer._controlfn = function(inst, cursor)
		if not self.lastpos then
			self.changer:MoveToFront()
			self.changer:Show()
		end
		if self.active and self.active._index and self.active == self.chgtype_icons[self.active._index] and chgtype_list[self.active._index] then
		--	local idx = chgtype_idx[chgtype_list[self.active._index].atlas] and chgtype_list[self.active._index].atlas or self.active._index
			if chgtype_list[self.active._index].ui then
				local uitype = self.data.uitype
				self.data.uitype = chgtype_idx[chgtype_list[self.active._index].atlas] and chgtype_list[self.active._index].atlas or self.active._index
				self.changer_pointer._chgtexfn(self.data.uitype, 0, true)
			else
				local bgtype = self.data.bgtype
				self.data.bgtype = chgtype_idx[chgtype_list[self.active._index].atlas] and chgtype_list[self.active._index].atlas or self.active._index
				self.changer_pointer._chgtexfn(self.data.bgtype, bgtype)
			end
		end
	end
--	modprint("uitype", self.data.uitype, chgtype_idx[self.data.uitype], chgtype_list[self.data.bgtype])
	self.data.uitype = chgtype_idx[self.data.uitype] and chgtype_list[chgtype_idx[self.data.uitype]].ui and self.data.uitype or chgtype_list[self.data.bgtype] and chgtype_list[self.data.bgtype].ui and self.data.uitype or 4
	self.data.bgtype = chgtype_idx[self.data.bgtype] and not chgtype_list[chgtype_idx[self.data.bgtype]].ui and self.data.bgtype or chgtype_list[self.data.bgtype] and not chgtype_list[self.data.bgtype].ui and self.data.bgtype or 1
	self.changer_pointer._chgtexfn(self.data.bgtype)
	self.changer_pointer._chgtexfn(self.data.uitype)

	self.changer._rebuildfn = function()
		for k,widget in ipairs(self.chgtype_icons) do
			local x,y, r,s
			r = math.floor( k / math.sqrt(k) )
			s = k - r*r
			if r < s then x = r*2 - s else x = r end
			if r > s then y = s else y = r end
			widget:SetPosition( 0-self.changer_pointer._size.x*x, 0-self.changer_pointer._size.y*y )
			widget:SetSize( self.changer_pointer._size.x, self.changer_pointer._size.y )
			if widget._overlay then
				widget._overlay:SetTexture(self.uiatlas, "uitype.tex")
				widget._overlay:SetSize( self.changer_pointer._size.x, self.changer_pointer._size.y )
			end
		end
		self.changer._rebuild = nil
	end

	--//
	self:GetMapControl()
--	self:SetZoom(self.data.zoomlevel)
	self:OnLoseFocus()
--	self.minimap:ResetOffset()
--	self:StartUpdating()
--	self:OnUpdate()

end)

function SmallMap:GetConfigData()
	return self.data
end

function SmallMap:SetTextureHandle(handle)
	self.img.inst.ImageWidget:SetTextureHandle( handle )
end
function SmallMap:UpdateTexture()
	local handle = self.minimap:GetTextureHandle()
	self:SetTextureHandle( handle )
end

function SmallMap:GetMapControl()
	if not self.minimap:IsVisible() then-- lost control
		self.minimap:ToggleVisibility()-- recover control
	--	self:UpdateTexture()
		self.minimap:ResetOffset()
		self:SetZoom(self.data.zoomlevel)
		self.bg._fixinsidefn()
	--	self.memory.mapscale = nil
	end
end

function SmallMap:OnGainFocus()
	if self.focusafter then
		self.focusafter = false
	end
	if self.lastpos then
		return
	end
	if self.img:IsVisible() then
		self.controls:Show()
	end
	self.minimizer:Show()
	if self.changer:IsVisible() then
		if self.changer._rebuild then
			self.changer._rebuildfn()
		end
		self.changer:Hide()
	end
	if self.mover_lock:IsVisible() and self.active ~= self.mover_lock then
		self.mover_lock:Hide()
	end
	if (self.resizer_lock:IsVisible() or self.resizer_lockratio:IsVisible()) and self.active ~= self.resizer_lock and self.active ~= self.resizer_lockratio then
		self.resizer_lock:Hide()
		self.resizer_lockratio:Hide()
	end
	self.bg:SetTint(1,1,1, 1)
	self:StartUpdating()
--	--//
end
function SmallMap:OnLoseFocus()
	if self.lastpos then
		self.focusafter = true
		return
	end
	if self.changer:IsVisible() then
		if self.changer._rebuild then
			self.changer._rebuildfn()
		end
		self.changer:Hide()
	end
	if self.mover_lock:IsVisible() then
		self.mover_lock:Hide()
	end
	if self.resizer_lock:IsVisible() then
		self.resizer_lock:Hide()
	end
	if self.resizer_lockratio:IsVisible() then
		self.resizer_lockratio:Hide()
	end
	self.controls:Hide()
	if self.img:IsVisible() then
		self.minimizer:Hide()
	end
	self.bg:SetTint(1,1,1, self.data.bgalpha)
	self.active = nil
	self:StopUpdating()
--	--//
	self.owner:PushEvent("smallmap_save_config")
end

function SmallMap:SetZoom(zoom)
	if zoom then
		if zoom < 0 then
			self.data.zoomlevel = 0
		elseif zoom < 1 then
			self.data.zoomlevel = zoom
		elseif zoom < 20 then
			self.data.zoomlevel = math.floor(zoom)
		else
			self.data.zoomlevel = 20
		end
	end

	local zoomget = self.minimap:GetZoom()
	local zoomset,zoomscale = math.modf(self.data.zoomlevel)
	local zoomcalc = math.floor(self.data.zoomlevel-zoomget)
	self.minimap:Zoom( zoomcalc )
	local uvscale = zoomset > 0 and 1 or 1-(1-zoomscale)*0.9 -- 1.0~1.9

	local scrx,scry = TheSim:GetScreenSize()
	local sx = math.max(self.data.size_w, self.data.size_h*scrx/scry)
	local sy = math.max(self.data.size_h, self.data.size_w*scry/scrx)
	local scx = 2 - self.data.size_w/sy * scry/scrx * uvscale
	local scy = 2 - self.data.size_h/sx * scrx/scry * uvscale
	self.img:SetUVScale( scx, scy )

	self.memory.zoom = nil--// handle redraw

end

function SmallMap:OnControl(control, down)
	if self._base.OnControl(self, control, down) then return true end
	if not self:IsEnabled() or not self.focus then return false end

	if down then
		if control == CONTROL_ACCEPT then
			if self.active and not self.activehold then
				self.activehold = self.active
				return true
			end
		end
	end

end

function SmallMap:OnUpdate(dt)
--	modprint("OnUpdate", self:IsVisible(), self.minimap:IsVisible())
	if not self:IsVisible() then return end
	self:GetMapControl()
	if not self.lastpos then
		if not self.focusafter and not self.focus then return end
	end

	if TheInput:IsControlPressed(CONTROL_PRIMARY) then
		local cursor = TheInput:GetScreenPosition()
		if self.activehold and self.activehold._controlfn then
			self.activehold:_controlfn(cursor)
		elseif self.activehold then
			if self.lastpos and self.img:IsVisible() then
				local scale = self:GetScale()
				local zoom = self.data.zoomlevel < 1 and (0.2*self.data.zoomlevel+2/90) or 2/9
				local dx = zoom / self.data.mapscale * ( cursor.x - self.lastpos.x ) / scale.x
				local dy = zoom / self.data.mapscale * ( cursor.y - self.lastpos.y ) / scale.y
				self.minimap:Offset( dx, dy )
			else
				self.controls:Hide()
			end
		end
		self.lastpos = cursor
	elseif TheInput:IsMouseDown(MOUSEBUTTON_MIDDLE) and self.img:IsVisible() then
		local cursor = TheInput:GetScreenPosition()
		if self.activehold then
		elseif not self.data.lock_move then
			self.activehold = self.mover
		elseif not self.data.lock_resize then
			self.activehold = self.resizer
		else
			self.activehold = nil
		end
		if self.activehold and self.activehold._controlfn then
			self.activehold:_controlfn(cursor)
		end
		self.lastpos = cursor
	else
		if self.lastpos then
			self.activehold = nil
			self.lastpos = nil
			if self.focusafter then
				self.focusafter = nil
				self:OnLoseFocus()
			else
				self:OnGainFocus()
			end
		end
	end

	if self.memory.mapscale ~= self.data.mapscale then
		self.memory.mapscale = self.data.mapscale
		local w,h = self.bg:GetSize()
		--//
		self.middler:SetPosition( 0, h/2 - self.middler._size.y*0.5 )
		self.alpha:SetPosition( w/2 - self.alpha._size.x*0.5, -h/2 + self.mover._size.y+self.resizer._size.y + math.min(self.alpha._size.y, h-self.mover._size.y-self.resizer._size.y)/2 )
		self.alpha:SetSize( self.alpha._size.x, math.min(self.alpha._size.y, h-self.mover._size.y-self.resizer._size.y) )
		self.mover:SetPosition( w/2 - self.mover._size.x*0.5, -h/2 + self.mover._size.y*0.5+self.resizer._size.y )
		self.mover_lock:SetPosition( w/2 - self.mover._size.x-self.mover_lock._size.x*0.5, -h/2 + self.mover._size.y*0.5+self.resizer._size.y )
		self.resizer:SetPosition( w/2 - self.resizer._size.x*0.5, -h/2 + self.resizer._size.y*0.5 )
		self.resizer_lock:SetPosition( w/2 - self.mover._size.x-self.resizer_lock._size.x*0.5-self.resizer_lockratio._size.x, -h/2 + self.resizer._size.y*0.5 )
		self.resizer_lockratio:SetPosition( w/2 - self.mover._size.x-self.resizer_lockratio._size.x*0.5, -h/2 + self.resizer._size.y*0.5 )
		self.slider:SetPosition( -w/2 + self.slider._size.x*0.5, 0 )
		self.slider:SetSize( self.slider._size.x, h )
		--//
		local x = w/2 - self.changer_pointer._size.x*0.5
		local y = h/2 - self.changer_pointer._size.y*0.5
		if h < self.changer_pointer._size.y+self.alpha._size.y+self.mover._size.y+self.resizer._size.y then
			x = x - math.max(self.changer_pointer._size.y,self.alpha._size.y,self.mover._size.y,self.resizer._size.y)
		end
		self.changer:SetPosition( x, y )
		self.changer_pointer:SetPosition( x, y )
		--//
		if self.data.minimizer_mode == FACING_UP then
			self.minimizer:SetPosition( 0, self.img:IsVisible() and -h/2 - self.minimizer._size.y*0.45 or h/2 - self.minimizer._size.y*0.5 )
		elseif self.data.minimizer_mode == FACING_DOWN then
			self.minimizer:SetPosition( 0, self.img:IsVisible() and h/2 + self.minimizer._size.y*0.45 or -h/2 + self.minimizer._size.y*0.5 )
		elseif self.data.minimizer_mode == FACING_RIGHT then
			self.minimizer:SetPosition( self.img:IsVisible() and -w/2 - self.minimizer._size.y*0.45 or w/2 - self.minimizer._size.y*0.5, 0 )
		elseif self.data.minimizer_mode == FACING_LEFT then
			self.minimizer:SetPosition( self.img:IsVisible() and w/2 + self.minimizer._size.y*0.45 or -w/2 + self.minimizer._size.y*0.5, 0 )
		else-- unuse
			self.minimizer:SetPosition( 0, self.img:IsVisible() and -h/2 - self.minimizer._size.y*0.45 or 0 )
		end
		--//
		self.memory.zoom = nil--// handle redraw
	end
	if self.minimap:GetZoom() ~= self.memory.zoom then
		self.memory.zoom = self.minimap:GetZoom()
		local w,h = self.slider:GetSize()
		self.handle:SetPosition( 0, h/2*0.95*(self.data.zoomlevel-1) / (self.data.zoomlevel < 1 and 1 or 19) )
	end

end


return SmallMap