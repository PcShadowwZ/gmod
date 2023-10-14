include("shared.lua")
PC_MethConfig = PC_MethConfig or {}
function ENT:Draw()
    self:DrawModel()
  
    local ply = LocalPlayer()
    local pos = self:GetPos()
    local eyePos = ply:GetPos()
    local dist = pos:Distance(eyePos)
    local alpha = math.Clamp(2500 - dist * 2.7, 0, 255)
  
    if (alpha <= 0) then return end
  
    local angle = self:GetAngles()
    local eyeAngle = ply:EyeAngles()
  
    angle:RotateAroundAxis(angle:Forward(), 90)
    angle:RotateAroundAxis(angle:Right(), - 90)
  
    cam.Start3D2D(pos + self:GetUp() * 60, Angle(0, eyeAngle.y - 90, 90), 0.04)
      draw.SimpleText("Meth Mixer","GlobalFont_100", 0,0,color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    cam.End3D2D()
end

concommand.Add("_meth_mixer_open", function()
    local tr = util.TraceLine( {
        start = LocalPlayer():EyePos(),
        endpos = LocalPlayer():EyePos() + EyeAngles():Forward() * 10000,
        filter = function( ent ) return ( ent:GetClass() == "meth_mixer" ) end
    } )
    local ent = tr.Entity
    if ent:GetPos():Distance(LocalPlayer():GetPos()) > 100 then return end
    if IsValid(query) then
        query:Remove()
    end
    query = vgui.Create("XeninUI.Frame")
    query:SetTitle("Meth Mixer Menu")
    query:SetSize(VoidUI.Scale(500),VoidUI.Scale(550))
    query:Center()
    query:MakePopup()

    local Btn = query:Add("DButton")
    Btn:SetText("")
    Btn:DockMargin(10,10,10,10)
    Btn:Dock(BOTTOM)
    Btn:SetTall(100)
    Btn.Paint = function(s,w,h)
        local state = ent:GetNWInt("State")
        if state == 0 then
            local mixState = false
            if ent:GetNWFloat("Aluminium", 0) >= 100 and ent:GetNWFloat("Methylamine", 0) >= 100 then
                draw.RoundedBox(5, 0, 0, w,h,Color(25,255,25))
            else
                draw.RoundedBox(5, 0, 0, w,h,Color(255,25,25))
            end
            draw.SimpleText("Start Mixing","GlobalFont_30", w/2,h/2,color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
        if state == 1 then
            if ent:GetNWFloat("MixTime", CurTime()) > CurTime() then
                draw.RoundedBox(5, 0, 0, w,h,Color(255,25,25))
            else
                draw.RoundedBox(5, 0, 0, w,h,Color(25,255,25))
            end
            draw.SimpleText("Harvest","GlobalFont_30", w/2,h/2,color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
        if s:IsHovered() then
            draw.RoundedBox(5, 0, 0, w,h,Color(0,0,0,200))
        end
    end
    Btn.DoClick = function()
        local state = ent:GetNWInt("State")
        if state == 0 then
            LocalPlayer():ConCommand("_meth_start")
        else
            LocalPlayer():ConCommand("_meth_harvest")
        end
    end

    local AluminiumPanel = query:Add("DPanel")
    AluminiumPanel:DockMargin(10,10,10,10)
    AluminiumPanel:Dock(TOP)
    AluminiumPanel:SetTall(100)
    AluminiumPanel.Paint = function(s,w,h)
        draw.RoundedBox(5, 0, 0, w,h,Color(30,30,30,200))
        draw.RoundedBox(5, 5, 5, w-10,h-10,Color(40,40,40,200))
        local frac = ent:GetNWFloat("Aluminium", 0)/100
        draw.RoundedBox(5, 5, 5, (w-10) * frac,h-10,Color(240,240,240,200))
        draw.SimpleText("Aluminium - "..ent:GetNWFloat("Aluminium", 0).."/100","GlobalFont_30", w/2,h/2,Color(100,100,100), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    local MeffPanel = query:Add("DPanel")
    MeffPanel:DockMargin(10,10,10,10)
    MeffPanel:Dock(TOP)
    MeffPanel:SetTall(100)
    MeffPanel.Paint = function(s,w,h)
        draw.RoundedBox(5, 0, 0, w,h,Color(30,30,30,200))
        draw.RoundedBox(5, 5, 5, w-10,h-10,Color(40,40,40,200))
        local frac = ent:GetNWFloat("Methylamine", 0)/100
        draw.RoundedBox(5, 5, 5, (w-10) * frac,h-10,Color(200,170,0,200))
        draw.SimpleText("Methylamine - "..ent:GetNWFloat("Methylamine", 0).."/100","GlobalFont_30", w/2,h/2,Color(100,100,100), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    local TimePanel = query:Add("DPanel")
    TimePanel:DockMargin(10,10,10,10)
    TimePanel:Dock(TOP)
    TimePanel:SetTall(100)
    TimePanel.Paint = function(s,w,h)
        local state = ent:GetNWInt("State")
        draw.RoundedBox(5, 0, 0, w,h,Color(30,30,30,200))
        draw.RoundedBox(5, 5, 5, w-10,h-10,Color(40,40,40,200))
        if state == 1 then
            local frac = (ent:GetNWFloat("MixTime", CurTime()) - CurTime())/180
            print(frac)
            draw.RoundedBox(5, 5, 5, (w-10) * frac,h-10,Color(20,170,170,200))
            if ent:GetNWFloat("MixTime", CurTime()) <= CurTime() then
                draw.SimpleText("Ready To Harvest","GlobalFont_30", w/2,h/2,Color(100,200,100), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            else
                draw.SimpleText("Time Left: " ..math.Round(ent:GetNWFloat("MixTime", CurTime()) - CurTime()).."s","GlobalFont_30", w/2,h/2,Color(100,100,100), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end
        else
            draw.SimpleText("Not Mixing","GlobalFont_30", w/2,h/2,Color(100,100,100), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    end

end)