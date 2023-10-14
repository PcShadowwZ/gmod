PCMAC = PCMAC or {}
PCMACConfig = PCMACConfig or {}
local ply = FindMetaTable("Player")

-------------------------------------------------
-------------------------------------------------
-------------------Base Config-------------------
-------------------------------------------------
-------------------------------------------------

--models/geralts/preda/tiny.mdl

PCMACConfig.MinerBoxMin = Vector(3195.576904, 1939.892090, -709.824402)
PCMACConfig.MinerBoxMax = Vector(4305.026855, 487.613159, -269.086151)
-------------------------------------------------
-------------------------------------------------
-------------------Pickaxe Config----------------
-------------------------------------------------
-------------------------------------------------
PCMACConfig.Pickaxe = PCMACConfig.Pickaxe or {}

--This does not include upgrades, this is with 0 upgrades

PCMACConfig.Pickaxe.oreMin = 0.5
PCMACConfig.Pickaxe.oreMax = 1.5
PCMACConfig.Pickaxe.delay = 1.5

-------------------------------------------------
-------------------------------------------------
-------------------Ore Config--------------------
-------------------------------------------------
-------------------------------------------------

PCMACConfig.Ores = {
	["Iron"] = {
		Name = "Iron", -- Name 
		Price = 15, --Sell Price
		Color = Color(100,100,100),
		DropChance = 60, --Drop chance, while mining 
		ResourceModel = "models/asapgaming/rocks/rock_64.mdl",
	},
	
	["Bronze"] = {
		Name = "Bronze",
		Price = 10,
		Color = Color(250,86,15),
		DropChance = 90,
		ResourceModel = "models/asapgaming/rocks/rock_64.mdl",
	},
	

	
	["Gold"] = {
		Name = "Gold",
		Price = 25,
		Color = Color(255,208,0),
		DropChance = 50,
		ResourceModel = "models/asapgaming/rocks/rock_64.mdl",
	},

	["Aluminum"] = {
		Name = "Aluminum",
		Price = 25,
		Color = Color(195,195,195),
		DropChance = 25,
		ResourceModel = "models/asapgaming/rocks/rock_64.mdl",
	},

	["Chromium"] = {
        Name = "Chromium",
        Price = 35,
        Color = Color(219,228,235),
        DropChance = 15,
        ResourceModel = "models/asapgaming/rocks/rock_64.mdl",
    },

    ["Ruby"] = {
        Name = "Ruby",
        Price = 20,
        Color = Color(224,17,95),
        DropChance = 30,
        ResourceModel = "models/asapgaming/rocks/rock_64.mdl",
    },

    ["Emerald"] = {
        Name = "Emerald",
        Price = 16,
        Color = Color(80,200,120),
        DropChance = 40,
        ResourceModel = "models/asapgaming/rocks/rock_64.mdl",
    },

    ["Diamond"] = {
        Name = "Diamond",
        Price = 24,
        Color = Color(0,168,186),
        DropChance = 35,
        ResourceModel = "models/asapgaming/rocks/rock_64.mdl",
    },
	
	
	
	
}


-------------------------------------------------
-------------------------------------------------
-------------------Upgrade Config----------------
-------------------------------------------------
-------------------------------------------------

-------------------------------------------------
-------------------------------------------------
-------------------Category Config---------------
-------------------------------------------------
-------------------------------------------------


PCMACConfig.Categories = {
	["Guns"] = {
		    ["Icon"] = "OSajkg0",
		    ["Name"] = "Guns",

	},
	["Suits"] = {
		    ["Icon"] = "EzyvHmB",
		    ["Name"] = "Suits",
	},

}

-------------------------------------------------
-------------------------------------------------
-------------------Item Config-------------------
-------------------------------------------------
-------------------------------------------------



