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

CreateClientConVar( 'wsps_useold_rift_effect', '0' )

function EFFECT:Init( fx )
	local PE = ParticleEmitter( fx:GetOrigin() )
		if GetConVarNumber( 'wsps_useold_rift_effect' ) == 0 then
			local ptcl = PE:Add( 'effects/wsps/wsps_rift_pinch', fx:GetOrigin() )
				ptcl:SetDieTime( 0.6 )
				ptcl:SetStartAlpha( 200 )
				ptcl:SetRoll( math.random( 0, 360 ) )
				ptcl:SetGravity( Vector() )
				ptcl:SetCollide( true )
				ptcl:SetAirResistance( 0 )
				ptcl:SetStartSize( math.random( 35, 45 ) )
				ptcl:SetEndSize( 0 )
				ptcl:SetVelocityScale( true ) 
				ptcl:SetLighting( false )
		
			local ptcl = PE:Add( 'effects/wsps/wsps_rift_pinch_b', fx:GetOrigin() )
				ptcl:SetDieTime( 0.6 )
				ptcl:SetStartAlpha( 200 )
				ptcl:SetRoll( math.random( 0, 360 ) )
				ptcl:SetGravity( Vector() )
				ptcl:SetCollide( true )
				ptcl:SetAirResistance( 0 )
				ptcl:SetStartSize( math.random( 25, 35 ) )
				ptcl:SetEndSize( 0 )
				ptcl:SetVelocityScale( true ) 
				ptcl:SetLighting( false )
				
			local ptcl = PE:Add( 'effects/wsps/wsps_flash', fx:GetOrigin() )
				ptcl:SetDieTime( 0.6 )
				ptcl:SetStartAlpha( 200 )
				ptcl:SetRoll( math.random( 0, 360 ) )
				ptcl:SetGravity( Vector() )
				ptcl:SetCollide( true )
				ptcl:SetAirResistance( 0 )
				ptcl:SetStartSize( math.random( 10, 15 ) )
				ptcl:SetEndSize( 0 )
				ptcl:SetVelocityScale( true ) 
				ptcl:SetLighting( false )
		else
			local ptcl = PE:Add( 'effects/wsps/wsps_flash', fx:GetOrigin() )
				ptcl:SetDieTime( 0.6 )
				ptcl:SetStartAlpha( 200 )
				ptcl:SetRoll( math.random( 0, 360 ) )
				ptcl:SetGravity( Vector() )
				ptcl:SetCollide( true )
				ptcl:SetAirResistance( 0 )
				ptcl:SetStartSize( math.random( 15, 20 ) )
				ptcl:SetEndSize( 0 )
				ptcl:SetVelocityScale( true ) 
				ptcl:SetLighting( false )
		end
			
		for i = 1, 10 do
			local spawnpos = fx:GetOrigin() + Vector( math.random( -50, 50 ), math.random( -50, 50 ), math.random( -50, 50 ) )
			local ptcl = PE:Add( 'effects/wsps/wsps_spark', spawnpos )
				ptcl:SetDieTime( 0.5 )
				ptcl:SetStartAlpha( 0 )
				//ptcl:SetRollDelta( 25 )
				ptcl:SetRollDelta( math.random( -25, 25 ) )
				ptcl:SetGravity( Vector() )
				ptcl:SetCollide( true )
				ptcl:SetAirResistance( 50 )
				ptcl:SetStartSize( 0 )
				ptcl:SetEndSize( 3 )
				ptcl:SetEndAlpha( 255 )
				ptcl:SetVelocityScale( true )
				ptcl:SetColor( 120, 150, 200 )
				ptcl:SetLighting( false )
				ptcl:SetVelocity( -( spawnpos - fx:GetOrigin() ) * 2 )
		end
		local ptcl = PE:Add( 'effects/select_ring', fx:GetOrigin() )
			ptcl:SetDieTime( 0.7 )
			ptcl:SetStartAlpha( 0 )
			ptcl:SetRoll( 0 )
			ptcl:SetGravity( Vector() )
			ptcl:SetCollide( true )
			ptcl:SetAirResistance( 0 )
			ptcl:SetStartSize( math.random( 45, 60 ) )
			ptcl:SetEndSize( 0 )
			ptcl:SetEndAlpha( math.random( 50, 100 ) )
			ptcl:SetColor( 50, 110, 200 )
			ptcl:SetVelocityScale( true )
			ptcl:SetLighting( false )
	PE:Finish()
end

function EFFECT:Think()
end

function EFFECT:Render()
end