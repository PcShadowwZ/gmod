include("shared.lua")
SWEP.PrintName = "Turret Placer" -- The name of your SWEP
SWEP.Slot = 1
SWEP.SlotPos = 2
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true -- Do you want the SWEP to have a crosshair?

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
end

function SWEP:PrimaryAttack()
	self.Weapon:SendWeaponAnim(ACT_SLAM_DETONATOR_DETONATE)
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self:SetNextPrimaryFire(CurTime() + 1)
end

function SWEP:SecondaryAttack()
	self.Weapon:SendWeaponAnim(ACT_SLAM_DETONATOR_DETONATE)
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self:SetNextSecondaryFire(CurTime() + 1)
end

function SWEP:Deploy()
	self:SendWeaponAnim(ACT_VM_DRAW)
end

function SWEP:Equip()
	self:SendWeaponAnim(ACT_VM_DRAW) -- View model animation
	self.Owner:SetAnimation(PLAYER_IDLE) -- 3rd Person Animation
end

function SWEP:DrawHUD()
	draw.SimpleText("Right Click To Connect, Left Click To Switch Entity Type, Reload To Remove An Entity", "GlobalFont_20", ScrW()/2 + 1, VoidUI.Scale(51), Color(0,0,0), 1, 1)
	draw.SimpleText("Right Click To Connect, Left Click To Switch Entity Type, Reload To Remove An Entity", "GlobalFont_20", ScrW()/2, VoidUI.Scale(50), color_white, 1, 1)
	if self:GetNWInt("CurrentEnt", 1) == 1 then
		draw.SimpleText("Current Entity: Generator", "GlobalFont_30", ScrW()/2 + 1, VoidUI.Scale(81), Color(0,0,0), 1, 1)
		draw.SimpleText("Current Entity: Generator", "GlobalFont_30", ScrW()/2, VoidUI.Scale(80), color_white, 1, 1)
	else
		draw.SimpleText("Current Entity: Turret", "GlobalFont_30", ScrW()/2 + 1, VoidUI.Scale(81), Color(0,0,0), 1, 1)
		draw.SimpleText("Current Entity: Turret", "GlobalFont_30", ScrW()/2, VoidUI.Scale(80), color_white, 1, 1)
	end
	local selfHalo = {}
	local gens = 0
	local turrets = 0
	for k, v in pairs(ents.FindByClass("power_generator")) do
		if v.Setowning_ent and v:Getowning_ent() == LocalPlayer() then
			table.insert(selfHalo, v)
			gens = gens + 1
		end
	end
	for k, v in pairs(ents.FindByClass("ent_turret")) do
		if v.Setowning_ent and v:Getowning_ent() == LocalPlayer() then
			table.insert(selfHalo, v)
			turrets = turrets + 1
		end
	end
	draw.SimpleText("Current Generators: ".. gens, "GlobalFont_30", ScrW()/1.3 + 1, VoidUI.Scale(51), Color(0,0,0), 1, 1)
	draw.SimpleText("Current Generators: ".. gens, "GlobalFont_30", ScrW()/1.3, VoidUI.Scale(50), color_white, 1, 1)
	draw.SimpleText("Current Turrets: ".. turrets, "GlobalFont_30", ScrW()/1.3 + 1, VoidUI.Scale(81), Color(0,0,0), 1, 1)
	draw.SimpleText("Current Turrets: ".. turrets, "GlobalFont_30", ScrW()/1.3, VoidUI.Scale(80), color_white, 1, 1)

	local trace = LocalPlayer():GetEyeTrace()
	if trace.Hit and (trace.Entity:GetClass() == "power_generator" or trace.Entity:GetClass() == "ent_turret") then
		if trace.Entity.Setowning_ent and trace.Entity:Getowning_ent() == LocalPlayer() then
			halo.Add({trace.Entity}, Color(255,0,0), 5, 5, 2)
			table.RemoveByValue(selfHalo, trace.Entity)
		end
	end
	halo.Add(selfHalo, Color(55,255,55), 5, 5, 2)
end