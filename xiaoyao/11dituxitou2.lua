local Widget = require "widgets/widget"
local Image = require "widgets/image"


local previousRotation = 0
local lcontrols = nil
local button = nil
local charPointer = nil
local x_res = GLOBAL.RESOLUTION_X
local y_res = GLOBAL.RESOLUTION_Y
local w, h = GLOBAL.TheSim:GetScreenSize()

--Map position is between -1 and 1 with a middle anchor
local function MapPosToScreenPos(x, y)
    return w * (x/2), h * (y/2)
end

local function AddArrow(mapscreen)
    if charPointer ~= nil then charPointer:Kill() end
    local zoom = GLOBAL.TheWorld.minimap.MiniMap:GetZoom()
    w, h = GLOBAL.TheSim:GetScreenSize()
    mapscreen.charPointer = mapscreen:AddChild(Image("images/arrow.xml", "arrow.tex"))
    charPointer = mapscreen.charPointer
    mapscreen.charPointer:SetRotation((TUNING.xiaoyao("判定地图方位") - previousRotation))
    mapscreen.charPointer:SetScale(1.5/zoom, 1.5/zoom, 1)
    mapscreen.charPointer:SetHAnchor(GLOBAL.ANCHOR_MIDDLE)
    mapscreen.charPointer:SetVAnchor(GLOBAL.ANCHOR_MIDDLE)
    mapscreen.charPointer:SetPosition(0, 0)
    mapscreen.charPointer:MoveToFront()
end

local function RotateToZero(controls)
    lcontrols = controls
    local ToggleMap_base = controls.ToggleMap
    controls.ToggleMap = function( self )
        if not controls.owner.HUD:IsMapScreenOpen() then
            previousRotation = GLOBAL.TheCamera:GetHeading()
            ToggleMap_base(self)
            GLOBAL.TheCamera:SetHeadingTarget(TUNING.xiaoyao("判定地图方位"))
            GLOBAL.TheCamera:Snap()
        else
            GLOBAL.TheCamera:SetHeadingTarget(previousRotation)
            GLOBAL.TheCamera:Snap()
            --See map snap instead of character snap
            --controls.inst:DoTaskInTime(0, function() ToggleMap_base(self) end)
            ToggleMap_base(self)
        end
    end
end

AddClassPostConstruct( "widgets/controls", RotateToZero)
if TUNING.xiaoyao("显示地图方位") then
    AddClassPostConstruct( "screens/mapscreen", AddArrow)
end

local MapScreen = require "screens/mapscreen"

MapScreen_OnControl_base = MapScreen.OnControl
MapScreen.OnControl = function( self, control, down )
	if not down and (control == GLOBAL.CONTROL_MAP or control == GLOBAL.CONTROL_CANCEL) then
        GLOBAL.TheCamera:SetHeadingTarget(previousRotation)
        GLOBAL.TheCamera:Snap()
        --See map snap instead of character snap
        --lcontrols.inst:DoTaskInTime(0, function() MapScreen_OnControl_base(self, control, down) end)
        --return true
	end
    
    local ret = MapScreen_OnControl_base(self, control, down)

	return ret
end

--Update character direction arrow
if TUNING.xiaoyao("显示地图方位") then
    MapScreen_OnUpdate_base = MapScreen.OnUpdate
    MapScreen.OnUpdate = function(self, dt)
        MapScreen_OnUpdate_base(self, dt)
        if charPointer ~= nil then
            local ex,ey,ez = GLOBAL.ThePlayer.Transform:GetWorldPosition()
            local x, y, z = self.minimap:WorldPosToMapPos(ex,ez,0)
            local dx, dy = MapPosToScreenPos(x, y)
            local zoom = GLOBAL.TheWorld.minimap.MiniMap:GetZoom()
            charPointer:SetPosition(dx, dy)
            charPointer:SetRotation(GLOBAL.TheCamera:GetHeading() - previousRotation)
            charPointer:SetScale(1.5/zoom, 1.5/zoom, 1)
        end
    end
end