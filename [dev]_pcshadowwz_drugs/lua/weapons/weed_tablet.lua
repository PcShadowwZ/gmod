if ( CLIENT ) then                                       
    SWEP.Author            = "PcShadowwZ"
    SWEP.Slot            = 1
    SWEP.SlotPos            = 4
    SWEP.ViewModelFOV        = 90
	SWEP.IconLetter			= "x"
end
SWEP.PrintName            = "Weed Tablet"
SWEP.Spawnable            = true
SWEP.AdminSpawnable        = false
SWEP.Category = "Other"
SWEP.ViewModel = "models/zerochain/props_growop2/zgo2_tablet_vm.mdl"
SWEP.WorldModel = "models/zerochain/props_growop2/zgo2_tablet.mdl"
SWEP.HoldType = "camera"
SWEP.IsGluonGun = true
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
    self.NextShoot = CurTime()
end



function SWEP:PrimaryAttack()
    if CLIENT then
        LocalPlayer():ConCommand("_weed_shop")
    end
end



function SWEP:SecondaryAttack()
end

function SWEP:Reload()
end



function SWEP:Think()
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
    concommand.Add("_weed_shop", function()
        if LocalPlayer():GetActiveWeapon():GetClass() != "weed_tablet" then return end
        if IsValid(query) then
			query:Remove()
		end
		query = vgui.Create("PIXEL.Frame")
		query:SetTitle("Weed Shop")
		query:SetSize(PIXEL.Scale(800),PIXEL.Scale(800))
		query:Center()
		query:MakePopup()
    end)
end