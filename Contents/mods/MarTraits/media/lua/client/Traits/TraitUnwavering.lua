MarTraits = MarTraits or {}

MarTraits.unwaveringUpdate = function(player)
	if not player:HasTrait("unwavering") then return end

	-- TODO: Add the thing that makes your attack speed not that bad when injured
	--[[
	weapon = player:getUseHandWeapon()
	if weapon ~= nil then
		--print(weapon:getSpeedMod(player))
	end
	]]--

	-- TODO: Maybe get unwavering to work based off of fracture time, depends if this works with fracture?
	playerdata = player:getModData()
	if playerdata.UnwaveringInjurySpeedChanged == false and player:HasTrait("unwavering") then
		playerdata.UnwaveringInjurySpeedChanged = true
		for n = 0, player:getBodyDamage():getBodyParts():size() - 1 do
			local i = player:getBodyDamage():getBodyParts():get(n);
			i:setScratchSpeedModifier(i:getScratchSpeedModifier() + 30);
			i:setCutSpeedModifier(i:getCutSpeedModifier() + 30);
			i:setDeepWoundSpeedModifier(i:getDeepWoundSpeedModifier() + 60);
			i:setBurnSpeedModifier(i:getBurnSpeedModifier() + 60);
		end
	end
end

MarTraits.unwaveringOnPlayerHit = function(player, _, __)
	if not player:HasTrait("Unwavering") then return end

	if player:getCurrentState() == PlayerHitReactionState.instance() then
		MarTraits.unwaveringDefendHit(player)
	end
end

MarTraits.unwaveringDefendHit = function(player)
	if player:getHitReaction() == "Bite" then
		player:setHitReaction("BiteFast")
		print("Unwavering Bite Animation Used")
	end
	if player:getHitReaction() == "BiteDefended" then
		player:setHitReaction("BiteDefendedFast")
		print("Unwavering BiteDefended Animation Used")
	end
end

Events.OnPlayerUpdate.Add(MarTraits.unwaveringUpdate)
Events.OnPlayerGetDamage.Add(MarTraits.unwaveringOnPlayerHit) -- TODO: PlayerGetDamage runs when damage is dealt, not attacks, it works because the player usually bleeds on a hit.