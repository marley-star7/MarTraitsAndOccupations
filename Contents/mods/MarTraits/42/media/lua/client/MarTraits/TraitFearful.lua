require("MarLibrary")

local minKillsTillRemoved = 100
local maxKillsTillRemoved = 200
local noiseChance = 0 -- TODO: make this a mod saved thing.
local baseNoiseChanceSettleSpeed = 3
local baseNoiseChanceRiseSpeed = 0.3

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
local previousNumVisibleZombies = 0

-- "PainFromGlassCut" -- For "ah shits"
local function doSlightFearNoise(player)
	player:playerVoiceSound("PainFromScratch")
	addSound(player, player:getX(), player:getY(), player:getZ(), 2, 4)
	print("Slight Fear Noise Done")
end

-- "PainFromGlassCut" -- For "ah shits"
local function doFearNoise(player)
	player:playerVoiceSound("PainFromLacerate")
	addSound(player, player:getX(), player:getY(), player:getZ(), 4, 8)
	print("Fear Noise Done")
end

-- For small scares.
local function doStrongFearNoise(player)
	player:playerVoiceSound("PainFromBite")
	addSound(player, player:getX(), player:getY(), player:getZ(), 8, 16)
	print("Strong Fear Noise Done")
end

-- "DeathFall" -- For really panic scream moments.
local function doExtremeFearNoise(player)
	-- 2 in 5 chance to use deathEaten occasionally as mixup.
	if ZombRand(1, 5) <= 2 then
		player:playerVoiceSound("DeathEaten")
	else
		player:playerVoiceSound("DeathFall")
	end
	addSound(player, player:getX(), player:getY(), player:getZ(), 40, 50)
	print("Extreme Fear Noise Done")
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
	--print(noiseChance)
	-- TODO: make it go up or go down based off same values, instead of panic, so then you can manage it and no longer will you randomly yelp
	if panic < 1 or player:isSneaking() then
		-- Slowly move noise chance to zero.
		noiseChance = PZMath.lerp(noiseChance, 0, baseNoiseChanceSettleSpeed * delta)
	else
		-- TODO: make the panic thing instead whenever there is a panic jump, instead  of steady rise with panic, and just make it so that you pant panicking.
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
		noiseChance = noiseChance + panicNoiseChanceInfluence + visibleZombiesSpikeNoiseChanceInfluence + visibleZombiesNoiseChanceInfluence + chasingZombiesNoiseChanceInfluence + veryCloseZombiesNoiseChanceInfluence
		-- Save previous num visible zombies.
		previousNumVisibleZombies = currentNumVisibleZombies

		local rand = ZombRandFloat(0, 1)  -- Random value between 0 and 100
		if rand <= noiseChance then

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
			-- We cap the noise you make based off your panic, to work with traits or mods that make you desensitized / braver over time.
			fearNoiseAmount = PZMath.clamp(fearNoiseAmount, 0, (panic + 50) * 1.5)

			print("total = " .. fearNoiseAmount)
			print("buildup influence = " .. noiseChance * 100)
			print("panic influence = " .. panicFearNoiseAmount)
			print("visible influence = " .. visibleZombiesFearNoiseAmount)
			print("chasing influence = " .. chasingZombiesFearNoiseAmount)
			print("close influence = " .. veryCloseZombiesFearNoiseAmount)
			-- We say a scream line
			if fearNoiseAmount <= 30 then
				doSlightFearNoise(player)
			elseif fearNoiseAmount <= 60 then
				doFearNoise(player)
			elseif fearNoiseAmount <= 90 then
				doStrongFearNoise(player)
			elseif fearNoiseAmount >= 100 then
				doExtremeFearNoise(player)
			end

			-- Reset the noiseChance buildup
			noiseChance = 0
		end
	end
end

Events.OnPlayerUpdate.Add(fearfulUpdate)