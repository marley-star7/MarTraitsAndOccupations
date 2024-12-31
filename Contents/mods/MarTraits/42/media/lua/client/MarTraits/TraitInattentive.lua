require('luautils')
require("MarLibrary")
require("MarLibraryEvents")

MarTraits = MarTraits or {}

MarTraits.InattentiveTrippableFloorOverlaySprites = {
    blends_streetoverlays_01 = {80, "TripOverObstacle"}, -- Large cracks in the ground
}

MarTraits.InattentiveExcludedTrippableFloorOverlaySprites = {

}

-- TODO: add the likely to cut yourself stuff while using knife on can or stuff.
local tripSoundCurb = ""
local curbTripChance = 40
MarTraits.InattentiveTrippableFloorCurbSprites = {
    -- The true or false, means its on the edge of a tile so the trip aligns properly
    street_curbs_01_0 = {IsoDirections.N, false}, -- This one is actually a North and West curb tile but I'm too lazy to code a whole thing for this one tile
    street_curbs_01_8 = {IsoDirections.N, false},
    street_curbs_01_20 = {IsoDirections.N, false},
    street_curbs_01_11 = {IsoDirections.E, true},
    street_curbs_01_57 = {IsoDirections.SE, false}, -- This one is the big bit of the diagonal curb
    street_curbs_01_62 = {IsoDirections.SE, true}, -- This one is a the tiny bit of the diagonal curb so we wait for a trip
    street_curbs_01_5 = {IsoDirections.S, true},
    street_curbs_01_10 = {IsoDirections.S, true},
    street_curbs_01_9 = {IsoDirections.W, false},
    street_curbs_01_56 = {IsoDirections.NW, false}, -- Long diagonal curb
    street_curbs_01_59 = {IsoDirections.NW, true}, -- Short diagonal curb
}

-- Eventually I'd like to swap over to a big list of included tiles with trip chances instead this but that's a bit time consuming.
MarTraits.InattentiveTrippableObjectSprites = {
    -- Those car parking lot things --
    street_decoration_01_45 = {100, "TripOverObstacle"},
    street_decoration_01_44 = {100, "TripOverObstacle"},
    street_decoration_01_43 = {100, "TripOverObstacle"},

    street_decoration_01_37 = {100, "TripOverObstacle"},
    street_decoration_01_36 = {100, "TripOverObstacle"},
    street_decoration_01_35 = {100, "TripOverObstacle"},
    -- NE --
    street_decoration_01_34 = {100, "TripOverObstacle"},
    street_decoration_01_33 = {100, "TripOverObstacle"},
    street_decoration_01_32 = {100, "TripOverObstacle"},

    street_decoration_01 = {100, "TripOverObstacle"},

    -- TRASH --
    trash_01_53 = {30, "GarbageKick"}, -- Regular Trash
    trash_01_52 = {40, "GarbageKick"}, -- Regular Junk
    trash_01_51 = {35, "GarbageKick"}, -- Newspaper and Trash
    trash_01_50 = {35, "GarbageKick"}, -- Newspaper and Trash
    trash_01_48 = {50, "GarbageKick"}, -- Trash Bags
    trash_01_42 = {35, "GarbageKick"}, -- Trash
    trash_01_41 = {50, "GarbageKick"}, -- Trash Bags
    trash_01_40 = {50, "GarbageKick"}, -- Trash Bags
    trash_01_19 = {50, "GarbageKick"},
    trash_01_17 = {50, "GarbageKick"},
    trash_01_8 = {15, "CanKick1"}, -- Small Can
    trash_01_5 = {15, "CanKick1"}, -- Small Can
    trash_01_0 = {15, "CanKick1"}, -- Small Can
    d_trash_1_18 = {35, "GarbageKick"}, -- Boxes and Bags
    d_trash_1_1 = {15, "GarbageKick"},

    trash_01 = {40, "GarbageKick"},
    d_trash_1 = {50, "TripOverObstacle"},
    -- GENERIC --
    -- It will base calculations for most things off this since it starts with 1, no need to fill in every generic.
    d_generic_1_ = {25, "TripOverObstacle"}, -- Base chance for generics
    boulders_ = {35, "TripOverObstacle"},
    construction_ = {60, "TripOverObstacle"},
    industry_ = {60, "TripOverObstacle"},
}

MarTraits.InattentiveExcludedTrippableObjectSprites = {
    "d_generic_1_0",
    "d_generic_1_1",
    "d_generic_1_2",
    "d_generic_1_7",
    "d_generic_1_26",
    "d_generic_1_48",
    "d_generic_1_51",
    "d_generic_1_53",
    "d_generic_1_54",
    "d_generic_1_80",
    "d_generic_1_82",
    "d_generic_1_81",
    "d_generic_1_83",
    "d_generic_1_86",
    "d_generic_1_87",
}