PCMACConfig.Items = {
	["m9k_emp_grenade"] = {
		Name = "EMP Grenade",  
		Model = "models/items/grenadeammo.mdl",
		Category = "Guns",
		Costs = {
			["Levels"] = {
					["Value"] = 1,
					["Color"] = Color(250,250,250),
					},
			["Money"] = {
					["Value"] = 250000,
					["Color"] = Color(25,250,25),
					},
			["Iron"] = {
					["Value"] = 1000,
					["Color"] = Color(100,100,100),
					},
			["Bronze"] = {
					["Value"] = 750,
					["Color"] = Color(250,86,15),
					},
			["Ruby"] ={
					["Value"] = 1500,
					["Color"] = Color(250,86,15),
					},
		},
	},

		["tfa_csgo_sonarbomb"] = {
			Name = "Tactical Awareness Grenade",  
			Model = "models/weapons/tfa_csgo/w_eq_sensorgrenade.mdl",
			Category = "Guns",
			Costs = {
				["Levels"] = {
						["Value"] = 2,
						["Color"] = Color(250,250,250),
						},
				["Money"] = {
						["Value"] = 250000,
						["Color"] = Color(25,250,25),
						},
				["Gold"] = {
						["Value"] = 1000,
						["Color"] = Color(255,208,0),
						},
				["Bronze"] = {
						["Value"] = 750,
						["Color"] = Color(250,86,15),
						},
				["Emerald"] ={
						["Value"] = 1500,
						["Color"] = Color(80,200,120),
						},
			},
		},

		["x-8"] = {
			Name = "X-8",  
			Model = "models/weapons/w_pist_revase.mdl",
			Category = "Guns",
			Costs = {
				["Levels"] = {
						["Value"] = 1,
						["Color"] = Color(250,250,250),
						},
				["Money"] = {
						["Value"] = 2500000,
						["Color"] = Color(25,250,25),
						},
				["Gold"] = {
						["Value"] = 1200,
						["Color"] = Color(255,208,0),
						},
				["Bronze"] = {
						["Value"] = 850,
						["Color"] = Color(250,86,15),
						},
				["Emerald"] ={
						["Value"] = 1200,
						["Color"] = Color(80,200,120),
						},
				["Diamond"] ={
						["Value"] = 2500,
						["Color"] = Color(0,168,186),
						},
			},
		},

		["mac_bo2_deathmach"] = {
			Name = "Death Machine V2",  
			Model = "models/weapons/w_bo2_deathmachine.mdl",
			Category = "Guns",
			Costs = {
				["Levels"] = {
						["Value"] = 2,
						["Color"] = Color(250,250,250),
						},
				["Money"] = {
						["Value"] = 5000000,
						["Color"] = Color(25,250,25),
						},
				["Gold"] = {
						["Value"] = 600,
						["Color"] = Color(255,208,0),
						},
				["Bronze"] = {
						["Value"] = 450,
						["Color"] = Color(250,86,15),
						},
				["Emerald"] ={
						["Value"] = 2200,
						["Color"] = Color(80,200,120),
						},
				["Diamond"] ={
						["Value"] = 3500,
						["Color"] = Color(0,168,186),
						},
				["Chromium"] ={
						["Value"] = 1500,
						["Color"] = Color(219,228,235),
						},
			},
		},

		["weapon_hoff_thundergun"] = {
			Name = "Thunder Gun",  
			Model = "models/hoff/weapons/thunder_gun/w_thundergun_pow.mdl",
			Category = "Guns",
			Costs = {
				["Levels"] = {
						["Value"] = 3,
						["Color"] = Color(250,250,250),
						},
				["Money"] = {
						["Value"] = 2500000,
						["Color"] = Color(25,250,25),
						},
				["Gold"] = {
						["Value"] = 2500,
						["Color"] = Color(255,208,0),
						},
				["Bronze"] = {
						["Value"] = 250,
						["Color"] = Color(250,86,15),
						},
				["Emerald"] ={
						["Value"] = 4000,
						["Color"] = Color(80,200,120),
						},

				["Aluminum"] ={
						["Value"] = 1000,
						["Color"] = Color(195,195,195),
						},
			},
		},

		["m27__mystifier"] = {
			Name = "Mystifier",  
			Model = "models/weapons/w_m27_mystifier.mdl",
			Category = "Guns",
			Costs = {
				["Levels"] = {
						["Value"] = 4,
						["Color"] = Color(250,250,250),
						},
				["Money"] = {
						["Value"] = 7500000,
						["Color"] = Color(25,250,25),
						},
				["Gold"] = {
						["Value"] = 1800,
						["Color"] = Color(255,208,0),
						},
				["Bronze"] = {
						["Value"] = 1600,
						["Color"] = Color(250,86,15),
						},
				["Emerald"] ={
						["Value"] = 12000,
						["Color"] = Color(80,200,120),
						},

				["Aluminum"] ={
						["Value"] = 1350,
						["Color"] = Color(195,195,195),
						},

				["Diamond"] ={
						["Value"] = 2000,
						["Color"] = Color(195,195,195),
						},
			},
		},

		["tfa_scavenger"] = {
			Name = "Scavanger",  
			Model = "models/weapons/scavenger/w_scavenger.mdl",
			Category = "Guns",
			Costs = {
				["Levels"] = {
						["Value"] = 5,
						["Color"] = Color(250,250,250),
						},
				["Money"] = {
						["Value"] = 2500000,
						["Color"] = Color(25,250,25),
						},
				["Chromium"] = {
						["Value"] = 1500,
						["Color"] = Color(219,228,235),
						},
				["Ruby"] = {
						["Value"] = 500,
						["Color"] = Color(224,17,95),
						},
				["Iron"] ={
						["Value"] = 2000,
						["Color"] = Color(100,100,100),
						},

				["Aluminum"] ={
						["Value"] = 3000,
						["Color"] = Color(195,195,195),
						},

				["Emerald"] ={
						["Value"] = 1750,
						["Color"] = Color(80,200,120),
						},
			},
		},

		["tfa_wintershowl"] = {
			Name = "Winters Howl",  
			Model = "models/weapons/freezegun/w_freezegun.mdl",
			Category = "Guns",
			Costs = {
				["Levels"] = {
						["Value"] = 6,
						["Color"] = Color(250,250,250),
						},
				["Money"] = {
						["Value"] = 5000000,
						["Color"] = Color(25,250,25),
						},
				["Gold"] = {
						["Value"] = 800,
						["Color"] = Color(255,208,0),
						},
				["Diamond"] = {
						["Value"] = 600,
						["Color"] = Color(0,168,186),
						},
				["Iron"] ={
						["Value"] = 1800,
						["Color"] = Color(100,100,100),
						},

				["Aluminum"] ={
						["Value"] = 2750,
						["Color"] = Color(195,195,195),
						},

				["Emerald"] ={
						["Value"] = 2250,
						["Color"] = Color(80,200,120),
						},
			},
		},

		["tfa_qc_eradicator"] = {
			Name = "Eradicator Railgun",  
			Model = "models/weapons/tfa_qc/w_railgun_eradicator.mdl",
			Category = "Guns",
			Costs = {
				["Levels"] = {
						["Value"] = 7,
						["Color"] = Color(250,250,250),
						},
				["Money"] = {
						["Value"] = 500000,
						["Color"] = Color(25,250,25),
						},
				["Diamond"] = {
						["Value"] = 2500,
						["Color"] = Color(0,168,186),
						},
				["Ruby"] = {
						["Value"] = 1500,
						["Color"] = Color(224,17,95),
						},

				["Aluminum"] ={
						["Value"] = 2500,
						["Color"] = Color(195,195,195),
						},

				["Emerald"] ={
						["Value"] = 750,
						["Color"] = Color(80,200,120),
						},
			},
		},

		["tfa_cso_magnumdrill"] = {
			Name = "Magnum Drill",  
			Model = "models/weapons/tfa_cso/w_magnum_drill.mdl",
			Category = "Guns",
			Costs = {
				["Levels"] = {
						["Value"] = 8,
						["Color"] = Color(250,250,250),
						},
				["Money"] = {
						["Value"] = 10000000,
						["Color"] = Color(25,250,25),
						},
				["Diamond"] = {
						["Value"] = 2600,
						["Color"] = Color(0,168,186),
						},
				["Ruby"] = {
						["Value"] = 900,
						["Color"] = Color(224,17,95),
						},
				["Iron"] ={
						["Value"] = 2500,
						["Color"] = Color(100,100,100),
						},

				["Aluminum"] ={
						["Value"] = 1750,
						["Color"] = Color(195,195,195),
						},
	
				["Bronze"] ={
					["Value"] = 1750,
					["Color"] = Color(250,86,15),
					},
			},
		},

		["tfa_cso_magnumdrill_expert"] = {
			Name = "Fire Drill",  
			Model = "models/weapons/tfa_cso/w_magnum_drill_expert_asap.mdl",
			Category = "Guns",
			Costs = {
				["Levels"] = {
						["Value"] = 9,
						["Color"] = Color(250,250,250),
						},
				["Money"] = {
						["Value"] = 15000000,
						["Color"] = Color(25,250,25),
						},
				["Chromium"] = {
						["Value"] = 4500,
						["Color"] = Color(219,228,235),
						},
				["Ruby"] = {
						["Value"] = 1250,
						["Color"] = Color(224,17,95),
						},
				["Iron"] ={
						["Value"] = 3500,
						["Color"] = Color(100,100,100),
						},

				["Aluminum"] ={
						["Value"] = 2750,
						["Color"] = Color(195,195,195),
						},

				["Emerald"] ={
						["Value"] = 650,
						["Color"] = Color(80,200,120),
						},
	
				["Bronze"] ={
					["Value"] = 2750,
					["Color"] = Color(250,86,15),
					},
			},
		},

		["weapon_gluongun"] = {
			Name = "Gluon Gun",  
			Model = "models/w_gluongun.mdl",
			Category = "Guns",
			Costs = {
				["Levels"] = {
						["Value"] = 9,
						["Color"] = Color(250,250,250),
						},
				["Money"] = {
						["Value"] = 15000000,
						["Color"] = Color(25,250,25),
						},
				["Chromium"] = {
						["Value"] = 4500,
						["Color"] = Color(219,228,235),
						},
				["Ruby"] = {
						["Value"] = 1250,
						["Color"] = Color(224,17,95),
						},
				["Iron"] ={
						["Value"] = 3500,
						["Color"] = Color(100,100,100),
						},

				["Aluminum"] ={
						["Value"] = 2750,
						["Color"] = Color(195,195,195),
						},

				["Emerald"] ={
						["Value"] = 650,
						["Color"] = Color(80,200,120),
						},
	
				["Bronze"] ={
					["Value"] = 2750,
					["Color"] = Color(250,86,15),
					},
			},
		},

	--SUITS BELOW
	["suit_heavyguard"] = {
		Name = "Heavy Guardian Suit",  
		Model = "models/delta/destiny2/titanexilemale.mdl",
		Category = "Suits",
		Costs = {
			["Levels"] = {
					["Value"] = 9,
					["Color"] = Color(250,250,250),
					},
			["Money"] = {
					["Value"] = 15000000,
					["Color"] = Color(25,250,25),
					},
			["Chromium"] = {
					["Value"] = 8500,
					["Color"] = Color(219,228,235),
					},
			["Ruby"] = {
					["Value"] = 2500,
					["Color"] = Color(224,17,95),
					},
			["Iron"] ={
					["Value"] = 3500,
					["Color"] = Color(100,100,100),
					},

			["Aluminum"] ={
					["Value"] = 5850,
					["Color"] = Color(195,195,195),
					},

			["Emerald"] ={
					["Value"] = 3000,
					["Color"] = Color(80,200,120),
					},

			["Bronze"] ={
				["Value"] = 10000,
				["Color"] = Color(250,86,15),
				},

			["Gold"] ={
				["Value"] = 7500,
				["Color"] = Color(255,208,0),
				},
		},
	},

	["suit_royalass"] = {
		Name = "Royal Assassin Suit",  
		Model = "models/epangelmatikes/nc/neo_crusader_g.mdl",
		Category = "Suits",
		Costs = {
			["Levels"] = {
					["Value"] = 7,
					["Color"] = Color(250,250,250),
					},
			["Money"] = {
					["Value"] = 10000000,
					["Color"] = Color(25,250,25),
					},
			["Chromium"] = {
					["Value"] = 4500,
					["Color"] = Color(219,228,235),
					},
			["Ruby"] = {
					["Value"] = 3500,
					["Color"] = Color(224,17,95),
					},
			["Iron"] ={
					["Value"] = 5700,
					["Color"] = Color(100,100,100),
					},

			["Aluminum"] ={
					["Value"] = 1550,
					["Color"] = Color(195,195,195),
					},

			["Emerald"] ={
					["Value"] = 2500,
					["Color"] = Color(80,200,120),
					},

			["Bronze"] ={
				["Value"] = 3000,
				["Color"] = Color(250,86,15),
				},

			["Gold"] ={
				["Value"] = 7500,
				["Color"] = Color(255,208,0),
				},
		},
	},

	["suit_royalkni"] = {
		Name = "Royal Knight Suit",  
		Model = "models/nigt_sentinel_1.mdl",
		Category = "Suits",
		Costs = {
			["Levels"] = {
					["Value"] = 7,
					["Color"] = Color(250,250,250),
					},
			["Money"] = {
					["Value"] = 10000000,
					["Color"] = Color(25,250,25),
					},
			["Chromium"] = {
					["Value"] = 4500,
					["Color"] = Color(219,228,235),
					},
			["Ruby"] = {
					["Value"] = 3500,
					["Color"] = Color(224,17,95),
					},
			["Iron"] ={
					["Value"] = 5700,
					["Color"] = Color(100,100,100),
					},

			["Aluminum"] ={
					["Value"] = 1550,
					["Color"] = Color(195,195,195),
					},

			["Emerald"] ={
					["Value"] = 2500,
					["Color"] = Color(80,200,120),
					},

			["Bronze"] ={
				["Value"] = 3000,
				["Color"] = Color(250,86,15),
				},

			["Gold"] ={
				["Value"] = 7500,
				["Color"] = Color(255,208,0),
				},
		},
	},

	["suit_royalwar"] = {
		Name = "Royal Warrior Suit",  
		Model = "models/vasey105/bdo/armour/phm_00_0007_pm.mdl",
		Category = "Suits",
		Costs = {
			["Levels"] = {
					["Value"] = 8,
					["Color"] = Color(250,250,250),
					},
			["Money"] = {
					["Value"] = 10000000,
					["Color"] = Color(25,250,25),
					},
			["Chromium"] = {
					["Value"] = 4500,
					["Color"] = Color(219,228,235),
					},
			["Ruby"] = {
					["Value"] = 3500,
					["Color"] = Color(224,17,95),
					},
			["Iron"] ={
					["Value"] = 5700,
					["Color"] = Color(100,100,100),
					},

			["Aluminum"] ={
					["Value"] = 1550,
					["Color"] = Color(195,195,195),
					},

			["Emerald"] ={
					["Value"] = 2500,
					["Color"] = Color(80,200,120),
					},

			["Bronze"] ={
				["Value"] = 3000,
				["Color"] = Color(250,86,15),
				},

			["Gold"] ={
				["Value"] = 7500,
				["Color"] = Color(255,208,0),
				},
		},
	},

	["suit_n7"] = {
		Name = "n7 Space Suit",  
		Model = "models/player/combine_soldier_prisonguard.mdl",
		Category = "Suits",
		Costs = {
			["Levels"] = {
					["Value"] = 2,
					["Color"] = Color(250,250,250),
					},
			["Money"] = {
					["Value"] = 5000000,
					["Color"] = Color(25,250,25),
					},
			["Chromium"] = {
					["Value"] = 5500,
					["Color"] = Color(219,228,235),
					},
			["Ruby"] = {
					["Value"] = 2500,
					["Color"] = Color(224,17,95),
					},
			["Iron"] ={
					["Value"] = 1500,
					["Color"] = Color(100,100,100),
					},

			["Aluminum"] ={
					["Value"] = 2850,
					["Color"] = Color(195,195,195),
					},

			["Emerald"] ={
					["Value"] = 1000,
					["Color"] = Color(80,200,120),
					},

			["Bronze"] ={
				["Value"] = 4000,
				["Color"] = Color(250,86,15),
				},

			["Gold"] ={
				["Value"] = 4500,
				["Color"] = Color(255,208,0),
				},
		},
	},

	["suit_speed"] = {
		Name = "Speed Suit",  
		Model = "models/player/n7legion/geth_infiltrator.mdl",
		Category = "Suits",
		Costs = {
			["Levels"] = {
					["Value"] = 1,
					["Color"] = Color(250,250,250),
					},
			["Money"] = {
					["Value"] = 2000000,
					["Color"] = Color(25,250,25),
					},
			["Chromium"] = {
					["Value"] = 5500,
					["Color"] = Color(219,228,235),
					},
			["Ruby"] = {
					["Value"] = 2500,
					["Color"] = Color(224,17,95),
					},
			["Iron"] ={
					["Value"] = 1700,
					["Color"] = Color(100,100,100),
					},

			["Aluminum"] ={
					["Value"] = 3850,
					["Color"] = Color(195,195,195),
					},

			["Emerald"] ={
					["Value"] = 2000,
					["Color"] = Color(80,200,120),
					},

			["Bronze"] ={
				["Value"] = 3000,
				["Color"] = Color(250,86,15),
				},

			["Gold"] ={
				["Value"] = 3500,
				["Color"] = Color(255,208,0),
				},
		},
	},
		
	["suit_tau"] = {
		Name = "TAU Armour",  
		Model = "models/halo4/spartans/masterchief_player.mdl",
		Category = "Suits",
		Costs = {
			["Levels"] = {
					["Value"] = 3,
					["Color"] = Color(250,250,250),
					},
			["Money"] = {
					["Value"] = 6000000,
					["Color"] = Color(25,250,25),
					},
			["Chromium"] = {
					["Value"] = 6500,
					["Color"] = Color(219,228,235),
					},
			["Ruby"] = {
					["Value"] = 1500,
					["Color"] = Color(224,17,95),
					},
			["Iron"] ={
					["Value"] = 2800,
					["Color"] = Color(100,100,100),
					},

			["Aluminum"] ={
					["Value"] = 3850,
					["Color"] = Color(195,195,195),
					},

			["Emerald"] ={
					["Value"] = 2000,
					["Color"] = Color(80,200,120),
					},

			["Bronze"] ={
				["Value"] = 3700,
				["Color"] = Color(250,86,15),
				},

			["Gold"] ={
				["Value"] = 5500,
				["Color"] = Color(255,208,0),
				},
		},
	},

	["suit_gx303"] = {
		Name = "GX303 Suit",  
		Model = "models/me3/blagod/pm/n7soldier.mdl",
		Category = "Suits",
		Costs = {
			["Levels"] = {
					["Value"] = 4,
					["Color"] = Color(250,250,250),
					},
			["Money"] = {
					["Value"] = 7500000,
					["Color"] = Color(25,250,25),
					},
			["Chromium"] = {
					["Value"] = 8500,
					["Color"] = Color(219,228,235),
					},
			["Ruby"] = {
					["Value"] = 2500,
					["Color"] = Color(224,17,95),
					},
			["Iron"] ={
					["Value"] = 3100,
					["Color"] = Color(100,100,100),
					},

			["Aluminum"] ={
					["Value"] = 2750,
					["Color"] = Color(195,195,195),
					},

			["Emerald"] ={
					["Value"] = 2150,
					["Color"] = Color(80,200,120),
					},

			["Bronze"] ={
				["Value"] = 5300,
				["Color"] = Color(250,86,15),
				},

			["Gold"] ={
				["Value"] = 6500,
				["Color"] = Color(255,208,0),
				},
		},
	},

	["suit_x60"] = {
		Name = "x60 Space Suit",  
		Model = "models/player/n7legion/cerberus_guardian.mdl",
		Category = "Suits",
		Costs = {
			["Levels"] = {
					["Value"] = 5,
					["Color"] = Color(250,250,250),
					},
			["Money"] = {
					["Value"] = 7500000,
					["Color"] = Color(25,250,25),
					},
			["Chromium"] = {
					["Value"] = 5500,
					["Color"] = Color(219,228,235),
					},
			["Ruby"] = {
					["Value"] = 4500,
					["Color"] = Color(224,17,95),
					},
			["Iron"] ={
					["Value"] = 5000,
					["Color"] = Color(100,100,100),
					},

			["Aluminum"] ={
					["Value"] = 3650,
					["Color"] = Color(195,195,195),
					},

			["Emerald"] ={
					["Value"] = 2550,
					["Color"] = Color(80,200,120),
					},

			["Bronze"] ={
				["Value"] = 3300,
				["Color"] = Color(250,86,15),
				},

			["Gold"] ={
				["Value"] = 5850,
				["Color"] = Color(255,208,0),
				},
		},
	},

	["suit_x99"] = {
		Name = "x99 Space Suit",  
		Model = "models/suno/player/ghost/ply_ghost.mdl",
		Category = "Suits",
		Costs = {
			["Levels"] = {
					["Value"] = 6,
					["Color"] = Color(250,250,250),
					},
			["Money"] = {
					["Value"] = 7500000,
					["Color"] = Color(25,250,25),
					},
			["Chromium"] = {
					["Value"] = 5500,
					["Color"] = Color(219,228,235),
					},
			["Ruby"] = {
					["Value"] = 4500,
					["Color"] = Color(224,17,95),
					},
			["Iron"] ={
					["Value"] = 5000,
					["Color"] = Color(100,100,100),
					},

			["Aluminum"] ={
					["Value"] = 3650,
					["Color"] = Color(195,195,195),
					},

			["Emerald"] ={
					["Value"] = 2550,
					["Color"] = Color(80,200,120),
					},

			["Bronze"] ={
				["Value"] = 3300,
				["Color"] = Color(250,86,15),
				},

			["Gold"] ={
				["Value"] = 5850,
				["Color"] = Color(255,208,0),
				},
		},
	},

}


