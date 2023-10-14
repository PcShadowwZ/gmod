include("shared.lua")

ENT.IdealAngle = Angle(0, 0, 0)
local laser = Material("sprites/physbeam")
--ENT.ClipProgress = 0

local entColors = {
    [1] = Color(181, 136, 29),
    [2] = Color(181, 136, 29),
    [3] = Color(255, 255, 255),
    [4] = Color(255, 255, 255),
    [5] = Color(255, 249, 76)
}

local hud = surface.GetTextureID("candy/turrets/ui/hud")
local health_hud = surface.GetTextureID("candy/turrets/ui/health")
local energy = surface.GetTextureID("candy/turrets/ui/energy")
local star = surface.GetTextureID("candy/turrets/ui/star")
local star_back = surface.GetTextureID("candy/turrets/ui/star_back")

local function drawMask(obj, mask)
    -- Reset everything to known good
    render.SetStencilWriteMask(0xFF)
    render.SetStencilTestMask(0xFF)
    render.SetStencilReferenceValue(0)
    -- render.SetStencilCompareFunction( STENCIL_ALWAYS )
    render.SetStencilPassOperation(STENCIL_KEEP)
    -- render.SetStencilFailOperation( STENCIL_KEEP )
    render.SetStencilZFailOperation(STENCIL_KEEP)
    render.ClearStencil()
    -- Enable stencils
    render.SetStencilEnable(true)
    -- Set everything up everything draws to the stencil buffer instead of the screen
    render.SetStencilReferenceValue(1)
    render.SetStencilCompareFunction(STENCIL_NEVER)
    render.SetStencilFailOperation(STENCIL_REPLACE)
    mask()
    -- Only draw things that are in the stencil buffer
    render.SetStencilCompareFunction(STENCIL_EQUAL)
    render.SetStencilFailOperation(STENCIL_KEEP)
    obj()
    render.SetStencilEnable(false)
end

local colors = {
    [0] = Vector(1, 1, 1),
    [1] = Vector(.2, .6, 1),
    [2] = Vector(1, .8, .2),
    [3] = Vector(.9, .15, .15),
    [4] = Vector(.2, .8, .15)
}

function ENT:GetPlayerColor()
    return colors[self:GetElement()]
end

ENT.HUDAmount = 0

function ENT:DrawInfo(b)
    self.HUDAmount = Lerp(FrameTime() * 5, self.HUDAmount, b and 1 or 0)
    local pos, ang = self:GetPos() + Vector(0, 0, (50) * self.HUDAmount), EyeAngles()
    ang:RotateAroundAxis(ang:Up(), -90)
    ang:RotateAroundAxis(ang:Forward(), 90)
    pos = pos + EyeAngles():Right() * 12 * self.HUDAmount
    pos = pos + EyeAngles():Up() * 4 * self.HUDAmount
    local health = self:Health() / self:GetMaxHealth()
    cam.Start3D2D(pos, ang, .125 * self.HUDAmount)
    surface.SetDrawColor(Color(255, 255, 255, self.HUDAmount * 255))
    surface.SetTexture(hud)
    surface.DrawTexturedRect(0, 0, 256, 128)

    local poly = {
        {
            x = 20 + 4,
            y = 15
        },
        {
            x = 20 + 215 * health,
            y = 15
        },
        {
            x = 20 + 215 * health - 4,
            y = 31
        },
        {
            x = 20,
            y = 31
        }
    }

    drawMask(function()
        surface.SetTexture(health_hud)
        surface.SetDrawColor(Color(255, 255, 255, 255))
        surface.DrawTexturedRect(0, 0, 256, 128)
    end, function()
        draw.NoTexture()
        surface.SetDrawColor(color_white)
        surface.DrawPoly(poly)
    end)

    surface.SetTexture(energy)
    surface.SetDrawColor(Color(255, 255, 255, 255))
    surface.DrawTexturedRect(0, 0, 256, 128)
    surface.SetTexture(star_back)
    surface.SetDrawColor(color_white)

    for k = 1, 5 do
        surface.SetTexture(self:GetLevel() >= k and star or star_back)
        surface.DrawTexturedRect(35 + k * 32, 45, 20, 20)
    end

    if (self:GetElement() > 1) then
        local element = self.ElementConfig[self:GetElement()]
        surface.SetMaterial(Material(element.Icon))
        surface.DrawTexturedRectRotated(37, 61, 36, 36, 0)
    end

    cam.End3D2D()
end

ENT.LastView = 0
local laser = Material("sprites/physbeam")

