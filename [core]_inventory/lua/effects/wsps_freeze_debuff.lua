local matRefract = Material( "models/spawn_effect" )
local matLight	 = Material( "models/spawn_effect2" )
local matWhite	 = Material( "models/debug/debugwhite" )

--[[---------------------------------------------------------
   Initializes the effect. The data is a table of data 
   which was passed from the server.
-----------------------------------------------------------]]
function EFFECT:Init( data )
	self.LifeTime = CurTime() + 4
	
	local ent = data:GetEntity()

	if ( !IsValid( ent ) ) then return end
	if ( !ent:GetModel() ) then return end
	
	self.ParentEntity = ent
	self:SetModel( ent:GetModel() )	
	self:SetPos( ent:GetPos() )
	self:SetAngles( ent:GetAngles() )
	self:SetParent( ent )
	
	self.ParentEntity.RenderOverride = self.RenderParent
	self.ParentEntity.SpawnEffect = self
	self.RenderingAlpha = 0
	self.PE = ParticleEmitter( ent:GetPos() )
	self.NextThinkTime = CurTime() + 0.1
end


--[[---------------------------------------------------------
   THINK
   Returning false makes the entity die
-----------------------------------------------------------]]
function EFFECT:Think( )
	self.NextThinkTime = self.NextThinkTime or 0
	if self.NextThinkTime > CurTime() then return true end
	if ( !IsValid( self.ParentEntity ) ) then return false end
	
	local mins, maxs = self.ParentEntity:OBBMins(), self.ParentEntity:OBBMaxs()
	local ptcl = self.PE:Add( 'effects/wsps/wsps_flash', self.ParentEntity:GetPos() + Vector( math.random( mins.x, maxs.x ), math.random( mins.y, maxs.y ), math.random( mins.z, maxs.z ) ) )
		ptcl:SetDieTime( 2 )
		ptcl:SetStartAlpha( 100 )
		ptcl:SetRoll( math.random( 0, 360 ) )
		ptcl:SetGravity( Vector( 0, 0, -15 ) )
		ptcl:SetCollide( true )
		ptcl:SetAirResistance( 0 )
		ptcl:SetStartSize( 0 )
		ptcl:SetEndSize( 15 )
		ptcl:SetEndAlpha( 0 )
		ptcl:SetVelocityScale( true )
		ptcl:SetLighting( false )
	
	local PPos = self.ParentEntity:GetPos();
	self:SetPos( PPos + (EyePos() - PPos):GetNormal() )
	
	if ( self.ParentEntity:GetNWFloat( 'WSPS_FreezeDebuff' ) > CurTime() or self.LifeTime > CurTime() ) then
		self.LifeTime = self.ParentEntity:GetNWFloat( 'WSPS_FreezeDebuff' )
		return true
	end
	
	self.ParentEntity.RenderOverride = nil
	self.ParentEntity.SpawnEffect = nil
	
	return false
end

function EFFECT:Render()

end

--[[---------------------------------------------------------
   Draw the effect
-----------------------------------------------------------]]
function EFFECT:RenderOverlay( entity )
	if self.LifeTime > CurTime() then
		self.RenderingAlpha = math.Approach( self.RenderingAlpha, 1, FrameTime() )
	end
		
	local Fraction = ( math.abs( math.sin( self.LifeTime - CurTime() ) ) * 0.2 ) * self.RenderingAlpha
	local ColFrac = (Fraction-0.5) * 2
	
	Fraction = math.Clamp( Fraction, 0, 1 )
	ColFrac =  math.Clamp( ColFrac, 0, 1 )

	local EyeNormal = entity:GetPos() - EyePos()
	local Distance = EyeNormal:Length()
	EyeNormal:Normalize()
	
	local Pos = EyePos() + EyeNormal * Distance * 0.01

	cam.Start3D( Pos, EyeAngles() )
		if ( render.GetDXLevel() >= 80 ) then
			render.UpdateRefractTexture()
			matRefract:SetFloat( "$refractamount", Fraction * 0.1 )
			render.MaterialOverride( matRefract )
				entity:DrawModel()
			render.MaterialOverride( 0 )
		end
	cam.End3D()
end


function EFFECT:RenderParent()
	local proc = 1 - math.Clamp( self.SpawnEffect.LifeTime - CurTime(), 0, 1 )
	render.SetColorModulation( ( 255 * proc ) / 255, ( 150 + 105 * proc ) / 255, 255 / 255 )
	self:DrawModel()
	render.SetColorModulation( 1, 1, 1 )
	
	self.SpawnEffect:RenderOverlay( self )

end