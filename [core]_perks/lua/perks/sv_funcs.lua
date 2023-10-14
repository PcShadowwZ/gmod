perksconfig = perksconfig or {}
hook.Add("Think", "Perks_ThinkHook", function()
	for k, ply in pairs(player.GetAll()) do
    		if !ply:Alive() then return end
    		if !ply:GetActiveWeapon() then return end
    		local wep = ply:GetActiveWeapon()
    		if ply.InfAmmo then
				if !table.HasValue(perksconfig.noInfAmmoGuns, ply:GetActiveWeapon():GetClass()) then 
					if wep:Clip1() < wep:GetMaxClip1() then
    					wep:SetClip1(wep:GetMaxClip1())
					end
				end
    		end
		if ply.DoubleTap then
			if !table.HasValue(perksconfig.noRpmChangeGuns, wep:GetClass()) then 
				if !wep:GetNWBool("DoubleTapped", false) then		
					wep:SetNWBool("DoubleTapped", false)
				end
				if !wep:GetNWBool("DoubleTapped", false) then
					if string.StartWith(wep:GetClass(), "tfa") then
						wep:SetStatRawL("Primary.RPM",  wep:GetStatRawL("Primary.RPM") * perksconfig.rpmIncrease  )
						wep:SetNWBool("DoubleTapped", true)
					end
					if wep.Primary and wep.Primary.RPM then
						wep.Primary.RPM = wep.Primary.RPM * perksconfig.rpmIncrease
						wep:SetNWBool("DoubleTapped", true)
					end	
					if wep.Primary and wep.Primary.Delay then
						wep.Primary.Delay = wep.Primary.Delay / perksconfig.rpmIncrease	
						wep:SetNWBool("DoubleTapped", true)
					end
					if wep.Delay then
						wep.Delay = wep.Delay / perksconfig.rpmIncrease
						wep:SetNWBool("DoubleTapped", true)
					end
				end
			end
		end
	end
end)

function GetWeightedRandomKey( tab )
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

hook.Add("EntityTakeDamage", "Perks_DamageHook", function(ply,dmg)	
    	if dmg:GetAttacker():IsPlayer() and IsValid(ply) and IsValid(dmg:GetAttacker()) and dmg:GetAttacker().MoreDamage then
        	dmg:ScaleDamage(1 + (tonumber( perksconfig.damageIncrease ) /100))
    	end
    	if dmg:GetAttacker():IsPlayer() and IsValid(ply) and IsValid(dmg:GetAttacker()) and ply.ThickSkin then
        	dmg:ScaleDamage(1 - (tonumber( perksconfig.defenceIncrease ) /100))
    	end
end)

hook.Add( "PlayerShouldTakeDamage", "Perks_UrbanEvasion", function( ply, att )
	if att:IsPlayer() and IsValid(ply) and IsValid(att) and ply.UrbanEvasion then
		local chances = {
			["TakeDamage"] = 100 - perksconfig.dodgeChance,
			["TakeNoDamage"] = perksconfig.dodgeChance
		}
		local choice = GetWeightedRandomKey(chances)
		if choice == "TakeNoDamage" then
			return false
		end
	end
end )
	

hook.Add("PlayerDeath", "Perks_LooseOnDeath", function(ply)
    	if ply.InfAmmo then
       		ply:ChatPrint("{blue [Perks]} You Lost Your " .. perksconfig.types["Free Fire"].Name .. " Perk")
    	end
    	if ply.MoreDamage then
        	ply:ChatPrint("{blue [Perks]} You Lost Your " .. perksconfig.types["Head Drama"].Name .. " Perk")
    	end
    	if ply.PrinterPower then
       		ply:ChatPrint("{blue [Perks]} You Lost Your " .. perksconfig.types["Printer Power"].Name .. " Perk")
    	end
    	if ply.ThickSkin then
        	ply:ChatPrint("{blue [Perks]} You Lost Your " .. perksconfig.types["Thick Skin"].Name .. " Perk")
    	end
    	if ply.DoubleTap then
        	ply:ChatPrint("{blue [Perks]} You Lost Your " .. perksconfig.types["Double Tap"].Name .. " Perk")
    	end
    	if ply.UrbanEvasion then
        	ply:ChatPrint("{blue [Perks]} You Lost Your " .. perksconfig.types["Urban Evasion"].Name .. " Perk")
    	end
    	ply.InfAmmo = false
    	ply.MoreDamage = false
	ply.ThickSkin = false
	ply.PrinterPower = false
	ply.DoubleTap = false
	ply.UrbanEvasion = false
end)

