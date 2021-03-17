local template = GLOBAL.require('widgets/redux/templates')
local ModListItem = template.ModListItem
template.ModListItem = function(onclick_btn, onclick_checkbox, onclick_setfavorite)
    local opt = ModListItem(onclick_btn, onclick_checkbox, onclick_setfavorite)
    opt.SetMod = function(_, modname, modinfo, modstatus, isenabled, isfavorited)
        if modinfo and modinfo.icon_atlas and modinfo.icon then
            opt.image:SetTexture(modinfo.icon_atlas, modinfo.icon)
        else
            opt.image:SetTexture("images/ui.xml", "portrait_bg.tex")
        end
        
        opt.image:SetSize(70,70)

      
        local nameStr = ((modinfo and modinfo.name) and modinfo.name or modname) .. "\n" .. modname
        opt.name:SetSize(20)
        opt.name:SetHAlign(GLOBAL.ANCHOR_LEFT)
        opt.name:SetMultilineTruncatedString(nameStr, 2, 800)
     

        local w, h = opt.name:GetRegionSize()
        opt.name:SetPosition(w * .5 - 75, 17, 0)

        opt:SetModStatus(modstatus)
        opt:SetModEnabled(isenabled)
        opt:SetModFavorited(isfavorited)
    end
    return opt
end