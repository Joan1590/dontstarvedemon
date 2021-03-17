local _G = GLOBAL
local TheInput = _G.TheInput
local AllRecipes = _G.AllRecipes

local function InGame()
    return _G.ThePlayer and _G.ThePlayer.HUD and not _G.ThePlayer.HUD:HasInputFocus()
end

TheInput:AddKeyUpHandler(_G[TUNING.xiaoyao("key")],function()
    if InGame() then
        _G.ThePlayer.replica.builder:MakeRecipeFromMenu(AllRecipes["nightsword"])	----影刀
    end
end)

TheInput:AddKeyUpHandler(TUNING.xiaoyao("key2"),function()
    if InGame() and not TUNING.xiaoyao("更多按键") or TheInput:IsKeyDown(KEY_CTRL) then
        _G.ThePlayer.replica.builder:MakeRecipeFromMenu(AllRecipes["bundlewrap"])	---打包纸
    end
end)

TheInput:AddKeyUpHandler(TUNING.xiaoyao("key3"),function()
	if InGame() and not TUNING.xiaoyao("更多按键") or TheInput:IsKeyDown(KEY_CTRL) then
        _G.ThePlayer.replica.builder:MakeRecipeFromMenu(AllRecipes["rope"])	---绳子
    end
end)