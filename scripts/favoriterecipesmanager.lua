local savefilepath = "favrecipes"

local FavoriteRecipesManager = Class(function(self)
	self.favorites = {}
	
	self:Load()
end)

function FavoriteRecipesManager:IsFavorited(recipe, skin)
	for k, v in pairs(self.favorites) do
		if v[1] == recipe and v[2] == skin then
			return true, k
		end
	end
	return false, -1
end

function FavoriteRecipesManager:AddFavorite(recipe, skin)
	if self:IsFavorited(recipe, skin) then return end
	table.insert(self.favorites, {recipe, skin})
	self:PushWidgetUpdate()
	self:Save()
end

function FavoriteRecipesManager:RemoveFavorite(recipe, skin)
	local found, index = self:IsFavorited(recipe, skin)
	if found then
		table.remove(self.favorites, index)
	end
	self:PushWidgetUpdate()
	self:Save()
end

function FavoriteRecipesManager:ToggleFavorite(recipe, skin)
	if self:IsFavorited(recipe, skin) then
		self:RemoveFavorite(recipe, skin)
		return false
	else
		self:AddFavorite(recipe, skin)
		return true
	end
end

function FavoriteRecipesManager:PushWidgetUpdate()
	if ThePlayer ~= nil then
		ThePlayer.HUD.controls.favrecipes:UpdateList()
	end
end

function FavoriteRecipesManager:Save()
	local savedata = {}
	for k, v in pairs(self.favorites) do
	if v[1] and v[1].name and v[2] then
		table.insert(savedata, {v[1].name, v[2]})
	end
	local str = json.encode(savedata) 
	ErasePersistentString(savefilepath, function() end)
	TheSim:SetPersistentString(savefilepath, str, false, function() end) 
	end
end

function FavoriteRecipesManager:Load()
	local savedata = {}
	TheSim:CheckPersistentStringExists(savefilepath, function(exists) 
		if exists then 
			TheSim:GetPersistentString(savefilepath, function(success, str) 
				savedata = json.decode(str) 
			end) 
		end 
	end)
	for k, v in pairs(savedata) do
		self:AddFavorite(AllRecipes[v[1]], v[2])
	end
end

FavRecipeManager = FavoriteRecipesManager()