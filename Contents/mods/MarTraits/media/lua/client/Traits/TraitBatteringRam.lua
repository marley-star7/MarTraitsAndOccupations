require("MarLibrary")

MarTraits = MarTraits or {}

-- TODO: Rework this so that you need to be sprinting as well so cant do it when cant sprint
-- TODO: Make this use a bit of endurance
-- TODO: add trip

-- There is a bug where the zombie will get double bumped currently.
-- This is due to the fact I cannot prevent the player nor the zombie from being able to be bumped quickly after they have bumped them.
-- At least this is my best guess as to how this happens.
-- It's probably fixable without jank if you attach some data to the bumped zombies that tells them they cant be bumped by THIS specific method until they get up.

local int lockedDoorBargeDamage = 10
local int baseBumpEnduranceCost = .015
local int bumpNbrTillTrip = 0
local int minRunTime = 15

-- We do this on sprint key pressed because if it was OnPlayerMove when they are sprinting -
-- bumping into zombies stops sprinting so then going from one bump right to another would not trigger the full knockdown.

local function staggerZombieBack(zombie)
	zombie:setBumpDone(false)
	zombie:setStaggerBack(true)
end

local function bumpZombieToGround(zombie)
	zombie:setBumpDone(false)
	zombie:setStaggerBack(true)
	zombie:setKnockedDown(true)
	zombie:setHitReaction("")
	zombie:setHitForce(2.0)
	-- this exists to solve a but with repeated bumps and the zombie visually being knocked down repeatedly, we delay it a bit however as to not remove collision with zombs.
	MarLibrary.delayFuncByDelta(function()
		zombie:setOnFloor(true) -- So we don't repeatedly collide with the same zombie.
	end, .3)
end

local function onSprintKeyPressed(key)
	local player = getPlayer()
	if player == nil then return end
	if not player:HasTrait("BatteringRam") then return end
	if not player:canSprint() then return end
	if player:isOnFloor() then return end

	if key == getCore():getKey("Sprint") then
		local stats = player:getStats()
		local endurance = stats:getEndurance()
		local fitnessLvl = stats:getFitness()
		local strengthLvl = player:getPerkLevel(Perks.Strength)
		local bodydamage = player:getBodyDamage()

		-- If limping.
		if bodydamage:getBodyPart(BodyPartType.UpperLeg_L):getFractureTime() > 1 or bodydamage:getBodyPart(BodyPartType.UpperLeg_R):getFractureTime() > 1 or bodydamage:getBodyPart(BodyPartType.LowerLeg_L):getFractureTime() > 1 or bodydamage:getBodyPart(BodyPartType.LowerLeg_R):getFractureTime() > 1 or bodydamage:getBodyPart(BodyPartType.Foot_L):getFractureTime() > 1 or bodydamage:getBodyPart(BodyPartType.Foot_R):getFractureTime() > 1 then
			return
		end

		local playerState = tostring(player:getCurrentState())
		-- getName() doesn't work for some reason.
		if player:isCollidedWithDoor() and not string.find(playerState, "BumpedState") then
			collidedDoor = player:getCollidedObject():getSquare():getIsoDoor() -- Weird fucking path, yes it has to be this way.
			doorMaxHealth = collidedDoor:getMaxHealth()
			collidedDoor:getSquare():playSound(collidedDoor:getThumpSound())
			collidedDoor:getSquare():playSound(collidedDoor:getThumpSound())
			-- EnduranceCost
			local bumpEnduranceCost = (baseBumpEnduranceCost - fitnessLvl/100) * 2
			stats:setEndurance(endurance - bumpEnduranceCost)

			local isLocked = collidedDoor:isLocked()
			local isLockedByKey = collidedDoor:isLockedByKey()
			if isLocked or isLockedByKey then
				doorHealth = collidedDoor:getHealth()
				if doorHealth <= lockedDoorBargeDamage then
					MarTraits.doorBargeBreak(player, collidedDoor)
					return
				else
					collidedDoor:setHealth(collidedDoor:getHealth() - lockedDoorBargeDamage)

					local openChance = (player:getPerkLevel(Perks.Strength) * 10) - 50
					-- More likely to open if lucky
					if player:HasTrait("Lucky") then
						openChance = openChance + 10
					elseif player:HasTrait("Unlucky") then
						openChance = openChance - 10
					end

					if MarLibrary.chance(openChance) then
						if isLocked then
							collidedDoor:setLocked(false)
						elseif isLockedByKey then
							collidedDoor:setLockedByKey(false)
						end
						MarTraits.doorBargeOpen(player, collidedDoor)
					else
						-- Fall if you didn't get a good running start
						MarTraits.doorBarge(player, collidedDoor)
						if player:getBeenSprintingFor() < minRunTime then
							MarLibrary.bumpFallBackwards(player)
						end
					end
				end
			else
				MarTraits.doorBargeOpen(player, collidedDoor)
				return
			end
		end

		local playerData = player:getModData()
		if player:isBumped() then
			if player:getBumpedChr() ~= nil then -- Bumped character can be nil/null since we use the bump state for doors as well.
				local bumpedChr = player:getBumpedChr()
				if bumpedChr:isCharacter() then
					bumpZombieToGround(bumpedChr)

					-- This is to solve bug with double bumps, the zombie is still forced down but the player is not forced to bump penalty again.
					if playerData.batteringRamLastBumpedChr ~= bumpedChr then
						playerData.batteringRamLastBumpedChr = bumpedChr
						-- EnduranceCost
						local bumpEnduranceCost = baseBumpEnduranceCost - fitnessLvl/100
						stats:setEndurance(endurance - bumpEnduranceCost)
						bumpNbrTillTrip = bumpNbrTillTrip + 1
					end
					-- Amount of zombies take down before trip is dependent on strength
					if bumpNbrTillTrip <= strengthLvl - 3 then
						MarLibrary.cancelBumpFall(player)
					else
						MarLibrary.trip(player)
						playerData.bumpNbrTillTrip = 0
						bumpNbrTillTrip = 0
					end
				end
			end
		end
	end
