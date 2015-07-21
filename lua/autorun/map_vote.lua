ZMapVote = {}

if SERVER then
	AddCSLuaFile("map_vote/cl_config.lua")
	AddCSLuaFile("map_vote/cl_mapvote.lua")
	AddCSLuaFile("map_vote/cl_fonts.lua")

	include("map_vote/sv_config.lua")
	include("map_vote/sv_maps.lua")
	include("map_vote/sv_mapvote.lua")
	include("map_vote/sv_rtv.lua")
	
	if GetConVar("gamemode"):GetString() == "terrortown" then
		include("map_vote/sv_ttt.lua")
	end
else
	include("map_vote/cl_config.lua")
	include("map_vote/cl_mapvote.lua")
	include("map_vote/cl_fonts.lua")
end