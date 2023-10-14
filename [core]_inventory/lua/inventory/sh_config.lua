local meta = FindMetaTable("Player")
Inventory = Inventory or {}
Inventory.AllItems = Inventory.AllItems or {} 
Inventory.Suits = Inventory.Suits or {}
Inventory.Weps = Inventory.Weps or {}
Inventory.CaseItems = Inventory.CaseItems or {}
Inventory.Cases = Inventory.Cases or {}


Inventory.Rarities = {
	[1] = {
		["Name"] = "Common",
		["Color"] = Color(155,155,155),
	},
	[2] = {
		["Name"] = "Uncommon",
		["Color"] = Color(75,255,75),
	},
	[3] = {
		["Name"] = "Rare",
		["Color"] = Color(55,255,255),
	},
	[4] = {
		["Name"] = "Epic",
		["Color"] = Color(255,155,255),
	},
	[5] = {
		["Name"] = "Legendary",
		["Color"] = Color(255,255,55),
	},
	[6] = {
		["Name"] = "Permanent",
		["Color"] = Color(230,20,20),
	},
	[7] = {
		["Name"] = "Divine",
		["Color"] = Color(255,255,75),
	},	
}


Inventory.SpecialHolsterWeps = {
	"gaster_four",
	"gaster_three",
	"gaster_five",
	"gaster_one",
	"gaster_two",
	"tfa_cso_heavenscorcher",
	"tfa_cso_dartpistol_emp",
	"tfa_cso_gungnir",
	"weapon_zerogun",
}

Inventory.InitialSlots = 25

function Inventory.AddNewItemSimple(name,mdl,realMdl,funcs,ent,type,rarity,weight)
	Inventory.AllItems[ent] = {}
	Inventory.AllItems[ent].name = name
	Inventory.AllItems[ent].mdl = mdl
	Inventory.AllItems[ent].realMdl = realMdl
	Inventory.AllItems[ent].funcs = funcs
	Inventory.AllItems[ent].ent = ent
	Inventory.AllItems[ent].type = type
	Inventory.AllItems[ent].rarity = rarity or 1
	Inventory.AllItems[ent].weight = weight or 1
end

--[[	TYPES:
		- SWEP
		- Suit	
		- Entity
]]
		


function Inventory.AddNewItemCustom(data)
	Inventory.AllItems[data.ent] = data
end

function Inventory.AddNewSimpleWeapon(name,mdl,ent,realMdl,rarity,weight)
	Inventory.Weps[ent] = {}
	Inventory.Weps[ent].name = name
	Inventory.Weps[ent].mdl = mdl
	Inventory.Weps[ent].realMdl = realMdl
	Inventory.AddNewItemSimple(name,mdl,realMdl,{ ["Equip"] = function(ply)			
			local weapon = ply:Give(ent)
			local class = ply:GetWeapon(ent)
			local ammotype = class:GetPrimaryAmmoType()
			local ammo = (class.Primary and class.Primary.DefaultClip or 1) * 3
			ply:GiveAmmo(ammo, ammotype)
			ply:SelectWeapon(ent) 
			return true
		end,
		["Drop"] = function(ply)
			if !data then data = {} end
			local trace = {}
			trace.start = ply:EyePos()
			trace.endpos = trace.start + ply:GetAimVector() * 85
			trace.filter = ply
			local tr = util.TraceLine(trace)
			local DroppedItem
			DroppedItem = ents.Create("spawned_weapon")
			DroppedItem:SetWeaponClass(ent)
			DroppedItem:SetModel(Inventory.AllItems[ent].realMdl)
			DroppedItem:SetPos(tr.HitPos+Vector(0,0,5))
			DroppedItem:Spawn()
			DroppedItem:Activate()
			return true
		end
 		},
	ent,"SWEP", rarity, weight)
end

function Inventory.AddNewPermWeapon(name,mdl,ent,realMdl,weight)
	Inventory.Weps[ent] = {}
	Inventory.Weps[ent].name = name
	Inventory.Weps[ent].mdl = mdl
	Inventory.Weps[ent].realMdl = realMdl
	Inventory.Weps[ent].isPerm = true
	Inventory.AddNewItemSimple(name,mdl,realMdl,{ ["Equip"] = function(ply)			
			local weapon = ply:Give(ent)
			local class = ply:GetWeapon(ent)
			local ammotype = class:GetPrimaryAmmoType()
			local ammo = (class.Primary and class.Primary.DefaultClip or 1) * 3
			ply:GiveAmmo(ammo, ammotype)
			ply:SelectWeapon(ent) 
			return false
		end,
		["Add_Perm"] = function(ply)	
			if !ply.permWeps then ply.permWeps = {} end
			if !ply.permWeps[ent] then
				ply.permWeps[ent] = true
				local weapon = ply:Give(ent)
				local class = ply:GetWeapon(ent)
				local ammotype = class:GetPrimaryAmmoType()
				local ammo = (class.Primary and class.Primary.DefaultClip or 1) * 3
				ply:GiveAmmo(ammo, ammotype)
				ply:SelectWeapon(ent) 
				ply:DarkRpChat("INVENTORY", Color(0,150,200), "Gun equiped permanently.")
			else
				ply.permWeps[ent] = nil
				ply:DarkRpChat("INVENTORY", Color(0,150,200), "Removed gun from permanently equiped.")
			end
		end,
 		},
	ent,"SWEP", 6, weight)
end


