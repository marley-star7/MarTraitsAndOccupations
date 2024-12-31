MarTraits = MarTraits or {}

MarTraits.setTurnDeltaDefault = function(player)
	local playerModData = player:getModData()
	local playerTurnDeltaPreAdjust = player:getTurnDelta()
	local currentTraitAddedPlayerTurnDelta = playerModData.fMarTraitsTurnDeltaAdjustment or 0
	local newPlayerTurnDelta = playerTurnDeltaPreAdjust - currentTraitAddedPlayerTurnDelta

	player:setTurnDelta(newPlayerTurnDelta)
	playerModData.fMarTraitsTurnDeltaAdjustment = 0
end

-- Functions are done this way to try and make sure it updates properly with mods that change turn delta.
MarTraits.setTurnDeltaLithe = function(player)
	-- reset turn delta before modificiations.
	MarTraits.setTurnDeltaDefault(player)
    local turnDeltaModifier = 1 + SandboxVars.MarTraits.LitheTurnSpeedPercentIncrease/100
    local playerTurnDeltaPreAdjust = player:getTurnDelta()
    local newPlayerTurnDelta = playerTurnDeltaPreAdjust * turnDeltaModifier

    player:setTurnDelta(newPlayerTurnDelta)
    print("Lithe player turn delta = " .. player:getTurnDelta())
    player:getModData().fMarTraitsTurnDeltaAdjustment = newPlayerTurnDelta - playerTurnDeltaPreAdjust
end

MarTraits.setTurnDeltaLumbering = function(player)
	-- reset turn delta before modificiations.
	MarTraits.setTurnDeltaDefault(player)
	local turnDeltaModifier = 1 - SandboxVars.MarTraits.LumberingTurnSpeedPercentDecrease/100
	local playerTurnDeltaPreAdjust = player:getTurnDelta()
	local newPlayerTurnDelta = playerTurnDeltaPreAdjust * turnDeltaModifier

	player:setTurnDelta(newPlayerTurnDelta)
	--print("Lumbering player turn delta = " .. newPlayerTurnDelta)
	player:getModData().fMarTraitsTurnDeltaAdjustment = newPlayerTurnDelta - playerTurnDeltaPreAdjust
end

--=============--
-- LOCAL STUFF --
--=============--

local function turnSpeedTraitsInitialize(player)
	if player:HasTrait("Mar_Lithe") then
		MarTraits.setTurnDeltaLithe(player)
	elseif player:HasTrait("Mar_Lumbering") then
		MarTraits.setTurnDeltaLumbering(player)
	end
end

Events.OnCreatePlayer.Add(
	function(playerNum, player) turnSpeedTraitsInitialize(player) end
)

local function turnSpeedTraitsOnLevelPerk(player, perk, perkLevel)
	if perk ~= Perks.Nimble then return end

	if not (player:HasTrait("Mar_Lithe")) and not (player:HasTrait("Mar_Lumbering")) then
		MarTraits.setTurnDeltaDefault(player)
	end

	if SandboxVars.MarTraits.LitheLumberingAreDynamic then
		if perkLevel >= SandboxVars.MarTraits.LumberingLoseLevel then
			if player:HasTrait("Mar_Lumbering") then
				player:getTraits():remove("Mar_Lumbering")
				print("Lumbering Trait Removed")
			end
		end

		if perkLevel >= SandboxVars.MarTraits.LitheGainLevel then
			if not (player:HasTrait("Mar_Lithe")) then
				player:getTraits():add("Mar_Lithe")
				print("Lithe Added")
			end
		end
	end

	-- We do this here because some mods specifically change turn rate on leveling.
	turnSpeedTraitsInitialize(player)
end

Events.LevelPerk.Add(turnSpeedTraitsOnLevelPerk)

local function turnSpeedTraitsOnAddXP(player, perk, amount)
	if perk ~= Perks.Nimble then return end

	if player:HasTrait("Mar_Lithe") then
		local litheXPModifier = SandboxVars.MarTraits.LitheXPModifier/100
		local litheAddedXP = amount * litheXPModifier
		local playerXP = player:getXp()
		playerXP:AddXP(perk, litheAddedXP, false, false, false)
		--print("Lithe XP added = " .. litheAddedXP)
	end

	if player:HasTrait("Mar_Lumbering") then
		local lumberingXPModifier = SandboxVars.MarTraits.LumberingXPModifier/100
		local lumberingRemovedXP = amount * lumberingXPModifier
		local playerXP = player:getXp()
		playerXP:setTotalXP(playerXP:getTotalXp() - lumberingRemovedXP)
		--print("Lumbering XP removed = " .. lumberingRemovedXP)
	end
end

Events.AddXP.Add(turnSpeedTraitsOnAddXP)