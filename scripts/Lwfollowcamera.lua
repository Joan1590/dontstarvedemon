local function Reset()
	TheCamera.free_camera = false
	TheCamera:SetDefaultOffset()
    TheCamera.headingtarget = math.floor(TheCamera.headingtarget/45)*45
    TheCamera.free_camera = true
end

local function FreeCamera(val)
    TheCamera.free_camera = val
    TheCamera.pitch_override = TheCamera.pitch
end

local function CutScene(val)
	TheCamera.cutscene = val
	TheCamera.force_cutscene = val
end

local function SetDistOver(num)
	TheCamera.distance_override = num
end

local function SetPitchOver(num)
	TheCamera.pitch_override = num
	if TheCamera.free_camera then
		TheCamera.pitch = num
		FreeCamera(true)
	end
end

local function SetMovingScale(num)
	TheCamera.moving_scale = num
end

local function SetRotScale(num)
	TheCamera.rot_scale = num
end

local function SetPitchScale(num)
	TheCamera.pitch_scale = num
end

local function SetAutoMoveDir(num)
	TheCamera.automove_dir = num
end

local function SetAutoMoveSpeed(num)
	TheCamera.automove_speed = num
end

local function EnableAutoMove(val)
	TheCamera.automove = val
end

local function DelayEnableAutoMove(delay)
	TheCamera.automove = true
	TheCamera.automove_delay = delay or 3
end

local _focuslist = {ThePlayer,}
local _index = 1
local _clean = function()
    for i, v in ipairs(_focuslist) do
        if not (type(v) == 'table' and v.IsValid and v.Transform and v:IsValid()) then
            table.remove(v, i)
            if i < _index then _index = i - 1
            elseif i == _index then _index = i - 1
            end
        end
    end
end

local function Focus(target)
	_clean()
	if target ~= nil and target ~= TheCamera.target then  --加载一个新目标
		for i = _index + 1, #_focuslist do --清空后面的目标
			_focuslist[i] = nil
		end	
		table.insert(_focuslist, target)
		_index = _index + 1
		TheCamera:SetTarget(target)
	end
end

local function FocusPrevious()
	_clean()
	_index = _index == 1 and #_focuslist or _index - 1
	
	TheCamera:SetTarget(_focuslist[_index])
end

local function FocusLatter()
	_clean()
	_index = _index == #_focuslist and 1 or _index + 1 

	TheCamera:SetTarget(_focuslist[_index])
end

local function NewFocus()
	TheCamera.try_newfocus = true
	if ThePlayer and ThePlayer.HUD then
		ThePlayer.HUD.controls.LwCameraUI:Hide()
	end
end

return {
	Reset = Reset,
	FreeCamera = FreeCamera,
	CutScene = CutScene,
	SetDistOver = SetDistOver,
	SetPitchOver = SetPitchOver,
	SetMovingScale = SetMovingScale,
	SetRotScale = SetRotScale,
	SetPitchScale = SetPitchScale,
	SetAutoMoveDir = SetAutoMoveDir,
	SetAutoMoveSpeed = SetAutoMoveSpeed,
	EnableAutoMove = EnableAutoMove,
	DelayEnableAutoMove = DelayEnableAutoMove,

	Focus = Focus,
	FocusPrevious = FocusPrevious,
	FocusLatter = FocusLatter,
	NewFocus = NewFocus,
}
