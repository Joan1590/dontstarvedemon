-- https://forums.kleientertainment.com/forums/topic/28665-tips-for-scripts/
--GLOBAL.CHEATS_ENABLED = true
--GLOBAL.require( 'debugkeys' )

function log(message)
  print('[CraftingVisibility] '..tostring(message))
end

local CraftSlot = GLOBAL.require "widgets/craftslot"
local Image = GLOBAL.require "widgets/image"
GLOBAL.require "widgets/widgetutil"

local slotAtlas = 'images/slots.xml'
local iconAtlas = 'images/icons.xml'


-- for key,value in pairs(GLOBAL.EQUIPSLOTS) do print('4r',key,value) end
AddGlobalClassPostConstruct("widgets/craftslot", "CraftSlot", function()

  local CraftSlot_Refresh_base = CraftSlot.Refresh or function() return "" end
  local CraftSlot_Clear_base = CraftSlot.Clear or function() return "" end

  function CraftSlot:CraftingVisibilitySetBackground(name)
    self.bgimage:SetTexture(slotAtlas, name)
  end

  function CraftSlot:CraftingVisibilitySetIcon(name)
    self.craftingVisibilityIcon:SetTexture(iconAtlas, name)
    self.craftingVisibilityIcon:Show()
  end

  function CraftSlot:SetCraftabilityMissingMaterials()
    self:CraftingVisibilitySetBackground("craft_slot_missing_mats.tex")
    self:CraftingVisibilitySetIcon("rocks.tex")
  end

  function CraftSlot:SetCraftabilityUpgradeNeeded()
    self:CraftingVisibilitySetBackground("craft_slot_locked_nextlevel.tex")
    self:CraftingVisibilitySetIcon("arrow.tex")
  end

  function CraftSlot:SetCraftabilityReadyToBuild()
    self:CraftingVisibilitySetBackground("craft_slot.tex")
    self:CraftingVisibilitySetIcon("checkmark.tex")
  end

  function CraftSlot:SetCraftabilityReadyToPrototype()
    self:CraftingVisibilitySetIcon("lightbulb.tex")
    if self:CraftingVisibilityIsDST() then
      self.lightbulbimage:Hide()
    end
  end

  function CraftSlot:SetCraftabilityBuffered()
    self.bgimage:SetTexture(self.atlas, "craft_slot_place.tex")
  end

  function CraftSlot:ResetCraftabilityIcon()
    self.craftingVisibilityIcon:Hide()
  end

  function CraftSlot:CraftingVisibilityIsDST()
    return self.owner.replica ~= nil
  end

  function CraftSlot:CraftingVisibilityBuilder()
    if self:CraftingVisibilityIsDST() then
      return self.owner.replica.builder
    else
      return self.owner.components.builder
    end
  end

  function CraftSlot:CraftingVisibilityTechTrees()
    if self:CraftingVisibilityIsDST() then
      return self:CraftingVisibilityBuilder():GetTechTrees()
    else
      return self:CraftingVisibilityBuilder().accessible_tech_trees
    end
  end

  function CraftSlot:CraftingVisibilityRefresh(self, recipename)
    recipename = recipename or self.recipename

    if self.recipe then
      self.fgimage:Hide()

      local builder = self:CraftingVisibilityBuilder()
      local canbuild = builder:CanBuild(recipename)
      local knows = builder:KnowsRecipe(recipename)
      local buffered = builder:IsBuildBuffered(recipename)
      local right_level = GLOBAL.CanPrototypeRecipe(self.recipe.level, self:CraftingVisibilityTechTrees())

      if self.craftingVisibilityIcon == nil then
        self.craftingVisibilityIcon = self:AddChild(Image(iconAtlas, "checkmark.tex"))
        self.craftingVisibilityIcon:SetScale(0.35, 0.35)
        self.craftingVisibilityIcon:SetPosition(-32, 15)
      else
        self:ResetCraftabilityIcon()
      end


      if not self:CraftingVisibilityIsDST() then
        self.tile:SetCanBuild(true)
      end

      if buffered then
        self:SetCraftabilityBuffered()
      else
        if knows or self.recipe.nounlock then
          if canbuild then
            -- Buildable
            self:SetCraftabilityReadyToBuild()
          else
            -- Missing materials
            self:SetCraftabilityMissingMaterials()
          end
        else
          if not right_level then
            -- Needs upgraded technology
            self:SetCraftabilityUpgradeNeeded()
          elseif canbuild and right_level then
            -- Ready to prototype
            self:SetCraftabilityReadyToPrototype()
          else
            -- Missing materials
            self:SetCraftabilityMissingMaterials()
          end
        end
      end
    end
  end

  function CraftSlot:Refresh(recipename)
    CraftSlot_Refresh_base(self, recipename)
    CraftSlot:CraftingVisibilityRefresh(self, recipename)
  end

  function CraftSlot:CraftingVisibilityClear(self)
    if self.craftingVisibilityIcon then
      self.craftingVisibilityIcon:Hide()
    end
  end

  function CraftSlot:Clear()
    CraftSlot_Clear_base(self)
    CraftSlot:CraftingVisibilityClear(self)
  end
end)