function Inventory.AddNewSuit(name,mdl,health,armor,speed,jump,bulletres,energyres,isperm,policeonly,equipnoise,dequipnoise,equipfunc,dequipfunc,rarity,weight)
	Inventory.Suits[name] = {}
	Inventory.Suits[name].Health = health
	Inventory.Suits[name].Armor = armor
	Inventory.Suits[name].Speed = speed
	Inventory.Suits[name].Jump = jump
	Inventory.Suits[name].BRes = bulletres
	Inventory.Suits[name].ERes = energyres
	Inventory.Suits[name].Perm = isperm
	Inventory.Suits[name].Esound = equipnoise		
	Inventory.Suits[name].Dsound = dequipnoise
	Inventory.Suits[name].Efunc = equipfunc		
	Inventory.Suits[name].Dfunc = dequipfunc
	Inventory.Suits[name].Police = policeonly
	Inventory.Suits[name].Model = mdl
	Inventory.AddNewItemSimple(name,mdl,mdl,{ 
	["Use"] = function(ply)
		if policeonly and !ply:isCP() then
			ply:DarkRpChat("INVENTORY", Color(0,150,200), "This Item Is Police Only.")
			return false
		end
		if !ply.NextSuitEquip then
			ply.NextSuitEquip = CurTime()
		end
		if !ply.SuitOn then
			if ply.NextSuitEquip > CurTime() then
				local dif = ply.NextSuitEquip - CurTime()
				ply:DarkRpChat("INVENTORY", Color(0,150,200), "You Must Wait "..math.Round(dif).."s To Equip Another Suit.")
				return false
			end
			ply.OldHealth = ply:Health()
			ply.OldMaxHealth = ply:GetMaxHealth()
			ply.OldMaxArmor = ply:GetMaxArmor()
			ply.OldArmor = ply:Armor()	
			ply.OldModel = ply:GetModel()
			ply.OldJumpPower = ply:GetJumpPower()
			ply.OldRunSpeed = ply:GetRunSpeed ()
			ply.OldWalkSpeed = ply:GetWalkSpeed()
			ply:SetHealth( health )
			ply:SetMaxHealth( health )
			ply:SetArmor( armor )
			ply:SetMaxArmor( armor )
			ply:SetWalkSpeed( speed / 1.25 )
			ply:SetRunSpeed( speed )	
			ply.BulletResistance = bulletres 
			ply.EnergyResistance = energyres 
			ply:EmitSound(equipnoise,100,100)
			ply:SetModel(mdl)
			ply.SuitOn = true
			ply.SuitType = name
			ply:SetNWInt("SuitEquipStatus", 0)
			timer.Simple(0.1, function()
				ply:SetNWInt("SuitEquipStatus", 1)
			end)
			ply:SetJumpPower( jump )
			equipfunc(ply)
			if rarity != 6 then
				return true
			else
				return false
			end
		end
	end
	}
	,name,"Suit", rarity, weight)
end
function Inventory.AddNewPermSuit(fakename,name,mdl,health,armor,speed,jump,bulletres,energyres,isperm,policeonly,equipnoise,dequipnoise,equipfunc,dequipfunc,rarity,weight)
	Inventory.Suits[name] = {}
	Inventory.Suits[name].Health = health
	Inventory.Suits[name].Armor = armor
	Inventory.Suits[name].Speed = speed
	Inventory.Suits[name].Jump = jump
	Inventory.Suits[name].BRes = bulletres
	Inventory.Suits[name].ERes = energyres
	Inventory.Suits[name].Perm = isperm
	Inventory.Suits[name].Esound = equipnoise		
	Inventory.Suits[name].Dsound = dequipnoise
	Inventory.Suits[name].Efunc = equipfunc		
	Inventory.Suits[name].Dfunc = dequipfunc
	Inventory.Suits[name].Police = policeonly
	Inventory.Suits[name].Model = mdl
	Inventory.AddNewItemSimple(fakename,mdl,mdl,{ 
	["Use"] = function(ply)
		if policeonly and !ply:isCP() then
			ply:DarkRpChat("INVENTORY", Color(0,150,200), "This Item Is Police Only.")
			return false
		end
		if !ply.NextSuitEquip then
			ply.NextSuitEquip = CurTime()
		end
		if !ply.SuitOn then
			if ply.NextSuitEquip > CurTime() then
				local dif = ply.NextSuitEquip - CurTime()
				ply:DarkRpChat("INVENTORY", Color(0,150,200), "You Must Wait "..math.Round(dif).."s To Equip Another Suit.")
				return false
			end
			ply.OldHealth = ply:Health()
			ply.OldMaxHealth = ply:GetMaxHealth()
			ply.OldMaxArmor = ply:GetMaxArmor()
			ply.OldArmor = ply:Armor()	
			ply.OldModel = ply:GetModel()
			ply.OldJumpPower = ply:GetJumpPower()
			ply.OldRunSpeed = ply:GetRunSpeed ()
			ply.OldWalkSpeed = ply:GetWalkSpeed()
			ply:SetHealth( health )
			ply:SetMaxHealth( health )
			ply:SetArmor( armor )
			ply:SetMaxArmor( armor )
			ply:SetWalkSpeed( speed / 1.25 )
			ply:SetRunSpeed( speed )	
			ply.BulletResistance = bulletres 
			ply.EnergyResistance = energyres 
			ply:EmitSound(equipnoise,100,100)
			ply:SetModel(mdl)
			ply.SuitOn = true
			ply.SuitType = name
			ply:SetNWInt("SuitEquipStatus", 0)
			timer.Simple(0.1, function()
				ply:SetNWInt("SuitEquipStatus", 1)
			end)
			ply:SetJumpPower( jump )
			equipfunc(ply)
			if rarity != 6 then
				return true
			else
				return false
			end
		end
	end
	}
	,name,"Suit", rarity, weight)
