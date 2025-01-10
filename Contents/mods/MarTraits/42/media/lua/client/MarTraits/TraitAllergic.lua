require("MarLibrary.Traits")

local moodleFrameworkActive = false
if getActivatedMods():contains("\\MoodleFramework") == true then
	require "MF_ISMoodle" --Moodle Framework requirement
	MF.createMoodle("SeasonalAllergies") --Create moodle through framework
	MF.createMoodle("DustAllergies") --Create moodle through framework
	moodleFrameworkActive = true
	print("TraitAllergic: Moodles Initialized!")
end

MarTraits = MarTraits or {}

--Declare local scope variables
local baseSneezeCountdown = 200.0 -- Counter to reset to on sneeze
local sneezeTimeMultiplier = 1.0 -- Modified by traits like Prone to Illness
local allergyRate = 0.02 --Multiplier on how fast allergy moodles move up and down
local baseAllergyRecoveryRate = .4 -- How quickly allergies should recover per minute
local proportionalAllergyRecoveryRate = 10.0 -- At max allergy, the base rate is multiplied by this number to return to "normal"
local seasonDelta = 0.0 -- Tracks the effect of seasons outside of the season update.
local sneezeSoundRange = 30 --Default range
local sneezeSoundVolume = 30 --Default volume
local conspicuousMod = 0.3 --A percentage (0.0 - 1.0) for more or less range depending on traits
local sneezeMuteMod = 0.1 --Multiplier on range and volume when muted. In vanilla, this is full mute, or 0.0
local sneezeColdMod = 1.25 --Multiplier on range/volume if player has a cold also. 1.0 is default volume
local tissueUseChance = 100 --Modifier on the chance to use tissues last from sneezes. 0 - 100%.

local totalPollen = 0.0 -- Trackers for update functions
local dustRoom = 0.0
local dustSquare = 0.0

local dustRoomMod = -0.08 --Amount to subtract from dust allergy moodle per dust in room
local dustSquareMod = -1.0 --Amount to subtract from dsut moodle per dust near player

local treeSneezeCost = -60 --Amount to subtract from sneezeCountdown when in trees
local dustSneezeCost = -30 --Amount to subtract from sneezeCountdown when standing on dust

local player = nil
local validItemTypes = {} -- A list of valid body slots for pollen tracked items to exist in

local moodleLevel1 = 0.8
local moodleLevel2 = 0.6
local moodleLevel3 = 0.4
local moodleLevel4 = 0.2

MarTraits.OnCreatePlayer = function(playerIndex, createdPlayer) --Load data on player creation
	player = createdPlayer
	-- That boy can SNEEZE!
	if player:HasTrait("ProneToIllness") then
		sneezeTimeMultiplier = sneezeTimeMultiplier * 0.75
	end

	if player:getModData().dictMarTraitsTrackedItems == nil then
		print("Adding item tracking to player")
		player:getModData().dictMarTraitsTrackedItems = {}
	else
		print("Item tracking already added.")
	end
	
	if player:HasTrait("Mar_DustAllergic") or player:HasTrait("Mar_SeasonAllergic") then
		if player:getModData().fMarTraitsSneezeCountdown == nil then
			print("Nil sneeze countdown, initializing")
			player:getModData().fMarTraitsSneezeCountdown = baseSneezeCountdown * sneezeTimeMultiplier
		end

		--With the Inconspicuous trait and base values of 30, sneezes match range and volume of vanilla.
		--With no trait, they are louder by about 30%. With Conspicuous, this is again louder.
		if player:HasTrait("Conspicuous") then
			sneezeSoundRange = sneezeSoundRange + (sneezeSoundRange * conspicuousMod)
			sneezeSoundVolume = sneezeSoundVolume + (sneezeSoundVolume * conspicuousMod)
		elseif player:HasTrait("Inconspicuous") then
			sneezeSoundRange = sneezeSoundRange - (sneezeSoundRange * conspicuousMod)
			sneezeSoundVolume = sneezeSoundVolume + (sneezeSoundVolume * conspicuousMod)
		end
	end

	if player:HasTrait("Mar_DustAllergic") then
		if player:getModData().fMarTraitsDustAllergyLevel == nil then
			print("Nil allergy level, initializing")
			player:getModData().fMarTraitsDustAllergyLevel = 1.0
			print("Dust level set to ", player:getModData().fMarTraitsDustAllergyLevel)
		end

		--Set thresholds for the moodle levels - Bad lvls 4, 3, 2, 1 | Good lvls 1, 2, 3, 4
		if moodleFrameworkActive then
			MF.getMoodle("DustAllergies",player:getPlayerNum()):setThresholds(moodleLevel4,moodleLevel3,moodleLevel2,moodleLevel1,nil,nil,nil,nil)
		end

		print("DustAllergic Trait Character Initialized")
	end

	if player:HasTrait("Mar_SeasonAllergic") then
		if player:getModData().fMarTraitsSeasonAllergyLevel == nil then
			print("Nil allergy level, initializing")
			player:getModData().fMarTraitsSeasonAllergyLevel = 1.0
			print("Season Level set to ",player:getModData().fMarTraitsSeasonAllergyLevel)
		end

		--Set thresholds for the moodle levels - Bad lvls 4, 3, 2, 1 | Good lvls 1, 2, 3, 4
		if moodleFrameworkActive then
			MF.getMoodle("SeasonalAllergies",player:getPlayerNum()):setThresholds(moodleLevel4,moodleLevel3,moodleLevel2,moodleLevel1,nil,nil,nil,nil)			
		end

		print("SeasonAllergic Trait Character Initialized")
	end
