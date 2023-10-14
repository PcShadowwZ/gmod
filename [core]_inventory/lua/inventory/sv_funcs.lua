Inventory = Inventory or {}
Inventory.AllItems = Inventory.AllItems or {} 
Inventory.Suits = Inventory.Suits or {}
Inventory.Rarities = Inventory.Rarities or {}
Inventory.Cases = Inventory.Cases or {}
PIXEL = PIXEL or {}
PIXEL.Credits = PIXEL.Credits or {}
PIXEL.Credits.DB = PIXEL.Credits.DB or {}
local meta = FindMetaTable("Player")
util.AddNetworkString( "AddHudEvent" )
util.AddNetworkString( "RemoveHudEvent" )

local function InventoryLog(str)
    local log = os.date("%d.%m.%Y %H:%M:%S - ", os.time()) .. str .. "\n"
    file.Append("inventory_logs.txt", log)
end

hook.Add("PlayerSpawn","NoKbNigga", function( pl )
	if not pl:IsEFlagSet(EFL_NO_DAMAGE_FORCES) then pl:AddEFlags(EFL_NO_DAMAGE_FORCES) end
end)

hook.Add("Think", "ForeverInPain", function()
    for k, v in pairs(player.GetAll()) do
        if v:IsPlayer() then
            v:SetCollisionGroup(COLLISION_GROUP_PASSABLE_DOOR)
            v:SetAvoidPlayers(false)
        end
    end
end)

hook.Add("EntityTakeDamage","SomeKBnigga", function( pl, dmg )
    if pl:IsPlayer() then
        local dir = (pl:GetPos() - dmg:GetAttacker():GetPos()):GetNormalized()
        timer.Simple(0.1, function()
            --Spl:SetLocalVelocity(Vector(0, 0, 0))
            pl:SetVelocity( dir * 100 + Vector(0, 0, 5))
        end)
    end
end)

hook.Add( "EntityTakeDamage", "GodModeOnSOD", function( target, dmginfo )
    if ( target:IsPlayer() and target:Team() == TEAM_STAFF ) then
        return true
    end
end )

function meta:Inventory_CurWeight()
	local weight = 0
	local itemweight
	for k, v in pairs(self.Inventory) do
		itemweight = Inventory.AllItems[k].weight * v
		weight = weight + (itemweight)
	end
	return weight
end


function meta:Inventory_Add(ent,amt,noannounce,checkweight)
	local am = amt or 1
	local weight = tonumber(self.InventorySlots)
	if checkweight then
		local curweight = self:Inventory_CurWeight()
		local itemwieght = Inventory.AllItems[ent].weight * amt
		if (curweight + itemwieght) > weight then
			self:DarkRpChat("INVENTORY", Color(0,150,200), "You need to free up some space in your inventory first.")
			return false
		end
	end
	if self.Inventory[ent] != nil then
		self.Inventory[ent] = self.Inventory[ent]+am
	else 
		self.Inventory[ent] = am 
	end
	if !noannounce then
		self:DarkRpChat("INVENTORY", Color(0,150,200), amt.." "..Inventory.AllItems[ent].name.." added to your inventory.")
	end
	self:Inventory_SaveItem(ent)
	self:Inventory_SendItem(ent)

	InventoryLog(string.format("Added %d %s to inventory of %s[%s]", amt, ent, self:Name(), self:SteamID64()))
	return true
end

function meta:Inventory_Has(ent)
	if self.Inventory[ent] != nil then
		return true
	elseif self.Inventory[ent] == nil then
		return false
	end
end

function meta:Inventory_RemoveItem(ent,amt)
	if self.Inventory[ent] then
		self.Inventory[ent] = self.Inventory[ent] - amt
		if self.Inventory[ent] < 1 then
			self.Inventory[ent] = nil
			self:Inventory_SaveRemoveItem(ent)
		else
			self:Inventory_SaveItem(ent)
		end
		self:Inventory_SendItem(ent)

		InventoryLog(string.format("Removed %d %s from inventory of %s[%s]", amt, ent, self:Name(), self:SteamID64()))
	end
end

function Inventory.weightedPick(tab)
	local sum = 0

	for _, chance in pairs( tab ) do
		sum = sum + chance
	end

	local select = math.random() * sum

	for key, chance in pairs( tab ) do
		select = select - chance
		if select < 0 then return key end
	end
end

util.AddNetworkString( "Inventory_ShowCaseOpening" )
function Inventory.OpenCase(name,ply) 
	local case = Inventory.Cases[name]
	local unboxeditem = Inventory.weightedPick(case.Items)
	local item = Inventory.CaseItems[unboxeditem]
	local rewardFunc = item.Func
	rewardFunc(ply)
	net.Start( "Inventory_ShowCaseOpening" )
		net.WriteString(name)
		net.WriteUInt(unboxeditem,16)
	net.Send(ply)
end


concommand.Add("inventory_Equip", function( ply, cmd, args )
	if !Inventory_CanUse(ply) then 
		ply:DarkRpChat("INVENTORY", Color(0,150,200), "You cant do this right now.")
		return
	end
	local ent = args[1]
	if ply.Inventory[ent] == nil then return end
	if ply:HasWeapon( ply.Inventory[ent] ) then
		ply:DarkRpChat("INVENTORY", Color(0,150,200), "You already have this gun equiped.")
		return
	end
	local func = Inventory.AllItems[ent].funcs.Equip
	if func(ply) then
		ply:Inventory_RemoveItem(ent, 1)
		InventoryLog(string.format("%s[%s] equipped a %s", ply:Name(), ply:SteamID64(), ent))
	end
end)

concommand.Add("inventory_Drop", function( ply, cmd, args )
	if !Inventory_CanUse(ply) then 
		ply:DarkRpChat("INVENTORY", Color(0,150,200), "You cant do this right now.")
		return
	end
	local ent = args[1]
	if ply.Inventory[ent] == nil then return end
	local func = Inventory.AllItems[ent].funcs.Drop
	if func(ply) then
		ply:Inventory_RemoveItem(ent, 1)
		ply:DarkRpChat("INVENTORY", Color(0,150,200), "You dropped a "..Inventory.AllItems[ent].name)
		InventoryLog(string.format("%s[%s] dropped a %s", ply:Name(), ply:SteamID64(), ent))
	end
end)

