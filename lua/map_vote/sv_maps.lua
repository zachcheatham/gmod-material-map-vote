-- Only put maps in here that aren't in the popular maps array.
ZMapVote.popularMaps = {
	"ttt_67thway_v7",
	"ttt_roy_the_ship",
	"dm_island17",
	"dm_richland",
	"ttt_minecraft_b5",
	"ttt_rooftops_a2",
	"ttt_crummycradle_a4",
	"ttt_whitehouse_b2",
	"ttt_innocentmotel_b6",
	"ttt_krusty_krab",
	"ttt_rooftops_2016_v1",
	"ttt_67thway_v3",
	"de_dolls",
}

-- Maps that you want presented to players in a rotation
ZMapVote.maps = {
	"ttt_lost_temple_v2",
	"ttt_backalley_b1",
	"ttt_hotwireslum_final",
	"de_westwood",
	"ttt_innocentmotel_v1",
	"ttt_anxiety",
	"ttt_toxicwaste",
	"ttt_town_b1",
	"cs_rooftops_css",
	"cs_desperados",
	"ttt_island_2013",
	"ttt_cruise",
	"ttt_subway_b4",
	"ttt_intergalatic",
	"ttt_magma",
	"ttt_nuclear_power_b2",
	"ttt_terrortrainb2",
	"ttt_giant_daycare",
	"ttt_bb_schooldayv3_r3",
	"cs_office-unlimited",
	"ttt_castle_2011_v3_night",
	"ttt_bb_teenroom_b2",
	"ttt_stone_v2",
	"ttt_thething_b4",
	"ttt_magma_v2a",
	"ttt_krusty_krab_a2",
	"ttt_kingswoodmanor_001_d",
	"ttt_summermansion_b3",
	"ttt_hairyhouse",
	"ttt_smalltown",
	"ttt_canyon_a4",
	"ttt_minecraft_haven",
	"ttt_motel_b4",
	"ttt_rapture_v3",
	"ttt_forgotten_forge",
	"ttt_stadium_v1",
	"ttt_floodlights",
	"ttt_community_bowling_v5",
	"ttt_fuuk_jail_final2",
	"ttt_bank_b3",
	"ttt_stripclub_v2",
	"ttt_cloverfield_b2",
	"ttt_stargate_v3",
	"ttt_bb_canalwarehousev2_r3",
	"ttt_sewers",
	"ttt_minecraftcity_v4",
	"ttt_woodedwidow",
	"ttt_clue_pak",
	"ttt_terrorception"
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