function ENT:Draw()
    if ((self.ClipProgress or 0) < .99) then
        if !self.ClipProgress then
            self.ClipProgress = 0
        end
        self.ClipProgress = Lerp(FrameTime() / 2, self.ClipProgress or 0, self.ClipProgress * 10 + .1)

        if (not IsValid(self.WireModel)) then
            self.WireModel = ClientsideModel(self:GetModel())
            self.WireModel:SetParent(self)
            self.WireModel:SetLocalPos(Vector(0, 0, 0))
            self.WireModel:SetLocalAngles(Angle(0, 0, 0))
            self.WireModel:SetMaterial("models/wireframe")
            self.WireModel:SetNoDraw(true)
        end

        local tall = self:GetModelRadius()
        local normal = self:GetUp() -- Everything "behind" this normal will be clipped
        local position = normal:Dot(self:GetPos() + self:GetUp() * (tall * self.ClipProgress)) -- self:GetPos() is the origin of the clipping plane
        local oldEC = render.EnableClipping(true)
        render.PushCustomClipPlane(normal, position)
        self.WireModel:DrawModel()
        render.PopCustomClipPlane()
        render.EnableClipping(oldEC)
        normal = -self:GetUp() -- Everything "behind" this normal will be clipped
        position = normal:Dot(self:GetPos() + self:GetUp() * (tall * self.ClipProgress)) -- self:GetPos() is the origin of the clipping plane
        oldEC = render.EnableClipping(true)
        render.PushCustomClipPlane(normal, position)
        self:DrawModel()
        render.PopCustomClipPlane()
        render.EnableClipping(oldEC)
        return
    end
    self:SetColor(self:GetPlayerColor():ToColor())
    self:DrawModel()
    if halo.RenderedEntity() == self then return end
    local dot = LocalPlayer():GetEyeTrace().Entity == self
    self:DrawInfo(dot)


    if (self.MuzzleAtt) then
        local att = self:GetAttachment(self.MuzzleAtt)
        if (not att) then return end
        local trace = util.QuickTrace(att.Pos, att.Ang:Forward() * 4192, self)
        local dist = att.Pos:Distance(trace.HitPos)
        render.SetMaterial(laser)
        render.SetColorModulation(1, .5, 0)
        render.StartBeam(2)
        render.AddBeam(att.Pos, 8, RealTime() % 1, Color(255, 0, 0))
        render.AddBeam(trace.HitPos, 8, dist / 32 + RealTime() % 1 + 1, Color(200, 0, 0))
        render.EndBeam()
    end

    if self:Getowning_ent() then
        local ply = self:Getowning_ent()
        for k, v in pairs(ents.FindByClass("power_generator")) do
            if v:Getowning_ent() == self:Getowning_ent() then
                local generator = v
                if v:GetPos():Distance(self:GetPos()) <= 500 then
                    render.SetMaterial(laser)
                    --render.SetColorModulation(1, .5, 0)
                    render.StartBeam(2)
                    render.DrawBeam( v:GetPos(), self:GetPos(), 10, 1, 1, Color(255,0,0) )
                    render.EndBeam()
                end
            end
        end
    end
end

function ENT:OnRemove()
end