concommand.Add("inventory_Scrap", function( ply, cmd, args )
	local ent = args[1]
	if !Inventory_CanUse(ply) or !Inventory.AllItems[ent].canScrap then 
		ply:DarkRpChat("INVENTORY", Color(0,150,200), "You cant do this right now.")
		return
	end
	if ply.Inventory[ent] == nil then return end
	ply:DarkRpChat("INVENTORY", Color(0,150,200), "You scraped a "..Inventory.AllItems[ent].name)
	ply:Inventory_RemoveItem(ent, 1)
	ply:Inventory_Add("Scrap",Inventory.AllItems[ent].scrapAmt,false,false)
	InventoryLog(string.format("%s[%s] scrappd a %s", ply:Name(), ply:SteamID64(), ent))
end)

concommand.Add("inventory_Delete", function( ply, cmd, args )
	if !Inventory_CanUse(ply) then 
		ply:DarkRpChat("INVENTORY", Color(0,150,200), "You cant do this right now.")
		return
	end
	local ent = args[1]
	if ply.Inventory[ent] == nil then return end
	ply:DarkRpChat("INVENTORY", Color(0,150,200), "You deleted a slot of "..Inventory.AllItems[ent].name)
	ply:Inventory_RemoveItem(ent, 1)
	InventoryLog(string.format("%s[%s] deleted a %s", ply:Name(), ply:SteamID64(), ent))
end)

concommand.Add("inventory_DeleteAll", function( ply, cmd, args )
	if !Inventory_CanUse(ply) then 
		ply:DarkRpChat("INVENTORY", Color(0,150,200), "You cant do this right now.")
		return
	end
	local ent = args[1]
	if ply.Inventory[ent] == nil then return end
	ply:DarkRpChat("INVENTORY", Color(0,150,200), "You deleted a slot of "..Inventory.AllItems[ent].name)
	InventoryLog(string.format("%s[%s] deleted all %s", ply:Name(), ply:SteamID64(), ent))
	ply:Inventory_RemoveItem(ent, 99999999999999999)
end)

concommand.Add("inventory_Use", function( ply, cmd, args )
	if !Inventory_CanUse(ply) then 
		ply:DarkRpChat("INVENTORY", Color(0,150,200), "You cant do this right now.")
		return
	end
	local ent = args[1]
	if ply.Inventory[ent] == nil then return end
	local func = Inventory.AllItems[ent].funcs.Use
	if func(ply) then
		ply:Inventory_RemoveItem(ent, 1)
		ply:DarkRpChat("INVENTORY", Color(0,150,200), "You used a "..Inventory.AllItems[ent].name)
		if ent == "Booster Pack" then
			local case = args[2]
			ply:Inventory_Add(case, 1, false, true)
		end
		InventoryLog(string.format("%s[%s] used a %s", ply:Name(), ply:SteamID64(), ent))
	end
end)

concommand.Add("inventory_Open", function( ply, cmd, args )
	if !Inventory_CanUse(ply) then 
		ply:DarkRpChat("INVENTORY", Color(0,150,200), "You cant do this right now.")
		return
	end
	local ent = args[1]
	if ply.Inventory[ent] == nil then return end
		ply:DarkRpChat("INVENTORY", Color(0,150,200), "You Opened a "..Inventory.AllItems[ent].name)
	Inventory.OpenCase(ent, ply) 
	ply:Inventory_RemoveItem(ent, 1)
end)

concommand.Add("inventory_Add_Perm", function( ply, cmd, args )
	if !Inventory_CanUse(ply) then 
		ply:DarkRpChat("INVENTORY", Color(0,150,200), "You cant do this right now.")
		return
	end
	local ent = args[1]
	if ply.Inventory[ent] == nil then return end
	if ply:HasWeapon( ply.Inventory[ent] ) then
		ply:DarkRpChat("INVENTORY", Color(0,150,200), "You already have this gun equiped.")
		return
	end
	local func = Inventory.AllItems[ent].funcs["Add_Perm"]
	func(ply) 
end)

concommand.Add("inventory_CustomSort", function( ply, cmd, args )
	local id1 = math.Round(args[1])
	local id2 = math.Round(args[2])
	local item1 = ply.Inventory[id1]
	local item2 = ply.Inventory[id2]
	ply.Inventory[id1] = item2
	ply.Inventory[id2] = item1
end)

concommand.Add("inventory_adminAdd", function( ply, cmd, args )
	if !ply:IsSuperAdmin() then return end
	ply:Inventory_Add("Divine Case",100,false,true)
end)

concommand.Add("Inventory_Gift", function( ply, cmd, args )
	local item = args[1]
	local recipient = player.GetBySteamID64( args[2] )
	if !item then return end
	if !recipient then return end
	if !Inventory.AllItems[item] then return end
	if !ply.Inventory[item] then return end
	if (recipient:Inventory_CurWeight() + Inventory.AllItems[item].weight) > tonumber(recipient.InventorySlots) then
		ply:DarkRpChat("INVENTORY", Color(0,150,200), "That player does't have enough space to take this item.")
		return
	end
	if recipient:Inventory_Add(item,1,true,true) then
		ply:Inventory_RemoveItem(item,1)
		ply:DarkRpChat("INVENTORY", Color(0,150,200), "You gifted "..recipient:Nick().." a "..Inventory.AllItems[item].name)
		recipient:DarkRpChat("INVENTORY", Color(0,150,200), ply:Nick().." gifted you a "..Inventory.AllItems[item].name)
		InventoryLog(string.format("%s[%s] gifted %s[%s] a %s", ply:Name(), ply:SteamID64(), recipient:Name(), recipient:SteamID64(), item))
	end
end)

concommand.Add("inventory_Refund", function( ply, cmd, args )
	if !ply:IsSuperAdmin() then ply:DarkRpChat("INVENTORY", Color(0,150,200), "You aint a superadmin bozo") return end
	if !args then return end
	local target = player.GetBySteamID64( args[1] )
	local ent = tostring(args[2])
	local amt = tonumber(args[3])
	if !target then ply:DarkRpChat("INVENTORY", Color(0,150,200), "nice target retard") return end
	if !ent then ply:DarkRpChat("INVENTORY", Color(0,150,200), "nice entity retard") return end
	if !Inventory.AllItems[ent] then ply:DarkRpChat("INVENTORY", Color(0,150,200), "that item doesnt exist retard") return end
	if !amt then ply:DarkRpChat("INVENTORY", Color(0,150,200), "nice quantity retard") return end
	target:Inventory_Add(ent,amt,false,false)
	ply:ChatPrint(string.format("you refunded %s[%s] %s  %s", target:Name(), target:SteamID64(), amt, ent))
	target:ChatPrint(string.format("%s[%s] refunded you %s  %s", ply:Name(), ply:SteamID64(), amt, ent))
	InventoryLog(string.format("%s[%s] refunded %s[%s] %s  %s", ply:Name(), ply:SteamID64(), target:Name(), target:SteamID64(), amt, ent))
end)


