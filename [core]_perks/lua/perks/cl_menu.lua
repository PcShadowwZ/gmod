perksconfig = perksconfig or {}
concommand.Add("perkmenu_open", function( ply, cmd, args )
    	local MFrame = vgui.Create("PIXEL.Frame")
    	MFrame:SetSize(PIXEL.Scale(300), PIXEL.Scale(250))
    	MFrame:Center()
	MFrame:SetTitle("Perk Menu")
    	MFrame:MakePopup()
	local Panel = vgui.Create("DPanelList", MFrame)
	Panel:Dock(FILL)
	Panel:EnableHorizontal(true)
	Panel:SetPadding( PIXEL.Scale(15) )
	Panel:SetAutoSize(true)
	Panel:SetSpacing(PIXEL.Scale(10))
	for k, v in pairs(perksconfig.types) do
		local Option = vgui.Create("DPanel")
		Option:SetSize(125, 50)
  		Option.Paint = function(pnl, w, h)
			draw.RoundedBox( 5, 0, 0, w , h , Color( 0, 0, 0, 0 ) )
 		end
		local Btn = vgui.Create("DButton", Option)
		Btn:Dock(FILL)
		Btn:SetDrawBackground(false)
		Btn:SetText("")
        	Btn.DoClick = function()
			print(k)
			RunConsoleCommand( "perks_buy", k )
        	end
  		Btn.Paint = function(pnl, w, h)
			draw.RoundedBox( 5, 0, 0, w , h , pnl:IsHovered() and Color(v.Color.r/2,v.Color.g/2,v.Color.b/2) or v.Color)
			PIXEL.DrawSimpleText(pnl:IsHovered() and DarkRP.formatMoney(v.Cost) or k, "UI.TextEntry", w/2, h / 2, PIXEL.Colors.SecondaryText, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
 		end
		Panel:AddItem( Option )
	end
end)

hook.Add( "OnPlayerChat", "OpenPerkMenu", function( ply, txt, team, state ) 
	if ply != LocalPlayer() then return end
	if table.HasValue(perksconfig.chatCmds, txt) then
		RunConsoleCommand( "perkmenu_open" )
		return true
	end
end)
