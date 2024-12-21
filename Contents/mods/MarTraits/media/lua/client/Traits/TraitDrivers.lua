MarTraits = MarTraits or {}

MarTraits.driverTraitUpdate = function(player)
    local vehicle = player:getVehicle()
    if not vehicle:getDriver() == player then return end
    local vehicleModData = vehicle:getModData()
    --print("Vehicle driver is " .. vehicleModData.sState)

    if vehicleModData.fRegulatorSpeed == nil then
        vehicleModData.bUpdated = nil
    end
    if vehicleModData.bUpdated == nil then
        vehicleModData.fBrakingForce = vehicle:getBrakingForce()
        vehicleModData.fMaxSpeed = vehicle:getMaxSpeed()
        vehicleModData.iEngineQuality = vehicle:getEngineQuality()
        vehicleModData.iEngineLoudness = vehicle:getEngineLoudness()
        vehicleModData.iEnginePower = vehicle:getEnginePower()
        vehicleModData.iMass = vehicle:getMass()
        vehicleModData.iInitialMass = vehicle:getInitialMass()
        vehicleModData.fOffRoadEfficiency = vehicle:getScript():getOffroadEfficiency()
        vehicleModData.fRegulatorSpeed = vehicle:getRegulatorSpeed()
        vehicleModData.sState = "Normal"
        vehicleModData.bUpdated = true
    else
        if player:HasTrait("expertdriver") and vehicleModData.sState ~= "ExpertDriver" then
            print("New vehicle driver is " .. vehicleModData.sState .. ", different from previous, applying changes.")

            vehicle:setBrakingForce(vehicleModData.fBrakingForce * 2)
            vehicle:setEngineFeature(vehicleModData.iEngineQuality * 2, vehicleModData.iEngineLoudness * 0.5, vehicleModData.iEnginePower * 3);
            vehicle:setMaxSpeed(vehicleModData.fMaxSpeed * 1.25)
            vehicle:setMass(vehicleModData.iMass * 0.5)
            vehicle:setInitialMass(vehicleModData.iInitialMass * 0.5)
            vehicle:updateTotalMass()
            vehicle:getScript():setOffroadEfficiency(vehicleModData.fOffRoadEfficiency * 2)
            vehicle:setRegulatorSpeed(vehicleModData.fRegulatorSpeed * 2)
            vehicleModData.sState = "ExpertDriver"
            print("Vehicle State: " .. vehicleModData.sState)
            vehicle:update()
        end
        if player:HasTrait("poordriver") and vehicleModData.sState ~= "PoorDriver" then
            print("New vehicle driver is " .. vehicleModData.sState .. ", different from previous, applying changes.")

            vehicle:setBrakingForce(vehicleModData.fBrakingForce * 0.5)
            vehicle:setEngineFeature(vehicleModData.iEngineQuality * 0.5, vehicleModData.iEngineLoudness * 1.5, vehicleModData.iEnginePower * 0.66)
            vehicle:setMaxSpeed(vehicleModData.fMaxSpeed * 0.75)
            vehicle:setMass(vehicleModData.iMass * 1.33)
            vehicle:setInitialMass(vehicleModData.iInitialMass * 1.33)
            vehicle:updateTotalMass()
            vehicle:getScript():setOffroadEfficiency(vehicleModData.fOffRoadEfficiency * 0.5)
            vehicle:setRegulatorSpeed(vehicleModData.fRegulatorSpeed * 0.66)
            vehicleModData.sState = "PoorDriver"
            print("Vehicle State: " .. vehicleModData.sState)
            vehicle:update()
        end
        if player:HasTrait("expertdriver") == false and player:HasTrait("poordriver") == false and vehicleModData.sState ~= "Normal" then
            print("New vehicle driver is " .. vehicleModData.sState .. ", different from previous, applying changes.")

            vehicle:setBrakingForce(vehicleModData.fBrakingForce)
            vehicle:setEngineFeature(vehicleModData.iEngineQuality, vehicleModData.iEngineLoudness, vehicleModData.iEnginePower)
            vehicle:setMaxSpeed(vehicleModData.fMaxSpeed)
            vehicle:setMass(vehicleModData.iMass)
            vehicle:setInitialMass(vehicleModData.iInitialMass)
            vehicle:updateTotalMass()
            vehicle:getScript():setOffroadEfficiency(vehicleModData.fOffRoadEfficiency)
            vehicle:setRegulatorSpeed(vehicleModData.fRegulatorSpeed)
            vehicleModData.sState = "Normal"
            print("Vehicle State: " .. vehicleModData.sState)
            vehicle:update()
        end
    end
end

Events.OnEnterVehicle.Add(MarTraits.driverTraitUpdate)