end
local caseItems = 0
function Inventory.AddNewCase(name,icon,items,color,sound,rarity)
	Inventory.Cases[name] = {}
	Inventory.Cases[name].Name = name
	Inventory.Cases[name].Items = items
	Inventory.Cases[name].Color = color
	Inventory.Cases[name].Sound = sound
	Inventory.AllItems[name] = {}
	Inventory.AllItems[name].name = name
	Inventory.AllItems[name].mdl = icon
	Inventory.AllItems[name].realMdl = icon
	Inventory.AllItems[name].funcs = {["Open"] = function() end}
	Inventory.AllItems[name].ent = name
	Inventory.AllItems[name].type = "Cases"
	Inventory.AllItems[name].rarity = rarity
	Inventory.AllItems[name].weight = .01
end

function Inventory.RegisterCaseItem(type,name,icon,value,amt,color,rarity)
	caseItems = caseItems + 1
	Inventory.CaseItems[caseItems] = {}
	Inventory.CaseItems[caseItems].Icon = icon
	Inventory.CaseItems[caseItems].Value = value
	Inventory.CaseItems[caseItems].Name = name
	Inventory.CaseItems[caseItems].Type = type
	Inventory.CaseItems[caseItems].Func = function(ply) end
	Inventory.CaseItems[caseItems].Color = color  
	Inventory.CaseItems[caseItems].Rarity = rarity
		
	if type then
		if type == "Money" then
			Inventory.CaseItems[caseItems].Func = function(ply)
				ply:addMoney(value)
			end
		end
		if type == "Credits" then
			Inventory.CaseItems[caseItems].Func  = function(ply)
				mTokens.AddPlayerTokens(ply, value)
			end
		end
		if type == "Weapon" then
			Inventory.CaseItems[caseItems].Func  = function(ply)
				ply:Inventory_Add(value,amt,true,false)
			end
		end
		if type == "Suit" then
			Inventory.CaseItems[caseItems].Func  = function(ply)
				ply:Inventory_Add(value,amt,true,false)
			end
		end
		if type == "InventoryItem" then
			Inventory.CaseItems[caseItems].Func  = function(ply)
				ply:Inventory_Add(value,amt,true,false)
			end
		end
	end	
end

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

function Inventory.UnboxMoneyReward(value, rarity)
	Inventory.RegisterCaseItem("Money",formatMoney(value),"0IpCrnN",value,1,Color(25,255,25), rarity)
end

function Inventory.UnboxCreditsReward(value, rarity)
	Inventory.RegisterCaseItem("Credits",tostring(value).." Credits","BvfOZdD",value,1,color_white, rarity)
end

function Inventory.UnboxWeaponReward(value, amt, rarity)
	Inventory.RegisterCaseItem("Weapon",Inventory.AllItems[value].name,Inventory.AllItems[value].mdl,value,amt,color_white, rarity)
end

function Inventory.UnboxSuitReward(value, amt, rarity)
	Inventory.RegisterCaseItem("Suit", Inventory.AllItems[value].name,Inventory.AllItems[value].mdl,value,amt,color_white, rarity)
end

function Inventory.UnboxItemReward(value, amt, rarity)
	Inventory.RegisterCaseItem("InventoryItem",Inventory.AllItems[value].name,Inventory.AllItems[value].mdl,value,amt,color_white, rarity)
end



---------------------------------------------------
-------------------RELEASE ITEMS-------------------
---------------------------------------------------


Inventory.AddNewSimpleWeapon("Asgore Gaster","models/evangelos/undertale/gasterblaster.mdl","gaster_four","models/evangelos/undertale/gasterblaster.mdl",3,.25)

Inventory.AddNewSimpleWeapon("Frenzy Gaster","models/evangelos/undertale/gasterblaster.mdl","gaster_three","models/evangelos/undertale/gasterblaster.mdl",2,.25)

Inventory.AddNewSimpleWeapon("Logical Gaster","models/evangelos/undertale/gasterblaster.mdl","gaster_five","models/evangelos/undertale/gasterblaster.mdl",3,.25)

Inventory.AddNewSimpleWeapon("Nitro Gaster","models/evangelos/undertale/gasterblaster.mdl","gaster_one","models/evangelos/undertale/gasterblaster.mdl",1,.25)

Inventory.AddNewSimpleWeapon("Nitro V2.0 Gaster","models/evangelos/undertale/gasterblaster.mdl","gaster_two","models/evangelos/undertale/gasterblaster.mdl",2,.25)

Inventory.AddNewSimpleWeapon("Ghostly Drill","models/weapons/tfa_cso/w_magnum_drill_expert_speeds.mdl","tfa_cso_magnumdrill_blinding","models/weapons/tfa_cso/w_magnum_drill_expert_speeds.mdl", 4,.25)


Inventory.AddNewSimpleWeapon("Gungnir","models/weapons/tfa_cso/w_gungnira.mdl","tfa_cso_gungnir_nrm","models/weapons/tfa_cso/w_gungnira.mdl",3,.25)

