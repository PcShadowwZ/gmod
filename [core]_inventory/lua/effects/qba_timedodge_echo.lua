local matRefract = Material( '!qbeffect_timedodgecopy' )

function EFFECT:Init( data )
	self.LifeTime = CurTime() + 0.25

	local ent = data:GetEntity()

	if ( !IsValid( ent ) ) then return end
	if ( !ent:GetModel() ) then return end

	self.ParentEntity = ent
	self:SetModel( ent:GetModel() )
	self:SetPos( ent:GetPos() )
	self:SetAngles( ent:GetAngles() )
	self:SetSequence( ent:GetSequence() )
	self:SetCycle( ent:GetCycle() )
	self:SetPlaybackRate( 0 )

	//self.ParentEntity.RenderOverride = self.RenderParent
	self.ParentEntity.SpawnEffect = self
end

function EFFECT:Think()
	if ( !IsValid( self.ParentEntity ) ) then return false end

	if ( self.LifeTime > CurTime() ) then
		return true
	end

	//self.ParentEntity.RenderOverride = nil
	self.ParentEntity.SpawnEffect = nil

	return false
end

function EFFECT:Render()
	local frac = ( self.LifeTime - CurTime() ) / 0.5
	
	if ( render.GetDXLevel() >= 80 ) then
		render.UpdateRefractTexture()

		matRefract:SetFloat( '$refractamount', frac * 0.25 )
		matRefract:SetFloat( '$alpha', frac )
		matRefract:SetVector( '$refracttint', Vector( 1, 1 + .08 * frac, 1 + 1 * frac ) )

		render.MaterialOverride( matRefract )
			self:DrawModel()
		render.MaterialOverride( 0 )
	end
end