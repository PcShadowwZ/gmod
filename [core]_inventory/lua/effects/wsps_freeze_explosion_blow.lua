--[[ Apache License --
	Copyright 2015 Wheatley
	 
	Licensed under the Apache License, Version 2.0 (the 'License'); you may not use this file except
	in compliance with the License. You may obtain a copy of the License at
	 
	http://www.apache.org/licenses/LICENSE-2.0
	 
	Unless required by applicable law or agreed to in writing, software distributed under the License
	is distributed on an 'AS IS' BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express
	or implied. See the License for the specific language governing permissions and limitations under
	the License.
	 
	The right to upload this project to the Steam Workshop (which is operated by Valve Corporation)
	is reserved by the original copyright holder, regardless of any modifications made to the code,
	resources or related content. The original copyright holder is not affiliated with Valve Corporation
	in any way, nor claims to be so.
]]

function EFFECT:Init( fx )
	local ent = fx:GetEntity()
	if !IsValid( ent ) then return end
	local PE = ParticleEmitter( ent:GetPos() )
		for i = 1, 200 do
			local mins, maxs = ent:OBBMins(), ent:OBBMaxs()
			local ptcl = PE:Add( 'effects/wsps/wsps_spark', ent:GetPos() + Vector( math.random( mins.x, maxs.x ), math.random( mins.y, maxs.y ), math.random( mins.z, maxs.z ) ) )
				ptcl:SetDieTime( math.random( 5, 10 ) )
				ptcl:SetStartAlpha( 255 )
				ptcl:SetRollDelta( math.random( -25, 25 ) )
				ptcl:SetGravity( Vector( 0, 0, -600 ) )
				ptcl:SetCollide( true )
				ptcl:SetAirResistance( 0 )
				ptcl:SetStartSize( math.random( 2, 5 ) )
				ptcl:SetEndSize( 0 )
				ptcl:SetColor( 0, 210, 255, 255 )
				ptcl:SetVelocityScale( true )
				ptcl:SetBounce( 0.5 )
				ptcl:SetLighting( false )
				ptcl:SetVelocity( -fx:GetAngles():Forward() + VectorRand() * math.random( 150, 250 ) )
				
			local ptcl = PE:Add( 'effects/wsps/wsps_flash', ent:GetPos() + Vector( math.random( mins.x, maxs.x ), math.random( mins.y, maxs.y ), math.random( mins.z, maxs.z ) ) )
				ptcl:SetDieTime( math.random( 4, 6 ) )
				ptcl:SetStartAlpha( 255 )
				ptcl:SetRoll( math.random( 0, 360 ) )
				ptcl:SetGravity( Vector( 0, 0, -math.random( 50, 100 ) ) )
				ptcl:SetCollide( true )
				ptcl:SetColor( 0, 210, 255 )
				ptcl:SetAirResistance( 0 )
				ptcl:SetStartSize( math.random( 5, 15 ) )
				ptcl:SetEndSize( 0 )
				ptcl:SetEndAlpha( 0 )
				ptcl:SetVelocityScale( true )
				ptcl:SetLighting( false )
		end
	PE:Finish()
end

function EFFECT:Think()
end

function EFFECT:Render()
end