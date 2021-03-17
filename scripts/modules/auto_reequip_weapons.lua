local _G = GLOBAL
local EQUIPSLOTS = _G.EQUIPSLOTS
local ACTIONS = _G.ACTIONS
local SendRPCToServer = _G.SendRPCToServer
local RPC = _G.RPC
local TheInput = _G.TheInput
local ThePlayer

local low_dur_first = GetModConfigData("low_dur_first")

local equiptask
local eventlisteninglist = {}

local disable = false

local function InGame()
    return ThePlayer and ThePlayer.HUD and not ThePlayer.HUD:HasInputFocus()
end

local function Say(text)
    if not (ThePlayer and ThePlayer.components.talker) then return end
    ThePlayer.components.talker:Say(text)
end

local function DoEquip(inst, item)
    if ThePlayer.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) then
        if equiptask then
            equiptask:Cancel()
            equiptask = nil
        end
    else
        local inventory = ThePlayer.components.inventory
        local playercontroller = ThePlayer.components.playercontroller
        local equip_actioncode = ACTIONS.EQUIP.code
        if inventory then
            local playercontroller_deploy_mode = playercontroller.deploy_mode
            playercontroller:ClearControlMods()
            playercontroller.deploy_mode = false
            inventory:ControllerUseItemOnSelfFromInvTile(item, equip_actioncode)
            playercontroller.deploy_mode = playercontroller_deploy_mode
        else
            SendRPCToServer(RPC.ControllerUseItemOnSelfFromInvTile, equip_actioncode, item)
        end
    end
end

local last_item
local function OnItemRemoved()

    if disable or equiptask then return end

    local inventory = ThePlayer.replica.inventory
    if inventory and not inventory:GetEquippedItem(EQUIPSLOTS.HANDS) then

        local last_prefab = last_item.prefab
        local right_weapons = {}
        local check_list = {{_ = inventory:GetActiveItem()}, inventory:GetItems()}

        local open_containers = inventory:GetOpenContainers()
        if open_containers then
            for container in pairs(open_containers) do
                local container_replica = container and container.replica.container
                if container_replica then
                    table.insert(check_list, container_replica:GetItems())
                end
            end
        end
        for _, items in ipairs(check_list) do
            for _, item in pairs(items) do
                if item and item.prefab == last_prefab then
                    if not low_dur_first then
                        DoEquip(nil, item)
                        equiptask = ThePlayer:DoPeriodicTask(0, DoEquip, nil, item)
                        return
                    end
                    table.insert(right_weapons, item)
                end
            end
        end

        local min_durability, final_weapon
        for _, weapon in ipairs(right_weapons) do
            local inventoryitem = weapon.replica.inventoryitem
            local cur_durability = inventoryitem.classified and inventoryitem.classified.percentused:value() or 0
            if not min_durability or cur_durability < min_durability then
                min_durability = cur_durability
                final_weapon = weapon
            end
        end
        if final_weapon then
            DoEquip(nil, final_weapon)
            equiptask = ThePlayer:DoPeriodicTask(0, DoEquip, nil, final_weapon)
        end

    end
end

local function onremove_fn(inst)
    if inst:HasTag("INLIMBO") and not inst:HasTag("projectile") then
        OnItemRemoved()
    end
end

local function percentusedchange_fn(inst, data)
    if data ~= nil
        and data.percent ~= nil
        and data.percent <= 0
        and inst.components.rechargeable == nil
        and inst.components.inventoryitem ~= nil
        and inst.components.inventoryitem.owner == ThePlayer then

        ThePlayer:DoTaskInTime(0, OnItemRemoved)
    end
end

local function RegistItemOnRemoveFn(item)
    if not item then return end
    last_item = item

    if not eventlisteninglist[item] then
        if ThePlayer.components.playercontroller.ismastersim then
            item:ListenForEvent("percentusedchange", percentusedchange_fn)
        else
            item:ListenForEvent("onremove", onremove_fn)
        end
        eventlisteninglist[item] = true
    end
end

AddClassPostConstruct("components/inventory_replica", function(self, inst)
    inst:DoTaskInTime(0, function(inst)
        if inst ~= _G.ThePlayer then return end
        ThePlayer = _G.ThePlayer
        RegistItemOnRemoveFn(self:GetEquippedItem(EQUIPSLOTS.HANDS))
    end)
end)

AddComponentPostInit("playercontroller", function(self, inst)
    if inst ~= _G.ThePlayer then return end
    ThePlayer = _G.ThePlayer

    ThePlayer:ListenForEvent('equip', function(inst, data)
        if not (data and data.eslot == EQUIPSLOTS.HANDS) then return end
        local item = data and data.item
        RegistItemOnRemoveFn(item)
    end)

    ThePlayer:ListenForEvent('unequip', function(inst, data)
        if not (data and data.eslot == EQUIPSLOTS.HANDS) then return end
        if last_item then
            if last_item:HasTag("projectile") then
                if self.ismastersim then
                    last_item:DoTaskInTime(0, function(inst) if inst:HasTag("NOCLICK") then OnItemRemoved() end end)
                elseif last_item:HasTag("NOCLICK") then
                    OnItemRemoved()
                end
            end
            last_item:RemoveEventCallback("onremove", onremove_fn)
            last_item:RemoveEventCallback("percentusedchange", percentusedchange_fn)
            eventlisteninglist[last_item] = nil
        end
    end)

end)

local toggle_key = GetModConfigData("auto_reequip_weapons") == "no_toggle_key" and -1 or _G[GetModConfigData("auto_reequip_weapons")]
TheInput:AddKeyUpHandler(toggle_key, function()
    if not InGame() then return end
    disable = not disable
    Say("Auto Re-Equip ".. (disable and "Off" or "On"))
end)
