Inventory = Inventory or {}
Inventory.AllItems = Inventory.AllItems or {}
Inventory.Inventory = Inventory.Inventory or {}

PIXEL = PIXEL or {}
local material = Material("vgui/gradient-l", "smooth")
surface.CreateFont("TTName", {
	font = "Open Sans Bold",
	extended = true,
	size = 37,
	weight = 1000,
	antialias = true,
})

surface.CreateFont("TTBig", {
	font = "Open Sans Bold",
	extended = true,
	size = 75,
	weight = 1000,
	antialias = true,
})

surface.CreateFont("TTRarity", {
	font = "Open Sans Bold",
	extended = true,
	size = 18,
	weight = 1000,
	antialias = true,
})

surface.CreateFont("TTSmall", {
	font = "Open Sans Bold",
	extended = true,
	size = 14,
	weight = 1000,
	antialias = true,
})

surface.CreateFont("TTInfo", {
	font = "Open Sans Bold",
	extended = true,
	size = 25,
	weight = 1000,
	antialias = true,
})

local panelMeta = FindMetaTable( "Panel" )
function panelMeta:SetItemToolTip( posX, posY, sizeW, sizeH, text, bg )
	self.OnCursorEntered = function()
		if ( bg.Menu or IsValid( bg.Menu ) ) then 
			if( IsValid( INV_TOOLTIP ) ) then
				INV_TOOLTIP:Remove()
			end			
		end
		if( IsValid( INV_TOOLTIP ) ) then
			INV_TOOLTIP:Remove()
		end

		local textTable = text
		if( not istable( text ) ) then
			textTable = { text }
		end

		INV_TOOLTIP = vgui.Create( "DPanel" )
		INV_TOOLTIP:MakePopup()
		INV_TOOLTIP:DockPadding( 10, 5, 0, 0 )
		INV_TOOLTIP.Paint = function( self2, w, h )
			draw.RoundedBox( 5, 0, 0, w, h, Color(25,25,25) )
		end

		local textX, textY = 0, 0
		for k, v in pairs( textTable ) do
			local textString = v
			local textColor = color_white
			local textFont = "F4.DashInfoTitles"
			if( istable( v ) ) then
				textString = v[1] or "Error"
				textColor = v[2] or color_white
				textFont = v[3] or "TTInfo"
			end

			surface.SetFont( textFont )
			
			local newTextX, newTextY = surface.GetTextSize( textString )
			if( newTextX > textX ) then
				textX = newTextX
			end
			textY = textY+newTextY

			local textPanel = vgui.Create( "DLabel", INV_TOOLTIP )
			textPanel:SetText( textString )
			textPanel:SetFont( textFont )
			textPanel:Dock( TOP )
			textPanel:SetTall( newTextY )

			if( isfunction( textColor ) ) then
				textPanel.Think = function()
					textPanel:SetTextColor( textColor() )
				end
			else
				textPanel:SetTextColor( textColor )
			end
		end

		INV_TOOLTIP:SetSize( textX+20, textY+10 )
		INV_TOOLTIP:SetPos( posX+sizeW+5, posY+(sizeH/2)-(INV_TOOLTIP:GetTall()/2) )
		INV_TOOLTIP:SetAlpha( 0 )
		INV_TOOLTIP:AlphaTo( 255, 0.1 )
		INV_TOOLTIP.Think = function()
			if( IsValid( INV_TOOLTIP ) and not self:IsHovered() ) then
				INV_TOOLTIP:Remove()
			end
		end
	end
	self.OnCursorExited = function()
		if( IsValid( INV_TOOLTIP ) ) then
			INV_TOOLTIP:Remove()
		end
	end

	self.OnRemove = function()
		if( IsValid( INV_TOOLTIP ) ) then
			INV_TOOLTIP:Remove()
		end
	end
end

