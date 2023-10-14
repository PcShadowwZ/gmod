AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
PC_MethConfig = PC_MethConfig or {}

function ENT:Initialize()
    self:SetModel("models/zerochain/props_methlab/zmlab2_filler.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetBodygroup( 0, 1 )
    self:SetNWFloat("MixTime", CurTime())
    self:SetNWInt("State",0)
    self:SetNWFloat("Aluminium", 0)
    self:SetNWFloat("Methylamine", 0)
    self.LoopSound = CreateSound(self, "zmlab2/boil02_loop.wav")
    local phys = self:GetPhysicsObject()
    phys:Wake()
end

function ENT:OnTakeDamage(dmg)
	self:Remove()
end

function ENT:Think()
    if self:GetNWInt("State",0) == 1 and self:GetNWFloat("MixTime", CurTime()) <= CurTime() then
        self.LoopSound:Stop()
    end
end
local nextTouch = CurTime()
function ENT:Touch(entity)
    if nextTouch > CurTime() then return end
	if self:GetNWInt("State",0) == 0 then
        if entity:GetClass() == "aluminium_box" and self:GetNWFloat("Aluminium", 0) < 100 then
            nextTouch = CurTime() + .5
            entity:Remove()
            self:EmitSound("zmlab2/aluminiumshake0"..math.random(1,6)..".mp3")
            self:SetNWFloat("Aluminium", self:GetNWFloat("Aluminium", 0) + 20)
        end
        if entity:GetClass() == "methylamine_barrel" and self:GetNWFloat("Methylamine", 0) < 100  then
            nextTouch = CurTime() + .5
            entity:Remove()
            self:EmitSound("zmlab2/liquid_fill01.wav")
            self:SetNWFloat("Methylamine", self:GetNWFloat("Methylamine", 0) + 25)
        end
    end
end

function ENT:Use(activator, caller)
    activator:ConCommand("_meth_mixer_open")
end
concommand.Add("_meth_start", function(ply, cmd, args)
    local tr = util.TraceLine( {
        start = ply:EyePos(),
        endpos = ply:EyePos() + ply:EyeAngles():Forward() * 10000,
        filter = function( ent ) return ( ent:GetClass() == "meth_mixer" ) end
    } )
    local ent = tr.Entity
    if ent:GetPos():Distance(ply:GetPos()) > 100 then return end
    if ent:GetNWInt("State",0) != 0 then return end
    if ent:GetNWFloat("Aluminium", 0) >= 100 and ent:GetNWFloat("Methylamine", 0) >= 100 then
        ent.LoopSound:Play()
        ent:SetNWFloat("MixTime", CurTime() + 180)
        ent:SetNWInt("State",1)
    end
end)
concommand.Add("_meth_harvest", function(ply, cmd, args)
    local tr = util.TraceLine( {
        start = ply:EyePos(),
        endpos = ply:EyePos() + ply:EyeAngles():Forward() * 10000,
        filter = function( ent ) return ( ent:GetClass() == "meth_mixer" ) end
    } )
    local ent = tr.Entity
    if ent:GetPos():Distance(ply:GetPos()) > 100 then return end
    if ent:GetNWInt("State",0) == 1 and ent:GetNWFloat("MixTime", CurTime()) <= CurTime() then
        ent:SetNWFloat("MixTime", CurTime())
        ent:SetNWInt("State",0)
        ent:SetNWFloat("Aluminium", 0)
        ent:SetNWFloat("Methylamine", 0)
        ply:PC_Leveling_AddXP(3,1)
        ply:SetNWInt("PC_Drugs_Meth", ply:GetNWInt("PC_Drugs_Weed", 0) + math.Round(math.random(20,50)))
    end
    ent:EmitSound("zmlab2/process_fillingcrate.wav")
end)