local old_re = require

local clear = {}
local function shouldrelease(v)
	if clear[v] then return true end
	if string.sub(v, 1, 11) == 'lw_cameraUI' then return true end
end

function GLOBAL.require(v)
	local result = old_re(v)
	if shouldrelease(v) then
		package.loaded[v] = nil
	end
	return result
end