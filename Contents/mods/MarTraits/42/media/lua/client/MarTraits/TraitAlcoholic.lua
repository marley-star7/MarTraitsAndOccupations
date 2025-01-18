MarTraits = MarTraits or {}

local alcoholDrinkStrength = 3
local maxAlcoholDesire = 100
local minAlcoholDesire = -100

MarTraits.drinkAlcohol = function(player, item)
    print(item:getAlcoholPower())
    print("Alcohol Drunk!")
    local playerModData = player:getModData()
    local stats = player:getStats()
    local stress = stats:getStress()

    playerModData.iMarTraitsMinutesSinceLastDrink = 0

    if playerModData.fMarTraitsAlcoholDesire == nil then
        playerModData.fMarTraitsAlcoholDesire = 0
    end

    -- A small drink makes you feel alot better after drinking getting rid of da stress.
    local abstinenceMultiplier = 1
    if playerModData.iMarTraitsMinutesSinceLastDrink >= 10080 then -- A week
        abstinenceMultiplier = 3
    end

    -- Alcohol desire directly coordinates to how drunk you get, so you can remove all your desire by getting plastered once in a blue moon, or drink casually often.
    -- Alcohol desire internally can also go into the negative, so you don't gain stress if you've drank alot recently.
    playerModData.iMarTraitsMinutesSinceLastDrink = 0
    local newAlcoholDesire = playerModData.fMarTraitsAlcoholDesire - (stats:getDrunkenness() * abstinenceMultiplier)
    newAlcoholDesire = PZMath.clamp(newAlcoholDesire, minAlcoholDesire, maxAlcoholDesire)
    -- Alcohol desire cannot go below enough to go above full drunkeness.
    playerModData.fMarTraitsAlcoholDesire = newAlcoholDesire
    playerModData.bMarTraitsAlcoholDesireRising = true -- Alcohol desire rising immediately set true on drink.
    stats:setStress(stress - PZMath.clampFloat(stats:getDrunkenness()/100 * alcoholDrinkStrength, 0, stress)) -- So you can't set stress into negative
end

local timeTillQuit = 87600 -- Two months
local alcoholDesireIncreaseRate = 0.04
local alcoholDesireDecreaseRate = -0.02 -- Goes down slower than up.
local stressIncreaseRate = 0.05

local function traitAlchoholicEveryOneMinute()
    local player = getPlayer()
    if not player:HasTrait("Mar_Alcoholic") then return end

    local playerModData = player:getModData()
    local stats = player:getStats()
    local currentStress = stats:getStress() -- Stress is 0 to 1 value
    --local prevStress = playerModData.fMarTraitsStressLastAlcoholicUpdate or 0

    local abstinenceMultiplier = 1 - ((playerModData.iMarTraitsMinutesSinceLastDrink or 0)/timeTillQuit)

    local currentAlcoholDesire = playerModData.fMarTraitsAlcoholDesire or 0
    local alcoholDesireRising = (playerModData.bMarTraitsAlcoholDesireRising or true)

    -- Your desire for alcohol will naturally flare up and down and max desire less strong as time goes once
    if currentAlcoholDesire >= maxAlcoholDesire - (abstinenceMultiplier * 1) and alcoholDesireRising then
        playerModData.bMarTraitsAlcoholDesireRising = false
    elseif currentAlcoholDesire <= minAlcoholDesire and alcoholDesireRising == false then
        playerModData.bMarTraitsAlcoholDesireRising = true
    end

    -- Alcohol desire rises faster than goes away, and rises slower with greater abstinence.
    if playerModData.bMarTraitsAlcoholDesireRising then
        playerModData.fMarTraitsAlcoholDesire = (playerModData.fMarTraitsAlcoholDesire or 0) + alcoholDesireIncreaseRate + (abstinenceMultiplier * alcoholDesireIncreaseRate)
    else
        playerModData.fMarTraitsAlcoholDesire = (playerModData.fMarTraitsAlcoholDesire or 0) + alcoholDesireDecreaseRate
    end

    local alcoholStressToAdd = 0
    -- Will not add if below zero.
    if playerModData.fMarTraitsAlcoholDesire >= 0 then
        alcoholStressToAdd = stressIncreaseRate * playerModData.fMarTraitsAlcoholDesire/maxAlcoholDesire
    end

    -- Add the new changed values to the total stress.
    stats:setStress(currentStress + alcoholStressToAdd)
    print("Alcohol Desire = " .. playerModData.fMarTraitsAlcoholDesire)
    print(playerModData.bMarTraitsAlcoholDesireRising)
    -- Update the stuff for next time updates.
    playerModData.iMarTraitsMinutesSinceLastDrink = (playerModData.iMarTraitsMinutesSinceLastDrink or 0) + 1
    --playerModData.fMarTraitsStressLastAlcoholicUpdate = stats:getStress()
end

Events.EveryOneMinute.Add(traitAlchoholicEveryOneMinute)

-- TODO: this initialize thing find out if more performant than using "or 0" in normal gameplay.
--[[
local function traitAlchoholInitialize(player)
    player = getPlayer()
    local modData = player:getModData()

    if modData.marMinutesSinceLastDrink == nil then
        modData.marMinutesSinceLastDrink = 0
    end
    if modData.marAlcoholDesire == nil then
        modData.marAlcoholDesire = 0
    end
    if modData.marAlcoholDesireRising == nil then
        modData.marAlcoholDesireRising = true
    end
    if modData.marAlcoholStress == nil then
        modData.marAlcoholStress = 0
    end
end

Events.OnCreatePlayer.Add(traitAlchoholInitialize)
]]--
