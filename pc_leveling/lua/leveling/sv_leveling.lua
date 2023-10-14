PC_Leveling = PC_Leveling or {}
PC_Leveling.Config = PC_Leveling.Config or {}
PC_Leveling.AllSkills = PC_Leveling.AllSkills or {}
local meta = FindMetaTable( "Player" )
util.AddNetworkString("PC_Leveling_SendXP")
util.AddNetworkString("PC_Leveling_SendLevel")
util.AddNetworkString("PC_Leveling_ClaimLevel")
util.AddNetworkString("lvlup_effect")
util.AddNetworkString("leveling_hint")

function meta:PC_Leveling_Init(id)
    self.PC_Leveling[id] = {}
    self.PC_Leveling[id].xp = 0
    self.PC_Leveling[id].level = 0
end

function meta:PC_Leveling_Save(id)
    PC_Leveling.DB.Query(string.format("REPLACE INTO pc_leveling VALUES ('%s', '%s', '%s', '%s')", self:SteamID64(), id, self.PC_Leveling[id].level,self.PC_Leveling[id].xp))
end

function meta:PC_Leveling_SendXP(id)
    net.Start("PC_Leveling_SendXP")
        net.WriteUInt(id, 5)
        net.WriteUInt(self.PC_Leveling[id].xp, 24)
    net.Send(self)
end


function meta:PC_Leveling_SetXP(id,xp)
    self.PC_Leveling[id].xp = xp
    self:PC_Leveling_SendXP(id)
end

function meta:PC_Leveling_AddXP(id,xp)
    self.PC_Leveling[id].xp = self.PC_Leveling[id].xp + xp
    self:PC_Leveling_SendXP(id)
    DarkRP.notify(self, 0, 5, "+ "..xp.." "..PC_Leveling.AllSkills[id].name.." XP" )
    self:PC_Leveling_Save(id)
end

function meta:PC_Leveling_SendLevel(id)
    net.Start("PC_Leveling_SendLevel")
        net.WriteUInt(id, 5)
        net.WriteUInt(self.PC_Leveling[id].level, 24)
    net.Send(self)
end



function meta:PC_Leveling_SetLevel(id,level)
    self.PC_Leveling[id].level = level
    self:PC_Leveling_SendLevel(id)
end

function meta:PC_Leveling_AddLevel(id,level)
    self.PC_Leveling[id].level = self.PC_Leveling[id].level + level
    self:PC_Leveling_SendLevel(id)
    DarkRP.notify(self, 0, 5, "Reached Level "..level.." "..PC_Leveling.AllSkills[id].name )
    self:PC_Leveling_Save(id)
end


net.Receive("PC_Leveling_ClaimLevel", function(len, ply)
    local id = net.ReadUInt(5)
    if ply.PC_Leveling[id].xp >= ply:PC_Leveling_GetNeededXP(id) then
        ply:PC_Leveling_AddLevel(id,1)
        local func = PC_Leveling.AllSkills[id].levels[ply:PC_Leveling_GetLevel(id)].RewardFunc
        func(ply)
        DarkRP.notify(ply, 0, 5, "Claimed Level "..ply.PC_Leveling[id].level.." "..PC_Leveling.AllSkills[id].name.." Reward: ".. PC_Leveling.AllSkills[id].levels[ply:PC_Leveling_GetLevel(id)].RewardName )
        ply:EmitSound("misc/achievement_earned.wav")
        net.Start("lvlup_effect")
            net.WriteVector(ply:GetPos())
        net.Broadcast()
    end
end)


local hints = {
    [1] = "I'm finally here, In this large abode. The fumes may be bad, but the space has me sold, now I'm ready to move In without refrain, how many boxes did I retain?", -- 8
    [2] = "Im still feeling thirsty, even after all I drank! how many did I drink whole?", -- 3
    [3] = "Im feeling lucky, but It's taking It's toll. I need help but I'm on a roll. The quantity mode of the number shall be the answer, I can't come up with a rhyme.", --5
    [4] = "COMING WITH HALLOWEEN UPDATE PART 2",
    [5] = "COMING WITH HALLOWEEN UPDATE PART 2",
}

net.Receive("leveling_hint", function(len,ply)
    local hint = net.ReadUInt(4)
    if hint < 0 then return end
    if !hints[hint] then return end
    if ply:PC_Leveling_GetLevel(10) < hint then ply:ChatPrint("You Cant See This Hint Yet.") return end
    ply:ChatPrint(hints[hint])
end)