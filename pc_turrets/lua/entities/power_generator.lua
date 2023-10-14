-- "addons\\asap-turrets\\lua\\entities\\asap_turret_generator.lua"
-- Retrieved by https://github.com/c4fe/glua-steal
AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName = "Power Generator"
ENT.Category = "Helix"
ENT.Spawnable = true
ENT.AdminSpawnable = false
ENT.AutomaticFrameAdvance = true 
ENT.IsGenerator = true
ENT.MaxHealth = 1500
function ENT:SetupDataTables()
    self:NetworkVar("Float", 0, "Power")
    self:NetworkVar("Int", 0, "Level")
    self:NetworkVar("Entity", 1, "owning_ent")
end

if SERVER then
    hook.Add("OnPlayerChangedTeam", "PC_Turrets_RemoveOnJobChange", function(ply,old,new)
        if old != new then
            for k, v in pairs(ents.FindByClass("power_generator")) do
                if v:Getowning_ent() == ply then
                    v:Remove()
                end
            end
            for k, v in pairs(ents.FindByClass("ent_turret")) do
                if v:Getowning_ent() == ply then
                    v:Remove()
                end
            end
        end
    end)
end

function ENT:SpawnFunction(ply, tr, class)
    if (not tr.Hit) then return end
    local SpawnPos = tr.HitPos + tr.HitNormal * 4
    local ent = ents.Create(class)
    ent:SetCreator(ply)
    ent:SetPos(SpawnPos)
    ent:Spawn()
    ent:Activate()
    ent:DropToFloor()
    if (ent.Setowning_ent) then
        ent:Setowning_ent(ply)
    end

    return ent
end

function ENT:Initialize()
    if SERVER then
        self:SetModel("models/tnt/lightning_lv3.mdl")
        self:PhysicsInitStatic(SOLID_VPHYSICS)
        self:SetUseType(SIMPLE_USE)
        self:SetHealth(self.MaxHealth)
    end
    self:SetPower(0)
    self:SetLevel(1)
    self:Regenerate()
    self:SetSequence("spin")
end

function ENT:Regenerate()
    if self:GetPower() < self:GetMaxPower() then
        if self:GetPower() + (150 *  self:GetLevel()) >= self:GetMaxPower() then
            self:SetPower(self:GetMaxPower())
        else
            self:SetPower(self:GetPower() + (150 *  self:GetLevel()))
        end
    end 
end

function ENT:OnRemove()
end

local nextThink = CurTime()
function ENT:Think()
    if nextThink <= CurTime() then 
        self:Regenerate()
        nextThink = CurTime() + (5 / self:GetLevel())
    end
end

function ENT:Use(ply)
    ply:ConCommand("_powergenmenu")
end

function ENT:GetMaxPower()
    return 150 + self:GetLevel() * 100
end

function ENT:Explode()
    --[[
    local explode = ents.Create("env_explosion") -- creates the explosion
    explode:SetPos(self:GetOrigin())
    explode:SetOwner(self) -- this sets you as the person who made the explosion
    explode:Spawn() --this actually spawns the explosion
    explode:SetKeyValue("iMagnitude", "100") -- the magnitude
    explode:Fire("Explode", 0, 0)
    explode:EmitSound("weapon_AWP.Single", 400, 400)
    ]]
    SafeRemoveEntity(self)
end

function ENT:OnTakeDamage(dmg)
    self:SetHealth(self:Health() - dmg:GetDamage())

    if (self:Health() <= 0) then
        self:Explode()
    end
end


