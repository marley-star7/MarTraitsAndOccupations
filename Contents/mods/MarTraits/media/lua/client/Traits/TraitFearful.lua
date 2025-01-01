-- TODO: On player update MIGHT run more times with multiple players in a lobby? so redo how this calculates.
-- TODO: CLEAN THIS UPPPP

require("MarLibrary")

local int minKillsTillRemoved = 100
local int maxKillsTillRemoved = 200
local int noiseChance = 0

local int secondsTillUpdate = 0
local boolean isScreaming = false

local function fearfulUpdate(player)
	if not player:HasTrait("fearful") then return end

	if secondsTillUpdate >= 1 then
		secondsTillUpdate = 0
		-- Very sloppy method of implementation to make scream on jumpscare but this does work, and with any scary situation!
		if player:getEmitter():isPlaying("ZombieSurprisedPlayer") then
			if isScreaming == false then
			sayScreamLine(player)
			end
			isScreaming = true
			return
		else
			isScreaming = false -- To make sure you don't spam screams.
		end

		if player:getCurrentState() == PlayerHitReactionState.instance() then
			sayExtremePanicLine(player)
			noiseChance = 0
			return
		end
	else
		secondsTillUpdate = secondsTillUpdate + getGameTime():getTimeDelta()
		return
	end

	local stats = player:getStats()
	local panic = stats:getPanic()
	-- To make sure the player doesn't spit out text too quickly because the dice just rolled that way.
	if panic < 5 then return end
	-- Panic is 0 to 100
	noiseChance = noiseChance + baseNoiseChance * (1 +(panic / 100))
	noiseChance = noiseChance + baseNoiseChance * stats:getNumVisibleZombies()
	--print(noiseChance)

	if ZombRand(0, 100) <= noiseChance then
		-- Reset the noiseChance buildup
		noiseChance = 0
		-- We say a scream line
		if player:isSneaking() then
			if panic <= 50 then
				saySlightPanicSneakingLine(player)
			elseif panic <= 90 then
				sayPanicSneakingLine(player)
			elseif panic > 90 then
				sayStrongPanicSneakingLine(player)
			end
			return
		end
		if panic <= 25 then
			saySlightPanicLine(player)
		elseif panic <= 50 then
			sayPanicLine(player)
		elseif panic <= 75 then
			sayStrongPanicLine(player)
		elseif panic > 75 then
			sayExtremePanicLine(player)
		end
	end
end

local function loseTraitFearful()
	getPlayer():getTraits():remove("Fearful")
end

local int baseNoiseChance = 0
local function traitFearfulNoiseChanceUpdate(character)
	if character:getAttackedBy() == getPlayer() then
		local zombieKills = player:getZombieKills();
		-- Don't ask this calculation
		killsTillTraitRemoved = maxKillsTillRemoved-zombieKills
		baseNoiseChanceModifer = 1
		if player:HasTrait("Cowardly") then
			baseNoiseChanceModifer = baseNoiseChanceModifer + .2
		end
		if player:HasTrait("Lucky") then
			baseNoiseChanceModifer = baseNoiseChanceModifer - .02
		elseif player:HasTrait("Unlucky") then
			baseNoiseChance = baseNoiseChance + .02
		end
		baseNoiseChance = (killsTillTraitRemoved/maxKillsTillRemoved) * baseNoiseChanceModifer -- The divison is just so we still have some randomness in wether a scream will happen.
		-- if over maximum fearful then remove
		if zombieKills >= maxKillsTillRemoved then
			loseTraitFearful()
			return
			--elseif killed more than minimum, roll a check to remove
		elseif zombieKills > minKillsTillRemoved then
			-- Chance of removal grows from 0 to 100 once hit minimum
			local probability = (zombieKills - minKillsTillRemoved) / maxKillsTillRemoved
			local probabilityDenominator = 100 * probability

			if ZombRand(1, 100) < probabilityDenominator then
				loseTraitFearful()
				return
			end
		end
	end
end

Events.OnPlayerUpdate.Add(fearfulUpdate)
Events.OnCreatePlayer.Add(traitFearfulNoiseChanceUpdate)
Events.OnCharacterDeath.Add(traitFearfulNoiseChanceUpdate)

function saySlightPanicLine(player)
	panicTextNum = getRandPanicLineOf(13)
	MarLibrary.playerSayServer(player, getText("UI_fearful_slightpanic" .. panicTextNum))
	addSound(player, player:getX(), player:getY(), player:getZ(), 4, 8)
end

function saySlightPanicSneakingLine(player)
	panicTextNum = getRandPanicLineOf(19)
	MarLibrary.playerSayServer(player, getText("UI_fearful_slightpanicsneaking" .. panicTextNum))
	addSound(player, player:getX(), player:getY(), player:getZ(), 4, 8)
end

function sayPanicLine(player)
	panicTextNum = getRandPanicLineOf(5)
	MarLibrary.playerSayServer(player, getText("UI_fearful_panic" .. panicTextNum))
	addSound(player, player:getX(), player:getY(), player:getZ(), 8, 16)
end

function sayPanicSneakingLine(player)
	panicTextNum = getRandPanicLineOf(5)
	MarLibrary.playerSayServer(player, getText("UI_fearful_panicsneaking" .. panicTextNum))
	addSound(player, player:getX(), player:getY(), player:getZ(), 8, 16)
end

function sayStrongPanicLine(player)
	panicTextNum = getRandPanicLineOf(7)
	MarLibrary.playerSayServer(player, getText("UI_fearful_strongpanic" .. panicTextNum))
	addSound(player, player:getX(), player:getY(), player:getZ(), 20, 25)
end

function sayStrongPanicSneakingLine(player)
	panicTextNum = getRandPanicLineOf(7)
	MarLibrary.playerSayServer(player, getText("UI_fearful_strongpanicsneaking" .. panicTextNum))
	addSound(player, player:getX(), player:getY(), player:getZ(), 20, 25)
end

function sayExtremePanicLine(player)
	panicTextNum = getRandPanicLineOf(16)
	MarLibrary.playerSayServer(player, getText("UI_fearful_extremepanic" .. panicTextNum))
	addSound(player, player:getX(), player:getY(), player:getZ(), 40, 50)
end

function sayScreamLine(player)
	panicTextNum = getRandPanicLineOf(6)
	MarLibrary.playerSayServer(player, getText("UI_fearful_scream" .. panicTextNum))
	addSound(player, player:getX(), player:getY(), player:getZ(), 40, 50)
end

-- This is here because I am lazy
local panicTextNumLast = 0
function getRandPanicLineOf(max)
	repeat
		panicTextNum = ZombRand(1,max)
	until panicTextNumLast ~= panicTextNum
	panicTextNumLast = panicTextNum -- Trying keeping it off for now
	return panicTextNum
end