function EFFECT:Init( fx )
	local size = math.min( fx:GetScale(), 10 ) / 10
	local sphereSize = fx:GetRadius() or 110

	local colorLerp = Color( Lerp( size, math.random( 60, 120 ), 255 ),
		Lerp( size, math.random( 170, 200 ), math.random( 145, 165 ) ),
		Lerp( size, 255, math.random( 60, 70 ) ) )
	
	local PE = ParticleEmitter( fx:GetOrigin() )
		for i = 1, 20 do
			local ptcl = PE:Add( 'effects/timefreeze_triangle', fx:GetOrigin() + VectorRand() * math.random( 0, sphereSize ) )
				ptcl:SetDieTime( math.random( 0.3, 1.2 ) )
				ptcl:SetStartAlpha( 0 )
				ptcl:SetEndAlpha( 255 )
				ptcl:SetRollDelta( math.random( -5, 5 ) )
				ptcl:SetGravity( Vector() )
				ptcl:SetCollide( true )
				ptcl:SetColor( colorLerp.r, colorLerp.g, colorLerp.b )
				ptcl:SetAirResistance( 0 )
				ptcl:SetStartSize( math.random( 2, 6 ) )
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