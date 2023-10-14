PC_Leveling = PC_Leveling or {}
PC_Leveling.Config = PC_Leveling.Config or {}
PC_Leveling.AllSkills = PC_Leveling.AllSkills or {}

function PC_Leveling:RegisterSkill(id,name,levels,bgPaint,dissabled)
    PC_Leveling.AllSkills[id] = {}
    PC_Leveling.AllSkills[id].name = name
    PC_Leveling.AllSkills[id].levels = levels
    PC_Leveling.AllSkills[id].bg = bgPaint
    if dissabled then
        PC_Leveling.AllSkills[id].dissabled = dissabled
    end
end

PC_Leveling:RegisterSkill(4,"Mining",{
    [0] = {
        ["Xp"] = 0,
        ["RewardName"] = "Example + New Crafting Items",
        ["RewardFunc"] = function(ply) end
    },
    [1] = {
        ["Xp"] = 10,
        ["RewardName"] = "$100,000 + New Crafting Items",
        ["RewardFunc"] = function(ply) 
            ply:addMoney(100000)
        end
    },
    [2] = {
        ["Xp"] = 20,
        ["RewardName"] = "$400,000 + New Crafting Items",
        ["RewardFunc"] = function(ply) 
            ply:addMoney(400000)
        end
    },
    [3] = {
        ["Xp"] = 50,
        ["RewardName"] = "1x Case Crate + New Crafting Items",
        ["RewardFunc"] = function(ply) 
            VoidCases.AddItem(ply:SteamID64(), "165", 1)
            VoidCases.NetworkItem(ply, 165, 1)        
        end
    },
    [4] = {
        ["Xp"] = 100,
        ["RewardName"] = "2x Case Crate + New Crafting Items",
        ["RewardFunc"] = function(ply) 
            VoidCases.AddItem(ply:SteamID64(), "165", 2)
            VoidCases.NetworkItem(ply, 165, 2)    
        end
    },
    [5] = {
        ["Xp"] = 200,
        ["RewardName"] = "3x Case Crate + New Crafting Items",
        ["RewardFunc"] = function(ply) 
            VoidCases.AddItem(ply:SteamID64(), "165", 3)
            VoidCases.NetworkItem(ply, 165, 3)      
        end
    },
    [6] = {
        ["Xp"] = 400,
        ["RewardName"] = "$4,000,000 + New Crafting Items",
        ["RewardFunc"] = function(ply) 
            ply:addMoney(4000000)
        end
    },
    [7] = {
        ["Xp"] = 800,
        ["RewardName"] = "5x Holy Case + New Crafting Items",
        ["RewardFunc"] = function(ply) 
            VoidCases.AddItem(ply:SteamID64(), "115", 5)
            VoidCases.NetworkItem(ply, 115, 5)        
        end
    },
    [8] = {
        ["Xp"] = 1600,
        ["RewardName"] = "20000 Points + New Crafting Items",
        ["RewardFunc"] = function(ply) 
            ply:AddGobblePoints(20000)
            ply:SendGobblePoints()
        end
    },
    [9] = {
        ["Xp"] = 3200,
        ["RewardName"] = "2x Fire Drill + New Crafting Items",
        ["RewardFunc"] = function(ply) 
            VoidCases.AddItem(ply:SteamID64(), "39", 2)
            VoidCases.NetworkItem(ply, 39, 2)
        end
    },
    [10] = {
        ["Xp"] = 6400,
        ["RewardName"] = "2x Heavy Guardian Suit",
        ["RewardFunc"] = function(ply) 
            VoidCases.AddItem(ply:SteamID64(), "104", 2)
            VoidCases.NetworkItem(ply, 104, 2)
        end
    },
    [11] = {
        ["Xp"] = 12800,
        ["RewardName"] = "1x Adaption Suit",
        ["RewardFunc"] = function(ply) 
            VoidCases.AddItem(ply:SteamID64(), "90", 1)
            VoidCases.NetworkItem(ply, 90, 1)
        end
    },
}, function(s,w,h) end)

