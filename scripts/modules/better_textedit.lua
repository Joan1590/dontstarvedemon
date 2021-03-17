local ENV = env
GLOBAL.setfenv(1, GLOBAL)

ENV.AddClassPostConstruct("screens/consolescreen", function(self)

    local CONSOLE_HISTORY = GetConsoleHistory()

    local Run = self.Run
    self.Run = function(self, ...) -- Don't record, if duplicate
        local rt = Run(self, ...)
        if #CONSOLE_HISTORY > 2 and CONSOLE_HISTORY[#CONSOLE_HISTORY] == CONSOLE_HISTORY[#CONSOLE_HISTORY - 1] then
            table.remove(CONSOLE_HISTORY, #CONSOLE_HISTORY)
        end
        return rt
    end

end)

local CHATINPUT_HISTORY = { "Klei yydsb" }
ENV.AddClassPostConstruct("screens/chatinputscreen", function(self)

    local Run = self.Run
    self.Run = function(self, ...)
        local chat_string = self.chat_edit:GetString()
        chat_string = chat_string ~= nil and chat_string:match("^%s*(.-%S)%s*$")
        if chat_string and (#CHATINPUT_HISTORY == 0 or chat_string ~= CHATINPUT_HISTORY[#CHATINPUT_HISTORY]) then
            table.insert(CHATINPUT_HISTORY, chat_string)
        end
        return Run(self, ...)
    end

    local OnRawKey = self.chat_edit.OnRawKey
    self.chat_edit.OnRawKey = function(s, key, down)

        if OnRawKey(s, key, down) then
            return true
        end

        if not down then return end

        local len = #CHATINPUT_HISTORY
        if len == 0 then return end

        if key == KEY_UP then
            if self.history_idx ~= nil then
                self.history_idx = math.max( 1, self.history_idx - 1 )
            else
                self.history_idx = len
            end
            self.chat_edit:SetString( CHATINPUT_HISTORY[ self.history_idx ] )
        elseif key == KEY_DOWN then
            if self.history_idx ~= nil then
                if self.history_idx == len then
                    self.chat_edit:SetString( "" )
                else
                    self.history_idx = math.min( len, self.history_idx + 1 )
                    self.chat_edit:SetString( CHATINPUT_HISTORY[ self.history_idx ] )
                end
            end
        end

        return true

    end

    self.chat_edit.validrawkeys[KEY_UP] = true
	self.chat_edit.validrawkeys[KEY_DOWN] = true

end)
