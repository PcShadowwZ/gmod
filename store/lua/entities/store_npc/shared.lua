ENT.Type = "anim"
ENT.Base = "base_ai"
ENT.Type = "ai"
ENT.PrintName = "Store NPC"
ENT.Author = "Helix Developers"
ENT.Category = "Helix"
ENT.Spawnable = true
ENT.AdminSpawnable = true

CredStore = CredStore or {}
CredStore.Config = {
    ["Weapons"] = {},
    ["Misc"] = {
        [1] = {
            ["Name"] = "Custom Job",
            ["ClickFunc"] = function() RunConsoleCommand("creditstore_purchasemisc", 1) end,
            ["Price"] = 3500,
            ["Color"] = Color(255,55,55),
            ["Contents"] = {
                "Permanent Private Job",
                "5 Weapons (No OP weapons)",
                "Any model from Workshop(Less than 5MB)",
                "Name of the job",
                "£18,750,000 In-Game",
                "£10000 salary",
                "100 Health, 100 Armour",
                "Upon purchase, make a ticket in the helix gaming discord.",
            },
        },
        [2] = {
            ["Name"] = "£2,500,000 Cash",
            ["ClickFunc"] = function() RunConsoleCommand("creditstore_purchasemisc", 2) end,
            ["Price"] = 100,
            ["Color"] = Color(55,255,55),
            ["Contents"] = {
                "Instant £2,500,000",
                "Go spend it on stuff i guessssss."
            },
        },
        [3] = {
            ["Name"] = "£10,000,000 Cash",
            ["ClickFunc"] = function() RunConsoleCommand("creditstore_purchasemisc", 3) end,
            ["Price"] = 350,
            ["Color"] = Color(55,255,55),
            ["Contents"] = {
                "Instant £10,000,000",
                "Go spend it on stuff i guessssss."
            },
        },
        [4] = {
            ["Name"] = "Premium Battle Pass",
            ["ClickFunc"] = function() RunConsoleCommand("creditstore_purchasemisc", 4) end,
            ["Price"] = 1000,
            ["Color"] = Color(55,255,55),
            ["Contents"] = {
                "Instant Access to premium battlepass tiers.",
                "Only valid for the current battlepass."
            },
        },
        [5] = {
            ["Name"] = "1 Battle Pass Tier Skip",
            ["ClickFunc"] = function() RunConsoleCommand("creditstore_purchasemisc", 5) end,
            ["Price"] = 200,
            ["Color"] = Color(255,175,55),
            ["Contents"] = {
                "Instantly unlock 1 battlepass tier.",
                "Only valid for the current battlepass."
            },
        },
        [6] = {
            ["Name"] = "5 Battle Pass Tiers Skip",
            ["ClickFunc"] = function() RunConsoleCommand("creditstore_purchasemisc", 6) end,
            ["Price"] = 950,
            ["Color"] = Color(255,175,55),
            ["Contents"] = {
                "Instantly unlock 5 or up to max battlepass tiers.",
                "Only valid for the current battlepass."
            },
        },
    },
}