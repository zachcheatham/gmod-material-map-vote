local rtv = {}
local srtv = {}
local success = false

local function voteCountForMap(map)
    local count = 0
    for _, mn in pairs(srtv) do
        if mn == map then
            count = count + 1
        end
    end
    return count
end

local function initiateSRTV(map)
    local title

    if GetRoundState() == ROUND_ACTIVE then
        title = "Change map to " .. map .. " at the end of the round?"
    else
        title = "Change map to " .. map .. "?"
    end

    ulx.doVote(title, {"Yes", "No"}, function(vote)
        local yesVotes = vote.results[1] or 0
        local requiredVotes = math.ceil(#player.GetAll() * (ZMapVote.Config.SRTVPercentage / 100))

        if yesVotes >= requiredVotes then
            if GetRoundState() == ROUND_ACTIVE then -- Change map after round
                SetGlobalInt("ttt_rounds_left", 0) -- Trigger map change at the end of the round

                -- Hijack the map change function
                function CheckForMapSwitch()
                    -- Change the map at the end of post time
                    timer.Simple(GetConVar("ttt_posttime_seconds"):GetInt(), function()
                        RunConsoleCommand("changelevel", map)
                    end)
                end

                -- Announce
                ULib.tsayColor(_, true, Color(0, 255, 0), "RTV to \"" .. map .. "\" succeeded. Map will change at the end of this round.")
            else -- Change map now
                ULib.tsayColor(_, true, Color(0, 255, 0), "RTV to \"" .. map .. "\" succeeded. Changing map...")

                timer.Simple(3, function()
                    RunConsoleCommand("changelevel", map)
                end)
            end
        else
            ULib.tsay(_, "RTV to \"" .. map .. "\" failed.")
        end
    end, 20, _, false)
end

-- GAMEMODE.FirstRound

if ZMapVote.Config.EnableRTV then
    local function playerSay(ply, text, teamChat)
        if string.sub(text, 1, 3) == "rtv" or string.sub(text, 1, 4) == "!rtv" then
            if GAMEMODE.FirstRound and ZMapVote.Config.TTTDisableFirstRound then
                ULib.tsayError(ply, "You may not rtv on the first round.", true)
            else
                if string.len(text) > 4 and ZMapVote.Config.EnableSRTV then
                    local map = string.sub(text, 6)
                    if file.Exists("maps/" .. map .. ".bsp", "GAME") then
                        if srtv[ply:UserID()] == map then
                            ULib.tsayError(ply, "You have already rocked the vote for \"" .. map .. "\"", true)
                        else
                            srtv[ply:UserID()] = map

                            local currentVotes = voteCountForMap(map)
                            local requiredVotes = math.ceil(#player.GetAll() * (ZMapVote.Config.InitiateSRTVPercentage / 100))
                            local votesNeeded = requiredVotes - currentVotes

                            ULib.tsay(_, ply:Nick() .. " has rocked the vote for " .. map .. "! ", true)

                            if votesNeeded <= 0 then
                                initiateSRTV(map)
                            else
                                ULib.tsay(_, votesNeeded .. " player(s) must type \"rtv " .. map .. "\" to start the vote!")
                            end
                        end
                    else
                        ULib.tsayError(ply, "The map \"" .. map .. "\" doesn't exist on this server.", true)
                    end
                else
                    if rtv[ply:UserID()] then
                        ULib.tsayError(ply, "You've already rocked the vote!", true)
                    elseif success then
                        ULib.tsayError(ply, "The vote has already been successfully rocked!", true)
                    else
                        rtv[ply:UserID()] = true

                        local currentVotes = table.Count(rtv)
                        local requiredVotes = math.ceil(#player.GetAll() * (ZMapVote.Config.RTVPercentage / 100))
                        local votesNeeded = requiredVotes - currentVotes

                        if votesNeeded <= 0 then
                            ULib.tsay(_, ply:Nick() .. " has rocked the vote!", true)

                            if GetConVar("gamemode"):GetString() == "terrortown" then
                                if GetRoundState() == ROUND_ACTIVE then
                                    SetGlobalInt("ttt_rounds_left", 0)  -- Trigger map change at the end of the round
                                    ULib.tsayColor(_, true, Color(0, 255, 0), "Map voting will begin at the end of the round!")
                                else
                                    -- Cause TTT to start the vote
                                    SetGlobalInt("ttt_rounds_left", 0)
                                    CheckForMapSwitch()

                                    ULib.tsayColor(_, true, Color(0, 255, 0), "Map voting has commenced!")
                                end
                            else
                                ULib.tsayColor(_, true, Color(0, 255, 0), "Map voting has commenced!")
                            end

                            success = true
                        else
                            ULib.tsay(_, ply:Nick() .. " has rocked the vote (" .. votesNeeded .. " more player(s) needed)!", true)
                        end
                    end
                end
            end

            return ""
        end
    end
    hook.Add("PlayerSay", "ZMapVote_RTV_PlayerSay", playerSay)

    local function playerDisconnect(ply)
        table.remove(rtv, ply:UserID())
        table.remove(srtv, ply:UserID())
    end
    hook.Add("PlayerDisconnected", "ZMapVote_RTV_PlayerDisconnected", playerDisconnect)
end