local function formatMoney(n)
    if not n then return "$0" end

    if n >= 1e14 then return "$"..(tostring(n)) end
    if n <= -1e14 then return "-" .. "$"..(tostring(math.abs(n))) end

    local negative = n < 0

    n = tostring(math.abs(n))
    local dp = string.find(n, "%.") or #n + 1

    for i = dp - 4, 1, -3 do
        n = n:sub(1, i) .. "," .. n:sub(i + 1)
    end

    -- Make sure the amount is padded with zeroes
    if n[#n - 1] == "." then
        n = n .. "0"
    end

    return (negative and "-" or "") .. "$"..(n)
end


concommand.Add("inventory_Purchase", function( ply, cmd, args )
	if !args then return end
	if !args[1] then return end
	if !args[2] then return end
	local ent = args[1]
	local amt = math.Round(args[2])
	if !Inventory.Shop[ent] then return end
	local cur = Inventory.Shop[ent].cur
	local price = tonumber(Inventory.Shop[ent].price) * tonumber(amt)
	if amt < 0 then return end
	local prettyShow
	if cur == "Cash" then
		if ply:canAfford(price) then
			ply:addMoney(-price)
		else
			ply:DarkRpChat("SHOP", Color(150,150,0), "You can't afford this")
			return
		end
		prettyShow = formatMoney(price)
	elseif cur == "Credits" then
			if mTokens.CanPlayerAfford(ply, price) then		
				mTokens.TakePlayerTokens(ply, price)
			else
				ply:DarkRpChat("SHOP", Color(150,150,0), "You can't afford this")
				return
			end
			prettyShow = price.." Credits"
	elseif cur == "Scrap" then
		if ply.Inventory["Scrap"] > price then
			ply:Inventory_RemoveItem("Scrap",price)
		else
			ply:DarkRpChat("SHOP", Color(150,150,0), "You can't afford this")
			return
		end
		prettyShow = price.." Scrap"
	end
	local func = Inventory.Shop[ent].func
	func(ply,amt)
	ply:DarkRpChat("SHOP", Color(150,150,0), "You purchased "..amt.." "..Inventory.Shop[ent].name.." for "..prettyShow)
	InventoryLog(string.format("%s[%s] purchased %d %s for %s", ply:Name(), ply:SteamID64(), amt, ent, prettyShow))
end)



function Inventory_CanUse(ply)
	if !ply:Alive() or ply:isArrested() then
		return false
	else
		return true
	end
end

function Inventory_EquipSuit(ply,type,data)
		local suit = Inventory.Suits[type]
		ply:SetHealth( suit.Health )
		ply:SetMaxHealth( suit.Health )
		ply:SetArmor( suit.Armor )
		ply:SetMaxArmor( suit.Armor )
		ply:SetWalkSpeed( suit.Speed / 1.25 )
		ply:SetRunSpeed( suit.Speed )	
		ply.BulletResistance = suit.BRes
		ply.EnergyResistance = suit.ERes
		ply:EmitSound(suit.Esound,100,100)
		ply:SetModel(suit.Model)
		ply.SuitOn = true
		ply.SuitType = type
		ply:SetNWInt("SuitEquipStatus", 0)
		timer.Simple(0.1, function()
			ply:SetNWInt("SuitEquipStatus", 1)
		end)
		ply:SetJumpPower( suit.Jump )
		local efunc = suit.Efunc
		efunc(ply)
end

function Inventory_DequipSuit(ply)
		ply:EmitSound(suit.Dsound,100,100)
		ply:SetHealth(ply.OldHealth) 
		ply:SetMaxHealth(ply.OldMaxHealth)
		ply:SetMaxArmor(ply.OldMaxArmor)
		ply:SetArmor(ply.OldArmor) 
		ply:SetWalkSpeed(ply.OldWalkSpeed) 
		ply:SetRunSpeed(ply.OldRunSpeed) 
		ply:SetJumpPower(ply.OldJumpPower)
		ply:SetModel(ply.OldModel)
		ply.EnergyResistance = 0
		ply.BulletResistance = 0
		ply.SuitType = nil
		local dfunc = suit.Dfunc
		dfunc(ply)
		ply.NextSuitEquip = CurTime() + 5
		ply.SuitOn = false
end

local function HolsterWep(ply,cmd,args)
	if !ply:Alive() then return "" end
	local wep = ply:GetActiveWeapon()
	local Type = wep:GetClass()

      	if (!IsValid(wep) or wep:GetModel() == "") then
        	ply:DarkRpChat("INVENTORY", Color(0,150,200), "Can't holster this gun.")
        	return
      	end

      	local canDrop = hook.Run("canDropWeapon", ply, wep)

      	if (!canDrop) then
        	ply:DarkRpChat("INVENTORY", Color(0,150,200), "Can't holster this gun.")
        	return
      	end

	local weight = tonumber(ply.InventorySlots)
	local curweight = ply:Inventory_CurWeight()
	local itemwieght = Inventory.AllItems[Type].weight 
	if (curweight + itemwieght) > weight then
		ply:DarkRpChat("INVENTORY", Color(0,150,200), "You need to free up some space in your inventory first.")
		return ""
	end

	if Inventory.AllItems[Type] then
		if table.HasValue(Inventory.SpecialHolsterWeps, Type) then
			if !wep.IsHolstering and !timer.Exists(Type.."_HolsterTimer") then
				wep.IsHolstering = true
				wep.HolsterTime = 12
				net.Start( "AddHudEvent" )
					net.WriteString( "Holstering "..Inventory.AllItems[Type].name )
					net.WriteUInt( 3, 16 )
					net.WriteColor( Inventory.Rarities[Inventory.AllItems[Type].rarity].Color, false )
				net.Send(ply)
				timer.Create(Type.."_HolsterTimer", 0.25, 12, function()
					if !wep or !IsValid(wep) then
						timer.Remove(Type.."_HolsterTimer")
						net.Start( "RemoveHudEvent" )
							net.WriteString( "Holstering "..Inventory.AllItems[Type].name )
						net.Send(ply)
						ply:DarkRpChat("INVENTORY", Color(0,150,200), "A holster has failed.")
						return
					end

					wep.HolsterTime = wep.HolsterTime - 1

					if wep.HolsterTime <= 0 then
						if ply:Inventory_Add(Type,1,false,true) then
							ply:StripWeapon(Type)
							ply:DarkRpChat("INVENTORY", Color(0,150,200), "You have holstered your weapon into your inventory.")
							local ammotype = ply:GetActiveWeapon():GetPrimaryAmmoType()
							local ammo = ply:GetAmmoCount(ammotype)
							ply:RemoveAmmo(ammo, ammotype)
							InventoryLog(string.format("%s[%s] holstered a %s", ply:Name(), ply:SteamID64(), Type))
						end
						timer.Remove(Type.."_HolsterTimer")
					end
				end)
			elseif wep.IsHolstering and timer.Exists(Type.."_HolsterTimer") then
				ply:DarkRpChat("INVENTORY", Color(0,150,200), "You are holstering/dropping this already.")
			end
		else
			if ply:Inventory_Add(Type,1,false,true) then
				ply:StripWeapon(Type)
				ply:DarkRpChat("INVENTORY", Color(0,150,200), "You have holstered your weapon into your inventory.")

				local ammotype = ply:GetActiveWeapon():GetPrimaryAmmoType()
				local ammo = ply:GetAmmoCount(ammotype)
				ply:RemoveAmmo(ammo, ammotype)
				InventoryLog(string.format("%s[%s] holstered a %s", ply:Name(), ply:SteamID64(), Type))
			end
		end
	else
			ply:DarkRpChat("INVENTORY", Color(0,150,200), "Can't holster this gun.")
	end
	return ""
end

hook.Add("canDropWeapon", "NoDropPermGuns", function(ply, wep)
	if Inventory.Weps[wep:GetClass()] and Inventory.Weps[wep:GetClass()].isPerm then
		return false
	end
end)


local function HolsterSuit(ply,cmd,args)
	if !ply.SuitOn then return "" end
	if ply.rifted then return end
	local weight = tonumber(ply.InventorySlots)
	local curweight = ply:Inventory_CurWeight()
	local itemwieght = Inventory.AllItems[ply.SuitType].weight 
	if (curweight + itemwieght) > weight then
		ply:DarkRpChat("INVENTORY", Color(0,150,200), "You need to free up some space in your inventory first.")
		return ""
	end

	if !ply:Alive() then return "" end
	if !ply.SuitOn then 
		ply:DarkRpChat("INVENTORY", Color(0,150,200), "You don't have a suit on.")
		return ""
	end
	ply.SuitHolsterTime = 20
	net.Start( "AddHudEvent" )
		net.WriteString( "Holster Suit" )
		net.WriteUInt( 5, 16 )
		net.WriteColor( Inventory.Rarities[Inventory.AllItems[ply.SuitType].rarity].Color, false )
	net.Send(ply)
	timer.Create("HolsterSuit_"..ply:SteamID64(), 0.25, 20, function()
		if !ply.SuitOn or ply.rifted then 
			ply:DarkRpChat("INVENTORY", Color(0,150,200), "Suit Holster Failed.")
			net.Start( "RemoveHudEvent" )
				net.WriteString( "Holster Suit" )
			net.Send(ply)
			timer.Remove("HolsterSuit_"..ply:SteamID64())
		end
		if ply.SuitOn then 
			ply.SuitHolsterTime = ply.SuitHolsterTime - 1
			if ply.SuitHolsterTime <= 0 then
				if Inventory.AllItems[ply.SuitType].rarity != 6 then
					ply:Inventory_Add(ply.SuitType,1)
				end
				InventoryLog(string.format("%s[%s] unequipped a %s", ply:Name(), ply:SteamID64(), ply.SuitType))
				Inventory_DequipSuit(ply,ply.SuitType)
				ply:DarkRpChat("INVENTORY", Color(0,150,200), "You have holstered your suit into your inventory.")
			end
		end	
	end)
	return ""
end

hook.Add( "PlayerSpawn", "Perm_Guns_Equip", function( ply )	
	if !ply.permWeps then ply.permWeps = {} end
	for k, v in pairs(ply.permWeps) do
		if !ply.Inventory[k] then 
			ply.permWeps[k] = nil
			return 
		end
		local weapon = ply:Give(k)
		local class = ply:GetWeapon(k)
		local ammotype = class:GetPrimaryAmmoType()
		local ammo = (class.Primary and class.Primary.DefaultClip or 1) * 3
		ply:GiveAmmo(ammo, ammotype)
	end
end)

hook.Add( "DoPlayerDeath", "Suit_Death_Rips", function( ply, att, dmg )	
	if ply.SuitOn then
		local suittype = ply.SuitType
		Inventory_DequipSuit(ply,ply.SuitType)
		for k, v in pairs(player.GetAll()) do
			if ply == att then	
				v:DarkRpChat("SUIT RIPS", Color(0,150,200), ply:Nick().." Died In A "..suittype)
			else
				v:DarkRpChat("SUIT RIPS", Color(0,150,200), att:Nick().." Killed ".. ply:Nick().." In A "..suittype)
			end
		end
		if ply != att then
			hook.Run("OnSuitRipped", att, ply, suittype)
		end
	end
end)

hook.Add("Initialize", "RipSuits_Hook", function()
    function GAMEMODE:OnSuitRipped(killer, ply, suit) end
end)


DarkRP = DarkRP or {}
timer.Simple(5, function()
	DarkRP.defineChatCommand("holster",HolsterWep)	
	DarkRP.defineChatCommand("invholster",HolsterWep)	
	DarkRP.defineChatCommand("unsuit",HolsterSuit)
	DarkRP.defineChatCommand("dropsuit",HolsterSuit)	
end)


concommand.Add("nanocloak", function( ply, cmd, args )	
if ply:GetModel() == "models/nanosuit/nanosuit_male_playermodel.mdl" then 
	if !ply.camoCd then ply.camoCd = CurTime() end
	if ply:GetModel() == "models/nanosuit/nanosuit_male_playermodel.mdl" then 	
		if ply.camoCd > CurTime() then return end
		ply.camoCd = CurTime() + 60
		ply:SetNWBool("CamoCD", CurTime() + 30)
		ply:SetNWBool("CamoOn", true)
		ply.invis = true
		ply.invisStart = CreateSound(ply, "HL1/fvox/activated.wav")
		ply.invisStart:Play()
		ply:SetMaterial("Models/effects/comball_sphere")
    		local wep = ply:GetActiveWeapon()
    		if wep and IsValid(wep) then
        		wep:SetMaterial("models/effects/vol_light001")
    		end
		local function CheckPlayerStill()
			for k, v in pairs(player.GetAll()) do
				if v.invis == true and v:GetModel() == "models/nanosuit/nanosuit_male_playermodel.mdl" then
					if v:GetVelocity():Length() <= 1 then
						v:SetNoDraw(true)
						v:SetMaterial("")
					else
						v:SetNoDraw(false)
						v:SetMaterial("Models/effects/comball_sphere")
					end
				elseif v.invis == true then
					v:SetNoDraw(false)
					v:SetMaterial("")
				end
			end
		end
		hook.Add("Think","SetPlayerCamoAlpha",CheckPlayerStill)
		hook.Add("PlayerSwitchWeapon", "switchnanosuitthing", function(ply, oldwep, newwep)
	 		if ply:Alive() and ply.invis and ply:GetModel() == "models/nanosuit/nanosuit_male_playermodel.mdl" then
        			if newwep and IsValid(newwep) then
            				newwep:SetMaterial("models/effects/vol_light001")
        			end
        			if oldwep and IsValid(oldwep) then
            				oldwep:SetMaterial("")
        			end
    			end
		end)	
		timer.Simple(30, function()
			if ply:Alive() and ply.invis and ply:GetModel() == "models/nanosuit/nanosuit_male_playermodel.mdl" then
				ply.invis = false
				ply:SetNWBool("CamoOn", false)		
				ply.invisEnd = CreateSound(ply, "HL1/fvox/deactivated.wav")
				ply.invisEnd:Play()
				ply:SetMaterial("")
				ply:SetNoDraw(false)
				if IsValid(wep) then
					wep:SetNoDraw(false)
					wep:SetMaterial("")
				end
				hook.Remove("PlayerSwitchWeapon", "switchnanosuitthing")
				hook.Remove("Think","SetPlayerCamoAlpha")
			end
		end)
	end
end
end)

concommand.Add("speedboost", function( ply, cmd, args )	
	if ply:GetModel() == "models/timeshift/beta_suit.mdl" then 
		local suit = Inventory.Suits["Agility Suit"]
		if !ply.boostCd then ply.boostCd = CurTime() end	
		if ply.boostCd > CurTime() then return end
		ply.boostCd = CurTime() + 30
		ply:SetNWBool("BoostCD", CurTime() + 10)
		ply:SetNWBool("SpeedBoost", true)
		ply:SetRunSpeed(suit.Speed * 1.5)
		ply:SetWalkSpeed((suit.Speed/1.25) * 1.5)
		ply:SetJumpPower(suit.Jump * 1.5)
		ply:EmitSound("weapons/rc_detonate.wav",100,100)
		timer.Simple(10, function()
			if ply:GetModel() == "models/timeshift/beta_suit.mdl" then 
				ply:SetRunSpeed(suit.Speed)
				ply:SetWalkSpeed(suit.Speed/1.25)
				ply:SetJumpPower(suit.Jump)
				ply:SetNWBool("SpeedBoost", false)
			end
		end)
	end
end)

concommand.Add("quantumsheild", function( ply, cmd, args )
    if ply:GetModel() == "models/arachnit/wolfenstein2/powerarmor/powerarmor_player.mdl" then 
        if !ply.sheildCd then ply.sheildCd = CurTime() end
        if ply.sheildCd > CurTime() then return end
        if ply.bubbleSheild then return end
        ply.sheildCd = CurTime() + 40
        ply:SetNWBool("ShieldCD", CurTime() + 10)
        ply.bubbleSheild = ents.Create( "qba_timefreeze" )
        ply.bubbleSheild:SetPos( ply:GetPos() )
        ply.bubbleSheild:SetOwner( ply )
        ply.bubbleSheild:Spawn()
    end
end)

local function DoArc(ArcPos)
	exp = ents.Create( "point_tesla" )
	exp:SetPos( ArcPos )
	exp:SetKeyValue( "m_SoundName", "DoSpark" )
	exp:SetKeyValue( "texture", "spriexp/laserbeam.spr" )
	exp:SetKeyValue( "m_Color", "0 255 0" )
	exp:SetKeyValue("rendercolor", "0 255 0")
	exp:SetKeyValue( "m_flRadius", "256" )
	exp:SetKeyValue( "beamcount_max", "25" )
	exp:SetKeyValue( "thick_min", "2" )
	exp:SetKeyValue( "thick_max", "2" )
	exp:SetKeyValue( "lifetime_min", "0.1" )
	exp:SetKeyValue( "lifetime_max", "0.1" )
	exp:SetKeyValue( "interval_min", "0.1" )
	exp:SetKeyValue( "interval_max", "0.1" )
	exp:Spawn()
	exp:Fire( "DoSpark", "", 0 )
	exp:Fire( "DoSpark", "", 0.05 )
	exp:Fire( "DoSpark", "", 0.1 )
	exp:Fire( "DoSpark", "", 0.15 )
	exp:Fire( "DoSpark", "", 0.2 )
	exp:Fire( "DoSpark", "", 0.25 )
	exp:Fire( "DoSpark", "", 0.3 )
	exp:Fire( "kill", "", 0.3 )
	exp = ents.Create( "env_spark" )
	exp:SetPos( ArcPos )
	exp:SetKeyValue( "magnitude", "5" )
	exp:SetKeyValue( "traillength", "2" )
	exp:SetKeyValue( "spawnflags", "128" )
	exp:Spawn()
	exp:Fire( "SparkOnce", "", 0 )
	exp:Fire( "SparkOnce", "", 0.05 )
	exp:Fire( "SparkOnce", "", 0.1 )
	exp:Fire( "SparkOnce", "", 0.15 )
	exp:Fire( "SparkOnce", "", 0.2 )
	exp:Fire( "SparkOnce", "", 0.25 )
	exp:Fire( "SparkOnce", "", 0.3 )
	exp:Fire( "kill", "", 0.3 )
	exp = ents.Create("info_particle_system")
	exp:SetKeyValue("effect_name", "teleport_lambda_exit")
	exp:SetKeyValue("start_active",tostring(1))
	exp:Spawn()
	exp:Activate()
	exp:SetPos(ArcPos)
	exp:Fire( "kill", "", 0.6 )
end
util.AddNetworkString( "SentStrifeTp" )
util.AddNetworkString( "RemoveStrifeTp" )
concommand.Add("strifeteleport", function( ply, cmd, args )
    if ply:GetModel() == "models/konnie/asapgaming/destiny2/exigent.mdl" then 
        if !ply.stpCd then ply.stpCd = CurTime() end
        if ply.stpCd > CurTime() then return end
	if !ply.stpPos then
		ply.stpPos = ply:GetPos()	
		net.Start("SentStrifeTp")
			net.WriteVector(ply.stpPos)
		net.Send(ply)
		ply:SetNWVector("StrifeTeleportPos", ply.stpPos)
		ply.stpCd = CurTime() + 5
        	ply:SetNWBool("StrifeCD", CurTime() + 5)
		ply:SetNWBool("IsSetTypeForTp", true)
	elseif ply.stpPos then
		ply:SetPos(ply.stpPos)
		DoArc(ply:GetPos())
		ply:EmitSound("BMS_objects/portal/portal_In_0".. math.random( 1, 3 ) .. ".wav",100,100,0.4)
		ply:SetArmor(0)
		ply.stpPos = nil
		net.Start("RemoveStrifeTp")
		net.Send(ply)
		ply.stpCd = CurTime() + 30
        	ply:SetNWBool("StrifeCD", CurTime() + 30)
		ply:SetNWBool("IsSetTypeForTp", false)
	end
    end
end)


concommand.Add("damagesurge", function( ply, cmd, args )
    if ply:GetModel() == "models/konnie/asapgaming/destiny2/intrepidexploit.mdl" then 
		local suit = Inventory.Suits["Surge Suit"]
		if !ply.surgeCd then ply.surgeCd = CurTime() end	
		if ply.surgeCd > CurTime() then return end
		ply.surgeCd = CurTime() + 60
		ply:SetNWBool("SurgeCD", CurTime() + 20)
		ply:SetNWBool("DamageBoost", true)
		ply:EmitSound("weapons/rc_detonate.wav",100,100)
		ply.damageSurge = true
		timer.Simple(20, function()
			if ply.damageSurge then 
				ply.damageSurge = false
				ply:SetNWBool("DamageBoost", false)
			end
		end)
    end
end)

concommand.Add("reverierollback", function( ply, cmd, args )
    if ply:GetModel() == "models/konnie/asapgaming/destiny2/crushingset.mdl" then 
	if !ply.rollbackCd then ply.rollbackCd = CurTime() end	
	if ply.rollbackCd > CurTime() then return end
	if table.Count(ply.timeTags) < 3 then return end
	ply.rollbackCd = CurTime() + 9
	ply:SetNWBool("SurgeCD", CurTime() + 9)
	ply:EmitSound("quantumbreak/timeblast_cast.wav",100,100)
        ply:SetPos(ply.timeTags[3][1])
        ply:SetEyeAngles(ply.timeTags[3][2])
	local ed = EffectData()
	ed:SetOrigin( ply:GetPos() + Vector( 0, 0, 5 ) )
	ed:SetEntity( ply )
	ed:SetScale(1.5)
	util.Effect( "qba_stutter_playerwave", ed, true, true )
    end
end)

concommand.Add("reverielaunch", function( ply, cmd, args )
    if ply:GetModel() == "models/konnie/asapgaming/destiny2/crushingset.mdl" then 
	if !ply.launchCd then ply.launchCd = CurTime() end	
	if ply.launchCd > CurTime() then return end
	if ply:GetVelocity():Length() <= 300 then return end
	if ply.warpCount < 1 then return end
	ply.warpCount = ply.warpCount - 1
	ply:SetNWInt("warpCount", ply.warpCount)
	ply.launchCd = CurTime() + .4
	ply:EmitSound("quantumbreak/timedodge_cast.wav",100,100)
	ply:SetLaggedMovementValue(4)
	timer.Simple(.25, function() 
		ply:SetLaggedMovementValue(1)
		local ed = EffectData()
		ed:SetOrigin( ply:GetPos() + Vector( 0, 0, 5 ) )
		ed:SetEntity( ply )
		ed:SetScale(.5)
		util.Effect( "qba_stutter_playerwave", ed, true, true )
	end)
    end
end)

concommand.Add("jugrocket", function( ply, cmd, args )
	local self = ply:GetActiveWeapon()
	if self:GetClass() != "tfa_cso_m2_devastator" then return end
	if !ply.rocketCd then ply.rocketCd = CurTime() end	
	if ply.rocketCd > CurTime() then return end
	ply.rocketCd = CurTime() + 3
	ply:SetNWBool("RocketCD", CurTime() + 3)
	self:SendViewModelAnim( ACT_VM_SECONDARYATTACK )
	if SERVER then
		local ent = ents.Create( self.Secondary.Ent )
		ent:SetOwner( self.Owner )
		ent:SetPos( self.Owner:GetShootPos() )
		ent:SetAngles( self.Owner:EyeAngles() )
		ent:SetModel( self:GetStat("Secondary.Model") )
		ent:Spawn()
		ent:Activate()
		ent:GetPhysicsObject():SetVelocity( self.Owner:GetAimVector() * self.Secondary.Velocity )
	end
	self:EmitSound( self:GetStat("Secondary.Sound") )
end)


local EmpRadius = 768 
local function EmpSuitActivate(pos)
    	local fx = EffectData()
    	fx:SetOrigin(pos)
    	util.Effect("empsuitexplode", fx)
	for k, v in pairs(ents.FindInSphere(pos, EmpRadius)) do
		if v.IsKeypad then
			v:AccessGranted()
		end
		if v:IsPlayer() then
			v:SetArmor(0)
			if v:GetModel() == "models/nanosuit/nanosuit_male_playermodel.mdl" then
				if v.invis then
					local wep = v:GetActiveWeapon()
					v.invis = false
					v:SetNWBool("CamoOn", false)		
					v.invisEnd = CreateSound(v, "HL1/fvox/deactivated.wav")
					v.invisEnd:Play()
					v:SetMaterial("")
					v:SetNoDraw(false)
					if IsValid(wep) then
						wep:SetNoDraw(false)
						wep:SetMaterial("")
					end
					v.camoCd = CurTime() + 30
					v:SetNWBool("CamoCD", CurTime() )
				end
			end
			if v:GetModel() == "models/konnie/asapgaming/destiny2/gardenofsalvation.mdl" then
				if v.rifted then
					timer.Remove("LoopRiftSound"..v:SteamID64())
					timer.Remove("ForceKeysInRift"..v:SteamID64())
					v.riftLoop:Stop()
					v.riftLoop = nil
					v.riftEnter = nil
					v.riftStop = CreateSound(v, "quantumbreak/timevision_cast.wav")
					v.riftStop:Play()
					v:SetNWBool("RiftOn", false)
					v.rifted = false
					v:SetNoDraw(false)
					v:SetLaggedMovementValue( 1 )
				end
			end
		end
	end	
end

concommand.Add("empsuitactivate", function( ply, cmd, args )	
	if ply:GetModel() == "models/konnie/asapgaming/destiny2/futurefacing.mdl" then 
		if !ply.empCd then ply.empCd = CurTime() end
		if !ply.empCharging then ply.empCharging = false end
		if ply.empCd > CurTime() then return end
		if ply.empCharging then return end
		ply:SetNWBool("EmpCD", CurTime() + 5)
		ply:SetNWBool("EmpOn", true)
		ply.empCharge = CreateSound(ply, "wsps/wsps_rift_loop_02.wav") 
		ply.empCharge:Play()
		ply.empTime = 20
		ply.empCd = CurTime() + 35
		ply.empCharging = true
		timer.Create("empCharge"..ply:SteamID64(), 0.25, 20, function()
		local ed = EffectData()
		ed:SetOrigin( ply:GetPos() + Vector( 0, 0, 40 ) )
		ed:SetEntity(ply)
		ply:SetLaggedMovementValue( 0.1 )
		util.Effect( "qba_stutter_playereffects", ed, true, true )
		ply:SetArmor(ply:Armor() - (ply:Armor()/200))
			if !ply.SuitOn or !ply:Alive() then
				ply.empCharging = false
				timer.Remove("empCharge"..ply:SteamID64())
				ply:SetNWBool("EmpCD", CurTime() + 30)
				ply.empCharge:Stop()
				ply:SetNWBool("EmpOn", false)
				ply:SetLaggedMovementValue( 1 )
			end
			if ply.SuitOn and ply.empCharging then
				ply.empTime = ply.empTime - 1
				if ply.empTime <= 0 then
					ply.empCharge:Stop()		
					ply.empCharging = false
					ply:SetNWBool("EmpOn", false)
					timer.Remove("empCharge")
					ply:SetNWBool("EmpCD", CurTime() + 30)
					ply.empCharge:Stop()	
					timer.Remove("empCharge"..ply:SteamID64())
					EmpSuitActivate(ply:GetPos())
					ply:EmitSound("quantumbreak/timeblast_blast.wav", 100 )
					ply:SetLaggedMovementValue(1 )
				end
			end
		end)
	end
end)


concommand.Add("riftshift", function( ply, cmd, args )	
	if ply:GetModel() != "models/konnie/asapgaming/destiny2/gardenofsalvation.mdl" then return end	
	if !ply.riftCd then ply.riftCd = CurTime() end
	if !ply.rifted then ply.rifted = false end
	if ply.riftCd > CurTime() then return end
	ply.riftCd = CurTime() + 5
	ply:SetNWBool("RiftCD", CurTime() + 5)
	if !ply.rifted then
		ply:SelectWeapon( "keys" )
		ply:SetNWBool("RiftOn", true)
		ply.rifted = true
		ply.riftEnter = CreateSound(ply, "quantumbreak/stutter_start2.wav") 
		ply.riftLoop = CreateSound(ply, "quantumbreak/stutter_loop_hard.wav") 
		ply.riftLoop:Play()
		ply.riftEnter:Play()
		ply:SetLaggedMovementValue( 0.4 )
		timer.Create("ForceKeysInRift"..ply:SteamID64(), 1, 0, function()
			ply:SelectWeapon( "keys" )
			if ply:Health() > 21 then
				ply:SetHealth(ply:Health() - 10)
			end
			if ply:Armor() > 11 then
				ply:SetArmor(ply:Armor() - 5)
			end
		end)
		timer.Create("LoopRiftSound"..ply:SteamID64(), 20, 0, function()
			ply.riftLoop:Stop()
			ply.riftLoop = CreateSound(ply, "quantumbreak/stutter_loop_hard.wav") 
			ply.riftLoop:Play()
		end)
		local function CheckPlayerRift()
			for k, v in pairs(player.GetAll()) do
				if v.rifted == true and v:GetModel() == "models/konnie/asapgaming/destiny2/gardenofsalvation.mdl" then
					v:SetNoDraw(true)
				end
			end
		end
		hook.Add("Think","SetPlayerFullInvis",CheckPlayerRift)
		ply:SelectWeapon( "keys" )
		hook.Add( "PlayerSwitchWeapon", "RiftNoSwitch", function( ply, oldWeapon, newWeapon )
			if ply.rifted then
				ply:SelectWeapon( "keys" )
				return true
			end
		end)
	elseif ply.rifted then
		timer.Remove("ForceKeysInRift"..ply:SteamID64())
		timer.Remove("LoopRiftSound"..ply:SteamID64())
		ply.riftLoop:Stop()
		ply.riftLoop = nil
		ply.riftEnter = nil
		ply.riftStop = CreateSound(ply, "quantumbreak/timevision_cast.wav")
		ply.riftStop:Play()
		ply:SetNWBool("RiftOn", false)
		ply.rifted = false
		ply:SetLaggedMovementValue( 1 )
		ply:SetNoDraw(false)
	end
end)




hook.Add( "KeyPress", "keypress_use_hi", function( ply, key )
	if ( key == IN_SPEED ) then
		ply:ConCommand("reverielaunch")
	end
end )


local bguns = {
}
local eguns = {
	"arccw_gluon",
}
hook.Add( "EntityTakeDamage", "Suit_Resistance", function( ply, dmg )
	local att = dmg:GetAttacker()
	if att.damageSurge then
		dmg:SetDamage(dmg:GetDamage() * 1.5)
	end
	if ply.SuitOn then
		if ply.BulletResistance then
			if table.HasValue(bguns, att:GetActiveWeapon()) then
				dmg:SetDamage(dmg:GetDamage() / (1 + (ply.BulletResistance/100)) )
			end
		end
		if ply.EnergyResistance then
			if table.HasValue(eguns, att:GetActiveWeapon()) then
				dmg:SetDamage(dmg:GetDamage() / (1 + (ply.EnergyResistance/100)) )
			end
		end
	end
end)

hook.Add( "EntityTakeDamage", "Damage_Surge", function( ply, dmg )
	local att = dmg:GetAttacker()
	if att.damageSurge then
		dmg:SetDamage(dmg:GetDamage() * 1.5)
	end
end)

hook.Add( "EntityTakeDamage", "NoJugExplo", function( ply, dmg )
	if ply:GetModel() == "models/gonzo/skullsilverjuggernaut/skullsilverjuggernaut.mdl" and dmg:IsExplosionDamage() then
		--dmg:SetDamage(dmg:GetDamage() * 0.4) 
	end
end)


hook.Add( "EntityTakeDamage", "NoRiftDamage", function( ply, dmg )
	if ply.rifted and ply:Health() > 100 then
		dmg:SetDamage(0) 
	end
end)


hook.Add( "OnDamagedByExplosion", "MyEarsDontBleedAnymore", function( ply, dmg )
	return true
end)

hook.Add( "Think", "Divine_Heal", function( ply, dmg )
	for k, v in pairs(player.GetAll()) do
		if v:GetModel() == "models/konnie/asapgaming/destiny2/gardenofsalvation_titan.mdl" then 
			if v:GetVelocity():Length() <= 120 and v:OnGround() then
				v:SetNWBool("DivineIsHealing", true)
				v.divineHealing = true
				if !v.nextDivineHeal then v.nextDivineHeal = CurTime() end
				if v.nextDivineHeal < CurTime() then 
				v.nextDivineHeal = CurTime() + 1.5
				local member = v:GetVFMember()
				if member and member.faction then
					local faction = member.faction
					local facMembers = faction.members
					for l, i in ipairs(facMembers) do
						if (!IsValid(i.ply)) then continue end
						if i.ply:GetPos():DistToSqr(v:GetPos()) < 32500 then
							if i.ply:Health() < i.ply:GetMaxHealth() and i.ply:Health() + 100 < i.ply:GetMaxHealth() then
								i.ply:SetHealth(i.ply:Health() + 100)
							else
								i.ply:SetHealth(i.ply:GetMaxHealth())
							end
							if i.ply:Armor() < i.ply:GetMaxArmor() and i.ply:Armor() + 125 < i.ply:GetMaxArmor() then
								i.ply:SetArmor(i.ply:Armor() + 125)
							else
								i.ply:SetArmor(i.ply:GetMaxArmor())
							end
						end
					end
				else				
					if v:Health() < v:GetMaxHealth() and v:Health() + 100 < v:GetMaxHealth() then
						v:SetHealth(v:Health() + 100)
					else
						v:SetHealth(v:GetMaxHealth())
					end
					if v:Armor() < v:GetMaxArmor() and v:Armor() + 125 < v:GetMaxArmor() then
						v:SetArmor(v:Armor() + 125)
					else
						v:SetArmor(v:GetMaxArmor())
					end
				end
				local ed = EffectData()
				ed:SetOrigin( v:GetPos() + Vector( 0, 0, 5 ) )
				ed:SetEntity( v )
				ed:SetScale(.5)
				util.Effect( "qba_stutter_frozenfire", ed, true, true )
				local sound = math.random(1,2)
				v:EmitSound("wsps/wsps_charge_hit_0"..sound..".wav", 50)
			else
				if v.nextDivineHeal < CurTime() then 
					v.nextDivineHeal = CurTime() + 2
				end
			end
			else
			
				v:SetNWBool("DivineIsHealing", false)
				v.divineHealing = false
			end
		end
	end
end)

hook.Add( "EntityTakeDamage", "Divine_DamageResistance", function( ply, dmg )
	if ply.divineHealing then
		dmg:SetDamage(dmg:GetDamage() * 1.5)
	end
end)

hook.Add( "PlayerInitialSpawn", "GiveStarterPack", function( ply )
	timer.Simple(7, function()
		if ply:GetPData( "GivenStarterPack", false ) == false  then	
			ply:DarkRpChat("INVENTORY", Color(0,150,200), "First Join Starter Pack Given, Hope You Enjoy Your Stay.")
			ply:Inventory_Add("Starter Pack",1,false,true)
			ply:SetPData( "GivenStarterPack", true )
		end
	end)
end )


SHARED:
Inventory.Crafting = Inventory.Crafting or {}
function Inventory.RegisterCraftingItem(class,items)
	Inventory.Crafting[class] = items
end
Inventory.RegisterCraftingItem("weapon_gluongun",{
	["Money"] = 100000
	["Supercharged Uranium"] = 1
})

SERVER: 
Inventory.Crafting = Inventory.Crafting or {}
concommand.Add("craft", function(ply,cmd,args)
	item = args[1]
	if not Inventory.Crafting[item] then return end
	materialsNeeded = Inventory.Crafting[item]
	canCraft = true
	for k, v in pairs(materialsNeeded) do 
		if k == "Money" then
			if not ply:canAfford(v) then
				canCraft = false
			end
		elseif ply.Inventory[item] < v then
			canCraft = false
		end
	end
	if canCraft then
		for k, v in pairs(materialsNeeded) do 
			if k == "Money" then
				ply:addMoney(-v)
			else
				ply:Inventory_RemoveItem(k,v)
			end
		end
		if ply:Inventory_Add(item,1,true,true) then
			ply:DarkRpChat("INVENTORY", Color(0,150,200), "You crafted a "..Inventory.AllItems[item].name)
			InventoryLog(string.format("%s[%s] crafted a %s", ply:Name(), ply:SteamID64(), item))
		else
			ply:DarkRpChat("INVENTORY", Color(0,150,200), "You don't have enough weight")
		end
	else
		ply:DarkRpChat("INVENTORY", Color(0,150,200), "You do not meet requirements to craft this")
	end
end)