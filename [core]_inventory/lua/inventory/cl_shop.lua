Inventory = Inventory or {}
Inventory.AllItems = Inventory.AllItems or {}
Inventory.Shop = Inventory.Shop or {}
PIXEL = PIXEL or {}
local cats = {}
local ShopIcons = {}
local Background
local Navbar
local Searchbox
local RealBackground
local PANEL = {}
local material = Material("vgui/gradient-l", "smooth")
local function formatMoney(n)
    if not n then return "$0" end

    if n >= 1e14 then return "$"..(tostring(n)) end
    if n <= -1e14 then return "-" .. "$"..(tostring(math.abs(n))) end

    local negative = n < 0

    n = tostring(math.abs(n))
    local dp = string.find(n, "%.") or #n + 1

    for i = dp - 4, 1, -3 do
        n = n:sub(1, i) .. "," .. n:sub(i + 1)
    end

    if n[#n - 1] == "." then
        n = n .. "0"
    end

    return (negative and "-" or "") .. "$"..(n)
end

function CreateShopIcon(panel,item,sizex,sizey) 
	if !panel then return end
	local BG = vgui.Create("DPanel", panel)
	local iconbutton
	local x, y, w, h = 0, 0, sizex, sizey
	local model = Inventory.Shop[item].mdl
	local rarity = Inventory.Rarities[Inventory.AllItems[Inventory.Shop[item].ent].rarity]
	BG:SetSize( sizex * 6,sizey )
	BG.Paint = function(s, w, h)
		draw.RoundedBox(10,0,0,w,h,Color(20,20,20))
        surface.SetDrawColor(rarity.Color or color_white)
        surface.SetMaterial(material)
        surface.DrawTexturedRect(0,0,sizex,sizex)
		draw.RoundedBox(0,0,0,sizex,20,Color(20,20,20,150))
		PIXEL.DrawText(Inventory.Shop[item].name, "TTRarity",sizex/2 - 1,0, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.RoundedBox(0,0,h-20,sizex,20,Color(20,20,20,150))
		local cur = Inventory.Shop[item].cur
		if cur == "Cash" then
			PIXEL.DrawText(formatMoney(Inventory.Shop[item].price), "TTRarity",sizex/2 - 1,h-20, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		elseif cur == "Credits" then
			PIXEL.DrawText(Inventory.Shop[item].price.." Credits", "TTRarity",sizex/2 - 1,h-20, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		elseif cur == "Junk" then
			PIXEL.DrawText(Inventory.Shop[item].price.." Scrap", "TTRarity",sizex/2 - 1,h-20, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
		if !model:EndsWith(".mdl") then
			if item == "Booster Pack" then
				PIXEL.DrawImgur(20,25,sizex/1.5,sizex/1.5,model,color_white)
			elseif model == "R0avAob" then
				PIXEL.DrawImgur(9,10,sizex,sizex,model,color_white)
			else
				PIXEL.DrawImgur(0,2,sizex,sizex, model,color_white)
			end
		end
	end



	if model:EndsWith(".mdl") then
		local icon = vgui.Create( "DModelPanel", BG )
		icon:SetModel(model)
		icon:SetSize( sizex-8,sizex-8 )
		icon:SetPos(4,4)
		function icon:LayoutEntity(Ent)
			Ent:SetAngles( Angle( 0, 0,  0) )
		end
		local BMin, BMax = icon.Entity:GetRenderBounds()    
		icon:SetColor(color_white)
		icon:SetCamPos((BMin:Distance(BMax)*Vector(0.75, 0.75, 0.5)))    
		icon:SetLookAt((BMax + BMin)/2)
		icon:SetFOV(60)
	end

	local iconbutton = vgui.Create( "DButton", BG )
	iconbutton:Dock(RIGHT)
	iconbutton:SetWide(100)
	iconbutton:SetDrawBackground(false)
	iconbutton:SetText("")
	iconbutton.DoClick = function()
		local query = vgui.Create("PIXEL.StringRequest")
		query:SetTitle("Purchase "..Inventory.Shop[item].name)
		query:SetPlaceholderText(1)
		local cur = Inventory.Shop[item].cur
		if cur == "Cash" then
			query:SetText("Amount ("..formatMoney(Inventory.Shop[item].price).." per):")
		elseif cur == "Credits" then
			query:SetText("Amount ("..Inventory.Shop[item].price.." Credits per):")
		elseif cur == "Junk" then
			query:SetText("Amount ("..Inventory.Shop[item].price.." Scrap per):")
		end
		query:AddOption("Confirm", function() RunConsoleCommand( "inventory_Purchase", item, query.TextEntry:GetInt() )  end)
		query:Center()
		query:MakePopup()
	end
	iconbutton.Paint = function(s,w,h)
		draw.RoundedBoxEx(10,0,0,w,h,Color(25,25,25),false,true,false,true)
		PIXEL.DrawText("Buy", "TTName", w/2, h/3.25, iconbutton:IsHovered() and Color(55,255,55) or color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	local Info = vgui.Create( "DLabel", BG )
	Info:Dock(LEFT)
	Info:DockMargin( sizex + 15, 0, 0, 0 )
	Info:SetWide(360)
	Info:SetColor(Color(255,255,255))
	Info:SetText( Inventory.Shop[item].desc )
	Info:SetFontInternal("TTInfo")
	Info:SetWrap( true )
	panel:AddItem( BG )
	return BG
end

function PANEL:Init()
	RealBackground = vgui.Create("DPanel",self)
	RealBackground:Dock(FILL)
	RealBackground.Paint = function(s,w,h)
	end
	Background = vgui.Create("DPanelList", RealBackground)
	Background:Dock(FILL)
	Background:EnableHorizontal(true)
	Background:SetPadding( 10 )
	Background:SetSpacing(6)
	Background:Clear()

	Searchbox = vgui.Create( "PIXEL.F4.SearchBar", RealBackground) 
	Searchbox:Dock(TOP)
	Searchbox:SetTall(45)
	Searchbox.Entry:SetUpdateOnType(true)
	Searchbox.Entry.OnValueChange = function(s,value)
		value = string.Trim(string.lower(value))
		if value == (s.LastSeachValue) then return end
		for k,v in pairs(ShopIcons) do
			if string.find(string.lower(Inventory.Shop[k].name),value,1,true) and Inventory.Shop[k].cat == self.Category then
				v:SetVisible(true)
			elseif (value == "") and Inventory.Shop[k].cat == self.Category then
				v:SetVisible(true)
			else
				v:SetVisible(false)
			end
		end
		Background:InvalidateLayout()
		s.LastSeachValue = value
	end

	Navbar = vgui.Create("PIXEL.Navbar", RealBackground)
	Navbar:Dock(TOP)
	cats = {}
	for k, v in pairs(Inventory.Shop) do
		if !table.HasValue( cats, v.cat ) then
			table.insert( cats, v.cat )
			Navbar:AddItem(v.cat, v.cat, function() self:SelectCategory(v.cat) end)
		end
	end
	Navbar:AddItem("Perks", "Perks", function() RunConsoleCommand( "perkmenu_open" ) end)
	

	Navbar:SelectItem("Cases")	
	self:SelectCategory("Cases")
	Navbar.SelectionX = 0
    Navbar.SelectionW = 108
	Navbar:SetTall(50)

end

function PANEL:Populate(type)
	for k, v in pairs(Inventory.Shop) do
		if v.cat == type then
			local cat = CreateShopIcon(Background,k,120,120)
			ShopIcons[k] = cat
		end
	end	
end

function PANEL:SelectCategory(type)
    Background:Clear()
    ShopIcons = {}
    self.Category = type
    self:Populate(type)
    Background:InvalidateLayout()
end

vgui.Register("PIXEL.F4.ItemShopPanel", PANEL)