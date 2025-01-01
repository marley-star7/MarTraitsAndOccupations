require("MarLibrary.Traits")

MarOccupations = MarOccupations or {}

local function addMarOccupationsTraits()
	-- Occupation Specific Traits
	local traitCorpseFamiliar = MarLibrary.Traits.addTrait("Mar_CorpseFamiliar")
	local traitDefenseTactics = MarLibrary.Traits.addTrait("Mar_DefenseTactics")

	local traitDemoman = MarLibrary.Traits.addTrait("Mar_Demoman")
	MarLibrary.Traits.addTraitTimedActionSpeedModifierList(
		"Mar_Demoman", 
		{	
			{"ISDestroyStuffAction", 2},
			{"ISMoveablesAction", 1},
		}
	)
	local traitPickaxeMan = MarLibrary.Traits.addTrait("Mar_PickaxeMan")
	MarLibrary.Traits.addTraitTimedActionSpeedModifierList(
		"Mar_PickaxeMan", 
		{	
			{"ISPickAxeGroundCoverItem", 1.5},
		}
	)
	local traitRushHour = MarLibrary.Traits.addTrait("Mar_RushHour")
	MarLibrary.Traits.addTraitTimedActionSpeedModifierList(
		"Mar_RushHour", 
		{
			{"ISOpenVehicleDoor", 2},
			{"ISCloseVehicleDoor", 20},
			{"ISEnterVehicle", 2},
			{"ISExitVehicle", 2},
			{"ISInventoryTransferAction", 2, function(player)
				-- isNearVehicle doesn't work for some reason, so have to use this instead.
				if player:getNearVehicle() ~= nil or player:isSeatedInVehicle() then
					return 2
				else
					return 0
				end
			end
			},
		})
	
	local traitCleaner = MarLibrary.Traits.addTrait("Mar_Cleaner")
	MarLibrary.Traits.addTraitTimedActionSpeedModifierList(
		"Mar_Cleaner", 
		{	
			{"ISCleanBlood", 1.75},
			{"ISWashClothing", 1.75},
		}
	)
	
	--===================--
	-- MUTUAL EXCLUSIVES --
	--===================--
	TraitFactory.setMutualExclusive("Mar_CorpseFamiliar", "Hemophobic")
end

local function addMarOccupationsProfessions()
	local profMason = MarLibrary.Traits.addProfession("mar_mason", -2)
	profMason:addXPBoost(Perks.Masonry, 3)
	profMason:addXPBoost(Perks.SmallBlade, 1)
	
	local profFederalOfficer = MarLibrary.Traits.addProfession("mar_federalofficer", -14)
	profFederalOfficer:addXPBoost(Perks.Aiming, 3)
	profFederalOfficer:addXPBoost(Perks.Reloading, 2)
	profFederalOfficer:addXPBoost(Perks.Fitness, 1)
	profFederalOfficer:addXPBoost(Perks.Nimble, 1)
	profFederalOfficer:addFreeTrait(MarLibrary.Traits.addTraitCopy("Brave", 0, "brave", "bravedesc"))
	--profFederalOfficer:addFreeTrait("Mar_DefenseTactics")
	
	local profPrivateInvestigator = MarLibrary.Traits.addProfession("mar_privateinvestigator", -2)
	profPrivateInvestigator:addXPBoost(Perks.Tracking, 3)
	profPrivateInvestigator:addXPBoost(Perks.Sneak, 2)
	profPrivateInvestigator:addXPBoost(Perks.Lightfoot, 1)
	profPrivateInvestigator:addFreeTrait(MarLibrary.Traits.addTraitCopy("Inconspicuous"))

	local profDemolitionWorker = MarLibrary.Traits.addProfession("mar_demolitionworker", 0)
	profDemolitionWorker:addXPBoost(Perks.Blunt, 2)
	profDemolitionWorker:addXPBoost(Perks.Woodwork, 1)
	profDemolitionWorker:addFreeTrait("Mar_Demoman")

	local profMiner = MarLibrary.Traits.addProfession("mar_miner", 2)
	profMiner:addXPBoost(Perks.Axe, 2)
	profMiner:addXPBoost(Perks.FlintKnapping, 1)
	profMiner:addFreeTrait("Mar_PickaxeMan")

	local profTailor = MarLibrary.Traits.addProfession("mar_tailor", 2)
	profTailor:addXPBoost(Perks.Tailoring, 3)
	profTailor:addFreeTrait(MarLibrary.Traits.addTraitCopy("Tailor"))

	local profAthlete = MarLibrary.Traits.addProfession("mar_athlete", -10)
	profAthlete:addXPBoost(Perks.Fitness, 3)
	profAthlete:addXPBoost(Perks.Nimble, 1)
	profAthlete:addXPBoost(Perks.Sprinting, 1)
	profAthlete:addXPBoost(Perks.Strength, 1)

	local profWaiter = MarLibrary.Traits.addProfession("mar_waiter", 2)
	profWaiter:addXPBoost(Perks.Nimble, 2)
	profWaiter:addXPBoost(Perks.Cooking, 1)
	profWaiter:addFreeTrait(MarLibrary.Traits.addTraitCopy("Dextrous", 0, "Dexterous")) -- Vanilla zomboid has a spelling inconsistency with this trait :|

	local profCleaner = MarLibrary.Traits.addProfession("mar_cleaner", 0)
	profCleaner:addXPBoost(Perks.Maintenance, 2)
	profCleaner:addXPBoost(Perks.Blunt, 1)
	profCleaner:addFreeTrait("Mar_Cleaner")

	local profDeliveryDriver = MarLibrary.Traits.addProfession("mar_deliverydriver", 7)
	profDeliveryDriver:addFreeTrait(MarLibrary.Traits.addTraitCopy("SpeedDemon"))
	profDeliveryDriver:addFreeTrait("Mar_RushHour")

	local profButcher = MarLibrary.Traits.addProfession("mar_butcher", -4)
	profButcher:addXPBoost(Perks.Butchering, 3)
	profButcher:addXPBoost(Perks.SmallBlade, 2)
	profButcher:addXPBoost(Perks.SmallBlunt, 1)
	profButcher:addXPBoost(Perks.Cooking, 1)

	local profMortician = MarLibrary.Traits.addProfession("mar_mortician", 0)
	profMortician:addXPBoost(Perks.Doctor, 1)
	profMortician:addXPBoost(Perks.Butchering, 1)
	profMortician:addXPBoost(Perks.SmallBlade, 2)
	profMortician:addFreeTrait("Mar_CorpseFamiliar")

	-- Occupation Descriptions
	-- Seriously why is this how we do this? 
	-- You are forced to use the exact "UI_profdesc_Occupation" typing way with this.
	local profList = ProfessionFactory.getProfessions()
	for i = 1, profList:size() do
		local prof = profList:get(i - 1)
		BaseGameCharacterDetails.SetProfessionDescription(prof)
	end
end

Events.OnGameBoot.Add(addMarOccupationsTraits)
Events.OnGameBoot.Add(addMarOccupationsProfessions)
Events.OnCreateLivingCharacter.Add(addMarOccupationsProfessions); -- Do this so it appears when respawning as well.