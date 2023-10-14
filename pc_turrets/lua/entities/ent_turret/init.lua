AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/asap/basic_turret.mdl")
    self:SetSolid(SOLID_VPHYSICS)
    self:PhysicsInitStatic(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)
    self:SetMaxHealth(100)
    self:SetHealth(self:GetMaxHealth())
    self:SetLevel(1)
    self:SetElement(0)
    self:SetisPolice(false)
    self:SetAutomaticFrameAdvance(true)
    local phys = self:GetPhysicsObject()
    phys:Wake()

	self:InitMeta()
	self:EmitSound("npc/turret_floor/deploy.wav")
	self.YawMotorThrottle = 0
	self.PitchMotorThrottle = 0
	self.MinTheta = { x = 0, y = 0 }
	self.Collided = false
	self.LastTargetTime = CurTime()
	self.LastShoot = CurTime()
	self.UpdateDelay = self.UpdateDelayLong
	self.Fires = 0
	self.Explored = false
	self.PlanB = false
	self.IdleLoop = CreateSound(self, "npc/turret_wall/turret_loop1.wav")
	self.TurningLoop = CreateSound(self, "npc/turret_floor/retract.wav")
    self.Dead = true
	self.Friendlies = {}
end

function ENT:OnTakeDamage(dmg)
	self:SetHealth(self:Health() - dmg:GetDamage())
    if self:Health() <= 0 then
        self:EmitSound("npc/turret_floor/die.wav")
        self.Dead = true
		if self:GetisPolice() then 
			timer.Simple(120, function()
				self:EmitSound("npc/turret_floor/deploy.wav")
				self.Dead = false
			end)
		end
    end
end


function ENT:Use(ply)
	if self:GetisPolice() then return end
    ply:ConCommand("_turretmenu")
end

local nextAction = CurTime()
local nextHealAction = CurTime()
concommand.Add("_turretupgrade", function(ply,cmd,args)
    local tr = util.TraceLine( {
        start = ply:EyePos(),
        endpos = ply:EyePos() + ply:EyeAngles():Forward() * 200,
        filter = function( ent ) return ( ent:GetClass() == "ent_turret" ) end
    } )
    local ent = tr.Entity
    if ent:GetPos():Distance(ply:GetPos()) > 200 then return end
	if ent:GetisPolice() then return end
    if nextAction <= CurTime() then 
        if ply:canAfford(25000) and ent:GetLevel() < 5 then
            ply:addMoney(-25000)
            ent:SetLevel(ent:GetLevel() + 1)
            ent:SetMaxHealth(ent:GetMaxHealth() + 200)
            ent:SetHealth(ent:GetMaxHealth())
        end
        nextAction = CurTime() + 1
    end
end)
concommand.Add("_turretheal", function(ply,cmd,args)
    local tr = util.TraceLine( {
        start = ply:EyePos(),
        endpos = ply:EyePos() + ply:EyeAngles():Forward() * 200,
        filter = function( ent ) return ( ent:GetClass() == "ent_turret" ) end
    } )
    local ent = tr.Entity
    if ent:GetPos():Distance(ply:GetPos()) > 200 then return end
	if ent:GetisPolice() then return end
    if nextHealAction <= CurTime() then 
        if ply:canAfford(5000) and ent:Health() < ent:GetMaxHealth() then
            ply:addMoney(-5000)
            ent:SetHealth(ent:GetMaxHealth())
			ent:ResetBoneAngles()
        end
        nextHealAction = CurTime() + 30
    end
end)
concommand.Add("_turretelement", function(ply,cmd,args)
    local tr = util.TraceLine( {
        start = ply:EyePos(),
        endpos = ply:EyePos() + ply:EyeAngles():Forward() * 200,
        filter = function( ent ) return ( ent:GetClass() == "ent_turret" ) end
    } )
    local ent = tr.Entity
    if ent:GetPos():Distance(ply:GetPos()) > 200 then return end
	if ent:GetisPolice() then return end
	local element = tonumber(args[1])
	if !ent.ElementConfig[element] then return end
	if ent:GetLevel() < ent.ElementConfig[element].Level then return end
    if nextAction <= CurTime() then 
		ent:SetElement(element)
        nextAction = CurTime() + 1
    end
end)

concommand.Add("_turretbuddies", function(ply, cmd, args)
	local player = player.GetBySteamID64(args[1])
	local adder = tonumber(args[2])
    local tr = util.TraceLine( {
        start = ply:EyePos(),
        endpos = ply:EyePos() + ply:EyeAngles():Forward() * 200,
        filter = function( ent ) return ( ent:GetClass() == "ent_turret" ) end
    } )
    local ent = tr.Entity
    if ent:GetPos():Distance(ply:GetPos()) > 200 then return end
	if ent:GetisPolice() then return end
	if ply != ent:Getowning_ent() then return end
	if !player or !adder then return end
	if adder == 1 then
		if !table.HasValue(ent.Friendlies, player) then
			table.insert(ent.Friendlies, player)
		end
	else
		if table.HasValue(ent.Friendlies, player) then
			table.RemoveByValue(ent.Friendlies, player)
		end
	end
end)