Inventory.AddNewSimpleWeapon("Gungnir V2","models/weapons/tfa_cso/w_gungnirb.mdl","tfa_cso_gungnir","models/weapons/tfa_cso/w_gungnirb.mdl",4,.25)

Inventory.AddNewSimpleWeapon("Heaven Scorcher","models/weapons/tfa_cso/w_heaven_scorcher.mdl","tfa_cso_heavenscorcher","models/weapons/tfa_cso/w_heaven_scorcher.mdl",4,.25)

Inventory.AddNewSimpleWeapon("Fire Drill","models/weapons/tfa_cso/w_magnum_drill_expert.mdl","tfa_cso_magnumdrill_expert","models/weapons/tfa_cso/w_magnum_drill_expert.mdl",4,.25)

Inventory.AddNewSimpleWeapon("Gold Drill","models/weapons/tfa_cso/w_magnumdrillg.mdl","tfa_cso_magnumdrillg","models/weapons/tfa_cso/w_magnumdrillg.mdl",3,.25)

Inventory.AddNewPermWeapon("☆ Magnum Lancer ☆","models/weapons/tfa_cso/w_magnum_lancer.mdl","tfa_cso_magnum_lancer","models/weapons/tfa_cso/w_magnum_lancer.mdl",2,.25)

Inventory.AddNewSimpleWeapon("Mangum Launcher Expert","models/weapons/tfa_cso/w_magnumlauncher_gs18.mdl","tfa_cso_magnumlauncher_gs18","models/weapons/tfa_cso/w_magnumlauncher_gs18.mdl",4,.25)

Inventory.AddNewSimpleWeapon("Newcomen Expert","models/weapons/tfa_cso/w_newcomen_v6.mdl","tfa_cso_newcomen_v6","models/weapons/tfa_cso/w_newcomen_v6.mdl",2,.25)

Inventory.AddNewSimpleWeapon("Fire Savery","models/weapons/tfa_cso/w_savery_v6.mdl","tfa_cso_savery_v6","models/weapons/tfa_cso/w_savery_v6.mdl",3,.25)

Inventory.AddNewSimpleWeapon("Zero Gun","models/weapons/w_zerogun.mdl","weapon_zerogun","models/weapons/w_zerogun.mdl",5,.25)



Inventory.AddNewSimpleWeapon("Pro Lockpick","models/weapons/w_crowbar.mdl","pro_lockpick","models/weapons/w_crowbar.mdl",1,.25)

Inventory.AddNewSimpleWeapon("Staff Lockpick","models/weapons/w_crowbar.mdl","staff_lockpick","models/weapons/w_crowbar.mdl",3,.25)

Inventory.AddNewSimpleWeapon("Dart Gun - EMP","models/weapons/tfa_cso/w_dartpistol_speeds.mdl","tfa_cso_dartpistol_emp","models/weapons/tfa_cso/w_dartpistol_speeds.mdl",4,.25)

Inventory.AddNewSimpleWeapon("Ghostly Dart Gun","models/weapons/tfa_cso/w_dartpistol_speeds.mdl","tfa_cso_dartpistol_blind","models/weapons/tfa_cso/w_dartpistol_speeds.mdl",4,.25)

--Inventory.AddNewPermWeapon("☆ Magnum Drill Gold ☆","models/weapons/tfa_cso/w_magnumdrillg.mdl","tfa_cso_magnumdrillg","models/weapons/tfa_cso/w_magnumdrillg.mdl",2)

Inventory.AddNewPermWeapon("☆ Magnum Drill ☆","models/weapons/tfa_cso/w_magnum_drill.mdl","tfa_cso_magnumdrill","models/weapons/tfa_cso/w_magnum_drill.mdl",2,.25)


Inventory.AddNewPermWeapon("☆ Thanatos 9 ☆","models/weapons/tfa_cso/w_thanatos_9.mdl","tfa_cso_thanatos9","models/weapons/tfa_cso/w_thanatos_9.mdl",2,.25)

Inventory.AddNewPermWeapon("☆ Dart Pistol ☆","models/weapons/tfa_cso/w_dartpistol.mdl","tfa_cso_dartpistol","models/weapons/tfa_cso/w_dartpistol.mdl",2,.25)


Inventory.AddNewPermWeapon("M2 DEVESTATOR (DONT USE FOR UNBOX SUIT ONLY)","models/weapons/tfa_cso/w_dartpistol.mdl","tfa_cso_m2_devastator","models/weapons/tfa_cso/w_dartpistol.mdl",2,.25)



 



Inventory.AddNewSuit("Juggernaut Suit","models/gonzo/skullsilverjuggernaut/skullsilverjuggernaut.mdl",3000,5000,225,350,40,40,false,false,"nemesis/jug_equip.wav","nemesis/jug_dequip.wav",function(ply) ply:SetGravity( 0.5 ) ply:Give("tfa_cso_m2_devastator") ply:SelectWeapon("tfa_cso_m2_devastator") end,function(ply) ply:SetGravity( 1 ) ply:StripWeapon("tfa_cso_m2_devastator") end, 5, .75)
Inventory.AddNewSuit("Nano Suit","models/nanosuit/nanosuit_male_playermodel.mdl",1600,2000,450,500,20,20,false,false,"nemesis/nano_equip.wav","nemesis/nano_dequip.wav",function(ply)
		if ply:Alive() and ply.invis then
			local wep = ply:GetActiveWeapon()
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
			ply.camoCd = CurTime() + 30
			ply:SetNWBool("CamoCD", CurTime() )
		elseif ply:Alive() and !ply.invis then
			ply.invis = false
			ply:SetNWBool("CamoOn", false)	
		end
	end,function(ply)
		if ply.invis then
			local wep = ply:GetActiveWeapon()
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
			ply.camoCd = CurTime() + 30
			ply:SetNWBool("CamoCD", CurTime() )
		elseif !ply.invis then
			ply.invis = false
			ply:SetNWBool("CamoOn", false)	
		end
end, 5, .75)


