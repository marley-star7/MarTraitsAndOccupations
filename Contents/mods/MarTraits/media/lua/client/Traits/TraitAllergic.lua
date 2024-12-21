MarTraits = MarTraits or {}

local float sneezeChanceSeasonModifier = 0
MarTraits.allergicSeasonUpdate = function()
	climate = getWorld():getClimateManager()
	season = climate:getSeasonName()
	-- Like does lua have switch statements or what cuz?????
	if season == "Early Summer" then
		sneezeChanceSeasonModifier = 2
	elseif season == "Summer" then
		sneezeChanceSeasonModifier = 1.5
	elseif season == "Early Autumn" then
		sneezeChanceSeasonModifier = 1
	elseif season == "Autumn" then
		sneezeChanceSeasonModifier = 0.25
	elseif season == "Early Winter" then
		sneezeChanceSeasonModifier = 0
	elseif season == "Winter" then
		sneezeChanceSeasonModifier = 0
	elseif season == "Early Spring" then
		sneezeChanceSeasonModifier = 2.5
	elseif season == "Spring" then
		sneezeChanceSeasonModifier = 3 -- Tree Pollen Baybee May go CRAZY!
	end
end
Events.EveryDays.Add(MarTraits.allergicSeasonUpdate)

-- TODO: Add pollen tracking on clothes when walking through trees
-- TODO: Add moodle for allergy outbreaks
-- TODO: Add wind as a major factor of sneezeChance
-- TODO: Add rain as a thing that washes off clothes pollen and disables sneezing

local int sneezeChanceBuildup = 0
MarTraits.allergicSneezeUpdate = function()
	climate = getWorld():getClimateManager()

	local player = getPlayer()
	if not player:HasTrait("allergic") or player:isAsleep() then
		return
	end
	getGameTime():setDay(150)

	sneezeChance = .2 -- Base sneeze chance
	-- You will become more and more likely to sneeze the more you move through foliage, until you eventually sneeze.
	if player:isInTrees() then
		sneezeChanceBuildup = sneezeChanceBuildup + (20 * sneezeChanceSeasonModifier)
		sneezeChanceBuildup = PZMath.clamp(sneezeChanceBuildup, 0, sneezeChance) -- Make sure you don't get so close to sneezing you start making it impossible to sneeze
	end

	-- That boy can SNEEZE!
	if player:HasTrait("ProneToIllness") then
		sneezeChance = sneezeChance + .25
	end

	sneezeChangeWindModifier = (climate:getWindPower() * 3) -- Wind power is usually pretty low
	sneezeChance = sneezeChance * sneezeChanceSeasonModifier * sneezeChangeWindModifier
	if not player:isOutside() then -- Less likely to sneeze inside.. because yknow no pollen.
		sneezeChance = sneezeChance/3
	end
	sneezeChance = sneezeChance + sneezeChanceBuildup -- We add this seperatly afterwards so that if you just got done walking through a ton of fucking trees you aren't suddenly sneeze immune if indoors.

	if ZombRand(0,100) <= sneezeChance then
		sneezeChanceBuildup = 0
		local itemPrimaryHand = player:getPrimaryHandItem()
		local itemSecondaryHand = player:getSecondaryHandItem()
		-- "Sneezing Tissue" by Hea
		if player:hasEquipped("Base.ToiletPaper") or player:hasEquipped("Base.Tissue") then
			if ZombRand(2) == 0 then
				if itemPrimaryHand and itemPrimaryHand:getType() == "ToiletPaper" then
					itemPrimaryHand:Use()
				elseif itemSecondaryHand and itemSecondaryHand:getType() == "ToiletPaper" then
					itemSecondaryHand:Use()
				elseif itemPrimaryHand and itemPrimaryHand:getType() == "Tissue" then
					itemPrimaryHand:Use()
				elseif itemSecondaryHand and itemSecondaryHand:getType() == "Tissue" then
					itemSecondaryHand:Use()
				end
			end
			player:Say(getText("IGUI_PlayerText_SneezeMuffled"))
			addSound(player, player:getX(), player:getY(), player:getZ(), 6, 10); -- range, then volume
			player:playEmote("MarTraitsSneeze");
		else -- "Sneezing No Tissue" by Hea
			player:Say(getText("IGUI_PlayerText_Sneeze"))
			addSound(player, player:getX(), player:getY(), player:getZ(), 50, 70); -- range, then volume
			player:playEmote("MarTraitsSneeze")
		end
	end
end

Events.EveryOneMinute.Add(MarTraits.allergicSneezeUpdate)