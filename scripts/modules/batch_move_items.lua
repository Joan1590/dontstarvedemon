local _G = GLOBAL
local RPC = _G.RPC
local SendRPCToServer = _G.SendRPCToServer
local GetTime = _G.GetTime
local Sleep = _G.Sleep
local TheInput = _G.TheInput
local orderedPairs = _G.orderedPairs
local CONTROL_FORCE_STACK = _G.CONTROL_FORCE_STACK
local CONTROL_FORCE_TRADE = _G.CONTROL_FORCE_TRADE
local CONTROL_ACCEPT = _G.CONTROL_ACCEPT
local CONTROL_SECONDARY = _G.CONTROL_SECONDARY
local CONTROL_PRIMARY = _G.CONTROL_PRIMARY

local ThePlayer

local instant_move = GetModConfigData("batch_move_items") == "instant_move" and true or false -- Idea from Chest Memory by sauktux
local double_click_speed = GetModConfigData("double_click_speed")
local autowrap = GetModConfigData("autowrap")

local workingthread

local morph_checker = _G.kleiloadlua(MODROOT.."scripts/morph_checker.lua") -- Basically modimport, but we need the return value
_G.setfenv(morph_checker, env)
morph_checker = morph_checker()
local IsRightItem = morph_checker.IsRightItem

local last_leftclick_time = 0
local last_leftclick_item
local last_leftclick_inv
local go_to_container

local function InGame()
    return ThePlayer and ThePlayer.HUD and not ThePlayer.HUD:HasInputFocus()
end

local function StopThread()
    --print("stoped")
    if workingthread then
        workingthread:SetList(nil)
    end
    workingthread = nil
end

local function fn(item, from_container, to_container)

    if not item or workingthread then return end

    local to_container = to_container
    if to_container == ThePlayer then
        to_container = ThePlayer.replica.inventory
    elseif to_container.replica then
        to_container = to_container.replica.container
    end
    local from_container = from_container

    local function GetItem(extracontainers)

        local final_items = {}

        local items = from_container and from_container:GetItems()
        if items then
            for k, v in orderedPairs(items) do
                if IsRightItem(v, item) then
                    if instant_move then
                        table.insert(final_items, {slot = k, item = v, container = from_container.inst})
                    else
                        items.__orderedIndex = nil
                        return {slot = k, item = v}
                    end
                end
            end
        end
        if extracontainers then
            for _, extracontainer in ipairs(extracontainers) do
                items = extracontainer.GetItems and extracontainer:GetItems() or extracontainer.slots
                if not items then return end
                if items then
                    for k, v in orderedPairs(items) do
                        if IsRightItem(v, item) then
                            if instant_move then
                                table.insert(final_items, {slot = k, item = v, container = extracontainer.inst})
                            else
                                items.__orderedIndex = nil
                                return {slot = k, item = v, container = extracontainer}
                            end
                        end
                    end
                end
            end
        --else
        --    items = extracontainer and extracontainer:GetItems()
        --    if items then
        --        for k,v in pairs(items) do
        --            if v.prefab == item then
        --                return k, extracontainer
        --            end
        --        end
        --    end
        end
        if instant_move then return final_items end
    end

    workingthread = ThePlayer:StartThread(function()

        local function IsValidContainer(container, cur_items)
            if not (container and container:IsOpenedBy(ThePlayer)) then return end
            if not container:IsFull() then return true end
            if container:AcceptsStacks() then
                local items = container.GetItems and container:GetItems() or container.slots
                for _, v in pairs(items) do
                    for _, cur_data in ipairs(cur_items) do
                        local cur_item = cur_data.item
                        if v.prefab == cur_item.prefab and v.skinname == cur_item.skinname then
                            if v.replica.stackable ~= nil and not v.replica.stackable:IsFull() then
                                return true
                            end
                        end
                    end
                end
            end
        end

        while ThePlayer:IsValid() do

            local item_info = {} -- For instant move
            local items = {}     -- For normal move
            
            local function get(condition, extracontainers)
                if condition then
                    if instant_move then
                        items = GetItem()
                    else
                        item_info = GetItem() or {}
                    end
                else
                    if instant_move then
                        items = GetItem(extracontainers)
                    else
                        item_info = GetItem(extracontainers) or {}
                    end
                end
            end

            local inventory = ThePlayer.replica.inventory
            local backpack = inventory:GetOverflowContainer()

            if to_container.inst:HasTag("bundle") then
                local containers = inventory:GetOpenContainers()
                local needed_containers = {}
                table.insert(needed_containers, inventory)
                for k, v in pairs(containers) do
                    if not k:HasTag("bundle") and k.replica.container then
                        table.insert(needed_containers, k.replica.container)
                    end
                end
                get(nil, needed_containers)
            elseif from_container == inventory then
                get(to_container.inst:HasTag("backpack"), {backpack})
            elseif from_container.inst:HasTag("backpack") then
                get(to_container == inventory, {inventory})
            else
                get()
            end

            if item_info.container then
                from_container = item_info.container
            end

            if not _G.next(item_info) and not _G.next(items) then
                if to_container.inst == ThePlayer or to_container.inst:HasTag("backpack") then
                    break
                end
                local active_item = inventory and inventory:GetActiveItem()
                if active_item and IsRightItem(active_item, item) and IsValidContainer(to_container, {{item = active_item}}) then
                    local num = to_container:GetNumSlots()
                    if num then
                        for i = 1, num do
                            local container_item = to_container:GetItemInSlot(i)
                            if container_item == nil then
                                to_container:PutAllOfActiveItemInSlot(i)
                            elseif to_container:AcceptsStacks()
                                and container_item.prefab == active_item.prefab and container_item.skinname == active_item.skinname
                                and container_item.replica.stackable ~= nil and not container_item.replica.stackable:IsFull() then

                                to_container:AddAllOfActiveItemToSlot(i)
                            end
                        end
                    end
                else
                    break
                end
            end

            if IsValidContainer(to_container, instant_move and items or {item_info}) then
                if instant_move then
                    for _, data in ipairs(items) do
                        local slot = data.slot
                        local f_container = data.container
                        if f_container == ThePlayer then
                            SendRPCToServer(RPC.MoveInvItemFromAllOfSlot, slot, to_container.inst)
                        else
                            SendRPCToServer(RPC.MoveItemFromAllOfSlot, slot, f_container, to_container.inst)
                        end
                    end
                else
                    from_container:MoveItemFromAllOfSlot(item_info.slot, to_container.inst)
                end
            elseif to_container == inventory and not from_container.inst:HasTag("backpack") then
                if backpack and IsValidContainer(backpack, instant_move and items or {item_info}) then
                    to_container = backpack
                else
                    break
                end
            elseif to_container.inst:HasTag("backpack") and from_container ~= inventory then
                if IsValidContainer(inventory, instant_move and items or {item_info}) then
                    to_container = inventory
                else
                    break
                end
            else
                break
            end

            Sleep(0)

        end

        local container_inst = to_container.inst
        if autowrap and container_inst:HasTag("bundle") and to_container:IsFull() then
            local button_fn = to_container.widget and to_container.widget.buttoninfo and to_container.widget.buttoninfo.fn
            if button_fn then
                local first_item
                local needs_autowrap = true
                for _, v in pairs(to_container:GetItems()) do
                    if first_item == nil then
                        first_item = v
                    end
                    if not IsRightItem(v, first_item)
                        or (v.replica.stackable and not v.replica.stackable:IsFull())
                        or (
                            v.replica.inventoryitem.classified
                            and v.replica.inventoryitem.classified.percentused:value() ~= 100 -- Full durability
                            and v.replica.inventoryitem.classified.percentused:value() ~= 255 -- Default value
                        ) then

                        needs_autowrap = false
                        break
                    end
                end
                if needs_autowrap then
                    if _G.TheWorld.ismastersim then Sleep(_G.FRAMES * 2) end
                    while container_inst:IsValid() and container_inst.replica.container do
                        button_fn(container_inst)
                        Sleep(0)
                    end
                end
            end
        end

        StopThread()
    end)
