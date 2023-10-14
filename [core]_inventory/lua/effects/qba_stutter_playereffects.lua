QBEFFECT_LAST_SCREEN_CAPTURE = QBEFFECT_LAST_SCREEN_CAPTURE or 0
function EFFECT:Init( fx )
	
	local size = fx:GetRadius()

	if QBEFFECT_LAST_SCREEN_CAPTURE < CurTime() then
		QBEFFECT_LAST_SCREEN_CAPTURE = CurTime() + 1
		render.CapturePixels()
	end
	
	local PE = ParticleEmitter( fx:GetOrigin() )
		for i = 1, 100 do
			local rand = VectorRand()
			rand.z = 0
			local spawnPos = fx:GetOrigin() + rand:GetNormalized() * math.random( size - size / 2, size )
			local tr = util.TraceLine( { start = fx:GetOrigin(), endpos = spawnPos, filter = player.GetAll() } )
			local trd = util.TraceLine( { start = tr.HitPos, endpos = tr.HitPos - Vector( 0, 0, 500 ), filter = player.GetAll() } )
			if trd.StartSolid then continue end
			spawnPos = trd.HitPos
			local screen = spawnPos:ToScreen()
			local r, g, b = render.ReadPixel( screen.x, screen.y )
			clr = Color( r, g, b )
			
			local ptcl = PE:Add( 'effects/timefreeze_triangle', spawnPos )
				ptcl:SetDieTime( math.random( 0.3, 1.2 ) )
				ptcl:SetStartAlpha( 0 )
				ptcl:SetEndAlpha( 255 )
				ptcl:SetRollDelta( math.random( -55, 55 ) )
				ptcl:SetGravity( Vector() )
				ptcl:SetCollide( true )
				ptcl:SetColor( math.random(55,155), math.random(155,255), math.random(155,255) )
				ptcl:SetAirResistance( 0 )
				ptcl:SetStartSize( math.random( 5, 15 ) )
				ptcl:SetEndSize( 0 )
				ptcl:SetVelocityScale( true )
				ptcl:SetLighting( false )
				ptcl:SetVelocity( VectorRand() * math.random( 150, 350 ) )
		end
	PE:Finish()
end

function EFFECT:Think()
end

function EFFECT:Render()
end