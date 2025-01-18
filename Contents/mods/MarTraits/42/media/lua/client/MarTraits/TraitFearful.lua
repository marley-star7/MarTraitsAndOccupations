require("MarLibrary")

local minKillsTillRemoved = 100
local maxKillsTillRemoved = 200
local noiseChance = 0 -- TODO: make this a mod saved thing.
local baseNoiseChanceSettleSpeed = 2
local sneakingNoiseChanceSettleSpeedModifier = 2
local baseNoiseChanceRiseSpeed = 0.12

local panicNoiseChanceRiseModifier = 1
local visibleZombiesSpikeNoiseChanceModifier = 8
local visibleZombiesNoiseChanceRiseModifier = 0.1
local chasingZombiesNoiseChanceRiseModifier = 5
local veryCloseZombiesNoiseChanceRiseModifier = 20

-- Removed buildup fear noise amount influence for being uninuitive, and too hard to properly balance after adding spike chances in ability without being unimpactful or breaking everything, 
-- Don't add back.
--local buildupFearNoiseAmountInfluence = 3
local sneakingFearNoiseAmountInfluence = -45 -- sneaking helps you calm yourself from making louder noises.
local runningFearNoiseAmountInfluence = 15 -- Running makes you more likely to be making louder noises.
local panicFearNoiseAmountInfluence = 35 -- Means will only get max 35 scream noise without other factors.
local visibleZombiesFearNoiseAmountInfluence = 0.1 -- Very low just for looking at em,
local chasingZombiesFearNoiseAmountInfluence = 0.75
local veryCloseZombiesFearNoiseAmountInfluence = 15

local secondsTillUpdate = 0
local isScreaming = false
local screamCooldown = 0
local previousNumVisibleZombies = 0

local function stopAllFearNoises(player)
	-- Stop da breathing
	player:stopPlayerVoiceSound("ApplyBandage")
	player:stopPlayerVoiceSound("PainFromScratch")
	player:stopPlayerVoiceSound("PainFromLacerate")
	player:stopPlayerVoiceSound("PainFromBite")
	player:stopPlayerVoiceSound("DeathFall")
	player:stopPlayerVoiceSound("DeathEaten")
end

-- "PainFromGlassCut" -- For "ah shits"
local function doSlightFearNoise(player)
	stopAllFearNoises(player)
	player:playerVoiceSound("PainFromScratch")
	screamCooldown = 6
	addSound(player, player:getX(), player:getY(), player:getZ(), 4, 6)
	print("Slight Fear Noise Done")
end

-- "PainFromGlassCut" -- For "ah shits"
local function doFearNoise(player)
	stopAllFearNoises(player)
	player:playerVoiceSound("PainFromLacerate")
	screamCooldown = 6
	addSound(player, player:getX(), player:getY(), player:getZ(), 8, 12)
	print("Fear Noise Done")
end

-- For small scares.
local function doStrongFearNoise(player)
	stopAllFearNoises(player)
	player:playerVoiceSound("PainFromBite")
	screamCooldown = 8
	addSound(player, player:getX(), player:getY(), player:getZ(), 12, 16)
	print("Strong Fear Noise Done")
end

-- "DeathFall" -- For really panic scream moments.
local function doExtremeFearNoise(player)
	-- Stop da breathing
	player:stopPlayerVoiceSound("ApplyBandage")
	-- 2 in 5 chance to use deathEaten occasionally as mixup.
	if ZombRand(1, 5) <= 3 then
		player:playerVoiceSound("DeathEaten")

		-- We cut the sound off early because alot of them have very unfitting goofy ending noises, 
		-- random chance to keep going lol, do it slightly earlier so it masks the sudden stops.
		MarLibrary.delayFuncByDelta(
			function(player)
				player:stopPlayerVoiceSound("DeathEaten")

				local rand = ZombRand(0, 4)
				if rand <= 1 then
					doSlightFearNoise(player)
				elseif rand <= 2 then
					doFearNoise(player)
				elseif rand <= 3 then
					doStrongFearNoise(player)
				else
					player:playerVoiceSound("ApplyBandage")
				end
			end,
			10 + ZombRand(-1, 1),
			player
		)
	else
		player:playerVoiceSound("DeathFall")
	end
	addSound(player, player:getX(), player:getY(), player:getZ(), 40, 50)
	print("Extreme Fear Noise Done")
	screamCooldown = 30
end

