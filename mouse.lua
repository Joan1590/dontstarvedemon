local variable = require 'lw_mod_camera'
local function GetScreenSize()
	return TheSim:GetScreenSize()
end

local function GetMouseXY()
	return TheInput:GetScreenPosition():Get()
end

local function GetMouseOffset() --获取鼠标相对于屏幕中央的位置
	local sx, sy = GetScreenSize()
	local mx, my = GetMouseXY()
	return mx - sx/2, my - sy/2
end

local function GetMouseMovePara() --获取鼠标当前位置对平移控制的影响, 返回方向(弧度制)
	local w, h = GetScreenSize()
	local mx, my = GetMouseXY()
	local d = 5 --鼠标距离边缘的像素数
	if mx < d or my < d or mx > w - d or my > h - d then 
		local targpos = Vector3(TheSim:ProjectScreenPos(mx, my))
		local curpos = Vector3(TheSim:ProjectScreenPos(w/2, h/2))
		local vec = targpos - curpos
		--print(targpos, curpos, vec)
		local angle = math.atan2(vec.z, vec.x)
		return angle
	end
end

local function GetMouseRotPara() --获取鼠标对旋转的影响
	local w, h = GetScreenSize()
	local mx, my = GetMouseXY()
	local d = 5
	if mx < d then
		return 'L'
	elseif mx > w - d then
		return 'R'
	end
end

local function GetMouseTiltPara() --获取鼠标对倾斜的影响
	local w, h = GetScreenSize()
	local mx, my = GetMouseXY()
	local d = 5
	if my < d then
		return 'U'
	elseif my > h - d then
		return 'D'
	end
end


variable.inject({
	GetMouseMovePara = GetMouseMovePara,
	GetMouseRotPara = GetMouseRotPara,
	GetMouseTiltPara = GetMouseTiltPara,
})

