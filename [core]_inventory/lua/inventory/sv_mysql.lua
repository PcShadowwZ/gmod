require("mysqloo")
Inventory = Inventory or {}
Inventory.DB = Inventory.DB or {}

Inventory.DB.Config = {
    host = "51.195.133.62", -- host / ip address
    username = "logicaln_zarp", -- username of mysql user
    password = "xbb;%#^8$@X4", -- password for mysql user
    database = "logicaln_inventory", -- database name
    port = 3306, -- the port innit
}

function Inventory.DB:Connect()
    self.Connection = mysqloo.connect( Inventory.DB.Config.host, Inventory.DB.Config.username, Inventory.DB.Config.password, Inventory.DB.Config.database, Inventory.DB.Config.port )

    function self.Connection:onConnectionFailed(err)
        MsgC(Color(255, 0 , 0), "[Inventory] Connection to database failed! \n" )
        MsgC(Color(255, 0 , 0), "[Inventory] Error: ", err .. "\n" )
	timer.Simple(5, function()
		if not self then return end
		Inventory.db:Connect()
	end)
    end

    function self.Connection:onConnected()
        MsgC(Color(0, 255 , 0), "[Inventory] Database connected \n" )

	Inventory.DB.Query("CREATE TABLE IF NOT EXISTS inventory_items (steamid BIGINT, item VARCHAR(64), amount INT, PRIMARY KEY(steamid, item))")
	Inventory.DB.Query("CREATE TABLE IF NOT EXISTS inventory_permweps (steamid BIGINT, item VARCHAR(64), PRIMARY KEY(item))")
	Inventory.DB.Query("CREATE TABLE IF NOT EXISTS inventory_slots (steamid BIGINT, slots INT, PRIMARY KEY(steamid))")
    end

    self.Connection:connect()
end

hook.Add("Initialize", "InventoryDBConnection", function()
	MsgC(Color(155, 155 , 155), "[Inventory] Attempting connection to MySQL Database.\n" )
	Inventory.DB:Connect()
end)

function Inventory.DB.Query(q, callback)
	local query = Inventory.DB.Connection:query(q)

	query.onSuccess = function(q, data)
		if callback then
			callback(data)
		end
	end
	query.onError = function(q, err)
        	MsgC(Color(255, 0 , 0), "[Inventory] MySQL Query failed! \n" )
       	 	MsgC(Color(255, 0 , 0), "[Inventory] Error: ", err .. "\n" )
	end

	query:start()
end