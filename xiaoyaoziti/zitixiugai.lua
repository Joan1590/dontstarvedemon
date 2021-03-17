local cn_scale = TUNING.xiaoyao("CHINESE_TEXT_SCALE")
local en_scale = TUNING.xiaoyao("ENGLISH_TEXT_SCALE")

GLOBAL.LOC.GetTextScale = function()
    if nil == GLOBAL.LOC.CurrentLocale then
        return en_scale
    elseif GLOBAL.LANGUAGE.CHINESE_S == GLOBAL.LOC.CurrentLocale.id then
        return cn_scale
    else
        return GLOBAL.LOC.CurrentLocale.scale
    end
end

AddClassPostConstruct("widgets/text", function(self)
	self.SetSize = function(self, sz)
        self.size = sz
        if GLOBAL.LOC then
            sz = sz * GLOBAL.LOC.GetTextScale()
        end
        self.inst.TextWidget:SetSize(sz)
	end
end)
