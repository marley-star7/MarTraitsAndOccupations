local function corpseFamiliarUpdate(player)
    if not player:HasTrait("Mar_CorpseFamiliar") then return end

    local bodyDamage = player:getBodyDamage()

    local delta = getGameTime():getTimeDelta()
    local corpseSicknessFoodSicknessRecution = bodyDamage:GetBaseCorpseSickness() * SandboxVars.MarOccupations.CorpseFamiliarCorpseSicknessReduction * delta
    --print(currentCorpseSickness)
    bodyDamage:setFoodSicknessLevel(bodyDamage:getFoodSicknessLevel() - corpseSicknessFoodSicknessRecution)
end

Events.OnPlayerUpdate.Add(corpseFamiliarUpdate)