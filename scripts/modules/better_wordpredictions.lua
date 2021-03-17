AddClassPostConstruct("screens/consolescreen", function(self)
    if not self.console_edit.prediction_widget then return end
    local TheWorld = GLOBAL.TheWorld
    if not TheWorld then return end

    local active_players = {}
    local player_dict = {words = active_players, delim = '"', postfix='"', skip_pre_delim_check = true, num_chars = 0}
    self.console_edit:AddWordPredictionDictionary(player_dict)

    TheWorld:ListenForEvent("ms_playerjoined", function(world, player)
        player = player.userid
        for i, v in ipairs(active_players) do
            if v == player then
                return
            end
        end
        table.insert(active_players, player)
    end)
    TheWorld:ListenForEvent("ms_playerleft", function(world, player)
        player = player.userid
        for i, v in ipairs(active_players) do
            if v == player then
                table.remove(active_players, i)
                return
            end
        end
    end)
end)