end
Events.OnKeyKeepPressed.Add(onSprintKeyPressed)

local function reduceBumpNbrTillTrip()
	bumpNbrTillTrip = PZMath.clamp(bumpNbrTillTrip -1, 0, 10)
end
Events.EveryOneMinute.Add(reduceBumpNbrTillTrip)

MarTraits.traitBatteringRamOnLevelPerk = function(player, perk, perkLevel)
	if perk ~= Perks.Strength then return end

	if player:HasTrait("BatteringRam") then
		if perkLevel >= 10 then
			player:getTraits():add("BatteringRam")
		end
	end
end
Events.LevelPerk.Add(MarTraits.traitBatteringRamOnLevelPerk)

local function getDoorBumpType()
	if collidedDoor:getY() > player:getY() then
		return"right"
	else
		return"left"
	end
end

function MarTraits.doorBarge(player, collidedDoor)
	player:setVariable("BumpDone", false)
	player:setBumpType(getDoorBumpType(collidedDoor))
end

function MarTraits.doorBargeOpen(player, collidedDoor)
	MarTraits.doorBarge(player, collidedDoor)
	collidedDoor:ToggleDoor(player)
	local square = collidedDoor:getSquare()
	local adjacentSquare = square:getAdjacentSquare(IsoDirections.fromAngle(player:getLastAngle()))
	local movingObjects = adjacentSquare:getMovingObjects()
	-- Knockback all the zombies on the other side.
	if movingObjects then
		for i = 0, movingObjects:size() - 1 do
			local character = movingObjects:get(i)
			if character:isZombie() then
				bumpZombieToGround(character)
			end
		end
	end
	-- TODO: Also make endurance and pain effect this.
	-- Trip chance dependent on strengthLvl, less likely to trip and harder depending on strength.
	-- Chance to trip based mostly on strength.
	local tripChance = 100 - player:getPerkLevel(Perks.Strength) * 10
	-- Less likely to trip if graceful
	if player:HasTrait("Graceful") then
		tripChance = tripChance - 10
	elseif player:HasTrait("Clumsy") then
		tripChance = tripChance + 10
	end
	-- Less likely to trip if lucky
	if player:HasTrait("Lucky") then
		tripChance = tripChance - 10
	elseif player:HasTrait("Unlucky") then
		tripChance = tripChance + 10
	end

	print(tripChance)
	if MarLibrary.chance(tripChance) then
		MarLibrary.trip(player)
	end
end

function MarTraits.doorBargeBreak(player, collidedDoor)
	MarTraits.doorBarge(player, collidedDoor)
	collidedDoor:getSquare():playSound("breakdoor")
	collidedDoor:destroy()
end