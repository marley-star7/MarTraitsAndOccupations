if getActivatedMods():contains("MoodleFramework") == true then
    require("MF_ISMoodle")
end

MarTraits = MarTraits or {}

local float boredomAngerInfluence = .01
local float painAngerInfluence = 10
local float unhappynessPositiveAngerInfluence = .0001
local float unhappynessNegativeAngerInfluence = .0001
local float stressAngerModifier = 1.5
local float unhappynessAngerModifier = 1.2
local float drunkennessAngerModifier = 2

local anger = 0
local int secondsTillUpdate = 0
-- the fact I have to do this makes me AGHHHHHHHHHHHHHHHHHHHHHHHHHH
MarTraits.angryUpdate = function(player)
    if not player:HasTrait("angry") then return end

    local stats = player:getStats()
    local bodyDamage = player:getBodyDamage()
    local delta = getGameTime():getTimeDelta()

    local moodleAnger = MF.getMoodle("Anger")
    local pain = stats:getPain()/100 -- Pain is 0 to 100 value so we divide it to align with anger
    local boredom = bodyDamage:getBoredomLevel()/100 -- Boredom is 0 to 100 value so we divide it
    local stress = stats:getStress() -- Stress is 0 to 1 value
    local unhappyness = bodyDamage:getUnhappynessLevel()/100 -- Unhappyness is 0 to 100 value so we divide it

    -- Anger grows with pain
    anger = anger + (painAngerInfluence * pain * delta)
    -- Anger grows with boredom
    anger = anger + (boredomAngerInfluence * boredom * delta)
    -- Anger grows slighlty with unhappyness, but shrinks when losing unhappyness
    -- cannot naturally lose anger when too unhappy
    if (unhappyness > 20) then
        --anger = anger + (unhappynessNegativeAngerInfluence * unhappyness * delta)
        --anger = anger + (.01 * unhappyness/100 * delta)
    else
        anger = anger - unhappynessPositiveAngerInfluence * delta
    end
    -- anger gained is more when unhappy
    anger = anger * (1 + (unhappyness))
    -- anger gained is more when stressed
    anger = anger * (1 + (stress * stressAngerModifier))
    -- anger gained is more when drunk
    anger = anger * (1 + ((stats:getDrunkenness()/100) * drunkennessAngerModifier)) -- Drunkenness is 0 to 100 so we divide it

    -- TODO: Figure out how to make anger moodle be 0 to 1 instead of 0 to -1
    -- We have to set it do this because of how Moodle Framework works.
    --print(anger)
    anger = .5 - anger/2
    anger = PZMath.clampFloat(anger, 0, .5)
    moodleAnger:setValue(moodleAnger:getValue() + anger)
    anger = 0
end

-- TODO: Add more events for getting damaged here to cause anger
-- TODO: Add more event for when gun jams
-- TODO: Add more event for when window lock breaks
-- TODO: Add more event for when trying to open locked door
MarTraits.angryOnPlayerGetDamage = function(_player, damageType, damage)
    player = _player
    if damageType == "CARCRASHDAMAGE" then
        -- You just crashed the car your gonna be mad
        anger = anger + damage/100
    end
end

if getActivatedMods():contains("MoodleFramework") == true then
    Events.OnPlayerUpdate.Add(MarTraits.angryUpdate)
    Events.OnPlayerGetDamage.Add(MarTraits.angryOnPlayerGetDamage)
end
