local function MakeMapAlpha(self)
    if self.bg ~= nil then
	    self.bg:SetTint(0, 0, 0, GetModConfigData("map_alpha"))
	end
end

AddClassPostConstruct("widgets/mapwidget", MakeMapAlpha)