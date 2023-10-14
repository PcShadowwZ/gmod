



AddCSLuaFile()



DEFINE_BASECLASS( 'base_anim' )



ENT.Editable = false

ENT.Spawnable = false

ENT.AdminOnly = false

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT



ENT.LifeTime	= 10

ENT.SpawnTime	= 0



ENT.StoredData	= {}

ENT.Delayed		= {}

ENT.StoredDamage = {}

ENT.LastEffect	= 0

ENT.Material = "models/wheatleymodels/qba/timefreeze_sphere"



ENT.LightColor = Color(0,38,153)

ENT.Damage = 500

ENT.SphereAmbientEffect = "qba_timefreeze_sphere"





local SIZE_STOP 	= 200

local SIZE_SHIELD	= 100



function ENT:Initialize()

	self.Mat = Material(self.Material)

	self:SetModel( 'models/wheatleymodels/qba/timefreeze.mdl' )

	self:SetMaterial(self.Material)

	self.SpawnTime = CurTime()

	self.LifeTime = self.LifeTime + CurTime()
	

	self.Size = ( self.AsShield ) and SIZE_SHIELD or SIZE_STOP

	self.Delay = CurTime() + 0.5

	self.AsShield = true

	self.StoredDamage = {}

	self.StoredData = {}

	

	if SERVER then

		self:SetNWBool( 'AsShield', true )

		


		self:EmitSound( 'quantumbreak/timeshield_cast.wav' )

		self.LoopSound = CreateSound( self, 'quantumbreak/timeshield_loop.wav' )

		if self.LoopSound then

			self.LoopSound:Play()

			self.LoopSound:ChangeVolume( 0 )

			timer.Simple( 0.7, function()

				if IsValid( self ) and self.LoopSound then

					self.LoopSound:ChangeVolume( 0.5, 0.5 )

				end

			end )

		end

		

		for i, v in ipairs( ents.FindInSphere( self:GetPos(), self.Size ) ) do

			if IsValid( v ) and v:GetClass() == 'prop_physics' then

				local phy = v:GetPhysicsObject()

				if IsValid( phy ) and phy:IsMotionEnabled() then

					phy:SetVelocity( ( v:GetPos() - self:GetPos() ):GetNormalized() * 300 )

					table.insert( self.Delayed, v )

				end

			end

		end

	end

	self:SetNWInt( 'BulletsStacked', 0 )

	

	if CLIENT then

		self:SetRenderBounds( -Vector( 110, 110, 110 ), Vector( 110, 110, 110 ) )



		local scale = 5

		

		local size = 0



		local c_mdl = ClientsideModel( 'models/wheatleymodels/qba/timefreeze.mdl' )

		c_mdl:SetPos( self:GetPos() )

		c_mdl:SetParent( self )

		c_mdl:SetNoDraw( true )

		c_mdl:SetSolid( SOLID_NONE )

		c_mdl:SetMaterial(self.Material)

		c_mdl:SetModelScale( 2, 0 ) 

		c_mdl.Owner = self

		c_mdl:Spawn()

		//c_mdl:SetColor(Color(0,38,153,255))

		self.Sphere = c_mdl

		

		local mat = Matrix()

		mat:SetScale( Vector( 1, 1, 1 ) )

		self.Sphere:EnableMatrix( 'RenderMultiply', mat )

		self.StackPercentage = 0

	end

end



function ENT:OnRemove()

	if self.LoopSound then

		self.LoopSound:Stop()

	end

	

	if IsValid( self.Sphere ) then

		self.Sphere:Remove()

	end

	

	if IsValid(self:GetOwner()) then		
		self:GetOwner().bubbleSheild = nil
		self:GetOwner().shieldCd = CurTime() + 40
		self:GetOwner():SetNWBool("ShieldCD", CurTime())
	end

	

end



function ENT:BulletImpact( pos, ammo )

	local ed = EffectData()

	ed:SetEntity( self )

	ed:SetAngles( ( pos - self:GetPos() ):Angle() )

	ed:SetMagnitude( ( ammo && ammo == 'AR2' ) and 2 or 1 )

	ed:SetOrigin( pos )

	util.Effect( 'qba_timeshield_bulletimpact', ed )

	

	local normal = ( pos - self:GetPos() ):GetNormalized()

	

	//QB_CreateBulletImpactEffect( pos, normal + VectorRand() * 5 )

end



