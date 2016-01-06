-- Only put maps in here that aren't in the popular maps array.
ZMapVote.popularMaps = {
	"ttt_67thway_v7",
	"ttt_minecraft_b5",
	"de_dolls",
	"ttt_67thway_v3",
	"ttt_rooftops_2016_v1"
}

-- Maps that you want presented to players in a rotation
ZMapVote.maps = {
	"ttt_bank_b3",
	"ttt_whitehouse_b2",
	"ttt_minecraft_haven",
	"ttt_island_2013",
	"ttt_rooftops_a2",
	"ttt_canyon_a4",
	"ttt_magma_v2a",
	"ttt_town_b1",
	"ttt_bb_teenroom_b2",
	"ttt_terrortrainb2",
	"ttt_innocentmotel_v1",
	"dm_richland"
}

-- DO NOT EDIT BELOW (Unless you know what you're doing, ofc)

function ZMapVote.fetchUpcomingMaps()
	local maps = {}
	
	local startIndex = (sql.QueryValue("SELECT value FROM mapvote_state WHERE key = 'last_map'") or 0) + 1
	local popularStartIndex = (sql.QueryValue("SELECT value FROM mapvote_state WHERE key = 'last_popular_map'") or 0) + 1
	
	print ("ZMapVote: Map startIndex is " .. startIndex)
	print ("ZMapVote: Popular map startIndex is " .. popularStartIndex)
	
	local mapsAdded = 0
	local index = popularStartIndex
	while mapsAdded < ZMapVote.Config.PopularMapsPerVote do
		if index > #ZMapVote.popularMaps then
			index = 1
		end
	
		local map = {}
		map.name = ZMapVote.popularMaps[index]
		map.popular = true
		
		table.insert(maps, map)
		
		mapsAdded = mapsAdded + 1
		index = index + 1
	end
	
	index = index - 1
	sql.Query("INSERT OR REPLACE INTO mapvote_state ('key', 'value') VALUES('last_popular_map', " .. index .. ")")
	
	mapsAdded = 0
	index = startIndex
	while mapsAdded < ZMapVote.Config.MapsPerVote do
		if index > #ZMapVote.maps then
			index = 1
		end
	
		local map = {}
		map.name = ZMapVote.maps[index]
		map.popular = false
		
		table.insert(maps, map)
		
		mapsAdded = mapsAdded + 1
		index = index + 1
	end
	
	index = index - 1
	sql.Query("INSERT OR REPLACE INTO mapvote_state ('key', 'value') VALUES('last_map', " .. index .. ")")
	
	if ZMapVote.Config.RandomMap then
		local map = {}
		map.name = "__random_map__"
		map.popular = false
		
		table.insert(maps, map)
	end
	
	return maps
end

function ZMapVote.fetchAllMaps()
	ErrorNoHalt("ZMapVote warning: Non-rotation mode has not been implemented yet!")
	return {}
end

function ZMapVote.fetchRandomMap()
	local possibleMaps = {}
	local mapFiles = file.Find("maps/*", "GAME")
	
	for _, file in ipairs(mapFiles) do
		local name, extension = string.match(file, "(.*)%.(%a*)$")
		if extension == "bsp" then
			table.insert(possibleMaps, name)
		end
	end
	
	math.randomseed(SysTime())
	return table.Random(possibleMaps)
end