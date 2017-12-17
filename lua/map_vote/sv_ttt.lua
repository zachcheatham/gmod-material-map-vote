local extendTime = 0
local function gmInitialize()
    function CheckForMapSwitch()
        local rounds_left = math.max(0, GetGlobalInt("ttt_rounds_left", 6) - 1)
        local time_left = math.max(0, (GetConVar("ttt_time_limit_minutes"):GetInt() * 60) - CurTime())

		SetGlobalInt("ttt_rounds_left", rounds_left)

        if rounds_left <= 0 or time_left <= 0 then
            LANG.Msg("limit_vote")
			timer.Stop("end2prep")
			timer.Stop("prep2begin")

			if GetRoundState() == ROUND_POST then -- Give players time to gather themselves if a round finished
				timer.Simple(8, function()
					ZMapVote.startVote()
				end)
			else -- Start instantly because we're probably sitting in waiting mode
				ZMapVote.startVote()
			end
        end
    end
end
hook.Add("Initialize", "ZMVTTT", gmInitialize)

hook.Add("ZMVVotingCompleted", "ZVMExtendVoteTTT", function(selectedMap)
    if selectedMap == "__extend__" then
        SetGlobalInt("ttt_rounds_left", 6)
        extendTime = extendTime + GetConVar("ttt_time_limit_minutes"):GetInt() - math.max(0, (GetConVar("ttt_time_limit_minutes"):GetInt() * 60) - CurTime())
        timer.Simple(4, function()
            PrepareRound()
        end)
    end
end)
