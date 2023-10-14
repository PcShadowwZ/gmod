function EFFECT:Init( fx )
	local ent = fx:GetEntity()
	if !IsValid( ent ) then return end

	local origin, omin, omax = ent:GetPos(), ent:OBBMins(), ent:OBBMaxs()
	
	local clr = Color( 255, 255, 255 )
	local PE = ParticleEmitter( origin )
		for i = 1, math.min( 50, ( omax - omin ):Length() / 4 ) do
			local rand = Vector( math.random( omin.x, omax.x ), math.random( omin.y, omax.y ), math.random( omin.z, omax.z ) )
			rand:Rotate( ent:GetAngles() )
			local spawnPos = origin + rand

			local screen = spawnPos:ToScreen()
			local r, g, b = render.ReadPixel( screen.x, screen.y )
			clr = Color( r, g, b )
			
			local ptcl = PE:Add( 'effects/timefreeze_triangle', spawnPos )
				ptcl:SetDieTime( math.random( 3, 12 ) / 10 )
				ptcl:SetStartAlpha( 0 )
				ptcl:SetEndAlpha( 255 )
				ptcl:SetRollDelta( math.random( -5, 5 ) )
				ptcl:SetGravity( Vector() )
				ptcl:SetCollide( true )
				ptcl:SetColor( clr.r, clr.g, clr.b )
				ptcl:SetAirResistance( 0 )
				ptcl:SetStartSize( math.random( 1, 3 ) )
				ptcl:SetEndSize( 0 )
				ptcl:SetVelocityScale( true )
				ptcl:SetLighting( false )
				ptcl:SetVelocity( -fx:GetAngles():Forward() + VectorRand() * math.random( 15, 35 ) )
		end
	PE:Finish()
end

function EFFECT:Think()
end

function EFFECT:Render()
end