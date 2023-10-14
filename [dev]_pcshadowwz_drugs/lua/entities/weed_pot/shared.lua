ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Weed Pot"
ENT.Author = "PcShadowwZ"
ENT.Spawnable = true
ENT.Category = "Drugs"
PC_WeedConfig = PC_WeedConfig or {}
PC_WeedConfig.Pot = PC_WeedConfig.Pot or {}

PC_WeedConfig.Pot.WeedStates = {
    [1] = {
        ["Name"] = "Rooting",
        ["Model"] = "models/zerochain/props_growop2/zgo2_plant04_break05.mdl",
        ["Color"] = Color(255,255,255),
        ["ModelScale"] = 0,
        ["Position"] = Vector(0,0,0)
    },
    [2] = {
        ["Name"] = "Growing",
        ["Model"] = "models/zerochain/props_growop2/zgo2_plant04_break05.mdl",
        ["Color"] = Color(255,255,255),
        ["ModelScale"] = 1,
        ["Position"] = Vector(-10,0,-11)
    },
    [3] = {
        ["Name"] = "Growing",
        ["Model"] = "models/zerochain/props_growop2/zgo2_plant04_break07.mdl",
        ["Color"] = Color(255,255,255),
        ["ModelScale"] = 1,
        ["Position"] = Vector(-4,7,-11)
    },
    [4] = {
        ["Name"] = "Growing",
        ["Model"] = "models/zerochain/props_growop2/zgo2_plant04_break07.mdl",
        ["Color"] = Color(255,255,255),
        ["ModelScale"] = 2,
        ["Position"] = Vector(-8,14,-30)
    },
    [5] = {
        ["Name"] = "Grown",
        ["Model"] = "models/zerochain/props_growop2/zgo2_plant04.mdl",
        ["Color"] = Color(255,255,255),
        ["ModelScale"] = 1,
        ["Position"] = Vector(0,0,10),
        ["CanHarvest"] = true
    },
    [6] = {
        ["Name"] = "Matured",
        ["Model"] = "models/zerochain/props_growop2/zgo2_plant04.mdl",
        ["Color"] = Color(255,255,255),
        ["ModelScale"] = 1.25,
        ["Position"] = Vector(0,0,11),
        ["CanHarvest"] = true
    },
    [7] = {
        ["Name"] = "Dead",
        ["Model"] = "models/zerochain/props_growop2/zgo2_plant04.mdl",
        ["Color"] = Color(75,65,25),
        ["ModelScale"] = 1,
        ["Position"] = Vector(0,0,11),
        ["Material"] = "models/antlion/antlion_innards",
        ["CanHarvest"] = true
    },
}

function ENT:OnRemove()
    if CLIENT then
        if IsValid(self.Weed) then
            self.Weed:Remove()
        end
    end
    if SERVER then
        timer.Remove("WeedGrowing"..self:EntIndex())
    end
end