-- TARGETING ------------------------------------------------------------------------------------------------------------------------------------------


local badEnts = {

}

local PoliceWhitelist = {}
timer.Simple(1, function()
    PoliceWhitelist[TEAM_MAYOR] = true
    PoliceWhitelist[TEAM_BANK] = true
    PoliceWhitelist[TEAM_POLICE] = true
    PoliceWhitelist[TEAM_POLICECHIEF] = true
    PoliceWhitelist[TEAM_SWAT] = true
    PoliceWhitelist[TEAM_SWATCHIEF] = true
    PoliceWhitelist[TEAM_SWATSNIPER] = true
    PoliceWhitelist[TEAM_SWATMEDIC] = true
    PoliceWhitelist[TEAM_SHEAVY] = true
    PoliceWhitelist[TEAM_MMEMBER] = true
    PoliceWhitelist[TEAM_MHEAVY] = true
    PoliceWhitelist[TEAM_SUPERS] = true
    PoliceWhitelist[TEAM_MLEADER] = true
    PoliceWhitelist[TEAM_SPECIALMEDIC] = true
    PoliceWhitelist[TEAM_SPECIALFORCE] = true
    PoliceWhitelist[TEAM_SPECIALSNIPER] = true
    PoliceWhitelist[TEAM_POLICEROBOT] = true
    PoliceWhitelist[TEAM_MROBOT] = true
    PoliceWhitelist[TEAM_GUARD] = true
    --PoliceWhitelist[TEAM_STAFFONDUTY] = true
end)

function ENT:IsTargetHostile(ent)
    if !IsValid(ent) then
        return false
    end
	if self:GetisPolice() then 
		if ent:IsPlayer() then
			if PoliceWhitelist[ent:Team()] or ent:isArrested() then
				return false
			else
				return true
			end
		end
		return false
	end
    local ply = self:Getowning_ent()
    if ent == ply then
        return false
    end
    if ent:IsNPC() then
        return true
    end
    if ent:IsPlayer() then
		if ent:Team() == TEAM_STAFFONDUTY then return false end
		local member = ply:GetVFMember()
		if member and member.faction then
			local faction = member.faction
			local facMembers = faction.members
			if table.HasValue(facMembers, ent) then
				return false
			end
		end
		if !table.HasValue(self.Friendlies, ent) then
			return true
		end
    end
    if table.HasValue(badEnts,ent) then
        return true
    end
    return false
end


function ENT:GetTarget()

	local targets = {}

	for k,v in pairs(ents.FindInSphere(self:GetPos(), 150 * self:GetLevel())) do
        if self:IsTargetHostile(v) then
            if v:Health() > 0 then
                if IsValid(self:Getowning_ent()) then
                    local target = { ent = v, health = v:Health(), dist = self:Getowning_ent():GetPos():Distance(v:GetPos()) }
                    table.insert(targets, target)
                else
                    local target = { ent = v, health = v:Health() }
                    table.insert(targets, target)
                end
            end
        end
	end

	if table.Count(targets) > 0 then
		table.SortByMember(targets, "health", true)
		if targets[1].ent:IsLineOfSightClear( self ) then
			self:EmitSound("npc/turret_floor/ping.wav")
			return targets[1].ent
		end
	end
end
------------------------------------------------------------------------------------------------------------------------------------------

--SHOOTING--------------------------------------------------------------------------------------------------------------------------v


function ENT:Shoot(ct, pos, ang)
    if self.LastShoot <= CurTime() then
        local damage = self.ElementConfig[self:GetElement()].Damage * self:GetLevel() 
		if self:GetisPolice() then
			damage = damage * 1.25
		end
		self:MuzzleEffects(pos, ang)
		util.ScreenShake(pos, 0.02 * damage, 0.05 * damage, 0.75, 2)

		local bullet = {}
			bullet.Num 		= 1
			bullet.Src 		= pos			-- Source
			bullet.Dir 		= ang:Forward()			-- Dir of bullet
			bullet.Spread 	= Vector(0, 0, 0)		-- Aim Cone
			bullet.Tracer	= 1									-- Show a tracer on every x bullets
			bullet.Force	= 0							-- Amount of force to give to phys objects
			bullet.Damage	= damage
			bullet.AmmoType = "Pistol"
			bullet.TracerName = "AR2Tracer"
            bullet.Callback	= function(attacker, tracedata, dmginfo)
                local func = self.ElementConfig[self:GetElement()].OnHit
                if (tracedata.Hit and tracedata.Entity) and (tracedata.Entity:IsPlayer() and tracedata.Entity:Alive()) then
                    func(tracedata.Entity,self)
                end
            end

		self.Entity:FireBullets(bullet)

		sound.Play("npc/turret_floor/shoot"..math.random(1,3)..".wav", pos, 100, math.Rand(95,105) * GetConVarNumber("host_timescale"), 1 )

		self.LastShoot = ct + (1 / self:GetLevel())
    end
