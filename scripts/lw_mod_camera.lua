
--变量储存器(防止污染)
local env = {}

local function set(k, v)
	env[k] = v
end

local function get(k)
	return env[k]
end

local function inject(data)
	for k, v in pairs(data)do
		env[k] = v
	end
end

local function pour(...)
	local result = {}
	for _, k in ipairs({...})do
		local v = get(k)
		assert(v ~= nil, 'Variable "'.. k .. '" is not deleared.')
		table.insert(result, v)
	end
	return unpack(result)
end

local function call(k, ...)
	local fn = get(k)
	assert(type(fn) == 'function', 'Variable "'.. k .. '" is not callable.')
	return fn(...)
end

local function softcall(k, ...)
	local fn = get(k)
	if type(fn) == 'function' then return fn(...) end
end

return {
	set = set, 
	get = get, 
	inject = inject,
	pour = pour,
	call = call,
	softcall = softcall,
}
