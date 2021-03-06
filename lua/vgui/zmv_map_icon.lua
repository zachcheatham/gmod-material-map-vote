local PANEL = {}

function PANEL:Init()
    self.shadowAlpha = 25
    self.shadowDistance = 3
    self.selected = false
    self.flashed = false

    self:SetWide(224)
    self:SetTall(224)
    self:SetMouseInputEnabled(true)
    self:SetCursor("hand")

    self.mapName = vgui.Create("DLabel", self)
    self.mapName:SetFont("ZMapVoteText")
    self.mapName:SetText("gm_example_map")
    self.mapName:SetColor(Color(0, 0, 0))
    self.mapName:SizeToContents()
    self.mapName:SetPos(self:GetWide() / 2 - self.mapName:GetWide() / 2, self:GetTall() - self.mapName:GetTall() - 10)

    self.mapImage = vgui.Create("HTML", self)
    self.mapImage:SetWide(self:GetWide())
    self.mapImage:SetTall(self:GetTall() - self.mapName:GetTall() - 20)
    self.mapImage:SetPos(0,-1)
    self.mapImage:SetMouseInputEnabled(false)

    self.votes = vgui.Create("DLabel", self)
    self.votes:SetFont("ZMapVoteCount")
    self.votes:SetColor(Color(255, 255, 0))
    self.votes:SetExpensiveShadow(1, Color(0, 0, 0, 200))
    self.votes:SetText("0")
    self.votes:SizeToContents()
    self.votes:SetPos(self:GetWide() - self.votes:GetWide() - 10, self.mapImage:GetTall() - self.votes:GetTall() - 5)
    self.votes:SetVisible(false)
end

function PANEL:OnMouseReleased()
    if isfunction(self.DoClick) then
        self:DoClick()
    end
end

function PANEL:Paint(w, h)
    -- Draw a shadow (fun)
    surface.DisableClipping(true)

    for i=1, self.shadowDistance do
        draw.RoundedBox(3 + i, -i, i - 1, w + i * 2, h + i -1, Color(0, 0, 0, self.shadowAlpha))
    end

    surface.DisableClipping(false)

    -- Draw our pretty box
    if self.flashed then
        draw.RoundedBox(3, 0, 0, w, h, Color(0, 151, 86, 255))
    elseif self.selected then
        draw.RoundedBox(3, 0, 0, w, h, Color(66, 129, 244, 255))
    else
        draw.RoundedBox(3, 0, 0, w, h, Color(247, 247, 247, 255))
    end

    -- Highlighting :)
    --surface.SetDrawColor(255, 255, 255, 255)
    --surface.DrawLine(1, 0, w-2, 0)
    --surface.DrawLine(0, 1, w, 1)

    --surface.SetDrawColor(214, 214, 214, 255)
    --surface.DrawLine(1, h-1, w-2, h-1)
end

function PANEL:SetMapData(data)
    self.data = data

    self.mapName:SetText(data.name)
    self.mapName:SizeToContents()
    self.mapName:SetPos(self:GetWide() / 2 - self.mapName:GetWide() / 2, self:GetTall() - self.mapName:GetTall() - 10)
    self.mapImage:SetHTML("<!doctype html><html><head><style>html, body{margin:0;padding:0;background-color: rgb(247, 247, 247);font-family: Roboto, Arial;}div.mapImage{position: absolute;width: 100%;height: 100%;background-repeat: no-repeat;background-position: center center;background-size: cover; background-image: url(\"https://i.imgur.com/" .. data.imgur .. ".jpg\")}</style></head><body><div class=\"mapImage\"></div></body></html>")
end

function PANEL:SetVotes(votes)
    self.votes:SetText(votes)

    if votes < 1 then
        self.votes:SetVisible(false)
    else
        self.votes:SetVisible(true)
        self.votes:SizeToContents()
        self.votes:SetPos(self:GetWide() - self.votes:GetWide() - 10, self.mapImage:GetTall() - self.votes:GetTall() - 5)
    end
end

function PANEL:SetSelected(selected)
    self.selected = selected

    if selected or self.flashed then
        self.mapName:SetColor(Color(255, 255, 255))
    else
        self.mapName:SetColor(Color(0, 0, 0))
    end
end

function PANEL:SetFlashed(flashed)
    self.flashed = flashed

    if flashed or self.selected then
        self.mapName:SetColor(Color(255, 255, 255))
    else
        self.mapName:SetColor(Color(0, 0, 0))
    end
end

function PANEL:SetShadow(alpha, distance)
    self.shadowAlpha = alpha
    self.shadowDistance = distance
end

vgui.Register("ZMVMapIcon", PANEL, "Panel")
