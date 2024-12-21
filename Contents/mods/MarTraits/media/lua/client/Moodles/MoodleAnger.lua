if getActivatedMods():contains("MoodleFramework") == true then
    require("MF_ISMoodle")
    MF.createMoodle("Anger")
end

local function AngerMoodleUpdate(player)
    local moodleAnger = MF.getMoodle("Anger")
    if moodleAnger and moodleAnger:getLevel() ~= 0 then
        local anger = moodleAnger:getValue()
        local criticalChance = -anger * 100
        --print(anger)
        if criticalChance >= 100 then criticalChance = 100 end
        -- BreakChance
        if player:getUseHandWeapon() then
            local handWeapon = player:getUseHandWeapon()
            --print(handWeapon:getCondition() .. " ass " .. anger)
            --print(handWeapon:getExtraDamage())
            local weaponData = handWeapon:getModData()
            if weaponData.AngerCriticalChanceModifier ~= nil then
                -- Remove the any old chance.
                handWeapon:setCriticalChance(handWeapon:getCriticalChance() - weaponData.AngerCriticalChanceModifier)
            end
            -- Add the new chance.
            weaponData.AngerCriticalChanceModifier = criticalChance
            handWeapon:setExtraDamage(anger)
            handWeapon:setCriticalChance(handWeapon:getCriticalChance() + weaponData.AngerCriticalChanceModifier)
        end
    end
end

local function AngerMoodleOnPlayerAttackFinished(character, handWeapon)
    local moodleAnger = MF.getMoodle("Anger")
    if moodleAnger and moodleAnger:getLevel() ~= 0 then
        local anger = moodleAnger:getValue()
        weaponCondition = handWeapon:getCondition()
        handWeapon:setCondition(weaponCondition - anger * 10)
    end
end

if getActivatedMods():contains("MoodleFramework") == true then
    Events.OnPlayerAttackFinished.Add(AngerMoodleOnPlayerAttackFinished)
    Events.OnPlayerUpdate.Add(AngerMoodleUpdate)
end