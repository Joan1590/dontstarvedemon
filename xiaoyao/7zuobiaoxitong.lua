
local function AddControl(ui,savename)
	function ui:OnControl(control, down)
		if ui._base.OnControl(ui, control, down) then return true end
		if ui.focus and control == 29 then
			if down then
				local pos = GLOBAL.TheInput:GetScreenPosition()
				local pos1 = ui:GetWorldPosition()
				local pos2 = ui:GetPosition()
				ui.offpos = pos - pos1
				if ui.followhandler == nil then
					ui.followhandler = GLOBAL.TheInput:AddMoveHandler(function(x, y)
						local scr_w, scr_h = GLOBAL.TheSim:GetScreenSize()
						local x,y = math.clamp(x, 32, scr_w - 32), math.clamp(y, 32, scr_h - 32)
						local scale = ui:GetScale()
						local pos4 = ui:GetPosition()
						local pos1 = ui:GetWorldPosition()
						local x1,y1 = (x - pos1.x) * ( 2 - scale.x), (y - pos1.y) * ( 2 - scale.x)
						ui:SetPosition(x1 + pos4.x - ui.offpos.x, y1 + pos4.y - ui.offpos.y)
					end)
				end
			else
				if ui.followhandler ~= nil then
					ui.followhandler:Remove()
					ui.followhandler = nil
					local newpos = ui:GetPosition()
					GLOBAL.TheSim:SetPersistentString(savename,string.format("return Vector3(%f,%f,%f)",newpos:Get()),false)
				end
			end
		end
		return true
	end
    GLOBAL.TheSim:GetPersistentString(savename,function(load_success, str)
        if load_success then
            local fn = GLOBAL.loadstring(str)
            if type(fn) == "function" then
                local pos = fn()
				ui:SetPosition(pos:Get())
            end
        end
    end)
end
local require = GLOBAL.require
local Image = require "widgets/image"
local Text = require "widgets/text"
local function AddCoordinates(controls)
    controls.inst:DoTaskInTime(0, function()
		controls.zuobiao = controls:AddChild(Image("images/frontend.xml","button_long.tex"))
		controls.zuobiao:SetScale(0.7,0.7) --图的大小
		controls.zuobiao:SetPosition(300,300) --图的原始坐标
		controls.zuobiao.text = controls.zuobiao:AddChild(Text(GLOBAL.NEWFONT_OUTLINE, 60)) --字体大小
		controls.zuobiao.text:SetPosition(0, 10) --字的坐标
		controls.zuobiao.text:SetColour(232/255,180/255,23/255,1) --字的颜色
		controls.zuobiao.text:SetString("挺复杂的")

        AddControl(controls.zuobiao,"zuobiao")
        local OnUpdate_base = controls.OnUpdate
        controls.OnUpdate = function(self, dt)
            OnUpdate_base(self, dt)
            local x, z, y = GLOBAL.ThePlayer.Transform:GetWorldPosition()
            local coordinatesString = math.floor(x+0.5) .. "x" .. math.floor(y+0.5)
			controls.zuobiao.text:SetString(coordinatesString)
		end
    end)
end

AddClassPostConstruct("widgets/controls", AddCoordinates)
