--[[
require('NPCs/MainCreationMethods');

local float fearHeightPanic = 0;
local float fearHeightStress = 0;
local boolean supriseSoundPlayed = false

function FearHeightUpdate(player)
    if not player:HasTrait("fearheight") then return end

    local stats = player:getStats();
    local stress = stats:getStress();
    local panic = stats:getPanic();
    playerSquare = player:getSquare()
    local height = playerSquare:getZ();

    if player:isbFalling() then
        -- Make your panic go crazy
        -- TODO: Add the going to land really bad fall thing forced
        fearHeightPanicDest = 100
    end


    local int distance = 1;
    local fearHeightPanicLastAdded = 0;
    local fearHeightPanicLastAdded = fearHeightPanic;
    local fearHeightPanicDest = 0;
    local squareChecking
    for i = 0, 3, 1 do
        squareChecking = playerSquare:getAdjacentSquare(IsoDirections.fromAngle(player:getLastAngle()))
        if squareChecking then
            if not squareChecking:isSolidFloor() then
                -- If you can't see it you aren't panicking
                if squareChecking:CalculateVisionBlocked(playerSquare) then break end
                cell = squareChecking:getCell()
                for heightFromBottom = squareChecking:getZ(), 0, -1 do
                    possibleBottom = cell:getGridSquare(squareChecking:getX(), squareChecking:getY(), squareChecking:getZ() - heightFromBottom)
                    if possibleBottom:isSolidFloor() and not possibleBottom:HasStairs() then
                        fearHeightPanicDest = heightFromBottom * 20;
                        break
                    end
                end
            end
        end
    end
    fearHeightPanic = PZMath.lerp(fearHeightPanic, fearHeightPanicDest, 0.05); -- Will lerp to zero if no destination set this frame.
    stats:setPanic(panic + fearHeightPanic - fearHeightPanicLastAdded);

    --== Stress Calculation ==--
    -- Currently stress progressively goes down after being set which... I don't want.
    -- Find a fix before release.
    -- TODO: Add window no animation for when vaulting a fence too high
    local int fearHeightStressLastAdded = fearHeightStress;
    if height >= 1 then
        fearHeightStress = height/4;
        if player:getVariableBoolean("ClimbWindowStarted") then
            print(stats:getNumChasingZombies())
            squareVaultingTo = playerSquare:getAdjacentSquare(IsoDirections.fromAngle(player:getLastAngle()))
            if squareVaultingTo and squareVaultingTo:isSolidFloor() then
                -- Just vault it lol
            elseif (stats:getNumChasingZombies() > 2 and height <= 4) or stats:getNumVeryCloseZombies() >= 1 then
                stats:setPanic(100);
                print("YESSSSSSSSSSSSS")
                --player:setVariable("ClimbWindowOutcome", "back")
            else
                if height >= 2 then
                    -- Your guy freaks out at the sheer height
                    player:setVariable("ClimbWindowOutcome", "fallback")
                    stats:setPanic(panic + 75);
                    if not supriseSoundPlayed then
                        getSoundManager():PlaySound("ZombieSurprisedPlayer", false, 0):setVolume(1);
                        supriseSoundPlayed = true
                    end
                else
                    stats:setPanic(panic + 50);
                    player:setVariable("ClimbWindowOutcome", "back") -- Your guy just does a quick.. nah not gonna happen
                end
            end
        else
            print("rui")
            supriseSoundPlayed = false
            if player:isbFalling() then
                player:setVariable("bHardFall", true)
            end
        end
    else
        fearHeightStress = 0;
    end
    stats:setStress(stress + fearHeightStress - fearHeightStressLastAdded)
end

-- Old panic calc method
--== WARNING WAS VERRRRYYY LAGGY ==--
-- Checks in a 3x3 grid around the player if there is no floor.
-- I'm sorry this looks ugly but did you know Lua has NO CONTINUE FOR LOOPS???
for y = -distance, distance, 1 do
    for x = -distance, distance, 1 do
        if x ~= y then
            local square = getCell():getGridSquare(player:getX() + x, player:getY() + y, player:getZ())
            if (square:isSolidFloor() == false) then
                fearHeightPanicDest = height * 20;
            end
        end
    end
end
]]--