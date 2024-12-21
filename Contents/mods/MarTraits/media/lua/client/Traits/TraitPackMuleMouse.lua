-- TODO: Find new names and icons for these.. Icons maybe like a tiny pouch and then an overloaded bag
-- TODO: Tweak these values a bit, especially the strength multiplier
MarTraits = MarTraits or {}

MarTraits.carryWeightUpdate = function()
	player = getPlayer()
	playerData = player:getModData()
	local strength = player:getPerkLevel(Perks.Strength)
	local carryWeightAddition = 0
	local carryWeightStrengthMod = 0
	if player:HasTrait("packmule") then
		carryWeightAddition = SandboxVars.MarTraits.PackMuleCarryWeightBonus
		carryWeightStrengthMod = strength * .17
	elseif player:HasTrait("packmouse") then
		carryWeightAddition = SandboxVars.MarTraits.PackMouseCarryWeightPenalty
		carryWeightStrengthMod = (10 - strength) * -.17 -- You are already losing ALOT of carry weight
	end

	local finalCarryWeightMod = math.floor(carryWeightAddition + carryWeightStrengthMod)
	if playerData.marTraitsCarryWeight == nil then
		playerData.marTraitsCarryWeight = finalCarryWeightMod
	end
	-- Remove old then add new
	player:setMaxWeightBase( math.floor(player:getMaxWeightBase() - playerData.marTraitsCarryWeight))
	playerData.marTraitsCarryWeight = finalCarryWeightMod
	player:setMaxWeightBase( math.floor(player:getMaxWeightBase() + playerData.marTraitsCarryWeight))
end

Events.OnNewGame.Add(MarTraits.carryWeightUpdate)
Events.LevelPerk.Add(MarTraits.carryWeightUpdate)