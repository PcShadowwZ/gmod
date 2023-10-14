include("shared.lua")
PC_DrugsConfig = PC_DrugsConfig or {}

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

  cam.Start3D2D(pos + self:GetUp() * 80, Angle(0, eyeAngle.y - 90, 90), 0.04)
    draw.SimpleText("Drugs NPC","GlobalFont_100", 0,0,color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
  cam.End3D2D()
end

concommand.Add("_drugs_menu", function()
  local tr = util.TraceLine( {
      start = LocalPlayer():EyePos(),
      endpos = LocalPlayer():EyePos() + EyeAngles():Forward() * 10000,
      filter = function( ent ) return ( ent:GetClass() == "drug_npc" ) end
  } )
  local ent = tr.Entity
  if ent:GetPos():Distance(LocalPlayer():GetPos()) > 100 then return end
  if IsValid(query) then
      query:Remove()
  end
  query = vgui.Create("XeninUI.Frame")
  query:SetTitle("Sell Drugs")
  query:SetSize(VoidUI.Scale(300),VoidUI.Scale(400))
  query:Center()
  query:MakePopup()
  local panelList = vgui.Create("DPanelList", query)
	panelList:Dock(FILL)
	panelList:SetPadding(10)
	panelList:SetSpacing(10)
	panelList:EnableVerticalScrollbar(true)
	panelList:EnableHorizontal(true)
	panelList.curFrames = {}
  for k, v in pairs(PC_DrugsConfig) do
    if !panelList.curFrames[k] then
      local ItemIcon = vgui.Create("DButton", panelList)
      ItemIcon:Dock(TOP)
      ItemIcon:SetTall(150)
      ItemIcon:DockMargin(10,10,10,10)
      ItemIcon:SetText("")
      ItemIcon.Paint = function(s,w,h)
          draw.RoundedBox(0, 0, 0, w, h, Color(30,30,30))
          draw.RoundedBox(0, 3, 3, w - 6, h - 6, Color(40,40,40))
          draw.RoundedBoxEx(0, 0, 0, w, 25, Color(0,0,0,225), true, true, false, false)
          draw.SimpleText(v.Name.. " $"..v.SellPrice * math.Round(GetGlobalFloat( v.Name.."_SellMultiplier", 100 )/100,2).." ["..math.Round(GetGlobalFloat( v.Name.."_SellMultiplier", 100 ),2).."%] Per Bag", "GlobalFont_20", w / 2,  12 , color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
          if s:IsHovered() then
              draw.RoundedBox(0, 0, 0, w, h, Color(0,0,0,200))
          end
      end
      ItemIcon.DoClick = function()
        Derma_StringRequest(
          "Sell "..v.Name, 
          "How Many To Sell?",
          "",
          function(text) print(text) RunConsoleCommand( "_drugs_sell", k, tonumber(text)) end,
          function(text) end
        )
      end
      local ItemModel = vgui.Create("DModelPanel", ItemIcon)
      ItemModel:Dock(FILL)
      ItemModel:SetMouseInputEnabled(false)
      ItemModel:SetModel(v.Model)
      local BMin, BMax = ItemModel.Entity:GetRenderBounds()    
      ItemModel:SetColor(color_white)
      ItemModel:SetCamPos((BMin:Distance(BMax)*Vector(0.75, 0.75, 0.5)))    
      ItemModel:SetLookAt((BMax + BMin)/2)
      ItemModel:SetFOV(100)
      function ItemModel:LayoutEntity(Ent)
      end
      panelList:AddItem(ItemIcon)
      panelList.curFrames[k] = ItemIcon
    end
  end
end)

hook.Add("HUDPaint", "Drug_WeedHudPaintUntilNewInv", function()
  if LocalPlayer():GetNWInt("PC_Drugs_Weed", 0) > 0 then
    draw.RoundedBox(8,ScrW() - VoidUI.Scale(100),VoidUI.Scale(200),VoidUI.Scale(100),VoidUI.Scale(100),Color(20,20,20))
    WeedIcon = WeedIcon or vgui.Create("SpawnIcon") 
    if WeedIcon then
      WeedIcon:SetPos( ScrW() - VoidUI.Scale(100),VoidUI.Scale(200) )
      WeedIcon:SetSize(VoidUI.Scale(100),VoidUI.Scale(100))
      WeedIcon:SetModel( "models/zerochain/props_growop2/zgo2_baggy.mdl" )
    end
    WeedTitle = WeedTitle or vgui.Create( "DLabel")
    if WeedTitle then  
      WeedTitle:SetPos( ScrW() - VoidUI.Scale(75),VoidUI.Scale(200) )
      WeedTitle:SetText( "Weed:" )
      WeedTitle:SetFont("GlobalFont_25")
      WeedTitle:SetColor(Color(255,255,255))
    end
    WeedAmt = WeedAmt or vgui.Create( "DLabel")  
    if WeedAmt then
      WeedAmt:SetPos( ScrW() - VoidUI.Scale(62.5),VoidUI.Scale(275) )
      WeedAmt:SetText( LocalPlayer():GetNWInt("PC_Drugs_Weed", 0) )
      WeedAmt:SetFont("GlobalFont_25")
      WeedAmt:SetColor(Color(255,255,255))
    end
  else
    if IsValid(WeedIcon) then
      WeedIcon:Remove()
      WeedIcon = nil
    end
    if IsValid(WeedTitle) then
      WeedTitle:Remove()
      WeedTitle = nil
    end
    if IsValid(WeedAmt) then
      WeedAmt:Remove()
      WeedAmt = nil
    end
  end

end)

hook.Add("HUDPaint", "Drug_MethHudPaintUntilNewInv", function()
  if LocalPlayer():GetNWInt("PC_Drugs_Meth", 0) > 0 then
    draw.RoundedBox(8,ScrW() - VoidUI.Scale(100),VoidUI.Scale(320),VoidUI.Scale(100),VoidUI.Scale(100),Color(20,20,20))
    MethIcon = MethIcon or vgui.Create("SpawnIcon") 
    if MethIcon then
      MethIcon:SetPos( ScrW() - VoidUI.Scale(100),VoidUI.Scale(320) )
      MethIcon:SetSize(VoidUI.Scale(100),VoidUI.Scale(100))
      MethIcon:SetModel( "models/zerochain/props_methlab/zmlab2_bag.mdl" )
    end
    MethTitle = MethTitle or vgui.Create( "DLabel")
    if MethTitle then  
      MethTitle:SetPos( ScrW() - VoidUI.Scale(75),VoidUI.Scale(320) )
      MethTitle:SetText( "Meth:" )
      MethTitle:SetFont("GlobalFont_25")
      MethTitle:SetColor(Color(255,255,255))
    end
    MethAmt = MethAmt or vgui.Create( "DLabel")  
    if MethAmt then
      MethAmt:SetPos( ScrW() - VoidUI.Scale(62.5),VoidUI.Scale(395) )
      MethAmt:SetText( LocalPlayer():GetNWInt("PC_Drugs_Meth", 0) )
      MethAmt:SetFont("GlobalFont_25")
      MethAmt:SetColor(Color(255,255,255))
    end
  else
    if IsValid(MethIcon) then
      MethIcon:Remove()
      MethIcon = nil
    end
    if IsValid(MethTitle) then
      MethTitle:Remove()
      MethTitle = nil
    end
    if IsValid(MethAmt) then
      MethAmt:Remove()
      MethAmt = nil
    end
  end

end)