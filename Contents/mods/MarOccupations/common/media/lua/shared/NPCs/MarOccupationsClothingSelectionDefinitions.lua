ClothingSelectionDefinitions.mar_demolitionworker = {
    -- if there's no difference between male/female outfit, just create the female one, here we can have skirt
	Female = {
		Hat = {
			chance = 10,
			items = {"Base.Hat_Beany"},
		},

		Mask = {
			chance = 5,
			items = {"Base.Hat_DustMask"},
		},	

		Eyes = {
			chance = 10,
			items = {"Base.Glasses_SafetyGoggles"},
		},

		Hands = {
			chance = 20,
			items = {"Base.Gloves_FingerlessGloves"},
		},

		Shirt = {
			items = {
                "Base.Shirt_Denim", 
                "Base.Shirt_Workman"
            },
		},

		Pants = {
			items = {"Base.Trousers_JeanBaggy"},
		},

		Shoes = {
			items = {
                "Base.Shoes_BlackBoots", 
                "Base.Shoes_Wellies", 
                "Base.Shoes_ArmyBoots"
            },
		},	

		TorsoExtra = {
			chance = 25,
			items = {"Base.Vest_HighViz"},
		},		
	},
}

ClothingSelectionDefinitions.mar_miner = {
	Female = {
		Hat = {
			chance = 10,
			items = {"Base.Hat_Beany",},
		},

		Mask = {
			chance = 5,
			items = {"Base.Hat_DustMask", },
		},	

		Eyes = {
			chance = 10,
			items = {"Base.Glasses_SafetyGoggles"},
		},

		Shirt = {
			items = {
                "Base.Shirt_Denim", 
                "Base.Shirt_Workman"
            },
		},
        
		Pants = {
			items = {
                "Base.Trousers_JeanBaggy", 
                "Base.Dungarees"
            },
		},

		Shoes = {
			items = {
                "Base.Shoes_BlackBoots", 
                "Base.Shoes_Wellies", 
                "Base.Shoes_ArmyBoots"
            },
		},	

		TorsoExtra = {
			chance = 30,
			items = {"Base.Vest_HighViz"},
		},			
	},
}

ClothingSelectionDefinitions.mar_waiter = {
    -- if there's no difference between male/female outfit, just create the female one, here we can have skirt
	Female = {
        Neck = {
			chance = 25,
			items = {
                "Base.Tie_BowTieFull", 
                "Base.Tie_BowTieWorn"
            },
		},

		Shirt = {
            chance = 30,
			items = {"Base.Shirt_FormalTINT"},
		},

		Pants = {
            chance = 30,
			items = {"Base.Trousers_SuitTEXTURE"},
		},
	},
}

ClothingSelectionDefinitions.mar_tailor = {
    -- if there's no difference between male/female outfit, just create the female one, here we can have skirt
	Female = {
		Neck = {
			chance = 30,
			items = {"Base.Tie_Full"},
		},

		Shirt = {
			items = {"Base.Shirt_FormalTINT"},
		},

		Pants = {
			items = {"Base.Trousers_SuitTEXTURE"},
		},
	},
}

ClothingSelectionDefinitions.mar_mortician = {
    -- if there's no difference between male/female outfit, just create the female one, here we can have skirt
	Female = {
		Neck = {
			chance = 50,
			items = {
                "Base.Tie_Full", 
            },
		},

		Hat = {
			chance = 5,
			items = {
                "Base.Hat_SurgicalMask", 
            },
		},
		
		Shirt = {
			items = {
                "Base.Shirt_FormalTINT", 
                "Base.Shirt_Scrubs"
            },
		},

        FullSuit = {
			chance = 5,
			items = {
                "Base.Boilersuit"
            },
		},
		
		Hands = {
			chance = 15,
			items = {
                "Base.Gloves_Surgical"
            },
		},
		
		Pants = {
			items = {
                "Base.Trousers_SuitTEXTURE"
            },
		},
	},
}

ClothingSelectionDefinitions.mar_cleaner = {
	Female = {
		Shirt = {
			items = {
                "Base.Shirt_Denim",
                "Base.Shirt_Workman"
            },
		},

		Pants = {
			items = {
                "Base.Trousers_JeanBaggy"
            },
		},

		Shoes = {
			chance = 20,
			items = {
                "Base.Shoes_Wellies"
            },
		},

        Hands = {
			chance = 30,
			items = {
                "Base.Gloves_Surgical", 
                "Base.Gloves_Dish"
            },
		},

        FullSuit = {
			chance = 30,
			items = {
                "Base.Boilersuit"
            },
		},
	},
}

ClothingSelectionDefinitions.mar_privateinvestigator = {
	Female = {
		Hat = {
			chance = 30,
			items = {
                "Base.Hat_Fedora", 
                "Base.Hat_BaseballCapRed", 
                "Base.Hat_BaseballCapBlue", 
                "Base.Hat_BaseballCapGreen"
            },
		},

		Eyes = {
			chance = 30,
			items = {
                "Base.Glasses_Sun"
            },
		},

        Neck = {
			chance = 20,
			items = {
                "Base.Tie_Full"
            },
		},

		Jacket = {
			chance = 15,
			items = {
                "Base.JacketLong_Random"
            },
		},	
	},
}

ClothingSelectionDefinitions.mar_butcher = {
	Female = {
		Neck = {
			chance = 10,
			items = {
                "Base.Tie_Full"
            },
		},

		TorsoExtra = {
			chance = 70,		
			items = {
                "Base.Apron_White", 
                "Base.Apron_Black"
            },
		},

        Hands = {
			chance = 30,
			items = {
                "Base.Gloves_Surgical"
            },
		},

		Pants = {
			items = {
                "Base.Trousers_Suit"
            },
		},
	}
}

ClothingSelectionDefinitions.mar_athlete = {
	Female = {
		Shirt = {
            chance = 60,
			items = {
                "Tshirt_SportDECAL", 
                "Tshirt_Sport"
            },
		},

		Pants = {
            chance = 60,
			items = {
                "Base.Shorts_LongSport_Red",
                "Base.Shorts_LongSport",
                "Base.Trousers_Sport",
                "Base.Shorts_ShortSport",
            },
		},
	}
}

ClothingSelectionDefinitions.mar_federalofficer = {
	Female = {
	
		Hat = {
			chance = 10,
			items = {
                "Base.Hat_Police",
                "Base.Hat_BaseballCap_Police"
            },
		},
		
		Eyes = {
			chance = 10,
			items = {
                "Base.Glasses", 
                "Base.Glasses_Aviators"
            },
		},
		
		Shirt = {
			chance = 20,
			items = {
                "Base.Shirt_OfficerWhite", 
                "Base.Shirt_PoliceBlue" , 
                "Base.Tshirt_PoliceBlue"
            },
		},
		
		Tshirt = {
			items = {
                "Base.Tshirt_Profession_PoliceBlue", 
                "Base.Tshirt_Profession_PoliceWhite"
            },
		},
		
		Pants = {
			items = {"Base.Trousers_Police"},
		},
	}
}

ClothingSelectionDefinitions.mar_mason = {
	Female = {
		Shirt = {
			items = {"Base.Shirt_Denim"},
		},
		
		TorsoExtra = {
			chance = 30,
			items = {"Base.Vest_HighViz"},
		},
		
		Pants = {
			items = {"Base.Trousers_JeanBaggy"},
		},
		
	},
}