function ENT:Draw()

	local bullets = self:GetNWInt( 'BulletsStacked' )

	local shield = self:GetNWBool( 'AsShield' )

	

	self:DestroyShadow()

	

	self.StackPercentage = math.Approach( self.StackPercentage or 0, math.min( bullets, 10 ) / 10, RealFrameTime() )



	if !self.IsGolden then

		self.Mat:SetVector( '$refracttint', LerpVector( self.StackPercentage, Vector( 1, 1.08, 1.62 ), Vector( 2.62, 1.08, 1 ) ) )

		if shield then

			self.Mat:SetFloat( '$refractamount', 0.03 )

		else

			self.Mat:SetFloat( '$refractamount', Lerp( self.StackPercentage, 0.005, 0.05 ) )

		end

		

		self.Mat:SetFloat( '$scrollRate', Lerp( self.StackPercentage, 0.003, 0.0035 ) )

	end

	

	if IsValid(self.Sphere) then

		if self.IsGolden then self.Sphere:SetMaterial("models/wheatleymodels/qba/timefreeze_sphere_gold") end

		self.Sphere:DrawModel()

	end

	

	//if shield then return end

	

	if bullets > 0 then

		local dlight = DynamicLight( self:EntIndex() )

		if ( dlight ) then

			dlight.pos = self:GetPos()

			dlight.r = 255

			dlight.g = 136

			dlight.b = 0

			dlight.brightness = self.StackPercentage * 3.6

			dlight.Decay = 1000

			dlight.Size = self.StackPercentage * 400

			dlight.DieTime = CurTime() + 0.1

		end

	end



	local dlight_white = DynamicLight( self:EntIndex() + 1 )

	if ( dlight_white ) then

		dlight_white.pos = self:GetPos()

		dlight_white.r = self.LightColor.r

		dlight_white.g = self.LightColor.g

		dlight_white.b = self.LightColor.b

		dlight_white.brightness = math.random( 1.5, 1.6 ) * ( 1 - self.StackPercentage )

		dlight_white.Decay = 1000

		dlight_white.Size = 200

		dlight_white.DieTime = CurTime() + 0.1

	end

end



function ENT:Blowup()




		for i, v in pairs( self.StoredData ) do

			if IsValid( i ) then

				v.TimeBubbleENT = nil

				if v.isplayer then

					i:SetMoveType( v.mv )

					i:Freeze( false )

					i:SetVelocity( v.vel )

				elseif v.isnpc then

					i.NextAllowedFreeze = CurTime() + 0.11

					i:SetCondition( 68 )

						

					i:SetMoveType( v.movetype )

					

					if i:GetClass() == 'npc_rollermine' or i:GetClass() == 'npc_manhack' or i:GetClass() == 'npc_clawscanner' or i:GetClass() == 'npc_cscanner' then

						local phy = i:GetPhysicsObject()

						if IsValid( phy ) then

							phy:EnableMotion( true )

						end

					end

						

					if i:GetClass() == 'npc_turret_floor' then

						i:SetSaveValue( 'm_bEnabled', true )

					end

				elseif v.isrpgmissile then

					i:SetMoveType( MOVETYPE_FLYGRAVITY )

				elseif v.iscball then

					i:SetMoveType( MOVETYPE_VPHYSICS )

					local phy = i:GetPhysicsObject()

					if IsValid( phy ) then

						phy:EnableMotion( true )

						phy:SetVelocity( v.vel )

					end

					timer.Create( 'cball_' .. tostring( i:EntIndex() ) .. '_explode', 3, 1, function()

						if IsValid( i ) then

							i:Fire( 'Explode' )

						end

					end )

				elseif v.isdoll then

					for c = 0, i:GetPhysicsObjectCount() - 1 do

						local phy = i:GetPhysicsObjectNum( c )

						if IsValid( phy ) then

							//phy:EnableMotion( true )

							if v.mv and v.mv[ c ] then

								phy:EnableMotion( v.mv[ c ] )

								phy:Wake()

							end

							if v.vel and v.vel[ c ] then

								phy:SetVelocity( v.vel[ c ] )

							end

						end

					end

				else

					timer.Simple( 0.07, function()

						if IsValid( i ) then

							i:SetHealth( v.health )

							if IsValid( v.phy ) then

								v.phy:EnableMotion( v.wasmotionenabled )

								

								if v.vel then v.phy:SetVelocity( v.vel ) end

								if v.avel then v.phy:AddAngleVelocity( v.avel ) end

							end

							if v.vel then

								i:SetVelocity( v.vel )

							end

						end

					end )

				end

			end

		end

	

	local damageReplica = table.Copy( self.StoredDamage )

	timer.Simple( 0.25, function()

		for i, v in pairs( damageReplica ) do

			if IsValid( v.ent ) and v.bubble == self then

				local dmg = DamageInfo()

				if IsValid( v.inf ) then dmg:SetInflictor( v.inf ) end

				if IsValid( v.atk ) then dmg:SetAttacker( v.atk ) end

				dmg:SetDamage( v.dmg )

				dmg:SetDamagePosition( v.pos )

				dmg:SetDamageType( v.typ )

				dmg:SetAmmoType( v.amm )

				dmg:SetDamageForce( v.frc )

				v.ent:TakeDamageInfo( dmg )

			end

		end

		

	end )

	

	self.StoredDamage = {}

	self.StoredData = {}

		

	local ed = EffectData()

	ed:SetOrigin( self:GetPos() )

	ed:SetScale( self:GetNWInt( 'BulletsStacked' ) )

	util.Effect( 'qba_timefreeze_sphere_explode', ed, true, true )

		

	if !self.AsShield then

		self:EmitSound( 'quantumbreak/timestop_collapse.wav' )

	else

		self:EmitSound( 'quantumbreak/timeshield_collapse.wav' )

	end

		

	self:Remove()