Inventory.AddNewSuit("Hunter Suit","models/konnie/asapgaming/destiny2/antiextinction.mdl",1400,1600,350,250,20,20,false,false,"nemesis/pred_on.wav","nemesis/pred_off.wav",function(ply) end,function(ply) end, 5, .75)
Inventory.AddNewSuit("Agility Suit", "models/Timeshift/Beta_suit.mdl",800,1200,600,200,0,0,false,false,"weapons/rc_draw_detonator.wav","weapons/rc_detonate_cut.wav",function(ply) ply:SetNWBool("SpeedBoost", false) end,function(ply) ply:SetNWBool("SpeedBoost", false) end, 5, .75)
Inventory.AddNewSuit("Warfare Suit", "models/arachnit/wolfenstein2/powerarmor/powerarmor_player.mdl",1800,2200,400,250,0,0,false,false,"quantumbreak/blockfield_enter.wav","quantumbreak/blockfield_leave.wav",function(ply) end,function(ply) if ply.bubbleSheild then ply.bubbleSheild:Remove() end end, 5, .75)
Inventory.AddNewSuit("Strife Suit", "models/konnie/asapgaming/destiny2/exigent.mdl",1300,1500,450,200,0,0,false,false,"vehicles/Crane/crane_magnet_switchon.wav","vehicles/crane/crane_extend_stop.wav",function(ply) end,function(ply) end, 5, .75)
Inventory.AddNewSuit("Surge Suit", "models/konnie/asapgaming/destiny2/intrepidexploit.mdl",1000,1200,450,300,0,0,false,false,"quantumbreak/timestop_cast.wav","quantumbreak/timestop_collapse.wav",function(ply) ply.damageSurge = false ply:SetNWBool("DamageBoost", false) end,function(ply) ply.damageSurge = false ply:SetNWBool("DamageBoost", false) end, 5, .75)
Inventory.AddNewSuit("Reverie Suit", "models/konnie/asapgaming/destiny2/crushingset.mdl",1200,2000,400,300,0,0,false,false,"quantumbreak/timerush_cast.wav","quantumbreak/timerush_end.wav",function(ply) 
		ply.warpCount = 1
		ply:SetNWInt("warpCount", ply.warpCount)
		ply:SetWalkSpeed(ply:GetRunSpeed()) 
		ply.timeTags = {}
            	local hookName = "TimeShift_" .. ply:SteamID64()
		local hookName2 = "TimeShiftRegen_" .. ply:SteamID64()
            	ply.timeTags = {}
            	timer.Create(hookName, 1, 0, function()
                	if not IsValid(ply) or not ply:Alive() then
                    		timer.Remove(hookName)
                    		return
                	end
			if ply:GetVelocity():Length() <= 100 then return end
			table.remove(ply.timeTags, 3 )
                	table.insert(ply.timeTags, 1, {ply:GetPos(), ply:GetAngles()})
            	end)
		timer.Create(hookName2, 3, 0, function()
		        if not IsValid(ply) or not ply:Alive() then
                    		timer.Remove(hookName2)
                    		return
                	end
			if ply.warpCount < 3 then
				ply.warpCount = ply.warpCount + 1
				ply:SetNWInt("warpCount", ply.warpCount)
			end	
		end)
end,function(ply)  
		local hookName = "TimeShift_" .. ply:SteamID64()
		local hookName2 = "TimeShiftRegen_" .. ply:SteamID64()
		timer.Remove(hookName)
		timer.Remove(hookName2)
		ply.warpCount = 0
		ply:SetNWInt("warpCount", ply.warpCount)
		ply.timeTags = {}
end, 5, .75)


Inventory.AddNewSuit("Rift Suit","models/konnie/asapgaming/destiny2/gardenofsalvation.mdl",1400,1600,350,250,20,20,false,false,"quantumbreak/stutter_start1.wav","quantumbreak/stutter_collapse.wav",function(ply) end,function(ply) 
		if ply.rifted then
			timer.Remove("LoopRiftSound"..ply:SteamID64())
			ply.riftLoop:Stop()
			ply.riftLoop = nil
			ply.riftEnter = nil
			ply:SetNWBool("EmpOn", false)
			ply.riftStop = CreateSound(ply, "quantumbreak/timevision_cast.wav")
			ply.riftStop:Play()
			ply:SetNWBool("RiftOn", false)
			ply.rifted = false
			ply:SetNoDraw(false)
			ply:SetLaggedMovementValue( 1 )	
			timer.Remove("ForceKeysInRift"..ply:SteamID64())
		end
	end, 5, .75)


