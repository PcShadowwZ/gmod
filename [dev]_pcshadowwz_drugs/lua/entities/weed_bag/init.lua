AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
PC_WeedConfig = PC_WeedConfig or {}
local coolDown = {}

function ENT:Initialize()
    self:SetModel("models/zerochain/props_growop2/zgo2_baggy.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    local phys = self:GetPhysicsObject()
    phys:Wake()
end

function ENT:OnTakeDamage(dmg)
	self:Remove()
end


function ENT:Use(activator, caller)
end