PC_Leveling:RegisterSkill(1,"Printing",{
    [0] = {
        ["Xp"] = 0,
        ["RewardName"] = "Nothing",
        ["RewardFunc"] = function(ply) end
    },
    [1] = {
        ["Xp"] = 50,
        ["RewardName"] = "$400,000",
        ["RewardFunc"] = function(ply) ply:addMoney(400000) end
    },
    [2] = {
        ["Xp"] = 100,
        ["RewardName"] = "1x Dual Kriss Custom",
        ["RewardFunc"] = function(ply) 
            VoidCases.AddItem(ply:SteamID64(), "55", 1)
            VoidCases.NetworkItem(ply, 55, 1)
        end
    },
    [3] = {
        ["Xp"] = 150,
        ["RewardName"] = "1x Broken Speed Suit",
        ["RewardFunc"] = function(ply) 
            VoidCases.AddItem(ply:SteamID64(), "95", 1)
            VoidCases.NetworkItem(ply, 95, 1)
        end
    },
    [4] = {
        ["Xp"] = 250,
        ["RewardName"] = "2x Holy Case",
        ["RewardFunc"] = function(ply) 
            VoidCases.AddItem(ply:SteamID64(), "115", 2)
            VoidCases.NetworkItem(ply, 115, 2)        
        end
    },
    [5] = {
        ["Xp"] = 395,
        ["RewardName"] = "1x Assassin Suit",
        ["RewardFunc"] = function(ply) 
            VoidCases.AddItem(ply:SteamID64(), "98", 1)
            VoidCases.NetworkItem(ply, 98, 1)        
        end
    },
    [6] = {
        ["Xp"] = 550,
        ["RewardName"] = "$15,000,000",
        ["RewardFunc"] = function(ply) 
            ply:addMoney(15000000)
        end
    },
    [7] = {
        ["Xp"] = 865,
        ["RewardName"] = "2x ??? Crate",
        ["RewardFunc"] = function(ply) 
            VoidCases.AddItem(ply:SteamID64(), "158", 2)
            VoidCases.NetworkItem(ply, 158, 2)        
        end

    },
    [8] = {
        ["Xp"] = 1300,
        ["RewardName"] = "2x Cases Crate",
        ["RewardFunc"] = function(ply) 
            VoidCases.AddItem(ply:SteamID64(), "165", 2)
            VoidCases.NetworkItem(ply, 165, 2)        
        end
    },
    [9] = {
        ["Xp"] = 2000,
        ["RewardName"] = "$30,000,000",
        ["RewardFunc"] = function(ply) 
            ply:addMoney(30000000)
        end
    },
    [10] = {
        ["Xp"] = 3000,
        ["RewardName"] = "3x Inventory Printer",
        ["RewardFunc"] = function(ply) 
            VoidCases.AddItem(ply:SteamID64(), "166", 1)
            VoidCases.NetworkItem(ply, 166, 1)        
        end
    },
    [11] = {
        ["Xp"] = 5000,
        ["RewardName"] = "1x Printer Suit",
        ["RewardFunc"] = function(ply) 
            VoidCases.AddItem(ply:SteamID64(), "168", 1)
            VoidCases.NetworkItem(ply, 168, 1)        
        end
    },
}, function(s,w,h) end)