if CLIENT then
    local star = surface.GetTextureID("candy/turrets/ui/star")
    local star_back = surface.GetTextureID("candy/turrets/ui/star_back")
    concommand.Add("_powergenmenu", function()
        local tr = util.TraceLine( {
            start = LocalPlayer():EyePos(),
            endpos = LocalPlayer():EyePos() + EyeAngles():Forward() * 200,
            filter = function( ent ) return ( ent:GetClass() == "power_generator" ) end
        } )
        local ent = tr.Entity
        if ent:GetPos():Distance(LocalPlayer():GetPos()) > 200 then return end
        if IsValid(query) then
            query:Remove()
        end
        query = vgui.Create("XeninUI.Frame")
        query:SetTitle("Generator Menu")
        query:SetSize(VoidUI.Scale(300),VoidUI.Scale(300))
        query:Center()
        query:MakePopup()
        local StarPanel = vgui.Create("DPanel",query)
        StarPanel:Dock(TOP)
        StarPanel:SetTall(VoidUI.Scale(150))
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
        upButton:DockMargin(10, 15, 10, 15)
        upButton.Paint = function(s,w,h)
            draw.RoundedBox(8, 0, 0, w, h, ent:GetLevel() < 5 and Color(36, 136, 36) or Color(136, 36, 36))
            draw.SimpleText("Upgrade [$50,000]", "GlobalFont_30", w/2, h/2, color_white, 1, 1)
            if s:IsHovered() then
                draw.RoundedBox(8, 0, 0, w, h, Color(0, 0, 0, 100))
            end
        end
        upButton.DoClick = function()
            RunConsoleCommand("_genupgrade")
        end

        local healButton = vgui.Create("DButton",query)
        healButton:Dock(BOTTOM)
        healButton:SetTall(50)
        healButton:SetText("")
        healButton:DockMargin(10, 15, 10, 15)
        healButton.Paint = function(s,w,h)
            draw.RoundedBox(8, 0, 0, w, h, ent:Health() < 1500 and Color(36, 136, 36) or Color(136, 36, 36))
            draw.SimpleText("Heal [$10,000]", "GlobalFont_30", w/2, h/2, color_white, 1, 1)
            if s:IsHovered() then
                draw.RoundedBox(8, 0, 0, w, h, Color(0, 0, 0, 100))
            end
        end
        healButton.DoClick = function()
            RunConsoleCommand("_genheal")
        end

    end)

    local w, h = 192, 76
    function ENT:Draw()
        self:DrawModel()
        if (self:GetPower() > 0) then
            self:ManipulateBoneAngles(1, Angle(0, 0, RealTime() * 512))
        end

        local pos = self:GetPos() + Vector(0, 0, 45)
        local ang = (EyePos() - pos):Angle()
        ang = Angle(0, ang.y, 0)
        pos = pos + Vector(math.cos(math.rad(ang.y)) * 38, math.sin(math.rad(ang.y)) * 38, 0)
        ang:RotateAroundAxis(ang:Up(), 90)
        ang:RotateAroundAxis(ang:Forward(), 60)
        cam.Start3D2D(pos, ang, .1)
            draw.RoundedBox(8, -w / 2, -16, w, h, Color(36, 36, 36))
            draw.SimpleText("GENERATOR", "XeninUI.Frame.Title", 0, 0, color_white, 1, 1)

            surface.SetDrawColor(color_white)
            local starSize = (w - 8 * 5) / 5
            for k = 1, 5 do
                surface.SetTexture(self:GetLevel() >= k and star or star_back)
                surface.DrawTexturedRect(-w / 2 + (k - 1) * (starSize + 8) + 4, 26, starSize, starSize)
            end

            surface.SetDrawColor(0, 0, 0)
            surface.DrawRect(-w / 2 + 4, 14, w - 8, 10)

            surface.SetDrawColor(75, 175, 255)
            surface.DrawRect(-w / 2 + 5, 15, (w - 10) * math.Clamp(self:GetPower() / self:GetMaxPower(), 0, 1), 4)

            surface.SetDrawColor(255, 75, 75)
            surface.DrawRect(-w / 2 + 5, 20, (w - 10) * math.Clamp(self:Health() / self.MaxHealth, 0, 1), 3)
        cam.End3D2D()
    end
elseif SERVER then
    local nextAction = CurTime()
    concommand.Add("_genupgrade", function(ply,cmd,args)
        local tr = util.TraceLine( {
            start = ply:EyePos(),
            endpos = ply:EyePos() + ply:EyeAngles():Forward() * 200,
            filter = function( ent ) return ( ent:GetClass() == "power_generator" ) end
        } )
        local ent = tr.Entity
        if ent:GetPos():Distance(ply:GetPos()) > 200 then return end
        if nextAction <= CurTime() then 
            if ply:canAfford(50000) and ent:GetLevel() < 5 then
                ply:addMoney(-50000)
                ent:SetLevel(ent:GetLevel() + 1)
            end
            nextAction = CurTime() + 1
        end
    end)
    concommand.Add("_genheal", function(ply,cmd,args)
        local tr = util.TraceLine( {
            start = ply:EyePos(),
            endpos = ply:EyePos() + ply:EyeAngles():Forward() * 200,
            filter = function( ent ) return ( ent:GetClass() == "power_generator" ) end
        } )
        local ent = tr.Entity
        if ent:GetPos():Distance(ply:GetPos()) > 200 then return end
        if nextAction <= CurTime() then 
            if ply:canAfford(10000) and ent:Health() < 1500 then
                ply:addMoney(-10000)
                ent:SetHealth(1500)
            end
            nextAction = CurTime() + 1
        end
    end)
end