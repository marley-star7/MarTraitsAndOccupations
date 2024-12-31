local depressiveUnhappynessIncreaseEveryOneMinute = 0.03
local depressiveUnhappynessExponentialGrowthMultiplier = 4

local function TraitDepressiveEveryOneMinute()
    local player = getPlayer()
    if not player:HasTrait("Mar_Depressive") then return end
    -- "DepressEffect" Despite the name is actually the current effect of antidepressants so this way you won't suddenly become depressed when already on the pill.
    if player:getDepressEffect() ~= 0 then return end

    local bodyDamage = player:getBodyDamage()
    local playerModData = player:getModData()
    local currentUnhappynessLevel = bodyDamage:getUnhappynessLevel()
    local previousUnhappynessLevel = playerModData.fMarTraitsUnhappynessLevelLastDepressiveUpdate or 0
    local previousDepressiveUnhappyness = playerModData.fMarTraitsDepressiveUnhappyness or 0
    local changeInUnhappynessLevel = currentUnhappynessLevel - previousUnhappynessLevel

    -- Add the slow normal growth for depressive unhappyness.
    local depressiveUnhappynessAddedMinuteIncrease = depressiveUnhappynessIncreaseEveryOneMinute
    local newDepressiveUnhappyness = previousDepressiveUnhappyness + depressiveUnhappynessAddedMinuteIncrease
    local midUpdateChangeInUnhappynessLevel = changeInUnhappynessLevel + depressiveUnhappynessAddedMinuteIncrease
    -- Add the exponential change in growth depending on how high sadness is, includes the unhappyness added this frame as well.
    if midUpdateChangeInUnhappynessLevel >= 0 then
        local exponentialDepressiveUnhappynessToAdd = midUpdateChangeInUnhappynessLevel * currentUnhappynessLevel/100 * depressiveUnhappynessExponentialGrowthMultiplier
        newDepressiveUnhappyness = newDepressiveUnhappyness + exponentialDepressiveUnhappynessToAdd
        print(exponentialDepressiveUnhappynessToAdd)
    end
    -- Add the new changed values to the total unhappyness.
    local changeInDepressiveHappyness = newDepressiveUnhappyness - previousDepressiveUnhappyness
    
    local newUnhappynessLevel = currentUnhappynessLevel + changeInDepressiveHappyness
    bodyDamage:setUnhappynessLevel(newUnhappynessLevel)
    -- Save them for next check, have to use "getUnhappynessLevel" for proper value to be set.
    playerModData.fMarTraitsUnhappynessLevelLastDepressiveUpdate = bodyDamage:getUnhappynessLevel()
    playerModData.fMarTraitsDepressiveUnhappyness = newDepressiveUnhappyness
end

Events.EveryOneMinute.Add(TraitDepressiveEveryOneMinute)