PC_Leveling:RegisterSkill(2,"Bitcoin",{
    [0] = {
        ["Xp"] = 0,
        ["RewardName"] = "Example",
        ["RewardFunc"] = function(ply) end
    },
    [1] = {
        ["Xp"] = 50,
        ["RewardName"] = "$600,000",
        ["RewardFunc"] = function(ply) ply:addMoney(600000) end
    },
    [2] = {
        ["Xp"] = 100,
        ["RewardName"] = "1x Balrog XI",
        ["RewardFunc"] = function(ply) 
            VoidCases.AddItem(ply:SteamID64(), "69", 1)
            VoidCases.NetworkItem(ply, 69, 1)
        end
    },
    [3] = {
        ["Xp"] = 150,
        ["RewardName"] = "1x Scrap Suit",
        ["RewardFunc"] = function(ply) 
            VoidCases.AddItem(ply:SteamID64(), "96", 1)
            VoidCases.NetworkItem(ply, 96, 1)
        end
    },
    [4] = {
        ["Xp"] = 250,
        ["RewardName"] = "2x Mystic Case",
        ["RewardFunc"] = function(ply) 
            VoidCases.AddItem(ply:SteamID64(), "114", 2)
            VoidCases.NetworkItem(ply, 114, 2)        
        end
    },
    [5] = {
        ["Xp"] = 395,
        ["RewardName"] = "1x TAU Suit",
        ["RewardFunc"] = function(ply) 
            VoidCases.AddItem(ply:SteamID64(), "99", 1)
            VoidCases.NetworkItem(ply, 99, 1)        
        end
    },
    [6] = {
        ["Xp"] = 550,
        ["RewardName"] = "$20,000,000",
        ["RewardFunc"] = function(ply) 
            ply:addMoney(20000000)
        end
    },
    [7] = {
        ["Xp"] = 865,
        ["RewardName"] = "2x ??? Crate",
        ["RewardFunc"] = function(ply) 
            VoidCases.AddItem(ply:SteamID64(), "158", 2)
            VoidCases.NetworkItem(ply, 158, 2)        
        end

    },
    [8] = {
        ["Xp"] = 1300,
        ["RewardName"] = "3x Cases Crate",
        ["RewardFunc"] = function(ply) 
            VoidCases.AddItem(ply:SteamID64(), "165", 3)
            VoidCases.NetworkItem(ply, 165, 2)        
        end
    },
    [9] = {
        ["Xp"] = 2000,
        ["RewardName"] = "$30,000,000",
        ["RewardFunc"] = function(ply) 
            ply:addMoney(30000000)
        end
    },
    [10] = {
        ["Xp"] = 3000,
        ["RewardName"] = "2x Gluon Gun",
        ["RewardFunc"] = function(ply) 
            VoidCases.AddItem(ply:SteamID64(), "43", 2)
            VoidCases.NetworkItem(ply, 43, 2)        
        end
    },
    [11] = {
        ["Xp"] = 5000,
        ["RewardName"] = "1x Printer Suit",
        ["RewardFunc"] = function(ply) 
            VoidCases.AddItem(ply:SteamID64(), "168", 1)
            VoidCases.NetworkItem(ply, 168, 1)        
        end
    },
}, function(s,w,h) end)