-------------------------------------------------
-------------------------------------------------
-------------------Dont Touch--------------------
-------------------------------------------------
-------------------------------------------------

local ENT = {}

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "MiningBonusSpot"
ENT.Author = "PcShadowwZ"
ENT.Spawnable = true
ENT.Category = "Rocks"
ENT.Parent = nil
if ( SERVER ) then
	function ENT:Initialize()
		self:SetModel( "models/Combine_Helicopter/helicopter_bomb01.mdl" )         
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetModelScale(5)
		self:SetMaterial("models/shadertest/shader4")
		self:SetNWString("Name", "Iron")
		self:DrawShadow(false)
		local phys = self:GetPhysicsObject() 
	   	if (phys) then
			phys:EnableMotion(false)
	   	end
	end	

	function ENT:OnTakeDamage(dmg)
		local ply = dmg:GetAttacker()
		if !ply:Alive() or !ply:IsPlayer() then return end
		if ply:GetActiveWeapon():GetClass() != "pcmac_pickaxe" then return end
		PCMAC_MineBonus(ply)
		self.Parent.bonusEnt = nil
		self:Remove()
	end
else
	function ENT:Draw()
		self:DrawModel()
	end
end

scripted_ents.Register( ENT, "bonus_ore" )

local bonusRandPositions = {
	Vector(30,0,15),
	Vector(-27,0,15),
	Vector(-10,32,8),
	Vector(10,-30,5),
	Vector(10,-10,23),
}

