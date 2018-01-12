-- Maps that you want presented to players in a rotation

-- Unknown is ICK2lr1
ZMapVote.maps = {
	{name="ttt_67thway_v14", imgur = "Zt3x7iz"},
	{name="ttt_waterworld_r9", imgur = "sJrxeX4", min_plys=18},
	{name="ttt_terrortrainb2", imgur = "IgswIgm", min_plys=12},
	{name="de_westwood", imgur = "OBkBJeo", min_plys=12},
	{name="cs_desperados", imgur = "LGdrTZA", min_plys=18},
	{name="ttt_rooftops_a2_f1", imgur = "3373vDz"},
	{name="ttt_wintermansion_beta2", imgur = "jg2dO96", min_plys=18},
	{name="ttt_subway_b4", imgur = "FvC5Lal"},
	{name="ttt_intergalactic", imgur = "lS5d1Uh"},
	{name="ttt_clue_pak", imgur = "yd9GyDC"},
	{name="ttt_minecraftcity_v4", imgur = "1G0cTlO"},
	{name="dm_island17", imgur = "Yc4ZU6u"},
	{name="ttt_67thway_v3", imgur = "J0QGfVt"},
	{name="ttt_roy_the_ship", imgur = "u0NTvPn"},
	{name="ttt_innocentmotel_v1", imgur = "ruBy3NU"},
	{name="ttt_bb_teenroom_b2", imgur = "HVyJ0L0", min_plys=18},
	{name="ttt_minecraft_b5", imgur = "E28JWLj"},
	{name="ttt_crummycradle_a4", imgur = "eI8dW4W", min_plys=18},
	{name="ttt_lost_temple_v2", imgur = "jCqatlZ", min_plys=18},
	{name="de_dolls", imgur = "7BhCKVD"},
	{name="ttt_whitehouse_b2", imgur = "VgPADXG", min_pls=12},
	{name="ttt_rooftops_2016_v1", imgur = "8kDN0L4"},
	{name="ttt_mc_dolls_v3", imgur = "9fVfX5x"},
	{name="ttt_magma", imgur = "q7ZJyCz"},
	{name="ttt_krusty_krab", imgur = "MaQxtI7"},
	{name="ttt_richland_fix", imgur = "tQ5pfWx"},
	{name="ttt_anxiety", imgur = "4K6CtSu"}
}

-- DO NOT EDIT BELOW (Unless you know what you're doing, ofc)

function ZMapVote.fetchUpcomingMaps()
    local maps = {}

    local startIndex = (sql.QueryValue("SELECT value FROM mapvote_state WHERE key = 'last_map'") or 0) + 1
    --local popularStartIndex = (sql.QueryValue("SELECT value FROM mapvote_state WHERE key = 'last_popular_map'") or 0) + 1

    print ("ZMapVote: Map startIndex is " .. startIndex)
    --print ("ZMapVote: Popular map startIndex is " .. popularStartIndex)

    --[[local mapsAdded = 0
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
    sql.Query("INSERT OR REPLACE INTO mapvote_state ('key', 'value') VALUES('last_popular_map', " .. index .. ")")]]--

    local mapsAdded = 0
    local index = startIndex
    while mapsAdded < ZMapVote.Config.MapsPerVote do
        if index > #ZMapVote.maps then
            index = 1
        end

        if game.GetMap() ~= ZMapVote.maps[index].name then
            if ZMapVote.maps[index].min_plys == nil or #player.GetAll() >= ZMapVote.maps[index].min_plys then
                local map = {}
                map.name = ZMapVote.maps[index].name
                map.imgur = ZMapVote.maps[index].imgur

                table.insert(maps, map)
                mapsAdded = mapsAdded + 1
            end
        end

        index = index + 1
    end

    index = index - 1
    sql.Query("INSERT OR REPLACE INTO mapvote_state ('key', 'value') VALUES('last_map', " .. index .. ")")

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
