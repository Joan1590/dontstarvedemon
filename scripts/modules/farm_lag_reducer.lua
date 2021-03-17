local _G = GLOBAL
local TheSim = _G.TheSim
local FindEntity = _G.FindEntity
local PrefabExists = _G.PrefabExists

local prefabs_to_hide = {
    "fast_farmplot"
}

local function UpdatePrefab(inst)
    if inst and inst:IsValid() then
        if FindEntity(inst, 0.1, function(_inst) return _inst.prefab == inst.prefab end) then
            inst:Hide()
        else
            inst:Show()
        end
    end
end

for i, v in ipairs(prefabs_to_hide) do

    AddPrefabPostInit(v, function(inst)

        inst:DoTaskInTime(0, UpdatePrefab)

---        local TheWorld = _G.TheWorld
---        if not TheWorld then return end
---
---        TheWorld:PushEvent("register_farmplot", inst)

        inst:ListenForEvent("onremove", function(inst)
            local pos = inst:GetPosition()
            local ents = TheSim:FindEntities(pos.x, pos.y, pos.z, 1)
            for _, ent in ipairs(ents) do
                if ent.prefab == inst.prefab then
                    ent:PushEvent("update_farmplot")
                end
            end
            --TheWorld:PushEvent("update_farmplot")
        end)

        inst:ListenForEvent("update_farmplot", UpdatePrefab)
        --inst:ListenForEvent("update_farmplot", function()
        --    inst:DoTaskInTime(0, UpdatePrefab)
        --end)
    end)
end

-- function _G.c_hideall(prefab)
--     local ThePlayer = _G.ThePlayer
--     if not ThePlayer then print("Not In Game") return end
--     if prefab == nil then
--         print("No Prefab Inputed")
--     end
--     if type(prefab) == "string" and PrefabExists(prefab) then
--         AddPrefabPostInit(prefab, function(inst)
--             inst:DoTaskInTime(0, UpdatePrefab)
--         end)
--         local pos = ThePlayer:GetPosition()
--         local ents = TheSim:FindEntities(pos.x, pos.y, pos.z, 70)
--         for i, ent in ipairs(ents) do
--             if ent.prefab == prefab then
--                 UpdatePrefab(ent)
--             end
--         end
--         print("Hidden "..prefab.." successfully")
--     else
--         print("Invalid Prefab")
--     end
-- end

--AddPrefabPostInit("world", function(inst)
--    local farms = {}
--    inst:ListenForEvent("register_farmplot", function(inst, farm)
--        table.insert(farms, farm)
--    end)
--
--    inst:ListenForEvent("update_farmplot", function(removed_farm)
--        for i, v in ipairs(farms) do
--            if v == removed_farm then
--                table.remove(farms, removed_farm)
--                break
--            end
--        end
--
--        for i, v in ipairs(farms) do
--            if v and v:IsValid() then
--                v:PushEvent("update_farmplot")
--            end
--        end
--    end)
--end)