PC_Leveling:RegisterSkill(3,"Drugs",{
    [0] = {
        ["Xp"] = 0,
        ["RewardName"] = "Noffin",
        ["RewardFunc"] = function(ply) end
    },
    [1] = {
        ["Xp"] = 20,
        ["RewardName"] = "1x Tempest + 2% Sell Price",
        ["RewardFunc"] = function(ply) 
            VoidCases.AddItem(ply:SteamID64(), "59", 1)
            VoidCases.NetworkItem(ply, 59, 1)        
        end
    },
    [2] = {
        ["Xp"] = 40,
        ["RewardName"] = "$1,000,000 + 2% Sell Price",
        ["RewardFunc"] = function(ply) 
            ply:addMoney(1000000)
        end
    },
    [3] = {
        ["Xp"] = 80,
        ["RewardName"] = "1x N7 Suit + 2% Sell Price",
        ["RewardFunc"] = function(ply) 
            VoidCases.AddItem(ply:SteamID64(), "93", 1)
            VoidCases.NetworkItem(ply, 93, 1)        
        end
    },
    [4] = {
        ["Xp"] = 130,
        ["RewardName"] = "1x Janus 5 + 2% Sell Price",
        ["RewardFunc"] = function(ply) 
            VoidCases.AddItem(ply:SteamID64(), "82", 1)
            VoidCases.NetworkItem(ply, 82, 1)        
        end
    },
    [5] = {
        ["Xp"] = 175,
        ["RewardName"] = "$15,000,000 + 2% Sell Price",
        ["RewardFunc"] = function(ply) 
            ply:addMoney(25000000)
        end
    },
    [6] = {
        ["Xp"] = 250,
        ["RewardName"] = "3x Magnum Drill + 2% Sell Price",
        ["RewardFunc"] = function(ply) 
            VoidCases.AddItem(ply:SteamID64(), "120", 3)
            VoidCases.NetworkItem(ply, 120, 3)        
        end
    },
    [7] = {
        ["Xp"] = 480,
        ["RewardName"] = "1x Royal Knight Suit + 2% Sell Price",
        ["RewardFunc"] = function(ply) 
            VoidCases.AddItem(ply:SteamID64(), "102", 1)
            VoidCases.NetworkItem(ply, 102, 1)        
        end
    },
    [8] = {
        ["Xp"] = 730,
        ["RewardName"] = "$25,000,000 + 2% Sell Price",
        ["RewardFunc"] = function(ply) 
            ply:addMoney(25000000)
        end
    },
    [9] = {
        ["Xp"] = 1290,
        ["RewardName"] = "6x Case Crates + 2% Sell Price",
        ["RewardFunc"] = function(ply) 
            VoidCases.AddItem(ply:SteamID64(), "165", 6)
            VoidCases.NetworkItem(ply, 165, 6)        
        end
    },
    [10] = {
        ["Xp"] = 2500,
        ["RewardName"] = "1x Perm Weed Pot + 2% Sell Price",
        ["RewardFunc"] = function(ply) 
            VoidCases.AddItem(ply:SteamID64(), "169", 1)
            VoidCases.NetworkItem(ply, 169, 1)        
        end
    },
}, function(s,w,h) end)

PC_Leveling:RegisterSkill(5,"Trashman",{
    [0] = {
        ["Xp"] = 0,
        ["RewardName"] = "Example",
        ["RewardFunc"] = function(ply) end
    },
    [1] = {
        ["Xp"] = 80,
        ["RewardName"] = "$500,000 + 2% Sell Profit",
        ["RewardFunc"] = function(ply) 
            ply:addMoney(500000)
        end
    },
    [2] = {
        ["Xp"] = 180,
        ["RewardName"] = "1x Ak-47 White Gold + 2% Sell Profit",
        ["RewardFunc"] = function(ply) 
            VoidCases.AddItem(ply:SteamID64(), "121", 1)
            VoidCases.NetworkItem(ply, 121, 1)        
        end
    },
    [3] = {
        ["Xp"] = 300,
        ["RewardName"] = "1x Fluence + 2% Sell Profit",
        ["RewardFunc"] = function(ply) 
            VoidCases.AddItem(ply:SteamID64(), "131", 1)
            VoidCases.NetworkItem(ply, 131, 1)        
        end
    },
    [4] = {
        ["Xp"] = 500,
        ["RewardName"] = "1x Speed Suit + 2% Sell Profit",
        ["RewardFunc"] = function(ply) 
            VoidCases.AddItem(ply:SteamID64(), "94", 1)
            VoidCases.NetworkItem(ply, 94, 1)        
        end
    },
    [5] = {
        ["Xp"] = 790,
        ["RewardName"] = "3x Ultra Blue Case + 2% Sell Profit",
        ["RewardFunc"] = function(ply) 
            VoidCases.AddItem(ply:SteamID64(), "132", 3)
            VoidCases.NetworkItem(ply, 132, 3)        
        end
    },
    [6] = {
        ["Xp"] = 960,
        ["RewardName"] = "2x VIP Case + 2% Sell Profit",
        ["RewardFunc"] = function(ply) 
            VoidCases.AddItem(ply:SteamID64(), "144", 2)
            VoidCases.NetworkItem(ply, 144, 2)        
        end
    },
    [7] = {
        ["Xp"] = 1200,
        ["RewardName"] = "$12,000,000 + 2% Sell Profit",
        ["RewardFunc"] = function(ply) 
            ply:addMoney(12000000)
        end
    },
    [8] = {
        ["Xp"] = 1600,
        ["RewardName"] = "1x Royal Warrior Suit + 2% Sell Profit",
        ["RewardFunc"] = function(ply) 
            VoidCases.AddItem(ply:SteamID64(), "103", 1)
            VoidCases.NetworkItem(ply, 103, 1)        
        end
    },
    [9] = {
        ["Xp"] = 2450,
        ["RewardName"] = "$22,500,000 + 2% Sell Profit",
        ["RewardFunc"] = function(ply) 
            ply:addMoney(22500000)
        end
    },
    [10] = {
        ["Xp"] = 4000,
        ["RewardName"] = "1x Trashman Suit + 2% Sell Profit",
        ["RewardFunc"] = function(ply) 
            VoidCases.AddItem(ply:SteamID64(), "169", 1)
            VoidCases.NetworkItem(ply, 169, 1)        
        end
    },
}, function(s,w,h) end)

