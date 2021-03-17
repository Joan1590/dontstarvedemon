local _G = GLOBAL
_G.NEWTEMPFONT = "tempfont"
local new_font = {filename = MODROOT.."fonts/temp.zip", alias = _G.NEWTEMPFONT, disable_color = true}
table.insert(_G.DEFAULT_FALLBACK_TABLE, 1, _G.NEWTEMPFONT)
table.insert(_G.DEFAULT_FALLBACK_TABLE_OUTLINE, 1, _G.NEWTEMPFONT)
table.insert(_G.FONTS, new_font)

local extra_emotes = {
    beishang   = "\243\176\130\160",         -- code point 983200
    angri      = "\243\176\130\161",         -- code point 983201
    hjbang     = "\243\176\130\162",         -- code point 983202
    happybuff  = "\243\176\130\163",         -- code point 983203
    wenhao     = "\243\176\130\164",         -- code point 983204
    hhh        = "\243\176\130\165",         -- code point 983205
    herb       = "\243\176\130\166",         -- code point 983206
    bang_bang  = "\243\176\130\167",         -- code point 983207
    qiwu       = "\243\176\130\168",         -- code point 983208
    taikongren = "\243\176\130\169",         -- code point 983209
    ile        = "\243\176\130\170",         -- code point 983210
    caoha      = "\243\176\130\171",         -- code point 983211
    lag        = "\243\176\130\172",         -- code point 983212
    fencer     = "\243\176\130\173",         -- code point 983213
    pink       = "\243\176\130\174",         -- code point 983214
    zszj       = "\243\176\130\175",         -- code point 983215
    fishing    = "\243\176\130\176",         -- code point 983216
}
-- Morphs
extra_emotes["strange_knowledge"] = extra_emotes["zszj"]

local extra_emotes_keys = {}
for key in pairs(extra_emotes) do
    table.insert(extra_emotes_keys, key)
end

local Emoji = require("util/emoji")
local GetWordPredictionDictionary = Emoji.GetWordPredictionDictionary
Emoji.GetWordPredictionDictionary = function()
    local data = GetWordPredictionDictionary()
    data.words = _G.JoinArrays(data.words, extra_emotes_keys)
    local GetDisplayString = data.GetDisplayString
    data.GetDisplayString = function(word)
        return extra_emotes[word] and extra_emotes[word] .. " " .. data.delim .. word .. data.postfix
            or GetDisplayString(word)
    end
    return data
end

AddClassPostConstruct("util/wordpredictor", function(self)
    -- local Apply = self.Apply
    -- self.Apply = function(self, prediction_index, ...)
    --     local new_text, new_cursor_pos = Apply(self, prediction_index, ...)
    --     local _new_text = new_text:gsub(":", "")
    --     new_text = extra_emotes[_new_text] or new_text
    --     return new_text, new_cursor_pos
    -- end
    self.Apply = function(self, prediction_index, ...) -- Override
        local new_text = nil
        local new_cursor_pos = nil
        if self.prediction ~= nil then
            local new_word = self.prediction.matches[math.clamp(prediction_index or 1, 1, #self.prediction.matches)]
            local extra_emote = extra_emotes[new_word]
    
            new_text = extra_emote and self.text:sub(1, self.prediction.start_pos - 1) .. extra_emote                                  -- Changed Part
                                    or self.text:sub(1, self.prediction.start_pos) .. new_word .. self.prediction.dictionary.postfix   -- Changed Part
            new_cursor_pos = #new_text
            
            local remainder_text = self.text:sub(self.cursor_pos + 1, #self.text) or ""
            local remainder_strip_pos = remainder_text:find("[^a-zA-Z0-9]") or (#remainder_text + 1)
            if self.prediction.dictionary.postfix ~= "" and remainder_text:sub(remainder_strip_pos, remainder_strip_pos + (#self.prediction.dictionary.postfix-1)) == self.prediction.dictionary.postfix then
                remainder_strip_pos = remainder_strip_pos + #self.prediction.dictionary.postfix
            end
    
            new_text = new_text .. remainder_text:sub(remainder_strip_pos)
        end
        
        self:Clear()
        return new_text, new_cursor_pos
    end
end)
