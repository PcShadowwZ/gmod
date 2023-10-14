include("shared.lua")
PC_WeedConfig = PC_WeedConfig or {}
PC_WeedConfig.Pot = PC_WeedConfig.Pot or {}
function ENT:Draw()
    self:DrawModel()
    local weedTable = PC_WeedConfig.Pot.WeedStates[self:GetNWInt("GrowState", 1)]
    if IsValid(self.Weed) and self.Weed:GetModel() != weedTable.Model then
        self.Weed:Remove()
        self.Weed = ClientsideModel(weedTable.Model)
    end
    self.Weed = self.Weed or ClientsideModel(weedTable.Model)
    local LVec, LAng = LocalToWorld( weedTable.Position, Angle(0,0,0), self:GetPos(),self:GetAngles())
    if IsValid(self.Weed) then
        self.Weed:DrawModel()	
        self.Weed:SetAngles(LAng)
        self.Weed:SetPos(LVec)
        self.Weed:SetModelScale(weedTable.ModelScale,0)
        self.Weed:SetColor(weedTable.Color)
        self.Weed:SetMaterial(weedTable.Material or "")
    else
        self.Weed = nil
    end
end

concommand.Add("_weed_pot_open", function()
    local tr = util.TraceLine( {
        start = LocalPlayer():EyePos(),
        endpos = LocalPlayer():EyePos() + EyeAngles():Forward() * 10000,
        filter = function( ent ) return ( ent:GetClass() == "weed_pot" ) end
    } )
    local ent = tr.Entity
    if ent:GetPos():Distance(LocalPlayer():GetPos()) > 100 then return end
    if IsValid(query) then
        query:Remove()
    end
    query = vgui.Create("XeninUI.Frame")
    query:SetTitle("Weed Pot Menu")
    query:SetSize(VoidUI.Scale(300),VoidUI.Scale(300))
    query:Center()
    query:MakePopup()
    local weedTable = PC_WeedConfig.Pot.WeedStates[ent:GetNWInt("GrowState", 1)]
    local State = query:Add("DPanel")
    State:Dock(TOP)
    State:SetTall(100)
    State:DockMargin(10,10,10,10)
    State.Paint = function(s,w,h)
        weedTable = PC_WeedConfig.Pot.WeedStates[ent:GetNWInt("GrowState", 1)]
        draw.RoundedBox(5, 0, 0, w,h,Color(40,40,40))
        draw.SimpleText("State = "..weedTable.Name,"GlobalFont_30", w/2,h/2,color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        local harvestState = "False"
        if weedTable.CanHarvest then
            harvestState = "True"
        end
        draw.SimpleText("Harvestable = "..harvestState,"GlobalFont_20", w/2,h/1.25,harvestState == "True" and Color(25,255,25) or Color(255,25,25), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    local Btn = query:Add("DButton")
    Btn:SetText("")
    Btn:DockMargin(10,10,10,10)
    Btn:Dock(TOP)
    Btn:SetTall(100)
    Btn.Paint = function(s,w,h)
        weedTable = PC_WeedConfig.Pot.WeedStates[ent:GetNWInt("GrowState", 1)]
        local harvestState = "False"
        if weedTable.CanHarvest then
            harvestState = "True"
        end
        draw.RoundedBox(5, 0, 0, w,h,harvestState == "True" and Color(25,255,25) or Color(255,25,25))
        draw.SimpleText("Harvest","GlobalFont_30", w/2,h/2,color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        if s:IsHovered() then
            draw.RoundedBox(5, 0, 0, w,h,Color(0,0,0,200))
        end
    end
    Btn.DoClick = function()
        LocalPlayer():ConCommand("_weed_harvest")
    end
end)