PC_Leveling:RegisterSkill(6,"Points Tree",{
    [0] = {
        ["Xp"] = 0,
        ["RewardName"] = "Example",
        ["RewardFunc"] = function(ply) end
    },
    [1] = {
        ["Xp"] = 20,
        ["RewardName"] = "$300,000",
        ["RewardFunc"] = function(ply) 
            ply:addMoney(300000)
        end
    },
    [2] = {
        ["Xp"] = 40,
        ["RewardName"] = "1x M2 Master",
        ["RewardFunc"] = function(ply) 
            VoidCases.AddItem(ply:SteamID64(), "51", 1)
            VoidCases.NetworkItem(ply, 51, 1)        
        end
    },
    [3] = {
        ["Xp"] = 70,
        ["RewardName"] = "5000 Points",
        ["RewardFunc"] = function(ply) 
            ply:AddGobblePoints(5000)
            ply:SendGobblePoints()
        end
    },
    [4] = {
        ["Xp"] = 120,
        ["RewardName"] = "2x RPG-7 Master",
        ["RewardFunc"] = function(ply) 
            VoidCases.AddItem(ply:SteamID64(), "127", 2)
            VoidCases.NetworkItem(ply, 127, 2)        
        end
    },
    [5] = {
        ["Xp"] = 190,
        ["RewardName"] = "1x X60 Space Suit",
        ["RewardFunc"] = function(ply) 
            VoidCases.AddItem(ply:SteamID64(), "91", 1)
            VoidCases.NetworkItem(ply, 91, 1)        
        end
    },
    [6] = {
        ["Xp"] = 250,
        ["RewardName"] = "$10,000,000",
        ["RewardFunc"] = function(ply) 
            ply:addMoney(10000000)
        end
    },
    [7] = {
        ["Xp"] = 410,
        ["RewardName"] = "15000 Points",
        ["RewardFunc"] = function(ply) 
            ply:AddGobblePoints(15000)
            ply:SendGobblePoints()
        end
    },
    [8] = {
        ["Xp"] = 750,
        ["RewardName"] = "2x Suit Case",
        ["RewardFunc"] = function(ply) 
            VoidCases.AddItem(ply:SteamID64(), "163", 2)
            VoidCases.NetworkItem(ply, 163, 2)        
        end
    },
    [9] = {
        ["Xp"] = 1300,
        ["RewardName"] = "$20,000,000",
        ["RewardFunc"] = function(ply) 
            ply:addMoney(20000000)
        end
    },
    [10] = {
        ["Xp"] = 2470,
        ["RewardName"] = "10x Points Tree",
        ["RewardFunc"] = function(ply) 
            VoidCases.AddItem(ply:SteamID64(), "167", 10)
            VoidCases.NetworkItem(ply, 167, 10)        
        end
    },
}, function(s,w,h) end)

