local PANEL = {}

local ICON_PADDING = 25
local MIN_WIDTH = 1000 -- Goal is to get 4 icons in a row (Unless low res)

function PANEL:Init()
    self.startTime = SysTime()
    self.maps = {}
    self.votingEnabled = true
    self.selectedMap = false

    gui.EnableScreenClicker(true)

    self:MakePopup()
    self:SetKeyboardInputEnabled(false)
    self:SetMouseInputEnabled(true)

    self:SetWide(ScrW())
    self:SetTall(ScrH())

    local window = self

    local closeButton = vgui.Create("DButton", self)
    closeButton:SetText("Close")
    closeButton:SetPos(self:GetWide() - closeButton:GetWide() - 10, closeButton:GetTall() - 10)
    closeButton.DoClick = function()
        window:Hide()
        gui.EnableScreenClicker(false)
    end

    self.inner = vgui.Create("Panel", self)
    self.inner:SetWide(ScrH() * 0.75 * 4 / 3)
    self.inner:SetTall(ScrH())
    if self.inner:GetWide() < MIN_WIDTH then
        if ScrW() < MIN_WIDTH then
            self.inner:SetWide(ScrW())
        else
            self.inner:SetWide(MIN_WIDTH)
        end
    end

    self.inner:SetPos((ScrW() / 2) - (self.inner:GetWide() / 2), (ScrH() / 2) - (self.inner:GetTall() / 2))

    function self.inner:PerformLayout()
        local first = window.maps[1]

        if first then
            local iconWidth = first:GetWide()
            local iconHeight = first:GetTall()
            local rowWidth = 0
            local rowItems = 0
            local rows = 1
            local startX = 0
            local startY = 0
            local padding = ICON_PADDING

            for i=1, #window.maps do
                if rowWidth + iconWidth + padding < self:GetWide() then
                    rowWidth = rowWidth + iconWidth + padding
                    rowItems = rowItems + 1
                else
                    -- Since we take up a full row, lets make things pretty
                    padding = (self:GetWide() - iconWidth * rowItems) / (rowItems - 1)
                    rowWidth = self:GetWide() + padding -- Unnecessarily add padding since we remove it below

                    break
                end
            end

            rowWidth = rowWidth - padding -- Remove trailing padding

            rows = math.ceil(#window.maps / rowItems)

            startX = self:GetWide() / 2 - rowWidth / 2
            startY = self:GetTall() / 2 - iconHeight * rows / 2

            self:GetParent().time:SetPos(
                self:GetWide() - self:GetParent().time:GetWide(),
                startY / 2 - self:GetParent().time:GetTall() / 2
            )
            self.title:SetPos(0, startY / 2 - self.title:GetTall() / 2)

            local i = 1
            for r=1, rows do
                for c=1, rowItems do
                    local icon = window.maps[i]

                    if not icon then return end

                    icon:SetPos(startX + ((iconWidth + padding) * (c - 1)), startY + ((iconHeight + padding) * (r - 1)))

                    i = i + 1
                end
            end

            if self:GetParent().extendOption then
                self:GetParent().extendOption:SetPos(
                    self:GetWide() - self:GetParent().extendOption:GetWide(),
                    self:GetTall() - startY / 2
                )
            end
        else
            ErrorNoHalt("Zach's Map Voting: Uhhh, somehow the vote menu was requested but we have no maps :c\r\n")
        end
    end

    self.inner.title = vgui.Create("DLabel", self.inner)
    self.inner.title:SetFont("ZMapVoteTitle")
    self.inner.title:SetText("MAP VOTE")
    self.inner.title:SetColor(Color(255, 255, 255))
    self.inner.title:SizeToContents()

    self.time = vgui.Create("DLabel", self.inner)
    self.time:SetFont("ZMapVoteTitle")
    self.time:SetText("0:30")
    self.time:SetColor(Color(255, 255, 255))
    self.time:SizeToContents()
end

function PANEL:Paint(w, h)
    Derma_DrawBackgroundBlur(self, self.startTime)
    --draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 200))
