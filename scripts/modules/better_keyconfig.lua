local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local PCKeyBindButton = require("widgets/pckeybindbutton")

ENV.AddClassPostConstruct("screens/redux/modconfigurationscreen", function(self, ...)
    local ApplyDataToWidget = self.options_scroll_list.update_fn
    self.options_scroll_list.update_fn = function(context, widget, data, idx, ...)
        local rt = ApplyDataToWidget(context, widget, data, idx, ...)
        if data == nil or data.is_header then
            if widget.keybind_btn then
                widget.keybind_btn:Hide()
            end
            return rt
        end
        local opt_data = data.option
        for _, v in ipairs(self.config) do
            if v.name == opt_data.name then
                if v.is_keylist then
                    local valid_keylist = {}
                    local can_no_toggle_key = false
                    for _, v in ipairs(opt_data.options) do
                        if type(v.data) == "string" then
                            if v.data == "no_toggle_key" then
                                can_no_toggle_key = true
                            elseif v.data:find("KEY_") then
                                table.insert(valid_keylist, v.data)
                            end
                        end
                    end
                    if widget.keybind_btn == nil then
                        widget.keybind_btn = widget:AddChild(PCKeyBindButton(valid_keylist, v.default, data.initial_value, can_no_toggle_key))
                        widget.focus_forward = widget.keybind_btn
                        widget.keybind_btn.change_val_fn = function(data)
                            self.options[widget.real_index].value = data
                            widget.opt.data.selected_value = data
                            self:MakeDirty()
                        end
                    end
                    widget.keybind_btn:Show()
                    widget.keybind_btn:SetValidKeylist(valid_keylist)
                    widget.keybind_btn.initial_value = data.initial_value
                    widget.keybind_btn.default = v.default
                    widget.keybind_btn.can_no_toggle_key = can_no_toggle_key
                    widget.keybind_btn:SetVal(data.selected_value)
                    widget.opt.spinner:Hide()
                elseif widget.keybind_btn then
                    widget.keybind_btn:Hide()
                end
                break
            end
        end
        return rt
    end
    self.options_scroll_list:RefreshView()
end)

-- UI, nightmare forever
