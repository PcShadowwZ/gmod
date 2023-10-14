Inventory = Inventory or {}
Inventory.DB = Inventory.DB or {}
Inventory.AllItems = Inventory.AllItems or {} 
Inventory.Suits = Inventory.Suits or {}
Inventory.Weps = Inventory.Weps or {}

local meta = FindMetaTable( "Player" )
util.AddNetworkString("Inventory_SendData")
util.AddNetworkString("Inventory_SendItems")
util.AddNetworkString("Inventory_SendItem")
util.AddNetworkString("Inventory_SendSlots")

function Inventory.GetInventoryFromDB(userid,callback)
	Inventory.DB.Query(string.format("SELECT * FROM inventory WHERE userid= %s;", userid), callback)
end

hook.Add("PlayerInitialSpawn", "InventoryLoad", function(ply)
	local sid = ply:SteamID64()

	ply.Inventory = {}
	ply.permWeps = {}

	Inventory.DB.Query(string.format("SELECT * FROM inventory_items WHERE steamid='%s'", sid), function(data)
		if data and not table.IsEmpty(data) then
			for _, column in pairs(data) do
				ply.Inventory[column.item] = column.amount
			end
			ply:Inventory_SendItems()
		end
	end)

	Inventory.DB.Query(string.format("SELECT * FROM inventory_permweps WHERE STEAMID='%s'", sid), function(data)
		if data and not table.IsEmpty(data) then
			for _, column in pairs(data) do
				table.insert(ply.permWeps, column.item)
			end
		end
	end)

	Inventory.DB.Query(string.format("SELECT * FROM inventory_slots WHERE steamid='%s'", sid), function(data)
		if data and not table.IsEmpty(data) then
			ply.InventorySlots = tonumber(data[1].slots)
			ply:Inventory_SendSlots()
		else
			ply.InventorySlots = Inventory.InitialSlots
			ply:Inventory_SaveSlots()
			ply:Inventory_SendSlots()
		end
	end)
end)

function meta:Inventory_SendItems()
	local json = util.TableToJSON(self.Inventory)
	local comp = util.Compress(json)
	net.Start("Inventory_SendItems")
		net.WriteUInt(#comp, 16)
		net.WriteData(comp, #comp)
	net.Send(self)
end

function meta:Inventory_SendItem(ent)
	net.Start("Inventory_SendItem")
		net.WriteString(ent)
		net.WriteUInt(self.Inventory[ent] or 0, 16)
	net.Send(self)
end

function meta:Inventory_SendSlots()
	local slots = self.InventorySlots
	net.Start("Inventory_SendSlots")
		net.WriteUInt(slots, 16)
	net.Send(self)
end

function meta:Inventory_SaveItem(item)
	local sid = self:SteamID64()
	local amt = self.Inventory[item]
	Inventory.DB.Query(string.format("REPLACE INTO inventory_items VALUES ('%s', '%s', '%d')", sid, item, amt))
end

function meta:Inventory_SaveAllItems()
	for k, v in pairs(self.Inventory) do
		self:Inventory_SaveItem(k)
	end
end

function meta:Inventory_SaveRemoveItem(item)
	local sid = self:SteamID64()
	Inventory.DB.Query(string.format("DELETE FROM inventory_items WHERE steamid='%s' AND item='%s'", sid, item))
end

function meta:Inventory_SavePerm(item)
	local sid = self:SteamID64()
	Inventory.DB.Query(string.format("REPLACE INTO inventory_permweps VALUES ('%s', '%s')", sid, item))
end

function meta:Inventory_SaveAllPerms()
	for _, v in pairs(self.permWeps) do
		self:Inventory_SavePerm(v)
	end
end

function meta:Inventory_SaveSlots()
	local sid = self:SteamID64()
	local slots = self.InventorySlots
	Inventory.DB.Query(string.format("REPLACE INTO inventory_slots VALUES ('%s', '%d')", sid, slots))
end

concommand.Add("inventory_save", function( ply, cmd, args )
	ply:Inventory_SaveAllItems()
	ply:Inventory_SaveAllPerms()
	ply:Inventory_SaveSlots()

	ply:Inventory_SendItems()
	ply:Inventory_SendSlots()
end)