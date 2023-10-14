Inventory = Inventory or {}


local espMod = {
	[ "$pp_colour_addr" ] = 0,
	[ "$pp_colour_addg" ] = 0,
	[ "$pp_colour_addb" ] = 0,
	[ "$pp_colour_brightness" ] = 0,
	[ "$pp_colour_contrast" ] = 1,
	[ "$pp_colour_colour" ] = 0,
	[ "$pp_colour_mulr" ] = 0 ,
	[ "$pp_colour_mulg" ] = 0 ,
	[ "$pp_colour_mulb" ] = 0 
}

local juggerMod = {
	[ "$pp_colour_addr" ] = 0,
	[ "$pp_colour_addg" ] = 0,
	[ "$pp_colour_addb" ] = 0,
	[ "$pp_colour_brightness" ] = 0,
	[ "$pp_colour_contrast" ] = 1,
	[ "$pp_colour_colour" ] = 1,
	[ "$pp_colour_mulr" ] = 0 ,
	[ "$pp_colour_mulg" ] = 0 ,
	[ "$pp_colour_mulb" ] = 0 
}

local nanoMod = {
	[ "$pp_colour_addr" ] = 0,
	[ "$pp_colour_addg" ] = 0,
	[ "$pp_colour_addb" ] = 0,
	[ "$pp_colour_brightness" ] = 0,
	[ "$pp_colour_contrast" ] = 1,
	[ "$pp_colour_colour" ] = 1,
	[ "$pp_colour_mulr" ] = 0 ,
	[ "$pp_colour_mulg" ] = 0 ,
	[ "$pp_colour_mulb" ] = 0 
}

local warfareMod = {
	[ "$pp_colour_addr" ] = 0,
	[ "$pp_colour_addg" ] = 0,
	[ "$pp_colour_addb" ] = 0,
	[ "$pp_colour_brightness" ] = 0,
	[ "$pp_colour_contrast" ] = 1,
	[ "$pp_colour_colour" ] = 1,
	[ "$pp_colour_mulr" ] = 0 ,
	[ "$pp_colour_mulg" ] = 0 ,
	[ "$pp_colour_mulb" ] = 0 
}

local agilityMod = {
	[ "$pp_colour_addr" ] = 0,
	[ "$pp_colour_addg" ] = 0,
	[ "$pp_colour_addb" ] = 0,
	[ "$pp_colour_brightness" ] = 0,
	[ "$pp_colour_contrast" ] = 1,
	[ "$pp_colour_colour" ] = 1,
	[ "$pp_colour_mulr" ] = 0 ,
	[ "$pp_colour_mulg" ] = 0 ,
	[ "$pp_colour_mulb" ] = 0 
}

local strifeMod = {
	[ "$pp_colour_addr" ] = 0,
	[ "$pp_colour_addg" ] = 0,
	[ "$pp_colour_addb" ] = 0,
	[ "$pp_colour_brightness" ] = 0,
	[ "$pp_colour_contrast" ] = 1,
	[ "$pp_colour_colour" ] = 1,
	[ "$pp_colour_mulr" ] = 0 ,
	[ "$pp_colour_mulg" ] = 0 ,
	[ "$pp_colour_mulb" ] = 0 
}

local surgeMod = {
	[ "$pp_colour_addr" ] = 0,
	[ "$pp_colour_addg" ] = 0,
	[ "$pp_colour_addb" ] = 0,
	[ "$pp_colour_brightness" ] = 0,
	[ "$pp_colour_contrast" ] = 1,
	[ "$pp_colour_colour" ] = 1,
	[ "$pp_colour_mulr" ] = 0 ,
	[ "$pp_colour_mulg" ] = 0 ,
	[ "$pp_colour_mulb" ] = 0 
}

local riftMod = {
	[ "$pp_colour_addr" ] = 0,
	[ "$pp_colour_addg" ] = 0,
	[ "$pp_colour_addb" ] = 0,
	[ "$pp_colour_brightness" ] = 0,
	[ "$pp_colour_contrast" ] = 1,
	[ "$pp_colour_colour" ] = 1,
	[ "$pp_colour_mulr" ] = 0 ,
	[ "$pp_colour_mulg" ] = 0 ,
	[ "$pp_colour_mulb" ] = 0 
}

local empMod = {
	[ "$pp_colour_addr" ] = 0,
	[ "$pp_colour_addg" ] = 0,
	[ "$pp_colour_addb" ] = 0,
	[ "$pp_colour_brightness" ] = 0,
	[ "$pp_colour_contrast" ] = 1,
	[ "$pp_colour_colour" ] = 1,
	[ "$pp_colour_mulr" ] = 0 ,
	[ "$pp_colour_mulg" ] = 0 ,
	[ "$pp_colour_mulb" ] = 0 
}

local divineMod = {
	[ "$pp_colour_addr" ] = 0,
	[ "$pp_colour_addg" ] = 0,
	[ "$pp_colour_addb" ] = 0,
	[ "$pp_colour_brightness" ] = 0,
	[ "$pp_colour_contrast" ] = 1,
	[ "$pp_colour_colour" ] = 1,
	[ "$pp_colour_mulr" ] = 0 ,
	[ "$pp_colour_mulg" ] = 0 ,
	[ "$pp_colour_mulb" ] = 0 
}








local function coords(ent)
	local min, max = ent:OBBMins() , ent:OBBMaxs()
	local corners = 
	{
			Vector( min.x, min.y, min.z ),
			Vector( min.x, min.y, max.z ),
			Vector( min.x, max.y, min.z ),
			Vector( min.x, max.y, max.z ),
			Vector( max.x, min.y, min.z ),
			Vector( max.x, min.y, max.z ),
			Vector( max.x, max.y, min.z ),
			Vector( max.x, max.y, max.z )
	}
	
	local LminX, LminY, LmaxX, LmaxY = ScrW() , ScrH() ,  0 ,  0
	local BminX, BminY, BmaxX, BmaxY = ScrW() , ScrH() ,  0 ,  0
	local IminX, IminY, ImaxX, ImaxY = ScrW() , ScrH() ,  0 ,  0

	bOffset = 7.5
	lOffset = 3
	iOffset = 12.5
	for _, corner in pairs( corners ) do
		local onScreen = ent:LocalToWorld( corner ):ToScreen()

		LminX, LminY = math.min( LminX, onScreen.x - lOffset), math.min( LminY, onScreen.y - lOffset)
		LmaxX, LmaxY = math.max( LmaxX, onScreen.x + lOffset), math.max( LmaxY, onScreen.y + lOffset)

		BminX, BminY = math.min( BminX, onScreen.x + bOffset), math.min( BminY, onScreen.y + bOffset)
		BmaxX, BmaxY = math.max( BmaxX, onScreen.x - bOffset), math.max( BmaxY, onScreen.y - bOffset)

		IminX, IminY = math.min( IminX, onScreen.x - iOffset), math.min( IminY, onScreen.y - iOffset*1.5)
		ImaxX, ImaxY = math.max( ImaxX, onScreen.x + iOffset), math.max( ImaxY, onScreen.y + iOffset/2.5)

	end

	return LminX, LminY, LmaxX, LmaxY, BminX, BminY, BmaxX, BmaxY, IminX, IminY, ImaxX, ImaxY
end



