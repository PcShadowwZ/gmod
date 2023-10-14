if ( CLIENT ) then                                       
    SWEP.Author            = "PcShadowwZ"
    SWEP.Slot            = 1
    SWEP.SlotPos            = 4
    SWEP.ViewModelFOV        = 100
	SWEP.IconLetter			= "x"
end
game.AddParticles("particles/ztm_trashcollector_vfx.pcf")
PrecacheParticleSystem("ztm_air_burst")
PrecacheParticleSystem("ztm_airsuck")
PrecacheParticleSystem("ztm_airsuck_trash")
SWEP.PrintName            = "Trash Collector"
SWEP.Spawnable            = true
SWEP.AdminSpawnable        = false
SWEP.Category = "Other"
SWEP.ViewModel = "models/zerochain/props_trashman/ztm_trashcollector_vm.mdl"
SWEP.WorldModel = "models/zerochain/props_trashman/ztm_trashcollector.mdl"
SWEP.HoldType = "shotgun"
SWEP.Primary.ClipSize = 0
SWEP.Primary.Damage = 0
SWEP.Primary.Ammo = "None"
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = true
SWEP.Secondary.ClipSize        = -1
SWEP.Secondary.DefaultClip    = -1
SWEP.Secondary.Automatic    = false
SWEP.Secondary.Ammo            = "none" 

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
    self.LoopSound = CreateSound(self,"ztm/ztm_airsuck_loop.wav")
    self.NextTrash = CurTime()
end

function SWEP:SetupDataTables()
	self:NetworkVar("Int", 0, "Trash")
	self:NetworkVar("Bool", 1, "IsCollectingTrash")
	if SERVER then
		self:SetTrash(0)
		self:SetIsCollectingTrash(false)
	end
end


function SWEP:PrimaryAttack()
end



function SWEP:SecondaryAttack()
end

function SWEP:Reload()
end



function SWEP:Think()
    if self:GetOwner():KeyDown(IN_ATTACK) then
        if self:GetIsCollectingTrash() then
            self:SendWeaponAnim(ACT_VM_PRIMARYATTACK) 
            self.Owner:SetAnimation(PLAYER_ATTACK1)
            self:CollectTrash()
        end
        if not self:GetIsCollectingTrash() then
            self:EmitSound("ztm/ztm_airsuck_start.wav")
            self:SetIsCollectingTrash(true)
            self.LoopSound:Play()
        end
    else
        if not self:GetIsCollectingTrash() then
            self:SendWeaponAnim(ACT_VM_IDLE)
            self.Owner:SetAnimation(PLAYER_IDLE)
        end
        if self:GetIsCollectingTrash() then
            self:SetIsCollectingTrash(false)
            self:EmitSound("ztm/ztm_airsuck_stop.wav")
            self.LoopSound:Stop()
        end
    end
end

function SWEP:MaxTrash()
    return 500 * math.Clamp(self.Owner:PC_Leveling_GetLevel(5), 0.5, 99999)
end

function SWEP:CollectTrash()
    if self.NextTrash  > CurTime() then return end
    if self:GetTrash() >= self:MaxTrash() then return end
    self.NextTrash = CurTime() + .15
    local tr = util.TraceLine( {
        start = self:GetOwner():EyePos(),
        endpos = self:GetOwner():EyePos() + self:GetOwner():EyeAngles():Forward() * 10000,
        filter = function( ent ) return ( ent:GetClass() == "trash_bag" or ent:GetClass() == "trash_bin" or ent:GetClass() == "trash_pile"  ) end
    } )
    local ent = tr.Entity
    local oldTrash = self:GetTrash()
    if ent:GetPos():Distance(self:GetOwner():GetPos()) < 100 then 
        if tonumber(ent:GetNWInt("Trash", 0)) > 0 then
            ent:SetNWInt("Trash",ent:GetNWInt("Trash",0) - 1)
            self:SetTrash(self:GetTrash() + 1) 
            if ent:GetClass() == "trash_bag" and ent:GetNWInt("Trash",0) <= 0 then
                if SERVER then
                    ent:Remove()
                end
            end
        end
    end
    local newTrash = false
    if self:GetTrash() > oldTrash then
        newTrash = true
    end
    if CLIENT then
        local ve = GetViewEntity()
        if ve:GetClass() == "player" then
            local vm = LocalPlayer():GetViewModel(0)
            if newTrash then
                ParticleEffectAttach("ztm_airsuck_trash", PATTACH_POINT_FOLLOW, vm, 2)
            else
                ParticleEffectAttach("ztm_airsuck", PATTACH_POINT_FOLLOW, vm, 2)
            end
        else
            if newTrash then
                ParticleEffectAttach("ztm_airsuck_trash", PATTACH_POINT_FOLLOW, self, 1)
            else
                ParticleEffectAttach("ztm_airsuck", PATTACH_POINT_FOLLOW, self, 1)
            end
        end
    end
end

function SWEP:Deploy()
	self:SetHoldType(self.HoldType)
    return true
end



function SWEP:Equip()
	self:SetHoldType(self.HoldType)
end



function SWEP:OnRemove()
end

function SWEP:Holster( self )
    return true
end

function SWEP:ShouldDropOnDie()
    return false
end

if CLIENT then
    hook.Add("PostDrawViewModel", "a_PostDrawViewModel_trashcollector", function(viewmodel,player,weapon )
        if IsValid(weapon) and weapon:GetClass() == "trash_collector" and IsValid(viewmodel) then
            local attach = viewmodel:GetAttachment(1)
            if attach then
                local Ang = attach.Ang
                local Pos = attach.Pos
                Ang:RotateAroundAxis(Ang:Forward(),-90)
                local trashAmt = weapon:GetTrash() or 0
                cam.Start3D2D(Pos, Ang, 0.02)
                    draw.RoundedBox(5, -25 ,-50 ,200 , 100, Color(100,150,200,200))
                    draw.SimpleText(trashAmt.."KG / "..weapon:MaxTrash().."KG", "GlobalFont_30", 80, 0,Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                cam.End3D2D()
            end
        end
    end)
end

hook.Add("PlayerButtonDown","Trash_DropBag",function(ply,btn)
    if btn != 109 then return end
    local wep = ply:GetActiveWeapon()
    if wep:GetClass() == "trash_collector" then
        for k, v in pairs(ents.FindByClass("trash_bag")) do
            if v.Owner == ply:SteamID64() then
                ply:DarkRpChat("TRASHMAN",Color(50,150,200), "You Already Have Another Trash Bag Down")
                return
            end
        end
        if wep:GetTrash() > 0  and SERVER then
            local bag = ents.Create("trash_bag")
            bag:SetPos(ply:GetPos() + ply:GetForward() * 50)
            bag.Owner = ply:SteamID64()
            bag:Spawn()
            bag:SetNWInt("Trash", wep:GetTrash())
            wep:SetTrash(0)
        end
    end
end)