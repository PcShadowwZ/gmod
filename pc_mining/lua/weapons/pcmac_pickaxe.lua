if CLIENT then
	SWEP.Slot = 1
	SWEP.SlotPos = 5
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = true
end

PCMACConfig = PCMACConfig or {}
PCMACConfig.Pickaxe = PCMACConfig.Pickaxe or {}
SWEP.PrintName = "Pickaxe"
SWEP.Author = ""
SWEP.Instructions = ""
SWEP.Contact = ""
SWEP.Purpose = ""

SWEP.ViewModelFOV = 85
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/yurie_rustalpha/c-vm-pickaxe.mdl"
SWEP.WorldModel = "models/weapons/yurie_rustalpha/wm-pickaxe.mdl"
SWEP.HoldType = "melee2"

SWEP.UseHands = true

SWEP.Spawnable = true	
SWEP.Category = "Mining"

SWEP.Sound = Sound("physics/wood/wood_box_impact_hard3.wav")

SWEP.Primary.DefaultClip = 9999;
SWEP.Primary.Automatic = true;
SWEP.Primary.ClipSize = 99999;
SWEP.Primary.Ammo = "";
SWEP.Primary.Delay = 1


--[[-------------------------------------------------------
Name: SWEP:Initialize()
Desc: Called when the weapon is first loaded
---------------------------------------------------------]]
function SWEP:Initialize()
	self:UpdateSWEPColour()
	self:SetHoldType(self.HoldType)
	self:SetNWFloat("NextAttack", CurTime())
end

function SWEP:UpdateSWEPColour()
	if( not IsValid( self.Owner ) or self.Owner:GetActiveWeapon() != self ) then return end
	
end

function SWEP:Deploy()
	self:UpdateSWEPColour()
	self:SetHoldType(self.HoldType)
    return true
end

function SWEP:PreDrawViewModel( viewmodel, weapon )
	self:UpdateSWEPColour()
end

if CLIENT then
    local WorldModel = ClientsideModel(SWEP.WorldModel)
    -- Settings...
    WorldModel:SetSkin(1)
    WorldModel:SetNoDraw(true)

    function SWEP:DrawWorldModel()
        local _Owner = self:GetOwner()

        if (IsValid(_Owner)) then
            -- Specify a good position
            local offsetVec = Vector(3, -2, -4)
            local offsetAng = Angle(180, 0, 0)

            local boneid = _Owner:LookupBone("ValveBiped.Bip01_R_Hand") -- Right Hand
            if !boneid then return end

            local matrix = _Owner:GetBoneMatrix(boneid)
            if !matrix then return end

            local newPos, newAng = LocalToWorld(offsetVec, offsetAng, matrix:GetTranslation(), matrix:GetAngles())

            WorldModel:SetPos(newPos)
            WorldModel:SetAngles(newAng)

            WorldModel:SetupBones()
        else
            WorldModel:SetPos(self:GetPos())
            WorldModel:SetAngles(self:GetAngles())
        end

        WorldModel:DrawModel()
    end
end

function SWEP:OnRemove()

end

function SWEP:Holster()

	return true
end


PCMACConfig = PCMACConfig or {}
function SWEP:PrimaryAttack()
	if !self:CanPrimaryAttack() then return end
	if self:GetNWFloat("NextAttack", 0) > CurTime() then return end
	self:SendWeaponAnim( ACT_VM_SWINGMISS )
	local speed = 1
	if SERVER then
		speed = 1
	else
		speed = 1
	end
	self:SetNextPrimaryFire(CurTime() +  (tonumber(PCMACConfig.Pickaxe.delay) - ( speed / 10)))
	self.Owner:GetViewModel():SetPlaybackRate(1 + (speed/3))
	self:EmitSound(Sound("YURIE_RUSTALPHA.Melee.Swing"))
	timer.Simple((self:GetNextPrimaryFire() - CurTime()) / 2, function()
		if !IsValid(self) then return end
		local trace = self.Owner:GetEyeTraceNoCursor()
		if (self.Owner:GetShootPos():Distance(trace.HitPos) <= 64) then
			if (IsValid(trace.Entity)) then
				self:EmitSound("physics/concrete/rock_impact_hard5.wav")	
				if SERVER then
					trace.Entity:TakeDamage(1, self.Owner, self)
				end
				self.Owner:DoAttackEvent()	
			end
		end	
	end)				
end


function SWEP:SecondaryAttack()
end

