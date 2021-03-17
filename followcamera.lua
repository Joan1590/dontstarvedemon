local variable = require 'lw_mod_camera'

--move
variable.set('move.reset', function()
    local vec = TheCamera.targetoffset
    vec.x, vec.z = 0, 0
    TheCamera:SetOffset(vec)
end)

--rotate
local function _normalize(num1, num2)
    return num2*(math.floor(num1/num2+0.5))
end
variable.set('rotate.align45', function()
    local angle = TheCamera.headingtarget
    TheCamera.headingtarget = _normalize(angle, 45)
end)
variable.set('rotate.align90', function()
    local angle = TheCamera.headingtarget
    TheCamera.headingtarget = _normalize(angle, 90)
end)
variable.set('C.GetHeading180', function()
    local angle =  TheCamera.heading
    while angle > 180 do angle = angle - 360 end
    while angle < -180 do angle = angle + 360 end
    return angle
end)

--cutscene
variable.set('CutScene', function(v)
    if v then
        TheCamera.cutscene = true
        variable.set('_cutscene', true)
    else
        TheCamera.cutscene = false
        variable.get('_cutscene', false)
    end
end)


AddClassPostConstruct('cameras/followcamera', function (self)
    --move
    local move_ctrl_main = true
    local move_ctrl_mouse = false
    local move_ctrl_key = false
    local move_ctrl_sensitivity = 1

    local move_auto_dir = 0
    local move_auto_speed = 0
    local move_auto_open = true
    local move_auto_delay = 0

    local fns = {
        --['move.main'] = function(v) move_ctrl_main = v end,
        ['move.ctrl.mouse'] = function(v) move_ctrl_mouse = v end,
        ['move.ctrl.key'] = function(v) move_ctrl_key = v end,
        ['move.ctrl.sensitivity'] = function(v) move_ctrl_sensitivity = v end,
        ['move.auto.dir'] = function(v) move_auto_dir = v end,
        ['move.auto.speed'] = function(v) move_auto_speed = v end,
        ['move.auto.open'] = function() move_auto_open = true end,
        ['move.auto.close'] = function() move_auto_open = false move_auto_delay = -1 end,
        ['move.auto.open3'] = function() move_auto_open = false move_auto_delay = 3 end,
    }
    variable.inject(fns)

    --rotate
    local rotate_ctrl_main = true
    local rotate_ctrl_key = false
    local rotate_ctrl_mouse = false
    local rotate_ctrl_sensitivity = 1

    local rotate_auto_speed = 0
    local rotate_auto_open = true
    local rotate_auto_delay = 0

    local fns = {
        ['rotate.ctrl.key'] = function(v) rotate_ctrl_key = v end,
        ['rotate.ctrl.mouse'] = function(v) rotate_ctrl_mouse = v end,
        ['rotate.ctrl.sensitivity'] = function(v) rotate_ctrl_sensitivity = v end,
        ['rotate.auto.speed'] = function(v) rotate_auto_speed = v end,
        ['rotate.auto.open'] = function() rotate_auto_open = true end,
        ['rotate.auto.close'] = function() rotate_auto_open = false rotate_auto_delay = -1 end,
        ['rotate.auto.open3'] = function() rotate_auto_open = false rotate_auto_delay = 3 end,

    }
    variable.inject(fns)

    
    --height
    local height_auto_speed = 0
    local height_auto_open = true
    local height_auto_delay = 0

    local fns = {
        ['height.auto.speed'] = function(v) height_auto_speed = v end,
        ['height.auto.open'] = function() height_auto_open = true self.time_since_zoom = nil end,
        ['height.auto.close'] = function() height_auto_open = false height_auto_delay = -1 end,
        ['height.auto.open3'] = function() height_auto_open = false height_auto_delay = 3 end,
    }
    variable.inject(fns)

    --pitch
    local pitch_ctrl_main = true
    local pitch_ctrl_key = false
    local pitch_ctrl_mouse = false
    local pitch_ctrl_sensitivity = 1
    local pitch_lock = false
    local pitch_override = nil

    local fns = {
        ['pitch.ctrl.key'] = function(v) pitch_ctrl_key = v end,
        ['pitch.ctrl.mouse'] = function(v) pitch_ctrl_mouse = v end,
        ['pitch.ctrl.sensitivity'] = function(v) pitch_ctrl_sensitivity = v end,
        ['pitch.lock'] = function() pitch_lock = true pitch_override = pitch_override or self.pitch end,
        ['pitch.unlock'] = function() pitch_lock = false pitch_override = nil end,
        ['pitch.triggerlock'] = function() variable.call('pitch.' .. (pitch_lock and 'unlock' or 'lock')) end,
        ['pitch.islocked'] = function() return pitch_lock end,
        ['C.GetTruePitch'] = function() return (pitch_lock and pitch_override or self.pitch) % 360 end,
        ['pitch.setoverride'] = function(v) pitch_override = v end,
    }
    variable.inject(fns)


    self.lw_key_handler = TheInput:AddKeyHandler(function(...)self:Lw_OnKey(...)end)
    self.lw_mouse_handle = TheInput:AddMouseButtonHandler(function(...)self:Lw_OnMouse(...)end)
    self.lw_keys = {}

    local look_for_new_target = false
    variable.set('target.set_look_for_new', function() look_for_new_target = true end)
    variable.set('target.set_target', function(ent) self:SetTarget(ent) end)

    function self:Lw_OnMouse(ms, down)
        if look_for_new_target and ms == MOUSEBUTTON_LEFT then 
            local ent = TheInput:GetWorldEntityUnderMouse()
            if ent then
                self:SetTarget(ent)
                variable.call('target.on_set_new', ent)
                look_for_new_target = false
            end
        end
    end

    function self:Lw_OnKey(key, down)
        if key == KEY_UP then self.lw_keys.up = down end
        if key == KEY_DOWN then self.lw_keys.down = down end
        if key == KEY_RIGHT then self.lw_keys.right = down end
        if key == KEY_LEFT then self.lw_keys.left = down end
        if key == KEY_LEFTBRACKET then self.lw_keys.L = down end
        if key == KEY_RIGHTBRACKET then self.lw_keys.R = down end
        if key == KEY_RSHIFT or key == KEY_LSHIFT or key == KEY_SHIFT then self.lw_keys.shift = down end
    end

    function self:Lw_CtrlCamera(dt)
        if move_ctrl_main and not (rotate_ctrl_main and self.lw_keys.shift) then
            local s = move_ctrl_sensitivity*dt
            if move_ctrl_key then
                local vr = self:GetRightVec()
                local vd = self:GetDownVec()
                local offset = self.targetoffset
                local plus = Vector3(0,0,0)
                for k, v in pairs({up = vd*(-1), down = vd, left = vr*(-1), right = vr})do
                    if self.lw_keys[k] then
                        plus = plus + v
                    end
                end
                plus = plus:Normalize()*s
                self.targetoffset = self.targetoffset + plus
            end
            if move_ctrl_mouse then
                local a = variable.call('GetMouseMovePara')
                if a then
                    local offset = self.targetoffset
                    self.targetoffset = offset + Vector3(s*math.cos(a), 0, s*math.sin(a))
                end
            end
        end

        if rotate_ctrl_main and self.lw_keys.shift then
            local s = rotate_ctrl_sensitivity* dt
            local angle = self.headingtarget
            if rotate_ctrl_key then 
                if self.lw_keys.left then
                    angle = angle - s 
                end
                if self.lw_keys.right then
                    angle = angle + s 
                end
                
            end
            if rotate_ctrl_mouse then
                local r = variable.call('GetMouseRotPara')
                if r == 'L' then 
                    angle = angle - s 
                elseif r == 'R' then
                    angle = angle + s
                end
            end
            self.headingtarget = angle
        end

        if pitch_ctrl_main and self.lw_keys.shift then
            if pitch_override then
                local s = pitch_ctrl_sensitivity*dt
                if pitch_ctrl_key then
                    pitch_override = pitch_override + (self.lw_keys.up and s or 0) - (self.lw_keys.down and s or 0)
                end
                if pitch_ctrl_mouse then
                    local dir = variable.call('GetMouseTiltPara')
                    if dir == 'U' then 
                        pitch_override = pitch_override + s 
                    elseif dir == 'D' then
                        pitch_override = pitch_override - s
                    end
                end
            end
        end
    end

    function self:Lw_AutoCamera(dt)
        if move_auto_open then
            local s = move_auto_speed*dt
            local a = move_auto_dir*DEGREES
            local vec = Vector3(math.cos(a)*s, 0, math.sin(a)*s)
            self.targetoffset = self.targetoffset + vec
        end

        if rotate_auto_open then
            local s = rotate_auto_speed*dt
            self.headingtarget = self.headingtarget + s 
        end

        if height_auto_open then
            local s = height_auto_speed*dt
            self.distancetarget = self.distancetarget + s
        end

        --pitch无自动

    end

    function self:Lw_Update(dt)
        --延迟任务处理
        if move_auto_delay > 0 and not move_auto_open then
            move_auto_delay = move_auto_delay - dt
            if move_auto_delay <= 0 then
                move_auto_open = true
            end
        end
        if rotate_auto_delay > 0 and not rotate_auto_open then
            rotate_auto_delay = rotate_auto_delay - dt
            if rotate_auto_delay <= 0 then
                rotate_auto_open = true
            end
        end
        if height_auto_delay > 0 and not height_auto_open then
            height_auto_delay = height_auto_delay - dt
            if height_auto_delay <= 0 then
                height_auto_open = true
            end
        end
        
        --手动控制
        self:Lw_CtrlCamera(dt)
        --自动控制
        self:Lw_AutoCamera(dt)
    end

    local old_app = self.Apply
    function self:Apply(...)
        if pitch_override and pitch_lock then 
            self.pitch = pitch_override
        end
        old_app(self, ...)
    end

    local old_set = self.CutsceneMode
    function self:CutsceneMode(...)
        if variable.get('_cutscene') then
            self.cutscene = true
            return
        end
        old_set(self, ...)
    end

    local old_up = self.Update
    function self:Update(dt, ...)
        if self.target and not self.target:IsValid() then
            self.target = nil
            local player = variable.call('GetPlayer')
            if player and player:IsValid() then
                self.target = player
                variable.call('target.to_player')
            end
        end
        if variable.get('lockdist') then
            self.should_push_down = false
        end
        old_up(self, dt, ...)
        self:Lw_Update(dt)
        self:Apply()
    end



    --[[

    local old_default = self.SetDefaultOffset
    function self:SetDefaultOffset(...)
        if self.free_camera then return end
        old_default(self, ...)
    end

    local old_default = self.SetDefault 
    function self:SetDefault(...)
        old_default(self, ...)
        if self.force_cutscene then 
            self.cutscene = true
        end
    end
    ]]

end)


if not softresolvefilepath'components/focalpoint.lua' then 
    return
end

AddComponentPostInit('focalpoint', function(self)
    local old_fn = self.Reset 
    function self:Reset(...)
        if variable.get('_cutscene') then return end
        return old_fn(self, ...)
    end

    local old_fn = self.StartFocusSource
    function self:StartFocusSource(...)
        if variable.get('_cutscene') then return end
        return old_fn(self, ...)
    end
end)