PC_Leveling:RegisterSkill(7,"Arena",{
    [0] = {
        ["Xp"] = 0,
        ["RewardName"] = "Example",
        ["RewardFunc"] = function(ply) end
    },
    [1] = {
        ["Xp"] = 5,
        ["RewardName"] = "Example",
        ["RewardFunc"] = function(ply) end
    },
    [2] = {
        ["Xp"] = 10,
        ["RewardName"] = "Example",
        ["RewardFunc"] = function(ply) end
    },
    [3] = {
        ["Xp"] = 25,
        ["RewardName"] = "Example",
        ["RewardFunc"] = function(ply) end
    },
    [4] = {
        ["Xp"] = 50,
        ["RewardName"] = "Example",
        ["RewardFunc"] = function(ply) end
    },
    [5] = {
        ["Xp"] = 100,
        ["RewardName"] = "Example",
        ["RewardFunc"] = function(ply) end
    },
    [6] = {
        ["Xp"] = 200,
        ["RewardName"] = "Example",
        ["RewardFunc"] = function(ply) end
    },
    [7] = {
        ["Xp"] = 400,
        ["RewardName"] = "Example",
        ["RewardFunc"] = function(ply) end
    },
    [8] = {
        ["Xp"] = 800,
        ["RewardName"] = "Example",
        ["RewardFunc"] = function(ply) end
    },
    [9] = {
        ["Xp"] = 1600,
        ["RewardName"] = "Example",
        ["RewardFunc"] = function(ply) end
    },
    [10] = {
        ["Xp"] = 2400,
        ["RewardName"] = "Example",
        ["RewardFunc"] = function(ply) end
    },
}, function(s,w,h) end, true)

PC_Leveling:RegisterSkill(8,"Robbery",{
    [0] = {
        ["Xp"] = 0,
        ["RewardName"] = "Example",
        ["RewardFunc"] = function(ply) end
    },
    [1] = {
        ["Xp"] = 5,
        ["RewardName"] = "Example",
        ["RewardFunc"] = function(ply) end
    },
    [2] = {
        ["Xp"] = 10,
        ["RewardName"] = "Example",
        ["RewardFunc"] = function(ply) end
    },
    [3] = {
        ["Xp"] = 25,
        ["RewardName"] = "Example",
        ["RewardFunc"] = function(ply) end
    },
    [4] = {
        ["Xp"] = 50,
        ["RewardName"] = "Example",
        ["RewardFunc"] = function(ply) end
    },
    [5] = {
        ["Xp"] = 100,
        ["RewardName"] = "Example",
        ["RewardFunc"] = function(ply) end
    },
    [6] = {
        ["Xp"] = 200,
        ["RewardName"] = "Example",
        ["RewardFunc"] = function(ply) end
    },
    [7] = {
        ["Xp"] = 400,
        ["RewardName"] = "Example",
        ["RewardFunc"] = function(ply) end
    },
    [8] = {
        ["Xp"] = 800,
        ["RewardName"] = "Example",
        ["RewardFunc"] = function(ply) end
    },
    [9] = {
        ["Xp"] = 1600,
        ["RewardName"] = "Example",
        ["RewardFunc"] = function(ply) end
    },
    [10] = {
        ["Xp"] = 2400,
        ["RewardName"] = "Example",
        ["RewardFunc"] = function(ply) end
    },
}, function(s,w,h) end, true)

PC_Leveling:RegisterSkill(9,"Police",{
    [0] = {
        ["Xp"] = 0,
        ["RewardName"] = "Example",
        ["RewardFunc"] = function(ply) end
    },
    [1] = {
        ["Xp"] = 5,
        ["RewardName"] = "Example",
        ["RewardFunc"] = function(ply) end
    },
    [2] = {
        ["Xp"] = 10,
        ["RewardName"] = "Example",
        ["RewardFunc"] = function(ply) end
    },
    [3] = {
        ["Xp"] = 25,
        ["RewardName"] = "Example",
        ["RewardFunc"] = function(ply) end
    },
    [4] = {
        ["Xp"] = 50,
        ["RewardName"] = "Example",
        ["RewardFunc"] = function(ply) end
    },
    [5] = {
        ["Xp"] = 100,
        ["RewardName"] = "Example",
        ["RewardFunc"] = function(ply) end
    },
    [6] = {
        ["Xp"] = 200,
        ["RewardName"] = "Example",
        ["RewardFunc"] = function(ply) end
    },
    [7] = {
        ["Xp"] = 400,
        ["RewardName"] = "Example",
        ["RewardFunc"] = function(ply) end
    },
    [8] = {
        ["Xp"] = 800,
        ["RewardName"] = "Example",
        ["RewardFunc"] = function(ply) end
    },
    [9] = {
        ["Xp"] = 1600,
        ["RewardName"] = "Example",
        ["RewardFunc"] = function(ply) end
    },
    [10] = {
        ["Xp"] = 2400,
        ["RewardName"] = "Example",
        ["RewardFunc"] = function(ply) end
    },
}, function(s,w,h) end, true)

