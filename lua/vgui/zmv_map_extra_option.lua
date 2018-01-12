local PANEL = {}

function PANEL:Init()
    self.shadowAlpha = 25
    self.shadowDistance = 3
    self.selected = false
    self.flashed = false

    self:SetWide(144)
    self:SetTall(40)
    self:SetMouseInputEnabled(true)
    self:SetCursor("hand")

    self.mapName = vgui.Create("DLabel", self)
    self.mapName:SetFont("ZMapVoteText")
    self.mapName:SetText("Extra Option")
    self.mapName:SetColor(Color(0, 0, 0))
    self.mapName:SizeToContents()
    self.mapName:SetPos(self:GetWide() / 2 - self.mapName:GetWide() / 2, self:GetTall() / 2  - self.mapName:GetTall() / 2)

    self.votes = vgui.Create("DLabel", self)
    self.votes:SetFont("ZMapVoteCount")
    self.votes:SetColor(Color(255, 255, 0))
    self.votes:SetExpensiveShadow(1, Color(0, 0, 0, 200))
    self.votes:SetText("0")
    self.votes:SizeToContents()
    self.votes:SetPos(self:GetWide() - self.votes:GetWide() - 10, self:GetTall() / 2 - self.votes:GetTall() / 2)
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

function PANEL:SetText(text)
    self.mapName:SetText(text)
    self.mapName:SizeToContents()
end

function PANEL:SetVotes(votes)
    self.votes:SetText(votes)

    if votes < 1 then
        self.votes:SetVisible(false)
        self.mapName:SetPos(self:GetWide() / 2 - self.mapName:GetWide() / 2, self:GetTall() / 2  - self.mapName:GetTall() / 2)
    else
        self.votes:SetVisible(true)
        self.votes:SizeToContents()
        self.mapName:SetPos(16, self:GetTall() / 2  - self.mapName:GetTall() / 2)
        self.votes:SetPos(self:GetWide() - self.votes:GetWide() - 10, self:GetTall() / 2 - self.votes:GetTall() / 2)
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

vgui.Register("ZMVExtraOption", PANEL, "Panel")
