
local Image = GLOBAL.require "widgets/image"

local function fornew( self )
	self.fgimage = self:AddChild(Image("images/slot_locked.xml", "slot_locked.tex"))
	function self:Refresh(recipename)
		if GLOBAL.TheSim:GetGameID() == "DST" then
		recipename = recipename or self.recipename
		local recipe = GLOBAL.AllRecipes[recipename]
		local canbuild = self.owner.replica.builder:CanBuild(recipename)
		local knows = self.owner.replica.builder:KnowsRecipe(recipename)
		local buffered = self.owner.replica.builder:IsBuildBuffered(recipename)
		local do_pulse = self.recipename == recipename and not self.canbuild and canbuild
		self.recipename = recipename
		self.recipe = recipe
		self.recipe_skins = {}
    
			if self.recipe then
			self.recipe_skins = GLOBAL.Profile:GetSkinsForPrefab(self.recipe.name)
	
			self.canbuild = canbuild
			self.tile:SetRecipe(self.recipe)
			self.tile:Show()
			local right_level = GLOBAL.CanPrototypeRecipe(self.recipe.level, self.owner.replica.builder:GetTechTrees())

			if self.fgimage then
				if knows or recipe.nounlock then
					if self.isquagmireshop then
                    if canbuild or buffered then
                        self.bgimage:SetTexture(self.atlas, "craft_slot_locked_highlight.tex")
                    else
                        self.bgimage:SetTexture(self.atlas, "craft_slot.tex")
                    end
                    self.lightbulbimage:Hide()
                    self.fgimage:Hide()
                else
                    if buffered then
                        self.bgimage:SetTexture(self.atlas, "craft_slot_place.tex")
                    else
                        self.bgimage:SetTexture(self.atlas, "craft_slot.tex")
                    end
                    if canbuild or buffered then
                        self.fgimage:Hide()
                    else
                        self.fgimage:Show()
                        self.fgimage:SetTexture(self.atlas, "craft_slot_missing_mats.tex")
                    end
                    self.lightbulbimage:Hide()
                    self.fgimage:SetTint(1, 1, 1, 1)
                end
            else
                local show_highlight = false
                
                show_highlight = canbuild and right_level
                
                local hud_atlas = GLOBAL.resolvefilepath( "images/hud.xml" )
                
                if not right_level then
                    self.fgimage:SetTexture("images/locked_nextlevel.xml", "locked_nextlevel.tex")
					self.lightbulbimage:Hide()
                    self.fgimage:Show()
                    if buffered then 
                        self.bgimage:SetTexture(self.atlas, "craft_slot_place.tex") 
                    else
                        self.bgimage:SetTexture(self.atlas, "craft_slot.tex") 
                    end
                    self.fgimage:SetTint(.7,.7,.7,1)
                elseif show_highlight then
                    self.bgimage:SetTexture(hud_atlas, "craft_slot_locked_highlight.tex")
                    self.lightbulbimage:Show()
                    self.fgimage:Hide()
                    self.fgimage:SetTint(1,1,1,1)
                else
                    self.fgimage:SetTexture(hud_atlas, "craft_slot_missing_mats.tex")
                    self.lightbulbimage:Hide()
                    self.fgimage:Show()
                    if buffered then 
                        self.bgimage:SetTexture(self.atlas, "craft_slot_place.tex") 
                    else
                        self.bgimage:SetTexture(self.atlas, "craft_slot.tex") 
                    end
                    self.fgimage:SetTint(1,1,1,1)
                end
            end
        end

        self.tile:SetCanBuild((buffered or canbuild )and (knows or recipe.nounlock or right_level))

        if self.recipepopup then
            self.recipepopup:SetRecipe(self.recipe, self.owner)
			if self.focus and not self.open then
				self:Open()
			end
		end
    end
	else
		self.lightbulbimage = self:AddChild(Image("images/craft_slot_prototype.xml", "craft_slot_prototype.tex"))
		self.lightbulbimage:Hide()
		recipename = recipename or self.recipename
		local recipe =  GLOBAL.GetRecipe(recipename)
		local canbuild = self.owner.components.builder:CanBuild(recipename)
		local knows = self.owner.components.builder:KnowsRecipe(recipename)
		local buffered = self.owner.components.builder:IsBuildBuffered(recipename)
		local do_pulse = self.recipename == recipename and not self.canbuild and canbuild
		self.recipename = recipename
		self.recipe = recipe
		if self.recipe then
			self.canbuild = canbuild
			self.tile:SetRecipe(self.recipe)
			self.tile:Show()
			local right_level = GLOBAL.CanPrototypeRecipe(self.recipe.level, self.owner.components.builder.accessible_tech_trees)
			if self.fgimage then
				if knows or recipe.nounlock then
                    if buffered then
                        self.bgimage:SetTexture(self.atlas, "craft_slot_place.tex")
                    else
                        self.bgimage:SetTexture(self.atlas, "craft_slot.tex")
                    end
                    if canbuild or buffered then
                        self.fgimage:Hide()
                    else
                        self.fgimage:Show()
						self.fgimage:SetTexture("images/craft_slot_missing_mats.xml", "craft_slot_missing_mats.tex")
                    end
                    self.lightbulbimage:Hide()
                    self.fgimage:SetTint(1, 1, 1, 1)
            else
                local show_highlight = false
                
                show_highlight = canbuild and right_level
                
                local hud_atlas = GLOBAL.resolvefilepath( "images/hud.xml" )
                
                if not right_level then
                    self.fgimage:SetTexture("images/locked_nextlevel.xml", "locked_nextlevel.tex")
					self.lightbulbimage:Hide()
                    self.fgimage:Show()
                    if buffered then 
                        self.bgimage:SetTexture(self.atlas, "craft_slot_place.tex") 
                    else
                        self.bgimage:SetTexture(self.atlas, "craft_slot.tex") 
                    end
                    self.fgimage:SetTint(.7,.7,.7,1)
                elseif show_highlight then
                    self.bgimage:SetTexture("images/craft_slot_locked_highlight.xml", "craft_slot_locked_highlight.tex")
                    self.lightbulbimage:Show()
                    self.fgimage:Hide()
                    self.fgimage:SetTint(1,1,1,1)
                else
                    self.fgimage:SetTexture("images/craft_slot_missing_mats.xml", "craft_slot_missing_mats.tex")
                    self.lightbulbimage:Hide()
                    self.fgimage:Show()
                    if buffered then 
                        self.bgimage:SetTexture(self.atlas, "craft_slot_place.tex") 
                    else
                        self.bgimage:SetTexture(self.atlas, "craft_slot.tex") 
                    end
                    self.fgimage:SetTint(1,1,1,1)
                end
            end
        end
        self.tile:SetCanBuild((buffered or canbuild )and (knows or recipe.nounlock or right_level))

        if self.recipepopup then
            self.recipepopup:SetRecipe(self.recipe, self.owner)
				if self.focus and not self.open then
				self:Open()
			end
        end
    end	
	function self:Clear()
		self.recipename = nil
		self.recipe = nil
		self.canbuild = false
    
		if self.tile then
			self.tile:Hide()
		end
    
		self.fgimage:Hide()
		if self.lightbulbimage then
			self.lightbulbimage:Hide()
		end
		self.bgimage:SetTexture(self.atlas, "craft_slot.tex")
	end
	end
end
return self
end
AddClassPostConstruct( "widgets/craftslot", fornew)
local function fordddd(self)
	function self:SetCanBuild(canbuild)
		--no need anymore
	end
end
if GLOBAL.TheSim:GetGameID() == "DS" then
AddClassPostConstruct( "widgets/recipetile", fordddd)
end