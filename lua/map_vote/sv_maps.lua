-- Only put maps in here that aren't in the popular maps array.
ZMapVote.popularMaps = {
	"ttt_dolls_2014",
	"ttt_krusty_krab",
	"dm_richland",
	"ttt_crummycradle_a4",
	"ttt_roy_the_ship",
	"ttt_minecraft_b5",
	"de_dolls",
	"dm_island17",
	"ttt_67thway_v3",
	"ttt_whitehouse_b2",
	"ttt_67thway_v14",
	"ttt_innocentmotel_v1",
	"ttt_67thway_v7",
	"ttt_rooftops_a2",
}

-- Maps that you want presented to players in a rotation
ZMapVote.maps = {
	"ttt_kingswoodmanor_001_d",
	"ttt_stone_v2",
	"ttt_nighttrap",
	"ttt_minecraft_haven",
	"ttt_signal",
	"ttt_datmap",
	"ttt_minecraft_mythic_st2",
	"zm_countrytrain_b4",
	"ttt_stadium_v1",
	"ttt_amsterville",
	"ttt_metropolis_v2",
	"ttt_iceresearch_rc4",
	"ttt_lost_temple_v2",
	"ttt_clue_se",
	"ttt_labyrinth_v2",
	"ttt_datmap_v2",
	"ttt_tundra",
	"ttt_terrorception_v7",
	"ttt_sewers",
	"ttt_terraria",
	"ttt_camel_v2",
	"ttt_cyberia_a3",
	"ttt_bb_teenroom_b2",
	"ttt_bb_canalwarehousev2_r3",
	"ttt_camel_fix2",
	"de_dust2",
	"ttt_ford_marine",
	"ttt_homestead_alpha_v6",
	"ttt_abbottabad_d",
	"ttt_minecraft_mythic_st3",
	"ttt_mc_terminal_a3",
	"ttt_bb_schooldayv3_r3",
	"ttt_innocentmotel_b6",
	"ttt_cod_stalingrad",
	"ttt_orange_v7",
	"ttt_castle_2011_v3_night",
	"ttt_traitor_industrie",
	"ttt_offshore",
	"ttt_community_pool_classic",
	"ttt_lego",
	"ttt_nether",
	"ttt_fastfood_a4test",
	"ttt_concentration_b2",
	"ttt_minecraftcity_v4",
	"ttt_vault101",
	"ttt_minecraft_mythic_st",
	"ttt_wasteplant_v04b",
	"ttt_camel_v1",
	"ttt_i0nsplayground_b14",
	"ttt_highrise",
	"ttt_skyrail_2014_v1_2",
	"ttt_teleport_lab",
	"ttt_freddy_the_ship_v3",
	"ttt_007_facility_gmn_v2",
	"ttt_floodlights",
	"ttt_krusty_krab_a2",
	"ttt_starfish_island_v1_2",
	"ttt_rooftops_a2_f1",
	"ttt_alien_v2",
	"ttt_bank_b3",
	"de_rats_kitchen",
	"de_westwood",
	"ttt_construction_v3",
	"ttt_metropolis",
	"ttt_clue_pak",
	"ttt_richland",
	"ttt_skyscraper",
	"ttt_nuclear_power_b2",
	"ttt_intergalactic",
	"ttt_alps",
	"ttt_mc_mineshaft",
	"ttt_terrortrainb2",
	"xmas_nipperhouse",
	"ttt_mc_frozen",
	"ttt_minecraft_mystic_st",
	"cs_office-unlimited",
	"ttt_hotwireslum_final",
	"ttt_minecraft_mythic_b8",
	"ttt_magma_v2a",
	"ttt_smalltown",
	"ttt_island_2013",
	"ttt_magma",
	"ttt_metropolis_v2a",
	"ttt_mc_jondome",
	"ttt_community_bowling_v5a",
	"ttt_alien",
	"ttt_giant_daycare",
	"ttt_subway_b4",
	"ttt_camel_fix",
	"cs_desperados",
	"ttt_motel_b4",
	"ttt_praya_b1",
	"ttt_bf3_scrapmetal",
	"ttt_thething_b3",
	"ttt_stripclub_v2",
	"ttt_underside_a1",
	"ttt_tundra_st",
	"ttt_prison_001",
	"ttt_cloverfield_b2",
	"ttt_cloudfactory",
	"ttt_hairyhouse",
	"ttt_policedepartment_betav2",
	"ttt_stargate_v3",
	"ttt_vessel",
	"ttt_parkhouse_fix",
	"ttt_summermansion_b3",
	"ttt_cluedo_b5_improved1",
	"ttt_woodedwidow",
	"ttt_rapture_v3",
	"ttt_canyon_a4",
	"ttt_terrorception",
	"ttt_thething_b4",
	"ttt_forest_final",
	"ttt_parking_alley",
	"ttt_ratskitchen_st",
	"ttt_scarisland_b1",
	"ttt_anxiety",
	"ttt_maximumsecurity_v1",
	"ttt_equilibre",
	"ttt_chaser_v2",
	"ttt_sunday_street_b2fix",
	"ttt_highrise_v2",
	"ttt_aircraft_v1b",
	"ttt_fuuk_jail_final2",
	"ttt_mcmansion_v5b",
	"dm_christmas_bungalow",
	"ttt_cruise",
	"ttt_plaza_b7",
	"ttt_forgotten_forge",
	"ttt_airbus_b3",
	"ttt_toxicwaste",
	"ttt_darkmatter_center_v5",
	"ttt_maximumsecurity_v53",
	"ttt_parkhouse",
	"ttt_town_b1",
	"ttt_backalley_b1",
	"ttt_infini_b5",
	"ttt_alien_v2b",
	"cs_rooftops_css",
	"ttt_templar_b2",
	"ttt_bb_suburbia_b3"
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
	return "gm_construct"
end