Inventory.AddNewSuit("EMP Suit","models/konnie/asapgaming/destiny2/futurefacing.mdl",1400,1600,350,250,20,20,false,false,"wsps/wsps_circut_cast_02.wav","wsps/wsps_deform_hit_01.wav",function(ply) end,function(ply) 
		if !ply.empCharging then return end
		ply.empCharge:Stop()		
		ply.empCharging = false
		ply:SetNWBool("EmpCD", CurTime() + 30)
		ply.empCharge:Stop()	
		timer.Remove("empCharge"..ply:SteamID64())
		ply:SetLaggedMovementValue( 1 )
	end, 5, .75)

Inventory.AddNewPermSuit("Makeshift Suit","Makeshift Suit","models/konnie/asapgaming/destiny2/scatterhorn.mdl",500,500,200,150,20,20,false,false,"npc/combine_soldier/gear5.wav","npc/combine_soldier/gear1.wav",function(ply) end,function(ply) end, 6, 0)



-- unbox items
Inventory.UnboxCreditsReward(20,1) --1
Inventory.UnboxMoneyReward(15000000,2) --2
Inventory.UnboxSuitReward("Juggernaut Suit", 1,5) --3
Inventory.UnboxSuitReward("Nano Suit", 1,5)-- 4
Inventory.UnboxSuitReward("Hunter Suit", 1,5)-- 5
Inventory.UnboxWeaponReward("tfa_cso_magnumdrillg", 1,6)-- 6
Inventory.UnboxWeaponReward("tfa_cso_magnumdrill", 1,6)--7
Inventory.UnboxWeaponReward("gaster_five", 1,3)--8
Inventory.UnboxWeaponReward("gaster_one", 1,1)--9
Inventory.UnboxWeaponReward("gaster_two", 1,2)--10
Inventory.UnboxWeaponReward("gaster_three", 1,2)--11
Inventory.UnboxWeaponReward("gaster_four", 1,3)--12
Inventory.UnboxWeaponReward("gaster_five", 1,3)--13
Inventory.UnboxSuitReward("Agility Suit", 1,5)-- 14
Inventory.UnboxWeaponReward("tfa_cso_dartpistol_emp", 1,4)--15
Inventory.UnboxWeaponReward("tfa_cso_magnumdrill_expert", 1,4)--16
Inventory.UnboxWeaponReward("tfa_cso_savery_v6", 1,3)--17
Inventory.UnboxSuitReward("Strife Suit", 1,5)-- 18
Inventory.UnboxSuitReward("Warfare Suit", 1,5)-- 19
Inventory.UnboxSuitReward("Surge Suit", 1,5)-- 20
Inventory.UnboxSuitReward("Reverie Suit", 1,5)-- 21
Inventory.UnboxWeaponReward("tfa_cso_magnumdrillg", 1,3)--22
Inventory.UnboxWeaponReward("tfa_cso_newcomen_v6", 1,2)--23
Inventory.UnboxWeaponReward("tfa_cso_thanatos9", 1,6)--24
Inventory.UnboxWeaponReward("tfa_cso_dartpistol_blind", 1,4)--25
Inventory.UnboxWeaponReward("tfa_cso_dartpistol", 1,6)--26
Inventory.UnboxWeaponReward("tfa_cso_magnum_lancer", 1,6)--27
Inventory.UnboxWeaponReward("tfa_cso_magnumlauncher_gs18", 1,4)--28
Inventory.UnboxWeaponReward("tfa_cso_gungnir_nrm", 1,3)--29
Inventory.UnboxSuitReward("EMP Suit", 1,5)-- 30
Inventory.UnboxSuitReward("Rift Suit", 1,5)-- 31

Inventory.AddNewCase("Flux Case","lS871XW",{
	[3] = 12,
	[2] = 20,
	[7] = 1,
	[12] = 20,
	[15] = 20,
	[16] = 20,
	[1] = 2,
	[17] = 10,


}, Color(55,155,155), "doors/vent_open2.wav",5)

Inventory.AddNewCase("Scarlet Case","pvoOeOq",{
	[21] = 5,
	[2] = 25,
	[5] = 12,
	[13] = 25,
	[12] = 15,
	[22] = 15,
	[1] = 2,
	[23] = 10,
	[30] = 10,


}, Color(230,70,70), "doors/vent_open2.wav",5)

Inventory.AddNewCase("Azule Case","iiULW7n",{
	[19] = 5,
	[2] = 25,
	[18] = 12,
	[10] = 25,
	[25] = 15,
	[22] = 15,
	[24] = 1,
	[8] = 10,


}, Color(70,30,200), "doors/vent_open2.wav",5)

Inventory.AddNewCase("Blackout Case","sknV5jZ",{
	[14] = 15,
	[2] = 25,
	[20] = 15,
	[10] = 25,
	[28] = 10,
	[29] = 15,
	[26] = 1,
	[27] = 0.05,
	[12] = 10,
	[31] = 5,
}, Color(30,30,30), "doors/vent_open2.wav",5)


Inventory.StarterPackItems = {
	["Agility Suit"] = 5,
	["Surge Suit"] = 5,
	["tfa_cso_newcomen_v6"] = 15,
	["tfa_cso_magnumdrillg"] = 10,
	["tfa_cso_savery_v6"] = 15,
	["gaster_one"] = 15,
	["gaster_two"] = 12,
	["tfa_cso_magnumlauncher_gs18"] = 3,
	["Makeshift Suit"] = 1,
}

