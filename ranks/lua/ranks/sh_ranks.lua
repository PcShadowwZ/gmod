PC_Ranks = PC_Ranks or {}
PC_Ranks.Config = PC_Ranks.Config or {}
local meta = FindMetaTable("Player")

function meta:PC_GetRank()
    if SERVER then
        return self.PCRank or 1
    else 
        return self:GetNWInt("PC_Rank", 1)
    end
end

function meta:PC_GetRankTable()
    if SERVER then
        return PC_Ranks.Config[self.PCRank or 1]
    else 
        return PC_Ranks.Config[self:GetNWInt("PC_Rank", 1)]
    end
end

function meta:PC_GetRankName()
    if SERVER then
        return PC_Ranks.Config[self.PCRank or 1].Name
    else 
        return PC_Ranks.Config[self:GetNWInt("PC_Rank", 1)].Name
    end
end

function meta:IsDonator()
    if SERVER then
        if self.PCRank > 1 then
            return true
        else
            return false
        end
    else 
        if self:GetNWInt("PC_Rank", 1) > 1 then
            return true
        else
            return false
        end
    end
end

function meta:IsVIP()
    if SERVER then
        if self.PCRank == 2 then
            return true
        else
            return false
        end
    else 
        if self:GetNWInt("PC_Rank", 1) == 2 then
            return true
        else
            return false
        end
    end
end

function meta:IsUltraVIP()
    if SERVER then
        if self.PCRank == 3 then
            return true
        else
            return false
        end
    else 
        if self:GetNWInt("PC_Rank", 1) == 3 then
            return true
        else
            return false
        end
    end
end

function meta:IsMeme()
    if SERVER then
        if self.PCRank == 4 then
            return true
        else
            return false
        end
    else 
        if self:GetNWInt("PC_Rank", 1) == 4 then
            return true
        else
            return false
        end
    end
end

function meta:IsMemeGod()
    if SERVER then
        if self.PCRank == 5 then
            return true
        else
            return false
        end
    else 
        if self:GetNWInt("PC_Rank", 1) == 5 then
            return true
        else
            return false
        end
    end
end

function meta:IsMemeLegend()
    if SERVER then
        if self.PCRank == 6 then
            return true
        else
            return false
        end
    else 
        if self:GetNWInt("PC_Rank", 1) == 6 then
            return true
        else
            return false
        end
    end
end

function meta:IsSpooky()
    if SERVER then
        if self.PCRank == 7 then
            return true
        else
            return false
        end
    else 
        if self:GetNWInt("PC_Rank", 1) == 7 then
            return true
        else
            return false
        end
    end
end