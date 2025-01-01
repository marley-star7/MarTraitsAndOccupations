require('luautils')
require("MarLibrary")

MarTraits = MarTraits or {}

MarTraits.inattentiveTrippableFloorOverlaySprites = {
    blends_streetoverlays_01 = {80, "TripOverObstacle"}, -- Large cracks in the ground
}

MarTraits.inattentiveExcludedTrippableFloorOverlaySprites = {

}

local string tripSoundCurb = ""
MarTraits.inattentiveTrippableFloorCurbSprites = {
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
MarTraits.inattentiveTrippableObjectSprites = {
    -- Those car parking lot things
    street_decoration_01_45 = {100, "TripOverObstacle"},
    street_decoration_01_44 = {100, "TripOverObstacle"},
    street_decoration_01_43 = {100, "TripOverObstacle"},

    street_decoration_01_37 = {100, "TripOverObstacle"},
    street_decoration_01_36 = {100, "TripOverObstacle"},
    street_decoration_01_35 = {100, "TripOverObstacle"},
    -- NE
    street_decoration_01_34 = {100, "TripOverObstacle"},
    street_decoration_01_33 = {100, "TripOverObstacle"},
    street_decoration_01_32 = {100, "TripOverObstacle"},

    street_decoration_01 = {100, "TripOverObstacle"},

    trash_01_53 = {25, "GarbageKick"}, -- Regular Trash
    trash_01_52 = {36, "GarbageKick"}, -- Regular Junk
    trash_01_50 = {35, "GarbageKick"}, -- Newspaper and Trash
    trash_01_50 = {35, "GarbageKick"}, -- Newspaper and Trash
    trash_01_48 = {50, "GarbageKick"}, -- Trash Bags
    trash_01_42 = {35, "GarbageKick"}, -- Trash
    trash_01_41 = {50, "GarbageKick"}, -- Trash Bags
    trash_01_40 = {50, "GarbageKick"}, -- Trash Bags
    trash_01_19 = {50, "GarbageKick"},
    trash_01_17 = {50, "GarbageKick"},
    trash_01_8 = {10, "CanKick1"}, -- Small Can
    trash_01_5 = {10, "CanKick1"}, -- Small Can
    trash_01_0 = {10, "CanKick1"}, -- Small Can
    d_trash_1_18 = {25, "GarbageKick"}, -- Boxes and Bags
    d_trash_1_1 = {15, "GarbageKick"},
    -- GENERIC
    trash_01 = {40, "GarbageKick"},
    d_trash_1 = {50, "TripOverObstacle"},
    d_generic_1 = {10, "TripOverObstacle"},
}

MarTraits.inattentiveExcludedTrippableObjectSprites = {
    "d_generic_1_0",
    "d_generic_1_1",
    "d_generic_1_2",
    "d_generic_1_7",
    "d_generic_1_22",
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

local function getTrippableData(potentialTrippableName, trippableList, excludedTrippableList)
    for trippableName, trippableData in pairs(trippableList) do
        if luautils.stringStarts(potentialTrippableName, tostring(trippableName)) then
            for _, excludedTrippableName in pairs(excludedTrippableList) do
                if luautils.stringStarts(potentialTrippableName, tostring(excludedTrippableName)) then
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
                local specificTrippableData = getTrippableData(spriteName, MarTraits.inattentiveTrippableObjectSprites, MarTraits.inattentiveExcludedTrippableObjectSprites)
                if specificTrippableData then
                    return specificTrippableData
                end
            end
        end
    end
    return nil
end

local getSquareTrippableFloorSpriteData = function(square)
    squareFloor = square:getFloor()
    attachedSprites = squareFloor:getAttachedAnimSprite()
    if attachedSprites then
        for num = attachedSprites:size(), 1, -1 do
            local sprite = attachedSprites:get(num - 1)
            if sprite:getParentSprite():getName() then -- If the sprite has a name, if it doesn't it doesn't exist.
                local spriteName = sprite:getParentSprite():getName()

                -- Prioritize sprites with specific data associated over the generic.
                local specificTrippableData = getTrippableData(spriteName, MarTraits.inattentiveTrippableFloorOverlaySprites, MarTraits.inattentiveExcludedTrippableFloorOverlaySprites)
                if specificTrippableData then
                    return specificTrippableData
                end
            end
        end
    end
    return
end

local getSquareTrippableFloorCurbSpriteData = function(square)
    squareFloor = square:getFloor()
    attachedSprites = squareFloor:getAttachedAnimSprite()
    if attachedSprites then
        for num = attachedSprites:size(), 1, -1 do
            local sprite = attachedSprites:get(num - 1)
            if sprite:getParentSprite():getName() then
                local spriteName = sprite:getParentSprite():getName()
                print(spriteName)
                for trippableCurbSpriteName, trippableCurbSpriteData in pairs(MarTraits.inattentiveTrippableFloorCurbSprites) do
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

MarTraits.inattentiveCalcTripChance = function(tripChance)
    local playerSquare = player:getSquare()
    local stats = player:getStats()

    --== SET TRIP CHANCE ==--
    -- If your on stairs you're more likely to trip
    -- This goes afterwards as a multiplier to make sure that it doesn't force trips on stairs that you can't avoid
    if playerSquare:HasStairs() then tripChance = tripChance * 1.5 end

    --== SET TRIP COOLDOWN ==--
    local tripChanceCooldownModifier = 1
    -- Trip more often when clumsy.
    if player:HasTrait("Clumsy2") or player:HasTrait("Clumsy") then
        tripChanceCooldownModifier = tripChanceCooldownModifier + 1.5
    end
    -- Trip more often when drunk
    tripChanceCooldownModifier = tripChanceCooldownModifier + (1 + (stats:getDrunkenness()/100))

    squaresTillCanTrip = squareTripCooldown/tripChanceCooldownModifier
    --print(tripChance)
    return tripChance
end

-- TODO: Figure out how to share the player thing between some of these scripts, I have no idea how to properly do global stuff in lua so to be safe we doing this.
-- TODO: Make player much more likely to trip in the dark
local IsoPlayer player = nil
local IsoGridSquare playerSquareLast = nil
local int squareTripCooldown = 50
local int squaresTillCanTrip = 0
local float tripPanicModifier = 1.25
local int tripChanceNextSquare = 0

MarTraits.inattentiveUpdate = function(_player, playerSquare)
    player = _player
    if not player:HasTrait("inattentive") then return end
    if not playerSquare:getFloor() then return end
    -- Hasn't moved far enough from last trip RETURN
    playerSquareLast = playerSquare
    local stats = player:getStats()
    local panic = stats:getPanic()
    if squaresTillCanTrip > 0 then
        squaresTillCanTrip = squaresTillCanTrip - 1
        if squaresTillCanTrip > panic * tripPanicModifier then -- Trip more frequently when panicking
            return
        end
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
        squareCurbDir = squareCurbData[1]
        if MarLibrary.getCorrectPlayerMoveIsoDir(player) == squareCurbDir then
            squareCurbNotAligned = squareCurbData[2]
            if squareCurbNotAligned then
                tripChanceNextSquare = tripChanceNextSquare + 80
            else
                tripChance = tripChance + 80
                tripSound = "TripOverObstacle"
            end
        end
        lastSquareCurbData = squareCurbData
    end
    --== CHECKING FOR ITEMS ==--
    -- Apparently cant use for each loops with Array lists from java, so we do this instead
    playerSquareWorldObjects = playerSquare:getWorldObjects()
    for i = 0, playerSquareWorldObjects:size() -1, 1 do
        local object = playerSquareWorldObjects:get(i)
        local item = object:getItem()
        tripChance = tripChance + item:getWeight() * 5
        tripSound = item:getPlaceOneSound()
    end
    --== CHECKING FOR CORPSES ==--
    zombieDeadCount = playerSquare:getDeadBodys():size()
    tripChance = tripChance + (zombieDeadCount * 10)
    --== CHECKING FOR VISUAL OBJECTS ==--
    -- Ex: (Trash, Twigs, Misc)
    local trippableObjectSpriteData = getSquareTrippableObjectSpriteChance(playerSquare)
    if trippableObjectSpriteData then
        tripChance = tripChance + trippableObjectSpriteData[1]
        tripSound = trippableObjectSpriteData[2]
    end
    --== CHECKING FOR ZOMBIES ON GROUND ==--
    -- Disabled, doesn't make sense
    --[[
    local squareObjects = playerSquare:getMovingObjects()
    zombieAliveCount = 0
    for i=0, squareObjects:size() -1, 1 do
        local obj = squareObjects:get(i)
        if instanceof(obj, 'IsoZombie') and obj:isOnFloor() then
            tripChance = tripChance + 20
        end
    end
    ]]--

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

        -- Trip more often if there is a chance to trip and your drunk.
        local drunkenness = stats:getDrunkenness()
        if drunkenness >= 10 then
            tripChance = tripChance + drunkenness/1.5
        end

        if player:HasTrait("Clumsy2") or player:HasTrait("Clumsy") then
            tripChance = tripChance + 10 -- This makes a BIG difference, from going to not tripping on things at all to occasionally.
        end

        if player:HasTrait("Lucky") then
            tripChance = tripChance - 2
        elseif player:HasTrait("Unlucky") then
            tripChance = tripChance + 2
        end

        local playerSquareLightLevel = playerSquare:getLightLevel(player:getPlayerNum())
        if not player:HasTrait("NightVision2") then -- Why is it called nightvision2 in game???
                if playerSquareLightLevel < .4 then
                tripChance = tripChance * (1 + .4 - playerSquareLightLevel)
            end
        end

        if isWalking then
            if isSneaking then
                tripChance = tripChance - 200
                tripChance = MarTraits.inattentiveCalcTripChance(tripChance)
                if MarLibrary.chance(tripChance) then
                    playTripSound(tripSound, playerSquare)
                    if MarLibrary.chance(40) then
                        MarLibrary.fallOnKneesOrBack(player)
                    else
                        MarLibrary.bump(player)
                    end
                end
            else
                tripChance = tripChance - 80
                tripChance = MarTraits.inattentiveCalcTripChance(tripChance)
                if MarLibrary.chance(tripChance) then
                    playTripSound(tripSound, playerSquare)
                    if MarLibrary.chance(tripChance) then
                        MarLibrary.fallOnKneesOrBack(player)
                    else
                        MarLibrary.bump(player)
                    end
                end
            end
        elseif isSprinting then
            tripChance = tripChance + 20
            tripChance = MarTraits.inattentiveCalcTripChance(tripChance)
            if MarLibrary.chance(tripChance) then
                playTripSound(tripSound, playerSquare)
                -- Trip more likely and harder on stairs.
                if playerSquare:HasStairs() then
                    squareObjects = playerSquare:getObjects()
                    for i=0, squareObjects:size() -1, 1 do
                        object = squareObjects:get(i)
                        if (object:isStairsNorth() and MarLibrary.getCorrectPlayerMoveIsoDir(player) == IsoDirections.S) or (object:isStairsWest() and MarLibrary.getCorrectPlayerMoveIsoDir(player) == IsoDirections.E) then
                            if MarLibrary.chance(tripChance) then
                                MarLibrary.tripRollIntense(player)
                                return
                            else
                                MarLibrary.trip(player)
                                return
                            end
                        end
                    end
                end
                if MarLibrary.chance(tripChance) then
                    MarLibrary.trip(player)
                else
                    MarLibrary.bump(player)
                end
            end
        elseif isRunning then
            if isSneaking then
                tripChance = tripChance - 60
                tripChance = MarTraits.inattentiveCalcTripChance(tripChance)
                if MarLibrary.chance(tripChance) then
                    playTripSound(tripSound, playerSquare)
                    if MarLibrary.chance(40) then
                        MarLibrary.fallOnKneesOrBack(player)
                    else
                        MarLibrary.bump(player)
                    end
                end
            else
                tripChance = tripChance - 20
                tripChance = MarTraits.inattentiveCalcTripChance(tripChance)
                if MarLibrary.chance(tripChance) then
                    playTripSound(tripSound, playerSquare)
                    if MarLibrary.chance(tripChance) then --get knocked down
                        MarLibrary.trip(player)
                    else
                        MarLibrary.bump(player)
                    end
                end
            end
        end
    end
end

MarEvents.OnPlayerMoveSquare:Add("MarTraits.inattentiveUpdate", MarTraits.inattentiveUpdate)