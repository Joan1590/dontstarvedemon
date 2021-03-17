local _G = GLOBAL

local morph_list = {}

local function IsRightItem(item, _item)
    local item_prefab = type(item) == "table" and item.prefab or item
    local _item_prefab = type(_item) == "table" and _item.prefab or _item
    if item_prefab == _item_prefab then
        return true
    end
    for _, group in ipairs(morph_list) do
        if table.contains(group, item_prefab) and table.contains(group, _item_prefab) then
            return true
        end
    end
end

local function generate_morphs(config_name, base_str, start_num, end_num, no_insert, extra_stuffs)
    local t = {}
    if config_name and not GetModConfigData(config_name.."_are_one") then return end
    if base_str then
        local start_num = start_num or 1
        for i = start_num, end_num do
            table.insert(t, base_str..tostring(i))
        end
    end
    if extra_stuffs then
        t = _G.JoinArrays(t, extra_stuffs)
    end
    if not no_insert then
        table.insert(morph_list, t)
    end
    return t
end

generate_morphs("shells", "singingshell_octave", 3, 5) -- Shells
generate_morphs("antlers", "deer_antler", 1, 3) -- Antlers
generate_morphs("trinkets", "trinket_", 1, _G.NUM_TRINKETS, nil, {"antliontrinket"}) -- Trinkets
generate_morphs("winter_lights", "winter_ornament_light", 1, 8) -- Festive Lights
generate_morphs("halloween_ornaments", "halloween_ornament_", 1, _G.NUM_HALLOWEEN_ORNAMENTS) -- Halloween Ornaments
generate_morphs("halloween_candies", "halloweencandy_", 1, _G.NUM_HALLOWEENCANDY) -- Halloween Candies
generate_morphs("winter_foods", "winter_food", 1, _G.NUM_WINTERFOOD) -- Winter Feast Foods

local boss_ornament = {"antlion",     "bearger",       "beequeen", "deerclops",
                       "dragonfly",   "fuelweaver",    "klaus",    "krampus", 
                       "moose",       "noeyeblue",     "noeyered", "toadstool",
                       "malbatross",
                       "crabking",    "crabkingpearl", "minotaur", "toadstool_misery",
                       "hermithouse", "pearl"
                    }
for i, v in ipairs(boss_ornament) do
    boss_ornament[i] = "winter_ornament_boss_"..v
end

generate_morphs("winter_ornaments", "winter_ornament_plain", 1, 12, nil, _G.JoinArrays( -- Festive Baubles (Plain)
    generate_morphs(nil, "winter_ornament_fancy", 1, 12, true), -- Festive Baubles (Fancy)
    generate_morphs(nil, "winter_ornament_festivalevents", 1, 3, true), -- Champion Adornment (Forge)
    generate_morphs(nil, "winter_ornament_festivalevents", 4, 5, true), -- Appeasing Adornment (Gorge)
    boss_ornament -- Magnificent Adornment (Boss)
))

local SEEDLESS = {
	berries = true, 
	cave_banana = true,
	cactus_meat = true,
	berries_juicy = true,
	kelp = true,
}

local seeds = { "seeds" }
local farm_plants = { "farm_plant_randomseed" }
local giant_veggies = {}
require("prefabs/veggies")
for veggiename in pairs(_G.VEGGIES) do
    if not SEEDLESS[veggiename] then
        table.insert(seeds, veggiename.."_seeds")
        table.insert(farm_plants, "farm_plant_"..veggiename)
        table.insert(giant_veggies, veggiename.."_oversized")
    end
end
generate_morphs("seeds", nil, nil, nil, nil, seeds)                 -- Seeds
generate_morphs("plants", nil, nil, nil, nil, farm_plants)          -- Planted Veggies
generate_morphs("giant_veggies", nil, nil, nil, nil, giant_veggies) -- Giant Veggies

generate_morphs("recipe_papers", nil, nil, nil, nil, {"blueprint", "sketch", "tacklesketch"}) -- Blueprints / Sketches / Adverts

generate_morphs(nil, "chessjunk", 1, 3) -- Broken Clockworks
local statues = {"ruins_statue_head", "ruins_statue_head_nogem", "ruins_statue_mage", "ruins_statue_mage_nogem"} -- Ancient Statues
generate_morphs(nil, nil, nil, nil, nil, statues)

return {
    morph_list = morph_list,
    IsRightItem = IsRightItem
}