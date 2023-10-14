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

		

local wave = CreateMaterial( 'qb_stutter_ground_wave', 'Refract', wave_params )



local life = 3

local lifeTime

function EFFECT:Init( fx )

	local owner = fx:GetEntity()

	local flags = fx:GetFlags()

	local fast = flags == 1

	lifeTime = life

	

	if fast then lifeTime = life / 4 end

	

	self.LifeTime = CurTime() + lifeTime

	local iteration = 1

	local delay = ( fast ) and 0.05 or 0.2

	timer.Create( 'qba_playerwave_particles', delay, ( fast ) and 10 or 15, function()

		local PE = ParticleEmitter( fx:GetOrigin() )

		for i = 1, 30 do

			local rand = VectorRand()

			rand.z = 0

			local spawnPos = fx:GetOrigin() + rand:GetNormalized() * ( 50 + ( fast and 20 or 10 ) * iteration )

			local tr = util.TraceLine( { start = spawnPos, endpos = spawnPos - Vector( 0, 0, 500 ) } )

			if tr.StartSolid then continue end

			spawnPos = tr.HitPos

			local screen = spawnPos:ToScreen()

			

			local ptcl = PE:Add( 'effects/timefreeze_triangle', spawnPos )

				ptcl:SetDieTime( ( fast ) and math.random( 0.15, 0.7 ) or math.random( 0.3, 1.2 ) )

				ptcl:SetStartAlpha( 255 )

				ptcl:SetEndAlpha( 0 )

				ptcl:SetRollDelta( math.random( -5, 5 ) )

				ptcl:SetGravity( Vector() )

				ptcl:SetCollide( true )

				ptcl:SetColor( 0,math.random(150,255), math.random(150,255))

				ptcl:SetAirResistance( 0 )

				ptcl:SetStartSize( math.random( 3, 6 ) )

				ptcl:SetEndSize( 0 )

				ptcl:SetVelocityScale( true )

				ptcl:SetLighting( false )

				ptcl:SetVelocity( VectorRand() * math.random( 15, 35 ) + Vector( 0, 0, ( fast ) and 200 or 50 ) )

		end

		iteration = iteration + 1

	end )

end



function EFFECT:Think()

	if !self.LifeTime || !lifeTime then return false end

	

	local frac = ( ( self.LifeTime - CurTime() ) / lifeTime )

	if self.LifeTime > CurTime() then

		return true

	end

	

	return false

end



function EFFECT:Render()

	if !self.LifeTime || !lifeTime then return false end

	

	local frac = 1 - ( ( self.LifeTime - CurTime() ) / lifeTime )

	//render.Clear( 0, 0, 0, 0, true, true )

	render.UpdateRefractTexture()

	local size = 400 * frac

	wave:SetFloat( '$refractamount', 0.5 * ( 1 - frac ) )

	render.SetMaterial( wave )

	cam.Start3D()

		render.DrawQuadEasy( self:GetPos() + Vector( 0, 0, 5 ), Vector( 0, 0, 1 ), size, size, Color( 255, 255, 255 ), 0 )

	cam.End3D()

end

