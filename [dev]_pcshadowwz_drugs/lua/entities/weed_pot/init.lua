AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
PC_WeedConfig = PC_WeedConfig or {}
PC_WeedConfig.Pot = PC_WeedConfig.Pot or {}
local coolDown = {}

function ENT:Initialize()
    self:SetModel("models/zerochain/props_growop2/zgo2_pot01.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetBodygroup( 0, 1 )
    self:SetNWInt("GrowState", 1)
    timer.Create("WeedGrowing"..self:EntIndex(), 120, 0, function()
        if self:GetNWInt("GrowState", 0) < 7 then
            self:SetNWInt("GrowState", self:GetNWInt("GrowState", 1) + 1)
        end
    end)
    local phys = self:GetPhysicsObject()
    phys:Wake()
end

function ENT:OnTakeDamage(dmg)
	self:Remove()
end


function ENT:Use(activator, caller)
    activator:ConCommand("_weed_pot_open")
end

concommand.Add("_weed_harvest", function(ply, cmd, args)
    local tr = util.TraceLine( {
        start = ply:EyePos(),
        endpos = ply:EyePos() + ply:EyeAngles():Forward() * 10000,
        filter = function( ent ) return ( ent:GetClass() == "weed_pot" ) end
    } )
    local ent = tr.Entity
    if ent:GetPos():Distance(ply:GetPos()) > 100 then return end
    local weedTable = PC_WeedConfig.Pot.WeedStates[ent:GetNWInt("GrowState", 1)]
    local harvestState = "False"
    if weedTable.CanHarvest then
        harvestState = "True"
    end
    if harvestState == "True" then
        local multi = 1
        if ent:GetNWInt("GrowState", 1) == 6 then
            multi = 1.5
            ply:PC_Leveling_AddXP(3,2)
        end
        if ent:GetNWInt("GrowState", 1) == 7 then
            multi = .1
            ply:PC_Leveling_AddXP(3,1)
        end
        ent:SetNWInt("GrowState", 1)
        ent:EmitSound("zwf/zwf_plant_cut")
        ply:SetNWInt("PC_Drugs_Weed", ply:GetNWInt("PC_Drugs_Weed", 0) + math.Round(math.random(15,30) * multi))
    end
end)