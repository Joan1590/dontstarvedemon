local PopupDialogScreen = require "screens/redux/popupdialog"
local Widget = require "widgets/widget"
local Text = require "widgets/text"
local TEMPLATES = require "widgets/redux/templates"
local IngredientUI = require "widgets/ingredientui"
local TechTree = require("techtree")


local tech_icons = {
	[TECH.NONE] = nil,
	[TECH.SCIENCE_ONE] = "researchlab.tex",
	[TECH.SCIENCE_TWO] = "researchlab2.tex",
	[TECH.SCIENCE_THREE] = "researchlab2.tex",
	[TECH.MAGIC_TWO] = "researchlab4.tex",
	[TECH.MAGIC_THREE] = "researchlab3.tex",
	[TECH.ANCIENT_TWO] = "ruinsaltar.tex",	--custom
	[TECH.ANCIENT_FOUR] = "ruinsaltar.tex",		--custom
	[TECH.CELESTIAL_ONE] = "moonrockseed.tex",
	[TECH.MOON_ALTAR_TWO] = "moonaltar.tex",		--custom
	[TECH.SHADOW_TWO] = "waxwelljournal.tex",
	[TECH.CARTOGRAPHY_TWO] = "cartographydesk.tex",
	[TECH.SEAFARING_TWO] = "seafaring_prototyper.tex",
	[TECH.SCULPTING_ONE] = "sculptingtable.tex",
	[TECH.ORPHANAGE_ONE] = "critterden.tex", --custom
	[TECH.YOTG] = nil,
	[TECH.YOTV] = nil,
	[TECH.YOTP] = nil,
	[TECH.YOTC] = nil,
	[TECH.PERDOFFERING_ONE] = "perdshrine.tex",
	[TECH.PERDOFFERING_THREE] = "perdshrine.tex",
	[TECH.WARGOFFERING_THREE] = "wardshrine.tex",
	[TECH.PIGOFFERING_THREE] = "pigshrine.tex",
	[TECH.CARRATOFFERING_THREE] = "yotc_carratshrine.tex",
	[TECH.MADSCIENCE_ONE] = "madscience_lab.tex",
	--[TECH.FOODPROCESSING_ONE] = "" gorge moment :(
	[TECH.FISHING_ONE] = "tacklestation.tex",
	[TECH.HERMITCRABSHOP_ONE] = "hermitcrab_icon.tex", --custom
	[TECH.HERMITCRABSHOP_THREE] = "hermitcrab_icon.tex", --custom
	[TECH.HERMITCRABSHOP_FIVE] = "hermitcrab_icon.tex", --custom
	[TECH.HERMITCRABSHOP_SEVEN] = "hermitcrab_icon.tex", --custom
	[TECH.HALLOWED_NIGHTS] = nil,
	[TECH.WINTERS_FEAST] = nil,
	[TECH.TURFCRAFTING_ONE] = "turfcraftingstation.tex",
	[TECH.WINTERSFEASTCOOKING_ONE] = "wintersfeastoven.tex",
	[TECH.LOST] = "blueprint_rare.tex", --this one's probably gunna need to be dynamic
}

local function GetTechIcon(recipe)
	for k, v in pairs(TECH) do
		local techtree = TechTree.Create(v)
		local matches = true
		for k2, v2 in pairs(techtree) do
			if v2 ~= recipe.level[k2] then
				matches = false
				break
			end
		end
		if matches then
			return tech_icons[v]
		end
	end
end

local FR_Entry = Class(Widget, function(self, owner)
    Widget._ctor(self, "FR_Entry")
	self.owner = owner

    self.onclick = function()
		TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/click_move")
		DoRecipeClick(self.owner, self.recipe, self.skin)
	end
	self.onrightclick = function()
		FavRecipeManager:RemoveFavorite(self.recipe, self.skin)
	end
    self.root = self:AddChild(Widget("root"))

    local frame_scale = 0.215
	local image_scale = 0.65
	local buffercheck_scale = 0.4
	local techicon_scale = 0.4
    local offset = -20

	self.frame = self.root:AddChild(Image("images/frontend_redux.xml", "achievement_backing.tex"))
	self.frame:SetScale(frame_scale, 0.5)
	
	self.frame_focused = self.root:AddChild(Image("images/frontend_redux.xml", "achievement_backing_hover.tex"))
	self.frame_focused:SetScale(frame_scale, 0.5)
	self.frame_focused:Hide()
	
	--self.str = ""
	--self.name = self.root:AddChild(Text(CHATFONT, 19, ""))
	self.recipe = nil
	self.itemicon = self.root:AddChild(Image())
	self.itemicon:SetPosition(-75, 0)
	self.itemicon:SetScale(image_scale, image_scale, 1)
	
	self.techicon = self.root:AddChild(Image())
	self.techicon:SetPosition(-35, 0)
	self.techicon:SetScale(techicon_scale, techicon_scale, 1)
	
	self.buffercheck = self.itemicon:AddChild(Image("images/favrecipes_check.xml", "favrecipes_check.tex"))
	self.buffercheck:SetPosition(27, -20)
	self.buffercheck:SetScale(buffercheck_scale, buffercheck_scale, 1)
	self.buffercheck:Hide()
	
	self.ingredient_widgets = {}
end)

function FR_Entry:OnGainFocus()
    if not self:IsEnabled() then return end
    FR_Entry._base.OnGainFocus(self)
    TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/click_mouseover")
	self.frame_focused:Show()
end

function FR_Entry:OnLoseFocus()
    if not self:IsEnabled() then return end
    FR_Entry._base.OnLoseFocus(self)
	self.frame_focused:Hide()
end

-- function FR_Entry:Hide()
	-- self.root:Hide()
-- end

-- function FR_Entry:Show()
	-- self.root:Show()
-- end

function FR_Entry:OnDeleteButton()
    
end

function FR_Entry:OnControl(control, down)
	if FR_Entry._base.OnControl(self, control, down) then return true end
	
	if not down then
		if control == CONTROL_ACCEPT then
			self:onclick()
            return true
		elseif control == CONTROL_SECONDARY then
			self:onrightclick()
			return true
		end
	end
end

function FR_Entry:SetName(name)
	if name == nil then
		self.root:Hide()
	else
		self.str = name
		self.name:SetString(name)
		self.root:Show()
	end
end

function FR_Entry:SetRecipe(recipe, skin)
	self.recipe = recipe
	self.skin = skin
	if recipe == nil then
		return
	end
	
	local imagename = skin and skin..".tex" or recipe.image
	if skin == recipe.product then
		imagename = recipe.image
	end
	local atlasname = GetInventoryItemAtlas(imagename, true) --no fallback for modded recipes
	if atlasname ~= nil then
		self.itemicon:SetTexture(atlasname, imagename)
	end

	local techicon = GetTechIcon(recipe)
	if techicon ~= nil then
		if techicon == "blueprint_rare.tex" then --special case for sketch & advert recipes
			if recipe.tab == RECIPETABS.SCULPTING then
				techicon = "sculptingtable_lost.tex"
			elseif recipe.tab == RECIPETABS.FISHING then
				techicon = "tacklestation_lost.tex"
			end
		end
		local atlas = GetInventoryItemAtlas(techicon, true)
		if atlas ~= nil then
			self.techicon:SetTexture(atlas, techicon)
			self.techicon:Show()
		else
			self.techicon:Hide()
		end
	else
		self.techicon:Hide()
	end
	
	self:UpdateData()
end

function FR_Entry:UpdateData()
	for k, v in pairs(self.ingredient_widgets) do
		v:Kill()
	end
	self.ingredient_widgets = {}
	
	local ing_offset = 40
	local ing_scale = 0.55
	local ing_width = 37
	
    local recipe = self.recipe
    local builder = self.owner.replica.builder
    local inventory = self.owner.replica.inventory
	if builder == nil then return end
    local knows = builder:KnowsRecipe(recipe.name)
    local buffered = builder:IsBuildBuffered(recipe.name)
    local can_build = buffered or builder:CanBuild(recipe.name)
    local tech_level = builder:GetTechTrees()
	local can_prototype = CanPrototypeRecipe(recipe.level, tech_level)
	
	if knows and recipe.tab ~= RECIPETABS.SCULPTING and recipe.tab ~= RECIPETABS.FISHING then
		self.techicon:Hide()
	else
		self.techicon:Show()
	end
	if buffered then
		self.buffercheck:Show()
	else
		self.buffercheck:Hide()
	end
	for k, v in pairs(recipe.tech_ingredients) do
        if v.type:sub(-9) == "_material" then
            local has = builder:HasTechIngredient(v)
            local ing = self.root:AddChild(IngredientUI(v:GetAtlas(), v:GetImage(), nil, nil, has, STRINGS.NAMES[string.upper(v.type)], self.owner, v.type))
			ing:SetScale(ing_scale, ing_scale, 1)
            if GetGameModeProperty("icons_use_cc") then
                ing.ing:SetEffect("shaders/ui_cc.ksh")
            end
			table.insert(self.ingredient_widgets, ing)
		end
	end
	for k, v in pairs(recipe.ingredients) do
		local amount_needed = RoundBiasedUp(v.amount * builder:IngredientMod())
		local has = inventory:Has(v.type, amount_needed)
		local ing_label = STRINGS.NAMES[string.upper(v.type)] .. (amount_needed > 1 and (" x"..tostring(amount_needed)) or "")
		local ing = self.root:AddChild(IngredientUI(v:GetAtlas(), v:GetImage(), nil, nil, has, ing_label, self.owner, v.type))
		ing:SetScale(ing_scale, ing_scale, 1)
        if GetGameModeProperty("icons_use_cc") then
            ing.ing:SetEffect("shaders/ui_cc.ksh")
        end
		table.insert(self.ingredient_widgets, ing)
	end
    for i, v in ipairs(recipe.character_ingredients) do
		local amount_needed_str = "-"
		if v.amount < 1 then
			amount_needed_str = amount_needed_str..tostring(v.amount*100) .. "%"
		else
			amount_needed_str = amount_needed_str..tostring(v.amount)
		end
		amount_needed_str = amount_needed_str .. " " .. STRINGS.NAMES[string.upper(v.type)]
        local has = builder:HasCharacterIngredient(v)
        local ing = self.root:AddChild(IngredientUI(v:GetAtlas(), v:GetImage(), nil, nil, has, amount_needed_str, self.owner, v.type))
		ing:SetScale(ing_scale, ing_scale, 1)
        if GetGameModeProperty("icons_use_cc") then
            ing.ing:SetEffect("shaders/ui_cc.ksh")
        end
		table.insert(self.ingredient_widgets, ing)
	end
	local xoff = (#self.ingredient_widgets-1) * (ing_width/2)
	for i, v in pairs(self.ingredient_widgets) do
		v:SetPosition(ing_offset-xoff+(ing_width*(i-1)), 0)
	end
end

function FR_Entry:GetHelpText()
	return "HELPTEXT"
end

return FR_Entry