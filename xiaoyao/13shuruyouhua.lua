--[[ Chat Shortcut Manager]]--

local _G = GLOBAL
local require = _G.require
local TheSim = _G.TheSim
local TheNet = _G.TheNet
local TheWorld = _G.TheWorld
local TheInventory = _G.TheInventory

local WordPredictor = require "util/wordpredictor"
local PersistentData = require "persistentshortcutdata"
local ShortcutData = PersistentData("Chat Shortcut Manager")

local consoletext_Hidden = false

-- wordpredictionwidget.lua ----------------------------------------

local Button = require "widgets/button"
local Image = require "widgets/image"

local FONT_SIZE = 22
local PADDING = 10

local TEXT_COLORS = {
	{1  ,.75,.15,1},
	{1  ,1  ,1  ,1},
	{1  ,0  ,0  ,1},
	{0  ,1  ,0  ,1},
	{0  ,0  ,1  ,1},
	{1  ,1  ,0  ,1},
	{1  ,0  ,1  ,1},
	{0  ,1  ,1  ,1},
	{0.5,0.5,0.5,1},
}

-- Display more colors & more lines
-- Allow the usage of Up & Down
local function WordPredictionWidgetTweaks(self)
	function self:RefreshPredictions()
		local prev_active_prediction = self.active_prediction_btn ~= nil and self.prediction_btns[self.active_prediction_btn].name or nil

		self.word_predictor:RefreshPredictions(self.text_edit:GetString(), self.text_edit.inst.TextEditWidget:GetEditCursorPos())

		self.prediction_btns = {}
		self.prediction_x = {} -- New
		self.prediction_row = {} -- New
		self.active_prediction_btn = nil
		self.prediction_root:KillAllChildren()

		if self.word_predictor.prediction ~= nil then
			self:Show()
			self:Enable()

			local prediction = self.word_predictor.prediction
			local offset_x = self.starting_offset
			local offset_y = 0
			local x_max = 0
			local rows = TUNING.xiaoyao("maxRows")

			-- Different colors
			local color_clickable = TUNING.xiaoyao("colorunselected") ~= 0 and TEXT_COLORS[TUNING.xiaoyao("colorunselected")] or UICOLOURS.GOLD_CLICKABLE
			local color_selected  = TUNING.xiaoyao("colorselected")   ~= 0 and TEXT_COLORS[TUNING.xiaoyao("colorselected")]   or UICOLOURS.GOLD_FOCUS

			for i, v in ipairs(prediction.matches) do
				local str = self.word_predictor:GetDisplayInfo(i)

				local btn = self.prediction_root:AddChild(Button())
				btn:SetFont(_G.CHATFONT)
				btn:SetDisabledFont(_G.CHATFONT)
				btn:SetTextColour(color_clickable)
				btn:SetTextFocusColour(color_clickable)
				btn:SetTextSelectedColour(color_selected)
				btn:SetText(str)
				btn:SetTextSize(FONT_SIZE)
				btn.clickoffset = _G.Vector3(0,0,0)

				btn.bg = btn:AddChild(Image("images/ui.xml", "blank.tex"))
				--btn.bg = btn:AddChild(Image("images/global.xml", "square.tex"))
				local w,h = btn.text:GetRegionSize()
				btn.bg:ScaleToSize(w, h)
				btn.bg:SetPosition(0,0)
				btn.bg:MoveToBack()

				btn:SetOnClick(function() if self.active_prediction_btn ~= nil then self.text_edit:ApplyWordPrediction(self.active_prediction_btn) end end)
				btn:SetOnSelect(function() if self.active_prediction_btn ~= nil and self.active_prediction_btn ~= i then self.prediction_btns[self.active_prediction_btn]:Unselect() end self.active_prediction_btn = i end)
				btn.ongainfocus = function() btn:Select() end
				btn.AllowOnControlWhenSelected = true
				
				if self:IsMouseOnly() then
					btn.onlosefocus = function() if btn.selected then btn:Unselect() self.active_prediction_btn = nil end end
				end

				-- More lines
				local sx, sy = btn.text:GetRegionSize()
				if offset_x + sx > self.max_width then
					x_max = math.max(offset_x,x_max)
					rows = rows-1
					if rows <= 0 then
						btn:Kill()
						break
					end
					offset_x = self.starting_offset
					offset_y = offset_y + sy + PADDING
				end
				btn:SetPosition(sx * 0.5 + offset_x, offset_y)
				table.insert(self.prediction_x, offset_x + sx/2)
				table.insert(self.prediction_row, rows)
				table.insert(self.prediction_btns, btn)
				offset_x = offset_x + sx + PADDING
				if prev_active_prediction ~= nil and btn.name == prev_active_prediction then
					self.active_prediction_btn = i
				end
			end

			if TUNING.xiaoyao("maxRows") - rows >= 1 then -- New: To make reading shortcuts easier
				if TheFrontEnd.consoletext.shown and not consoletext_Hidden then
					TheFrontEnd.consoletext:Hide()
					consoletext_Hidden = true
				end
			else
				if not TheFrontEnd.consoletext.shown and consoletext_Hidden then
					TheFrontEnd.consoletext:Show()
					consoletext_Hidden = false
				end
			end

			if self:IsMouseOnly() then
				self.active_prediction_btn = nil
			else
				self.prediction_btns[self.active_prediction_btn or 1]:Select()
			end
			x_max = math.max(offset_x,x_max)
			self.backing:SetSize(x_max, self.sizey + 4 + offset_y)
			self.backing:SetPosition(-5, offset_y/2)
		else
			if not TheFrontEnd.consoletext.shown and consoletext_Hidden then
				TheFrontEnd.consoletext:Show()
				consoletext_Hidden = false
			end

			self:Hide()
			self:Disable()
		end
	end

	function self:OnRawKey(key, down)