end

function ENT:MuzzleEffects(p, a)

	local Muzzle_FX = EffectData()
		Muzzle_FX:SetEntity(self.Entity)
		Muzzle_FX:SetOrigin(p)
		Muzzle_FX:SetNormal(a:Forward())
		Muzzle_FX:SetScale(1)
		Muzzle_FX:SetAttachment(2)
	util.Effect("gdcw_tnt_muzzle_cannon", Muzzle_FX)
	local Muzzle_Light = EffectData()
		Muzzle_Light:SetOrigin(p)
		Muzzle_Light:SetScale(1)
	util.Effect("tnt_effect_light", Muzzle_Light)

end


------------------------------------------------------------

function ENT:SpawnFunction(ply, tr, class)
    if (not tr.Hit) then return end
    local SpawnPos = tr.HitPos + tr.HitNormal * 4 - Vector(0,0,5)
    local ent = ents.Create(class)
    ent:SetCreator(ply)
    ent:SetPos(SpawnPos)
    ent:Spawn()
    ent:Activate()
    ent:DropToFloor()
    if (ent.Setowning_ent) then
        ent:Setowning_ent(ply)
    end

    return ent
end


local TargetBoneIndex
local AimPosition_w, AimAngle_w, AimPosition, AimAngle, AngleAimYaw, AngleAimPitch, YawDiff, PitchDiff, newpos, newang
local RecoilBoneIndex, RecoilBonePos, RecoilBoneAng
local AttPos, AttAng
local recoil, back

function ENT:InitMeta()

	self.YawBoneIndex = self.Entity:LookupBone(self.AimYawBone)
	self.PitchBoneIndex = self.Entity:LookupBone(self.AimPitchBone)

	self.YawBonePos = Vector(0, 0, 0)
	self.YawBoneAng = Angle(0, 0, 0)
	self.PitchBonePos= Vector(0, 0, 0)
	self.PitchBoneAng = Angle(0, 0, 0)

	if self.ExPitchBone != nil then
		self.ExPitchBoneIndex = self.Entity:LookupBone(self.ExPitchBone)
	end
	self.ExPitchBonePos = Vector(0, 0, 0)
	self.ExPitchBoneAng = Angle(0, 0, 0)

	self.YawClampDelta = nil
	self.PitchClampDelta = nil

	self.AngularSpeed = Angle(0, 0, 0)
	self.PitchSpeed = Angle(0, 0, 0)

	self.p_AngDiff = { y = 0, p = 0 }
	self.p_YawBoneAng = Angle(0, 0, 0)
	self.p_PitchBoneAng = Angle(0, 0, 0)
	self.p_AngularSpeed = Angle(0, 0, 0)
	self.p_PitchSpeed = Angle(0, 0, 0)

end

function ENT:UpdateTransformation()

	local YawBonePos_w, YawBoneAng_w = self.Entity:GetBonePosition(self.YawBoneIndex)
	local PitchBonePos_w, PitchBoneAng_w = self.Entity:GetBonePosition(self.PitchBoneIndex)
	self.YawBonePos, self.YawBoneAng = self:TranslateCoordinateSystem(YawBonePos_w, YawBoneAng_w)
	self.PitchBonePos, self.PitchBoneAng = self:TranslateCoordinateSystem(PitchBonePos_w, PitchBoneAng_w)
	if self.ExPitchBone != nil then
		local ExPitchBonePos_w, ExPitchBoneAng_w = self.Entity:GetBonePosition(self.ExPitchBoneIndex)
		self.ExPitchBonePos, self.ExPitchBoneAng = self:TranslateCoordinateSystem(ExPitchBonePos_w, ExPitchBoneAng_w)
	end

	self.AngularSpeed = self.YawBoneAng - self.p_YawBoneAng
	self.PitchSpeed = self.PitchBoneAng - self.p_PitchBoneAng

end

function ENT:PostTransformation()

	self.p_YawBoneAng = self.YawBoneAng
	self.p_PitchBoneAng = self.PitchBoneAng
	self.p_AngularSpeed = self.AngularSpeed
	self.p_PitchSpeed = self.PitchSpeed

end

function ENT:TranslateCoordinateSystem(pos, ang)

	newpos, newang = WorldToLocal(pos, ang, self.Entity:GetPos(), self.Entity:GetAngles())

	return newpos, newang
