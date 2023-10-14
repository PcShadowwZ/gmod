ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Turret"
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

function ENT:SetupDataTables()
    self:NetworkVar("Int", 0, "Element")
    self:NetworkVar("Int", 1, "Level")
    self:NetworkVar("Int", 2, "MaxHealth")
    self:NetworkVar("Bool", 0, "isPolice")
    self:NetworkVar("Entity", 1, "owning_ent")
    self:SetMaxHealth(100)
end

ENT.ElementConfig = {
    [0] = {
        Name = "Normal",
        Level = 1,
        Icon = "",
        Sprite = "",
        Damage = 2,
        OnHit = function(ply)
            
        end,
    },
    [1] = {
        Name = "Cold Shot",
        Level = 2,
        Icon = "candy/turrets/ui/ice",
        Sprite = "candy/turrets/tracer/ice_bullet",
        Damage = 3,
        OnHit = function(ply,turret)
            if (not ply._iceBullet) then
                ply._iceBullet = true
                ply._oldIceSpeed = ply:GetRunSpeed()
                ply._oldIceWalk = ply:GetWalkSpeed()
                ply:SetRunSpeed(ply:GetRunSpeed() / 2)
                ply:SetWalkSpeed(ply:GetWalkSpeed() / 2)
                timer.Remove("IceBullet_" .. ply:EntIndex())
            end

            timer.Create("IceBullet_" .. ply:EntIndex(), 3, 1, function()
                if IsValid(ply) then
                    ply._iceBullet = nil
                    ply:SetRunSpeed(ply._oldIceSpeed)
                    ply:SetWalkSpeed(ply._oldIceWalk)
                    ply._oldIceSpeed = nil
                    ply._oldIceWalk = nil
                else
                    timer.Remove("IceBullet_" .. ply:EntIndex())
                end
            end)
        end,
    },
    [2] = {
        Name = "Bolt Tesla",
        Level = 3,
        Icon = "candy/turrets/ui/lighting",
        Sprite = "candy/turrets/tracer/lighting",
        Damage = 4,
        OnHit = function(ply,turret)
            if (not ply._iceBullet) then
                ply._iceBullet = true
                ply._oldIceSpeed = ply:GetRunSpeed()
                ply._oldIceWalk = ply:GetWalkSpeed()
                ply:SetRunSpeed(ply:GetRunSpeed() / 2)
                ply:SetWalkSpeed(ply:GetWalkSpeed() / 2)
                timer.Remove("IceBullet_" .. ply:EntIndex())
            end

            local dmg = DamageInfo()
            dmg:SetDamage(ply:GetMaxHealth() * .01)
            dmg:SetDamageType(DMG_BURN)
            dmg:SetAttacker(turret)
            dmg:SetInflictor(turret)
            ply:TakeDamageInfo(dmg)

            timer.Create("IceBullet_" .. ply:EntIndex(), 3, 1, function()
                if IsValid(ply) then
                    ply._iceBullet = nil
                    ply:SetRunSpeed(ply._oldIceSpeed)
                    ply:SetWalkSpeed(ply._oldIceWalk)
                    ply._oldIceSpeed = nil
                    ply._oldIceWalk = nil
                else
                    timer.Remove("IceBullet_" .. ply:EntIndex())
                end
            end)
        end
    },
    [3] = {
        Name = "Ember Shot",
        Level = 4,
        Icon = "candy/turrets/ui/fire",
        Sprite = "candy/turrets/tracer/fire",
        Damage = 5,
        OnHit = function(ply,turret)
            if (not ply:IsOnFire()) then
                ply:Ignite(3)
            else
                local dmg = DamageInfo()
                dmg:SetDamage(ply:GetMaxHealth() * .02)
                dmg:SetDamageType(DMG_BURN)
                dmg:SetAttacker(turret)
                dmg:SetInflictor(turret)
                ply:TakeDamageInfo(dmg)
            end
        end,
    },
    [4] = {
        Name = "Toxic Shot",
        Level = 5,
        Icon = "candy/turrets/ui/poison",
        Sprite = "candy/turrets/tracer/venom",
        Damage = 6,
        OnHit = function(ply,turret)
            local dmg = DamageInfo()
            dmg:SetDamage(ply:Health() * .02)
            dmg:SetDamageType(DMG_POISON)
            dmg:SetAttacker(turret)
            dmg:SetInflictor(turret)
            ply:TakeDamageInfo(dmg)
            ply:ScreenFade( SCREENFADE.IN, Color( 150, 255, 75, 100 ), 1.5, .1 )
        end
    },
}
