local PANEL = PANEL or {}
PCMAC = PCMAC or {}
PCMACConfig = PCMACConfig or {}
PCMACConfig.Categories = PCMACConfig.Categories or {}

timer.Simple(3, function()
	for k, v in SortedPairs(PCMACConfig.Categories) do
		local CPANEL = CPANEL or {}
		function CPANEL:Init()
			local gp = vgui.Create("DPanelList", self)
			gp:Dock(FILL)
			gp:EnableHorizontal(true)
			gp:SetPadding( 25 )
			gp:SetAutoSize(true)
			gp:SetSpacing(9)

			for j, item in SortedPairs( PCMACConfig.Items ) do
				if item.Category == v.Name then
					local Hovered = false
					local iconmove = 0
					local locked
					local sw = ScrW()/7.5
					local sh = ScrH()/7.5
					if LocalPlayer():PC_Leveling_GetLevel(4) < item.Costs.Levels.Value then
						locked = true
					else
						locked = false
					end	

					local Hovered = false
					local iconmove = 0
					local BG = vgui.Create("DPanel")
					BG:SetSize( sw,sh )
					BG.Paint = function(self, w, h)

						draw.RoundedBox(5, 0, 0, w, h, Hovered and Color(35,35,35) or Color(55,55,55))
						draw.RoundedBox(5, 4, 4, w-8, h-8, Hovered and Color(55,55,55) or Color(35,35,35))

					end

					local icon = vgui.Create( "DModelPanel", BG )
					icon:SetSize( sw-8,sh-8 )
					icon:SetPos(4,4)


					icon:SetModel(item.Model)
					function icon:LayoutEntity(Ent)
						if Hovered then
							iconmove = iconmove+1
							Ent:SetAngles( Angle( 0, iconmove,  0) )
						else
							if iconmove != 0 then iconmove = 0 end
							Ent:SetAngles( Angle( 0, 0, 0) )
						end
					end
					local min, max = icon.Entity:GetRenderBounds()    
					icon:SetCamPos((min:Distance(max)*Vector(0.75, 0.75, 0.5)))    
					icon:SetLookAt((max + min)/2)
					icon:SetFOV(70)

					local FG = vgui.Create("DPanel", icon)
					FG:Dock(FILL)
					FG.Paint = function(self, w, h)
						if locked then
							XeninUI:DrawBlur(self, 2.5)
							HUD:WebImage("https://i.imgur.com/tt2NiHl.png", w/2.5, h/4, HUD:Scale(60), HUD:Scale(60), nil, nil, nil, nil)
						end
						draw.SimpleText(locked and "Lvl Needed: "..item.Costs.Levels.Value or item.Name, "HUD:Font20", w/2, h/10, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
					end
				
					local iconbutton = vgui.Create( "DButton", icon)
					iconbutton:SetSize(sw,sh)
					iconbutton:SetDrawBackground(false)
					iconbutton:SetText("")
					iconbutton.OnCursorEntered = function()
						Hovered = true
					end
					iconbutton.OnCursorExited = function()
						Hovered = false
					end
						iconbutton.DoClick = function()
						if locked then return end
								local craftPopup = vgui.Create("PCMAC_CraftingPopupPanel")
								craftPopup:MakePopup()
								craftPopup:SetSize(ScrW(), ScrH())
								craftPopup:SetBackgroundHeight(ScrH()/2)
								craftPopup:SetBackgroundWidth(ScrW()/2)
						craftPopup:PostInit(j, self, item.Model)
						end

					gp:AddItem( BG )
				end
			end

		end
		vgui.Register("PCMAC_CraftingPanel_"..v.Name, CPANEL)
	end

	function PANEL:Init()
		self.Sidebar = self:Add("XeninUI.SidebarV2")
		self.Sidebar:Dock(LEFT)
		self.Sidebar:SetWide(150)

		self.Background = self:Add("Panel")
		self.Background:Dock(FILL)
		self.Background.Paint = function(pnl, w, h)
				XeninUI:DrawRoundedBox(6, 0, 0, w, h, Color(25,25,25), false, false, false, true)
		end


		self.Sidebar:SetBody(self.Background)

		self:Create()

		self.Sidebar:SetActiveByName("Guns")
	end


	function PANEL:Create()
		local col = {
			colors = {
				[1] = Color(55,155,255),
				[2] = Color(40,40,40)
				},
		
		}
		for k, v in SortedPairs( PCMACConfig.Categories ) do
			self.Sidebar:CreatePanel(v.Name, "", "PCMAC_CraftingPanel_"..v.Name, v.Icon, col)
		end
	end



	vgui.Register("PCMAC_CraftingPanel", PANEL)
end)