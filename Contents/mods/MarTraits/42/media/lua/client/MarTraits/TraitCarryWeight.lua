local carryWeightUpdate = function()
	local player = getPlayer()
	local playerModData = player:getModData()

	local strength = player:getPerkLevel(Perks.Strength)
	local carryWeightAddition = 0
	-- The strength mod and strength added is broke, but tbh traits work like this fine lol, so I'm keeping it this way.
	local carryWeightStrengthMod = 0
	if player:HasTrait("Mar_StrongBack") then
		carryWeightAddition = SandboxVars.MarTraits.StrongBackCarryWeightBonus
		--carryWeightStrengthMod = (strength - 5) * 0.2
	elseif player:HasTrait("Mar_WeakBack") then
		carryWeightAddition = SandboxVars.MarTraits.WeakBackCarryWeightPenalty
		--carryWeightStrengthMod = (5 - strength) * -0.2 -- You are already losing ALOT of carry weight
	end

	-- Carry weight is saved and set as whole number always.
	local noTraitModifiedCarryWeight = player:getMaxWeightBase() - (playerModData.fMarTraitsCarryWeightModifier or 0)
	local finalCarryWeightMod = math.floor(carryWeightAddition + carryWeightStrengthMod)
	-- Remove old then add new
	player:setMaxWeightBase(noTraitModifiedCarryWeight + finalCarryWeightMod)
	playerModData.fMarTraitsCarryWeightModifier = finalCarryWeightMod
end

Events.OnNewGame.Add(carryWeightUpdate)
Events.EveryOneMinute.Add(carryWeightUpdate)