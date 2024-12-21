MarOccupations = MarOccupations or {}

local corpseSicknessNegationStrength = .7
local prevSicknessLevel = -1
-- Thanks "Working Masks" for most of this code I stole.
function MarOccupations.CorpseFamiliarUpdate(player)
    if not player:HasTrait("CorpseFamiliar") then return end

    local bodyDamage = player:getBodyDamage()
    -- TODO TAKE THIS FOR THE FUCKING THING FOR THE FUCKING TEMPERATURE TRAITS YES
	if prevSicknessLevel < 0.0 then --get initial value
		prevSicknessLevel = bodyDamage:getFoodSicknessLevel()
	end

    local currentSickness = bodyDamage:getFoodSicknessLevel()
    if corpseSicknessNegationStrength > 0.0 and currentSickness > 0.0 then
        local newSickness = currentSickness
        local gameTimeMultiplier = GameTime.getInstance():getMultiplier()
        local deltaSicknessLevel = currentSickness - prevSicknessLevel
        local poisonLevel = bodyDamage:getPoisonLevel()
        if deltaSicknessLevel > 0 then
            -- Cannot get the number of corpses, because that value is not exposed in lua, so we calculate it backwards ourselves
            local sicknessFromCorpses
            if poisonLevel > 0.0 then -- use different formula if poisoned
                --original formula for 41.65
                sicknessFromCorpses = deltaSicknessLevel - ((bodyDamage:getInfectionGrowthRate() * (2 + Math.round(bodyDamage:getPoisonLevel() / 10.0))) * gameTimeMultiplier)
            else
                sicknessFromCorpses = deltaSicknessLevel
            end
            local sicknessFromCorpseRate = BodyDamage.getSicknessFromCorpsesRate(6) -- Damage is calculated for any corpse above 5
            local estimatedCorpses = sicknessFromCorpses / sicknessFromCorpseRate / gameTimeMultiplier
            local sicknessFromCorpsesAdjusted = Math.min(Math.ceil(estimatedCorpses), 20) * sicknessFromCorpseRate * gameTimeMultiplier-- capped at 20 corpses
            if sicknessFromCorpses > 0 then
                newSickness = newSickness - (sicknessFromCorpsesAdjusted * corpseSicknessNegationStrength)
            end
        end
        if newSickness < 0 then
            newSickness = 0
        end
        bodyDamage:setFoodSicknessLevel(newSickness);
        prevSicknessLevel = newSickness
    else
        prevSicknessLevel = currentSickness
    end
end

Events.OnPlayerUpdate.Add(MarOccupations.CorpseFamiliarUpdate)