local function ESP(ent)
	local LerpAlpha = 200

	local dist = LocalPlayer():GetPos():Distance( ent:GetPos() )

	if ent:GetModel() == "models/nanosuit/nanosuit_male_playermodel.mdl" and ent:GetNWBool("CamoOn", false) then
		LerpAlpha = 0
	elseif ent:GetModel() == "models/nanosuit/nanosuit_male_playermodel.mdl" then
		LerpAlpha = math.Clamp( LerpAlpha - (dist/18) , 0, 5 )
	elseif ent:GetNWBool("RiftOn", false) and ent:GetModel() == "models/konnie/asapgaming/destiny2/futurefacing.mdl"  then
		LerpAlpha = 0
	else
		LerpAlpha = LerpAlpha - (dist/18) 
	end
	

	local Lx1,Ly1,Lx2,Ly2,Bx1,By1,Bx2,By2,Ix1,Iy1,Ix2,Iy2 = coords(ent)

	local hp = math.Round(math.Clamp((ent:Health()/ent:GetMaxHealth()) * 255, 0 , 255))

	surface.SetDrawColor(Color(100 , hp , 0, LerpAlpha/2))

	surface.DrawRect(Bx1 , By1, (Bx2 - Bx1) + 1, (By2 - By1) + 1 )

	surface.SetDrawColor(Color(155 , hp , 0, LerpAlpha))
	
	if (Lx1 and Lx2 and Lx1 != 0 and Lx2 != 0 and Ly1 and Ly2 and Ly1 != 0 and Ly2 != 0) then

		surface.DrawLine( Lx1, Ly1, Lx2, Ly1 )
		surface.DrawLine( Lx1, Ly1, Lx1, Ly2 )

		surface.DrawLine( Lx2, Ly1, Lx1, Ly1 )
		surface.DrawLine( Lx2, Ly1, Lx2, Ly2 )

		surface.DrawLine( Lx1, Ly2, Lx2, Ly2 )
		surface.DrawLine( Lx1, Ly2, Lx1, Ly1 )

		surface.DrawLine( Lx2, Ly2, Lx1, Ly2 )
		surface.DrawLine( Lx2, Ly2, Lx2, Ly1 )
	end	

	if ent:IsPlayer() and ent:GetModel() != "models/nanosuit/nanosuit_male_playermodel.mdl" then
		if ent:Alive() then
			draw.DrawText( ent:Nick().."   (HP: "..ent:Health().."/"..ent:GetMaxHealth()..")", "TTSmall", Lx2-((Lx2-Lx1)/2), Iy1, Color(255 , 255 , 255, LerpAlpha), TEXT_ALIGN_CENTER )
			draw.DrawText( ent:getJobTable().name, "TTSmall", Lx2-((Lx2-Lx1)/2), Iy2, Color(255 , 255 , 255, LerpAlpha), TEXT_ALIGN_CENTER )
		else
			draw.DrawText( ent:Nick().."   Dead", "TTSmall", Lx2-((Lx2-Lx1)/2), Iy1, Color(255 , 35 , 35, LerpAlpha), TEXT_ALIGN_CENTER )
			draw.DrawText( ent:getJobTable().name, "TTSmall", Lx2-((Lx2-Lx1)/2), Iy2, Color(255 , 35 , 35, LerpAlpha), TEXT_ALIGN_CENTER )
		end
		
	elseif ent.printer then
		draw.DrawText(ent.Name, "TTInfo", Ix1, Iy1, Color(255 , 255 , 255, 255), TEXT_ALIGN_LEFT )
	end
end

local function PoliceESP(ent)
	local Alpha 
	local dist = LocalPlayer():GetPos():Distance( ent:GetPos() )

	if ent:GetModel() == "models/nanosuit/nanosuit_male_playermodel.mdl" and ent.invis then
		Alpha = 0
	elseif ent:GetModel() == "models/nanosuit/nanosuit_male_playermodel.mdl" then
		Alpha = 4
	else
		Alpha = 200
	end


	local Lx1,Ly1,Lx2,Ly2,Bx1,By1,Bx2,By2,Ix1,Iy1,Ix2,Iy2 = coords(ent)

	if ent:isWanted() then
		surface.SetDrawColor(Color(200 , 0 , 0, Alpha))
	else
		surface.SetDrawColor(Color(255 , 255 , 255, Alpha))
	end

	
	if (Lx1 and Lx2 and Lx1 != 0 and Lx2 != 0 and Ly1 and Ly2 and Ly1 != 0 and Ly2 != 0) then

		surface.DrawLine( Lx1, Ly1, Lx2, Ly1 )
		surface.DrawLine( Lx1, Ly1, Lx1, Ly2 )

		surface.DrawLine( Lx2, Ly1, Lx1, Ly1 )
		surface.DrawLine( Lx2, Ly1, Lx2, Ly2 )

		surface.DrawLine( Lx1, Ly2, Lx2, Ly2 )
		surface.DrawLine( Lx1, Ly2, Lx1, Ly1 )

		surface.DrawLine( Lx2, Ly2, Lx1, Ly2 )
		surface.DrawLine( Lx2, Ly2, Lx2, Ly1 )
	end	

	if ent:IsPlayer() and ent:GetModel() != "models/nanosuit/nanosuit_male_playermodel.mdl" then
		if ent:Alive() then
			draw.DrawText( ent:Nick(), "TTInfo", Ix1, Iy1, ent:isWanted() and Color(200 , 0 , 0, 255) or color_white, TEXT_ALIGN_LEFT )
			draw.DrawText( ent:isWanted() and "Wanted" or "Not Wanted", "TTInfo", Ix1, Iy2, ent:isWanted() and Color(200 , 0 , 0, 255) or color_white, TEXT_ALIGN_LEFT )
		else
			draw.DrawText( "Dead", "TTInfo", Ix1, Iy1, Color(255 , 35 , 35, 255), TEXT_ALIGN_LEFT )
		end
	end

end