Inventory.AddNewItemSimple("Starter Pack","pLaEPkF","pLaEPkF",{["Use"] = function(ply) 
	ply:addMoney(5000000)
	for i = 1,5 do
		local item = Inventory.weightedPick(Inventory.StarterPackItems)
		ply:Inventory_Add(item,1,false,true)
	end
	return true
end},"Starter Pack","Starter Pack",5,0) 

Inventory.AddNewItemSimple("Battle Pass Premium","R0avAob","R0avAob",{["Use"] = function(ply) 
	BATTLEPASS:SetOwned(ply, true)
	net.Start("BATTLEPASS.GivePass")
	net.Send(ply)
	return true
end},"Battle Pass Premium","Battle Pass Premium",5,0) 

Inventory.AddNewItemSimple("Weight Bonus","R0avAob","R0avAob",{["Use"] = function(ply) 
	ply.InventorySlots = ply.InventorySlots + 5
	ply:Inventory_SaveSlots()
	ply:Inventory_SendSlots()
	return true
end},"Weight Bonus","Weight Bonus",5,0) 

Inventory.BoosterCases = {
	["Flux Case"] = true,
	["Blackout Case"] = true,
	["Azule Case"] = true,
	["Scarlet Case"] = true,
}

Inventory.AddNewItemSimple("Booster Pack","rgb08tF","rgb08tF",{["Use"] = function(ply) 
	ply:addMoney(5000000)
	ply:Inventory_Add("Giveaway Token 1",1,false,true)
	ply.InventorySlots = ply.InventorySlots + 10
	ply:Inventory_SaveSlots()
	ply:Inventory_SendSlots()
	return true
end},"Booster Pack","Booster Pack",5,0) 

Inventory.AddNewItemSimple("Scrap","models/props_junk/garbage128_composite001c.mdl","models/props_junk/garbage128_composite001c.mdl",{},"Scrap","Scrap",1,0) 
Inventory.AddNewItemSimple("Giveaway Token 1","6ZJjlgO","6ZJjlgO",{},"Giveaway Token 1","Giveaway Token 1",1,0) 
Inventory.Shop = Inventory.Shop or {}
function Inventory.AddShopItem(cat,name,ent,mdl,cur,price,func,desc)
	Inventory.Shop[ent] = {}
	Inventory.Shop[ent].name = name
	Inventory.Shop[ent].ent = ent
	Inventory.Shop[ent].cat = cat
	Inventory.Shop[ent].mdl = mdl
	Inventory.Shop[ent].cur = cur
	Inventory.Shop[ent].price = price
	Inventory.Shop[ent].func = func
	Inventory.Shop[ent].desc = desc
end

function Inventory.AddShopSuit(name,ent,mdl,cur,price,desc)
	Inventory.AddShopItem("Suits",name,ent,mdl,cur,price,function(ply,amt) ply:Inventory_Add(ent,amt,false,false) end,desc)
end

function Inventory.AddShopGun(name,ent,mdl,cur,price,desc)
	Inventory.AddShopItem("Weapons",name,ent,mdl,cur,price,function(ply,amt) ply:Inventory_Add(ent,amt,false,false) end,desc)
end

function Inventory.AddShopCase(name,ent,mdl,cur,price,desc)
	Inventory.AddShopItem("Cases",name,ent,mdl,cur,price,function(ply,amt) ply:Inventory_Add(ent,amt,false,false) end,desc)
end
function Inventory.AddShopCase(name,ent,mdl,cur,price,desc)
	Inventory.AddShopItem("Cases",name,ent,mdl,cur,price,function(ply,amt) ply:Inventory_Add(ent,amt,false,false) end,desc)
end


Inventory.AddShopCase("Flux Case","Flux Case","lS871XW","Cash",10000000,"The Flux Case contains high tech armor such as the Juggernaut Suit.")
Inventory.AddShopCase("Blackout Case","Blackout Case","sknV5jZ","Cash",15000000,"The Blackout Case contains the most powerful weapon. The Magnum Lancer.")
Inventory.AddShopCase("Azule Case","Azule Case","iiULW7n","Cash",12000000,"The Azule Case contains one of the most offensive armors. The Warfare Suit.")
Inventory.AddShopCase("Scarlet Case","Scarlet Case","pvoOeOq","Cash",12000000,"The Scarlet Case contains the newest time travel tech. The Reverie Suit.")
Inventory.AddShopCase("Booster Pack","Booster Pack","rgb08tF","Credits",500,"$5mill, 10 inventory space and a case of your choice. Also 1 Giveaway Token (Ending Feb)")
Inventory.AddShopItem("Misc","Premium BP","Battle Pass Premium","R0avAob","Credits",1200,function(ply,amt) ply:Inventory_Add("Battle Pass Premium",1,false,false) end,"Gives you premium battlepass")
Inventory.AddShopItem("Misc","Weight Bonus","Weight Bonus","R0avAob","Cash",500000000,function(ply,amt) ply:Inventory_Add("Weight Bonus",1,false,false) end,"Gives you 5 inventory weight")

function Inventory.AddScrapableItem(ent,scrap)
	Inventory.AllItems = Inventory.AllItems or {} 
	Inventory.AllItems[ent].canScrap = true
	Inventory.AllItems[ent].scrapAmt = scrap
end