concommand.Add("_turretmenu", function()
    local tr = util.TraceLine( {
        start = LocalPlayer():EyePos(),
        endpos = LocalPlayer():EyePos() + EyeAngles():Forward() * 200,
        filter = function( ent ) return ( ent:GetClass() == "ent_turret" ) end
    } )
    local ent = tr.Entity
    if ent:GetPos():Distance(LocalPlayer():GetPos()) > 200 then return end
    if ent:GetisPolice() then return end
    if IsValid(query) then
        query:Remove()
    end
    query = vgui.Create("XeninUI.Frame")
    query:SetTitle("Turret Menu")
    query:SetSize(VoidUI.Scale(300),VoidUI.Scale(400))
    query:Center()
    query:MakePopup()
    local StarPanel = vgui.Create("DPanel",query)
    StarPanel:Dock(TOP)
    StarPanel:SetTall(VoidUI.Scale(100))
    StarPanel.Paint = function(s,w,h)
        surface.SetDrawColor(color_white)
        local starSize = (w - 8 * 5) / 5
        for k = 1, 5 do
            surface.SetTexture(ent:GetLevel() >= k and star or star_back)
            surface.DrawTexturedRect(0  + (k - 1) * (starSize + 8) + 4, 26, starSize, starSize)
        end
    end
    local upButton = vgui.Create("DButton",query)
    upButton:Dock(BOTTOM)
    upButton:SetTall(50)
    upButton:SetText("")
    upButton:DockMargin(10, 10, 10, 10)
    upButton.Paint = function(s,w,h)
        draw.RoundedBox(8, 0, 0, w, h, ent:GetLevel() < 5 and Color(36, 136, 36) or Color(136, 36, 36))
        draw.SimpleText("Upgrade [$50,000]", "GlobalFont_30", w/2, h/2, color_white, 1, 1)
        if s:IsHovered() then
            draw.RoundedBox(8, 0, 0, w, h, Color(0, 0, 0, 100))
        end
    end
    upButton.DoClick = function()
        RunConsoleCommand("_turretupgrade")
    end

    local healButton = vgui.Create("DButton",query)
    healButton:Dock(BOTTOM)
    healButton:SetTall(50)
    healButton:SetText("")
    healButton:DockMargin(10, 10, 10, 10)
    healButton.Paint = function(s,w,h)
        draw.RoundedBox(8, 0, 0, w, h, ent:Health() < 1500 and Color(36, 136, 36) or Color(136, 36, 36))
        draw.SimpleText("Heal [$10,000]", "GlobalFont_30", w/2, h/2, color_white, 1, 1)
        if s:IsHovered() then
            draw.RoundedBox(8, 0, 0, w, h, Color(0, 0, 0, 100))
        end
    end
    healButton.DoClick = function()
        RunConsoleCommand("_turretheal")
    end

    local ElementPanel = vgui.Create("DPanel",query)
    ElementPanel:Dock(TOP)
    ElementPanel:SetTall(VoidUI.Scale(60))
    ElementPanel.Paint = function(s,w,h)
        draw.RoundedBox(8, 0, 0, w, h, Color(0,0,0,0))
    end

    for k = 1, 5 do
        local ElementSize = 50
        local element = vgui.Create("DButton",ElementPanel)
        element:SetPos(0  + (k - 1) * (ElementSize + 8) + 4, 0)
        element:SetSize(ElementSize, ElementSize)
        element:SetText("")
        element.Paint = function(s,w,h)
            draw.RoundedBox(8, 0, 0, w, h, ent:GetElement() == k-1 and Color(55,255,55) or Color(15,15,15,255))
            if (k-1) > 0 and ent:GetLevel() >= k then
                surface.SetDrawColor(255,255,255)
                surface.SetTexture(surface.GetTextureID(ent.ElementConfig[k-1].Icon))
                surface.DrawTexturedRect(0, 0, w, h)
            else
                draw.SimpleText("X", "GlobalFont_30", w/2, h/2, color_white, 1, 1)
            end
        end
        element.DoClick = function()
            RunConsoleCommand("_turretelement", k-1)
        end
    end

    local buddyButton = vgui.Create("DButton",query)
    buddyButton:Dock(BOTTOM)
    buddyButton:SetTall(50)
    buddyButton:SetText("")
    buddyButton:DockMargin(10, 10, 10, 10)
    buddyButton.Paint = function(s,w,h)
        draw.RoundedBox(8, 0, 0, w, h, Color(36, 136, 36))
        draw.SimpleText("Buddies", "GlobalFont_30", w/2, h/2, color_white, 1, 1)
        if s:IsHovered() then
            draw.RoundedBox(8, 0, 0, w, h, Color(0, 0, 0, 100))
        end
    end
    local newplayerList = nil
    buddyButton.DoClick = function()
        if IsValid(newplayerList) then
            newplayerList:Remove()
        end
        newplayerList = vgui.Create("XeninUI.Frame",query)
        local x, y = input.GetCursorPos()
        newplayerList:SetPos(x, y)
        newplayerList:SetSize(256, 300)
        newplayerList:SetTitle("Add Buddy...")
        newplayerList:MakePopup()
        local scroller = vgui.Create("XeninUI.Scrollpanel.Wyvern", newplayerList)
        scroller:Dock(FILL)
        for k, v in pairs(player.GetAll()) do
            if v != LocalPlayer() then
                local player = vgui.Create("DButton",scroller)
                player:Dock(TOP)
                player:DockMargin(3,3,3,3)
                player:SetTall(20)
                player:SetText("")
                player.Paint = function(s,w,h)
                    if table.HasValue(ent.Friendlies, v) then
                        draw.RoundedBox(8, 0, 0, w, h, Color(36, 136, 36))
                    else
                        draw.RoundedBox(8, 0, 0, w, h, Color(25, 25, 25))
                    end
                    draw.SimpleText(v:Nick(), "GlobalFont_20", w/2, h/2, color_white, 1, 1)
                end
                player.DoClick = function()
                    if !table.HasValue(ent.Friendlies, v) then
                        table.insert(ent.Friendlies, v)
                        RunConsoleCommand("_turretbuddies", v:SteamID64(), 1)
                    else
                        table.RemoveByValue(ent.Friendlies, v)
                        RunConsoleCommand("_turretbuddies", v:SteamID64(), 0)
                    end
                end
            end
        end
    end

end)