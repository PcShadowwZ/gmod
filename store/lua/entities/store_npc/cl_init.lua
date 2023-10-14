include("shared.lua")
PC_Ranks = PC_Ranks or {}

CredStore = CredStore or {}
CredStore.Config = CredStore.Config or {}

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
    draw.SimpleText("Store","GlobalFont_150", 0,0,color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
  cam.End3D2D()
end

local function CreateRanksPanel(parent,sidebar)
  local BackGround = vgui.Create("DPanel", parent)
  local function DoRankPanel()
    local panelList = vgui.Create("DPanelList", BackGround)
    panelList:Dock(FILL)
    panelList:SetPadding(10)
    panelList:SetSpacing(10)
    panelList:EnableVerticalScrollbar(true)
    panelList:EnableHorizontal(true)
    panelList:SetText("")
    panelList.curFrames = {}
    panelList.Paint = function(s,w,h)
      draw.RoundedBox(0, 0, 0, w, h, Color(55,55,55))
    end
    for k, v in SortedPairs(PC_Ranks.Config) do
      if k == 1 then continue end
      local rankPanel = vgui.Create("DPanel", panelList)
      rankPanel:SetSize(VoidUI.Scale(470), VoidUI.Scale(390))
      rankPanel.Paint = function(s,w,h)
        draw.RoundedBox(8, 0, 0, w, h, Color(25,25,25))
        draw.SimpleText(v.Name, "GlobalFont_30", w/2, VoidUI.Scale(20), v.Color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
      end

        local discount = 0
        if LocalPlayer():PC_GetRank() > 1 then
          discount = PC_Ranks.Config[LocalPlayer():PC_GetRank()].Price 
        end


      local buyBut = vgui.Create("XeninUI.ButtonV2", rankPanel)
      buyBut:SetText( "Purchase - ".. tostring(v.Price - discount).." Credits")
      buyBut:Dock(BOTTOM)
      buyBut:DockMargin(45,5,45,5)
      buyBut:SetYOffset(-2)
      buyBut:SetSolidColor(Color(0, 155, 0))
      buyBut:SetStartColor(Color(0, 155, 0))
      buyBut:SetEndColor(Color(0, 115, 0))
      buyBut.DoClick = function()
        Derma_Query(
          "Do you wish to purchase this rank for: ".. tostring(v.Price).." Credits",
          "Confirmation:",
          "Yes",
          function()  v.ClickFunc() parent:GetParent():Remove() RunConsoleCommand("_storemenu") end,
        "No",
        function() end)
      end
      panelList:AddItem(rankPanel)

      if k <= LocalPlayer():PC_GetRank() then
        buyBut:SetText("Owned")
        buyBut.DoClick = function() end
        buyBut:SetSolidColor(Color(155, 0, 0))
        buyBut:SetStartColor(Color(155, 0, 0))
        buyBut:SetEndColor(Color(115, 0, 0))
      end

      local infoPanel = vgui.Create("DPanel", rankPanel)
      infoPanel:Dock(BOTTOM)
      infoPanel:SetTall(VoidUI.Scale(305))
      infoPanel:DockMargin(5,5,5,5)
      infoPanel.Paint = function(s,w,h)
        draw.RoundedBox(8, 0, 0, w, h, Color(15,15,15))
      end
      for i, desc in pairs(v.Contents) do
        local label = vgui.Create("DLabel", infoPanel)
        label:DockMargin(5,5,5,5)
        label:Dock(TOP)
        label:SetText(desc)
        label:SetFont("GlobalFont_22")
        label:SetTextColor(color_white)
        --label:SetWrap(true)
      end
    end
  end
  DoRankPanel()
  sidebar:CreatePanel("Ranks", "Buy donator ranks with credits for bonuses!", BackGround, "C3MyKJE")
end


local function CreateMiscPanel(parent,sidebar)
  local NBackGround = vgui.Create("DPanel", parent)
  local NpanelList = vgui.Create("DPanelList", NBackGround)
  NpanelList:Dock(FILL)
  NpanelList:SetPadding(10)
  NpanelList:SetSpacing(10)
  NpanelList:EnableVerticalScrollbar(true)
  NpanelList:EnableHorizontal(true)
  NpanelList:SetText("")
  NpanelList.curFrames = {}
  NpanelList.Paint = function(s,w,h)
    draw.RoundedBox(0, 0, 0, w, h, Color(55,55,55))
  end
  for k, v in SortedPairs(CredStore.Config.Misc) do
    local NrankPanel = vgui.Create("DPanel", NpanelList)
    NrankPanel:SetSize(VoidUI.Scale(470), VoidUI.Scale(390))
    NrankPanel.Paint = function(s,w,h)
      draw.RoundedBox(8, 0, 0, w, h, Color(25,25,25))
      draw.SimpleText(v.Name, "GlobalFont_30", w/2, VoidUI.Scale(20), v.Color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    local NbuyBut = vgui.Create("XeninUI.ButtonV2", NrankPanel)
    NbuyBut:SetText( "Purchase - ".. tostring(v.Price).." Credits")
    NbuyBut:Dock(BOTTOM)
    NbuyBut:DockMargin(45,5,45,5)
    NbuyBut:SetYOffset(-2)
    NbuyBut:SetSolidColor(Color(0, 155, 0))
    NbuyBut:SetStartColor(Color(0, 155, 0))
    NbuyBut:SetEndColor(Color(0, 115, 0))
    NbuyBut.DoClick = function()
      Derma_Query(
        "Do you wish to purchase this package for: ".. tostring(v.Price).." Credits",
        "Confirmation:",
        "Yes",
        function()  v.ClickFunc() parent:GetParent():Remove() RunConsoleCommand("_storemenu") end,
      "No",
      function() end)
    end
    NpanelList:AddItem(NrankPanel)

    local NinfoPanel = vgui.Create("DPanel", NrankPanel)
    NinfoPanel:Dock(BOTTOM)
    NinfoPanel:SetTall(VoidUI.Scale(305))
    NinfoPanel:DockMargin(5,5,5,5)
    NinfoPanel.Paint = function(s,w,h)
      draw.RoundedBox(8, 0, 0, w, h, Color(15,15,15))
    end
    for i, desc in pairs(v.Contents) do
      local Nlabel = vgui.Create("DLabel", NinfoPanel)
      Nlabel:DockMargin(5,5,5,5)
      Nlabel:Dock(TOP)
      Nlabel:SetText(desc)
      Nlabel:SetFont("GlobalFont_22")
      Nlabel:SetTextColor(color_white)
      --label:SetWrap(true)
    end
  end
  sidebar:CreatePanel("Misc", "Misc things to buy with credits!", NBackGround, "C3MyKJE")
end


concommand.Add("_storemenu", function()
  if IsValid(query) then
      query:Remove()
  end
  local query = vgui.Create("XeninUI.Frame")
  query:SetSize(0, 0)
  query:Center()
  query:MakePopup()
  query:SetTitle("Credit Store - [" .. LocalPlayer():GetNWInt("Credits",0) .. " Credits] [".. PC_Gobbles.Points .." Points]")
  query:MoveTo(VoidUI.Scale(60),VoidUI.Scale(115), .75, 0, -1, function() end)
  query:SizeTo(VoidUI.Scale(1800), VoidUI.Scale(850), .75, 0, -1, function()
    local panel = vgui.Create("DPanel", query)
    panel:Dock(FILL)

    local Sidebar = vgui.Create("XeninUI.SidebarV2", query)
    Sidebar:SetBody(panel)
    Sidebar:Dock(LEFT)
    Sidebar:SetWide(VoidUI.Scale(350))

    CreateRanksPanel(panel,Sidebar)
    CreateMiscPanel(panel,Sidebar)
    --[[for k, v in pairs(PC_Ranks.Config) do
      panelList.Paint = function(s,w,h)
        draw.RoundedBox( 5, 0, 0, w/3, h, Color(255,255,255) )
      end
    end]]
    Sidebar:SetActiveByName("Ranks")
    query:Center()
    query:MakePopup()
  end)

end)