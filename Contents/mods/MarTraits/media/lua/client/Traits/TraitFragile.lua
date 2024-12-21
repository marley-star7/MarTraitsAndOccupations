local function TraitFragileUpdate(player)
    if not player:HasTrait("Fragile") then return end

    local delta = getGameTime():getTimeDelta()
    if not player:isAsleep() then
        local heavyLoadMoodleLevel = player:getMoodles():getMoodleLevel(MoodleType.HeavyLoad)
        if heavyLoadMoodleLevel >= 2 then
            if player:getBodyDamage():getOverallBodyHealth() >= 40 then
                for i = 0, player:getBodyDamage():getBodyParts():size() - 1 do
                    local b = player:getBodyDamage():getBodyParts():get(i)
                    b:AddDamage(0.075 * (heavyLoadMoodleLevel - 1) * delta)
                end
            end
        end
    end
    --[[
    local playerdata = player:getModData()
    local bodydamage = player:getBodyDamage()
    local health = bodydamage:getOverallBodyHealth()
    local multiplier = getGameTime():getMultiplier()
    if currenthp < lasthp and multiplier <= 4.0 then
        if playerdata.isSleeping == true and player:getBodyDamage():getBodyPart(BodyPartType.FromString("Neck")):getAdditionalPain() > 0 then
            playerdata.isSleeping = false
            playerdata.fLastHP = 0
            return
        else
            playerdata.isSleeping = false
        end
        local chance = 33
        local woundstrength = 10
        if player:HasTrait("Lucky") then
            chance = chance - 5 * luckimpact
            woundstrength = woundstrength - 5 * luckimpact
        elseif player:HasTrait("Unlucky") then
            chance = chance + 5 * luckimpact
            woundstrength = woundstrength + 5 * luckimpact
        end
        local difference = lasthp - currenthp
        --Divide the difference by the number of body parts, since ReduceGeneralHealth applies to each part.
        difference = difference * 2 / bodydamage:getBodyParts():size()
        bodydamage:ReduceGeneralHealth(difference)
        if difference > 0.33 and ZombRand(100) <= chance then
            local randompart = ZombRand(0, 16)
            local b = bodydamage:getBodyPart(BodyPartType.FromIndex(randompart))
            b:setFractureTime(ZombRand(20) + woundstrength)
        elseif difference > 0.1 and ZombRand(100) <= chance then
            local randompart = ZombRand(0, 16)
            local b = bodydamage:getBodyPart(BodyPartType.FromIndex(randompart))
            b:setScratched(true, true)
        end
    end
    ]]--
end

local function TraitFragileOnPlayerDamage(player, damageType, damage)
    if damage >= 2 then
        print(damageType)

    end
    --[[
    if currenthp < lasthp and multiplier <= 4.0 then
        if playerdata.isSleeping == true and player:getBodyDamage():getBodyPart(BodyPartType.FromString("Neck")):getAdditionalPain() > 0 then
            playerdata.isSleeping = false
            playerdata.fLastHP = 0
            return
        else
            playerdata.isSleeping = false
        end
        local chance = 33
        local woundstrength = 10
        if player:HasTrait("Lucky") then
            chance = chance - 5 * luckimpact
            woundstrength = woundstrength - 5 * luckimpact
        elseif player:HasTrait("Unlucky") then
            chance = chance + 5 * luckimpact
            woundstrength = woundstrength + 5 * luckimpact
        end
        local difference = lasthp - currenthp
        --Divide the difference by the number of body parts, since ReduceGeneralHealth applies to each part.
        difference = difference * 2 / bodydamage:getBodyParts():size()
        bodydamage:ReduceGeneralHealth(difference)
        if difference > 0.33 and ZombRand(100) <= chance then
            local randompart = ZombRand(0, 16)
            local b = bodydamage:getBodyPart(BodyPartType.FromIndex(randompart))
            b:setFractureTime(ZombRand(20) + woundstrength)
        elseif difference > 0.1 and ZombRand(100) <= chance then
            local randompart = ZombRand(0, 16)
            local b = bodydamage:getBodyPart(BodyPartType.FromIndex(randompart))
            b:setScratched(true, true)
        end
    end
    ]]--
end

Events.OnPlayerUpdate.Add(TraitFragileUpdate)
Events.OnPlayerGetDamage.Add(TraitFragileOnPlayerDamage)