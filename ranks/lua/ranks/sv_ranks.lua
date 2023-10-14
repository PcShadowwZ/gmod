PC_Ranks = PC_Ranks or {}
PC_Ranks.DB = PC_Ranks.DB or {}
PC_Ranks.Config = PC_Ranks.Config or {}
local meta = FindMetaTable("Player")


function meta:PC_SetRank(rank)
    self.PCRank = rank
    self:SetNWInt("PC_Rank", rank)
    self:PC_SaveRank()
end

function PC_SetRankBySteamID(sid,rank)
    local player = player.GetBySteamID64(sid)
    if IsValid(player) then
        player:PC_SetRank(rank)
    else
        PC_Ranks.DB.Query(string.format("REPLACE INTO player_ranks VALUES ('%s', '%s')", sid, rank))  
    end
end

function meta:PC_SaveRank()
    local sid = self:SteamID64()
    local rank = self.PCRank or 1
    PC_Ranks.DB.Query(string.format("REPLACE INTO player_ranks VALUES ('%s', '%s')", sid, rank))
end


concommand.Add("rank_giveself", function (ply, cmd, args)
	if !ply:IsSuperAdmin() then return end 

	local rank = tonumber(args[1])

	if not (PC_Ranks.Config[rank]) then return end

    ply:PC_SetRank(rank)
end)

concommand.Add("rank_give_id", function (ply, cmd, args)
	if (ply != NULL) then return end 

	local steamid = args[1]
	local rank = tonumber(args[2])

	if not (PC_Ranks.Config[rank]) then return end

    PC_SetRankBySteamID(steamid,rank)
end)


hook.Add("PlayerSpawnedProp", "PC_Rank_PropLimitS", function(ply,mdl,ent)
    if ply:GetCount("props") >= PC_Ranks.Config[ply.PCRank].Props then
        ent:Remove()
    end
end)

function PC_GiveRankWeapons(ply)
    for k, v in pairs(PC_Ranks.Config[ply.PCRank or 1].Weps) do
        local wep = ply:Give(k)
        wep.RankWep = true
    end
end
hook.Add("PlayerSpawn","PC_Ranks_GiveGuns",PC_GiveRankWeapons)

hook.Add("canDropWeapon","PC_Ranks_NoDropRankGuns", function(ply,wep)
    if wep.RankWep then
        return false, "You can not drop rank weapons."
    end
end)