function ShowCaseUnboxing(self,ply,id,name,color,result,sound)
	local col = color
	local items = {}
	local case = Inventory.Cases[name]
	for k,v in pairs(case.Items) do
		items[k] = Inventory.CaseItems[k]
	end
	if Background or IsValid(Background) then	
		Background:Remove()
	end
  	Background = vgui.Create("DPanel", self)
	Background:Dock(FILL)
  	Background:SetSize(self:GetWide(),320)
	Background.finished = false
  	Background.Paint = function(pnl, w, h)
		PIXEL.DrawRoundedBox(0, 0, 0, w, h, col)
		draw.SimpleText(name,"TTBig",w*.5 + 2,h*.125 + 2,Color(0,0,0),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER )
		draw.SimpleText(name,"TTBig",w*.5,h*.125,Color(col.r + 75,col.g + 75,col.b + 75),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER )
  	end
	Background.OnRemove = function()
		chat.AddText( Color(200,200,0), "[UNBOX] ", color_white, "You Opened: ",Inventory.Rarities[Inventory.CaseItems[result].Rarity or 1].Color, Inventory.CaseItems[result].Name )
	end

	local BGsList = vgui.Create("DPanel", Background)
	BGsList:SetPos(0,Background:GetTall()/2)
	BGsList:SetSize( Background:GetWide() , 215 )
	BGsList.Paint = function(s,w,h)
 		surface.SetDrawColor(Color(col.r,col.g,col.b))
 		surface.DrawRect(0, 0, w, h)
	end
	BGsList.PaintOver = function(s,w,h)
		local triangle = {
			{ x = (s:GetWide() / 2) - 8, y = 0 },
			{ x = (s:GetWide() / 2) + 8 , y = 0 },
			{ x = (s:GetWide() / 2), y = 30 }
		}		
 		surface.SetDrawColor(Color(col.r,col.g,col.b))
		draw.NoTexture()
		surface.DrawPoly( triangle )
	end
	BGsList:SetZPos(1)
	local BW,BH = 200,200

	local function StartCaseOpen(endat)
		if not IsValid(BGsList) then return end
		local speed = 7.5
		local moveamount = endat - (BGsList:GetWide() / 2) + math.random(0,BW - 5)
		local movedamount = 0
		local pixelsmoved = 0
		BGsList.Think = function()
			if (moveamount - movedamount) <= 2000 then //1000
				speed = math.Approach(speed,0.1,FrameTime() * 1.417) //1.27
			end
			for k,v in pairs(BGsList:GetChildren()) do
				if not v.NewX then v.NewX = v:GetPos() end
				v.NewX = math.Approach(v.NewX,-BW,FrameTime() * 100 * speed)
				if v.NewX <= -BW then v:Remove() continue end
				v:SetPos(v.NewX,5)
			end

			pixelsmoved = math.Approach(pixelsmoved,50,FrameTime() * 100 * speed)
			if pixelsmoved >= 50 then
				pixelsmoved = 0
				surface.PlaySound("darkrp/tick.wav")
			end
			movedamount = math.Approach(movedamount,moveamount,FrameTime() * 100 * speed)
			if movedamount >= moveamount then BGsList.Think = nil 
			timer.Simple(0.4, function()
				if !IsValid(Background) then return end
				if IsValid(Background) then Background:Remove() end
				Background.finished = true
			end)	
			end
		end
	end

	local num = 0
	local endat = 0
	for i=1,10,1 do
		for k,v in RandomPairs(items) do  				
			local BG = vgui.Create("DPanel", BGsList)
			BG:SetSize(BW,BH)
			BG:SetPos(5 + (num * 203),5)
			BG.Paint = function(pnl,w,h) 
        			surface.SetDrawColor(Inventory.Rarities[Inventory.CaseItems[k].Rarity or 1].Color)
        			surface.SetMaterial(material)
				surface.DrawTexturedRectRotated(0, h-35 , w * 4, h * 3, -50)
				PIXEL.DrawRoundedBox(0, 2 , h-35 , w - 4  , 2 , Color(0,0,0,200))
				PIXEL.DrawRoundedBox(0, 2 , h-2 , w - 4  , 2 , Color(0,0,0,200))
				PIXEL.DrawRoundedBox(0, 2 , 5 , w - 4  , 30 , Color(0,0,0,200))
				PIXEL.DrawRoundedBox(0, 0 , 5 , 2  , h, Color(0,0,0,200))
				PIXEL.DrawRoundedBox(0, w - 2 , 5 , 2  , h, Color(0,0,0,200))

				draw.SimpleText( Inventory.Rarities[Inventory.CaseItems[k].Rarity or 1].Name, "TTInfo", BG:GetWide() / 2 + 2,19, Color(0,0,0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				draw.SimpleText( Inventory.Rarities[Inventory.CaseItems[k].Rarity or 1].Name, "TTInfo", BG:GetWide() / 2 ,18, Inventory.Rarities[Inventory.CaseItems[k].Rarity or 1].Color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	
				
				local tw,th = surface.GetTextSize(v.Name)
				surface.SetFont( "TTInfo" )
				surface.SetTextColor( Color(0,0,0) )
				surface.SetTextPos( BG:GetWide() / 2 - (tw / 2) + 2,171 ) 
				surface.DrawText( v.Name )
				surface.SetFont( "TTInfo" )
				surface.SetTextColor( Inventory.Rarities[Inventory.CaseItems[k].Rarity or 1].Color )
				surface.SetTextPos( BG:GetWide() / 2 - (tw / 2),170 ) 
				surface.DrawText( v.Name )	
			end
			local icon
			if !v.Icon:EndsWith(".mdl") then
				icon = vgui.Create("DPanel", BG)
				icon:SetSize( BW-8,BH-8 )
				icon:SetPos(4,4)
				icon.Paint = function()	
					PIXEL.DrawImgur(64,64,BW-128,BW-128, v.Icon, v.Color)
				end
			else
				icon = vgui.Create( "DModelPanel", BG )
				icon:SetModel(v.Icon)
				icon:SetSize( BW-8,BH-8 )
				icon:SetPos(4,4)
				function icon:LayoutEntity(Ent)
					Ent:SetAngles( Angle( 0, 0,  0) )
				end
				local BMin, BMax = icon.Entity:GetRenderBounds()    
				icon:SetColor(v.Color)
				icon:SetCamPos((BMin:Distance(BMax)*Vector(0.75, 0.75, 0.5)))    
				icon:SetLookAt((BMax + BMin)/2)
				icon:SetFOV(50)
			end
			if i == 7 and (k == result) then endat = 5 + (num * 203) end
			num = (num + 1)
		end
	end

	timer.Simple(0, function()
		surface.PlaySound(sound)
		StartCaseOpen(endat)
	end)
end
Inventory.Rarities = Inventory.Rarities or {}
function CreateIcon(panel,model,sizex,sizey,ent,clr) 
	if !panel then return end
	local BG = vgui.Create("DPanel")
	local changeAlpha = 0
	local iconbutton
	local x, y, w, h = 0, 0, sizex, sizey
	if panel then BG:SetParent(panel) end
	local Pressed = false
	local Hovered = false
	local rarity = Inventory.Rarities[Inventory.AllItems[ent].rarity]
	local Type = Inventory.AllItems[ent].type
	local tooltipInfo = {}
	tooltipInfo[1] = {  (Inventory.AllItems[ent].name), rarity.Color, "TTName" }
	tooltipInfo[3] = { "Rarity: ".. rarity.Name, rarity.Color, "TTInfo"}
	tooltipInfo[2] = { "Type: ".. Type, rarity.Color, "TTInfo" }

	if Type == "SWEP" then
		local wep = weapons.Get(ent)

		local dmg = wep.Primary.Damage
		if dmg then
			tooltipInfo[4] = { "Damage: " .. math.floor(dmg), color_white, "TTInfo" }
		end

		local magSize = wep.Primary.ClipSize
		if magSize then
		  tooltipInfo[5] = { "Max Clip: "..  math.floor(magSize), color_white, "TTInfo" }
		end
	  
		local rpm =  wep.Primary.Delay
		if rpm then
		  tooltipInfo[6] = { "RPM: " .. math.floor(60 / rpm), color_white, "TTInfo" }
		end
	  
		local rpm = wep.Primary.RPM
		if rpm then
		  tooltipInfo[7] = { "RPM: " .. math.floor(rpm), color_white, "TTInfo" }
		end
	  
	  
		local shots = wep.Primary.NumShots or wep.Primary.NumberofShots or 1
		if shots then
		  tooltipInfo[8] = { "Number Of Shots: " .. shots, color_white, "TTInfo" }
		end
	end

	if Type == "Suit" then
		tooltipInfo[4] = { "Health: " .. Inventory.Suits[ent].Health, color_white, "TTInfo" }
		tooltipInfo[5] = { "Armor: "..  Inventory.Suits[ent].Armor, color_white, "TTInfo" }
		tooltipInfo[6] = { "Speed: " .. Inventory.Suits[ent].Speed, color_white, "TTInfo" }
		tooltipInfo[7] = { "Jump: " .. Inventory.Suits[ent].Jump, color_white, "TTInfo" }
	end


	if Type == "Cases" then
		local num = 0
		tooltipInfo[4] = { "Items: ", color_white, "TTInfo" }
		for k, v in pairs(Inventory.Cases[ent].Items) do
			tooltipInfo[5 + num] = { Inventory.CaseItems[k].Name, Inventory.Rarities[Inventory.CaseItems[k].Rarity].Color, "TTRarity" } -- ITEM TYPE
			num = num + 1
		end
	end


	if Type == "Booster Pack" then
		local num = 0
		tooltipInfo[4] = { "Items: ", color_white, "TTInfo" }
		for k, v in pairs(Inventory.BoosterCases) do
			tooltipInfo[5 + num] = {Inventory.AllItems[k].name, Inventory.Rarities[Inventory.AllItems[k].rarity].Color, "TTRarity" } 
			num = num + 1
		end
	end	
	
	BG:SetSize( sizex, sizey )
	BG.Paint = function(s, w, h)
		draw.RoundedBox(0,0,0,w,h,Color(20,20,20))
        	surface.SetDrawColor(rarity.Color or color_white)
        	surface.SetMaterial(material)
        	surface.DrawTexturedRectRotated(5, 5, w * 3.5, h * 2.5, -50)
		PIXEL.DrawText("x"..Inventory.Inventory[ent], "F4.DashInfoTitles", PIXEL.Scale(15), h-PIXEL.Scale(20), rarity.Color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		if !model:EndsWith(".mdl") then
			PIXEL.DrawImgur(w/12,h/5,sizex-8,sizex-8, model,clr)
		end
		draw.RoundedBox(0,0,4,w,PIXEL.Scale(20),Color(22,22,22,230))
		PIXEL.DrawText(Inventory.AllItems[ent].name, "TTSmall", w/2, PIXEL.Scale(6), rarity.Color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end



	if model:EndsWith(".mdl") then
		local icon = vgui.Create( "DModelPanel", BG )
		icon:SetModel(model)
		icon:SetSize( sizex-8,sizey-8 )
		icon:SetPos(4,4)
		function icon:LayoutEntity(Ent)
			Ent:SetAngles( Angle( 0, 0,  0) )
		end
		local BMin, BMax = icon.Entity:GetRenderBounds()    
		icon:SetColor(clr)
		icon:SetCamPos((BMin:Distance(BMax)*Vector(0.75, 0.75, 0.5)))    
		icon:SetLookAt((BMax + BMin)/2)
		icon:SetFOV(50)
	end

	local iconbutton = vgui.Create( "DButton", BG )
	iconbutton:Dock(FILL)
	iconbutton:SetDrawBackground(false)
	iconbutton:SetText("")
	iconbutton.DoRightClick = function()
		BG.Menu = vgui.Create( "PIXEL.Menu" )
		BG.Menu:Open()
		for name, funcs in pairs( Inventory.AllItems[ent].funcs ) do
			if ent != "Booster Pack" then
			local tempname 
			if name == "Add_Perm" then
				tempname  = "Add Perm"
			else
				tempname = name
			end
			BG.Menu:AddOption( tempname, function() 
				RunConsoleCommand( "inventory_"..name, ent )
				panel:Update() 
			end)
			end
		end
		if ent == "Booster Pack" then 
			local Booster = BG.Menu:AddSubMenu("Claim", function() end)
			for k, v in pairs(Inventory.BoosterCases) do
				Booster:AddOption(Inventory.Cases[k].Name, function() RunConsoleCommand( "inventory_Use", ent, k) panel:Update() end)
			end
		end
		local GiftNames = BG.Menu:AddSubMenu("Gift", function() end)
		for k, v in pairs(player.GetAll()) do
			if v:SteamID64() != LocalPlayer():SteamID64() then 
				GiftNames:AddOption(v:Nick(), function() RunConsoleCommand( "inventory_Gift", ent, v:SteamID64()) panel:Update() end)
			end
		end
		if Inventory.AllItems[ent].canScrap then
			BG.Menu:AddOption( "Scrap ["..Inventory.AllItems[ent].scrapAmt.."]", function()	
				RunConsoleCommand( "inventory_Scrap", ent )
			end)			
		end
		BG.Menu:AddOption( "Delete", function()
			local query = vgui.Create("PIXEL.Query")
			query:SetTitle("Delete")
			query:SetText("Delete 1 of this item?")
			query:AddOption("Yes", function() RunConsoleCommand( "inventory_Delete", ent) panel:Update() end)
			query:AddOption("No", function() end)
			query:Center()
			query:MakePopup()
			
		end)
		BG.Menu:AddOption( "Delete All", function() 
			local query = vgui.Create("PIXEL.Query")
			query:SetTitle("Delete All")
			query:SetText("Delete all of this item?")
			query:AddOption("Yes", function() RunConsoleCommand( "inventory_DeleteAll", ent )  panel:Update() end)
			query:AddOption("No", function() end)
			query:Center()
			query:MakePopup()
		end)
	end

	iconbutton.Paint = function(s,w,h)
            	local toScreenX, toScreenY = BG:LocalToScreen( 0, 0 )
            	if( x != toScreenX or y != toScreenY ) then
                	x, y = toScreenX, toScreenY
                	s:SetItemToolTip( x, y, w, h, tooltipInfo, BG, k )
            	end
	end
	BG.OnCursorExited = function()
		if( IsValid( self.Menu ) ) then
			self.Menu:Remove()
		end
	end
	return BG
end

local PANEL = {}
function PANEL:Init()
	local h = self:GetTall()
	Inv = vgui.Create( "DPanel", self )
	Inv:Dock( FILL )
	Inv:DockMargin( 9, 9, 9, 9 )
	Inv:SetTall( h*5 )
	Inv.Paint = function( s, w, h )
	end
	if !Inventory.Inventory then
		Inventory.Inventory = {}
	end
	local Inve = Inve or {}
	local w = w
	local l = h
	local CurIcons = CurIcons or {}
	local SearchBox = vgui.Create( "PIXEL.F4.SearchBar", self ) 
	SearchBox:Dock(TOP)
	SearchBox:SetTall(45)
	local Slots = vgui.Create( "DLabel", SearchBox )
	Slots:SetFontInternal("TTInfo")
	Slots:SetColor(Color(255,255,255))
    local weight = 0
	for k, v in pairs(Inventory.Inventory) do
		local itemweight = (Inventory.AllItems[k].weight * v) or 0
		weight = weight + (itemweight)
	end
    Slots:SetText( weight.."/"..Inventory.InvSlots.." Weight" )
    Slots:SizeToContents()
	Slots:SetPos( PIXEL.Scale(self:GetWide() * 11 ), PIXEL.Scale(SearchBox:GetTall() / 6 ))

	Inve.ItemList = vgui.Create("DPanelList", Inv)
	Inve.ItemList:Dock(FILL)
	Inve.ItemList:SetPadding(8)
	Inve.ItemList:SetSpacing(8)
	Inve.ItemList:EnableVerticalScrollbar(true)
	Inve.ItemList:EnableHorizontal(true)
	Inve.ItemList.Paint = function(s,w,h)
		if table.IsEmpty( Inventory.Inventory ) then	
			PIXEL.DrawText("Your Inventory Is Empty", "F4.DashboardNothingToSeeHere", w/2, h/10, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)	
		end
	end

	SearchBox.Entry:SetUpdateOnType(true)
	SearchBox.Entry.OnValueChange = function(s,value)
		value = string.Trim(string.lower(value))
		if value == (s.LastSeachValue) then return end
		for k,v in pairs(CurIcons) do
			if string.find(string.lower(Inventory.AllItems[k].name),value,1,true) then
				v:SetVisible(true)
			elseif (value == "") then
				v:SetVisible(true)
			else
				v:SetVisible(false)
			end
		end
		Inve.ItemList:InvalidateLayout()
		s.LastSeachValue = value
	end

	function Inve.ItemList.Update() 
		local weight = 0
		for k, v in pairs(Inventory.Inventory) do
			local itemweight = Inventory.AllItems[k].weight * v
			weight = weight + (itemweight)
		end
		Slots:SetText( weight.."/"..Inventory.InvSlots.." Weight" )
		if table.IsEmpty( Inventory.Inventory ) then
			Inve.ItemList:Clear()
			CurIcons = {}
		end
		for k,v in pairs(Inventory.Inventory) do
			for i, j in pairs(CurIcons) do
				if !Inventory.Inventory[i] then
					Inve.ItemList:RemoveItem(j)
					CurIcons[i] = nil
				end
			end
			if CurIcons[k] then
				if v <= 0 then
					Inve.ItemList:RemoveItem(CurIcons[k])
					CurIcons[k] = nil
				end
			elseif !CurIcons[k] then
				local ItemIcon = CreateIcon(Inve.ItemList,Inventory.AllItems[k].mdl,120,130, k ,color_white)
				Inve.ItemList:AddItem(ItemIcon)
				CurIcons[k] = ItemIcon
			end
		end
	end

	net.Receive( "Inventory_ShowCaseOpening", function()
		local case = net.ReadString()
		local name = Inventory.Cases[case].Name
		local color = Inventory.Cases[case].Color
		local result = net.ReadUInt(16)
		local sound = Inventory.Cases[case].Sound
		ShowCaseUnboxing(self,LocalPlayer(),case,name,color,result,sound)
	end)	
	Inve.ItemList.Think = function()
		Inve.ItemList:Update()
	end
	return Inve.BackGround
end
vgui.Register("PIXEL.F4.InventoryPanel", PANEL, "Panel")

/*
local function InitClient()
	timer.Simple(5, function()
		Inventory.Inventory = {}
		//RunConsoleCommand("inventory_init")
	end)
end
hook.Add("InitPostEntity","LoadPlayerInventoryCL",InitClient)
*/

net.Receive("Inventory_SendItems", function(_, ply)
	local len = net.ReadUInt(16)
	local comp = net.ReadData(len)
	local json = util.Decompress(comp)
	Inventory.Inventory = util.JSONToTable(json)
end)

net.Receive("Inventory_SendItem", function(_, ply)
	local item = net.ReadString()
	local amt = net.ReadUInt(16)
	if amt == 0 then amt = nil end
	Inventory.Inventory[item] = amt
end)

net.Receive("Inventory_SendSlots", function(_, ply)
	Inventory.InvSlots = net.ReadUInt(16)
end)


/*
net.Receive( "Inventory_SendData", function( len, ply )
	local inv = net.ReadTable()
	local slots = net.ReadUInt(16)
	Inventory.Inventory = inv
	Inventory.InvSlots = slots
end)
*/


concommand.Add("refunds", function( ply, cmd, args )
	if !ply:IsSuperAdmin() then ply:ChatPrint("cant access this bozo") return end
	local chosen = 0
	local chosenPanel
    local MFrame = vgui.Create("PIXEL.Frame")
    MFrame:SetSize(PIXEL.Scale(600), PIXEL.Scale(500))
    MFrame:Center()
	MFrame:SetTitle("Refund Menu")
    MFrame:MakePopup()
	local Panel = vgui.Create("DPanelList", MFrame)
	Panel:Dock(TOP)
	Panel:SetTall(MFrame:GetTall()/1.62)
	Panel:EnableHorizontal(true)
	Panel:EnableVerticalScrollbar()
	Panel:SetPadding( PIXEL.Scale(10) )
	Panel:SetSpacing(PIXEL.Scale(10))
  	Panel.Paint = function(pnl, w, h)
		draw.RoundedBox( 5, 0, 0, w , h , Color( 50, 50, 50, 250 ) )
 	end
	for k, v in pairs(player.GetAll()) do
		local Option = vgui.Create("DPanel")
		Option:SetSize(MFrame:GetWide()/1.075 , 50)
  		Option.Paint = function(pnl, w, h)
 		end
		local Btn = vgui.Create("DButton", Option)
		Btn:Dock(FILL)
		Btn:SetDrawBackground(false)
		Btn:SetText("")
        	Btn.DoClick = function()
			chosen = v:SteamID64()
			print(chosen)
			chosenPanel = Option
        	end
  		Btn.Paint = function(pnl, w, h)
			if chosenPanel == Option then
				draw.RoundedBox( 5, 0, 0, w , h , Color( 100, 100, 100, 250 ) )
			else
				draw.RoundedBox( 5, 0, 0, w , h , Color( 70, 70, 70, 250 ) )
			end
			PIXEL.DrawSimpleText(v:Nick(), "TTName", w/2, h / 2, chosenPanel == Option and Color(55,255,55) or color_white , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
 		end
		Panel:AddItem( Option )
	end
	local ItemBox = vgui.Create( "PIXEL.F4.SearchBar", MFrame ) 
	ItemBox:Dock(TOP)
	ItemBox:SetTall(45)
	ItemBox.Entry:SetUpdateOnType(true)
	ItemBox.Entry.OnValueChange = function(s,value)
	end
	ItemBox.Entry:SetPlaceholderText("Item Class")
	local NumberBox = vgui.Create( "PIXEL.F4.SearchBar", MFrame ) 
	NumberBox:Dock(TOP)
	NumberBox:SetTall(45)
	NumberBox.Entry:SetUpdateOnType(true)
	NumberBox.Entry.OnValueChange = function(s,value)
	end
	NumberBox.Entry:SetPlaceholderText("Quantity")
	local Btn = vgui.Create("DButton", MFrame)
	Btn:Dock(FILL)
	Btn:SetDrawBackground(false)
	Btn:SetText("")
        Btn.DoClick = function()
		RunConsoleCommand( "inventory_Refund", chosen, ItemBox.Entry:GetValue(), NumberBox.Entry:GetInt()  )
        end
  	Btn.Paint = function(pnl, w, h)
		draw.RoundedBox( 5, 0, 0, w , h , pnl:IsHovered() and Color( 100, 100, 100, 250 ) or Color( 70, 70, 70, 250 ) )
		PIXEL.DrawSimpleText("Refund", "TTName", w/2, h / 2, pnl:IsHovered() and Color(55,255,55) or color_white , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
 	end
end)