local function doFearNoiseByStrength(player, fearNoiseAmount)
	if fearNoiseAmount <= 30 then
		doSlightFearNoise(player)
	elseif fearNoiseAmount <= 60 then
		doFearNoise(player)
	elseif fearNoiseAmount <= 90 then
		doStrongFearNoise(player)
	elseif fearNoiseAmount >= 100 then
		doExtremeFearNoise(player)
	end
end

-- Removed for most sounds of them having a weird "blegghhh" at the end when they "die" lol, kept it in extreme just as a mixup
-- For max panic scream moments, complete freakouts, like being bit.
--[[
local function doSuperExtremeFearNoise(player)
	player:playerVoiceSound("DeathEaten")
	addSound(player, player:getX(), player:getY(), player:getZ(), 40, 50)
	print("Extreme Fear Noise Done")
end
]]--

-- Collected list of possible noises game has...
	-- "PainFromFallLow" -- Kinda good, could work for small scares
	-- "PainFromFallHigh" -- Notably delayed
	-- "DeathAlone" -- Sounds like someone choking on their food...
	-- "DeathFall"
	-- "DeathEaten"
	-- "PainFromGlassCut"
	-- "PainFromScratch" -- All other pain ones besides glass cut seem broken?
	-- "PainFromLacerate"
	-- "PainFromBite"
	-- "PainMoodle"
	-- "ApplyBandage"
	-- "FemaleHeavyBreath"
	-- "FemaleHeavyBreathPanic"