--		print(key, down)
		if key == _G.KEY_BACKSPACE or key == _G.KEY_DELETE then
			self.active_prediction_btn = nil
			self:RefreshPredictions()
			return false  -- do not consume the key press
		elseif self.word_predictor.prediction ~= nil then
--			print(key, down)
--			print(self.active_prediction_btn,self.prediction_btns[self.active_prediction_btn])
			if key == _G.KEY_TAB then
				return self.tab_complete
			elseif key == _G.KEY_ENTER then
				return self.enter_complete
			elseif key == _G.KEY_LEFT and not self:IsMouseOnly() then
				if down and self.active_prediction_btn > 1 then
					self.prediction_btns[self.active_prediction_btn - 1]:Select()
				end
				return true
			elseif key == _G.KEY_RIGHT and not self:IsMouseOnly() then
				if down and self.active_prediction_btn < #self.prediction_btns then
					self.prediction_btns[self.active_prediction_btn + 1]:Select()
				end
				return true
			elseif (key == _G.KEY_UP or key == _G.KEY_DOWN) and not self:IsMouseOnly() then -- New key
				if down then
					local diff = -1
					local toselect = -1
					local direction = key == _G.KEY_UP and 1 or -1
					local selected = self.active_prediction_btn + direction
					while selected > 0 and selected <= #self.prediction_btns do
						if self.prediction_row[selected] == self.prediction_row[self.active_prediction_btn] - direction then
							local new_diff = math.abs(self.prediction_x[selected] - self.prediction_x[self.active_prediction_btn])
							if diff == -1 or diff > new_diff then
								diff = new_diff
								toselect = selected
							else
								break
							end
						elseif self.prediction_row[selected] ~= self.prediction_row[self.active_prediction_btn] then
							break
						end
						selected = selected + direction
					end
					if toselect ~= -1 then
						self.prediction_btns[toselect]:Select()
					end
				end
				return true
			elseif key == _G.KEY_ESCAPE then
				return true
			end
		end
		return false
	end

	function self:Dismiss()
		if not TheFrontEnd.consoletext.shown and consoletext_Hidden then
			TheFrontEnd.consoletext:Show()
			consoletext_Hidden = false
		end

		self.word_predictor:Clear()

		self.prediction_btns = {}
		self.prediction_x = {}
		self.prediction_row = {}
		self.active_prediction_btn = nil
		self.prediction_root:KillAllChildren()

		self:Hide()
		self:Disable()
	end

end
AddClassPostConstruct("widgets/wordpredictionwidget", WordPredictionWidgetTweaks)

-- wordpredictor.lua ----------------------------------------

