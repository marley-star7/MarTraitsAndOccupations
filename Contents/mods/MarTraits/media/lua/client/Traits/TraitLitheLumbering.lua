MarTraits = MarTraits or {}

-- TODO: Nothing! this seems to work just fine :]
-- TODO: On the other hand FIGURE OUT HOW TO USE FUNCTIONS BETWEEN SCRIPTS SINCE WE COPY THIS DELAY FUNCTION FUNCTION TWICE NOW!!!

MarTraits.turnSpeedsInitialize = function(player)
	player = getPlayer()
	if player:HasTrait("Lithe") then
		MarTraits.setTurnDeltaLithe(player)
	elseif player:HasTrait("Lumbering") then
		MarTraits.setTurnDeltaLumbering(player)
	end
end
Events.OnCreatePlayer.Add(MarTraits.turnSpeedsInitialize)

MarTraits.setTurnDeltaLithe = function(player)
	player:setTurnDelta(SandboxVars.MarTraits.LitheTurnSpeed/100)
end

MarTraits.setTurnDeltaLumbering = function(player)
	player:setTurnDelta(SandboxVars.MarTraits.LumberingTurnSpeed/100)
end

MarTraits.setTurnDeltaDefault = function(player)
	player:setTurnDelta(1)
end

MarTraits.traitTurnSpeedsOnLevelPerk = function(player, perk, perkLevel)
	if perk ~= Perks.Nimble then return end

	if player:HasTrait("Lumbering") then
		if perkLevel >= 3 then
			player:getTraits():remove("Lumbering")
			MarTraits.setTurnDeltaDefault(player)
			print("Lumbering Trait Removed")
		end
	end

	if not player:HasTrait("Lithe") then
		if perkLevel >= 7 then
			player:getTraits():add("Lithe")
			MarTraits.setTurnDeltaLithe(player)
			print("Lithe Added")
		end
	end
end
Events.LevelPerk.Add(MarTraits.traitTurnSpeedsOnLevelPerk)

MarTraits.lumberingAddNimbleXp = function(player, perk, amount)
	if not player:HasTrait("Lumbering") then return end

	local lumberingModifier = -0.5;
	if perk == Perks.Nimble
	then
		amount = amount * lumberingModifier
		player:getXp():AddXP(perk, amount, false, false, false)
	end
end
Events.AddXP.Add(MarTraits.lumberingAddNimbleXp)