end
Events.OnCreatePlayer.Add(MarTraits.OnCreatePlayer)

MarTraits.getItemPollen = function(item)
	return item:getModData().fMarTraitsPollenLevel
end

MarTraits.setItemPollen = function(item, amount)
	item:getModData().fMarTraitsPollenLevel = PZMath.clampFloat(amount,0.0,1.0)
end

MarTraits.addItemPollen = function(item, amount)
	if player == nil then 
		player = getPlayer()
	end

	local parts = item:getCoveredParts()
	local randIndex = ZombRand(0,item:getNbrOfCoveredParts())
	local selected = parts:get(randIndex)
	-- local player = getPlayer()

	-- Add dirt so player can clean it.
	-- TODO: Not ideal since this does not communicate HOW much pollen is on the clothes to the player at all, but the alternative is getting really dirty just by being in the wind.
	if not item:hasDirt() then
		player:addDirt(selected, 1, true)
	end

	print("Typeof parts: ",type(parts))
	print("Adding dirt to part: "..selected:getDisplayName())

	MarTraits.setItemPollen(item,amount + MarTraits.getItemPollen(item))
end

MarTraits.addTrackedItemType = function(strType)
	table.insert(validItemTypes,strType)
end

MarTraits.isValidItemType = function(item)
	--print(item:getName().." is worn on "..item:getBodyLocation())
	for i, validType in pairs(validItemTypes) do
		if item:getBodyLocation() == validType then return true end
	end
	return false
end

MarTraits.trackItem = function (_player, item)
	if _player:getModData().dictMarTraitsTrackedItems[item:getID()] == nil then
		_player:getModData().dictMarTraitsTrackedItems[item:getID()] = item
		print("Tracking item "..item:getID())
	end
end

MarTraits.untrackItem = function(_player, item)
	_player:getModData().dictMarTraitsTrackedItems[item:getID()] = nil
end

MarTraits.updateTrackedItems = function()
	if player == nil then 
		player = getPlayer()
	end
	--print("Updating Tracked Items")

	if player:getModData().dictMarTraitsTrackedItems == nil or player:getModData().dictMarTraitsTrackedItems == {} then
		return
	end

	for ID, item in pairs(player:getModData().dictMarTraitsTrackedItems) do
		local pollen = MarTraits.getItemPollen(item)
		--print("Item "..item:getName().." has pollenLevel "..pollen)

		local wet = item:getWetness()
		if wet ~= nil and wet > 0 then
			local newMax = PZMath.max(100 - (wet * 2), 0)/100.0
			--print("Item is wet: "..wet.." , new max pollen "..newMax)
			MarTraits.setItemPollen(item, PZMath.clampFloat(pollen, 0.0, newMax))
		end

		if MarTraits.getItemPollen(item) <= 0 then
			--print("Item "..item:getName().." is clean, remove from tracking!")
			MarTraits.untrackItem(player,item)	
		end
	end
