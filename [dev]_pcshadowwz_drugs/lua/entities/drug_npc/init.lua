AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
PC_DrugsConfig = PC_DrugsConfig or {}
local function RandomDrugMultipliers()
	for k, v in pairs(PC_DrugsConfig) do
		SetGlobalFloat(v.Name.."_SellMultiplier", math.Round(math.Rand(50,150),2))
	end
end
RandomDrugMultipliers()
timer.Create("RandomizeDrugPrices",3600, 0, function()
	RandomDrugMultipliers()
end)
function ENT:Initialize()
	self:SetModel("models/gman_high.mdl")
	self:SetHullType(HULL_HUMAN)
	self:SetHullSizeNormal()
	self:SetNPCState(NPC_STATE_SCRIPT)
	self:SetSolid(SOLID_BBOX)
	self:CapabilitiesAdd(bit.bor(CAP_ANIMATEDFACE, CAP_TURN_HEAD))
	self:SetUseType(SIMPLE_USE)
end



function ENT:Use(ply)
	ply:ConCommand("_drugs_menu")
end

concommand.Add("_drugs_sell", function(ply, cmd, args)
	local drug = args[1]
	local amt = tonumber(args[2])
	if !PC_DrugsConfig[drug] then return end
	if amt < 0 then return end
	local drug = PC_DrugsConfig[drug]
    local tr = util.TraceLine( {
        start = ply:EyePos(),
        endpos = ply:EyePos() + ply:EyeAngles():Forward() * 10000,
        filter = function( ent ) return ( ent:GetClass() == "drug_npc" ) end
    } )
    local ent = tr.Entity
    if ent:GetPos():Distance(ply:GetPos()) > 100 then return end
	local frac = (0.02 * ply:PC_Leveling_GetLevel(3)) + 1
	local price = drug.SellPrice * math.Round(GetGlobalFloat( drug.Name.."_SellMultiplier", 100 )/100,2) * amt * frac
	if args[1] == "weed_bag" then
		if ply:GetNWInt("PC_Drugs_Weed", 0) >= amt then
			ply:SetNWInt("PC_Drugs_Weed", ply:GetNWInt("PC_Drugs_Weed", 0) - amt)
			ply:addMoney(price)
			ply:EmitSound("zmlab2/cash")
			DarkRP.notify(ply, 0, 5, "You sold "..amt.." ".. drug.Name.. " for $"..price)
			hook.Run( "PC_Drugs_SellWeed", ply, price )
			--ply:DarkRpChat("INVENTORY", Color(0,150,200), "You sold "..amt.." ".. drug.Name.. " for $"..price)
		end
	end
	if args[1] == "meth_bag" then
		if ply:GetNWInt("PC_Drugs_Meth", 0) >= amt then
			ply:SetNWInt("PC_Drugs_Meth", ply:GetNWInt("PC_Drugs_Meth", 0) - amt)
			ply:addMoney(price)
			ply:EmitSound("zmlab2/cash")
			DarkRP.notify(ply, 0, 5, "You sold "..amt.." ".. drug.Name.. " for $"..price)
			hook.Run( "PC_Drugs_SellMeth", ply, price )
			--ply:DarkRpChat("INVENTORY", Color(0,150,200), "You sold "..amt.." ".. drug.Name.. " for $"..price)
		end
	end
end)


hook.Add("PlayerDeath", "Drugs_RemoveDeath", function(ply) 
	ply:SetNWInt("PC_Drugs_Weed", 0)
	ply:SetNWInt("PC_Drugs_Meth", 0)
end)