local function chance(percentage)
    if percentage >= ZombRand(1,100) then
        return true
    else
        return false
    end
end

local function getTrippableData(potentialTrippableName, trippableList, excludedTrippableList)
    for trippableName, trippableData in pairs(trippableList) do
        -- We make sure if it starts with it, it will work anyways, so don't have to write down EVERY tile.
        if luautils.stringStarts(potentialTrippableName, tostring(trippableName)) then
            for _, excludedTrippableName in pairs(excludedTrippableList) do
                if potentialTrippableName == tostring(excludedTrippableName) then
                    return
                end
            end
            print("Inattentive can trip sprite is '".. potentialTrippableName .. "'")
            return trippableData
        end
    end
end

local getSquareTrippableObjectSpriteChance = function(square)
    local floorObjs = square:getObjects()
    for i = 0, floorObjs:size() - 1 do
        local obj = floorObjs:get(i)
        if instanceof(obj, "IsoObject") then
            local sprite =  obj:getSprite()
            local spriteName = sprite:getName()
            if spriteName then
                -- Prioritize sprites with specific data associated over the generic.
                local specificTrippableData = getTrippableData(spriteName, MarTraits.InattentiveTrippableObjectSprites, MarTraits.InattentiveExcludedTrippableObjectSprites)
                if specificTrippableData then
                    return specificTrippableData
                end
            end
        end
    end
    return nil
end

local getSquareTrippableFloorSpriteData = function(square)
    local squareFloor = square:getFloor()
    local attachedSprites = squareFloor:getAttachedAnimSprite()
    if attachedSprites then
        for num = attachedSprites:size(), 1, -1 do
            local sprite = attachedSprites:get(num - 1)
            if sprite:getParentSprite():getName() then -- If the sprite has a name, if it doesn't it doesn't exist.
                local spriteName = sprite:getParentSprite():getName()

                -- Prioritize sprites with specific data associated over the generic.
                local specificTrippableData = getTrippableData(spriteName, MarTraits.InattentiveTrippableFloorOverlaySprites, MarTraits.InattentiveExcludedTrippableFloorOverlaySprites)
                if specificTrippableData then
                    return specificTrippableData
                end
            end
        end
    end
    return
end

local getSquareTrippableFloorCurbSpriteData = function(square)
    local squareFloor = square:getFloor()
    local attachedSprites = squareFloor:getAttachedAnimSprite()
    if attachedSprites then
        for num = attachedSprites:size(), 1, -1 do
            local sprite = attachedSprites:get(num - 1)
            if sprite:getParentSprite():getName() then
                local spriteName = sprite:getParentSprite():getName()
                --print(spriteName)
                for trippableCurbSpriteName, trippableCurbSpriteData in pairs(MarTraits.InattentiveTrippableFloorCurbSprites) do
                    if luautils.stringStarts(spriteName, tostring(trippableCurbSpriteName)) then
                        print("Inattentive can trip curb sprite is '".. spriteName .. "'")
                        return trippableCurbSpriteData
                    end
                end
            end
        end
    end
    return nil
end

-- TODO: Make player much more likely to trip in the dark
local player = nil

local function playTripSound(tripSound, square)
    if tripSound ~= '' then
        -- TODO: Check if other players can hear this.
        if tripSound == "GarbageKick" then
            tripSound = tripSound .. ZombRand(1,7)
        end
    else
        tripSound = "TripOverObstacle"
    end
    getSoundManager():PlayWorldSound(tripSound, square, ZombRand(-10,10), 5, 10, false)
    -- This so you can give away your position to zombs when tripping.
    addSound(player, player:getX(), player:getY(), player:getZ(), 6, 10) -- range, then volume
end

local squareTripBaseCooldown = 60
local clumsyTripCooldownModifier = 0.8

local tripChanceNextSquare = 0

local panicTripCooldownModifier = 0.8
local drunkTripCooldownModifier = 0.4

local function inattentiveResetTripCooldown()
    local tripChanceCooldownModifier = 1

    -- Trip more often when clumsy.
    if player:HasTrait("Clumsy2") or player:HasTrait("Clumsy") then
        tripChanceCooldownModifier = tripChanceCooldownModifier * clumsyTripCooldownModifier
    end
    
    local playerModData = player:getModData()
    playerModData.fMarTraitsSquaresTillCanTrip = squareTripBaseCooldown/tripChanceCooldownModifier
end

local lastSquareCurbData

local walkingTripChanceModifier = -75
local runningTripChanceModifier = 0
local sprintingTripChanceModifier = 75
local sneakingTripChanceModifier = -200
local sneakRunningTripChanceModifier = -40
local clumsyTripChanceModifier = 15

