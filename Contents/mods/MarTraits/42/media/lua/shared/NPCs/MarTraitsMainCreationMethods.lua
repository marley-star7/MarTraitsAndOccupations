require("MarLibrary")

MarTraits = MarTraits or {}

local function addMarTraits()
	-- SPORT TRAITS --
	local traitRacketPlayer = MarLibrary.addTrait("RacketPlayer", 4)
	traitRacketPlayer:addXPBoost(Perks.SmallBlunt, 1)

	local traitBasketballPlayer = MarLibrary.addTrait("BasketballPlayer", 4)
	traitBasketballPlayer:addXPBoost(Perks.Nimble, 1)

	local traitSoccerPlayer = MarLibrary.addTrait("SoccerPlayer", 6)
	traitSoccerPlayer:addXPBoost(Perks.Running, 1)
	traitSoccerPlayer:addXPBoost(Perks.Nimble, 1)

	local traitFootballPlayer = MarLibrary.addTrait("FootballPlayer", 6)
	traitFootballPlayer:addXPBoost(Perks.Strength, 1)
	traitFootballPlayer:addXPBoost(Perks.Running, 1)

	-- KNOWLEDGE TRAITS --
	local traitElectricalKnowledge = MarLibrary.addTrait("ElectricalKnowledge", 5)
	traitElectricalKnowledge:addXPBoost(Perks.Electricity, 1)
	traitElectricalKnowledge:getFreeRecipes():add("Make Remote Controller V1")
	traitElectricalKnowledge:getFreeRecipes():add("Make Remote Controller V2")
	traitElectricalKnowledge:getFreeRecipes():add("Make Remote Controller V3")
	traitElectricalKnowledge:getFreeRecipes():add("Make Timer")
	traitElectricalKnowledge:getFreeRecipes():add("Make Remote Trigger")
	traitElectricalKnowledge:getFreeRecipes():add("Make Noise Maker")
	traitElectricalKnowledge:getFreeRecipes():add("Make Smoke Bomb")
	traitElectricalKnowledge:getFreeRecipes():add("Craft Makeshift Radio")
	traitElectricalKnowledge:getFreeRecipes():add("Craft Makeshift HAM Radio")
	traitElectricalKnowledge:getFreeRecipes():add("Craft Makeshift Walkie Talkie")
	traitElectricalKnowledge:getFreeRecipes():add("Generator")

	local traitWeldingKnowledge = MarLibrary.addTrait("WeldingKnowledge", 6)
	traitWeldingKnowledge:addXPBoost(Perks.Welding, 1)
	traitWeldingKnowledge:getFreeRecipes():add("Make Metal Walls")
	traitWeldingKnowledge:getFreeRecipes():add("Make Metal Roof")
	traitWeldingKnowledge:getFreeRecipes():add("Make Metal Containers")
	traitWeldingKnowledge:getFreeRecipes():add("Make Metal Fences")
	traitWeldingKnowledge:getFreeRecipes():add("Make Metal Sheet")
	traitWeldingKnowledge:getFreeRecipes():add("Make Small Metal Sheet")

	local traitGunKnowledge = MarLibrary.addTrait("GunKnowledge", 7)
	traitGunKnowledge:addXPBoost(Perks.Aiming, 1)
	traitGunKnowledge:addXPBoost(Perks.Reloading, 1)

	-- BLOOD TRAITS --
	local traitThickBlooded = MarLibrary.addTrait("ThickBlooded", 2)
	local traitThinBlooded = MarLibrary.addTrait("ThinBlooded", -3)

	-- OTHER TRAITS --

	--===========--
	-- EXCLUSIVES --
	--===========--

	TraitFactory.sortList()
end

Events.OnGameBoot.Add(addMarTraits)