--require("ProfessionFramework")
require("MarLibraryTimedActionSpeedModifier.lua")
require("TimedActionSpeedModifier")

MarOccupations = MarOccupations or {}

local function addProfession(name, cost)
	local prof = ProfessionFactory.addProfession(name, getText("UI_prof_" .. name), getText("icon_prof_" .. name), cost)
	return prof
end

local function addMarProfessionTraits()
	-- Copy Traits
	local traitBatteringRam2 = MarLibrary.addProfessionTraitCopy("BatteringRam2")
	TraitFactory.setMutualExclusive("BatteringRam2", "BatteringRam")

	local traitDexterous2 = TraitFactory.addTrait("Dextrous2", getText("UI_trait_Dexterous"), 0, getText("UI_trait_DexterousDesc"), true)
	TraitFactory.setMutualExclusive("Dextrous2", "Dextrous")
	TraitFactory.setMutualExclusive("Dextrous2", "AllThumbs")

	local traitGraceful2 = TraitFactory.addTrait("Graceful2", getText("UI_trait_graceful"), 0, getText("UI_trait_gracefuldesc"), true)
	TraitFactory.setMutualExclusive("Graceful2", "Graceful")
	TraitFactory.setMutualExclusive("Graceful2", "Clumsy")

	local traitSpeedDemon2 = TraitFactory.addTrait("SpeedDemon2", getText("UI_trait_speeddemon"), 0, getText("UI_trait_speeddemondesc"), true)
	TraitFactory.setMutualExclusive("SpeedDemon2", "SpeedDemon")
	TraitFactory.setMutualExclusive("SpeedDemon2", "SundayDriver")

	local traitTailor2 = TraitFactory.addTrait("Tailor2", getText("UI_trait_Tailor"), 0, getText("UI_trait_TailorDesc"), true)
	TraitFactory.setMutualExclusive("Tailor2", "Tailor")
	-- Occupation Specific Traits
	local traitDemoman = MarLibrary.addProfessionTrait("Demoman")
	MarLibrary.TraitSpecificTimedActionSpeedListAdd(
		"Demoman", 
		{	
		{"ISDestroyStuffAction", 2},
	    {"ISMoveablesAction", 1}, 
		})
	local traitRushHour = MarLibrary.addProfessionTrait("RushHour")
	MarLibrary.TraitSpecificTimedActionSpeedListAdd(
		"RushHour", 
		{
			{"ISOpenVehicleDoor", 2},
			{"ISCloseVehicleDoor", 20},
			{"ISEnterVehicle", 2},
			{"ISExitVehicle", 2},
		})
	local traitButcher = MarLibrary.addProfessionTrait("Butcher")
	local traitCorpseFamiliar = MarLibrary.addProfessionTrait("CorpseFamiliar")
	local traitCleaner = MarLibrary.addProfessionTrait("Cleaner")
	MarLibrary.TraitSpecificTimedActionSpeedListAdd(
		"Cleaner", 
		{	
			{"ISCleanBlood", 1.75},
			{"ISWashClothing", 1.75},
			{"ISInventoryTransferAction", 2,
			 	function(player)
					if player:isNearVehicle() then
						return 200
					else
						return
					end
				end
			},
		}
	)
	TraitFactory.setMutualExclusive("CorpseFamiliar", "Hemophobic")
	-- Disabled Trait
	--local traitDefenseTactics = MarLibrary.addProfessionTrait("DefenseTactics")
end

local function addMarProfessions()
	local profDemolitionWorker = addProfession("demolitionworker", 0)
	profDemolitionWorker:addXPBoost(Perks.Woodwork, 1)
	profDemolitionWorker:addXPBoost(Perks.Blunt, 2)
	profDemolitionWorker:addFreeTrait("Demoman")
