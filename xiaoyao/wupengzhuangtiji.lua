local function IsYellowOrOpalStaff(test)
    return test == "yellowstaff" or test == "opalstaff"
end
local DoNotStackWith =
{
    fossil_piece_placer = "fossil_stalker",
}
local NoClickMe = {}
AddGamePostInit(
    function()
        local hookent = GLOBAL.CreateEntity()
        if hookent
        then
            local mt = GLOBAL.getmetatable(hookent.entity)
            if mt and mt.__index
            then
                local mt_index = mt.__index
                if mt_index.IsVisible
                then
                    local IsVisible_old = mt_index.IsVisible
                    mt_index.IsVisible = function(entity, ...)
                        if entity.GetGUID
                        then
                            local inst = GLOBAL.Ents[entity:GetGUID() or 0]
                            if inst and NoClickMe[inst]
                            then
                                return false
                            end
                        end
                        return IsVisible_old(entity, ...)
                    end
                end
            end
            hookent:Remove()
        end
    end
)
local function OnEntityEntered(ent)
    NoClickMe[ent] = true
end
local function OnEntityLeft(ent)
    NoClickMe[ent] = nil
end
local CheckingTimer = nil
local Sources = 0
local TrackedEnts = {}
local PlacerPrefab = "N/A"
local OldHeldPrefab = "N/A"
local function StopChecking(player)
    Sources = Sources - 1
    if Sources == 0
    then
        if CheckingTimer ~= nil
        then
            CheckingTimer:Cancel()
            CheckingTimer = nil
        end
        for k,_ in pairs(TrackedEnts)
        do
            OnEntityLeft(k)
        end
        TrackedEnts = {}
    end
end
local function StartChecking(player)
    Sources = Sources + 1
    if CheckingTimer == nil
    then
        CheckingTimer = player:DoPeriodicTask(
            0.1,
            function(self)
                local x, y, z = GLOBAL.TheSim:ProjectScreenPos(GLOBAL.TheSim:GetPosition())
                local ents = GLOBAL.TheSim:FindEntities(x, y, z, 8.0) or {}
                local new_ents = {}
                for _,v in pairs(ents)
                do
                    new_ents[v] = true
                    if TrackedEnts[v] == nil and DoNotStackWith[PlacerPrefab] ~= v.prefab
                    then
                        OnEntityEntered(v)
                    end
                end
                for k,_ in pairs(TrackedEnts)
                do
                    if new_ents[k] == nil
                    then
                        OnEntityLeft(k)
                    end
                end
                TrackedEnts = new_ents
            end
        )
    end
end
local function HookPlayerController(inst)
    local metatable = GLOBAL.getmetatable(inst) or {}
    local metatable_newindex_old = metatable.__newindex
    metatable.__newindex = function(t, k, v)
        if k == "deployplacer" and v ~= nil
        then
            if inst.inst and inst.inst.replica and inst.inst.replica.inventory
            then
                local item = inst.inst.replica.inventory:GetActiveItem()
                if item and item.replica and item.replica._ and item.replica._.inventoryitem and item.replica._.inventoryitem.classified and (item.replica._.inventoryitem.classified.deployspacing and item.replica._.inventoryitem.classified.deployspacing:value() == GLOBAL.DEPLOYSPACING.NONE or item.replica._.inventoryitem.classified.deploymode and item.replica._.inventoryitem.classified.deploymode:value() == GLOBAL.DEPLOYMODE.ANYWHERE)
                then
                    v:ListenForEvent(
                        "onremove",
                        function(self)
                            PlacerPrefab = "N/A"
                            StopChecking(inst.inst)
                        end
                    )
                    PlacerPrefab = v.prefab or "N/A"
                    StartChecking(inst.inst)
                end
            end
        end
        if metatable_newindex_old ~= nil
        then
            metatable_newindex_old(t, k, v)
        else
            GLOBAL.rawset(t, k, v)
        end
    end
    GLOBAL.setmetatable(inst, metatable)
end
AddPrefabPostInit(
    "world",
    function(inst)
        inst:ListenForEvent(
            "playeractivated",
            function(inst, data)
                if data == GLOBAL.ThePlayer
                then
                    if data.components.playercontroller
                    then
                        HookPlayerController(data.components.playercontroller)
                    end
                    -- Polling because inventory event "unequip" doesn't fire under a _lot_ of circumstances.  I can't be bothered.
                    data:DoPeriodicTask(
                        0.1,
                        function(self)
                            if self.replica.inventory
                            then
                                local HeldItem = self.replica.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.HANDS)
                                local WasStaff = IsYellowOrOpalStaff(OldHeldPrefab)
                                if HeldItem ~= nil
                                then
                                    local HeldPrefab = HeldItem.prefab or "N/A"
                                    local IsStaff = IsYellowOrOpalStaff(HeldPrefab)
                                    if not WasStaff and IsStaff
                                    then
                                        StartChecking(self)
                                    elseif WasStaff and not IsStaff
                                    then
                                        StopChecking(self)
                                    end
                                    OldHeldPrefab = HeldPrefab
                                else
                                    if WasStaff
                                    then
                                        StopChecking(self)
                                    end
                                    OldHeldPrefab = "N/A"
                                end
                            end
                        end
                    )
                end
            end
        )
    end
)