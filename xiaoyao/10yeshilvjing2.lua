local _G = GLOBAL
local debug = _G.debug

-- From Kynoox_'s Seasonal Colour Cubes
local function getval(fn, path)
    local val = fn
    for entry in path:gmatch("[^%.]+") do
        local i = 1
        while true do
            local name, value = debug.getupvalue(val, i)
            if name == entry then
                val = value
                break
            elseif name == nil then
                return
            end
            i = i + 1
        end
    end
    return val
end

local function setval(fn, path, new)
    local val = fn
    local prev = nil
    local i
    for entry in path:gmatch("[^%.]+") do
        i = 1
        prev = val
        while true do
            local name, value = debug.getupvalue(val, i)
            if name == entry then
                val = value
                break
            elseif name == nil then
                return
            end
            i = i + 1
        end
    end
    debug.setupvalue(prev, i, new)
end
---------------------------------------

--if not GetModConfigData("低san花纹") then
	AddClassPostConstruct("screens/playerhud", function(self)
		self.GoInsane = function(self)
			self:GoSane()
		end
	end)
--end

-- Also from Kynoox_'s Seasonal Colour Cubes
AddComponentPostInit("colourcube", function(self)
	local TheWorld = _G.TheWorld
    for _, fn in ipairs(TheWorld.event_listeners["playeractivated"][TheWorld]) do
        local OnSanityDelta = getval(fn, "OnSanityDelta")
        if OnSanityDelta then
            setval(fn, "OnSanityDelta", function(player, data)
                local easing = _G.require("easing")
                _G.PostProcessor:SetColourCubeLerp(1, 0)
                _G.PostProcessor:SetDistortionFactor(1)
                setval(OnSanityDelta, "_fxspeed", easing.outQuad(0, 0, .2, 1))
            end)
        end
        local OnOverrideCCTable = getval(fn, "OnOverrideCCTable")
        if OnOverrideCCTable then
            local GetCCPhase = getval(OnOverrideCCTable, "UpdateAmbientCCTable.Blend.GetCCPhase")
            setval(fn, "OnOverrideCCTable", function(player, cctable)
                if cctable and cctable.supper_moggles and not cctable[GetCCPhase()] then return end
                OnOverrideCCTable(player, cctable)
            end)
        end
	end
end)

AddComponentPostInit("playervision", function(self)
   -- if GetModConfigData("灵魂滤镜") then
        setval(self.UpdateCCTable, "GHOSTVISION_COLOURCUBES", nil)
   -- end
    --if GetModConfigData("鼹鼠帽泛白") then
        local cubes = {
            day = "images/colour_cubes/mole_vision_off_cc.tex",
            supper_moggles = true
        }
        setval(self.UpdateCCTable, "NIGHTVISION_COLOURCUBES", cubes)
   -- else
        setval(self.UpdateCCTable, "NIGHTVISION_COLOURCUBES", nil)
    --end
end)


--if GetModConfigData("低san声音") then
    RemapSoundEvent("dontstarve/sanity/gonecrazy_stinger", "")
    RemapSoundEvent("dontstarve/sanity/sanity", "")
--end

--if GetModConfigData("月岛滤镜") then
    RemapSoundEvent("turnoftides/sanity/lunacy_LP", "")
--end
