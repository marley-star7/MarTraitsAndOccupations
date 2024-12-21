require("MarLibrary")

MarTraits = MarTraits or {}

local function addMarTraits()
	--=============--
	-- Good Traits --
	--=============--
	local traitLeadFoot = MarLibrary.addTrait("LeadFoot", 2)
	local traitThickBlooded = MarLibrary.addTrait("ThickBlooded", 3)
	local traitCruel = MarLibrary.addTrait("Cruel", 4)
	-- SPORT TRAITS --
	-- Basketball Player
	local traitBasketballPlayer = MarLibrary.addTrait("BasketballPlayer", 3)
	traitBasketballPlayer:addXPBoost(Perks.Nimble, 1)
	-- Racket Player
	local traitRacketPlayer = MarLibrary.addTrait("RacketPlayer", 4)
	traitRacketPlayer:addXPBoost(Perks.SmallBlunt, 1)
	-- Soccer Player
	local traitSoccerPlayer = MarLibrary.addTrait("SoccerPlayer", 5)
	traitSoccerPlayer:addXPBoost(Perks.Sprinting, 1)
	traitSoccerPlayer:addXPBoost(Perks.Lightfoot, 1)
	-- Football Player
	local traitFootballPlayer = MarLibrary.addTrait("FootballPlayer", 6)
	traitFootballPlayer:addXPBoost(Perks.Sprinting, 1)
	traitFootballPlayer:addXPBoost(Perks.Strength, 1)
	-- SKILL TRAITS --
	-- Tinkerer
	local traitTinkerer = MarLibrary.addTrait("Tinkerer", 5)
	traitTinkerer:addXPBoost(Perks.Electricity, 1)
	traitTinkerer:getFreeRecipes():add("Make Remote Controller V1")
	traitTinkerer:getFreeRecipes():add("Make Remote Controller V2")
	traitTinkerer:getFreeRecipes():add("Make Remote Controller V3")
	traitTinkerer:getFreeRecipes():add("Make Timer")
	traitTinkerer:getFreeRecipes():add("Make Remote Trigger")
	traitTinkerer:getFreeRecipes():add("Make Noise Maker")
	traitTinkerer:getFreeRecipes():add("Make Smoke Bomb")
	traitTinkerer:getFreeRecipes():add("Craft Makeshift Radio")
	traitTinkerer:getFreeRecipes():add("Craft Makeshift HAM Radio")
	traitTinkerer:getFreeRecipes():add("Craft Makeshift Walkie Talkie")
	traitTinkerer:getFreeRecipes():add("Generator")
	-- Welder
	local traitAmateurWelder = MarLibrary.addTrait("AmateurWelder", 5)
	traitAmateurWelder:addXPBoost(Perks.MetalWelding, 1)
	traitAmateurWelder:getFreeRecipes():add("Make Metal Walls")
	traitAmateurWelder:getFreeRecipes():add("Make Metal Roof")
	traitAmateurWelder:getFreeRecipes():add("Make Metal Containers")
	traitAmateurWelder:getFreeRecipes():add("Make Metal Fences")
	traitAmateurWelder:getFreeRecipes():add("Make Metal Sheet")
	traitAmateurWelder:getFreeRecipes():add("Make Small Metal Sheet")
	-- BEYOND
	local traitExpertDriver = MarLibrary.addTrait("ExpertDriver", 5)
	local traitFastWorker = MarLibrary.addTrait("FastWorker", 6)
	local traitLithe = MarLibrary.addTrait("Lithe", 6)
	traitLithe:addXPBoost(Perks.Nimble, 1)
	local traitPackMule = MarLibrary.addTrait("PackMule", 6)
	local traitUnwavering = MarLibrary.addTrait("Unwavering", 6)
	local traitBatteringRam = MarLibrary.addTrait("BatteringRam", 8)
	traitBatteringRam:addXPBoost(Perks.Strength, 2)
	-- Gun Knowledge
	local traitGunKnowledge = MarLibrary.addTrait("GunKnowledge", 8)
	traitGunKnowledge:addXPBoost(Perks.Aiming, 1)
	traitGunKnowledge:addXPBoost(Perks.Reloading, 1)
	-- Gun Proficient
	local traitGunProficient = MarLibrary.addTrait("GunProficient", 12)
	traitGunProficient:addXPBoost(Perks.Aiming, 2)
	traitGunProficient:addXPBoost(Perks.Reloading, 2)
	-- Desensitized
	local traitDesensitized = TraitFactory.addTrait("Desensitized2", getText("UI_trait_Desensitized"), 12, getText("UI_trait_DesensitizedDesc"), false)
	TraitFactory.setMutualExclusive("Dextrous2", "Dextrous")
	-- Ingenuitive
	local traitIngenuitive = MarLibrary.addTrait("Ingenuitive", 5)
	traitIngenuitive:getFreeRecipes():add("Generator")
	traitIngenuitive:getFreeRecipes():add("Make Mildew Cure")
	traitIngenuitive:getFreeRecipes():add("Make Flies Cure")
	traitIngenuitive:getFreeRecipes():add("Make Cake Batter")
	traitIngenuitive:getFreeRecipes():add("Make Pie Dough")
	traitIngenuitive:getFreeRecipes():add("Make Bread Dough")
	traitIngenuitive:getFreeRecipes():add("Herbalist")
	traitIngenuitive:getFreeRecipes():add("Make Stick Trap")
	traitIngenuitive:getFreeRecipes():add("Make Snare Trap")
	traitIngenuitive:getFreeRecipes():add("Make Wooden Cage Trap")
	traitIngenuitive:getFreeRecipes():add("Make Trap Box")
	traitIngenuitive:getFreeRecipes():add("Make Cage Trap")
	traitIngenuitive:getFreeRecipes():add("Basic Mechanics")
	traitIngenuitive:getFreeRecipes():add("Intermediate Mechanics")
	traitIngenuitive:getFreeRecipes():add("Advanced Mechanics")
	traitIngenuitive:getFreeRecipes():add("Make Fishing Rod")
	traitIngenuitive:getFreeRecipes():add("Fix Fishing Rod")
	traitIngenuitive:getFreeRecipes():add("Get Wire Back")
	traitIngenuitive:getFreeRecipes():add("Make Fishing Net")
	traitIngenuitive:getFreeRecipes():add("Make Remote Controller V1")
	traitIngenuitive:getFreeRecipes():add("Make Remote Controller V2")
	traitIngenuitive:getFreeRecipes():add("Make Remote Controller V3")
	traitIngenuitive:getFreeRecipes():add("Make Remote Trigger")
	traitIngenuitive:getFreeRecipes():add("Make Timer")
	traitIngenuitive:getFreeRecipes():add("Craft Makeshift Radio")
	traitIngenuitive:getFreeRecipes():add("Craft Makeshift HAM Radio")
	traitIngenuitive:getFreeRecipes():add("Craft Makeshift Walkie Talkie")
	traitIngenuitive:getFreeRecipes():add("Make Aerosol bomb")
	traitIngenuitive:getFreeRecipes():add("Make Flame bomb")
	traitIngenuitive:getFreeRecipes():add("Make Pipe bomb")
	traitIngenuitive:getFreeRecipes():add("Make Noise generator")
	traitIngenuitive:getFreeRecipes():add("Make Smoke Bomb")
	traitIngenuitive:getFreeRecipes():add("Make Metal Walls")
	traitIngenuitive:getFreeRecipes():add("Make Metal Fences")
	traitIngenuitive:getFreeRecipes():add("Make Metal Containers")
	traitIngenuitive:getFreeRecipes():add("Make Metal Sheet")
	traitIngenuitive:getFreeRecipes():add("Make Small Metal Sheet")
	traitIngenuitive:getFreeRecipes():add("Make Metal Roof")
	--===========--
	--Bad Traits--
	--===========--
	if isDebugEnabled() then local traitColorBlind = MarLibrary.addTrait("ColorBlind", -1) end
	local traitFearHeight = MarLibrary.addTrait("Acrophobic", -2)
	local traitFearDark = MarLibrary.addTrait("Nyctophobic", -2)
	local traitThinBlooded = MarLibrary.addTrait("ThinBlooded", -3)
	--local traitSensitiveStomach = addTrait("SensitiveStomach", -3)
	local traitAllergic = MarLibrary.addTrait("Allergic", -3)
	local traitDepressive = MarLibrary.addTrait("Depressive", -4)
	local traitBroken = MarLibrary.addTrait("Broken", -5)
	local traitPoorDriver = MarLibrary.addTrait("PoorDriver", -5)
	local traitLumbering = MarLibrary.addTrait("Lumbering", -6)
	local traitSlowWorker = MarLibrary.addTrait("SlowWorker", -6)
	local traitPackMouse = MarLibrary.addTrait("PackMouse", -6)
	local traitAlcoholic = MarLibrary.addTrait("Alcoholic", -6)
	local traitAntiGun = MarLibrary.addTrait("AntiGun", -6)
	local traitFearful = MarLibrary.addTrait("Fearful", -7)
	local traitInattentive = MarLibrary.addTrait("Inattentive", -8)
	local traitMinorLimp = MarLibrary.addTrait("MinorLimp", -12)
	local traitMajorLimp = MarLibrary.addTrait("MajorLimp", -24)
	--=================--
	--Occupation Traits--
	--=================--
	--===========--
	--Exclusives--
	--===========--
	TraitFactory.setMutualExclusive("Cruel", "Pacifist")
	TraitFactory.setMutualExclusive("GunProficient", "GunKnowledge")
	TraitFactory.setMutualExclusive("BaseballPlayer", "BasketballPlayer")
	TraitFactory.setMutualExclusive("BaseballPlayer", "SoccerPlayer")
	TraitFactory.setMutualExclusive("BaseballPlayer", "RacketPlayer")
	TraitFactory.setMutualExclusive("FootballPlayer", "BaseballPlayer")
	TraitFactory.setMutualExclusive("FootballPlayer", "SoccerPlayer")
	TraitFactory.setMutualExclusive("FootballPlayer", "RacketPlayer")
	TraitFactory.setMutualExclusive("BasketballPlayer", "FootballPlayer")
	TraitFactory.setMutualExclusive("BasketballPlayer", "SoccerPlayer")
	TraitFactory.setMutualExclusive("BasketballPlayer", "RacketPlayer")
	TraitFactory.setMutualExclusive("SoccerPlayer", "RacketPlayer")
	TraitFactory.setMutualExclusive("MinorLimp", "MajorLimp")
	TraitFactory.setMutualExclusive("MinorLimp", "Broken")
	TraitFactory.setMutualExclusive("MajorLimp", "Broken")
	TraitFactory.setMutualExclusive("Fearful", "Brave")
	TraitFactory.setMutualExclusive("Fearful", "Desensitized")
	TraitFactory.setMutualExclusive("Fearful", "Desensitized2")
	TraitFactory.setMutualExclusive("Desensitized2", "Desensitized")
	TraitFactory.setMutualExclusive("Desensitized2", "Cowardly")
	TraitFactory.setMutualExclusive("Desensitized2", "Brave")
	TraitFactory.setMutualExclusive("Desensitized2", "AdrenalineJunkie")
	TraitFactory.setMutualExclusive("Desensitized2", "Agoraphobic")
	TraitFactory.setMutualExclusive("Desensitized2", "Claustophobic")
	TraitFactory.setMutualExclusive("Lithe", "Lumbering")
	TraitFactory.setMutualExclusive("BatteringRam", "Strong")
	TraitFactory.setMutualExclusive("BatteringRam", "Weak")
	TraitFactory.setMutualExclusive("BatteringRam", "Feeble")
	TraitFactory.setMutualExclusive("ColdTolerant", "ColdIntolerant")
	TraitFactory.setMutualExclusive("HeatTolerant", "HeatIntolerant")
	TraitFactory.setMutualExclusive("ThickBlooded", "ThinBlooded")
	TraitFactory.setMutualExclusive("ExpertDriver", "PoorDriver")
	TraitFactory.setMutualExclusive("PackMule", "PackMouse")
	TraitFactory.setMutualExclusive("FastWorker", "SlowWorker")
	TraitFactory.setMutualExclusive("Nyctophobic", "NightVision")
	if getActivatedMods():contains("MarTraitsBlind") then
		TraitFactory.setMutualExclusive("Blind", "Nyctophobic")
	end
	TraitFactory.sortList()
	--===================--
	-- TRAITS IN TESTING --
	--===================--
	-- Need to write some code for adding recipes from all mods
	if isDebugEnabled() then
		-- IN LIST OF PRIORITY TO COMPLETE
		if getActivatedMods():contains("MoodleFramework") == true then
			traitAngry = MarLibrary.addTrait("Angry", -5)
		end

		local traitColdIntolerant = MarLibrary.addTrait("ColdIntolerant", -1)
		local traitHeatIntolerant = MarLibrary.addTrait("HeatIntolerant", -3)
		local traitColdTolerant = MarLibrary.addTrait("ColdTolerant", 1)
		local traitHeatTolerant = MarLibrary.addTrait("HeatTolerant", 3)
		local traitFragile = MarLibrary.addTrait("Fragile", -10)
		local traitSnorer = MarLibrary.addTraitSinglePlayerOnly("Snorer", -1, true)
		local traitMicrowaveSyndrome = MarLibrary.addTrait("MicrowaveSyndrome", -12)
		local traitDeprived = MarLibrary.addTrait("Deprived", -1)
	end
end

function MarTraits.doNewCharacterTraitSwaps(playernum, player)
	local player = getSpecificPlayer(playernum)
	-- Swap them traits

	if player:HasTrait("Desensitized2") then
		player:getTraits():remove("Desensitized2")
		player:getTraits():add("Desensitized")
	end
end

Events.OnCreatePlayer.Add(MarTraits.doNewCharacterTraitSwaps)

Events.OnGameBoot.Add(addMarTraits)