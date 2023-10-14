include("shared.lua")

function ENT:Draw()
    self:DrawModel()
    cam.Start3D2D(self:LocalToWorld(Vector(35.5,5.6,78.5)), self:LocalToWorldAngles(Angle(0,90,90)), 0.1)
        draw.RoundedBox( 5, -180, 85,360,215, Color(50,150,200,100) )
        draw.SimpleText(self:GetNWInt("Trash",0).." KG Trash","GlobalFont_60",0, 120, color_White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText("Press E For Menu","GlobalFont_40",0, 170, color_White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.RoundedBox( 5, -150, 200 , 300,50, Color(50,50,50,255) )
        if self:GetNWInt("State", 0) == 0 then
            draw.SimpleText("Not Processing","GlobalFont_40",0, 225, color_White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        else
            local frac = (self:GetNWFloat("Time", CurTime()) - CurTime())/self:GetNWInt("MaxTime", 0)
            draw.RoundedBox( 5, -147.5, 202.5, 295 * frac,45, Color(50,150,200,255) )
            draw.SimpleText(math.Round(self:GetNWFloat("Time", CurTime()) - CurTime()).."s Left","GlobalFont_40",0, 225, color_White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    cam.End3D2D()
end

concommand.Add("_trash_recycler_open", function()
    local tr = util.TraceLine( {
        start = LocalPlayer():EyePos(),
        endpos = LocalPlayer():EyePos() + EyeAngles():Forward() * 10000,
        filter = function( ent ) return ( ent:GetClass() == "trash_recycler" ) end
    } )
    local ent = tr.Entity
    if ent:GetPos():Distance(LocalPlayer():GetPos()) > 100 then return end
    if IsValid(query) then
        query:Remove()
    end
    query = vgui.Create("XeninUI.Frame")
    query:SetTitle("Trash Recycler Menu")
    query:SetSize(VoidUI.Scale(300),VoidUI.Scale(290))
    query:Center()
    query:MakePopup()
    local PricePanel = query:Add("DPanel")
    PricePanel:Dock(TOP)
    PricePanel:DockMargin(5,5,5,5)
    PricePanel:SetTall(50)
    PricePanel.Paint = function(s,w,h)
        draw.RoundedBox(5,0,0,w,h,Color(50,150,200,100))
        draw.SimpleText("Trash Selling Price/KG: $".. 2.2 * GetGlobalInt("Trash_Price_Multiplier", 100),"GlobalFont_25",w/2, h/2, color_White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    local AmtPanel = query:Add("DPanel")
    AmtPanel:Dock(TOP)
    AmtPanel:DockMargin(5,5,5,5)
    AmtPanel:SetTall(50)
    AmtPanel.Paint = function(s,w,h)
        draw.RoundedBox(5,0,0,w,h,Color(50,150,200,100))
        draw.SimpleText(ent:GetNWInt("Trash", 0).." KG Trash Inside","GlobalFont_25",w/2, h/2, color_White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    local ProgPanel = query:Add("DPanel")
    ProgPanel:Dock(TOP)
    ProgPanel:DockMargin(5,5,5,5)
    ProgPanel:SetTall(50)
    ProgPanel.Paint = function(s,w,h)
        draw.RoundedBox(5,0,0,w,h,Color(20,20,20,100))
        local frac = (ent:GetNWFloat("Time", CurTime()) - CurTime())/ent:GetNWInt("MaxTime", 0)
        if frac > 0 then
            draw.RoundedBox(5,5,5,(w-10) * frac,h-10,Color(50,150,200,255))
            draw.SimpleText(math.Round(ent:GetNWFloat("Time", CurTime()) - CurTime()).."s Left","GlobalFont_25",w/2, h/2, color_White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        else
            draw.SimpleText("Awaiting Processing","GlobalFont_25",w/2, h/2, color_White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    end

    local Btn = query:Add("DButton")
    Btn:Dock(TOP)
    Btn:DockMargin(5,5,5,5)
    Btn:SetTall(50)
    Btn:SetText("")
    Btn.Paint = function(s,w,h)
        if ent:GetNWInt("State", 0) == 0 and ent:GetNWInt("Trash", 0) > 0 then
            draw.RoundedBox(5,0,0,w,h,Color(25,255,25,255))
        else
            draw.RoundedBox(5,0,0,w,h,Color(255,25,25,255))
        end
        draw.SimpleText("Process","GlobalFont_25",w/2, h/2, color_White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    Btn.DoClick = function()
        LocalPlayer():ConCommand("_trash_recycle")
    end
end)