local matRefract = Material( "models/spawn_effect" )
local matLight	 = Material( "models/spawn_effect2" )

--[[---------------------------------------------------------
   Initializes the effect. The data is a table of data 
   which was passed from the server.
-----------------------------------------------------------]]
function EFFECT:Init( data )
	
	-- This is how long the spawn effect 
	-- takes from start to finish.
	self.Time = 8
	self.LifeTime = CurTime() + self.Time
	
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


end


--[[---------------------------------------------------------
   THINK
   Returning false makes the entity die
-----------------------------------------------------------]]
function EFFECT:Think( )

	if ( !IsValid( self.ParentEntity ) ) then return false end
	
	local PPos = self.ParentEntity:GetPos();
	self:SetPos( PPos + (EyePos() - PPos):GetNormal() )
	
	if ( self.ParentEntity:GetNWFloat( 'WSPS_DeformDebug' ) > CurTime() or self.LifeTime > CurTime() ) then
		self.LifeTime = self.ParentEntity:GetNWFloat( 'WSPS_DeformDebug' )
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
		
	local Fraction = math.abs( math.sin( self.LifeTime - CurTime() ) ) * 0.1
	local ColFrac = (Fraction-0.5) * 2
	
	Fraction = math.Clamp( Fraction, 0, 1 )
	ColFrac =  math.Clamp( ColFrac, 0, 1 )
	
	-- Change our model's alpha so the texture will fade out
	--entity:SetColor( 255, 255, 255, 1 + 254 * (ColFrac) )
	
	-- Place the camera a tiny bit closer to the entity.
	-- It will draw a big bigger and we will skip any z buffer problems
	local EyeNormal = entity:GetPos() - EyePos()
	local Distance = EyeNormal:Length()
	EyeNormal:Normalize()
	
	local Pos = EyePos() + EyeNormal * Distance * 0.01
	
	-- Start the new 3d camera position
	cam.Start3D( Pos, EyeAngles() )
				
		-- If our card is DX8 or above draw the refraction effect
		if ( render.GetDXLevel() >= 80 ) then
		
			-- Update the refraction texture with whatever is drawn right now
			render.UpdateRefractTexture()
			
			matRefract:SetFloat( "$refractamount", Fraction * 0.1 )
		
			-- Draw model with refraction texture

			render.MaterialOverride( matRefract )
				entity:DrawModel()
			render.MaterialOverride( 0 )
		
		end
	
	-- Set the camera back to how it was
	cam.End3D()
end


function EFFECT:RenderParent()

	local proc = 1 - math.Clamp( self.SpawnEffect.LifeTime - CurTime(), 0, 1 )
	render.SetColorModulation( ( 200 + 55 * proc ) / 255, ( 200 + 55 * proc ) / 255, 255 / 255 )
	self:DrawModel()
	render.SetColorModulation( 1, 1, 1 )
	
	self.SpawnEffect:RenderOverlay( self )

end