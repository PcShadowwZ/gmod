AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
PC_Ranks = PC_Ranks or {}

CredStore = CredStore or {}
CredStore.Config = CredStore.Config or {}

function ENT:Initialize()
	self:SetModel("models/Characters/hostage_03.mdl")
	self:SetHullType(HULL_HUMAN)
	self:SetHullSizeNormal()
	self:SetNPCState(NPC_STATE_SCRIPT)
	self:SetSolid(SOLID_BBOX)
	self:CapabilitiesAdd(bit.bor(CAP_ANIMATEDFACE, CAP_TURN_HEAD))
	self:SetUseType(SIMPLE_USE)
end

function ENT:Use(ply)
	ply:ConCommand("_storemenu")
end

concommand.Add("creditstore_purchaserank", function(ply,len,args)
	local rank = tonumber(args[1])
	if !PC_Ranks.Config[rank] then return end
	local pkg = PC_Ranks.Config[rank]
    local plyData = mTokens.PlyData[ply:SteamID64()]
    if (!plyData) then return end
	local discount = 0
	if ply:PC_GetRank() > 1 then
		discount = PC_Ranks.Config[ply:PC_GetRank()].Price 
	end
	local realPrice = pkg.Price - discount
    if (!mTokens.CanPlayerAfford(ply, realPrice)) then
        DarkRP.notify(ply, 1, 5, "You can not afford this package.")
        return
    end

	if ply.PCRank >= rank then
        DarkRP.notify(ply, 1, 5, "You already have the same/higher rank.")
        return
    end

	mTokens.TakePlayerTokens(ply, realPrice)
	ply:PC_SetRank(rank)
	ply:addMoney((pkg.Price/1000) * 2500000)

	DarkRP.notify(ply, 0, 5, "You purchased the package: ".. pkg.Name.." for: "..realPrice.. " Credits")
    mTokens.Print(ply:Nick() .. " purchased package " .. pkg.Name .." for: "..realPrice.. " Credits")

end)

concommand.Add("creditstore_purchasemisc", function(ply,len,args)
	local item = tonumber(args[1])
	if !CredStore.Config.Misc[item] then return end
	local pkg = CredStore.Config.Misc[item]
    local plyData = mTokens.PlyData[ply:SteamID64()]
    if (!plyData) then return end
	local realPrice = pkg.Price 
    if (!mTokens.CanPlayerAfford(ply, realPrice)) then
        DarkRP.notify(ply, 1, 5, "You can not afford this package.")
        return
    end


	mTokens.TakePlayerTokens(ply, realPrice)
	if item == 2 then
		ply:addMoney(2500000)
	end
	if item == 3 then
		ply:addMoney(10000000)
	end
	if item == 4 then
		RunConsoleCommand("battlepass_give_pass", ply:SteamID64())
	end
	if item == 5 then
		RunConsoleCommand("battlepass_give_tier", ply:SteamID64(), 1)
	end
	if item == 6 then
		RunConsoleCommand("battlepass_give_tier", ply:SteamID64(), 5)
	end

	DarkRP.notify(ply, 0, 5, "You purchased the package: ".. pkg.Name.." for: "..realPrice.. " Credits")
    mTokens.Print(ply:Nick() .. " purchased package " .. pkg.Name .." for: "..realPrice.. " Credits")

end)

local badwords = {

}

--[[hook.Add( "PlayerSay", "CoinFlip", function(ply,text)
	for k, v in pairs(badwords) do
		if string.find( text:lower(), k ) then
			RunConsoleCommand("_storemenu")
			return ""
		end
	end
end )]]