end



function ENT:Think()

	if CLIENT then // looking for client-side ragdolls

		if self:GetNWBool( 'AsShield' ) and (self.Delay or 0) > CurTime() then return end

		local sp = ents.FindInSphere( self:GetPos(), self.Size )

		for i, v in pairs( sp ) do

			if IsValid( v ) and v != self then

				if v:IsRagdoll() then

					if !self.StoredData[ v ] then

						local storedVelocities = {}

						for c = 0, v:GetPhysicsObjectCount() - 1 do

							local phy = v:GetPhysicsObjectNum( c )

							if IsValid( phy ) then

								storedVelocities[ c ] = phy:GetVelocity()

								phy:EnableMotion( false )

							end

						end

						self.StoredData[ v ] = { vel = storedVelocities, isdoll = true }

					end

				end

			end

		end

	end

	

	if SERVER then

		local sp = ents.FindInSphere( self:GetPos(), self.Size * 0.7 )

		

		if self.AsShield then

			if !IsValid( self:GetOwner() ) then

				self:Blowup(true)

				return

			else

				if self:GetOwner():GetPos():Distance( self:GetPos() ) > self.Size * 1.9 then

					self:Blowup(true)

					return

				end

			end

		end

		if IsValid(self:GetOwner()) then

			for k,v in pairs(sp) do		

				if (v:IsPlayer() or v:IsNPC()) and (v != self:GetOwner()) then

					local dmg = DamageInfo()

					dmg:SetAttacker(self:GetOwner())

					dmg:SetInflictor(self)

					dmg:SetDamageType(DMG_DISSOLVE)

					dmg:SetDamage(self.Damage)

					v:TakeDamageInfo(dmg)

				end

			end

		end

		

		if self.LastEffect < CurTime() then

			self.LastEffect = CurTime() + 0.1

			local ed = EffectData()

			ed:SetOrigin( self:GetPos() )

			ed:SetScale( self:GetNWInt( 'BulletsStacked' ) )

			ed:SetRadius( self.Size )

			util.Effect(self.SphereAmbientEffect, ed, true, true )

		end

	end

	
	if SERVER and self.LifeTime <= CurTime() then
		self:Blowup()
	end


end



if SERVER then

	local noDmgClasses = {

		'npc_turret_floor',

		'npc_strider',

		'npc_gunship',

		'npc_helicopter'

	}

	

	hook.Add( 'EntityTakeDamage', 'QBA_TIMESTOP_REGISTERDAMAGE', function( ent, dmg )

		if ent.TimeBubbleENT and !table.HasValue( noDmgClasses, ent:GetClass() ) then

			if ent.TimeBubbleENT.SpawnTime + ent.TimeBubbleENT.LifeTime <= CurTime() then return end

			

			local tb = { ent = ent, inf = dmg:GetInflictor(), atk = dmg:GetAttacker(), 

				dmg = dmg:GetDamage(), pos = dmg:GetDamagePosition(), typ = dmg:GetDamageType(), amm = dmg:GetAmmoType(),

				frc = dmg:GetDamageForce(), bubble = ent.TimeBubbleENT }



			if ent.TimeBubbleENT.StoredDamage and ent != ent.TimeBubbleENT:GetOwner() then

				table.insert( ent.TimeBubbleENT.StoredDamage, tb )

				dmg:ScaleDamage( 0 )

			end

			

			return true

		end

	end )

end

