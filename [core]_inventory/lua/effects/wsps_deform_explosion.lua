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
		for i = 2, 5 do
			local ptcl = PE:Add( 'effects/wsps/wsps_flash', fx:GetOrigin() )
				ptcl:SetDieTime( i / 30 )
				ptcl:SetStartAlpha( 255 )
				ptcl:SetRoll( math.random( 0, 360 ) )
				ptcl:SetGravity( Vector() )
				ptcl:SetCollide( true )
				ptcl:SetAirResistance( 0 )
				ptcl:SetStartSize( 0 )
				ptcl:SetEndSize( i * 25 )
				ptcl:SetVelocityScale( true )
				ptcl:SetLighting( false )
			end
		for i = 1, 45 do
			local ptcl = PE:Add( 'effects/wsps/wsps_spark', fx:GetOrigin() )
				ptcl:SetDieTime( 2 )
				ptcl:SetStartAlpha( 255 )
				ptcl:SetRollDelta( math.random( -25, 25 ) )
				ptcl:SetGravity( Vector() )
				ptcl:SetCollide( true )
				ptcl:SetAirResistance( 50 )
				ptcl:SetStartSize( 3 )
				ptcl:SetEndSize( 0 )
				ptcl:SetVelocityScale( true )
				ptcl:SetBounce( 0.3 )
				ptcl:SetColor( 100, 130, 255 )
				ptcl:SetLighting( false )
				ptcl:SetVelocity( VectorRand() * math.random( 100, 200 ) )
		end
		
		for i = 2, 5 do
			local ptcl = PE:Add( 'effects/wsps/wsps_flash', fx:GetOrigin() )
				ptcl:SetDieTime( i * 0.2 )
				ptcl:SetStartAlpha( 25 )
				ptcl:SetRoll( math.random( 0, 360 ) )
				ptcl:SetGravity( Vector() )
				ptcl:SetCollide( true )
				ptcl:SetAirResistance( 0 )
				ptcl:SetStartSize( 0 )
				ptcl:SetEndSize( i * 25 )
				ptcl:SetEndAlpha( 0 )
				ptcl:SetColor( 255, 255, 255 )
				ptcl:SetVelocityScale( true )
				ptcl:SetLighting( false )
		end
	PE:Finish()
end

function EFFECT:Think()
end

function EFFECT:Render()
end