end

local interrupt_controls = {}
for control = _G.CONTROL_ATTACK, _G.CONTROL_MOVE_RIGHT do
    interrupt_controls[control] = true
end
AddComponentPostInit("playercontroller", function(self, inst)
    if inst ~= _G.ThePlayer then return end
    ThePlayer = _G.ThePlayer
    local mouse_controls = {[_G.CONTROL_PRIMARY] = true, [_G.CONTROL_SECONDARY] = true}

    local PlayerControllerOnControl = self.OnControl
    self.OnControl = function(self, control, down)
        local mouse_control = mouse_controls[control]
        local interrupt_control = interrupt_controls[control]
        if interrupt_control or mouse_control and not TheInput:GetHUDEntityUnderMouse() then
            if down and workingthread and InGame() then
                StopThread()
            end
        end
        PlayerControllerOnControl(self, control, down)
    end
end)

local function InvSlotPostInit(self)
    local InvSlotOnControl = self.OnControl
    self.OnControl = function(self, control, down)
        if down and control == CONTROL_ACCEPT and TheInput:IsControlPressed(CONTROL_FORCE_TRADE) then
            local current_time = GetTime()
            if go_to_container and go_to_container:IsValid() and not go_to_container:HasTag("stewer")
            and current_time - last_leftclick_time < double_click_speed and last_leftclick_inv == self
            and not (self.tile and self.tile.item) then
                fn(last_leftclick_item, self.container, go_to_container)
            end
            last_leftclick_time = current_time
            last_leftclick_inv = self
            last_leftclick_item = self.tile and self.tile.item
        end
        return InvSlotOnControl(self, control, down)
    end
end

AddClassPostConstruct("widgets/invslot", InvSlotPostInit)

local function Inv_Container_PostInit(self)
    local Old_MoveItemFromAllOfSlot = self.MoveItemFromAllOfSlot

    self.MoveItemFromAllOfSlot = function(self, slot, container)
        Old_MoveItemFromAllOfSlot(self, slot, container)
        go_to_container = container
    end

end

AddClassPostConstruct("components/inventory_replica", Inv_Container_PostInit)
AddClassPostConstruct("components/container_replica", Inv_Container_PostInit)