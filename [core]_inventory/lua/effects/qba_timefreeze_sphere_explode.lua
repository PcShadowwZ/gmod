function EFFECT:Init( fx )
	local PE = ParticleEmitter( fx:GetOrigin() )
		for i = 1, 15 do
			local pos = fx:GetOrigin() + VectorRand() * math.random( 35, 110 )
			local ptcl = PE:Add( 'effects/timefreeze_triangle', pos )
				ptcl:SetDieTime( math.random( 0.9, 1.2 ) )
				ptcl:SetStartAlpha( 0 )
				ptcl:SetEndAlpha( 255 )
				ptcl:SetRollDelta( math.random( -10, 10 ) )
				ptcl:SetGravity( Vector() )
				ptcl:SetCollide( true )
				ptcl:SetColor( math.random( 60, 120 ), math.random( 170, 200 ), 255 )
				ptcl:SetAirResistance( 0 )
				ptcl:SetStartSize( math.random( 2, 6 ) )
				ptcl:SetEndSize( 0 )
				ptcl:SetVelocityScale( true )
				ptcl:SetLighting( false )
				ptcl:SetVelocity( ( pos - fx:GetOrigin() ):GetNormalized() * 600 )
		end
		
		local wave_params = {
			['$dudvmap'] = 'effects/qba_shockwave_dudv',
			['$normalmap'] = 'effects/qba_shockwave_nrm',
			['$model'] = '1',
			['$refractamount'] = '.16',
			['$bluramount'] = '0',
			['$bumpframe'] = '0',
			['$translucent'] = '1',
			['$ignorez'] = '0',
			['$forcerefract'] = '1',
			['$nofog'] = '1',
			['$scale'] = '[1 1]'
		}
		
		local wave = CreateMaterial( 'timestop_explode_wave', 'Refract', wave_params )
		local wave_amount = 0.16
		if wave then
			wave:SetFloat( '$refractamount', wave_amount )
		end
		
		timer.Create( 'updaterefract_timestop_wave_' .. tostring( self ), 0.05, 6, function()
			wave_amount = wave_amount - 0.026
			if wave then
				wave:SetFloat( '$refractamount', wave_amount )
			end
		end )
		
		local wave = PE:Add( wave, fx:GetOrigin() )
		wave:SetDieTime( 0.4 )
		wave:SetStartAlpha( 255 )
		wave:SetEndAlpha( 0 )
		
		wave:SetStartSize( 150 )
		wave:SetEndSize( 260 )
		
		wave:SetGravity( Vector() )
		wave:SetColor( math.random( 60, 120 ), math.random( 170, 200 ), 255 )
		wave:SetLighting( false )

		local bludge_params = {
			['$dudvmap'] = 'effects/strider_bulge_dudv',
			['$normalmap'] = 'effects/strider_bulge_normal',
			['$refractamount'] = '.24',
			['$bluramount'] = '0',
			['$bumpframe'] = '0',
			['$translucent'] = '1',
			['$ignorez'] = '0',
			['$forcerefract'] = '1',
			['$nofog'] = '1',
			['$scale'] = '[1 1]'
		}

		local bludge = CreateMaterial( 'timestop_explode_bulge', 'Refract', bludge_params )
		local bludge_amount = 0.24
		if bludge then
			bludge:SetFloat( '$refractamount', bludge_amount )
		end
		
		timer.Create( 'updaterefract_timestop_bludge_' .. tostring( self ), 0.05, 6, function()
			bludge_amount = bludge_amount - 0.04
			if bludge then
				bludge:SetFloat( '$refractamount', bludge_amount )
			end
		end )
		
		local dudv = PE:Add( bludge, fx:GetOrigin() )
		dudv:SetDieTime( 0.5 )
		dudv:SetStartAlpha( 255 )
		dudv:SetEndAlpha( 0 )
		
		dudv:SetStartSize( 200 )
		dudv:SetEndSize( 360 )
		
		dudv:SetGravity( Vector() )
		dudv:SetColor( math.random( 60, 120 ), math.random( 170, 200 ), 255 )
		dudv:SetLighting( false )
	PE:Finish()
end

function EFFECT:Think()
end

function EFFECT:Render()
end