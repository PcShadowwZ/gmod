include("shared.lua")

function ENT:Draw()
    self:DrawModel()
end

net.Receive("Collectable_Effect", function()
    local pos = net.ReadVector()
    local emitter = ParticleEmitter( pos ) 

    for i = 1, 15 do 
        local part = emitter:Add( Material("zerochain/zpn/particles/partypopper/zpn_pumbkinface"), pos ) 
        if ( part ) then
            part:SetDieTime( 2 ) 
            part:SetColor(math.random(200,255),math.random(175,125),0)
            part:SetStartAlpha( 255 ) 
            part:SetEndAlpha( 100 ) 
    
            part:SetStartSize( 5 ) 
            part:SetEndSize( 5 ) 
    
            part:SetGravity( Vector( 0, 0, 15 ) ) 
            part:SetVelocity( VectorRand() * 20 ) 
        end
    end
    
    emitter:Finish()
end)