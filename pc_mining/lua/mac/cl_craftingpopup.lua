local PANEL = PANEL or {}
PCMAC = PCMAC or {}
PCMACConfig = PCMACConfig or {}
local val
local canGet
function PANEL:PostInit(id, parentPanel, model)
    	self.background:SetTitle("Craft "..PCMACConfig.Items[id].Name)

	local BG = vgui.Create("DPanel", self.background)
	BG:Dock(LEFT)
	BG:SetWide(HUD:Scale(300))
	BG.Paint = function(self, w, h)
			draw.RoundedBox(5, 0, 0, w, h, Hovered and Color(35,35,35) or Color(55,55,55))
			draw.RoundedBox(5, 4, 4, w-8, h-8, Hovered and Color(55,55,55) or Color(35,35,35))
			draw.SimpleText(PCMACConfig.Items[id].Name, "HUD:Font30", w/2, h/10, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

    	self.ScrollBar = vgui.Create("XeninUI.Scrollpanel.Wyvern", self.background)
    	self.ScrollBar:Dock(FILL)
    	self.ScrollBar:DockMargin(5, 5, 5, 5)



	local icon = vgui.Create( "DModelPanel", BG )
	icon:SetFOV(50)
	icon:SetModel(model)
	icon:Dock(FILL)
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

	canGet = true
    	for k, v in pairs(PCMACConfig.Items[id].Costs) do
		
        	local Panel = vgui.Create("DPanel", self.ScrollBar)
        	Panel:Dock(TOP)
        	Panel:DockMargin(5, 5, 5, 5)
        	Panel:SetTall(70)
		function Panel.Paint(pnl, w, h)
			if k == "Levels" then
				hasReq =  math.Clamp( (LocalPlayer():PC_Leveling_GetLevel(4) / (v.Value)) *  w/1.025, 0 , w/1.025)   
			elseif k == "Money" then
				hasReq = math.Clamp( (LocalPlayer():getDarkRPVar("money")/  v.Value ) * w/1.025, 0, w/1.025 )
			else
				hasReq = math.Clamp( (PCMAC.PlyMaterials[k] /  v.Value ) * w/1.025, 0, w/1.025 )
			end
			draw.RoundedBox(5, 0, 0, w, h, Color(50,50,50))

			



			local canGetLocal = true
			if k == "Money" then
				if !LocalPlayer():canAfford(v.Value) then
					canGet = false
					canGetLocal = false
				end
			elseif k == "Levels" then
				if LocalPlayer():PC_Leveling_GetLevel(4) < v.Value then
					canGet = false
					canGetLocal = false
				end
			elseif tonumber(PCMAC.PlyMaterials[k]) <  v.Value then
				canGet = false
				canGetLocal = false
			end

			draw.SimpleText(k, "HUD:Font25", HUD:Scale(5), HUD:Scale(5), color_white )

			draw.RoundedBox(5, w/100, h/2, w/1.025, h/3, Color(30,30,30))

			draw.RoundedBox(5, w/100, h/2, hasReq, h/3, v.Color)

			if k == "Levels" then
				draw.SimpleText(LocalPlayer():PC_Leveling_GetLevel(4) .. "/".. v.Value , "HUD:Font25", w/3, HUD:Scale(5), canGetLocal and Color(50,250,50) or Color(250,50,50) )
			elseif k == "Money" then
				draw.SimpleText(DarkRP.formatMoney(LocalPlayer():getDarkRPVar("money")).."/"..DarkRP.formatMoney(v.Value), "HUD:Font25", w/3, HUD:Scale(5), canGetLocal and Color(50,250,50) or Color(250,50,50) )
			else
				draw.SimpleText(PCMAC.PlyMaterials[k] .. "/".. v.Value , "HUD:Font25", w/3, HUD:Scale(5), canGetLocal and Color(50,250,50) or Color(250,50,50) )
			end


			
		end
    	end

        local uPanel = vgui.Create("DButton", self.background)
	local hover = false
        uPanel:Dock(BOTTOM)
	uPanel:SetText( "" )	
        uPanel:DockMargin(280, 15, 280, 20)
	uPanel:SetTall( 50 )	
	function uPanel.Paint(pnl, w, h)
		if hover then
			draw.RoundedBox(5, 0, 0, w, h, canGet and Color(50,250,50) or Color(250,50,50)    )
		end
		draw.RoundedBox(5, 2, 2, w-4, h-4, hover and Color(25,25,25) or Color(40,40,40))
		draw.SimpleText("Craft" , "HUD:Font40", w/2, h/2, canGet and Color(50,250,50) or Color(250,50,50),1,1 )
			
	end

       	function uPanel.OnCursorEntered(pnl)
		hover = true
        end
        function uPanel.OnCursorExited(pnl)
		hover = false
        end
	function uPanel.DoClick(pnl)	
		if canGet then
			net.Start( "PCMAC_Craft" )
				net.WriteString(id)
			net.SendToServer()
		else
			net.Start( "PCMAC_Craft" )
				net.WriteString("False")
			net.SendToServer()
		end
	end
end





vgui.Register("PCMAC_CraftingPopupPanel", PANEL, "XeninUI.Popup")

