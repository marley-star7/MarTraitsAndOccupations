-- TODO: I'd like to make this a bit more complex, like make the player be more sad depending on other stuff but this is good for now.
-- TODO: Also check if this is dependent on time
local function TraitDepressiveEveryHours()
    player = getPlayer()
    if not player:HasTrait("Depressive") then return end

    -- "DepressEffect" Despite the name is actually the current effect of antidepressants so this way you won't suddenly become depressed when already on the pill.
    if player:getDepressEffect() == 0 then
        local depressionChance = 2 -- You will experience 30 Sadness on average every real life hour.
        if player:HasTrait("Lucky") then
            depressionChance = depressionChance - 1
        end
        if player:HasTrait("Unlucky") then
            depressionChance = depressionChance + 1
        end
        if ZombRand(100) <= depressionChance then
            bodyDamage = player:getBodyDamage()
            unhappyness = bodyDamage:getUnhappynessLevel()

            -- 25 is the amount to make your character slightly depressed
            bodyDamage:setUnhappynessLevel((unhappyness + (25 * (1 + unhappyness/100)))) -- The sadness gets worse dependent on how sad you already are.
        end
    end
end

Events.EveryHours.Add(TraitDepressiveEveryHours)

-- Removed functionality cuz idk what I was thinkin.
--[[
local function TraitDepressiveOnPlayerGetDamage(player, damageType, damage)
    if player:HasTrait("Depressive") then
        bodyDamage = player:getBodyDamage()
        unhappyness = bodyDamage:getUnhappynessLevel()
        if damageType == "BLEEDING" then
            bodyDamage:setUnhappynessLevel(unhappyness + damage * 2)
        end
        else if damageType == "" then

        end
    end
end
Events.OnPlayerGetDamage.Add(TraitDepressiveOnPlayerGetDamage)
]]--