end

function PANEL:SetTimer(seconds)
    local remaining = seconds
    local window = self

    window.time:SetText("0:" .. seconds) -- I hope no one wants to go over a minute (UPDATE: The max is limited to 64)

    timer.Remove("ZMVCountdown")
    timer.Create("ZMVCountdown", 1, seconds, function()
        remaining = remaining - 1
        if remaining < 10 then
            window.time:SetText("0:0" .. remaining)
        else
            window.time:SetText("0:" .. remaining)
        end
    end)
end

function PANEL:AddMap(map)
    local mapIcon = vgui.Create("ZMVMapIcon", self.inner)
    mapIcon:SetMapData(map)

    mapIcon.DoClick = function(icon)
        if self.votingEnabled then
            if icon.data.name ~= selectedMap then
                self.extendOption:SetSelected(false)
                for _, i in ipairs(self.maps) do
                    i:SetSelected(false)
                end

                icon:SetSelected(true)
                self.selectedMap = icon.data.name
                self:OnMapPicked(icon.data.name)
            end
        end
    end

    table.insert(self.maps, mapIcon)
end

function PANEL:SetRandomEnabled(enabled)

end

function PANEL:SetExtendEnabled(enabled)
    self.extendOption = vgui.Create("ZMVExtraOption", self.inner)
    self.extendOption:SetText("Extend Map")
    self.extendOption.DoClick = function(option)
        if self.votingEnabled then
            if selectedMap ~= "__extend__" then
                for _, i in ipairs(self.maps) do
                    i:SetSelected(false)
                end

                self.extendOption:SetSelected(true)
                self.selectedMap = "__extend__"
                self:OnMapPicked("__extend__")
            end
        end
    end
end

function PANEL:SetMapVotes(map, votes)
    if map == "__extend__" then
        if self.extendOption then
            self.extendOption:SetVotes(votes)
        end
    else
        for _, mapIcon in ipairs(self.maps) do
            if mapIcon.data.name == map then
                mapIcon:SetVotes(votes)
                break
            end
        end
    end
end

function PANEL:SetSelected(map)
    if map == "__extend__" then
        if self.extendOption then
            self.extendOption:SetSelected(true)
        end
    else
        for _, mapIcon in ipairs(self.maps) do
            if mapIcon.data.name == map then
                mapIcon:SetSelected(true)
            else
                mapIcon:SetSelected(false)
            end
        end
    end
end

function PANEL:SetVotingEnabled(enabled)
    self.votingEnabled = enabled
end

function PANEL:FlashWinningMap(map)
    local flashedIcon = nil
    if map == "__extend__" then
        if self.extendOption then
            flashedIcon = self.extendOption
        end
    else
        for _, mapIcon in ipairs(self.maps) do
            if mapIcon.data.name == map then
                flashedIcon = mapIcon
                break
            end
        end
    end

    local flashed = false
    timer.Create("ZMVWinFlash", 0.2, 5, function()
        if not flashed then
            flashed = true
            surface.PlaySound("hl1/fvox/blip.wav")
        else
            flashed = false
        end

        flashedIcon:SetFlashed(flashed)
    end)
end

function PANEL:OnMapPicked(mapName)
    ErrorNoHalt("Zach's Map Voting: Someone screwed up. A map got voted for but nothing handles it.\n")
end

vgui.Register("ZMVVoteWindow", PANEL, "Panel")

/*concommand.Add("test_mapvote", function()
    local testMap = {}
    testMap.name = "ttt_test_server"
    testMap.popular = false

    local mvote = vgui.Create("ZMVVoteWindow")
    mvote:AddMap(testMap)
    mvote:AddMap(testMap)
    mvote:AddMap(testMap)
    mvote:AddMap(testMap)
    mvote:AddMap(testMap)
    mvote:AddMap(testMap)
    mvote:AddMap(testMap)
    mvote:AddMap(testMap)
    mvote:SetTimer(30)
    mvote:Show()
end)*/
