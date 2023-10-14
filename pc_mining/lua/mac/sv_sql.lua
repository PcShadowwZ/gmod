require("mysqloo")
PCMAC = PCMAC or {}
PCMAC.DB = PCMAC.DB or {}
PCMACConfig = PCMACConfig or {}

PCMAC.DB.Config = {
    host = "104.128.72.10",
    username = "u6036_E5turR6Yw5",
    password = "Yt3qCXJr4lHicS4s",
    database = "s6036_helix_gaming",
    port = 3306,
}

function PCMAC.DB:Connect()
    self.Connection = mysqloo.connect( PCMAC.DB.Config.host, PCMAC.DB.Config.username, PCMAC.DB.Config.password, PCMAC.DB.Config.database, PCMAC.DB.Config.port )

    function self.Connection:onConnectionFailed(err)
        MsgC(Color(255, 0 , 0), "[PCMAC] Connection to database failed! \n" )
        MsgC(Color(255, 0 , 0), "[PCMAC] Error: ", err .. "\n" )
		timer.Simple(5, function()
			if not self then return end
			PCMAC.DB:Connect()
		end)
    end

    function self.Connection:onConnected()
        MsgC(Color(0, 255 , 0), "[PCMAC] Database connected \n" )

		PCMAC.DB.Query("CREATE TABLE IF NOT EXISTS pcmac_ores (sid BIGINT, type VARCHAR(20), amt FLOAT, PRIMARY KEY(sid, type))")

    end

    self.Connection:connect()
end


function PCMAC.GetOresFromDB(sid,callback)
	PCMAC.DB.Query(string.format("SELECT * FROM pcmac_ores WHERE sid= %s;", sid), callback)
end


hook.Add("Initialize", "PCMACDBConnection", function()
	MsgC(Color(155, 155 , 155), "[PCMAC] Attempting connection to MySQL Database.\n" )
	PCMAC.DB:Connect()
end)

function PCMAC.DB.Query(q, callback)
	local query = PCMAC.DB.Connection:query(q)

	query.onSuccess = function(q, data)
		if callback then
			callback(data)
		end
	end
	query.onError = function(q, err)
        MsgC(Color(255, 0 , 0), "[PCMAC] MySQL Query failed! \n" )
       	MsgC(Color(255, 0 , 0), "[PCMAC] Error: ", err .. "\n" )
	end

	query:start()
end

hook.Add("PlayerInitialSpawn", "PC_PlayerPCMACLoad", function(ply)
	timer.Simple(5, function()
		ply.PCMACMaterials = {}
		for k, v in pairs(PCMACConfig.Ores) do 
			ply.PCMACMaterials[k] = 0
		end
		ply:RefundUpgrades()
		PCMAC.GetOresFromDB(ply:SteamID64(), function(data)
            if data and not table.IsEmpty(data) then
                for k, v in pairs(data) do
					ply.PCMACMaterials[tostring(v.type)] = tonumber(v.amt)
				end 
			else
                for k, v in pairs(PCMACConfig.Ores) do
					ply:SaveOre(k)
				end 
			end
        end)
		timer.Simple(5, function()
			for k, v in pairs(PCMACConfig.Ores) do 
				ply:SendOre(k)
			end
		end)
	end)
end)