require("mysqloo")
PC_Ranks = PC_Ranks or {}
PC_Ranks.Config = PC_Ranks.Config or {}
PC_Ranks.DB = PC_Ranks.DB or {}

PC_Ranks.DB.Config = {
    host = "104.128.72.10",
    username = "u6173_6sJ4gTP8xl",
    password = "ju41V778KelQkf7d",
    database = "s6173_helixranks",
    port = 3306,
}

function PC_Ranks.DB:Connect()
    self.Connection = mysqloo.connect( PC_Ranks.DB.Config.host, PC_Ranks.DB.Config.username, PC_Ranks.DB.Config.password, PC_Ranks.DB.Config.database, PC_Ranks.DB.Config.port )

    function self.Connection:onConnectionFailed(err)
        MsgC(Color(255, 0 , 0), "[Ranks] Connection to database failed! \n" )
        MsgC(Color(255, 0 , 0), "[Ranks] Error: ", err .. "\n" )
		timer.Simple(5, function()
			if not self then return end
			PC_Ranks.DB:Connect()
		end)
    end

    function self.Connection:onConnected()
        MsgC(Color(0, 255 , 0), "[Ranks] Database connected \n" )

		PC_Ranks.DB.Query("CREATE TABLE IF NOT EXISTS player_ranks (sid BIGINT, rank INT, PRIMARY KEY(sid))")
    end

    self.Connection:connect()
end


function PC_Ranks.GetRankFromDB(sid,callback)
	PC_Ranks.DB.Query(string.format("SELECT * FROM player_ranks WHERE sid= %s;", sid), callback)
end


hook.Add("Initialize", "RanksDBConnection", function()
	MsgC(Color(155, 155 , 155), "[Ranks] Attempting connection to MySQL Database.\n" )
	PC_Ranks.DB:Connect()
end)

function PC_Ranks.DB.Query(q, callback)
	local query = PC_Ranks.DB.Connection:query(q)

	query.onSuccess = function(q, data)
		if callback then
			callback(data)
		end
	end
	query.onError = function(q, err)
        MsgC(Color(255, 0 , 0), "[Rank] MySQL Query failed! \n" )
       	MsgC(Color(255, 0 , 0), "[Rank] Error: ", err .. "\n" )
	end

	query:start()
end


hook.Add("PlayerInitialSpawn", "PC_PlayerRankLoad", function(ply)
	timer.Simple(5, function()
        PC_Ranks.GetRankFromDB(ply:SteamID64(), function(data)
            if data and not table.IsEmpty(data) then
                ply:PC_SetRank(data[1].rank)
            else
                ply:PC_SetRank(1)
            end
        end)
	end)
end)