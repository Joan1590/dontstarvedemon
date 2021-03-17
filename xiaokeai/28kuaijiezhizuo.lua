
local function IsHUDScreen()
	local defaultscreen = false
	if TheFrontEnd:GetActiveScreen() and TheFrontEnd:GetActiveScreen().name and type(TheFrontEnd:GetActiveScreen().name) == "string" and TheFrontEnd:GetActiveScreen().name == "HUD" then
		defaultscreen = true
	end
	return defaultscreen
end


if TUNING.xiaoyao("key") then modimport("scripts/yingdao.lua") end
local function GetItemDaBao()
    local invitems = GLOBAL.ThePlayer.replica.inventory:GetItems()
    local backpack
    if GLOBAL.EQUIPSLOTS.BACK then
        backpack = GLOBAL.ThePlayer.replica.inventory:GetEquippedItem(
            GLOBAL.EQUIPSLOTS.BACK)
    else
        backpack = GLOBAL.ThePlayer.replica.inventory:GetEquippedItem(
            GLOBAL.EQUIPSLOTS.BODY)
    end
    local packitems = backpack and backpack.replica.container and
                          backpack.replica.container:GetItems() or nil
    local itemlist = {}
    if invitems then
        for k, v in pairs(invitems) do
            if v.prefab == "giftwrap" or v.prefab == "bundlewrap" then table.insert(itemlist, v) end
        end
    end
    if packitems then
        for k, v in pairs(packitems) do
            if v.prefab == "giftwrap" or v.prefab == "bundlewrap" then table.insert(itemlist, v) end
        end
    end
    return itemlist
end


TheInput:AddKeyUpHandler(TUNING.xiaoyao("打包纸"),function()
    if not IsHUDScreen() then return end
	if GLOBAL.ThePlayer ~= nil   and GLOBAL.ThePlayer.replica.inventory then
        local dabao = GetItemDaBao()
        if next(dabao) ~= nil then
            GLOBAL.ThePlayer.replica.inventory:UseItemFromInvTile(dabao[1])
        end
	end
end)

