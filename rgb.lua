--颜色空间转换

--参数取值: 0~1
local function hsv2rgb(h, s, v)
	local i = math.floor(h*6)
	local max = v
	local delta = v*s
	local min = max - delta
	local adj = delta* (h%(1/6)*6)

	if i == 0 then
		return {max, min+adj, min}
	elseif i == 1 then
		return {max-adj, max, min}
	elseif i == 2 then
		return {min, max, min+adj}
	elseif i == 3 then
		return {min, max-adj, max}
	elseif i == 4 then
		return {min+adj, min, max}
	else
		return {max, min, max-adj}
	end
end

function rgb2hsv(r, g, b)
	local min = math.min(r, g, b)
	local max = math.max(r, g, b)
	local delta = max - min

	local h, s
	local v = max

	if max <= 1/255 or delta <= 1/255 then
		return {0, 0, v}
	else
		s = delta/max
	end

	if r == max then
		h = (g-b)/delta
	elseif g == max then
		h = (b-r)/delta + 2
	else
		h = (r-g)/delta + 4
	end

	h = h / 6
	if h < 0 then
		h = h + 1
	end
	return {h, s, v}
end

local variable = require 'lw_mod_camera'
variable.inject({ hsv2rgb = hsv2rgb, rgb2hsv = rgb2hsv,})

