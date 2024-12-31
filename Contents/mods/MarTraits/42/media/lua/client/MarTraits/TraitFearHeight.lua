require("MarLibrary.lua")

local fearHeightPanicReachSpeed = 1.5 -- Any lower it kinda breaks.
local squaresAheadForHeightCheck = 3;
local seenDropHeightPanicMultiplier = 35
local fallChanceClimbingRope = 0.05

local height = 0
local attemptedVaultsUntilSucceed = 0
local isFirstFrameOfVault = false

local function fearHeightUpdate(player)
    if not player:HasTrait("Mar_Acrophobic") then return end

    local playerSquare = player:getSquare()
    if not (height == playerSquare:getZ()) then
        height = playerSquare:getZ()
        -- Always takes at least 2 tries of hyping up before a high jump
        attemptedVaultsUntilSucceed = PZMath.clamp(height, 0, 2)
    end

	local playerModData = player:getModData()

    -------------------------
    -- FALLING CALCULATION --
    -------------------------

    local fearHeightPanicDest = 0;

    -- If you are falling, panic goes CRAZY, purely for thematics.
    if player:isbFalling() then
        -- notably this overrides above check for heights, since falling instantly sets it really high.
        -- TODO: Add the going to land really bad fall thing forced
        -- TODO: add the sloppy landings.
        fearHeightPanicDest = 100
        --player:setVariable("bHardFall", true)
        -- Don't need rest of stuff if falling.
        return
    end

    ---------------------------
    --SHEET FALL CALCULATION --
    ---------------------------

    local stats = player:getStats();
    local panicBeforeCalc = stats:getPanic();

    local delta = getGameTime():getTimeDelta() -- So it doesn't change with frame rate.
    if (player:getCurrentState() == ClimbSheetRopeState:instance()) or (player:getCurrentState() == ClimbDownSheetRopeState:instance()) then
        -- Calculate the chance of falling based on various factors (fall chance, panic, and delta)
        -- Twice as more likely to fall if full panic.
        local panicFailChanceInfluence = 1 + (panicBeforeCalc/100)
        local fallThreshold = fallChanceClimbingRope * panicFailChanceInfluence * delta
        local rand = ZombRandFloat(0, 1)  -- Random value between 0 and 1
        
        -- If the random value is less than or equal to the calculated fall chance, the player falls
        if rand <= fallThreshold then
            player:fallFromRope()
        end
    end

    -----------------------------
    -- WINDOW CLIMB CALCUAITON --
    -----------------------------

    if height >= 1 then
        -- Base panic 
        fearHeightPanicDest = height * 5;
        -- Checks for climbing windows.
        if player:getVariableBoolean("ClimbWindowStarted") then

            if isFirstFrameOfVault then
                -- Add some panic for how high the vault is 
                stats:setPanic(50 * height);
                local squareVaultingTo = playerSquare:getAdjacentSquare(IsoDirections.fromAngle(player:getLastAngle()))

                if squareVaultingTo and squareVaultingTo:isSolidFloor() then
                -- Just vault it lol, you'll be safe
                elseif height >= 2 and attemptedVaultsUntilSucceed >= 2 then
                        -- Your guy freaks out at the sheer height, and refuses.
                        player:setVariable("ClimbWindowOutcome", "fallback")
                        -- Only play the sound once on first frame
                        player:getEmitter():playSound("ZombieSurprisedPlayer")
                elseif height >= 1 and attemptedVaultsUntilSucceed >= 1 and stats:getNumVeryCloseZombies() == 0 then
                    -- Your guy just does a quick.. nah not gonna happen, except if there is zombies chasing, in that case it seems weird...
                    player:setVariable("ClimbWindowOutcome", "back")
                    -- Play a disgruntled hurt sound on the back down for thematics.
                    MarLibrary.delayFuncByDelta(function() player:playHurtSound() end, 2.3)
                end
            end

            -- Record the attempted vault
            if isFirstFrameOfVault then
                attemptedVaultsUntilSucceed = attemptedVaultsUntilSucceed - 1
            end

            if isFirstFrameOfVault then
                isFirstFrameOfVault = false
            end
        else -- We aren't vaulting currently, reset this.
            isFirstFrameOfVault = true
        end
    end

    local panicLast = playerModData.fMarTraitsFearHeightPanicLastUpdate or 0;

    ---------------------------
    -- SEE HEIGHT CACULATION --
    ---------------------------

    -- Checks for squares in front, looking for heights to panic about.
    local squareChecking = playerSquare
    local greatestHeightFound = 0
    local playerAngleIsoDirection = IsoDirections.fromAngle(player:getLastAngle())
    for squaresAway = 1, squaresAheadForHeightCheck do
        -- Edge case scenario if square checking is nil.
        if squareChecking then
            squareChecking = squareChecking:getAdjacentSquare(playerAngleIsoDirection)
            -- If new square is also nil, skip past its check.
            if squareChecking and not squareChecking:isSolidFloor() then
                -- If you can't see it you aren't panicking about it duh.
                if not squareChecking:getCanSee(player:getPlayerNum()) then 
                    break 
                end

                --if isoGridSquareCalculateVisionBlockedWindowFix(playerSquare, squareChecking) then break end

                local cell = squareChecking:getCell()
                -- Loop down to find where ground floor is at.
                for heightFromBottom = squareChecking:getZ(), 0, -1 do
                    -- Only do the fear stuff for the greatest height drop found, to make sure it's not overriden by a platfrom in front of a big drop.
                    if heightFromBottom > greatestHeightFound then
                        greatestHeightFound = heightFromBottom

                        local possibleBottom = cell:getGridSquare(squareChecking:getX(), squareChecking:getY(), squareChecking:getZ() - heightFromBottom)
                        if possibleBottom:isSolidFloor() and not possibleBottom:HasStairs() then
                            -- Closer you are to that big drop, more panic you get.
                            -- We clamp it to be based of closeness as well, so you don't shoot to 100 instantly when 3 blocks away from a window in a skycraper, keeps the realism.
                            -- panic grows expoentially the closer you are.
                            local squaresCloseToDrop = squaresAheadForHeightCheck + 1 - squaresAway
                            local panicFromSeenHeight = PZMath.clamp(((heightFromBottom * seenDropHeightPanicMultiplier)/(squaresAway)), 0, (squaresCloseToDrop^2) * 15)
                            fearHeightPanicDest = fearHeightPanicDest + panicFromSeenHeight
                            break
                        end
                    end
                    -- Helps with performance, no need to check so many levels if this high anyways, eventually panic from height gets so much it stops mattering anyways.
                    if heightFromBottom >= 6 then 
                        break 
                    end
                end
            end
        end
    end

    local newPanic = PZMath.lerp(stats:getPanic(), panicBeforeCalc - panicLast + fearHeightPanicDest, fearHeightPanicReachSpeed * delta) -- Will lerp to zero if no destination set this frame.
	stats:setPanic(newPanic)
	playerModData.fMarTraitsFearHeightPanicLastUpdate = newPanic
end

Events.OnPlayerUpdate.Add(fearHeightUpdate)