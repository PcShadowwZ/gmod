AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/zerochain/props_trashman/ztm_trashbag.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetNWInt("Trash", 100)
    local phys = self:GetPhysicsObject()
    phys:Wake()
end

function ENT:OnTakeDamage(dmg)
	self:Remove()
end