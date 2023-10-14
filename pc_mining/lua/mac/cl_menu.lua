local PANEL = PANEL or {}
PCMACConfig = PCMACConfig or {}
PCMAC = PCMAC or {}
PCMAC.PlyMaterials = PCMAC.PlyMaterials or {}

hook.Add( "PostDrawTranslucentRenderables", "MinerProtectionBox", function()
	if LocalPlayer():Team() == TEAM_MINER then
		render.SetColorMaterial() 
		render.DrawBox( Vector(0,0,0), Angle(0,0,0), PCMACConfig.MinerBoxMax, PCMACConfig.MinerBoxMin, Color(55,255,55) ) 
	end
end)

hook.Add("HUDPaint", "MinerProtectionBoxHud", function()
	if LocalPlayer():Team() == TEAM_MINER then
		if LocalPlayer():GetPos():WithinAABox(PCMACConfig.MinerBoxMax, PCMACConfig.MinerBoxMin) then
			draw.SimpleText("Miner Protection Active", "GlobalFont_50", ScrW() / 1.25, VoidUI.Scale(100), Color(55,255,55), 1,1 )
		end
	end
end)

net.Receive( "PCMAC_SendOre", function()
	local ore = net.ReadString()
	local amt = net.ReadFloat()
	PCMAC.PlyMaterials[ore] = amt
end)

HUD = HUD or {}
local PANEL = PANEL or {}
function HUD:Scale(num)
	return VoidUI.Scale(num)
end

for i = 1, 200 do
    surface.CreateFont( "HUD:Font"..i, {     font = "Montserrat",     extended = false,     size = i,     weight = 500 } )
end

local path = 'hud'

file.CreateDir(path)
local exists = file.Exists
local write = file.Write
local fetch = http.Fetch
local surface = surface
local crc = util.CRC
local _error = Material("error")
local math = math
local mats = {}
local color_white = Color(255, 255, 255)
local color_text = Color(255, 255, 255)

function HUD:DownloadImage(url, name, flags)
	if not url then return _error end
	if mats[url] then return mats[url] end
	local crc = crc(url)
	if name then
		crc = name
	end

	if exists(path ..'/' .. crc .. ".png", "DATA") then
		mats[url] = Material("data/" .. path .. "/" .. crc .. ".png", flags or "mips smooth")

		return mats[url]
	end

	mats[url] = _error

	fetch(url, function(data)
		write(path ..'/' .. crc .. ".png", data)
		mats[url] = Material("data/" .. path .. "/" .. crc .. ".png", flags or "mips smooth")
	end)

	return mats[url]
end

function HUD:WebImage(url, x, y, width, height, color, angle, cornerorigin, flags)
	HUD:DownloadImage(url)
	color = color or color_white
	surface.SetDrawColor(color.r, color.g, color.b, color.a)
	surface.SetMaterial(self:DownloadImage(url, nil, flags))

	if not angle then
		surface.DrawTexturedRect(x, y, width, height)
	else
		if not cornerorigin then
			surface.DrawTexturedRectRotated(x, y, width, height, angle)
		else
			surface.DrawTexturedRectRotated(x + width / 2, y + height / 2, width, height, angle)
		end
	end
end

function PANEL:Init()
	self:Dock(FILL)
    self.panel = vgui.Create("DPanel", self)
    	self.panel:Dock(FILL)	
		self.panel.Start = SysTime()
    	self.panel.Paint = function(self, w, h)
        	draw.RoundedBox(10, 0, 0, w, h, Color(25, 25, 25))
    	end
		self:Create()
end


function PANEL:Create()
	local lerpLevel = 0
    Navbar = vgui.Create("XeninUI.Navbar", self.panel)
    Navbar:Dock(TOP)
	Navbar:SetBody(self.panel)
    Navbar:SetTall(56)
	Navbar:AddTab("Ores", "PCMAC_Materials")
	Navbar:AddTab("Crafting", "PCMAC_CraftingPanel")
	Navbar:SetActive("Ores", true)

    	local Panel = vgui.Create("DModelPanel", self.panel)
	Panel:Dock(LEFT)
	Panel:SetWide(VoidUI.Scale(300))
	Panel:SetModel(LocalPlayer():GetModel())
   	Panel.LayoutEntity = function() end
    	Panel:SetCamPos(Vector(50, -20, 45))
    	Panel:SetLookAt(Vector(0, 0, 30))
    	Panel:GetEntity():SetSequence("idle_melee2")
    	Panel:SetFOV(50)

    	Panel.PostDrawModel = function(s, ent)
        	Pickaxe:DrawModel()
    	end

    	Pickaxe = ClientsideModel("models/weapons/yurie_rustalpha/c-vm-pickaxe.mdl")
   	Pickaxe:SetParent(Panel:GetEntity())
   	Pickaxe:AddEffects(EF_BONEMERGE)
    	Pickaxe:SetNoDraw(true)

	






    	levelBar = vgui.Create("DPanel", Navbar)
    	levelBar:Dock(RIGHT)
    	levelBar:DockMargin(10, 10, 10, 10)
    	levelBar:SetWide(500)
    	levelBar.Paint = function(self, w, h)
		lerpLevel = Lerp(2 * RealFrameTime() , lerpLevel, LocalPlayer():PC_Leveling_GetXP(4)  )
		lvlW =  math.Clamp((lerpLevel/LocalPlayer():PC_Leveling_GetNeededXP(4)) * (w/1.25),0, w/1.25) 
        draw.RoundedBox(0, 0, 0, w, h, Color(25, 25, 25))
		draw.RoundedBox(5, w/10, h/3, w/1.25, h/2.5, Color(35, 35, 35))
		draw.RoundedBox(5, w/10, h/3, lvlW, h/2.5, Color(55, 155,255))
		draw.SimpleText( LocalPlayer():PC_Leveling_GetLevel(4),  "HUD:Font25", 30, h/2, Color( 255, 255, 255 ),1,1 )
		draw.SimpleText( "["..math.Round(lerpLevel) .."/"..LocalPlayer():PC_Leveling_GetNeededXP(4).."]" , "HUD:Font25", w/2 + 1, h/2 + 1,   Color( 0,0,0 ),1,1)
		draw.SimpleText( "["..math.Round(lerpLevel) .."/"..LocalPlayer():PC_Leveling_GetNeededXP(4).."]" , "HUD:Font25", w/2, h/2,   Color( 255, 255, 255 ),1,1)
		draw.SimpleText( LocalPlayer():PC_Leveling_GetLevel(4) + 1, "HUD:Font25", w - 30, h/2,   Color( 255, 255, 255 ),1,1 )
		
    	end
end
	

vgui.Register("PCMAC_MainPanel", PANEL)










