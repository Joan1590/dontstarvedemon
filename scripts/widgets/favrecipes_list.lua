local Widget = require "widgets/widget"
local Image = require "widgets/image"
local TEMPLATES = require "widgets/redux/templates"
local FR_Entry = require "widgets/favrecipes_entry"

local update_events = { "healthdelta", "sanitydelta", "techtreechange", "itemget", "itemlose", "newactiveitem", "stacksizechange", "unlockrecipe", "refreshcrafting", "refreshinventory"}
local onupdaterecipes

local FR_List = Class(Widget, function(self, owner)
    Widget._ctor(self, "FR_List")
	self.owner = owner
   
	self.root = self:AddChild((TEMPLATES.RectangleWindow(180, 255)))
	self.root:SetClickable(false)
	
	self.scroll_list = self:AddChild(self:_BuildSaveSlotList())
    self.scroll_list:SetPosition(-13, 0)
	
	function onupdaterecipes()
		self:UpdateRecipes()
	end
	for k, v in pairs(update_events) do
		owner:ListenForEvent(v, onupdaterecipes)
	end
end)

function FR_List:_BuildSaveSlotList()

	local function ScrollWidgetsCtor(context, index)
		local widget = FR_Entry(self.owner)
		widget.ongainfocusfn = function(is_btn_enabled)
            self.scroll_list:OnWidgetFocus(widget)
        end
		return widget
    end

	local function ScrollWidgetApply(context, widget, data, index)
		if data then
			widget.root:Show()
			widget:SetRecipe(data[1], data[2])
		else
			widget.root:Hide()
		end
    end

    self.items = FavRecipeManager.favorites
	
    local row_w = 250
    local row_h = 40
    local row_spacing = 5
    local scrollbar_offset = 0

	local extra_rows = nil
	
    local grid = TEMPLATES.ScrollingGrid(
        self.items,
        {
            context = {},
            widget_width  = row_w,
            widget_height = row_h+row_spacing,
            num_visible_rows = 5,
            num_columns      = 1,
            item_ctor_fn = ScrollWidgetsCtor,
            apply_fn     = ScrollWidgetApply,
            scrollbar_offset = scrollbar_offset,
            scrollbar_height_offset = -50,
			extra_rows = extra_rows,
        })
    
	local grid_onfocusmove_old = grid.OnFocusMove
	grid.OnFocusMove = function(self, dir, down, ...)
		if not TheInput:ControllerAttached() then
			return
		end
		return grid_onfocusmove_old(self, dir, down, ...)
	end
    return grid
end
function FR_List:UpdateList()
	self.scroll_list:SetItemsData(FavRecipeManager.favorites)
end
function FR_List:UpdateRecipes()
	--self.scroll_list:RefreshView()
	--well, RefreshView messes with the scroll so i need to do this manually...
	local start_index, row_offset = self.scroll_list:GetIndexOfFirstVisibleWidget()
	for i = 1,self.scroll_list.items_per_view do 
        self.scroll_list.update_fn(self.scroll_list.context, self.scroll_list.widgets_to_update[i], self.scroll_list.items[start_index + i], start_index + i )
		self.scroll_list.widgets_to_update[i]:Show()
	end
	self.scroll_list.list_root:SetPosition( 0, row_offset * self.scroll_list.row_height, 0 )
end

function FR_List:Kill()
	for k, v in pairs(update_events) do
		self.owner:RemoveEventCallback(v, onupdaterecipes)
	end
end

return FR_List