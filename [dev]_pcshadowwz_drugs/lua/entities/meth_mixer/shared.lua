ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Meth Mixer"
ENT.Author = "PcShadowwZ"
ENT.Spawnable = true
ENT.Category = "Drugs"
PC_MethConfig = PC_MethConfig or {}

function ENT:OnRemove()
    if CLIENT then
    end
    if SERVER then
        self.LoopSound:Stop()
        self.LoopSound = nil
    end
end