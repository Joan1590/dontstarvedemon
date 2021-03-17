local G = GLOBAL
local unpack = G.unpack

local atlas = "images/favrecipesinventoryimages.xml"
local images = { "hermitcrab_icon.tex", "critterden.tex", "ruinsaltar.tex", "moonaltar.tex", "sculptingtable_lost.tex", "tacklestation_lost.tex" }
for k, v in pairs(images) do RegisterInventoryItemAtlas(atlas, v) end

require("favoriterecipesmanager")

local FAVRECIPES_UISCALE = TUNING.xiaoyao("uiscale")
local controlkey = G["KEY_"..TUNING.xiaoyao("listbind")]

local FR_List = require("widgets/favrecipes_list")
local ImageButton = require("widgets/imagebutton")
AddClassPostConstruct("widgets/controls", function(self, owner)
	self.favrecipes = self.topleft_root:AddChild(FR_List(owner))
	self.favrecipes:SetPosition(200*FAVRECIPES_UISCALE, -200*FAVRECIPES_UISCALE)
	self.favrecipes:SetScale(0,0,1)
end)

G.TheInput:AddKeyDownHandler(controlkey, function()
	local screen = G.TheFrontEnd:GetActiveScreen()
	if screen and G.ThePlayer and screen == G.ThePlayer.HUD and G.ThePlayer.HUD.controls.favrecipes.scale ~= 1 then
		G.ThePlayer.HUD.controls.favrecipes:ScaleTo(0,FAVRECIPES_UISCALE,0.3)
		G.ThePlayer.HUD.controls.favrecipes.scale = 1
	end
end)
G.TheInput:AddKeyUpHandler(controlkey, function()
	local screen = G.TheFrontEnd:GetActiveScreen()
	if screen and G.ThePlayer and screen == G.ThePlayer.HUD then
		G.ThePlayer.HUD.controls.favrecipes:ScaleTo(FAVRECIPES_UISCALE,0,0.3)
		G.ThePlayer.HUD.controls.favrecipes.scale = 0
	end
end)

AddClassPostConstruct("widgets/recipepopup", function(self, horizontal)
	local function UpdateFavoriteButton()
		local recipe = self.recipe
		if recipe == nil then
			self.favoritebutton:Hide()
			return
		else
			self.favoritebutton:Show()
		end
		local skin = self.recipe.product
		if #self.skins_options > 1 then
			skin = self.skins_spinner.GetItem()
		end
		if G.FavRecipeManager:IsFavorited(recipe, skin) then
			self.favoritebutton:SetTextures("images/global_redux.xml", "star_checked.tex", nil, "star_uncheck.tex", nil, nil, {0.75,0.75}, {0, 0})
		else
			self.favoritebutton:SetTextures("images/global_redux.xml", "star_uncheck.tex", nil, "star_checked.tex", nil, nil, {0.75,0.75}, {0, 0})
		end
	end
	local function OnFavoriteButton()
		local recipe = self.recipe
		if recipe == nil then return end
		local skin = self.recipe.product
		if #self.skins_options > 1 then
			skin = self.skins_spinner.GetItem()
		end
		G.FavRecipeManager:ToggleFavorite(recipe, skin)
		UpdateFavoriteButton()
	end
	self.favoritebutton = self.contents:AddChild(ImageButton())
	self.favoritebutton:SetPosition(225, -107, 0)
	self.favoritebutton:SetOnClick(OnFavoriteButton)
	UpdateFavoriteButton()
	
	local Refresh_old = self.Refresh
	function self:Refresh(...)
		local rtn = {Refresh_old(self, ...)}
		if self.favoritebutton ~= nil then self.favoritebutton:Kill() self.favoritebutton = nil end
		self.favoritebutton = self.contents:AddChild(ImageButton())
		self.favoritebutton:SetOnClick(OnFavoriteButton)
		if self.skins_spinner ~= nil then
			self.favoritebutton:SetPosition(225, -157, 0)
		else
			self.favoritebutton:SetPosition(225, -107, 0)
		end
		UpdateFavoriteButton()
		if self.button ~= nil then
			-- local builder = self.owner.replica.builder
			-- local tech_level = builder:GetTechTrees()
			-- local buffered = builder:IsBuildBuffered(self.recipe.name)
			-- local knows = builder:KnowsRecipe(self.recipe.name)
			-- local can_build = buffered or builder:CanBuild(self.recipe.name)
			-- local can_prototype = G.CanPrototypeRecipe(self.recipe.level, tech_level)
			--if knows or can_build or can_prototype then
			if self.button:IsVisible() then
				self.favoritebutton:Show()
			else
				self.favoritebutton:Hide()
			end
		else
			self.favoritebutton:Hide()
		end
		
		return unpack(rtn)
	end
	
	local MakeSpinner_old = self.MakeSpinner
	function self:MakeSpinner(...)
		local spinner_group = MakeSpinner_old(self, ...)
		local spinner_onchange_old = spinner_group.spinner.onchangedfn
		spinner_group.spinner:SetOnChangedFn(function(selected, old, ...)
			local rtn = {spinner_onchange_old(selected, old, ...)}
			UpdateFavoriteButton()
			return unpack(rtn)
		end)
		return spinner_group
	end
end)