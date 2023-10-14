local PANEL = {}
local ply = FindMetaTable("Player")
PCMAC = PCMAC or {}
PCMACConfig = PCMACConfig or {}

function PANEL:Init()
    	self.Scrollpanel = vgui.Create("XeninUI.Scrollpanel.Wyvern", self)
    	self.Scrollpanel:Dock(FILL)
    	self.Scrollpanel:DockMargin(16, 16, 16, 16)
end



function PANEL:OnSwitchedTo()
    	self:Create()
end




function PANEL:Create()
    	self.Scrollpanel:Clear()
	PCMACConfig = PCMACConfig or {}
	PCMAC = PCMAC or {}

    	for k, v in pairs (PCMACConfig.Ores) do 
		local Hovered = false
		local plyMaxOres = PCMAC:GetMaxOre(LocalPlayer(),k)
		local plyOreCount = math.Round(PCMAC.PlyMaterials[k],1) or 0
        	local Panel = vgui.Create("DButton", self.Scrollpanel)



		

        	Panel:Dock(TOP)
		Panel:SetText( "" )	
        	Panel:DockMargin(0, 0, 8, 8)
        	Panel:SetTall(75)
		local lerpOre = 0
		local barLength = 0
		local barSpeed = 2
        	function Panel.Paint(pnl, w, h)
            		draw.RoundedBox(4, 2, 2, w-4, h-4, Hovered and Color(35,35,35) or Color(40,40,40) )

			lerpOre = Lerp(2 * RealFrameTime() , math.Round(lerpOre,2), plyOreCount  )
			lerpOreName = Lerp(10 * RealFrameTime() , lerpOre, plyOreCount  )

			oreW =  math.Clamp( (lerpOre / plyMaxOres) * (w/1.2) , 0, w/1.2   ) 

			draw.RoundedBox(5, HUD:Scale(5), h/1.8, w/1.2 , h/3, Color(25,25,25))

			
			if tonumber(plyOreCount) < tonumber(plyMaxOres) - (tonumber(plyMaxOres)/175) then
				draw.RoundedBoxEx(5, HUD:Scale(5) + 3, h/1.8 + 3, oreW - 6 , h/3 - 6, v.Color, true, false , true, false )
                	else
				draw.RoundedBox(5, HUD:Scale(5) + 3, h/1.8 + 3,  oreW  - 6, h/3 - 6, v.Color )
			end
			
			HUD:WebImage(v.Image or "https://i.imgur.com/V7NoHO4.png",  string.len(k) * HUD:Scale(15), h/10, HUD:Scale(30), HUD:Scale(30), nil, nil, nil, nil)


			draw.SimpleText( k, "HUD:Font25", HUD:Scale(5), HUD:Scale(5), v.Color )
			draw.SimpleText( plyOreCount.."/"..plyMaxOres.." ", "HUD:Font25", w - HUD:Scale(175), h/2, color_white)

			if pnl:IsHovered() then
				barLength = math.Clamp(barLength + barSpeed * FrameTime(), 0, 1)
			else		
				barLength = math.Clamp(barLength - barSpeed * FrameTime(), 0, 1)		
			end
			draw.RoundedBox(4, 2, h * .9, w * barLength, h * .05, v.Color )
        	end
       	 	function Panel.OnCursorEntered(pnl)
			Hovered = true
        	end
        	function Panel.OnCursorExited(pnl)
			Hovered = false
        	end
        	function Panel.DoClick(pnl)
			local price = 0
            		local query = XeninUI:SimpleQuery("Sell "..k, "How Much " .. k .. " Do You Want To Sell? ($"..v.Price.." Per Ore)", "Sell", function(_, pnl, value)

				

                		value = tonumber(value)

                		if value <= 0 then return end

				self.Scrollpanel:Clear()

				net.Start( "PCMAC_SellOre" )
					net.WriteString(k)
					net.WriteFloat(value)
				net.SendToServer()

				timer.Simple(0.5, function()
					self:Create()
				end)

			
                        	

            		end, "Cancel")



            		query:SetInput(plyOreCount, "Amount", true)
            		query:SetBackgroundHeight(200)

        	end


  




	end
end

vgui.Register("PCMAC_Materials", PANEL)