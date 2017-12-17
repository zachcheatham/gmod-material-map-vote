ZMapVote.Config = {}

--
-- General
--

-- If set to false, the map vote will display every map listed in the map rotation file
ZMapVote.Config.RotationMode = true -- THIS DOESN'T DO ANYTHING RIGHT NOW :S

-- How many popular maps you want to show per map vote
--ZMapVote.Config.PopularMapsPerVote = 1

-- How many maps you want shown per map vote (this does not include the popular maps)
ZMapVote.Config.MapsPerVote = 8

-- Enable option for a random map from entire map rotation
ZMapVote.Config.RandomMap = false

-- Enable option for extending the map
ZMapVote.Config.ExtendMap = true

-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- I HIGHLY recommend making the total maps in the list add up to 8 (Includes random map as 1)
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

--
-- RTV
--

-- Enable (true) or disable (false) rtv functionality
ZMapVote.Config.EnableRTV = true

-- Perecentage of players needing to rtv to initiate vote (0 - 100)
ZMapVote.Config.RTVPercentage = 50

-- Enable to disable RTV on the first round of TTT
ZMapVote.Config.TTTDisableFirstRound = true

-- Enable (true) or disable (false) players being able to rtv to a specific map
ZMapVote.Config.EnableSRTV = true

-- Perecentage of players needed to start a rtv vote to a specific map (0 - 100)
ZMapVote.Config.InitiateSRTVPercentage = 25

-- Perecentage of players needing to rtv to a specific map (0 - 100)
ZMapVote.Config.SRTVPercentage = 50
