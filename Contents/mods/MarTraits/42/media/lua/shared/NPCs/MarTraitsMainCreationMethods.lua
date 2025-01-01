require("MarLibrary.Traits")

local function addMarTraitsTraits()
	-- SPORT TRAITS --
	local traitRacketPlayer = MarLibrary.Traits.addTrait("Mar_RacketPlayer", 4)
	traitRacketPlayer:addXPBoost(Perks.SmallBlunt, 1)

	local traitBasketballPlayer = MarLibrary.Traits.addTrait("Mar_BasketballPlayer", 4)
	traitBasketballPlayer:addXPBoost(Perks.Nimble, 1)

	local traitSoccerPlayer = MarLibrary.Traits.addTrait("Mar_SoccerPlayer", 6)
	traitSoccerPlayer:addXPBoost(Perks.Sprinting, 1)
	traitSoccerPlayer:addXPBoost(Perks.Nimble, 1)

	local traitFootballPlayer = MarLibrary.Traits.addTrait("Mar_FootballPlayer", 6)
	traitFootballPlayer:addXPBoost(Perks.Strength, 1)
	traitFootballPlayer:addXPBoost(Perks.Sprinting, 1)

	-- KNOWLEDGE TRAITS --
	local traitElectricalKnowledge = MarLibrary.Traits.addTrait("Mar_ElectricalKnowledge", 5)
	traitElectricalKnowledge:addXPBoost(Perks.Electricity, 1)
    traitElectricalKnowledge:getFreeRecipes():add("Generator");
    traitElectricalKnowledge:getFreeRecipes():add("MakeRemoteControllerV1");
    traitElectricalKnowledge:getFreeRecipes():add("MakeRemoteControllerV2");
    traitElectricalKnowledge:getFreeRecipes():add("MakeRemoteControllerV3");
    traitElectricalKnowledge:getFreeRecipes():add("MakeRemoteTrigger");
    traitElectricalKnowledge:getFreeRecipes():add("MakeTimer");
    traitElectricalKnowledge:getFreeRecipes():add("CraftMakeshiftRadio");
    traitElectricalKnowledge:getFreeRecipes():add("CraftMakeshiftHAMRadio");
    traitElectricalKnowledge:getFreeRecipes():add("CraftMakeshiftWalkieTalkie");
    traitElectricalKnowledge:getFreeRecipes():add("MakeImprovisedFlashlight");
    traitElectricalKnowledge:getFreeRecipes():add("MakeImprovisedLantern");
	ProfessionFactory.getProfession("electrician"):addFreeTrait(MarLibrary.Traits.addTraitCopy("Mar_ElectricalKnowledge", 0, "Mar_ElectricalKnowledge_copy"))

	local traitWeldingKnowledge = MarLibrary.Traits.addTrait("Mar_WeldingKnowledge", 6)
	traitWeldingKnowledge:addXPBoost(Perks.MetalWelding, 1)
	traitWeldingKnowledge:getFreeRecipes():add("Make Metal Walls")
	traitWeldingKnowledge:getFreeRecipes():add("Make Metal Roof")
	traitWeldingKnowledge:getFreeRecipes():add("Make Metal Containers")
	traitWeldingKnowledge:getFreeRecipes():add("Make Metal Fences")
	traitWeldingKnowledge:getFreeRecipes():add("Make Metal Sheet")
	traitWeldingKnowledge:getFreeRecipes():add("Make Small Metal Sheet")
	ProfessionFactory.getProfession("metalworker"):addFreeTrait(MarLibrary.Traits.addTraitCopy("Mar_WeldingKnowledge", 0, "Mar_WeldingKnowledge_copy"))

	local traitGunKnowledge = MarLibrary.Traits.addTrait("Mar_GunKnowledge", 7)
	traitGunKnowledge:addXPBoost(Perks.Aiming, 1)
	traitGunKnowledge:addXPBoost(Perks.Reloading, 1)

	-- VOLUME TRAITS --
	local traitQuiet = MarLibrary.Traits.addTrait("Mar_Quiet", 3)
	traitQuiet:addXPBoost(Perks.Sneak, 1)

	-- FEAR TRAITS --
	local traitFearful = MarLibrary.Traits.addTrait("Mar_Fearful", -4)
	local traitNyctophobic = MarLibrary.Traits.addTrait("Mar_Nyctophobic", -2)
	local traitAcrophobic = MarLibrary.Traits.addTrait("Mar_Acrophobic", -1)
	MarLibrary.Traits.addTraitTimedActionSpeedModifierList(
		"Mar_Acrophobic", 
		{"ISClimbSheetRopeAction", -1 }
	)
	-- LIMP TRAITS --
	local traitMinorLimp = MarLibrary.Traits.addTrait("Mar_MinorLimp", -12)
	local traitMajorLimp = MarLibrary.Traits.addTrait("Mar_MajorLimp", -24)
	-- local traitBrokeLeg = MarLibrary.Traits.addTrait("Mar_BrokeLeg", -1) -- Disabled for not fitting into zomboids new style of traits.
	-- XP TRAITS --
	local traitWarMonger = MarLibrary.Traits.addTrait("Mar_WarMonger", 4)
	local traitArtist = MarLibrary.Traits.addTrait("Mar_Artist", 2)
	-- BLOOD TRAITS --
	local traitThickBlooded = MarLibrary.Traits.addTrait("Mar_ThickBlooded", 2)
	local traitThinBlooded = MarLibrary.Traits.addTrait("Mar_ThinBlooded", -3)
	-- TURN TRAITS --
	local traitLithe = MarLibrary.Traits.addTrait("Mar_Lithe", 6)
	local traitLumbering = MarLibrary.Traits.addTrait("Mar_Lumbering", -6)
	-- DRIVING TRAITS --
	local traitKeenDriver = MarLibrary.Traits.addTrait("Mar_KeenDriver", 5)
	local traitPoorDriver = MarLibrary.Traits.addTrait("Mar_PoorDriver", -5)
	-- CARRY WEIGHT TRAITS
	local traitStrongBack = MarLibrary.Traits.addTrait("Mar_StrongBack", 5)
	local traitWeakBack = MarLibrary.Traits.addTrait("Mar_WeakBack", -5)
	-- COPY TRAITS --
	local traitDesentiziedCopy = MarLibrary.Traits.addTraitCopy("Desensitized", 12)
	-- MISC TRAITS

	local traitNoEmotion = MarLibrary.Traits.addTrait("Mar_NoEmotion", 16)
	local traitDepressive = MarLibrary.Traits.addTrait("Mar_Depressive", -2)
	--local traitAlcoholic = MarLibrary.Traits.addTrait("Mar_Alcoholic", -2)
	local traitInattentive = MarLibrary.Traits.addTrait("Mar_Inattentive", -8)

	local workerTimedActionNoSpeedList = {
		"ISWalkToTimedAction",
		"ISPathFindAction",
		"ISReadABook",
		-- Really they eat faster, yea no?
		"ISTakeWaterAction",
		"ISEatFoodAction",
	}

	local traitFastWorker = MarLibrary.Traits.addTrait("Mar_FastWorker", 6)
	MarLibrary.Traits.addTraitBaseTimedActionSpeedModifierWithExclusionsList("Mar_FastWorker", 0.4, workerTimedActionNoSpeedList)
	local traitSlowDriver = MarLibrary.Traits.addTrait("Mar_SlowWorker", -6)
	MarLibrary.Traits.addTraitBaseTimedActionSpeedModifierWithExclusionsList("Mar_SlowWorker", -0.4, workerTimedActionNoSpeedList)

	--===================--
	-- MUTUAL EXCLUSIVES --
	--===================--
	TraitFactory.setMutualExclusive("Mar_ThickBlooded", "Mar_ThinBlooded")
	TraitFactory.setMutualExclusive("Mar_StrongBack", "Mar_WeakBack")
	TraitFactory.setMutualExclusive("Mar_Lithe", "Mar_Lumbering")
	TraitFactory.setMutualExclusive("Mar_WarMonger", "Pacifist")
	TraitFactory.setMutualExclusive("Mar_MinorLimp", "Mar_MajorLimp")
	if TraitFactory.getTrait("Mar_BrokeLeg") then
		TraitFactory.setMutualExclusive("Mar_BrokeLeg", "Mar_MinorLimp")
		TraitFactory.setMutualExclusive("Mar_BrokeLeg", "Mar_MajorLimp")
	end
	TraitFactory.setMutualExclusive("Mar_KeenDriver", "Mar_PoorDriver")
	TraitFactory.setMutualExclusive("Mar_FastWorker", "Mar_SlowWorker")
	TraitFactory.setMutualExclusive("Mar_Fearful", "Brave")
	TraitFactory.setMutualExclusive("Mar_Fearful", "Desensitized")
	TraitFactory.setMutualExclusive("Mar_NoEmotion", "Desensitized")
	TraitFactory.setMutualExclusive("Mar_NoEmotion", "Brave")
	TraitFactory.setMutualExclusive("Mar_NoEmotion", "Cowardly")
	TraitFactory.setMutualExclusive("Mar_NoEmotion", "Hemophobic")
	TraitFactory.setMutualExclusive("Mar_NoEmotion", "Mar_Acrophobic")
	TraitFactory.setMutualExclusive("Mar_NoEmotion", "Mar_Nyctophobic")
	TraitFactory.setMutualExclusive("Mar_NoEmotion", "Mar_Fearful")
	TraitFactory.setMutualExclusive("Mar_NoEmotion", "Mar_Depressive")

	TraitFactory.sortList()
end

Events.OnGameBoot.Add(addMarTraitsTraits)