-- "addons\\asap-turrets\\lua\\entities\\asap_turret_police.lua"
-- Retrieved by https://github.com/c4fe/glua-steal
AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "ent_turret"
DEFINE_BASECLASS("ent_turret")
ENT.PrintName = "Police Turret"
ENT.Author = "PcShadowwZ"
ENT.Spawnable = true
ENT.Category = "Helix"
ENT.AimYawBone = "Slave_Main"
ENT.AimPitchBone = "Slave_Rotation_Upper"	-- These two bones can be the same bone or different like this one
ENT.ExPitchBone = "Slave_Rotation_Lower"
ENT.AimHeight = 3600	-- The height of the gun
ENT.YawLimitLeft = 0
ENT.YawLimitRight = 0
ENT.PitchLimitUp = 3600
ENT.PitchLimitDown = 3600
ENT.ExistAngle = 90	-- It's 90 in this model
ENT.RecoilBone = "Slave_Barrel"
ENT.ExPitchWeight = 10
ENT.MuzzleAtt = 2
ENT.Dead = false
ENT.IdealAngle = Angle(0,0,0)
ENT.LastView = 0
ENT.Friendlies = {}
if CLIENT then return end

function ENT:Initialize()
    self:SetModel("models/asap/basic_turret.mdl")
    self:SetSolid(SOLID_VPHYSICS)
    self:PhysicsInitStatic(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)
    self:SetMaxHealth(500)
    self:SetHealth(self:GetMaxHealth())
    self:SetLevel(5)
    self:SetElement(math.random(1,4))
    self:SetisPolice(true)
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
    self.Dead = false
end