--[[
	local profMiner = addProfession("miner", 0)
	profMiner:addXPBoost(Perks.Axe, 2)
	profMiner:addXPBoost(Perks.Strength, 1)
]]--
	local profFederalOfficer = addProfession("federalofficer", -14)
	profFederalOfficer:addXPBoost(Perks.Aiming, 3)
	profFederalOfficer:addXPBoost(Perks.Fitness, 1)
	profFederalOfficer:addXPBoost(Perks.Nimble, 1)
	profFederalOfficer:addXPBoost(Perks.Reloading, 2)
	profFederalOfficer:addFreeTrait("Desensitized")

	local profTailor = addProfession("tailor", 2)
	profTailor:addXPBoost(Perks.Tailoring, 3)
	profTailor:addFreeTrait("Tailor2")

	if isDebugEnabled() then
		local profAthlete = addProfession("athlete", -14)
		profAthlete:addXPBoost(Perks.Fitness, 3)
		profAthlete:addXPBoost(Perks.Nimble, 1)
		profAthlete:addXPBoost(Perks.Sprinting, 2)
		profAthlete:addXPBoost(Perks.Strength, 1)
	end

	local profWaiter = addProfession("waiter", 2)
	profWaiter:addXPBoost(Perks.Nimble, 2)
	profWaiter:addFreeTrait("Graceful2")
	profWaiter:addFreeTrait("Dextrous2")

	if isDebugEnabled() then
		local profDeliveryDriver = addProfession("deliverydriver", 7)
		profDeliveryDriver:addFreeTrait("SpeedDemon2")
		profDeliveryDriver:addFreeTrait("RushHour")
	end

	local profButcher = addProfession("butcher", -4)
	profButcher:addXPBoost(Perks.SmallBlade, 2)
	profButcher:addXPBoost(Perks.SmallBlunt, 1)
	profButcher:addXPBoost(Perks.Cooking, 1)
	profButcher:addFreeTrait("CorpseFamiliar")
	profButcher:addFreeTrait("Butcher")

	local profMortician = addProfession("mortician", 0)
	profMortician:addXPBoost(Perks.Doctor, 1)
	profMortician:addXPBoost(Perks.SmallBlade, 2)
	profMortician:addFreeTrait("CorpseFamiliar")

	local profJanitor = addProfession("janitor", 2)
	profJanitor:addXPBoost(Perks.Maintenance, 2)
	profJanitor:addXPBoost(Perks.Blunt, 1)
	profJanitor:addFreeTrait("Cleaner")
	--profFederalOfficer:addFreeTrait("DefenseTactics")

	--[[
	local profMiner = addProfession("Miner", 2)
	profMiner:addXPBoost(Perks.Axe, 2)
	profMiner:addXPBoost(Perks.Foraging, 1)
	]]--

	-- The SECRET Profession
	if isDebugEnabled() then
		local profFootballPlayer = addProfession("footballPlayer", -10)
		profFootballPlayer:addXPBoost(Perks.Strength, 2)
		profFootballPlayer:addXPBoost(Perks.Sprinting, 2)
		profFootballPlayer:addXPBoost(Perks.Fitness, 2)
		profFootballPlayer:addFreeTrait("BatteringRam2")
	end

	-- Occupation Descriptions
	-- Seriously why is this how we do this??? you are forced to use the exact "UI_profdesc_Occupation" typing way with this.
	local profList = ProfessionFactory.getProfessions()
	for i = 1, profList:size() do
		local prof = profList:get(i - 1)
		BaseGameCharacterDetails.SetProfessionDescription(prof)
	end
end

function MarOccupations.doNewCharacterTraitSwaps(playernum, player)
	local player = getSpecificPlayer(playernum)
	-- Swap them traits

	if player:HasTrait("BatteringRam2") then
		player:getTraits():remove("BatteringRam2")
		player:getTraits():add("BatteringRam")
	end

	if player:HasTrait("Dextrous2") then
		player:getTraits():remove("Dextrous2")
		player:getTraits():add("Dextrous")
	end

	if player:HasTrait("Graceful2") then
		player:getTraits():remove("Graceful2")
		player:getTraits():add("Graceful")
	end

	if player:HasTrait("SpeedDemon2") then
		player:getTraits():remove("SpeedDemon2")
		player:getTraits():add("SpeedDemon")
	end

	if player:HasTrait("Tailor2") then
		player:getTraits():remove("Tailor2")
		player:getTraits():add("Tailor")
	end
end

Events.OnCreatePlayer.Add(MarOccupations.doNewCharacterTraitSwaps)

Events.OnGameBoot.Add(addMarProfessionTraits)
Events.OnGameBoot.Add(addMarProfessions)
Events.OnCreateLivingCharacter.Add(addMarProfessions);