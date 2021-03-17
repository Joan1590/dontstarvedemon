AddClassPostConstruct("widgets/crafting", function(self)
    local _G = GLOBAL
    local TheInput = _G.TheInput
    local IsPaused = _G.IsPaused
    local TheFocalPoint = _G.TheFocalPoint

    local function fn(self, down)
        if not IsPaused() then
            local oldidx = self.idx
            self.idx = down and -1 or #self.valid_recipes - (self.max_slots - 1)
            self:UpdateRecipes()
            if self.idx ~= oldidx then
                TheFocalPoint.SoundEmitter:PlaySound("dontstarve/HUD/craft_down")
            end
        end
    end

--    local DownButtonClickFunction = self.downbutton.onclick
--    self.downbutton:SetOnClick(function()
--        if TheInput:IsKeyDown(_G["KEY_LSHIFT"]) then
--            fn(self, true)
--            return
--        end
--        DownButtonClickFunction()
--    end)
--
--    local UpButtonClickFunction = self.upbutton.onclick
--    self.upbutton:SetOnClick(function()
--        if TheInput:IsKeyDown(_G["KEY_LSHIFT"]) then
--            fn(self, false)
--            return
--        end
--        UpButtonClickFunction()
--    end)

    local Crafting_ScrollDown = self.ScrollDown
    self.ScrollDown = function(self)
        Crafting_ScrollDown(self)
        if TheInput:IsKeyDown(_G["KEY_LSHIFT"]) then
            fn(self, true)
        end
    end
    local Crafting_ScrollUp = self.ScrollUp
    self.ScrollUp = function(self)
        Crafting_ScrollUp(self)
        if TheInput:IsKeyDown(_G["KEY_LSHIFT"]) then
            fn(self, false)
        end
    end
end)