end
Events.EveryTenMinutes.Add(MarTraits.updateTrackedItems)

--A list of item slots we can track pollen on.
MarTraits.addTrackedItemType("Hat")
MarTraits.addTrackedItemType("TorsoExtraVest")
MarTraits.addTrackedItemType("Jacket")
MarTraits.addTrackedItemType("Sweater")
MarTraits.addTrackedItemType("Dress")
MarTraits.addTrackedItemType("Shirt")
MarTraits.addTrackedItemType("Tshirt")
MarTraits.addTrackedItemType("TankTop")
MarTraits.addTrackedItemType("Pants")
--MarTraits.addTrackedItemType("Mask") --Don't track mask, just look for the equip slot to reduce effect.

MarTraits.setSneezeCountdown = function(_player, newLevel)
	_player:getModData().fMarTraitsSneezeCountdown = PZMath.clampFloat(newLevel, -1.0, baseSneezeCountdown*sneezeTimeMultiplier)
	return MarTraits.getSneezeCountdown(_player)
end

MarTraits.getSneezeCountdown = function(_player)
	return _player:getModData().fMarTraitsSneezeCountdown
end

MarTraits.setSeasonAllergyLevel = function(_player,newLevel)
	_player:getModData().fMarTraitsSeasonAllergyLevel = PZMath.clampFloat(newLevel,0.0,1.0)
	return MarTraits.getSeasonAllergyLevel(_player)
end

MarTraits.getSeasonAllergyLevel = function(_player)
	return _player:getModData().fMarTraitsSeasonAllergyLevel
end

MarTraits.setDustAllergyLevel = function(_player,newLevel)
	_player:getModData().fMarTraitsDustAllergyLevel = PZMath.clampFloat(newLevel,0.0,1.0)
	return MarTraits.getDustAllergyLevel(_player)
end

MarTraits.getDustAllergyLevel = function(_player)
	return _player:getModData().fMarTraitsDustAllergyLevel
end

MarTraits.allergicSeasonUpdate = function()
	local climate = getWorld():getClimateManager()
	local season = climate:getSeasonName()

	-- Like does lua have switch statements or what cuz?????
	if season == "Early Summer" then
		seasonDelta = 3.5
	elseif season == "Summer" then
		seasonDelta = 2.5
	elseif season == "Early Autumn" then
		seasonDelta = 2.0
	elseif season == "Autumn" then
		seasonDelta = 1.0
	elseif season == "Early Winter" then
		seasonDelta = 0.0
	elseif season == "Winter" then
		seasonDelta = 0.0
	elseif season == "Early Spring" then
		seasonDelta = 3.0
	elseif season == "Spring" then
		seasonDelta = 5.0 -- Tree Pollen Baybee May go CRAZY!
	end

	print("Season: "..season.." Effect: "..seasonDelta)

end
Events.EveryDays.Add(MarTraits.allergicSeasonUpdate)
Events.OnCreatePlayer.Add(MarTraits.allergicSeasonUpdate)

MarTraits.addClothesPollen = function(_player,amount)
	if player == nil then 
		return
	end

	local items = _player:getWornItems()
	local size = items:size() - 1
	--print("Items: "..size)
	--print("CLOTHING UPDATE")
	for c=0,size do
		local item = items:getItemByIndex(c)
		if item:IsClothing() and MarTraits.isValidItemType(item) then
			MarTraits.addItemPollen(item,amount)
			MarTraits.trackItem(_player,item)
		end
	end
end

MarTraits.clothesUpdated = function(_player)
	if player == nil then 
		player = getPlayer()
	end

	if player == getPlayer() then
		local items = player:getWornItems()
		local size = items:size() - 1
		--print("Items: "..size)
		--print("CLOTHING UPDATE")
		for c=0,size do
			local item = items:getItemByIndex(c)
			if item:IsClothing() and MarTraits.isValidItemType(item) then
				--print(item:getName() .. " -- Equipped on " .. items:getLocation(item))
				if MarTraits.getItemPollen(item) == nil then
					MarTraits.setItemPollen(item,0)
					print("Added Pollen Tracking to item")
				elseif MarTraits.getItemPollen(item) > 0 then
					MarTraits.trackItem(player,item)
				end
			end
		end
	end