for k, v in pairs( PCMACConfig.Ores ) do
	local ENT = {}
	
	ENT.Type = "anim"
	ENT.Base = "base_gmodentity"
	ENT.PrintName = v.Name.." Ore"
	ENT.Author = "PcShadowwZ"
	ENT.Spawnable = true
	ENT.Category = "Rocks"
    

	function ENT:OnTakeDamage(dmg)
		local ply = dmg:GetAttacker()
		if !ply:Alive() or !ply:IsPlayer() then return end
		if !ply.PCMACMaterials[self:GetNWString("Name")] then return end
		if ply:GetActiveWeapon():GetClass() != "pcmac_pickaxe" then return end
		PCMAC_MineOre(ply, self:GetNWString("Name"))
	end

    if ( SERVER ) then
        function ENT:Initialize()
            self:SetModel( v.ResourceModel )       -- v.ResourceModel  
	    self:PhysicsInit(SOLID_VPHYSICS) 
            self:SetMoveType(MOVETYPE_VPHYSICS)
            self:SetSolid(SOLID_VPHYSICS)
	    self:SetColor(v.Color)
		self.bonusEnt = nil
	    self:SetNWString("Name", v.Name)
            local phys = self:GetPhysicsObject() 
   	    if (phys) then
    		phys:EnableMotion(false)
  	     end
        end	

		function ENT:Think()
			self:NextThink(CurTime() + 30)
			if !self.bonusEnt then
				self.bonusEnt = ents.Create("bonus_ore")
				self.bonusEnt:SetPos(self:GetPos() + table.Random(bonusRandPositions))
				self.bonusEnt:Spawn()
				self.bonusEnt:SetNWString("Name", v.Name)
				self.bonusEnt.Parent = self
				self.bonusEnt:SetModelScale(.75) 
				self.bonusEnt:Activate()
			end
			return true
		end
    else

		

function ENT:Draw()
  self:DrawModel()

  local ply = LocalPlayer()
  local pos = self:GetPos()
  local eyePos = ply:GetPos()
  local dist = pos:Distance(eyePos)
  local alpha = math.Clamp(500 - dist * 2.7, 0, 255)

  if (alpha <= 0) then return end

  local angle = self:GetAngles()
  local eyeAngle = ply:EyeAngles()

  angle:RotateAroundAxis(angle:Forward(), 90)
  angle:RotateAroundAxis(angle:Right(), - 90)
  
  cam.Start3D2D(pos + self:GetUp() * 50, Angle(0, eyeAngle.y - 90, 90), 0.04)
    draw.SimpleText(v.Name.." Ore","GlobalFont_200", 0,0,v.Color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
  cam.End3D2D()

end
end
	
	scripted_ents.Register( ENT, string.lower(v.Name).."_ore" )
	

end


function PCMAC:GetMaxOre(ply,ore)
	return 1000 * math.Clamp(ply:PC_Leveling_GetLevel(4),0.5,999)
end