end

function ENT:TurningTurret()
	local boneYaw = self.YawBoneIndex
	local bonePitch = self.PitchBoneIndex
	if (not IsValid(self:GetTarget())) then
		self.IdealAngle = LerpAngle(FrameTime() * 2, self.IdealAngle, Angle(0, self.LastView + math.cos(RealTime() / 2) * 90, 0))
	else
		local target, whatever = self:GetTarget():GetPos() + Vector(0, 0, self:GetTarget():GetModelRadius() / 3) 
		local diff = ((self:GetPos() + self:GetUp() * 20) - target):Angle() --(target + Vector(0, 0, target:GetModelRadius()))
		self.IdealAngle = LerpAngle(FrameTime() * ((self:GetLevel() + 1) * 2), self.IdealAngle, diff)
		self.LastView = self.IdealAngle.y

		local pos , ang = LocalToWorld(Vector(self.PitchBonePos,self.YawBonePos,0), Angle(self.PitchBoneAng, self.YawBoneAng,0), self:GetPos(), self:GetAngles())
		self:Shoot(CurTime(),pos, ang)
	end

	self:ManipulateBoneAngles(boneYaw, Angle(0, -self:GetAngles().y + self.IdealAngle.y + 90, 0))
	self:ManipulateBoneAngles(bonePitch, Angle(-self.IdealAngle.p, 0, 0))
end

function ENT:FindGenerator()
	if !self:GetisPolice() then
		local foundValidGenerator = false
		for k, v in pairs(ents.FindInSphere(self:GetPos(), 500)) do
			if (v:GetClass() == "power_generator") and (v:Getowning_ent() == self:Getowning_ent()) and v:GetPower() > 0 then
				v:SetPower(v:GetPower() - 1)
				foundValidGenerator = true
			end
		end
		return foundValidGenerator
	else
		return true
	end
end

function ENT:ResetBoneAngles()
	self.Entity:ManipulateBoneAngles(self.PitchBoneIndex, Angle(0, 0, 0))
	self.Entity:ManipulateBoneAngles(self.YawBoneIndex, Angle(0, 0, 0))
end

function ENT:Think()
	local CT = CurTime()
	if self:GetAngles().p != 0 or self:GetAngles().r != 0 then
		if !self.Dead then
			self.Dead = true
			self:ResetBoneAngles()
			self:EmitSound("npc/turret_floor/die.wav")
			self.IdealAngle = LerpAngle(FrameTime() * 2, self.IdealAngle, Angle(-30, 0, 0))
			self:ManipulateBoneAngles(self.PitchBoneIndex, Angle(-self.IdealAngle.p, 0, 0))
			self:ManipulateBoneAngles(self.YawBoneIndex, Angle(0, -self:GetAngles().y + self.IdealAngle.y + 90, 0))
			self.TurningLoop:Stop()
			self.IdleLoop:Stop()
		end
		return
	end
	if !self:GetisPolice() then 
		if self:FindGenerator() then
			if self:Health() > 0 and self.Dead then
				self.Dead = false
				self:ResetBoneAngles()
				self:EmitSound("npc/turret_floor/deploy.wav")
			end
		else
			if !self.Dead then
				self.Dead = true
				self:ResetBoneAngles()
				self:EmitSound("npc/turret_floor/die.wav")
			end
		end
	end
    if !self.Dead then
        self:TurningTurret()
		self:UpdateTransformation()
        self:PostTransformation()
		self.IdleLoop:Play()
    else
        self.IdealAngle = LerpAngle(FrameTime() * 2, self.IdealAngle, Angle(-30, 0, 0))
        self:ManipulateBoneAngles(self.PitchBoneIndex, Angle(-self.IdealAngle.p, 0, 0))
        self:ManipulateBoneAngles(self.YawBoneIndex, Angle(0, -self:GetAngles().y + self.IdealAngle.y + 90, 0))
		self.TurningLoop:Stop()
		self.IdleLoop:Stop()
    end

	self:NextThink(CurTime())

	return true
end

function ENT:TurningSound()
	if self.TurningLoop then
		if self.p_AngDiff.y != YawDiff.y then
			self.TurningLoop:Play()
			self.TurningLoop:ChangeVolume(math.Clamp(self.YawMotorThrottle, 0.5, 1))
			self.TurningLoop:ChangePitch(100 * GetConVarNumber("host_timescale"))
		else
			self.TurningLoop:Stop()
		end
	end
end

function ENT:OnRemove()
    if self.TurningLoop then
        self.TurningLoop:Stop()
        self.TurningLoop = nil
    end
	if self.IdleLoop then
		self.IdleLoop:Stop()
		self.IdleLoop = nil
	end
end