-- If modifiers for any of these are set to 1, it means for every 1 value out of 100 = 1 is added to the trip chance.
local stressTripChanceModifier = 0.5
local unhappynessTripChanceModifier = 0.65
local panicTripChanceModifier = 0.35 -- Panic is set low because it is often at 100
local drunkTripChanceModifier = 1.25
local stairsTripChanceModifier = 1.5
local painTripChanceModifier = 0.25 -- Pain barely has an effect.
local darkTripChanceModifier = 1 -- Dark has a big effect

local function inattentiveUpdate(_player, playerSquare)
    player = _player
    if not player:HasTrait("Mar_Inattentive") then return end
    if not playerSquare:getFloor() then return end

    local stats = player:getStats()
    local panic = stats:getPanic()
    local playerModData = player:getModData()

    local squaresTillCanTrip = playerModData.fMarTraitsSquaresTillCanTrip or 0
    if squaresTillCanTrip > 0 then
        print(squaresTillCanTrip) 
        local cooldownModifier = 1 

        -- Trip more often when panicking
        if panic > 5 then
            cooldownModifier = cooldownModifier - ((panic/100) * panicTripCooldownModifier)
        end

        -- Trip more often when drunk.
        local drunkenness = stats:getDrunkenness()
        if drunkenness > 10 then
            cooldownModifier = cooldownModifier - ((drunkenness/100) * drunkTripCooldownModifier)
        end

        playerModData.fMarTraitsSquaresTillCanTrip = squaresTillCanTrip - (1/cooldownModifier)
        return
    end

    if player:isDriving() then return end

    -- Currently the next square trip chance is only used for curbs that don't appear where they seem to be so we wait until you move a frame
    -- TODO: Probably change this just so that it uses the position of the next square you should be on instead of this.. smaller code and you'll have to use it to fix the other bug with tripping while not walking up curb.
    local tripChance = 0
    local tripSound = ""
    if tripChanceNextSquare > 0 then
        -- If the square where the last trippable curb should be is the square you are on
        if getSquareTrippableFloorCurbSpriteData(playerSquare:getAdjacentSquare(IsoDirections.reverse(lastSquareCurbData[1]))) == lastSquareCurbData then
            -- And if the player is moving the same direction needed by the curb still
            if MarLibrary.getCorrectPlayerMoveIsoDir(player) == lastSquareCurbData[1] then
                -- Trip
                tripChance = tripChance + tripChanceNextSquare
            end
        end
    end
    tripChanceNextSquare = 0

    --===========================--
    -- FINDING TRIPPABLE OBJECTS --
    --===========================--

    --== CHECKING FOR FLOOR OVERLAYS ==--
    -- Ex: (Cracks, Rugs)
    local trippableFloorSpriteData = getSquareTrippableFloorSpriteData(playerSquare)
    if trippableFloorSpriteData then
        tripChance = tripChance + trippableFloorSpriteData[1]
        tripSound = trippableFloorSpriteData[2]
    end

    --== CHECKING FOR CURBS ==--
    -- Curbs also floor overlay but have special calculation
    local squareCurbData = getSquareTrippableFloorCurbSpriteData(playerSquare)
    if squareCurbData then
        local squareCurbDir = squareCurbData[1]
        if MarLibrary.getCorrectPlayerMoveIsoDir(player) == squareCurbDir then
            local squareCurbNotAligned = squareCurbData[2]
            if squareCurbNotAligned then
                tripChanceNextSquare = tripChanceNextSquare + curbTripChance
            else
                tripChance = tripChance + curbTripChance
                tripSound = "TripOverObstacle"
            end
        end
        lastSquareCurbData = squareCurbData
    end

    --== CHECKING FOR ITEMS ==--
    -- Apparently cant use for each loops with Array lists from java, so we do this instead
    local playerSquareWorldObjects = playerSquare:getWorldObjects()
    for i = 0, playerSquareWorldObjects:size() -1, 1 do
        local object = playerSquareWorldObjects:get(i)
        local item = object:getItem()
        tripChance = tripChance + item:getWeight() * 5
        tripSound = item:getPlaceOneSound()
    end

    --== CHECKING FOR CORPSES ==--
    local zombieDeadCount = playerSquare:getDeadBodys():size()
    tripChance = tripChance + (zombieDeadCount * 10)

    --== CHECKING FOR VISUAL OBJECTS ==--
    -- Ex: (Trash, Twigs, Misc)
    local trippableObjectSpriteData = getSquareTrippableObjectSpriteChance(playerSquare)
    if trippableObjectSpriteData then
        tripChance = tripChance + trippableObjectSpriteData[1]
        tripSound = trippableObjectSpriteData[2]
    end

    --=========================--
    -- CALCULATING TRIPS --
    --=========================--

    if tripSound == "" then
        tripSound = "TripOverObstacle"
    end

    if tripChance > 0 then
        local isMoving = player:isPlayerMoving()
        local isRunning = player:isRunning()
        local isSprinting = player:isSprinting()
        local isWalking = isMoving and not isRunning and not isSprinting
        local isSneaking = player:isSneaking() and not isSprinting -- Bug if sneaking then start sprinting so do this.

        -- Trip chances from moodles only influence if they are visible.

        -- Trip more likely when panicking
        if panic > 5 then
            tripChance = tripChance + panic * panicTripChanceModifier
        end

        -- Trip more likely when stressed.
        local stress = stats:getStress()
        if stress > 0.25 then
            tripChance = tripChance + stress * 100 * stressTripChanceModifier -- Stress is 0 to 1 so need to multiply by 100
        end

        -- Trip likely when unhappy.
        local bodyDamage = player:getBodyDamage()
        local unhappyness = bodyDamage:getUnhappynessLevel()
        if unhappyness > 0.2 then
            tripChance = tripChance + unhappyness * unhappynessTripChanceModifier
        end

        -- Trip more likely when drunk.
        local drunkenness = stats:getDrunkenness()
        if drunkenness > 10 then
            tripChance = tripChance + drunkenness * drunkTripChanceModifier
        end

        -- Trip more likely when in pain.
        local pain = stats:getPain()
        if pain > 0 then
            tripChance = tripChance + pain * painTripChanceModifier
        end

        -- Trip more likely when clumsy.
        if player:HasTrait("Clumsy2") or player:HasTrait("Clumsy") then
            tripChance = tripChance + clumsyTripChanceModifier -- This makes a BIG difference, from going to not tripping on things at all to occasionally.
        end

        -- Trip much more likely in the dark.
        local playerSquareLightLevel = playerSquare:getLightLevel(player:getPlayerNum())
        if not player:HasTrait("NightVision2") then -- Why is it called nightvision2 in game???
                if playerSquareLightLevel < 0.4 then
                tripChance = tripChance + (100 * (1 - playerSquareLightLevel) * darkTripChanceModifier)
            end
        end

        -- If your on stairs you're more likely to trip
        -- This goes afterwards as a multiplier to make sure that it doesn't force trips on stairs that you can't avoid
        if playerSquare:HasStairs() then tripChance = tripChance * stairsTripChanceModifier end

        local didTrip = false

        if isWalking then
            if isSneaking then
                -- Very unlikely to trip sneak walking
                tripChance = tripChance + sneakingTripChanceModifier
                if chance(tripChance) then
                    didTrip = true
                    playTripSound(tripSound, playerSquare)
                    if chance(40) then
                        MarLibrary.fallOnKneesOrBack(player)
                    else
                        MarLibrary.bump(player)
                    end
                end
            else
                tripChance = tripChance + walkingTripChanceModifier
                if chance(tripChance) then
                    didTrip = true
                    playTripSound(tripSound, playerSquare)
                    if chance(tripChance) then
                        MarLibrary.fallOnKneesOrBack(player)
                    else
                        MarLibrary.bump(player)
                    end
                end
            end
        elseif isSprinting then
            tripChance = tripChance + sprintingTripChanceModifier
            if chance(tripChance) then
                didTrip = true
                playTripSound(tripSound, playerSquare)
                -- Trip more likely and harder on stairs.
                if playerSquare:HasStairs() then
                    local squareObjects = playerSquare:getObjects()
                    for i=0, squareObjects:size() -1, 1 do
                        object = squareObjects:get(i)
                        if (object:isStairsNorth() and MarLibrary.getCorrectPlayerMoveIsoDir(player) == IsoDirections.S) or (object:isStairsWest() and MarLibrary.getCorrectPlayerMoveIsoDir(player) == IsoDirections.E) then
                            if chance(tripChance) then
                                MarLibrary.tripRollIntense(player)
                                return
                            else
                                MarLibrary.trip(player)
                                return
                            end
                        end
                    end
                end
                if chance(tripChance) then
                    MarLibrary.trip(player)
                else
                    MarLibrary.bump(player)
                end
            end
        elseif isRunning then
            if isSneaking then
                tripChance = tripChance + sneakRunningTripChanceModifier
                if chance(tripChance) then
                    didTrip = true
                    playTripSound(tripSound, playerSquare)
                    if chance(40) then
                        MarLibrary.fallOnKneesOrBack(player)
                    else
                        MarLibrary.bump(player)
                    end
                end
            else
                tripChance = tripChance + runningTripChanceModifier
                if chance(tripChance) then
                    didTrip = true
                    playTripSound(tripSound, playerSquare)
                    if chance(tripChance) then --get knocked down
                        MarLibrary.trip(player)
                    else
                        MarLibrary.bump(player)
                    end
                end
            end
        end

        if didTrip then
            inattentiveResetTripCooldown()
        end
    end
end

MarLibrary.Events.OnPlayerMoveSquare:Add("inattentiveUpdate", inattentiveUpdate)