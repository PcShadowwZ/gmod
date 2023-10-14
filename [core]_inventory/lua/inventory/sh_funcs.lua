Inventory = Inventory or {}
Inventory.AllItems = Inventory.AllItems or {} 
local meta = FindMetaTable("Player")

function meta:DarkRpChat(nam,col,msg)
	umsg.Start("DarkRpChat", self)
		umsg.String(nam)
		umsg.Vector(Vector(col.r,col.g,col.b))
		umsg.String(msg)
	umsg.End()
	if CLIENT then
		chat.AddText(col,"[" .. nam .. "] ",Color(255,255,255),msg)
	end
end


if CLIENT then
	local self = LocalPlayer()
	local function Chat(um)
		local nam = um:ReadString()
		local vcol = um:ReadVector()
		local col = Color(vcol.x,vcol.y,vcol.z)
		local msg = um:ReadString()
	
		chat.AddText(unpack({col,"[" .. nam .. "] ",Color(255,255,255),msg}))
		chat.PlaySound()
	end
	usermessage.Hook("DarkRpChat", Chat)

end

local function AutoComplete( cmd, stringargs )
	stringargs = string.Trim( stringargs )
	stringargs = string.lower( stringargs )
	stringargs = string.gsub(stringargs,'"',"" )
	local tbl = {}
	for k, v in pairs(Inventory.AllItems) do
		local nick = k
		if string.find( string.lower( nick ), stringargs, 1, true ) then
			nick = cmd .." ".. nick 
			table.insert( tbl, nick )
		end
	end
	return tbl
end

concommand.Add("inv_equip", function( ply, cmd, args )
	if !args or args[1] == "" then
		LocalPlayer():ChatPrint("item doesn't exist")
		return
	end
	local item = table.concat(args, " ")
	if !Inventory.AllItems[item] then 
		LocalPlayer():ChatPrint("item doesn't exist")
	return end
	if !Inventory.Inventory[item] then
		LocalPlayer():ChatPrint("you don't have this item")
		return
	elseif Inventory.Inventory[item] then
		if Inventory.Weps[item] then
			RunConsoleCommand( "inventory_Equip", table.concat(args, " ") )
		elseif Inventory.Cases[item] then
			RunConsoleCommand( "inventory_Open", table.concat(args, " ") )
		else
			RunConsoleCommand( "inventory_Use", table.concat(args, " ") )
		end
	end
end,AutoComplete)