local startSuit = .4
hook.Add("RenderScreenspaceEffects", "Suit_Overlays", function()
	local ply = LocalPlayer()
	local model = string.lower(ply:GetModel())
	if LocalPlayer():GetActiveWeapon() == "Camera" then return end
	if GetViewEntity() != LocalPlayer() then return end
	if (model == "models/gonzo/skullsilverjuggernaut/skullsilverjuggernaut.mdl") then
		DrawMaterialOverlay( "effects/combine_binocoverlay", 0.3 )
		if LocalPlayer():GetNWInt("SuitEquipStatus", 0) == 0 then
			startSuit = 1	
		end
		if startSuit > .01 then
			juggerMod[ "$pp_colour_contrast" ] = startSuit + 1
			juggerMod[ "$pp_colour_mulr" ] =  .5 + startSuit
			juggerMod[ "$pp_colour_mulg" ] = .1 + startSuit
			juggerMod[ "$pp_colour_mulb" ] = .1 + startSuit
			juggerMod[ "$pp_colour_addr" ] = .2 + startSuit
		elseif startSuit > 0 then
			juggerMod[ "$pp_colour_contrast" ] =  1 + startSuit
			juggerMod[ "$pp_colour_colour" ] =  .5 + startSuit
			juggerMod[ "$pp_colour_mulr" ] =  .5 + startSuit
			juggerMod[ "$pp_colour_mulg" ] =  .5 + startSuit
			juggerMod[ "$pp_colour_mulb" ] =  .5 + startSuit
			juggerMod[ "$pp_colour_addr" ] = .2 + startSuit
		end
		DrawColorModify(juggerMod)
		startSuit = Lerp(2 * RealFrameTime() , startSuit, 0  )
		DrawBloom( 0.07, startSuit, 50, 50, 1, 1, 1, 1, 1 )
		DrawSharpen( startSuit * 2, startSuit * 2 )
	end

	if (model == "models/konnie/asapgaming/destiny2/antiextinction.mdl") then
		if LocalPlayer():GetNWInt("SuitEquipStatus", 0) == 0 then
			startSuit = 1	
		end
		startSuit = Lerp(2 * RealFrameTime() , startSuit, 0  )
		DrawBloom( 0.07, startSuit, 50, 50, 1, 1, 1, 1, 1 )
		DrawColorModify(espMod)
		DrawSharpen(9 + (startSuit * 2)  , 0.18 )
		DrawMaterialOverlay( "models/shadertest/shader3" , 0.001 + (startSuit/100)  )
	end

	if ply:GetNWBool("CamoOn", false) and ply:GetModel() == "models/nanosuit/nanosuit_male_playermodel.mdl" then
		startSuit = Lerp(2 * RealFrameTime() , startSuit, 0  )
		DrawColorModify(espMod)
		DrawMotionBlur(0.25, 0.85, 0.02)
		DrawToyTown(2,ScrH()/2)
	elseif ply:GetModel() == "models/nanosuit/nanosuit_male_playermodel.mdl" then
		if LocalPlayer():GetNWInt("SuitEquipStatus", 0) == 0 then
			startSuit = 1	
		end
		nanoMod[ "$pp_colour_contrast" ] = startSuit + 1
		nanoMod[ "$pp_colour_colour" ] =  1 + startSuit
		nanoMod[ "$pp_colour_mulr" ] =  .5 + startSuit
		nanoMod[ "$pp_colour_addr" ] = .25 + startSuit
		startSuit = Lerp(2 * RealFrameTime() , startSuit, 0  )
		DrawColorModify(nanoMod)
	end

	if ply:GetNWBool("SpeedBoost", false) and ply:GetModel() == "models/timeshift/beta_suit.mdl" then
		startSuit = Lerp(2 * RealFrameTime() , startSuit, 0  )
		DrawMotionBlur(0.05, 0.35, 0.01)
		DrawToyTown(2,ScrH()/2)
		agilityMod[ "$pp_colour_contrast" ] = startSuit + 1
		agilityMod[ "$pp_colour_colour" ] =  1.5 + startSuit
		agilityMod[ "$pp_colour_mulr" ] =  .15 
		agilityMod[ "$pp_colour_addr" ] = .15 + startSuit
		agilityMod[ "$pp_colour_mulg" ] =  .15 
		agilityMod[ "$pp_colour_addg" ] = .15 + startSuit
		DrawMaterialOverlay( "Models/effects/comball_tape" , 0.0001 + (startSuit/100)  )
		DrawColorModify(agilityMod)
	elseif ply:GetModel() == "models/timeshift/beta_suit.mdl" then
		if LocalPlayer():GetNWInt("SuitEquipStatus", 0) == 0 then
			startSuit = .35
		end
		agilityMod[ "$pp_colour_contrast" ] = startSuit + 1
		agilityMod[ "$pp_colour_colour" ] =  1.5 + startSuit
		agilityMod[ "$pp_colour_mulr" ] =  .15 
		agilityMod[ "$pp_colour_addr" ] = .15 + startSuit
		agilityMod[ "$pp_colour_mulg" ] =  .15 
		agilityMod[ "$pp_colour_addg" ] = .15 + startSuit
		startSuit = Lerp(2 * RealFrameTime() , startSuit, 0  ) 
		DrawMaterialOverlay( "Models/effects/comball_tape" , 0.0001 + (startSuit/100)  )
		DrawColorModify(agilityMod)
	end

	if ply:GetModel() == "models/arachnit/wolfenstein2/powerarmor/powerarmor_player.mdl" then
		if LocalPlayer():GetNWInt("SuitEquipStatus", 0) == 0 then
			startSuit = .35
		end
		warfareMod[ "$pp_colour_contrast" ] = startSuit + 1
		warfareMod[ "$pp_colour_colour" ] =  1.5 + startSuit
		warfareMod[ "$pp_colour_mulb" ] =  .15 
		warfareMod[ "$pp_colour_addb" ] = .15 + startSuit
		warfareMod[ "$pp_colour_mulg" ] =  .15 
		warfareMod[ "$pp_colour_addg" ] = .15 + startSuit
		startSuit = Lerp(2 * RealFrameTime() , startSuit, 0  )
		DrawSharpen(9 + (startSuit * 2)  , 0.18 )  
		DrawMaterialOverlay( "effects/water_warp" , 0.001 + (startSuit/100)  )
		DrawColorModify(warfareMod)
	end

	if ply:GetModel() == "models/konnie/asapgaming/destiny2/exigent.mdl" then
		if LocalPlayer():GetNWInt("SuitEquipStatus", 0) == 0 then
			startSuit = .35
		end
		strifeMod[ "$pp_colour_contrast" ] = startSuit + 1
		strifeMod[ "$pp_colour_colour" ] =  1.5 + startSuit
		strifeMod[ "$pp_colour_mulb" ] =  .15 
		strifeMod[ "$pp_colour_addb" ] = .15 + startSuit
		strifeMod[ "$pp_colour_mulr" ] =  .15 
		strifeMod[ "$pp_colour_addr" ] = .15 + startSuit
		startSuit = Lerp(2 * RealFrameTime() , startSuit, 0  )
		DrawColorModify(strifeMod)
		DrawSobel( 2 + (startSuit/2) )
	end

	if ply:GetModel() == "models/konnie/asapgaming/destiny2/intrepidexploit.mdl" then
		if LocalPlayer():GetNWInt("SuitEquipStatus", 0) == 0 then
			startSuit = .35
		end
		surgeMod[ "$pp_colour_colour" ] =  .5 + (startSuit * 10)
		startSuit = Lerp(2 * RealFrameTime() , startSuit, 0  )
		DrawSharpen(6 + (startSuit ), .15 )  
		if ply:GetNWBool("DamageBoost", false) then
			DrawMaterialOverlay( "effects/tp_eyefx/tpeye2" , 0.001 + (startSuit/100)  )
		end
		DrawColorModify(surgeMod)
	end

	if ply:GetModel() == "models/konnie/asapgaming/destiny2/crushingset.mdl" then 
		if LocalPlayer():GetNWInt("SuitEquipStatus", 0) == 0 then
			startSuit = .35
		end
		warfareMod[ "$pp_colour_contrast" ] = startSuit + 1
		warfareMod[ "$pp_colour_colour" ] =  1.5 + startSuit
		warfareMod[ "$pp_colour_mulb" ] =  .15 
		warfareMod[ "$pp_colour_addb" ] = .15 + startSuit
		warfareMod[ "$pp_colour_mulg" ] =  .15 
		warfareMod[ "$pp_colour_addg" ] = .15 + startSuit
		startSuit = Lerp(2 * RealFrameTime() , startSuit, 0  )
		DrawColorModify(warfareMod)
	end

	if ply:GetModel() == "models/konnie/asapgaming/destiny2/gardenofsalvation.mdl" then 
		if LocalPlayer():GetNWInt("SuitEquipStatus", 0) == 0 then
			startSuit = .35
		end
		riftMod[ "$pp_colour_contrast" ] = 1
		riftMod[ "$pp_colour_colour" ] =  4 + (startSuit * 10)
		riftMod[ "$pp_colour_mulb" ] =  .05 
		riftMod[ "$pp_colour_addb" ] = .05 + (startSuit/5)
		riftMod[ "$pp_colour_mulg" ] =  .05 
		riftMod[ "$pp_colour_addg" ] = .05 + (startSuit/5)
		startSuit = Lerp(2 * RealFrameTime() , startSuit, 0  )
		DrawColorModify(riftMod)
		if ply:GetNWBool("RiftOn", false) then
			DrawTexturize( 1, Material("pp/texturize/lines.png") )
		end
	end

	if ply:GetModel() == "models/konnie/asapgaming/destiny2/futurefacing.mdl" then 
		if LocalPlayer():GetNWInt("SuitEquipStatus", 0) == 0 then
			startSuit = .35
		end
		empMod[ "$pp_colour_contrast" ] = 1
		empMod[ "$pp_colour_colour" ] =  .5 + (startSuit * 10)
		empMod[ "$pp_colour_mulb" ] =   .1 
		empMod[ "$pp_colour_addb" ] = .2 + ((startSuit/3))
		startSuit = Lerp(2 * RealFrameTime() , startSuit, 0  )
		DrawColorModify(empMod)
	end


	if ply:GetModel() == "models/konnie/asapgaming/destiny2/scatterhorn.mdl" then 
		if LocalPlayer():GetNWInt("SuitEquipStatus", 0) == 0 then
			startSuit = .35
		end
		startSuit = Lerp(2 * RealFrameTime() , startSuit, 0  )
		DrawTexturize( 1, Material("pp/texturize/plain.png") )
	end

	if ply:GetModel() == "models/konnie/asapgaming/destiny2/gardenofsalvation_titan.mdl" then 
		if LocalPlayer():GetNWInt("SuitEquipStatus", 0) == 0 then
			startSuit = .35
		end
		divineMod[ "$pp_colour_contrast" ] = 1
		divineMod[ "$pp_colour_colour" ] =  .5 + (startSuit * 10)
		divineMod[ "$pp_colour_mulr" ] =   .1 
		divineMod[ "$pp_colour_addr" ] = .2 + ((startSuit/3))
		divineMod[ "$pp_colour_mulg" ] =   .1 
		divineMod[ "$pp_colour_addg" ] = .2 + ((startSuit/3))
		startSuit = Lerp(2 * RealFrameTime() , startSuit, 0  )
		DrawColorModify(divineMod)
		DrawSharpen(10 + (startSuit ), .15 )  
	end

end)
local function ScreenScale(number)
	return (ScrH() / 1200) * number