local function WordPredictorTweaks(self)
	local function _find_prediction_start(dictionaries, text, cursor_pos)
		local prediction = nil

		local pos = cursor_pos
		while (pos > 0) do
			for _, dic in ipairs(dictionaries) do
				local pos_char = text:sub(pos - (#dic.delim-1), pos)
				local ignoreCase = dic.adjust_case == true or TUNING.xiaoyao("ignoreCase")

				if pos_char == nil or #pos_char ~= #dic.delim or pos_char:sub(-1) == HARD_DELIM then
					break
				end

				local num_chars_for_prediction = dic.num_chars or 2

				if pos_char == dic.delim then
					if cursor_pos - pos >= num_chars_for_prediction then
						local pre_pos_char = (dic.skip_pre_delim_check or pos == 1) and HARD_DELIM or text:sub(pos-#dic.delim, pos-#dic.delim)
						if pre_pos_char == HARD_DELIM or pre_pos_char == dic.delim or not string.match(pre_pos_char, "[a-zA-Z0-9]") then -- Note: the character range checking is here so I don't have to write crazy pairing of ':' to determin if the current one is the end of another word
							local search_text = text:sub(pos + 1, cursor_pos)
							local matches = {}
							for _, word in ipairs(dic.words) do
								local index
						-- This >>>
								if ignoreCase then
									index = word:lower():find(search_text:lower(), 1, true)  -- <<< This is literally the only line I had to change to make the whole "Ignore Case" work!
								else
									index = word:find(search_text, 1, true)
								end
								if index ~= nil then
									table.insert(matches, {i = index, word = word})
								end
							end
							if dic.postfix == "" and #matches == 1 then
								-- if we only have one match and its the full text of the word then then remove it so pressing enter doesnt have to happen twice during chat
								-- this check is only needed if there is no post fix, otherwise typing the post fix will dismiss the prediction
								if matches[1].word == search_text then
									matches = {}
								end
							end
							if #matches > 0 then
								prediction = {}
								prediction.start_pos = pos
								prediction.matches = matches
								prediction.dictionary = dic
							end
						end
					end				
					break
				end
			end
			if prediction ~= nil then
				break
			end
			pos = pos - 1
		end

		if prediction ~= nil then
			local matches = prediction.matches
			table.sort(matches, function(a, b) return (a.i == b.i and a.word < b.word) or a.i < b.i end)

			prediction.matches = {}
			for _, v in ipairs(matches) do 
				table.insert(prediction.matches, v.word)
			end

			local str = ""
			for _, v in ipairs(prediction.matches) do str = str .. ", " .. v end
		end
		return prediction
	end

	-- Nothing changed here... obviously...
	function self:RefreshPredictions(text, cursor_pos)
		self.cursor_pos = cursor_pos
		self.text = text

		self.prediction = _find_prediction_start(self.dictionaries, text, cursor_pos)
	end

	-- New functions implemented
	function self:Apply(prediction_index)
		local new_text = nil
		local new_cursor_pos = nil
		if self.prediction ~= nil then
			local index = math.clamp(prediction_index or 1, 1, #self.prediction.matches)
			local new_word = self.prediction.matches[index]
			local postfix = ""

			if self.prediction.dictionary.translate and self.prediction.dictionary.translate[new_word] then -- if "translate" is set then the result will be changed into another result
				new_word = self.prediction.dictionary.translate[new_word]
			else
				postfix = self.prediction.dictionary.postfix
			end
				if self.prediction.dictionary.adjust_case then -- if "adjust_case" is true, then the case will be lowered if the first letter is lower case
				local pos = self.prediction.start_pos + #self.prediction.dictionary.delim
				local c = self.text:sub(pos,pos)
				if c:upper() ~= c then
					new_word = new_word:lower()
				end
			end

			if self.prediction.dictionary.remove_delim and self.prediction.dictionary.delim then
				new_text = self.text:sub(1, self.prediction.start_pos - #self.prediction.dictionary.delim) .. new_word .. postfix
			else
				new_text = self.text:sub(1, self.prediction.start_pos) .. new_word .. postfix
			end
--			new_text = self.text:sub(1, self.prediction.start_pos) .. new_word .. self.prediction.dictionary.postfix
			new_cursor_pos = #new_text 

			local remainder_text = self.text:sub(self.cursor_pos + 1, #self.text) or ""
			local remainder_strip_pos = remainder_text:find("[^a-zA-Z0-9]") or (#remainder_text + 1)
			if postfix ~= "" and remainder_text:sub(remainder_strip_pos, remainder_strip_pos + (#postfix-1)) == postfix then
				remainder_strip_pos = remainder_strip_pos + #postfix
			end

			new_text = new_text .. remainder_text:sub(remainder_strip_pos)
		end

		if not TheFrontEnd.consoletext.shown and consoletext_Hidden then -- Also new
			TheFrontEnd.consoletext:Show()
			consoletext_Hidden = false
		end

		self:Clear()
		return new_text, new_cursor_pos
	end
end
AddClassPostConstruct("util/wordpredictor", WordPredictorTweaks)

-- Prediction Dictionaries ----------------------------------------

-- Players
local function GetPlayerPredictionDictionary()
	local players = {}
--	local players = {"Charles","David","James","John","Michael","Richard","Robert","William"}
	if TheNet:GetClientTable() then -- In case of if you open it in the main menu
		for i, v in ipairs(TheNet:GetClientTable()) do
			if v.name ~= "[Host]" then
				table.insert(players, v.name)
			end
		end
	end
	local data = {
		words = players,
		delim = TUNING.xiaoyao("playerDelim"),
		num_chars = TUNING.xiaoyao("playerNumChars"),
		remove_delim = true,
--		remove_delim = TUNING.xiaoyao("playerRemoveDelim"),
	}
	data.GetDisplayString = function(word) return data.delim..word end
	return data
end

-- Objects
local object_names = {}
local function GetObjectPredictionDictionary()
	if #object_names == 0 then
		local names = {}
		local exists = {}
		for i, v in pairs(_G.STRINGS.NAMES) do
			if type(v) == "string" then
				local s = string.gsub(v,"\n"," ")
				if exists[s] == nil then
					table.insert(names, TUNING.xiaoyao("objectLowerCase") == true and s:lower() or s)
					exists[s] = true
				end
			end
		end
		object_names = names
	end
	local data = {
		words = object_names,
		delim = TUNING.xiaoyao("objectDelim"),
		num_chars = TUNING.xiaoyao("objectNumChars"),
		remove_delim = true,
--		remove_delim = TUNING.xiaoyao("objectRemoveDelim"),
		adjust_case = TUNING.xiaoyao("objectLowerCase") == "adjust",
	}
	data.GetDisplayString = function(word) return data.delim..word end
	return data
end

-- Prefabs
local prefab_names = {}
local prefab_toPrefab = {}
local function GetPrefabPredictionDictionary()
	if #prefab_names == 0 or #prefab_toPrefab == 0 then
		local names = {}
		local toPrefab = {}
		-- Using "PrefabExists" would have worked too
		for v, _ in pairs(_G.Prefabs) do
			local s = _G.STRINGS.NAMES[v:upper()]
			if type(s) == "string" then
				s = string.gsub(s,"\n"," ")
				local num = 2
				while toPrefab[s] ~= nil do
					if num == 2 then
						s = s.." ("..num..")"
					else
						s = s:sub(1,#s-3-#tostring(num)).." ("..num..")"
					end
					num = num + 1
				end
				table.insert(names, s)
				toPrefab[s] = "\""..v.."\""
			end
		end
		prefab_names = names
		prefab_toPrefab = toPrefab
	end
	local data = {
		words = prefab_names,
		translate = prefab_toPrefab,
		delim = TUNING.xiaoyao("prefabDelim"),
		num_chars = TUNING.xiaoyao("prefabNumChars"),
		remove_delim = true,
	}
	data.GetDisplayString = function(word) return data.delim..word end
	return data
end

-- Emojis
local Emoji = require("util/emoji")
local UserCommands = require("usercommands")

local function GetAllowedEmojiNames(userid)
    local has_ownership = nil
    if TheWorld ~= nil and userid ~= nil and TheWorld.ismastersim then
        has_ownership = function(item_type) return TheInventory:CheckClientOwnership(userid, item_type) end
    elseif userid == TheNet:GetUserID() then
        has_ownership = function(item_type) return TheInventory:CheckOwnership(item_type) end
    else
        return {}
    end

    local emoji_translator = {}
    local allowed_emoji = {}
    for item_type,emoji in pairs(_G.EMOJI_ITEMS) do
        if has_ownership(item_type) then
            emoji_translator[emoji.input_name] = emoji.data.utf8_str
            table.insert(allowed_emoji, emoji.input_name)
        end
    end
    return allowed_emoji, emoji_translator
end

-- Personal
AddUserCommand("shortcut", {
	aliases = {"sc"},
	prettyname = "Save a shortcut",
	desc = "Saves the shortcut [name] in your data"..(TUNING.xiaoyao("personalDelim") and " which can be called with \""..TUNING.xiaoyao("personalDelim").."[name]\" + Tab/Enter." or ".").."\nThe resulting text needs to be written after [name].\nIf you leave the text after [name] blank, then the shortcut will be removed instead.",
	permission = _G.COMMAND_PERMISSION.USER,
	slash = true,
	usermenu = false,
	servermenu = false,
	params = {"name"},
	paramsoptional = {false},
	vote = false,
	localfn = function(params, caller)
		local name = params.name:lower()
		local chatqueue = _G.ThePlayer.HUD.controls.networkchatqueue
		local persistentdata = ShortcutData:Load()
		if params.rest == nil then
			if persistentdata[name] ~= nil then
				ShortcutData:SetPersistent(name,nil)
				chatqueue:DisplaySystemMessage("Shortcut \""..name.."\" has been removed from your list.")
			else
				chatqueue:DisplaySystemMessage("Shortcut \""..name.."\" is not available in your list.")
			end
		else
			if persistentdata[name] == nil then
				ShortcutData:SetPersistent(name,params.rest)
				chatqueue:DisplaySystemMessage("Shortcut \""..name.."\" has been added to your list.")
			else
				chatqueue:DisplaySystemMessage("Shortcut \""..name.."\" is already used.")
			end
		end
	end,
})

local function normalizeName(name)
	local new_name = name:lower()
	new_name = string.gsub(new_name," ","")
	new_name = string.gsub(new_name,"\n","")
	new_name = string.gsub(new_name,"\t","")
	return new_name
end

local function displayableText(text)
	local new_text = text
	new_text = string.gsub(new_text,"\\","\\\\")
	new_text = string.gsub(new_text,"\"","\\\"")
	new_text = string.gsub(new_text,"\n","\\n")
	new_text = string.gsub(new_text,"\t","\\t")
	return new_text
end

-- Saves or deletes a shortcut in your data.
_G.c_shortcut = function(name,text)
	if not name or name == "" then
		print("Error: No shortcut name declared.")
		print("\tc_shortcut(name,text):")
		print("\t\tname: The name of your shortcut")
		print("\t\ttext: The text which results if you select your shortcut and press Tab or Enter")
		return false
	end
	local lowname = normalizeName(name)
--	local lowname = string.gsub(name:lower()," ","")
	local persistentdata = ShortcutData:Load()
	if text == nil then
		if persistentdata[lowname] ~= nil then
			print("Removed c_shortcut(\""..lowname.."\", \""..displayableText(persistentdata[lowname]).."\") from your list")
			ShortcutData:SetPersistent(lowname,nil)
			return true
		else
			print("\""..lowname.."\" is not available in your list")
		end
	else
		if persistentdata[lowname] == nil then
			print("Added c_shortcut(\""..lowname.."\", \""..displayableText(text).."\") to your list")
			ShortcutData:SetPersistent(lowname,text)
			return true
		else
			print("c_shortcut(\""..lowname.."\", \""..displayableText(persistentdata[lowname]).."\") is already used")
		end
	end
	return false
end

-- Lists all the shortcuts in your data.
_G.c_shortcutlist = function()
	local persistentdata = ShortcutData:Load()
	local count = 0
	print("Available Shortcuts:")
	for i,v in pairs(persistentdata) do
		print("	c_shortcut(\""..i.."\", \""..displayableText(v).."\")")
		count = count + 1
	end
	print("Total: "..count)
	return true
end

-- Removes all the shortcuts in your data. Requires confirmation. 
_G.c_shortcutclear = function(confirm)
	local persistentdata = ShortcutData:Load()
	local count = 0
	for i,v in pairs(persistentdata) do
		count = count + 1
	end
	if count == 0 then
		print("No shortcuts available to remove from your list.")
	elseif confirm == count then
		local todelete = {}
		for i,v in pairs(persistentdata) do
			table.insert(todelete, i)
		end
		for i,v in pairs(todelete) do
			print("	Removing c_shortcut(\""..v.."\", \""..displayableText(persistentdata[v]).."\")")
			ShortcutData:SetValue(v,nil)
		end
		ShortcutData:Save()
		print("All shortcuts had been successfully removed from your list.")
	else
		print("Warning: Using this function will remove all your shortcuts from your list!")
		print("Are you sure you want to continue? If so then confirm with \"c_shortcutclear("..count..")\"")
	end
	return true
end

local function GetPersonalPredictionDictionary()
	local persistentdata = ShortcutData:Load()
	local names = {}
	local toShortcut = {}
	if persistentdata ~= nil then
		for n, t in pairs(persistentdata) do
			table.insert(names, n)
			toShortcut[n] = t
		end
	end
	local data = {
		words = names,
		translate = toShortcut,
		delim = TUNING.xiaoyao("personalDelim"),
		num_chars = TUNING.xiaoyao("personalNumChars"),
		remove_delim = true,
	}
	data.GetDisplayString = function(word) return data.delim..word end
	return data
end

-- Chat Screens ----------------------------------------

function ChatInputScreenPostInit(_self)
	_self.chat_edit.prediction_widget = nil -- Reset
	_self.chat_edit:EnableWordPrediction({width = 800, mode=_G.Profile:GetChatAutocompleteMode()})

	-- Emojis --
	dictionary = Emoji.GetWordPredictionDictionary()
	if dictionary then
		local data = dictionary
		local words, emoji_translator = GetAllowedEmojiNames(TheNet:GetUserID())
		data.num_chars = TUNING.xiaoyao("emojiNumChars")
		if TUNING.xiaoyao("emojiTranslate") then
			table.insert(data.words,"lmb") emoji_translator["lmb"] = ""
			table.insert(data.words,"rmb") emoji_translator["rmb"] = ""
			data.translate = emoji_translator
			data.remove_delim = true
		end
		if TUNING.xiaoyao("emojiDisplay") then
			data.GetDisplayString = function(word) return emoji_translator[word]..TUNING.xiaoyao("emojiDisplay") end
		else
			data.GetDisplayString = function(word) return emoji_translator[word].." "..data.delim..word..data.postfix end
		end
		_self.chat_edit:AddWordPredictionDictionary(data)
	end
	-- Emotes --
	dictionary = UserCommands.GetEmotesWordPredictionDictionary()
	if dictionary then
		local data = dictionary
		data.num_chars = TUNING.xiaoyao("emoteNumChars")
		_self.chat_edit:AddWordPredictionDictionary(data)
	end
	-- Players --
	if TUNING.xiaoyao("playerDelim") then
		_self.chat_edit:AddWordPredictionDictionary(GetPlayerPredictionDictionary())
	end
	-- Objects --
	if TUNING.xiaoyao("objectDelim") then
		_self.chat_edit:AddWordPredictionDictionary(GetObjectPredictionDictionary())
	end
	-- Prefabs --
	if TUNING.xiaoyao("prefabDelim") then
		_self.chat_edit:AddWordPredictionDictionary(GetPrefabPredictionDictionary())
	end
	-- Personal --
	if TUNING.xiaoyao("personalDelim") then
		_self.chat_edit:AddWordPredictionDictionary(GetPersonalPredictionDictionary())
	end
end
AddClassPostConstruct("screens/chatinputscreen", ChatInputScreenPostInit)

function ConsoleScreenPostInit(_self)
	if _self.console_edit.prediction_widget then -- Let's sneak our own commands in
		for i,v in pairs(_self.console_edit.prediction_widget.word_predictor.dictionaries) do
			if v.delim == "c_" then
				table.insert(v.words,"shortcut")
				table.insert(v.words,"shortcutlist")
				table.insert(v.words,"shortcutclear")
			end
		end
	end
	-- Players --
	if TUNING.xiaoyao("playerDelim") then
		_self.console_edit:AddWordPredictionDictionary(GetPlayerPredictionDictionary())
	end
	-- Objects --
	if TUNING.xiaoyao("objectDelim") then
		_self.console_edit:AddWordPredictionDictionary(GetObjectPredictionDictionary())
	end
	-- Prefabs --
	if TUNING.xiaoyao("prefabDelim") then
		_self.console_edit:AddWordPredictionDictionary(GetPrefabPredictionDictionary())
	end
	-- Personal --
	if TUNING.xiaoyao("personalDelim") then
		_self.console_edit:AddWordPredictionDictionary(GetPersonalPredictionDictionary())
	end
end
AddClassPostConstruct("screens/consolescreen", ConsoleScreenPostInit)
