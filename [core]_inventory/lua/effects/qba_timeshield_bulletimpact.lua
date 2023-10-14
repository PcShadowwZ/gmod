EFFECT.Trails = {}
function EFFECT:AddTrail( start, dir, clr )
	for i = 0, math.random( 3, 6 ) do
		local prev = start
		local ang = dir:Angle()
		local startdir = math.random( 0, 1 ) == 1
		ang.y = math.random( -179, 179 )
		ang.r = math.random( -179, 179 )
		ang.p = ang.p + ( startdir and 25 or -25 )
		local length = math.random( 10, 40 )
		
		for i = 0, length do
			timer.Simple( ( i / length ) * 0.15, function()
				if self and self.Trails then
					local e = prev + ang:Forward() * 1 + VectorRand()
					
					table.insert( self.Trails, { lt = CurTime() + 0.15, size = 0, s = prev, e = e, clr = clr } )
					prev = e
					ang.p = ang.p + ( startdir and 2 or -2 )
				end
			end )
		end
	end
end

function EFFECT:Init( fx )
	local found = {}
	for i, v in pairs( ents.FindInSphere( fx:GetOrigin(), 6 ) ) do
		if IsValid( v ) and v:GetClass() == 'class CLuaEffect' and v != self then
			table.insert( found, v )
			if #found > 1 then
				found[1]:Remove()
				table.remove( found, 1 )
			end
		end
	end
	
	local size = math.min( fx:GetScale(), 10 ) / 10
	local dir = fx:GetAngles():Forward()
	local sphere = fx:GetEntity()
	
	local isAr2 = math.ceil( fx:GetMagnitude() ) == 2

	self:AddTrail( fx:GetOrigin(), dir, ( isAr2 ) and Color( 126, 160, 255 ) or nil )
	
	self.LifeTime = CurTime() + 0.5
	
	local PE = ParticleEmitter( fx:GetOrigin() )
		for i = 1, 10 do
			local ptcl = PE:Add( 'effects/timefreeze_triangle', fx:GetOrigin() )
				ptcl:SetDieTime( math.random( 0.3, 1.2 ) )
				ptcl:SetStartAlpha( 255 )
				ptcl:SetEndAlpha( 0 )
				ptcl:SetRollDelta( math.random( -5, 5 ) )
				ptcl:SetGravity( Vector() )
				ptcl:SetCollide( true )
				if isAr2 then
					ptcl:SetColor( 126, 160, 255 )
				else
					ptcl:SetColor( 255, 240, 100 )
				end
				ptcl:SetAirResistance( 0 )
				ptcl:SetStartSize( math.random( 1, 2 ) )
				ptcl:SetEndSize( 0 )
				ptcl:SetVelocityScale( true )
				ptcl:SetLighting( false )
				ptcl:SetVelocity( -fx:GetAngles():Forward() + VectorRand() * math.random( 45, 80 ) )
		end
	PE:Finish()
end

function EFFECT:Think()
	if self.LifeTime <= CurTime() then
		return false
	end
	
	return true
end

local mat = Material( 'trails/laser' )
function EFFECT:Render()
	if GetConVarNumber( 'cl_qb_drawhitbeams' ) == 0 then return end
	
	render.SetMaterial( mat )
	for i, v in pairs( self.Trails ) do
		if v.lt > CurTime() then
			v.size = math.Approach( v.size, 1, RealFrameTime() * 3 )
		else
			if v.size == 0 then
				table.remove( self.Trails, i )
				continue
			end

			v.size = math.Approach( v.size, 0, RealFrameTime() * 3 )
		end
		
		render.DrawBeam( v.s, v.e, v.size * 2, 0, 1, v.clr or Color( 255, 240, 100, 255 * v.size ) )
	end
end