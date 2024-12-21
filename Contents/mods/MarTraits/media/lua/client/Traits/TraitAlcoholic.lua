MarTraits = MarTraits or {}

-- TODO: This trait is very barebones functionality wise currently, sorry bout that.
local alcoholDrinkStrength = 3
MarTraits.drinkAlcohol = function(player, item)
    local playerModData = player:getModData()
    local stats = player:getStats()
    local stress = stats:getStress()

    playerModData.marMinutesSinceLastDrink = 0

    if playerModData.marAlcoholDesire == nil then
        playerModData.marAlcoholDesire = 0
    end

    local abstinenceMultiplier = 1
    if playerModData.marMinutesSinceLastDrink >= 10080 then -- A week
        abstinenceMultiplier = 3
    end

    -- Alcohol desire directly coordinates to how drunk you get, so you can remove all your desire by getting plastered once in a blue moon, or drink casually often.
    -- Alcohol desire internally can also go into the negative, so you don't gain stress if you've drank alot recently.
    playerModData.marMinutesSinceLastDrink = 0
    playerModData.marAlcoholDesire = playerModData.marAlcoholDesire - (stats:getDrunkenness()/100 * 2 * abstinenceMultiplier)
    stats:setStress(stress - PZMath.clampFloat(stats:getDrunkenness()/100 * alcoholDrinkStrength, 0, stress)) -- So you can't set stress into negative
end

local timeTillQuit = 87600 -- Two months
local alcoholIncreaseEveryMin = .004

local function TraitAlchoholicEveryOneMinute()
    local player = getPlayer()
    if not player:HasTrait("Alcoholic") then return end
    local stats = player:getStats()
    local stress = stats:getStress() -- Stress is 0 to 1 value
    if prevStress == -999 then
        prevStress = stress
    end

    local modData = player:getModData()
    local prevAlcoholDesire = modData.marAlcoholDesire

    local abstinenceMultiplier = modData.marMinutesSinceLastDrink/timeTillQuit
    -- Your desire for alcohol will naturally flare up and down and max desire less strong as time goes once
    if modData.marAlcoholDesire >= 1 - (abstinenceMultiplier * 1) and modData.marAlcoholDesireRising then
    modData.marAlcoholDesireRising = false
    elseif modData.marAlcoholDesire <= 0 and not modData.marAlcoholDesireRising then
    modData.marAlcoholDesireRising = true
    end

    -- Alcohol desire rises faster than goes away
    if modData.marAlcoholDesireRising then
    modData.marAlcoholDesire = modData.marAlcoholDesire + alcoholIncreaseEveryMin - (abstinenceMultiplier * alcoholIncreaseEveryMin)
    else
    modData.marAlcoholDesire = modData.marAlcoholDesire + alcoholIncreaseEveryMin/2 + (abstinenceMultiplier * alcoholIncreaseEveryMin/2)
    end

    if stress <= .8 then
        stats:setStress(stress - PZMath.clampFloat(prevAlcoholDesire, 0, 100) + PZMath.clampFloat(modData.marAlcoholDesire, 0, 100))
    end
    modData.marMinutesSinceLastDrink = modData.marMinutesSinceLastDrink + 1
end

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
Events.EveryOneMinute.Add(TraitAlchoholicEveryOneMinute)
