PCMAC = PCMAC or {}
PCMACConfig = PCMACConfig or {}
PCMAC.PlyMaterials = PCMAC.PlyMaterials or {}
local meta = FindMetaTable("Player")

util.AddNetworkString( "PCMAC_SellOre" )
util.AddNetworkString( "PCMAC_Craft" )
util.AddNetworkString( "PCMAC_SendOre" )

local refundVars = {
	["Storage"] = 1000,
	["Speed"] = 1000,
	["Power"] = 1000,
	["Rare Find"] = 1500,
	["Luck"] = 2000,

}

function meta:RefundUpgrades()
	PCMAC.DB.Query(string.format("SELECT * FROM pcmac_upgrades WHERE sid= %s;", self:SteamID64()), function(data)
		if data and istable(data) then
			for k, v in pairs(data) do
				for i = 0, v.amt do
					self:addMoney((tonumber(refundVars[v.type]) * tonumber(refundVars[v.type])) * (i))
				end
			end
			print("Refunded")
			PCMAC.DB.Query(string.format("DELETE FROM pcmac_upgrades WHERE sid= %s;", self:SteamID64()), function(data) end)
		end
	end)
end
--[[Storage = (tonumber(refundVars[v.type]) * tonumber(refundVars[v.type])) * v.amt
Speed = (tonumber(1000) * tonumber(1000)) * (PCMAC.PlyUpgrades[id])
Power = (tonumber(1000) * tonumber(1000)) * (PCMAC.PlyUpgrades[id])
Rare Find = (tonumber(1500) * tonumber(1500)) * (PCMAC.PlyUpgrades[id])
Luck = (tonumber(2000) * tonumber(2000)) * (PCMAC.PlyUpgrades[id])]]

function meta:SaveOre(ore)
    local sid = self:SteamID64()
    local level = self.PCMACMaterials[ore] or 0
    PCMAC.DB.Query(string.format("REPLACE INTO pcmac_ores VALUES ('%s', '%s', '%s')", sid, ore, level))
end

function meta:SendOre(ore)
	net.Start("PCMAC_SendOre")
		net.WriteString(ore)
		net.WriteFloat(self.PCMACMaterials[ore])
	net.Send(self)
end

function meta:AddOre(ore, value)
	self.PCMACMaterials[ore] = math.Round(self.PCMACMaterials[ore] + value,1)
	self:SaveOre(ore)
end

concommand.Add("Fuck", function(ply,len,args)
	for k, v in pairs(PCMACConfig.Ores) do
		ply:SendOre(k)
	end
end)


function PCMAC_SellOre(ply, oreName, sellCount)
	if !ply.PCMACMaterials[oreName] then return end
	if sellCount < 0 then return end
	if ply.PCMACMaterials[oreName] >= sellCount then
		DarkRP.notify(ply, 0, 5, "You Sold " .. sellCount .. " Of ".. oreName .. " For $"..PCMACConfig.Ores[oreName].Price * sellCount )
		local profit = PCMACConfig.Ores[oreName].Price * sellCount

		if sellCount < ply.PCMACMaterials[oreName] then
            ply:AddOre(oreName, -sellCount)
			ply:addMoney(profit)
		else
			ply:AddOre(oreName, -ply.PCMACMaterials[oreName])
			ply:addMoney(profit)
		end
	
        ply:SendOre(oreName)

		hook.Run( "PCMAC_Sell_Ore", ply, profit, oreName  )
	else
		DarkRP.notify(ply, 0, 5, "You Can't Sell That Much" )
	end
end

function PCMAC_MineOre(ply, oreName)
	local adder = math.Rand(PCMACConfig.Pickaxe.oreMin,PCMACConfig.Pickaxe.oreMax)
	adder = math.Round(adder,2)
	ply:AddOre(oreName, adder)
	ply:SendOre(oreName)
	DarkRP.notify(ply, 0, 5, "You Mined ".. adder.. " "..oreName )
	hook.Run("PCMAC_Mine_Ore", ply, adder, oreName)
	if math.random(1, 10) == 1 then
		ply:PC_Leveling_AddXP(4,1)
	end
end

function PCMAC_MineBonus(ply)
	DarkRP.notify(ply, 0, 5, "You Mined A XP Bonus Spot" )
	ply:PC_Leveling_AddXP(4,1)
