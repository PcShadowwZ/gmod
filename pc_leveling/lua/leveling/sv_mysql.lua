require("mysqloo")
PC_Leveling = PC_Leveling or {}
PC_Leveling.Config = PC_Leveling.Config or {}
PC_Leveling.AllSkills = PC_Leveling.AllSkills or {}
PC_Leveling.DB = PC_Leveling.DB or {}

PC_Leveling.DB.Config = {
    host = "104.128.72.10",
    username = "u6173_6sJ4gTP8xl",
    password = "ju41V778KelQkf7d",
    database = "s6173_helixranks",
    port = 3306,
}


function PC_Leveling.DB:Connect()
    self.Connection = mysqloo.connect( PC_Leveling.DB.Config.host, PC_Leveling.DB.Config.username, PC_Leveling.DB.Config.password, PC_Leveling.DB.Config.database, PC_Leveling.DB.Config.port )

    function self.Connection:onConnectionFailed(err)
        MsgC(Color(255, 0 , 0), "[PC_Leveling] Connection to database failed! \n" )
        MsgC(Color(255, 0 , 0), "[PC_Leveling] Error: ", err .. "\n" )
		timer.Simple(5, function()
			if not self then return end
			PC_Leveling.DB:Connect()
		end)
    end

    function self.Connection:onConnected()
        MsgC(Color(0, 255 , 0), "[PC_Leveling] Database connected \n" )
		PC_Leveling.DB.Query("CREATE TABLE IF NOT EXISTS pc_leveling (sid BIGINT, type INT, level INT, xp INT, PRIMARY KEY(sid,type))")
		PC_Leveling.DB.Query("CREATE TABLE IF NOT EXISTS pc_prestige (sid BIGINT, level INT, PRIMARY KEY(sid))")
    end

    self.Connection:connect()
end


function PC_Leveling.GetLevelingFromDB(sid,callback)
	PC_Leveling.DB.Query(string.format("SELECT * FROM pc_leveling WHERE sid= %s;", sid), callback)
end

function PC_Leveling.GetPrestigeFromDB(sid,callback)
	PC_Leveling.DB.Query(string.format("SELECT * FROM pc_prestige WHERE sid= %s;", sid), callback)
end

function PC_Leveling.DB.Query(q, callback)
	local query = PC_Leveling.DB.Connection:query(q)

	query.onSuccess = function(q, data)
		if callback then
			callback(data)
		end
	end
	query.onError = function(q, err)
        	MsgC(Color(255, 0 , 0), "[PC_Leveling] MySQL Query failed! \n" )
       	 	MsgC(Color(255, 0 , 0), "[PC_Leveling] Error: ", err .. "\n" )
	end

	query:start()
end

hook.Add("Initialize", "PC_LevelingDBConnection", function()
	MsgC(Color(155, 155 , 155), "[PC_Leveling] Attempting connection to MySQL Database.\n" )
	PC_Leveling.DB:Connect()
end)


hook.Add("PlayerInitialSpawn", "PC_LevelingLoad", function(ply)
	timer.Simple(5, function()
		ply.PC_Leveling = {}
		for k, v in pairs(PC_Leveling.AllSkills) do
			ply:PC_Leveling_Init(k)
			ply:PC_Leveling_SendLevel(k)
			ply:PC_Leveling_SendXP(k)
		end
		--[[PC_Leveling.GetPrestigeFromDB(ply:SteamID64(),function(data)
			if IsValid(data) and istable(data) then
				for k, v in pairs(data) do
					print(data)
				end
			else
				
			end
		end)]]
		PC_Leveling.GetLevelingFromDB(ply:SteamID64(),function(data)
			if data and not table.IsEmpty(data) then
				PrintTable(data)
				for k, v in pairs(data) do
					ply:PC_Leveling_SetXP(v.type,v.xp)
					ply:PC_Leveling_SetLevel(v.type,v.level)
				end
			end
		end)
	end)
end)