util.AddNetworkString("ZMV_Start") -- Tells clients that a vote started
util.AddNetworkString("ZMV_Update") -- Updates clients on votes
util.AddNetworkString("ZMV_Vote") -- Lets clients vote
util.AddNetworkString("ZMV_Selected") -- Tells client what he's voted for (Desync fixes)
util.AddNetworkString("ZMV_Finish") -- Tells clients which map won

local VOTE_WINDOW_SECONDS = 30 -- MAX: 64

local maps = {}
local allowedToVote = false
local votes = {}

local function finishVote()
	local winningMap = false

	if table.Count(votes) == 0 then -- No one picked a map?	
		ServerLog("ZMapVoting: No one voted. Picking random map...\n")
		
		-- Go to the popular map to get better people
		local mapData = maps[1]
		winningMap = mapData.name
		
		-- Before I randomized the map. Decided against it.
		--[[ -- Don't want a random map to win. That would cause a blackhole!
		if ZMapVote.Config.RandomMap then
			table.remove(maps, #maps) -- I hope random map is not ever somehow not at the end
		end
		
		math.randomseed(SysTime()) -- Better randomization. I think.
		local mapData = table.Random(maps)
		winningMap = mapData.name]]--
	else
		local tally = {}
		local topMaps = {}
		local topMapaVotes = 0

		-- Tally the votes
		for _, map in pairs(votes) do
			if not tally[map] then
				tally[map] = 1
			else
				tally[map] = tally[map] + 1
			end
		end

		--PrintTable(tally)
		
		-- Find the top maps
		for map, voteCount in pairs(tally) do
			--print (map .. ":" .. voteCount)
			if not topMaps[1] then
				--print ("DEBUG: Starting table topMaps with " .. map .. ":" .. voteCount)
				table.insert(topMaps, map)
				topMapsVotes = voteCount
			elseif topMapsVotes == voteCount then
				--print ("DEBUG: " .. map .. ":" .. voteCount .. " tied with the current top map.")
				table.insert(topMaps, map)
			elseif topMapsVotes < voteCount then
				--print ("DEBUG: " .. map .. ":" .. voteCount .. " now has the top votes.")
				
				table.Empty(topMaps)
				table.insert(topMaps, map)
				topMapVotes = voteCount
			end
		end
		
		-- Handle the winner(s)
		if #topMaps > 1 then
			ServerLog("There was a tie between maps. Randomizing...\n")
		
			-- If theres a tie with random map, we don't want it to win.
			if ZMapVote.Config.RandomMap then
				table.remove(topMaps, #topMaps) -- I hope random map is not ever somehow not at the end
			end

			-- Randomize between the winners
			math.randomseed(SysTime()) -- Better randomization. I think.
			winningMap = table.Random(topMaps)
		else
			winningMap = topMaps[1]
		end
	end
	
	local selectedMap = winningMap
	
	if not winningMap then
		ErrorNoHalt("ZMapVoting warning: Somehow, no map actually won the vote. Picking a completely random map...\n")
		winningMap = ZMapVote.fetchRandomMap()
		selectedMap = winningMap
	elseif winningMap == "__random_map__" then
		ErrorNoHalt("Random map actually won. Picking a completely random map...\n")
		selectedMap = ZMapVote.fetchRandomMap()
	end
	
	ServerLog("ZMapVoting: " .. selectedMap .. " won the map vote.\n")
	
	-- Tell everyone what the winning map was
	net.Start("ZMV_Finish")
	net.WriteString(winningMap)
	net.Broadcast()
	
	timer.Simple(4, function()
		RunConsoleCommand("changelevel", selectedMap)
	end)
	
	hook.Call("ZMVVotingCompleted", nil, winningMap, selectedMap)
end

function ZMapVote.startVote()

	-- Reset things in-case it opens twice
	timer.Remove("ZMVCountdown")
	table.Empty(votes)

	-- Fetch some maps
	if ZMapVote.Config.RotationMode then
		maps = ZMapVote.fetchUpcomingMaps()
	else
		maps = ZMapVote.fetchAllMaps()
	end

	-- Open the polls!
	ServerLog("ZMapVote: Voting has begun!\n")
	allowedToVote = true
	net.Start("ZMV_Start")
	net.WriteTable(maps)
	net.WriteInt(VOTE_WINDOW_SECONDS, 6)
	net.Broadcast()
	
	-- Set the time window for voting
	timer.Create("ZMVCountdown", VOTE_WINDOW_SECONDS, 1, function()
		ServerLog("ZMapVote: Voting closed.\n")
		allowedToVote = false
		finishVote()
	end)
	
	hook.Call("ZMVVotingStarted")
end

local function playerVote(len, ply)
	local map = net.ReadString()
	local oldMap = votes[ply:UserID()] or false
	
	if allowedToVote then
		ServerLog("ZMapVote: ".. ply:Nick() .. " voted for " .. map .. "\n")
		votes[ply:UserID()] = map -- Update this player's vote
		
		-- Count the votes for the old map
		if oldMap then
			local voteCount = 0
			
			for _, mapName in pairs(votes) do
				if mapName == oldMap then
					voteCount = voteCount + 1
				end
			end
			
			net.Start("ZMV_Update")
			net.WriteString(oldMap)
			net.WriteInt(voteCount, 7)
			net.Broadcast()
		end
		
		-- Count the votes for the new map
		local voteCount = 0
		
		for _, mapName in pairs(votes) do
			if mapName == map then
				voteCount = voteCount + 1
			end
		end
		
		net.Start("ZMV_Update")
		net.WriteString(map)
		net.WriteInt(voteCount, 7)
		net.Broadcast()
		
		-- Make sure the player's ui has this map selected
		net.Start("ZMV_Selected")
		net.WriteString(map)
		net.Send(ply)
	else
		ErrorNoHalt("ZMapVote warning: Somehow " .. ply:Nick() .. " attempted to vote after voting was closed.\n")
		
		-- Update their ui to what they used to have selected
		net.Start("ZMV_Selected")
		net.WriteString(oldMap or "")
		net.Send(ply)
	end
end
net.Receive("ZMV_Vote", playerVote)

local function initializeSQL()
	-- Why store a table thats going to be empty?
	if ZMapVote.Config.RotationMode then
		sql.Query("CREATE TABLE mapvote_state (key string, value int, PRIMARY KEY(key))")
	end
end
initializeSQL()

concommand.Add("start_vote", function()
	ZMapVote.startVote()
end)