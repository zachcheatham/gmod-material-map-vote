local voteWindow = nil

local function mapPicked(pnl, name)
	net.Start("ZMV_Vote")
	net.WriteString(name)
	net.SendToServer()	
end

local function start()
	print ("ZMapVote by zachcheatham. I have no website for this. Try to find me if you want a copy!")	
	
	local maps = net.ReadTable()
	local seconds = net.ReadInt(6)
	
	if IsValid(voteWindow) then
		voteWindow:Remove()
	end
	
	voteWindow = vgui.Create("ZMVVoteWindow")
	voteWindow.OnMapPicked = mapPicked
	
	for _, m in ipairs(maps) do
		voteWindow:AddMap(m)
	end
	
	voteWindow:SetTimer(seconds)
	voteWindow:SetVisible(true)
	print ("ZMapVote: Voting has begun!")
	
	hook.Call("ZMVVotingStarted", winningMap)
end
net.Receive("ZMV_Start", start)

local function update()
	local map = net.ReadString()
	local votes = net.ReadInt(7)
	
	--print ("ZMapVote debug: " .. map .. " now has " .. votes .. " vote(s)")
	
	if IsValid(voteWindow) then
		voteWindow:SetMapVotes(map, votes)
	end
end
net.Receive("ZMV_Update", update)

local function selected()
	local map = net.ReadString()
	
	if IsValid(voteWindow) then
		voteWindow:SetSelected(map)
	end
end
net.Receive("ZMV_Selected", selected)

local function votingFinished()
	local winningMap = net.ReadString()

    if not IsValid(voteWindow) then return end

    voteWindow:SetVotingEnabled(false)
	voteWindow:Show()
	
	print("ZMapVote: " .. winningMap .. " won the map vote!")
	
	voteWindow:FlashWinningMap(winningMap)
	
	hook.Call("ZMVVotingCompleted", nil, winningMap)
end
net.Receive("ZMV_Finish", votingFinished)

-- Reopens the voting window (DEAR GOD I'VE WANTED THIS FOR SO LONG)
local function playerChat(ply, message)
	if ply == LocalPlayer() and message == "!revote" then
		if IsValid(voteWindow) then
			voteWindow:Show()
		end
	end
end
hook.Add("OnPlayerChat", "ZMVRevoteCommand", playerChat)