end
Events.OnClothingUpdated.Add(MarTraits.clothesUpdated)

MarTraits.updateClothesTotalPollen = function()
	if player == nil then 
		player = getPlayer()
	end

	-- local player = getPlayer()
	local items = player:getWornItems()
	local size = items:size() - 1
	totalPollen = 0

	for c=0, size do
		local item = items:getItemByIndex(c)
		--print(item:getName() .. items:getLocation(item))

		local pollen = MarTraits.getItemPollen(item)
		if pollen ~= nil then
			if items:getLocation(item) == "Pants" then
				totalPollen = totalPollen + (pollen * 0.25) --Smaller effect from pants
			else
				totalPollen = totalPollen + pollen
			end
		end
	end
end
Events.EveryTenMinutes.Add(MarTraits.updateClothesTotalPollen)

local dustSquareMax = 4
MarTraits.sumDustInSquare = function(gridSquare)
	if gridSquare == nil then return 0 end

	local squareObjects = gridSquare:getObjects()

	if squareObjects == nil then return 0 end

	local dustSum = 0

	--print("There are ",squareObjects:size()," objects in this square")

	for i=0,squareObjects:size()-1 do
		if dustSum >= dustSquareMax or i > 15 then --Sanity check, prevent huge returns or super long loops if somehow there are a lot of objects.
			break
		end

		local object = squareObjects:get(i);
		
		if object then
			local attachedsprite = object:getAttachedAnimSprite()
			
			if object:getTextureName() and luautils.stringStarts(object:getTextureName(), "overlay_grime") then
				-- Dirty Tile
				dustSum = dustSum + 1
				-- print("Dirty Texture")
			end
			
			if object:getOverlaySprite() and object:getOverlaySprite():getName() and luautils.stringStarts(object:getOverlaySprite():getName(), "overlay_grime") then
				-- Dirty Tile
				dustSum = dustSum + 1
				-- print("Dirty OverlaySprite")
			end

			if attachedsprite then
				for n=1,attachedsprite:size() do
					local sprite = attachedsprite:get(n-1)
					
					if sprite and sprite:getParentSprite() and sprite:getParentSprite():getName() and luautils.stringStarts(sprite:getParentSprite():getName(), "overlay_grime") then
						-- Dirty Tile
						dustSum = dustSum + 1
						-- print("Dirty AttachedSprite")
					end
				end 
			end 
		end
	end

	return dustSum
end

local dustRoomMax = 30
MarTraits.allergyDustInRoom = function()
	if player == nil then 
		player = getPlayer()
	end

	if not player:HasTrait("Mar_DustAllergic") or player:isAsleep() or player:isOutside() then
		dustRoom = 0
		return
	end

	local room = player:getCurrentRoomDef()

	if room == nil then 
		dustRoom = 0
		return 
	end
	
	local roomSquares = room:getIsoRoom():getSquares()
	--print("--== Dust Room Debugger ==--")

	local dustSum = 0
	
	--print("There are ",roomSquares:size()," squares in this room.")
	if roomSquares:size() > 150 then
		local x = player:getX()
		local y = player:getY()
		local z = player:getZ()
		local playerSquare = getCell():getGridSquare(x,y,z)

		for squareX = x-5, x+5 do
			if dustSum >= dustRoomMax then
				break
			end
			for squareY = y-5, y+5 do
				local square = getCell():getGridSquare(squareX,squareY,z)
				if playerSquare:getRoomID() == square:getRoomID() then
					dustSum = dustSum + MarTraits.sumDustInSquare(square)
				end
			end
		end
	else
		for s=0, roomSquares:size()-1 do
			if dustSum >= dustRoomMax then
				break
			end
			dustSum = dustSum + MarTraits.sumDustInSquare(roomSquares:get(s))
		end
	end

	--print("Dust in Player Room: ",dustSum)

	dustRoom = PZMath.clamp(dustSum,0,dustRoomMax)
end
Events.EveryTenMinutes.Add(MarTraits.allergyDustInRoom)


