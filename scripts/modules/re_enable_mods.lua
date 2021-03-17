local _G = GLOBAL
local TheSim = _G.TheSim
local DataDumper = _G.DataDumper
local SavePersistentString = _G.SavePersistentString
--local KnownModIndex = _G.require("modindex")
local KnownModIndex = _G.KnownModIndex
local ModManager = _G.ModManager

local filepath = "mod_config_data/re_enable_mods_data_save"
local mod_list = {}

TheSim:GetPersistentString(filepath, function(load_success, str)
    if load_success then
        local success, savedata = _G.RunInSandboxSafe(str)
        if success and string.len(str) > 0 then
            mod_list = savedata
        end
    end
end)

local modsenabled = KnownModIndex:GetModsToLoad()
if #modsenabled == 1 then -- Only we are enabled, enable all saved mods
    for modname in pairs(mod_list) do
        KnownModIndex:Enable(modname)
        ModManager:FrontendLoadMod(modname)
    end
else
    mod_list = {}
    for _, modname in ipairs(modsenabled) do
        mod_list[modname] = true
    end
    SavePersistentString(filepath, DataDumper(mod_list, nil, true), false, nil)
end

-- To prevent us from loading after the crashed mod

--local KnownModIndex_Enable = KnownModIndex.Enable
--KnownModIndex.Enable = function(self, modname)
--    mod_list[modname] = true
--    SavePersistentString(filepath, DataDumper(mod_list, nil, true), false, nil)
--    KnownModIndex_Enable(self, modname)
--end
--local KnownModIndex_Disable = KnownModIndex.Disable
--KnownModIndex.Disable = function(self, modname)
--    mod_list[modname] = nil
--    SavePersistentString(filepath, DataDumper(mod_list, nil, true), false, nil)
--    KnownModIndex_Disable(self, modname)
--end