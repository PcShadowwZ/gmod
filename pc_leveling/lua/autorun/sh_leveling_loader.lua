PC_Leveling = PC_Leveling or {}
PC_Leveling.Config = PC_Leveling.Config or {}

local function load_directory(dir)
    local fil, fol = file.Find(dir .. "/*", "LUA")
    for k,v in ipairs(fol) do
        load_directory(dir .. "/" .. v)
    end
    for k,v in ipairs(fil) do
        local dirs = dir .. "/" .. v
        if v:StartWith("cl_") then
            if SERVER then
                AddCSLuaFile(dirs)
            else
                include(dirs)
            end
        elseif v:StartWith("sh_") then
            AddCSLuaFile(dirs)
            include(dirs)
        else
            if SERVER then
                include(dirs)
            end
        end
    end
    print("[[LEVELING FILES LOADED]]")
end
load_directory("leveling")