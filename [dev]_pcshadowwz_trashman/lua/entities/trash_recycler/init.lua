AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
local coolDown = {}
local function SetTrashVariablePrice()
    SetGlobalInt("Trash_Price_Multiplier", math.random(50,150))
end
SetTrashVariablePrice()
timer.Create("Trash_ChangePrices", 3600, 0, function()
    SetTrashVariablePrice()
end)
function ENT:Initialize()
    self:SetModel("models/zerochain/props_trashman/ztm_recycler.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)
    self:SetNWInt("Trash", 0)
    self:SetNWInt("MaxTime", 0)
    self:SetNWFloat("Time", CurTime())
    self:SetNWInt("State", 0)
    self:SetNWInt("curPlyID", 0)
    self.Sound1 = CreateSound(self, "ztm/ztm_conveyorbelt_loop.wav")
    self.Sound2 = CreateSound(self, "ztm/ztm_recycler_grind.wav")
    self.Sound3 = CreateSound(self, "ztm/ztm_recycler_trashfall.wav")
    self.NextTouch = CurTime()
    local phys = self:GetPhysicsObject()
    phys:Wake()
end

function ENT:Touch(entity)
    if self.NextTouch > CurTime() then return end
    self.NextTouch = CurTime() + .25
    if entity:GetClass() == "trash_bag" then
        self:SetNWInt("Trash", self:GetNWInt("Trash", 0) + entity:GetNWInt("Trash", 0))
        entity:Remove()
    end
end

function ENT:OnRemove()
    self.Sound1:Stop()
    self.Sound2:Stop()
    self.Sound3:Stop()
end

function ENT:Use(activator, caller)
    activator:ConCommand("_trash_recycler_open")
end

concommand.Add("_trash_recycle", function(ply, cmd, args)
    local tr = util.TraceLine( {
        start = ply:EyePos(),
        endpos = ply:EyePos() + ply:EyeAngles():Forward() * 10000,
        filter = function( ent ) return ( ent:GetClass() == "trash_recycler" ) end
    } )
    local ent = tr.Entity
    if ent:GetPos():Distance(ply:GetPos()) > 100 then return end
    if ent:GetNWInt("State", 0) == 0 and ent:GetNWInt("Trash", 0) > 0 then
        local trashWhenRecycle = ent:GetNWInt("Trash", 0)
        ent:SetNWInt("MaxTime", ent:GetNWInt("Trash", 0) * 0.1)
        ent:SetNWFloat("Time", CurTime() + ent:GetNWInt("MaxTime", 0))
        ent:SetNWInt("Trash", 0)
        ent:SetNWInt("State", 1)
        ent:SetNWInt("curPlyID", ply:SteamID64())
        ent.Sound1:Play()
        ent.Sound2:Play()
        timer.Simple(ent:GetNWInt("MaxTime", 0), function()
            if IsValid(ent) then
                ent:SetNWInt("State", 0)
                ent.Sound1:Stop()
                ent.Sound2:Stop()
                ent.Sound3:Play()
                local owner = player.GetBySteamID64(ent:GetNWInt("curPlyID", 0))
                if owner then
                    DarkRP.notify(ply, 0, 5, "Your Trash Has Been Recycled")
                    --owner:DarkRpChat("TRASHMAN",Color(50,150,200), "Your Trash Has Been Recycled")
                    local frac = (0.02 * ply:PC_Leveling_GetLevel(5)) + 1
                    local profit = 2.2 * GetGlobalInt("Trash_Price_Multiplier", 100) * frac
                    local realProfit = profit * trashWhenRecycle
                    owner:addMoney(realProfit)
                    --owner:DarkRpChat("TRASHMAN",Color(50,150,200), "You Gained $"..tonumber(profit * trashWhenRecycle).." From Selling "..trashWhenRecycle.." KG Of Trash And Current Trash Selling Price Is $"..tonumber(profit).." ")
                    DarkRP.notify(ply, 0, 5, "You Gained $"..tonumber(realProfit).." From Selling "..trashWhenRecycle.." KG Of Trash And Current Trash Selling Price Is $"..tonumber(profit).." ")
                    if trashWhenRecycle >= 100 then
                        ply:PC_Leveling_AddXP(5,math.floor(trashWhenRecycle/100))
                    end
                    hook.Run( "PC_Trashman_SellTrash", owner, realProfit )
                end
                ent:SetNWInt("curPlyID", 0)
                timer.Simple(1, function()
                    if IsValid(ent) then
                        ent.Sound3:Stop()
                    end
                end)
            end
        end)
    end
end)