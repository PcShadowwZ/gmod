AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
SWEP.Weight = 5

--SWEP:Initialize\\
--Tells the script what to do when the player "Initializes" the SWEP.
function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
	self:SetNWInt("CurrentEnt", 1)
end

function SWEP:Deploy()
	self:SendWeaponAnim(ACT_VM_DRAW)
end



function SWEP:PrimaryAttack()
	self.Weapon:SendWeaponAnim(ACT_SLAM_DETONATOR_DETONATE)
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	local tr = self.Owner:GetEyeTrace()
	local ent = tr.Entity
	if self:GetNWInt("CurrentEnt", 1) == 1 then
		for k, v in pairs(ents.FindByClass("power_generator")) do
			if v.Setowning_ent and v:Getowning_ent() == self.Owner then
				self.Owner:ChatPrint("You Already Have A Generator Down.")
				return
			end
		end
		local tr = util.TraceLine( {
            start = self.Owner:EyePos(),
            endpos = self.Owner:EyePos() + self.Owner:EyeAngles():Forward() * 200,
            filter = function( ent ) return ( ent:GetClass() == self.Owner ) end
        } )
		if (not tr.Hit) then return end
		local SpawnPos = tr.HitPos + tr.HitNormal * 4
		local ent = ents.Create("power_generator")
		ent:SetCreator(self.Owner)
		ent:SetPos(SpawnPos)
		ent:Spawn()
		ent:Activate()
		ent:DropToFloor()
		if (ent.Setowning_ent) then
			ent:Setowning_ent(self.Owner)
		end
	else
		local count = 0
		for k, v in pairs(ents.FindByClass("ent_turret")) do
			if v.Setowning_ent and v:Getowning_ent() == self.Owner then
				count = count + 1
			end
		end
		if count > 2 then
			self.Owner:ChatPrint("You Already Have Maxmimum Turrets Down.")
			return
		end
		local tr = util.TraceLine( {
            start = self.Owner:EyePos(),
            endpos = self.Owner:EyePos() + self.Owner:EyeAngles():Forward() * 200,
            filter = function( ent ) return ( ent:GetClass() == self.Owner ) end
        } )
		if (not tr.Hit) then return end
		local SpawnPos = tr.HitPos + tr.HitNormal * 4
		local ent = ents.Create("ent_turret")
		ent:SetCreator(self.Owner)
		ent:SetPos(SpawnPos)
		ent:Spawn()
		ent:Activate()
		ent:DropToFloor()
		if (ent.Setowning_ent) then
			ent:Setowning_ent(self.Owner)
		end
	end

	self:SetNextPrimaryFire(CurTime() + 1)
end

function SWEP:SecondaryAttack()
	self.Weapon:SendWeaponAnim(ACT_SLAM_DETONATOR_DETONATE)
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	if self:GetNWInt("CurrentEnt", 1) == 1 then
		self:SetNWInt("CurrentEnt", 2)
	else
		self:SetNWInt("CurrentEnt", 1)
	end

	self:SetNextSecondaryFire(CurTime() + 1)
end

function SWEP:Reload()
	local tr = util.TraceLine( {
		start = self.Owner:EyePos(),
		endpos = self.Owner:EyePos() + self.Owner:EyeAngles():Forward() * 200,
		filter = function( ent ) return ( ent:GetClass() == "ent_turret" or ent:GetClass() == "power_generator"  ) end
	} )
	if (not tr.Hit) then return end
	if tr.Entity then
		if (tr.Entity.Setowning_ent and tr.Entity:Getowning_ent() == self.Owner) then
			SafeRemoveEntity(tr.Entity)
		end
	end
end

--Tells the script what to do when the player "Initializes" the SWEP.
function SWEP:Equip()
	self:SendWeaponAnim(ACT_VM_DRAW) -- View model animation
	self.Owner:SetAnimation(PLAYER_IDLE) -- 3rd Person Animation
end

function SWEP:ShouldDropOnDie()
	return false
end
