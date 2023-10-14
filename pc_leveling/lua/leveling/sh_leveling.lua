PC_Leveling = PC_Leveling or {}
PC_Leveling.Config = PC_Leveling.Config or {}
PC_Leveling.AllSkills = PC_Leveling.AllSkills or {}
PC_Leveling.XP = PC_Leveling.XP or {}
PC_Leveling.Levels = PC_Leveling.Levels or {}

local meta = FindMetaTable("Player")

concommand.Add("level_dump", function(ply, cmd, args)
    if SERVER then
        PrintTable(ply.PC_Leveling)
    else
        PrintTable(PC_Leveling)
    end
end)

function meta:PC_Leveling_GetLevel(id)
    if SERVER then
        return self.PC_Leveling[id].level
    end
    if CLIENT then
        return PC_Leveling.Levels[id]
    end
end

function meta:PC_Leveling_GetXP(id)
    if SERVER then
        return self.PC_Leveling[id].xp
    end
    if CLIENT then
        return PC_Leveling.XP[id]
    end
end

function meta:PC_Leveling_GetNeededXP(id)
    if self:PC_Leveling_GetLevel(id) >= #PC_Leveling.AllSkills[id].levels then
        return 999999999
    else
        return PC_Leveling.AllSkills[id].levels[self:PC_Leveling_GetLevel(id) + 1].Xp
    end
end