local function fearfulUpdate(player)
	if not player:HasTrait("Mar_Fearful") then return end

	-- For performance reasons, only does this update check every second, possibly remove if screams seem weird.
	if secondsTillUpdate >= 1 then
		secondsTillUpdate = 0
		-- TODO: make this jumpscare thing send between servers, since its checking when YOU are jumpscared.
		-- TODO: maybe look into making it work based off high panic jumps instead?
		-- Very sloppy method of implementation to make scream on jumpscare but this does work, and with any scary situation!
		--player:getEmitter():playSound("ZombieSurprisedPlayer")
		if player:getEmitter():isPlaying("ZombieSurprisedPlayer") then
			if isScreaming == false then
				doStrongFearNoise(player)
				isScreaming = true
				return
			end
		else
			isScreaming = false -- To make sure you don't spam screams.
		end

		if player:getCurrentState() == PlayerHitReactionState.instance() then
			doExtremeFearNoise(player)
			return
		end
	else
		secondsTillUpdate = secondsTillUpdate + getGameTime():getTimeDelta()
		return
	end

	local stats = player:getStats()
	local panic = stats:getPanic()

	local delta = getGameTime():getTimeDelta() -- So it doesn't change with frame rate.
	-- Panic is 0 to 100,
	-- noise chance is always being reduced but is fighting with your current situation to go up, crouching makes it go down way faster.
	local noiseChanceSettle = baseNoiseChanceSettleSpeed
	if player:isSneaking() then
		noiseChanceSettle = noiseChanceSettle * sneakingNoiseChanceSettleSpeedModifier
	elseif panic > 70 then
		-- Closest to constant breathing noise I could get...
		player:playerVoiceSound("ApplyBandage")
		addSound(player, player:getX(), player:getY(), player:getZ(), 6, 10)
	end

	noiseChance = PZMath.clamp(noiseChance - noiseChanceSettle * delta, 0, 999) -- Can't go below zero.

	local panicNoiseChanceInfluence = baseNoiseChanceRiseSpeed * (panic / 100) * panicNoiseChanceRiseModifier * delta

	-- If amount of visible zombies increased from before then add an increase spike to noise chance, so not looking at them helps.
	local visibleZombiesSpikeNoiseChanceInfluence = 0
	local currentNumVisibleZombies = stats:getNumVisibleZombies()
	if previousNumVisibleZombies < currentNumVisibleZombies then
		visibleZombiesSpikeNoiseChanceInfluence = currentNumVisibleZombies * visibleZombiesSpikeNoiseChanceModifier
	end

	-- Also steady increase longer you look.
	local visibleZombiesNoiseChanceInfluence = baseNoiseChanceRiseSpeed * currentNumVisibleZombies * visibleZombiesNoiseChanceRiseModifier * delta
	local chasingZombiesNoiseChanceInfluence = baseNoiseChanceRiseSpeed * stats:getNumChasingZombies() * chasingZombiesNoiseChanceRiseModifier * delta
	local veryCloseZombiesNoiseChanceInfluence = baseNoiseChanceRiseSpeed * stats:getNumVeryCloseZombies() * veryCloseZombiesNoiseChanceRiseModifier * delta
	-- Chance to scream is ever increasing.
	-- Chance to scream increase lessens over time with how many zombies you kill.
	local fearfulTimeRemovalMod = 1 - (player:getZombieKills()/SandboxVars.MarTraits.FearfulMaximumKillsTillLose)
	local noiseChanceToAdd = panicNoiseChanceInfluence + visibleZombiesSpikeNoiseChanceInfluence + visibleZombiesNoiseChanceInfluence + chasingZombiesNoiseChanceInfluence + veryCloseZombiesNoiseChanceInfluence
	noiseChanceToAdd = noiseChanceToAdd * fearfulTimeRemovalMod
	noiseChance = noiseChance + noiseChanceToAdd
	
	-- Save previous num visible zombies.
	previousNumVisibleZombies = currentNumVisibleZombies

	screamCooldown = PZMath.clamp(screamCooldown - 1 * delta, 0, 99)
	local rand = ZombRandFloat(0, 1)  -- Random value between 0 and 100
	if rand <= noiseChance and screamCooldown <= 0 then

		-- Running makes you more volatile, sneaking makes you calmer.
		local runningFearNoiseAmount = 0
		local sneakingFearNoiseAmount = 0
		if player:isSneaking() then 
			sneakingFearNoiseAmount = sneakingFearNoiseAmountInfluence
		elseif player:isRunning() then
			runningFearNoiseAmount = runningFearNoiseAmountInfluence 
		end
		-- Current zombie situation has factor.
		local panicFearNoiseAmount = panic/100 * panicFearNoiseAmountInfluence
		local visibleZombiesFearNoiseAmount = stats:getNumVisibleZombies() * visibleZombiesFearNoiseAmountInfluence
		local chasingZombiesFearNoiseAmount = (stats:getNumChasingZombies() * chasingZombiesFearNoiseAmountInfluence) or 0
		local veryCloseZombiesFearNoiseAmount = stats:getNumVeryCloseZombies() * veryCloseZombiesFearNoiseAmountInfluence

		local fearNoiseAmount = runningFearNoiseAmount + sneakingFearNoiseAmount + panicFearNoiseAmount + visibleZombiesFearNoiseAmount + chasingZombiesFearNoiseAmount + veryCloseZombiesFearNoiseAmount
		-- Scream intensity lowers with how many zombies you kill as well, cuz your getting hardened.
		local fearNoiseAmount = fearNoiseAmount * fearfulTimeRemovalMod
		-- We cap the noise you make based off your panic, to work with traits or mods that make you desensitized / braver over time.
		fearNoiseAmount = PZMath.clamp(fearNoiseAmount, 0, (panic + 50) * 1.5)

		--[[
		print("total = " .. fearNoiseAmount)
		print("buildup influence = " .. noiseChance * 100)
		print("panic influence = " .. panicFearNoiseAmount)
		print("visible influence = " .. visibleZombiesFearNoiseAmount)
		print("chasing influence = " .. chasingZombiesFearNoiseAmount)
		print("close influence = " .. veryCloseZombiesFearNoiseAmount)
		]]--
		-- We say a scream line
		doFearNoiseByStrength(player, fearNoiseAmount)

		-- Reset the noiseChance buildup
		noiseChance = 0
	end
end

local function loseFearfulRoll()
	local player = getPlayer()
	if not player:HasTrait("Mar_Fearful") then return end

	-- If you got brave, then return
	if player:HasTrait("Brave") then 
		player:getTraits():remove("Mar_Fearful")
		return
	end

	local zombieKills = player:getZombieKills()
	-- if over maximum fearful then remove
		if zombieKills >= maxKillsTillRemoved then
			player:getTraits():remove("Mar_Fearful")
			return
			--elseif killed more than minimum, roll a check to remove
		elseif zombieKills > SandboxVars.MarTraits.FearfulMinimumKillsTillLose then
			-- Chance of removal grows from 0 to 100 once hit minimum
			local probability = (zombieKills - minKillsTillRemoved) / maxKillsTillRemoved
			local probabilityDenominator = 100 * probability

			if ZombRand(SandboxVars.MarTraits.FearfulMinimumKillsTillLose, SandboxVars.MarTraits.FearfulMaximumKillsTillLose) < SandboxVars.MarTraits.FearfulMinimumKillsTillLose then
				player:getTraits():remove("Mar_Fearful")
				return
			end
		end
end

Events.EveryHours.Add(loseFearfulRoll)
Events.OnPlayerUpdate.Add(fearfulUpdate)