Inventory.AddScrapableItem("Juggernaut Suit",5)
Inventory.AddScrapableItem("Nano Suit",10)
Inventory.AddScrapableItem("Hunter Suit",5)
Inventory.AddScrapableItem("Agility Suit",3)
Inventory.AddScrapableItem("Strife Suit",5)
Inventory.AddScrapableItem("Warfare Suit",10)
Inventory.AddScrapableItem("Surge Suit",4)
Inventory.AddScrapableItem("Reverie Suit",10)
Inventory.AddScrapableItem("EMP Suit",5)
Inventory.AddScrapableItem("Rift Suit",10)
Inventory.AddScrapableItem("Makeshift Suit",40)
Inventory.AddScrapableItem("gaster_one",1)
Inventory.AddScrapableItem("gaster_two",2)
Inventory.AddScrapableItem("gaster_three",2)
Inventory.AddScrapableItem("gaster_four",3)
Inventory.AddScrapableItem("gaster_five",3)
Inventory.AddScrapableItem("tfa_cso_magnumdrill_blinding",7)
Inventory.AddScrapableItem("tfa_cso_gungnir_nrm",2)
Inventory.AddScrapableItem("tfa_cso_gungnir",3)
Inventory.AddScrapableItem("tfa_cso_heavenscorcher",7)
Inventory.AddScrapableItem("tfa_cso_magnumdrill_expert",4)
Inventory.AddScrapableItem("tfa_cso_magnumdrillg",3)
Inventory.AddScrapableItem("tfa_cso_magnum_lancer",50)
Inventory.AddScrapableItem("tfa_cso_magnumlauncher_gs18",5)
Inventory.AddScrapableItem("tfa_cso_newcomen_v6",2)
Inventory.AddScrapableItem("tfa_cso_savery_v6",3)
Inventory.AddScrapableItem("weapon_zerogun",10)
Inventory.AddScrapableItem("tfa_cso_dartpistol_emp",4)
Inventory.AddScrapableItem("tfa_cso_dartpistol_blind",5)
Inventory.AddScrapableItem("tfa_cso_magnumdrill",15)
Inventory.AddScrapableItem("tfa_cso_thanatos9",20)
Inventory.AddScrapableItem("tfa_cso_dartpistol",25)


--UPDATE 1, DIVINE CASE

Inventory.AddNewPermWeapon("☆ Magnum Shooter ☆","models/weapons/tfa_cso/w_magnum_shooter.mdl","tfa_cso_magnum_shooter","models/weapons/tfa_cso/w_magnum_shooter.mdl",6,.25) 
Inventory.AddNewSimpleWeapon("Divine Blaster","models/weapons/tfa_cso/w_divine_blaster.mdl","tfa_cso_divine_blaster","models/weapons/tfa_cso/w_divine_blaster.mdl",7,.25)
Inventory.AddNewSimpleWeapon("Broad Divine","models/weapons/tfa_cso/w_broad.mdl","tfa_cso_broad","models/weapons/tfa_cso/w_broad.mdl",3,.25)
Inventory.AddNewSimpleWeapon("Divine Lock","models/weapons/tfa_cso/w_flintlock_pistol.mdl","tfa_cso_divinelock","models/weapons/tfa_cso/w_flintlock_pistol.mdl",2,.25) 
Inventory.AddNewSimpleWeapon("Bendita","models/weapons/tfa_cso/w_bendita.mdl","tfa_cso_bendita","models/weapons/tfa_cso/w_bendita.mdl",3,.25)
Inventory.AddNewSimpleWeapon("Holy Bomb","models/weapons/tfa_cso/w_holybomb.mdl","tfa_cso_holybomb","models/weapons/tfa_cso/w_holybomb.mdl",3,.25)
Inventory.AddNewSuit("Divine Suit","models/konnie/asapgaming/destiny2/gardenofsalvation_titan.mdl",2000,2000,250,175,20,20,false,false,"wsps/wsps_freeze_cast_01.wav","wsps/wsps_freeze_hit_01.wav",function(ply) ply.divineHealing = false end,function(ply) ply.divineHealing = false end, 7, .75)

Inventory.AddScrapableItem("tfa_cso_magnum_shooter",75)
Inventory.AddScrapableItem("tfa_cso_divine_blaster",10)
Inventory.AddScrapableItem("tfa_cso_broad",3)
Inventory.AddScrapableItem("tfa_cso_divinelock",2)
Inventory.AddScrapableItem("tfa_cso_bendita",3)
Inventory.AddScrapableItem("tfa_cso_holybomb",1)
Inventory.AddScrapableItem("Divine Suit",10)

Inventory.UnboxSuitReward("Divine Suit", 1,7)-- 32
Inventory.UnboxWeaponReward("tfa_cso_magnum_shooter", 1,6)-- 33
Inventory.UnboxWeaponReward("tfa_cso_divine_blaster", 1,7)-- 34
Inventory.UnboxWeaponReward("tfa_cso_broad", 1,3)-- 35
Inventory.UnboxWeaponReward("tfa_cso_divinelock", 1,2)-- 36
Inventory.UnboxWeaponReward("tfa_cso_bendita", 1,3)-- 37
Inventory.UnboxWeaponReward("tfa_cso_holybomb",1,3)-- 38

Inventory.AddNewCase("Divine Case","gZdWaTG",{
	[32] = 5,
	[33] = 0.001,
	[34] = 5,
	[35] = 25,
	[36] = 25,
	[37] = 25,
	[38] = 25,
}, Color(155,155,55), "wsps/wsps_circut_cast_03.wav",7)

Inventory.AddShopCase("Divine Case","Divine Case","gZdWaTG","Cash",25000000,"[LIMIED TIME] Truly a heavenly deal")