PC_Leveling:RegisterSkill(10,"Halloween",{
    [0] = {
        ["Xp"] = 0,
        ["RewardName"] = "Example",
        ["RewardFunc"] = function(ply) end
    },
    [1] = {
        ["Xp"] = 1,
        ["RewardName"] = "1x Halloween Costume",
        ["RewardFunc"] = function(ply) 
            VoidCases.AddItem(ply:SteamID64(), "175", 1)
            VoidCases.NetworkItem(ply, 175, 1)        
        end
    },
    [2] = {
        ["Xp"] = 3,
        ["RewardName"] = "3x Halloween Case + Hint 1",
        ["RewardFunc"] = function(ply) 
            VoidCases.AddItem(ply:SteamID64(), "179", 3)
            VoidCases.NetworkItem(ply, 179, 3)        
        end
    },
    [3] = {
        ["Xp"] = 6,
        ["RewardName"] = "2x Halloween Costume",
        ["RewardFunc"] = function(ply) 
            VoidCases.AddItem(ply:SteamID64(), "175", 2)
            VoidCases.NetworkItem(ply, 175, 2)        
        end
    },
    [4] = {
        ["Xp"] = 10,
        ["RewardName"] = "5x Halloween Case + Hint 2",
        ["RewardFunc"] = function(ply) 
            VoidCases.AddItem(ply:SteamID64(), "179", 5)
            VoidCases.NetworkItem(ply, 179, 5)        
        end
    },
    [5] = {
        ["Xp"] = 15,
        ["RewardName"] = "1x Void Drill",
        ["RewardFunc"] = function(ply) 
            VoidCases.AddItem(ply:SteamID64(), "171", 1)
            VoidCases.NetworkItem(ply, 171, 1)        
        end
    },
    [6] = {
        ["Xp"] = 21,
        ["RewardName"] = "1x Heaven Scorcher + Hint 3",
        ["RewardFunc"] = function(ply) 
            VoidCases.AddItem(ply:SteamID64(), "149", 1)
            VoidCases.NetworkItem(ply, 149, 1)        
        end
    },
    [7] = {
        ["Xp"] = 28,
        ["RewardName"] = "1x Dracula Suit",
        ["RewardFunc"] = function(ply) 
            VoidCases.AddItem(ply:SteamID64(), "176", 1)
            VoidCases.NetworkItem(ply, 176, 1)        
        end
    },
    [8] = {
        ["Xp"] = 36,
        ["RewardName"] = "7x Halloween Case + Hint 4",
        ["RewardFunc"] = function(ply) 
            VoidCases.AddItem(ply:SteamID64(), "179", 7)
            VoidCases.NetworkItem(ply, 179, 7)     
        end
    },
    [9] = {
        ["Xp"] = 45,
        ["RewardName"] = "1x Dracula Suit",
        ["RewardFunc"] = function(ply) 
            VoidCases.AddItem(ply:SteamID64(), "176", 1)
            VoidCases.NetworkItem(ply, 176, 1)        
        end
    },
    [10] = {
        ["Xp"] = 55,
        ["RewardName"] = "1x Void Stalker Suit + Hint 5",
        ["RewardFunc"] = function(ply) 
            VoidCases.AddItem(ply:SteamID64(), "177", 1)
            VoidCases.NetworkItem(ply, 177, 1)        
        end
    },
}, function(s,w,h) end)