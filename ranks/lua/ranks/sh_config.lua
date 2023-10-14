PC_Ranks = PC_Ranks or {}
PC_Ranks.Config =  {
    [1] = {
        ["Name"] = "None", 
        ["Weps"] = {
        },
        ["PrinterBoost"] = 1,
        ["Props"] = 45,
        ["Price"] = 0,
        ["Color"] = color_white,
        ["ClickFunc"] = function()
            RunConsoleCommand("creditstore_purchaserank", 1)
        end,
        ["Contents"] = {
            ""
        },
    }, 
    [2] = {
        ["Name"] = "VIP",
        ["Weps"] = {
            ["weapon_lightsaber"] = "Light-Saber",
            ["csgo_bayonet"] = "Bayonet Knife",
            ["arena_br9"] = "BR-9",
        },
        ["PrinterBoost"] = 1.15,
        ["Props"] = 50,
        ["Color"] =  Color(0,100,255),
        ["Price"] = 1000,
        ["ClickFunc"] = function()
            RunConsoleCommand("creditstore_purchaserank", 2)
        end,
        ["Contents"] = {
            "Permanent V.I.P Rank",
            "VIP Jobs",
            "Prop Limit: 50",
            "£2,500,000 In-Game Money",
            "⇊ ⇊ Permanent Weapons⇊ ⇊ ",
            "Lightsaber, Bayonet Knife and BR-9 Pistol",
            "Printer Boost: 1.15x",
            "Points Tree Boost: 1.05x"
        },
    },
    [3] = {
        ["Name"] = "Ultra VIP",
        ["Weps"] = {
            ["weapon_lightsaber"] = "Light-Saber",
            ["csgo_bayonet_ddpat"] = "Bayonet Knife - Forest DDPAT",
            ["arena_br9"] = "BR-9",
            ["robotnik_mw2_tmp"] = "TMP",
        },
        ["PrinterBoost"] = 1.3,
        ["Props"] = 60,
        ["Price"] = 2000,
        ["ClickFunc"] = function()
            RunConsoleCommand("creditstore_purchaserank", 3)
        end,
        ["Color"] =  Color(0,100,255),
        ["Contents"] = {
            "Permanent Ultra V.I.P Rank",
            "Ultra VIP/VIP jobs",
            "Prop Limit: 60",
            "£7,500,000 In-Game Money",
            "⇊ ⇊ Permanent Weapons⇊ ⇊",
            "Lightsaber, Bayonet Knife - Forest DDPAT ",
            "BR-9 Pistol, TMP Smg",
            "Printer Boost: 1.3x",
            "Points Tree Boost: 1.1x"
        },
    },
    [4] = {
        ["Name"] = "Meme",
        ["Weps"] = {
            ["weapon_lightsaber"] = "Light-Saber",
            ["csgo_bayonet_bluesteel"] = "Bayonet Knife - Blue Steel",
            ["arena_br9"] = "BR-9",
            ["robotnik_mw2_tmp"] = "TMP",
            ["robotnik_mw2_f2"] = "F2000"
        },
        ["PrinterBoost"] = 1.45,
        ["Props"] = 65,
        ["Price"] = 3000,
        ["ClickFunc"] = function()
            RunConsoleCommand("creditstore_purchaserank", 4)
        end,
        ["Color"] =  Color(0,100,255),
        ["Contents"] = {
            "Permanent MEME Rank",
            "Meme/Ultra VIP/VIP jobs",
            "Prop Limit: 65",
            "£15,000,000 In-Game Money",
            "⇊ ⇊ Permanent Weapons⇊ ⇊",
            "Lightsaber, Bayonet Knife - Blue Steel ",
            "BR-9 Pistol, TMP Smg, F2000 AR",
            "Printer Boost: 1.45x",
            "Points Tree Boost: 1.15x"
        },
    },
    [5] = {
        ["Name"] = "Meme God",
        ["Weps"] = {
            ["weapon_lightsaber"] = "Light-Saber",
            ["csgo_bayonet_marblefade"] = "Bayonet Knife - Marble Fade",
            ["arena_br9"] = "BR-9",
            ["robotnik_mw2_tmp"] = "TMP",
            ["robotnik_mw2_f2"] = "F2000",
            ["robotnik_mw2_m10"] = "M1014",
        },
        ["PrinterBoost"] = 1.6,
        ["Props"] = 70,
        ["Price"] = 4000,
        ["ClickFunc"] = function()
            RunConsoleCommand("creditstore_purchaserank", 5)
        end,
        ["Color"] = Color(0,100,255),
        ["Contents"] = {
            "Permanent MEME God Rank",
            "Meme God/Meme/Ultra VIP/VIP jobs",
            "Prop Limit: 70",
            "£22,500,000 In-Game Money",
            "⇊ ⇊ Permanent Weapons⇊ ⇊",
            "Lightsaber, Bayonet Knife - Marble Fade",
            "BR-9 Pistol, TMP Smg, F2000 AR, M1014 Shotgun",
            "Printer Boost: 1.6x",
            "Points Tree Boost: 1.2x"
        },
    },
    [6] = {
        ["Name"] = "Meme Legend",
        ["Weps"] = {
            ["weapon_lightsaber"] = "Light-Saber",
            ["csgo_bayonet_fade"] = "Bayonet Knife - Fade",
            ["arena_br9"] = "BR-9",
            ["robotnik_mw2_tmp"] = "TMP",
            ["robotnik_mw2_f2"] = "F2000",
            ["robotnik_mw2_m10"] = "M1014",
            ["destiny_recluse"] = "Recluse",
        },
        ["PrinterBoost"] = 1.75,
        ["Props"] = 100,
        ["Color"] = Color(255, 215, 0),
        ["Price"] = 5000,
        ["ClickFunc"] = function()
            RunConsoleCommand("creditstore_purchaserank", 6)
        end,
        ["Contents"] = {
            "Permanent MEME Legend Rank",
            "Meme God/Meme/Ultra VIP/VIP jobs",
            "Prop Limit: 100",
            "£37,500,000 In-Game Money",
            "⇊ ⇊ Permanent Weapons⇊ ⇊",
            "Lightsaber, Bayonet Knife - Fade",
            "BR-9 Pistol, TMP Smg, F2000 AR, M1014 Shotgun",
            "Recluse AR",
            "Printer Boost: 1.75x",
            "Points Tree Boost: 1.25x"
        },
    },
    [7] = {
        ["Name"] = "Spo0ky",
        ["Weps"] = {
            ["weapon_lightsaber"] = "Light-Saber",
            ["csgo_bayonet_fade"] = "Bayonet Knife - Fade",
            ["arena_br9"] = "BR-9",
            ["robotnik_mw2_tmp"] = "TMP",
            ["robotnik_mw2_f2"] = "F2000",
            ["robotnik_mw2_m10"] = "M1014",
            ["destiny_recluse"] = "Recluse",
            ["tfa_cso_awpz"] = "AWP-Z",
            ["tfa_dax_big_glock"] = "Big Glock",
            ["tfa_cso_pumpkin"] = "Jack-O-Lantern",
        },
        ["PrinterBoost"] = 1.9,
        ["Props"] = 125,
        ["Color"] = Color(255, 150, 50),
        ["Price"] = 6000,
        ["ClickFunc"] = function()
            RunConsoleCommand("creditstore_purchaserank", 7)
        end,
        ["Contents"] = {
            "Permanent Spo0ky Rank - LIMITED[2 WEEKS]",
            "Spo0ky/Meme God/Meme/Ultra VIP/VIP jobs",
            "Prop Limit: 120",
            "£37,500,000 In-Game Money",
            "⇊ ⇊ Permanent Weapons⇊ ⇊",
            "Lightsaber, Bayonet Knife - Fade",
            "BR-9 Pistol, TMP Smg, F2000 AR, M1014 Shotgun",
            "Recluse AR, AWP-Z, Big Glock, Jack-O-Lantern",
            "Printer Boost: 1.9x",
            "Points Tree Boost: 1.3x"
        },
    },
}