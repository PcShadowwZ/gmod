AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/zerochain/props_trashman/ztm_leafpile.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetNWInt("Trash", 20)
    local phys = self:GetPhysicsObject()
    phys:Wake()
end

function ENT:Think()
    if self:GetNWInt("Trash", 0) < 75 then
        self:SetNWInt("Trash", self:GetNWInt("Trash", 0) + 1)
    end
    self:NextThink(CurTime() + 5)
    return true
end