end
hook.Add( "HUDPaint", "Suit_Huds", function()
	local ply = LocalPlayer()
	w = ScrW()
	h = ScrH()
	function ScreenScale(num, h)
		local devw = 2560 
		local devh = 1440 
		
		return num * (h and (ScrH() / devh) or (ScrW() / devw))
	end
	ply.EspEnts = ply.EspEnts or {}
	ply.PEspEnts = ply.PEspEnts or {}
	local model = string.lower(ply:GetModel())
	if ply:GetActiveWeapon() == "Camera" then return end
	if GetViewEntity() != ply then return end
	
	if (model == "models/konnie/asapgaming/destiny2/antiextinction.mdl") then
		local ents = ents.FindInSphere(ply:GetPos(), 999999)
		for k, v in pairs(ents) do
			if v != ply and (v:IsPlayer() or v.printer) and ply:GetPos():Distance( v:GetPos() ) < 3250 then
				if !table.HasValue(ply.EspEnts, v ) then
					surface.PlaySound( "nemesis/esp_start.wav" )
					table.insert( ply.EspEnts, v )
				elseif table.HasValue(ply.EspEnts, v ) then
					ESP(v)
				end
			end
		end
		for k, v in pairs(ents) do
			if ply:GetPos():Distance( v:GetPos() ) > 3250 then
				if table.HasValue(ply.EspEnts, v) then
					table.RemoveByValue( ply.EspEnts, v )
					surface.PlaySound( "nemesis/esp_end.wav" )
				end
			end
		end
	end

	if (model == "models/konnie/isa/detroit/swat_soldier_2.mdl") then
		local ents = ents.FindInSphere(ply:GetPos(), 999999)
		for k, v in pairs(ents) do
			if v != ply and v:IsPlayer() then
				if !table.HasValue(ply.PEspEnts, v ) and ply:GetPos():Distance( v:GetPos() ) < 500 then
					surface.PlaySound( "nemesis/esp_start.wav" )
					table.insert( ply.PEspEnts, v )
				elseif table.HasValue(ply.PEspEnts, v ) then
					PoliceESP(v)
				end
			end
		end
		for k, v in pairs(ents) do
			if ply:GetPos():Distance( v:GetPos() ) > 1500 then
				if table.HasValue(ply.PEspEnts, v) then
					table.RemoveByValue( ply.PEspEnts, v )
					surface.PlaySound( "nemesis/esp_end.wav" )
				end
			end
		end
	end

		if ply:GetModel() == "models/nanosuit/nanosuit_male_playermodel.mdl" then
				local CamoOverlayMat = "camo/camo_overlay.vmt"
				local CamoOverlayID = surface.GetTextureID(CamoOverlayMat)

					surface.SetDrawColor(Color(255,255,255))
					surface.SetTexture(CamoOverlayID)
					surface.DrawTexturedRect(0,0,ScrW(),ScrH())
					
					local nextability = ply:GetNWBool("CamoCD", 0)
					local timeremaining = nextability - CurTime()
					local canuse = timeremaining <= 0
					local mat = Material("vgui/suits/camo_icon.png")
					surface.SetDrawColor(Color(255,0,0,100))
					surface.SetMaterial(mat)
					surface.DrawTexturedRect((ScrW() / 2.21) , ScreenScale(1000, true), ScreenScale(250), ScreenScale(250))


				if (timeremaining + 30) > 30 and ply:GetNWBool("CamoOn", false) then			
					local pct = (100 / 30) 
					local fraction = (((timeremaining * pct) / 100))
					local tall = math.Round(math.Clamp(ScreenScale(250) * fraction, 0, ScreenScale(250)))
				
					surface.SetDrawColor(Color(255,255,255,255))
					surface.SetMaterial(mat)
					surface.DrawTexturedRectUV((ScrW() / 2.21) , (ScreenScale(1000, true)) - tall + ScreenScale(250), ScreenScale(250), tall, 0, (1 - fraction), 1, 1)
				elseif (timeremaining + 30) > 30 and !ply:GetNWBool("CamoOn", false) then	
					surface.SetDrawColor(Color(255,0,0,155))
					surface.SetMaterial(mat)
					surface.DrawTexturedRect((ScrW() / 2.21) , ScreenScale(1000, true), ScreenScale(250), ScreenScale(250))
				elseif (timeremaining + 30) < 30 and (timeremaining + 30) > 0 then
					local pct = (100 / 30) 
					local fraction = 1 - ((((timeremaining + 30) * pct) / 100))
					local tall = math.Round(math.Clamp(ScreenScale(250) * fraction, 0, ScreenScale(250)))
				
					surface.SetDrawColor(Color(255,255,255,255))
					surface.SetMaterial(mat)
					surface.DrawTexturedRectUV((ScrW() / 2.21) , (ScreenScale(1000, true)) - tall + ScreenScale(250), ScreenScale(250), tall, 0, (1 - fraction), 1, 1)
				else
					surface.SetDrawColor(Color(255,255,255, 255))
					surface.SetMaterial(mat)
					surface.DrawTexturedRect((ScrW() / 2.21) , ScreenScale(1000, true), ScreenScale(250), ScreenScale(250))
					draw.SimpleText("["..string.upper( input.LookupBinding("gm_showspare1")).."]", "TTName", w / 2 , ScrH()/1.315 + 20 + 2, Color(40,40,40,235), 1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
					draw.SimpleText("["..string.upper( input.LookupBinding("gm_showspare1")).."]", "TTName", w / 2 , ScrH()/1.315 + 20, Color(225,225,225), 1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				end

		end

		if ply:GetModel() == "models/timeshift/beta_suit.mdl" then
				local nextability = ply:GetNWBool("BoostCD", 0)
				local timeremaining = nextability - CurTime()
				local canuse = timeremaining <= 0
				local mat = Material("vgui/suits/speed_icon.png")
				surface.SetDrawColor(Color(255,0,0,100))
				surface.SetMaterial(mat)
				surface.DrawTexturedRect((ScrW() / 2.21) , ScreenScale(1000, true), ScreenScale(250), ScreenScale(250))


				if (timeremaining + 20) > 20 and ply:GetNWBool("BoostCD", false) then			
					local pct = (100 / 10) 
					local fraction = (((timeremaining * pct) / 100))
					local tall = math.Round(math.Clamp(ScreenScale(250) * fraction, 0, ScreenScale(250)))
				
					surface.SetDrawColor(Color(255,255,255,255))
					surface.SetMaterial(mat)
					surface.DrawTexturedRectUV((ScrW() / 2.21) , (ScreenScale(1000, true)) - tall + ScreenScale(250), ScreenScale(250), tall, 0, (1 - fraction), 1, 1)
				elseif (timeremaining + 20) > 20 and !ply:GetNWBool("BoostCD", false) then	
					surface.SetDrawColor(Color(255,0,0,155))
					surface.SetMaterial(mat)
					surface.DrawTexturedRect((ScrW() / 2.21) , ScreenScale(1000, true), ScreenScale(250), ScreenScale(250))
				elseif (timeremaining + 20) < 20 and (timeremaining + 20) > 0 then
					local pct = (100 / 20) 
					local fraction = 1 - ((((timeremaining + 20) * pct) / 100))
					local tall = math.Round(math.Clamp(ScreenScale(250) * fraction, 0, ScreenScale(250)))
				
					surface.SetDrawColor(Color(255,255,255,255))
					surface.SetMaterial(mat)
					surface.DrawTexturedRectUV((ScrW() / 2.21) , (ScreenScale(1000, true)) - tall + ScreenScale(250), ScreenScale(250), tall, 0, (1 - fraction), 1, 1)
				else
					surface.SetDrawColor(Color(255,255,255, 255))
					surface.SetMaterial(mat)
					surface.DrawTexturedRect((ScrW() / 2.21) , ScreenScale(1000, true), ScreenScale(250), ScreenScale(250))
					draw.SimpleText("["..string.upper( input.LookupBinding("gm_showspare1")).."]", "TTName", w / 2 , ScrH()/1.315 + 20 + 2, Color(40,40,40,235), 1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
					draw.SimpleText("["..string.upper( input.LookupBinding("gm_showspare1")).."]", "TTName", w / 2 , ScrH()/1.315 + 20, Color(225,225,225), 1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				end

		end

		if ply:GetModel() == "models/arachnit/wolfenstein2/powerarmor/powerarmor_player.mdl" then
				local nextability = ply:GetNWBool("ShieldCD", 0)
				local timeremaining = nextability - CurTime()
				local canuse = timeremaining <= 0
				local mat = Material("vgui/suits/sheild_icon.png")
				surface.SetDrawColor(Color(255,0,0,100))
				surface.SetMaterial(mat)
				surface.DrawTexturedRect((ScrW() / 2.21) , ScreenScale(1000, true), ScreenScale(250), ScreenScale(250))


				if (timeremaining + 60) > 60 and ply:GetNWBool("ShieldCD", false) then			
					local pct = (100 / 10) 
					local fraction = (((timeremaining * pct) / 100))
					local tall = math.Round(math.Clamp(ScreenScale(250) * fraction, 0, ScreenScale(250)))
				
					surface.SetDrawColor(Color(255,255,255,255))
					surface.SetMaterial(mat)
					surface.DrawTexturedRectUV((ScrW() / 2.21) , (ScreenScale(1000, true)) - tall + ScreenScale(250), ScreenScale(250), tall, 0, (1 - fraction), 1, 1)
				elseif (timeremaining + 60) > 60 and !ply:GetNWBool("ShieldCD", false) then	
					surface.SetDrawColor(Color(255,0,0,155))
					surface.SetMaterial(mat)
					surface.DrawTexturedRect((ScrW() / 2.21) , ScreenScale(1000, true), ScreenScale(250), ScreenScale(250))
				elseif (timeremaining + 60) < 60 and (timeremaining + 60) > 0 then
					local pct = (100 / 60) 
					local fraction = 1 - ((((timeremaining + 60) * pct) / 100))
					local tall = math.Round(math.Clamp(ScreenScale(250) * fraction, 0, ScreenScale(250)))
				
					surface.SetDrawColor(Color(255,255,255,255))
					surface.SetMaterial(mat)
					surface.DrawTexturedRectUV((ScrW() / 2.21) , (ScreenScale(1000, true)) - tall + ScreenScale(250), ScreenScale(250), tall, 0, (1 - fraction), 1, 1)
				else
					surface.SetDrawColor(Color(255,255,255, 255))
					surface.SetMaterial(mat)
					surface.DrawTexturedRect((ScrW() / 2.21) , ScreenScale(1000, true), ScreenScale(250), ScreenScale(250))
					draw.SimpleText("["..string.upper( input.LookupBinding("gm_showspare1")).."]", "TTName", w / 2 , ScrH()/1.315 + 20 + 2, Color(40,40,40,235), 1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
					draw.SimpleText("["..string.upper( input.LookupBinding("gm_showspare1")).."]", "TTName", w / 2 , ScrH()/1.315 + 20, Color(225,225,225), 1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				end

		end

		if ply:GetModel() == "models/konnie/asapgaming/destiny2/exigent.mdl" then 
				local nextability = ply:GetNWBool("StrifeCD", 0)
				local timeremaining = nextability - CurTime()
				local canuse = timeremaining <= 0
				local mat = Material("hud/qba/progressbar_full.png")
				local mat2 = Material("hud/qba/deny.png")
				if canuse then
					surface.SetDrawColor(Color(0,255,0, 255))
					surface.SetMaterial(mat)
					surface.DrawTexturedRect((ScrW() / 2.21) , ScreenScale(1000, true), ScreenScale(250), ScreenScale(250))
					draw.SimpleText("["..string.upper( input.LookupBinding("gm_showspare1")).."]", "TTName", w / 2 , ScrH()/1.315 + 20 + 2, Color(40,40,40,235), 1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
					draw.SimpleText("["..string.upper( input.LookupBinding("gm_showspare1")).."]", "TTName", w / 2 , ScrH()/1.315 + 20, Color(225,225,225), 1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				else
					surface.SetDrawColor(Color(255,0,0,255))
					surface.SetMaterial(mat)
					surface.DrawTexturedRect((ScrW() / 2.21) , ScreenScale(1000, true), ScreenScale(250), ScreenScale(250))
					surface.SetDrawColor(Color(255,0,0,255))
					surface.SetMaterial(mat2)
					surface.DrawTexturedRect((ScrW() / 2.21) , ScreenScale(1000, true), ScreenScale(250), ScreenScale(250))
					draw.SimpleText("["..math.Round(timeremaining, 1).."]", "TTName", w / 2 , ScrH()/1.315 + 20 + 2, Color(40,40,40,235), 1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
					draw.SimpleText("["..math.Round(timeremaining, 1).."]", "TTName", w / 2 , ScrH()/1.315 + 20, Color(225,225,225), 1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				end

				if ply:GetNWBool("IsSetTypeForTp", false) then
					draw.SimpleText("[TP POS: TRUE]", "TTName", w / 2 , ScrH()/1.15, Color(22,225,22), 1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				else
					draw.SimpleText("[TP POS: FALSE]", "TTName", w / 2 , ScrH()/1.15 , Color(225,22,22), 1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				end

				local tpPos = LocalPlayer().strifeTpPos or nil
				if tpPos and LocalPlayer():GetNWBool("IsSetTypeForTp", false) then
					local pos = tpPos:ToScreen()
					pos.x = math.Clamp(pos.x, 32, ScrW() - 32)
					pos.y = math.Clamp(pos.y, 32, ScrH() - 32)
					surface.SetDrawColor(Color(0, 40, 240, 255))
					surface.SetMaterial(mat)
					surface.DrawTexturedRect(pos.x - 32, pos.y - 32, 64, 64)
					surface.SetDrawColor(Color(0, 40, 240, 255))
					surface.SetMaterial(mat2)
					surface.DrawTexturedRect(pos.x - 32, pos.y - 32, 64, 64)
				end

		end

		if ply:GetModel() == "models/konnie/asapgaming/destiny2/intrepidexploit.mdl" then
				local nextability = ply:GetNWBool("SurgeCD", 0)
				local timeremaining = nextability - CurTime()
				local canuse = timeremaining <= 0
				local mat = Material("vgui/suits/dd_iocn.png")
				surface.SetDrawColor(Color(255,0,0,100))
				surface.SetMaterial(mat)
				surface.DrawTexturedRect((ScrW() / 2.21) , ScreenScale(1000, true), ScreenScale(250), ScreenScale(250))

				if (timeremaining + 60) > 60 and ply:GetNWBool("SurgeCD", false) then			
					local pct = (100 / 20) 
					local fraction = (((timeremaining * pct) / 100))
					local tall = math.Round(math.Clamp(ScreenScale(250) * fraction, 0, ScreenScale(250)))
				
					surface.SetDrawColor(Color(255,255,255,255))
					surface.SetMaterial(mat)
					surface.DrawTexturedRectUV((ScrW() / 2.21) , (ScreenScale(1000, true)) - tall + ScreenScale(250), ScreenScale(250), tall, 0, (1 - fraction), 1, 1)
				elseif (timeremaining + 60) > 60 and !ply:GetNWBool("SurgeCD", false) then	
					surface.SetDrawColor(Color(255,0,0,155))
					surface.SetMaterial(mat)
					surface.DrawTexturedRect((ScrW() / 2.21) , ScreenScale(1000, true), ScreenScale(250), ScreenScale(250))
				elseif (timeremaining + 60) < 60 and (timeremaining + 60) > 0 then
					local pct = (100 / 60) 
					local fraction = 1 - ((((timeremaining + 60) * pct) / 100))
					local tall = math.Round(math.Clamp(ScreenScale(250) * fraction, 0, ScreenScale(250)))
				
					surface.SetDrawColor(Color(255,255,255,255))
					surface.SetMaterial(mat)
					surface.DrawTexturedRectUV((ScrW() / 2.21) , (ScreenScale(1000, true)) - tall + ScreenScale(250), ScreenScale(250), tall, 0, (1 - fraction), 1, 1)
				else
					surface.SetDrawColor(Color(255,255,255, 255))
					surface.SetMaterial(mat)
					surface.DrawTexturedRect((ScrW() / 2.21) , ScreenScale(1000, true), ScreenScale(250), ScreenScale(250))
					draw.SimpleText("["..string.upper( input.LookupBinding("gm_showspare1")).."]", "TTName", w / 2 , ScrH()/1.315 + 20 + 2, Color(40,40,40,235), 1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
					draw.SimpleText("["..string.upper( input.LookupBinding("gm_showspare1")).."]", "TTName", w / 2 , ScrH()/1.315 + 20, Color(225,225,225), 1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				end
		end


		if ply:GetModel() == "models/konnie/asapgaming/destiny2/crushingset.mdl" then 
				local nextability = ply:GetNWBool("SurgeCD", 0)
				local timeremaining = nextability - CurTime()
				local canuse = timeremaining <= 0
				local mat = Material("hud/qba/timerush.png")
				local mat2 = Material("hud/qba/timedodge.png")
			
				if canuse then
					surface.SetDrawColor(Color(0,255,0, 255))
					surface.SetMaterial(mat)
					surface.DrawTexturedRectRotated((ScrW() / 1.995) , ScreenScale(1200, true), ScreenScale(500), ScreenScale(500),-180)
					draw.SimpleText("["..string.upper( input.LookupBinding("gm_showspare1")).."]", "TTName", w / 2 , ScrH()/1.205 + 2, Color(40,40,40,235), 1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
					draw.SimpleText("["..string.upper( input.LookupBinding("gm_showspare1")).."]", "TTName", w / 2 , ScrH()/1.205 , Color(225,225,225), 1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				else
					surface.SetDrawColor(Color(255,0,0,255))
					surface.SetMaterial(mat)
					surface.DrawTexturedRectRotated((ScrW() / 1.995) , ScreenScale(1200, true), ScreenScale(500), ScreenScale(500),-180)
					draw.SimpleText("["..math.Round(timeremaining, 1).."]", "TTName", w / 2 , ScrH()/1.205  + 2, Color(40,40,40,235), 1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
					draw.SimpleText("["..math.Round(timeremaining, 1).."]", "TTName", w / 2 , ScrH()/1.205 , Color(225,225,225), 1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				end
				local warpcount = ply:GetNWInt("warpCount", 0)
				for i = 1,3 do
					if warpcount > i - 1 then
						surface.SetDrawColor(Color(0,255,0, 255))
					else
						surface.SetDrawColor(Color(255,0,0, 255))
					end
					surface.SetMaterial(mat2)
					local xpos
					if i == 1 then
						xpos = (ScrW() / 2.12) - ScreenScale(200)
					elseif i == 2 then
						xpos = (ScrW() / 2.12)
					elseif i == 3 then
						xpos = (ScrW() / 2.12) + ScreenScale(200)
					end
					surface.DrawTexturedRect(xpos , ScreenScale(50, true), ScreenScale(150), ScreenScale(150))
				end
		end

		if ply:GetModel() == "models/konnie/asapgaming/destiny2/gardenofsalvation.mdl" then 
				local nextability = ply:GetNWBool("RiftCD", 0)
				local timeremaining = nextability - CurTime()
				local canuse = timeremaining <= 0
				local mat = Material("hud/qba/timestop.png")
			
			if canuse then
				surface.SetDrawColor(Color(0,255,0, 255))
				surface.SetMaterial(mat)
				surface.DrawTexturedRectRotated((ScrW() / 1.995) , ScreenScale(1200, true), ScreenScale(500), ScreenScale(500),-180)
				draw.SimpleText("["..string.upper( input.LookupBinding("gm_showspare1")).."]", "TTName", w / 2 , ScrH()/1.205 + 2, Color(40,40,40,235), 1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				draw.SimpleText("["..string.upper( input.LookupBinding("gm_showspare1")).."]", "TTName", w / 2 , ScrH()/1.205 , Color(225,225,225), 1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			else
				surface.SetDrawColor(Color(255,0,0,255))
				surface.SetMaterial(mat)
				surface.DrawTexturedRectRotated((ScrW() / 1.995) , ScreenScale(1200, true), ScreenScale(500), ScreenScale(500),-180)
				draw.SimpleText("["..math.Round(timeremaining, 1).."]", "TTName", w / 2 , ScrH()/1.205 + 2, Color(40,40,40,235), 1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				draw.SimpleText("["..math.Round(timeremaining, 1).."]", "TTName", w / 2 , ScrH()/1.205 , Color(225,225,225), 1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
		end

		if ply:GetModel() == "models/konnie/asapgaming/destiny2/futurefacing.mdl" then 
				local nextability = ply:GetNWBool("EmpCD", 0)
				local timeremaining = nextability - CurTime()
				local canuse = timeremaining <= 0
				local mat = Material("hud/qba/timeblast.png")
			
				if canuse then
					surface.SetDrawColor(Color(0,155,155, 255))
					surface.SetMaterial(mat)
					surface.DrawTexturedRectRotated((ScrW() / 1.995) , ScreenScale(1200, true), ScreenScale(500), ScreenScale(500),-180)
					draw.SimpleText("["..string.upper( input.LookupBinding("gm_showspare1")).."]", "TTName", w / 2 , ScrH()/1.205 + 2, Color(40,40,40,235), 1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
					draw.SimpleText("["..string.upper( input.LookupBinding("gm_showspare1")).."]", "TTName", w / 2 , ScrH()/1.205 , Color(225,225,225), 1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				else
					surface.SetDrawColor(Color(255,0,0,255))
					surface.SetMaterial(mat)
					surface.DrawTexturedRectRotated((ScrW() / 1.995) , ScreenScale(1200, true), ScreenScale(500), ScreenScale(500),-180)
					draw.SimpleText("["..math.Round(timeremaining, 1).."]", "TTName", w / 2 , ScrH()/1.205 + 2, Color(40,40,40,235), 1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
					draw.SimpleText("["..math.Round(timeremaining, 1).."]", "TTName", w / 2 , ScrH()/1.205 , Color(225,225,225), 1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				end
		end

		if ply:GetModel() == "models/konnie/asapgaming/destiny2/gardenofsalvation_titan.mdl" then 
			local inuse = ply:GetNWBool("DivineIsHealing", false)
			local mat = Material("hud/qba/timeshield.png")
		
			if inuse then
				surface.SetDrawColor(Color(255,255,75, 255))
				surface.SetMaterial(mat)
				surface.DrawTexturedRectRotated((ScrW() / 1.995) , ScreenScale(1200, true), ScreenScale(500), ScreenScale(500),-180)
			else
				surface.SetDrawColor(Color(0,0,0,155))
				surface.SetMaterial(mat)
				surface.DrawTexturedRectRotated((ScrW() / 1.995) , ScreenScale(1200, true), ScreenScale(500), ScreenScale(500),-180)
				draw.SimpleText("["..string.upper( input.LookupBinding("+walk") or "alt").."]", "TTName", w / 2 , ScrH()/1.205 + 2, Color(40,40,40,235), 1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				draw.SimpleText("["..string.upper( input.LookupBinding("+walk") or "alt").."]", "TTName", w / 2 , ScrH()/1.205 , Color(225,225,225), 1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
	end

	if (LocalPlayer():GetModel() == "models/gonzo/skullsilverjuggernaut/skullsilverjuggernaut.mdl") or (LocalPlayer():GetModel() == "models/nanosuit/nanosuit_male_playermodel.mdl") then
		local lowhealth = (LocalPlayer():Health() <= LocalPlayer():GetMaxHealth() / 2 and LocalPlayer():Health() > LocalPlayer():GetMaxHealth() / 5 )
		local criticalhealth = (LocalPlayer():Health() <= LocalPlayer():GetMaxHealth() / 5)
		if lowhealth and LocalPlayer():Alive() and not LocalPlayer().HeardWarning then
			surface.PlaySound("HL1/fvox/health_critical.wav")
			LocalPlayer().HeardWarning = true 
			timer.Simple(10, function()
				LocalPlayer().HeardWarning = false
			end)
		end



		if criticalhealth and (not LocalPlayer().CritHealthAlarm or LocalPlayer().CritHealthAlarm:GetVolume() <= 0) and LocalPlayer():Alive() then
			LocalPlayer().CritHealthAlarm = CreateSound(LocalPlayer(), "npc/turret_floor/alarm.wav")
			LocalPlayer().CritHealthAlarm:Play()
			LocalPlayer().CritHealthAlarm:ChangeVolume( 0.5, 1 ) 
		elseif not criticalhealth and LocalPlayer().CritHealthAlarm then
			LocalPlayer().CritHealthAlarm:FadeOut(1)
		end

		
		if !lowhealth and !criticalhealth then
			draw.SimpleText( "STATUS - FINE", "TTBig", ScrW() / 2, 100, Color(50 + math.sin(RealTime() * 2) * 50,250 + math.sin(RealTime() * 2) * 50,0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end

		if lowhealth then
			draw.SimpleText( "STATUS - DAMAGED", "TTBig", ScrW() / 2, 100, Color(250 + math.sin(RealTime() * 2) * 50,50 + math.sin(RealTime() * 2) * 50,0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			draw.RoundedBox( 0, 0, 0, w, h, Color(250 + math.sin(RealTime() * 2) * 50,50 + math.sin(RealTime() * 2) * 50,0,50) )
		end

		if criticalhealth then
			draw.SimpleText( "STATUS - CRITICAL", "TTBig", ScrW() / 2, 100, Color(250 + math.sin(RealTime() * 5) * 50,10 + math.sin(RealTime() * 5) * 50,0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			draw.RoundedBox( 0, 0, 0, w, h, Color(255 + math.sin(RealTime() *5) * 50,10 + math.sin(RealTime() * 5) * 50,0,100) )
		end

		
	elseif LocalPlayer().CritHealthAlarm then LocalPlayer().CritHealthAlarm:Stop() LocalPlayer().CritHealthAlarm = nil end

	if (LocalPlayer():GetModel() == "models/gonzo/skullsilverjuggernaut/skullsilverjuggernaut.mdl") then
				local rocketout = false
				local wep = LocalPlayer():GetActiveWeapon()
				if IsValid(wep) and wep:GetClass() == "tfa_cso_m2_devastator" then
					rocketout = true
				else
					rocketout = false
				end
				local mat = Material("vgui/suits/rocket_icon.png")
				surface.SetDrawColor(Color(255,0,0,100))
				surface.SetMaterial(mat)
				surface.DrawTexturedRect((ScrW() / 2.21) , ScreenScale(1000, true), ScreenScale(250), ScreenScale(250))
				if rocketout then 
					local nextability = ply:GetNWBool("RocketCD", 0)
					local timeremaining = nextability - CurTime()
					local canuse = timeremaining <= 0
			
					if canuse then
						surface.SetDrawColor(Color(0,0,0, 255))
						surface.SetMaterial(mat)
						surface.DrawTexturedRect((ScrW() / 2.21) , ScreenScale(1000, true), ScreenScale(250), ScreenScale(250))
						draw.SimpleText("["..string.upper( input.LookupBinding("gm_showspare1")).."]", "TTName", w / 2 , ScrH()/1.315 + 20 + 2, Color(40,40,40,235), 1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
						draw.SimpleText("["..string.upper( input.LookupBinding("gm_showspare1")).."]", "TTName", w / 2 , ScrH()/1.315 + 20, Color(225,225,225), 1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
					else
						local pct = (100 / 3) 
						local fraction = 1 - (((timeremaining * pct) / 100))
						local tall = math.Round(math.Clamp(ScreenScale(250) * fraction, 0, ScreenScale(250)))
				
						surface.SetDrawColor(Color(255,255,255,255))
						surface.SetMaterial(mat)
						surface.DrawTexturedRectUV((ScrW() / 2.21) , (ScreenScale(1000, true)) - tall + ScreenScale(250), ScreenScale(250), tall, 0, (1 - fraction), 1, 1)
					end
				end
	end

end)
net.Receive( "SentStrifeTp", function( len, ply )
	LocalPlayer().strifeTpPos = net.ReadVector()
end)
net.Receive( "RemoveStrifeTp", function( len, ply )
	LocalPlayer().strifeTpPos = nil
end)

hook.Add( "PlayerFootstep", "Suit_Footstep", function( ply, pos, foot, sound, volume, rf )

	if ply:GetModel() == "models/gonzo/skullsilverjuggernaut/skullsilverjuggernaut.mdl" then
		local step = math.random(1,2)
		if step == 1 then
			ply:EmitSound("nemesis/jugstep1.wav", 40, 70 )
		elseif step == 2 then
			ply:EmitSound("nemesis/jugstep2.wav", 40, 70 )
		end
		return true
	end

	if ply:GetModel() == "models/konnie/asapgaming/destiny2/antiextinction.mdl" then
		local step = math.random(1,2)
		if step == 1 then
			ply:EmitSound("nemesis/jugstep1.wav", 40, 225 )
		elseif step == 2 then
			ply:EmitSound("nemesis/jugstep2.wav", 40, 225 )
		end
		return true
	end

	if ply:GetModel() == "models/nanosuit/nanosuit_male_playermodel.mdl" then
		local step = math.random(1,2)
		if step == 1 then
			ply:EmitSound("nemesis/jugstep1.wav", 40, 170 )
		elseif step == 2 then
			ply:EmitSound("nemesis/jugstep2.wav", 40, 170 )
		end
		return true
	end

	if ply.rifted then
		ply:EmitSound("nemesis/jugstep1.wav", 0, 0 )
		return true
	end

	return false	
end)


--sv

hook.Add( "GetFallDamage", "No_Fall", function( ply, speed )
	if ply.SuitOn then
    		return 0
	else
		return speed/100
	end
end)

hook.Add( "OnPlayerChangedTeam", "Suit_Dequip_On_Team_Change", function( ply, bef, aft )
	if ply.SuitOn then
		Inventory_DequipSuit(ply,ply.SuitType)
	end
end)

hook.Add( "playerArrested", "Suit_Equip_On_Arrest", function( ply, time, att )
	if ply.SuitOn then
		timer.Simple(.1, function()
			Inventory_EquipSuit(ply,ply.SuitType)
		end)
	end
end)

hook.Add( "playerUnArrested", "Suit_Equip_On_Unarrest", function( ply, att )
	if ply.SuitOn then
		timer.Simple(.1, function()
			Inventory_EquipSuit(ply,ply.SuitType)
		end)
	end
end)





hook.Add("PlayerBindPress","PlayerBindPress_SuitKeys",function(ply,bind,pressed)
	if bind == "gm_showspare1" and pressed then
		if ply:GetModel() == "models/timeshift/beta_suit.mdl" then 
			ply:ConCommand("speedboost")
		elseif ply:GetModel() == "models/nanosuit/nanosuit_male_playermodel.mdl" then 
			ply:ConCommand("nanocloak")
		elseif ply:GetModel() == "models/arachnit/wolfenstein2/powerarmor/powerarmor_player.mdl" then
			ply:ConCommand("quantumsheild")
		elseif ply:GetModel() == "models/konnie/asapgaming/destiny2/intrepidexploit.mdl" then
			ply:ConCommand("damagesurge")
		elseif ply:GetModel() == "models/konnie/asapgaming/destiny2/exigent.mdl" then
			ply:ConCommand("strifeteleport")
		elseif ply:GetModel() == "models/konnie/asapgaming/destiny2/crushingset.mdl" then
			ply:ConCommand("reverierollback")
		elseif ply:GetModel() == "models/gonzo/skullsilverjuggernaut/skullsilverjuggernaut.mdl" then
			ply:ConCommand("jugrocket")
		elseif ply:GetModel() == "models/konnie/asapgaming/destiny2/gardenofsalvation.mdl" then
			ply:ConCommand("riftshift")
		elseif ply:GetModel() == "models/konnie/asapgaming/destiny2/futurefacing.mdl" then
			ply:ConCommand("empsuitactivate")
		end
	end
end)


local matHeatWave = Material( "sprites/heatwave" )
local matFire = Material( "effects/fire_cloud1" )
local seed = math.Rand( 0, 10000 )
local SmokePos = {}
SmokePos[1] = {Vector(-2.269, -13.456, -9.63),Angle(-92.6,-5.1,39.1)}
SmokePos[2] = {Vector(-2.269, -13.456, 9.311),Angle(-92.6,-5.1,39.1)}
local CurrentScale = 0
hook.Add( "PostDrawTranslucentRenderables", "Suit_TransRenderabels", function( BD, BS )
	for k,v in pairs(player.GetAll()) do
		if v:GetModel() == "models/gonzo/skullsilverjuggernaut/skullsilverjuggernaut.mdl" then		
			for l,m in ipairs(SmokePos) do
				local self = v
				local bone = self:LookupBone("ValveBiped.Bip01_Spine2")
				if !bone then return end
				local bonepos,boneang = self:GetBonePosition(bone)
				local vOffset,vAngle = LocalToWorld(m[1], m[2], bonepos, boneang )
				local vNormal = Vector(0,0,-1)
				local scroll = seed + ( CurTime() * -10 )
				if v:OnGround() then
					CurrentScale = math.Approach(CurrentScale, 0, FrameTime() * 0.3)
				elseif !v:OnGround() then
					CurrentScale = math.Approach(CurrentScale, 0.2, FrameTime() * 0.3)
				end
				local Scale = CurrentScale
				for i=1,2 do
				render.SetMaterial( matFire )
				render.StartBeam( 3 )
					render.AddBeam( vOffset, 8 * Scale, scroll, Color( 0, 0, 255, 128 ) )
					render.AddBeam( vOffset + vNormal * 60 * Scale, 32 * Scale, scroll + 1, Color( 255, 255, 255, 128 ) )
					render.AddBeam( vOffset + vNormal * 148 * Scale, 32 * Scale, scroll + 3, Color( 255, 255, 255, 0 ) )
				render.EndBeam()
				scroll = scroll * 0.5
				render.UpdateRefractTexture()
				render.SetMaterial( matHeatWave )
				render.StartBeam( 3 )
					render.AddBeam( vOffset, 8 * Scale, scroll, Color( 0, 0, 255, 128 ) )
					render.AddBeam( vOffset + vNormal * 32 * Scale, 32 * Scale, scroll + 2, Color( 255, 255, 255, 255 ) )
					render.AddBeam( vOffset + vNormal * 128 * Scale, 48 * Scale, scroll + 5, Color( 0, 0, 0, 0 ) )
				render.EndBeam()
				scroll = scroll * 1.3
				render.SetMaterial( matFire )
				render.StartBeam( 3 )
					render.AddBeam( vOffset, 8 * Scale, scroll, Color( 0, 0, 255, 128) )
					render.AddBeam( vOffset + vNormal * 60 * Scale, 16 * Scale, scroll + 1, Color( 255, 255, 255, 128 ) )
					render.AddBeam( vOffset + vNormal * 148 * Scale, 16 * Scale, scroll + 3, Color( 255, 255, 255, 0 ) )
				render.EndBeam()
				end
			end
		end
	end
end)

if CLIENT then
    local EFFECT = {}

    function EFFECT:Init(ed)
        local vOrig = ed:GetOrigin()
        self.Emitter = ParticleEmitter(vOrig)

        for i = 1, 100 do
            local smoke = self.Emitter:Add("particle/particle_smokegrenade", vOrig)

            if (smoke) then
                smoke:SetColor(25, 125, 200)
                smoke:SetVelocity(VectorRand():GetNormal() * math.random(100, 150))
                smoke:SetRoll(math.Rand(0, 360))
                smoke:SetRollDelta(math.Rand(-2, 2))
                smoke:SetDieTime(4)
                smoke:SetLifeTime(0)
                smoke:SetStartSize(50)
                smoke:SetStartAlpha(255)
                smoke:SetEndSize(100)
                smoke:SetEndAlpha(0)
                smoke:SetGravity(Vector(0, 0, 0))
            end

            local smoke2 = self.Emitter:Add("particle/particle_smokegrenade", vOrig)

            if (smoke2) then
                smoke2:SetColor(25, 125, 200)
                smoke2:SetVelocity(VectorRand():GetNormal() * math.random(75, 100))
                smoke2:SetRoll(math.Rand(0, 360))
                smoke2:SetRollDelta(math.Rand(-2, 2))
                smoke2:SetDieTime(16)
                smoke2:SetLifeTime(0)
                smoke:SetStartSize(50)
                smoke:SetStartAlpha(255)
                smoke:SetEndSize(100)
                smoke2:SetEndAlpha(0)
                smoke2:SetGravity(Vector(0, 0, 0))
            end

            local smoke3 = self.Emitter:Add("particle/particle_smokegrenade", vOrig + Vector(math.random(-150, 150), math.random(-150, 150), 0))

            if (smoke3) then
                smoke3:SetColor(25, 125, 200)
                smoke3:SetVelocity(VectorRand():GetNormal() * math.random(50, 75))
                smoke3:SetRoll(math.Rand(0, 360))
                smoke3:SetRollDelta(math.Rand(-2, 2))
                smoke3:SetDieTime(16)
                smoke3:SetLifeTime(0)
                smoke:SetStartSize(50)
                smoke:SetStartAlpha(255)
                smoke:SetEndSize(100)
                smoke3:SetEndAlpha(0)
                smoke3:SetGravity(Vector(0, 0, 0))
            end

            local heat = self.Emitter:Add("sprites/heatwave", vOrig + Vector(math.random(-150, 150), math.random(-150, 150), 0))

            if (heat) then
                heat:SetColor(0, 25, 50)
                heat:SetVelocity(VectorRand():GetNormal() * math.random(50, 100))
                heat:SetRoll(math.Rand(0, 360))
                heat:SetRollDelta(math.Rand(-2, 2))
                heat:SetDieTime(3)
                heat:SetLifeTime(0)
                heat:SetStartSize(100)
                heat:SetStartAlpha(255)
                heat:SetEndSize(0)
                heat:SetEndAlpha(0)
                heat:SetGravity(Vector(0, 0, 0))
            end
        end

        for i = 1, 72 do
            local sparks = self.Emitter:Add("effects/spark", vOrig)

            if (sparks) then
                sparks:SetColor(0, 200, 255)
                sparks:SetVelocity(VectorRand():GetNormal() * math.random(300, 500))
                sparks:SetRoll(math.Rand(0, 360))
                sparks:SetRollDelta(math.Rand(-2, 2))
                sparks:SetDieTime(2)
                sparks:SetLifeTime(0)
                sparks:SetStartSize(6)
                sparks:SetStartAlpha(255)
                sparks:SetStartLength(15)
                sparks:SetEndLength(3)
                sparks:SetEndSize(6)
                sparks:SetEndAlpha(255)
                sparks:SetGravity(Vector(0, 0, -800))
            end

            local sparks2 = self.Emitter:Add("effects/spark", vOrig)

            if (sparks2) then
                sparks2:SetColor(0, 200, 255)
                sparks2:SetVelocity(VectorRand():GetNormal() * math.random(400, 800))
                sparks2:SetRoll(math.Rand(0, 360))
                sparks2:SetRollDelta(math.Rand(-2, 2))
                sparks2:SetDieTime(0.4)
                sparks2:SetLifeTime(0)
                sparks2:SetStartSize(10)
                sparks2:SetStartAlpha(255)
                sparks2:SetStartLength(80)
                sparks2:SetEndLength(0)
                sparks2:SetEndSize(10)
                sparks2:SetEndAlpha(0)
                sparks2:SetGravity(Vector(0, 0, 0))
            end
        end

        for i = 1, 8 do
            local flash = self.Emitter:Add("effects/combinemuzzle2_dark", vOrig)

            if (flash) then
                flash:SetColor(255, 255, 255)
                flash:SetVelocity(VectorRand():GetNormal() * math.random(10, 30))
                flash:SetRoll(math.Rand(0, 360))
                flash:SetDieTime(0.2)
                flash:SetLifeTime(0)
                flash:SetStartSize(300)
                flash:SetStartAlpha(255)
                flash:SetEndSize(400)
                flash:SetEndAlpha(0)
                flash:SetGravity(Vector(0, 0, 0))
            end

            local quake = self.Emitter:Add("effects/splashwake3", vOrig)

            if (quake) then
                quake:SetColor(0, 175, 255)
                quake:SetVelocity(VectorRand():GetNormal() * math.random(10, 30))
                quake:SetRoll(math.Rand(0, 360))
                quake:SetDieTime(0.2)
                quake:SetLifeTime(0)
                quake:SetStartSize(250)
                quake:SetStartAlpha(200)
                quake:SetEndSize(420)
                quake:SetEndAlpha(0)
                quake:SetGravity(Vector(0, 0, 0))
            end

            local wave = self.Emitter:Add("sprites/heatwave", vOrig)

            if (wave) then
                wave:SetColor(0, 175, 255)
                wave:SetVelocity(VectorRand():GetNormal() * math.random(10, 30))
                wave:SetRoll(math.Rand(0, 360))
                wave:SetDieTime(0.5)
                wave:SetLifeTime(0)
                quake:SetStartSize(250)
                quake:SetStartAlpha(255)
                quake:SetEndSize(420)
                wave:SetEndAlpha(0)
                wave:SetGravity(Vector(0, 0, 0))
            end
        end
    end

    function EFFECT:Think()
        return false
    end

    function EFFECT:Render()
    end

    effects.Register(EFFECT, "empsuitexplode", true)
end
local function DoEmpPlayer( ply )
	if !IsValid( ply ) then return end 
	if !ply:Alive() then return end
	if ply:GetModel() != "models/konnie/asapgaming/destiny2/futurefacing.mdl" then if ply.empModel then ply.empModel:Remove() end return end
	if !ply:GetNWBool("EmpOn", false) then return end	
        if !IsValid(ply.empModel) then
            ply.empModel = ClientsideModel("models/konnie/asapgaming/destiny2/futurefacing.mdl")
            ply.empModel:SetPos(ply:GetPos())
            ply.empModel:SetNoDraw(true)

            ply.empModel.RenderOverride = function(ent)
                if !IsValid(ply) then
                    ent:Remove()

                    return
                end

                render.SetBlend(1)

                render.SetColorModulation(0, .5, math.random(.5,1))
                ent:DrawModel()
                render.SetColorModulation(0, .5, math.random(.5,1))

                render.SetBlend(1)
            end

            local matrix = Matrix()
            matrix:Scale(Vector(1.01, 1.01, 1.01))
            ply.empModel:EnableMatrix("RenderMultiply", matrix)
            ply.empModel:SetMaterial("debug/debugdrawflat")
        else
	    ply.empModel:DrawModel()
            ply.empModel:SetMaterial("debug/debugdrawflat")
            ply.empModel:SetColor(Color(0, 255, 255))
            ply.empModel:SetPos(ply:GetPos() + VectorRand() * 1.35)
            ply.empModel:SetAngles(Angle(ply:GetAngles().x, ply:GetAngles().y, ply:GetAngles().z))
            ply.empModel:SetSequence(ply:GetSequence())
            ply.empModel:SetCycle(ply:GetCycle())
            ply.empModel:SetPoseParameter("move_x", ply:GetPoseParameter("move_x"))
            ply.empModel:SetPoseParameter("move_y", ply:GetPoseParameter("move_y"))
            ply.empModel:InvalidateBoneCache()
	end
end

hook.Add( "PostPlayerDraw", "DoEmpPlayer", DoEmpPlayer )

local function DoDivinePlayer( ply )
	if !IsValid( ply ) then return end 
	if !ply:Alive() then return end
	if ply:GetModel() != "models/konnie/asapgaming/destiny2/gardenofsalvation_titan.mdl" then if ply.divineModel then ply.divineModel:Remove() end return end
	if !ply:GetNWBool("DivineIsHealing", false) then return end	
        if !IsValid(ply.divineModel) then
            ply.divineModel = ClientsideModel("models/konnie/asapgaming/destiny2/gardenofsalvation_titan.mdl")
            ply.divineModel:SetPos(ply:GetPos())
            ply.divineModel:SetNoDraw(true)

            ply.divineModel.RenderOverride = function(ent)
                if !IsValid(ply) then
                    ent:Remove()

                    return
                end

                render.SetBlend(1)

                render.SetColorModulation(math.random(.75,1), math.random(7.5,1), .5)
                ent:DrawModel()
                render.SetColorModulation(math.random(.75,1), math.random(.75,1), .5)

                render.SetBlend(1)
            end

            local matrix = Matrix()
            matrix:Scale(Vector(1.1, 1.1, 1.1))
            ply.divineModel:EnableMatrix("RenderMultiply", matrix)
            ply.divineModel:SetMaterial("debug/debugdrawflat")
        else
	    ply.divineModel:DrawModel()
            ply.divineModel:SetMaterial("debug/debugdrawflat")
            ply.divineModel:SetColor(Color(255, 255, 155))
            ply.divineModel:SetPos(ply:GetPos())
            ply.divineModel:SetAngles(Angle(ply:GetAngles().x, ply:GetAngles().y, ply:GetAngles().z))
            ply.divineModel:SetSequence(ply:GetSequence())
            ply.divineModel:SetCycle(ply:GetCycle())
            ply.divineModel:SetPoseParameter("move_x", ply:GetPoseParameter("move_x"))
            ply.divineModel:SetPoseParameter("move_y", ply:GetPoseParameter("move_y"))
            ply.divineModel:InvalidateBoneCache()
	end
end

hook.Add( "PostPlayerDraw", "DoEmpPlayer", DoDivinePlayer )