MarTraits.allergyDustOnSquare = function()
	if player == nil then 
		player = getPlayer()
	end

	if not player:HasTrait("Mar_DustAllergic") or player:isAsleep() then
		dustSquare = 0
		return
	end

	--print("--== Dust Debugger ==--")
	local square = getCell():getGridSquare(player:getX(),player:getY(),player:getZ())

	if square == nil then 
		dustSquare = 0
		return 
	end

	local dustSum = MarTraits.sumDustInSquare(square)
	--print("Dust In Player Square: ",dustSum)

	if player:isOutside() then
		dustSum = dustSum * 0.2 -- When outside, "dust" tiles have reduced effect.
	end

	dustSquare = dustSum 
end
Events.EveryOneMinute.Add(MarTraits.allergyDustOnSquare)


MarTraits.treePollenClothesUpdate = function()
	if player == nil then
		player = getPlayer()
	end

	if player:isInTrees() then
		MarTraits.addClothesPollen(player,0.1) -- Add 10% max pollen on clothes items when walking through trees
		print("======== ADDED CLOTHES POLLEN ==========")
	end
end
Events.EveryOneMinute.Add(MarTraits.treePollenClothesUpdate)

local allergySneezeActive = false --Tracks if last loop, allergies caused sneezing. This is so we don't interfere with colds or other sneeze triggers.
MarTraits.allergicSneezeUpdate = function()
	if player == nil then 
		player = getPlayer()
	end
	
	if player:isAsleep() then
		return
	end 

	local moodleShowing = false

	if player:HasTrait("Mar_SeasonAllergic") then
		local allergyDelta = 0.0

		local climate = getWorld():getClimateManager()
		
		--print("Wind speed is: ",climate:getWindspeedKph() / 40.0)
		--print("Speed Lerp: ",PZMath.lerp(-0.2, -1.0, climate:getWindspeedKph() / 40.0))
		local windDelta = PZMath.clampFloat(PZMath.lerp(-0.2, -1.0, climate:getWindspeedKph() / 40.0), -1.0, -0.2) -- With no wind, modify seasonal allergy effect by the first argument, with max wind, modify by second argument.

		local rainDelta = 0.0
		if climate:getRainIntensity() > 0 then
			rainDelta = PZMath.lerp(1.0, 5.0, (climate:getRainIntensity())) --Rain will restore the counter.
		end

		local insideMod = 1.0 --Wind and rain are divided by this number.
		if not player:isOutside() then
			insideMod = 3.0
		end

		local treeDelta = 0.0
		if player:isInTrees() then
			treeDelta = -10.0
		end
		
		local clothesDelta = PZMath.lerp(0.0, -1.0, totalPollen) --Every "full" clothes item will incur the set cost.

		--Accumulate all effects and then update player allergy level.
		allergyDelta = allergyDelta + (((seasonDelta * windDelta) + rainDelta) / insideMod) + treeDelta + clothesDelta

		--If wearing mask, reduce effects of all deltas!
		if player:getWornItems():getItem("Mask") ~= nil then
			allergyDelta = allergyDelta * 0.75
		end

		local oldLevel = MarTraits.getSeasonAllergyLevel(player)
		allergyDelta = allergyDelta + PZMath.lerp(baseAllergyRecoveryRate, baseAllergyRecoveryRate * proportionalAllergyRecoveryRate, 1.0 - oldLevel)
		local newLevel = MarTraits.setSeasonAllergyLevel(player, oldLevel + (allergyDelta * allergyRate)) 

		if newLevel <= moodleLevel1 then
			moodleShowing = true
		end
		print(string.format("SeasonalAllergy %.2f/%.2f (%.2f) | Season %.2f | Wind %.2f | Rain %.2f | Clothes %.2f | Trees %.2f", oldLevel, newLevel, allergyDelta * allergyRate, seasonDelta, windDelta, rainDelta, clothesDelta, treeDelta))

		if moodleFrameworkActive == true then
			moodle = MF.getMoodle("SeasonalAllergies", player:getPlayerNum())
			moodle:setValue(newLevel)
		end

		local countChange = 0
		if newLevel <= moodleLevel1 then
			countChange = PZMath.lerp(-15.0, -0.1, newLevel - (1.0 - moodleLevel1))
		else
			countChange = PZMath.lerp(0.0, 0.05, newLevel - moodleLevel1)
		end

		print("Sneeze Change: ",countChange)
		if treeDelta < 0 then
			print("In trees!")
			countChange = countChange + (treeSneezeCost) -- Standing in trees subtracts seconds from sneeze for quick feedback/consequences
			print("Sneeze Change Updated: ",countChange)
		end

		MarTraits.setSneezeCountdown(player,MarTraits.getSneezeCountdown(player) + countChange)
	end

	if player:HasTrait("Mar_DustAllergic") then
		local allergyDelta = 0.0

		allergyDelta = allergyDelta + (dustRoom * dustRoomMod) + (dustSquare * dustSquareMod)

		--If wearing mask, reduce effects of all deltas!
		if player:getWornItems():getItem("Mask") ~= nil then
			allergyDelta = allergyDelta * 0.75
		end

		local oldLevel = MarTraits.getDustAllergyLevel(player)
		allergyDelta = allergyDelta + PZMath.lerp(baseAllergyRecoveryRate, baseAllergyRecoveryRate * proportionalAllergyRecoveryRate, 1.0 - oldLevel)
		local newLevel = MarTraits.setDustAllergyLevel(player, oldLevel + (allergyDelta * allergyRate))

		if newLevel <= moodleLevel1 then
			moodleShowing = true
		end

		print(string.format("DustAllergy %.2f/%.2f (%.2f) | Room %.2f | Square %.2f", oldLevel, newLevel, allergyDelta * allergyRate, dustRoom * dustRoomMod, dustSquare * dustSquareMod))
		if moodleFrameworkActive == true then
			moodle = MF.getMoodle("DustAllergies",player:getPlayerNum())
			moodle:setValue(newLevel)
		end		

		local countChange = 0
		if newLevel <= moodleLevel1 then
			countChange = PZMath.lerp(-15.0, -0.1, newLevel - (1.0 - moodleLevel1))
		else
			countChange = PZMath.lerp(0.0, 0.05, newLevel - moodleLevel1)
		end

		print("Sneeze Change: ",countChange)

		if dustSquare > 0 then
			print("Standing in Dust!")
			countChange = countChange + (dustSquare * dustSneezeCost) -- Standing in dust subtracts seconds from sneeze for quick feedback/consequences
			print("Sneeze Change Updated: ",countChange)
		end

		MarTraits.setSneezeCountdown(player,MarTraits.getSneezeCountdown(player) + countChange)
	end
	
	if player:HasTrait("Mar_DustAllergic") or player:HasTrait("Mar_SeasonAllergic") then
		print("Sneeze Countdown: ",MarTraits.getSneezeCountdown(player))
		if MarTraits.getSneezeCountdown(player) <= 0 then
			MarTraits.setSneezeCountdown(player, baseSneezeCountdown * sneezeTimeMultiplier * (ZombRand(70,100) * 0.01))

			if not moodleShowing then
				return --Abort if neither moodle is showing!
			end
			allergySneezeActive = true --Track that allergies caused a sneeze

			local volume = sneezeSoundVolume
			local range = sneezeSoundRange
			if player:getBodyDamage():isHasACold() then
				volume = volume * sneezeColdMod
				range = range * sneezeColdMod
			end

			local itemPrimaryHand = player:getPrimaryHandItem()
			local itemSecondaryHand = player:getSecondaryHandItem()
			-- "Sneezing Tissue" by Hea
			if player:hasEquipped("Base.ToiletPaper") or player:hasEquipped("Base.Tissue") then
				if ZombRand(0,100) <= tissueUseChance then
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
				player:getBodyDamage():setSneezeCoughActive(3) --Int 3 is "stifled" sneeze active
				if sneezeMuteMod > 0 then -- If sneezeMuteMod == 0, then no sound is played!
					addSound(player, player:getX(), player:getY(), player:getZ(), range * sneezeMuteMod, volume * sneezeMuteMod);
				end

			else -- "Sneezing No Tissue" by Hea
				player:getBodyDamage():setSneezeCoughActive(1) --Int 1 is "normal" sneeze active
				addSound(player, player:getX(), player:getY(), player:getZ(), range, volume);
			end

		else if allergySneezeActive then --Makes sure we don't disable a non-allergic sneeze.
			allergySneezeActive = false
			player:getBodyDamage():setSneezeCoughActive(0) --Disable sneezing
		end
	end
end
Events.EveryOneMinute.Add(MarTraits.allergicSneezeUpdate)