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
	local PE = ParticleEmitter( fx:GetOrigin() )
		for i = 1, 5 do
			local ptcl = PE:Add( 'effects/wsps/wsps_spark', fx:GetOrigin() )
				ptcl:SetDieTime( 0.3 )
				ptcl:SetStartAlpha( 255 )
				ptcl:SetRollDelta( 25 )
				ptcl:SetGravity( Vector() )
				ptcl:SetCollide( true )
				ptcl:SetColor( 0, 210, 255 )
				ptcl:SetAirResistance( 0 )
				ptcl:SetStartSize( 2 )
				ptcl:SetEndSize( 0 )
				ptcl:SetVelocityScale( true )
				ptcl:SetLighting( false )
				ptcl:SetVelocity( -fx:GetAngles():Forward() + VectorRand() * math.random( 35, 75 ) )
		end
		
		local ptcl = PE:Add( 'effects/wsps/wsps_flash', fx:GetOrigin() )
			ptcl:SetDieTime( 0.5 )
			ptcl:SetStartAlpha( 255 )
			ptcl:SetRoll( math.random( 0, 360 ) )
			ptcl:SetGravity( Vector() )
			ptcl:SetCollide( true )
			ptcl:SetColor( 0, 210, 255 )
			ptcl:SetAirResistance( 0 )
			ptcl:SetStartSize( math.random( 13, 24 ) )
			ptcl:SetEndSize( 0 )
			ptcl:SetVelocityScale( true )
			ptcl:SetLighting( false )
	PE:Finish()
end

function EFFECT:Think()
end

function EFFECT:Render()
end