concommand.Add("perks_buy", function( ply, cmd, args )
   	local type = args[1]
    	if !perksconfig.types[type] then 
        	ply:ChatPrint("{blue [Perks]} This Perk Does Not Exist")
        	return
   	end
    	if !ply:canAfford(perksconfig.types[type].Cost) then 
        	ply:ChatPrint("{blue [Perks]} You Cant Afford This Perk")
        	return 
    	end
    	if type == "Free Fire" then	
		if ply.InfAmmo then
			ply:ChatPrint("{blue [Perks]} You Already Have This Perk")
			return
		end
        	ply.InfAmmo = true
		ply:addMoney(-perksconfig.types[type].Cost)
		ply:ChatPrint("{blue [Perks]} You Purchased A "..perksconfig.types[type].Name..", Infinite Ammo")
    	end
    	if type == "Head Drama" then
		if ply.MoreDamage then
			ply:ChatPrint("{blue [Perks]} You Already Have This Perk")
			return
		end
        	ply.MoreDamage = true
		ply:addMoney(-perksconfig.types[type].Cost)
		ply:ChatPrint("{blue [Perks]} You Purchased A "..perksconfig.types[type].Name..", "..perksconfig.damageIncrease.."% More Damage.")
   	end
    	if type == "Printer Power" then	
		if ply.PrinterPower then
			ply:ChatPrint("{blue [Perks]} You Already Have This Perk")
			return
		end
        	ply.PrinterPower = true
		ply:addMoney(-perksconfig.types[type].Cost)
		ply:ChatPrint("{blue [Perks]} You Purchased A "..perksconfig.types[type].Name..", 1.5x Printer Money When Withdrawing")
    	end
    	if type == "Thick Skin" then	
		if ply.ThickSkin then
			ply:ChatPrint("{blue [Perks]} You Already Have This Perk")
			return
		end
        	ply.ThickSkin = true
		ply:addMoney(-perksconfig.types[type].Cost)
		ply:ChatPrint("{blue [Perks]} You Purchased A "..perksconfig.types[type].Name..", "..perksconfig.defenceIncrease.."% Less Damage Taken.")
    	end
    	if type == "Double Tap" then	
		if ply.DoubleTap then
			ply:ChatPrint("{blue [Perks]} You Already Have This Perk")
			return
		end
        	ply.DoubleTap = true
		ply:addMoney(-perksconfig.types[type].Cost)
		ply:ChatPrint("{blue [Perks]} You Purchased A "..perksconfig.types[type].Name..", "..perksconfig.rpmIncrease.."x More Firerate.")
    	end
    	if type == "Urban Evasion" then	
		if ply.UrbanEvasion then
			ply:ChatPrint("{blue [Perks]} You Already Have This Perk")
			return
		end
        	ply.UrbanEvasion = true
		ply:addMoney(-perksconfig.types[type].Cost)
		ply:ChatPrint("{blue [Perks]} You Purchased A "..perksconfig.types[type].Name..", "..perksconfig.dodgeChance.."% Chance To Dodge Damage.")
    	end
end)


concommand.Add("_gobblegumstacking", function( ply, cmd, args )
	if !ply:IsSuperAdmin() then return end
    ply.InfAmmo = true
    ply.MoreDamage = true
	ply.ThickSkin = true
	ply.PrinterPower = true
	ply.DoubleTap = true
	ply.StaminUp = true
	ply.UrbanEvasion = true
	ply.SilkTouch = true
end)