end

net.Receive( "PCMAC_SellOre", function( len, ply )
	local oreName = net.ReadString()
	local sellCount = math.Round(net.ReadFloat(), 2)

	PCMAC_SellOre(ply, oreName, sellCount)
end)



function PCMAC_CraftItem(ply, itemId)
	local item = PCMACConfig.Items[itemId]
	local realItemID = -1
	for k, v in pairs(VoidCases.Config.Items) do 
		if tostring(v.info.actionValue) == itemId then
			realItemID = v.id
		end
	end
	if realItemID <= 0 then
		DarkRP.notify(ply, 0, 5, "Invalid Item" )
		return
	end
	local removerTbl = {}
	for k, v in pairs(item.Costs) do 
		if k == "Levels" and tonumber(ply.PCMACLevel) < v.Value then
			DarkRP.notify(ply, 0, 5, "You Dont Meet The Requirements" )
			return	
		end

		if k == "Money" and ply:canAfford(v.Value) then
			removerTbl["Money"] = v.Value
		elseif !ply:canAfford(v.Value) then
			DarkRP.notify(ply, 0, 5, "You Dont Meet The Requirements" )
			return	
		end

		if (k != "Money") and (k != "Levels") then
			if ply.PCMACMaterials[k] >= v.Value then
				removerTbl[k] = v.Value
			elseif ply.PCMACMaterials[k] < v.Value then
				DarkRP.notify(ply, 0, 5, "You Dont Meet The Requirements" )
				return	
			end
		end
	end

	for k, v in pairs(removerTbl) do 
		if k == "Money" then
			ply:addMoney(-v)
		else
            ply:AddOre(k, -v)
            ply:SendOre(k)
		end
	end



	if item.Category == "Guns" then
		VoidCases.AddItem(ply:SteamID64(), realItemID, 1)
		VoidCases.NetworkItem(ply, realItemID, 1)
	end

	if item.Category == "Suits" then
		VoidCases.AddItem(ply:SteamID64(), realItemID, 1)
		VoidCases.NetworkItem(ply, realItemID, 1)
	end

	hook.Run( "PCMAC_Craft_"..itemId, ply )

	DarkRP.notify(ply, 0, 5, "You Crafted A(n) ".. item.Name  )
end

net.Receive( "PCMAC_Craft", function( len, ply )
	local itemId = net.ReadString()
	PCMAC_CraftItem(ply, itemId)
end)


local minerBoxMin
local minerBoxMax
local protectedMiners = {}
local nextThink = CurTime()
hook.Add("Think", "PC_Mining_MinerProtection", function()
	if nextThink > CurTime() then return end
	nextThink = CurTime() + .5
	for k, ply in pairs(player.GetAll()) do 
		if IsValid(ply) then
			if ply:GetPos():WithinAABox(PCMACConfig.MinerBoxMax, PCMACConfig.MinerBoxMin) then
				if ply:Team() == TEAM_MINER then
					if !table.HasValue(protectedMiners, ply) then
						table.insert(protectedMiners, ply)
						ply:SetNoDraw(true)
						ply:SetCollisionGroup(COLLISION_GROUP_WORLD)
						ply.MinerProtection = true
					end
				else
					if table.HasValue(protectedMiners, ply) then
						table.RemoveByValue(protectedMiners, ply)
						ply:SetNoDraw(false)
						ply:SetCollisionGroup(COLLISION_GROUP_PASSABLE_DOOR)
						ply.MinerProtection = false
					end
				end
			else
				if table.HasValue(protectedMiners, ply) then
					table.RemoveByValue(protectedMiners, ply)
					ply:SetNoDraw(false)
					ply.MinerProtection = false
				end
				ply:SetCollisionGroup(COLLISION_GROUP_PASSABLE_DOOR)
			end
		end
		if not ply:IsEFlagSet(EFL_NO_DAMAGE_FORCES) then ply:AddEFlags(EFL_NO_DAMAGE_FORCES) end
		ply:SetAvoidPlayers(false)
	end 
end)

hook.Add("PlayerShouldTakeDamage", "MinerNoDamage", function(ply,att)
	if ply.MinerProtection or att.MinerProtection then
		return false
	end
end)
