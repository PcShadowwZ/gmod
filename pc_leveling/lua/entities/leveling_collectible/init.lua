AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
util.AddNetworkString("Collectable_Effect")
function CollectibleFuckNiggersWithEspLOL()
    local tblRand = {}
    for k, v in pairs(ents.FindByClass("leveling_collectible")) do
        table.insert(tblRand, v)
        v.Active = false
    end
    local chosen = table.Random(tblRand)
    if chosen then
        chosen.Active = true
        print(chosen:GetPos())
    end
end


function ENT:Initialize()
    self:SetModel("models/terr/models/bosses/boss_pumpking_mad_head_small.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetModelScale(1, 0)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)
    self.Active = false
    local phys = self:GetPhysicsObject()
    phys:EnableMotion(false)
    phys:Wake()
end

function ENT:Think()
    if self.Active then
        net.Start("Collectable_Effect")
            net.WriteVector(self:GetPos())
        net.Broadcast()
    end
    self:NextThink(CurTime() + 1)
    return true
end

function ENT:Use(acc,call)
    if self.Active then
        acc:PC_Leveling_AddXP(10,1)
        self:EmitSound("vo/npc/Barney/ba_laugh02.wav",75,50)
        net.Start("pumpbomb_effect")
		    net.WriteVector(self:GetPos())
	    net.Broadcast()
        for k, v in pairs(ents.FindByClass("leveling_collectible")) do
            v.Active = false
        end
        timer.Simple(1500, function()
            CollectibleFuckNiggersWithEspLOL()
        end)
    end
end