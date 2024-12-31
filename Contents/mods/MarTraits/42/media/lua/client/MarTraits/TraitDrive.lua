MarTraits = MarTraits or {}

MarTraits.DriverTraits = 
{
    Keen = "Mar_KeenDriver",
    Poor = "Mar_PoorDriver",
    Normal = "Mar_NormalDriver"
}

MarTraits.setVehicleStateNormalDriver = function(vehicle)
    local vehicleModData = vehicle:getModData()
    if vehicleModData.sMarTraitsState == nil then
        vehicleModData.fMarTraitsBrakingForceAdjustment = 0
        vehicleModData.iMarTraitsEngineQualityAdjustment = 0
        vehicleModData.iMarTraitsEngineLoudnessAdjustment = 0
        vehicleModData.iMarTraitsEnginePowerAdjustment = 0
        vehicleModData.fMarTraitsMaxSpeedAdjustment =  0
        vehicleModData.iMarTraitsMassAdjustment = 0
        vehicleModData.iMarTraitsInitialMassAdjustment = 0
        vehicleModData.fOffRoadEfficiencyAdjustment = 0
        vehicleModData.fMarTraitsRegulatorSpeedAdjustment = 0
    end

    vehicle:setBrakingForce(vehicle:getBrakingForce() - vehicleModData.fMarTraitsBrakingForceAdjustment)
    vehicle:setEngineFeature(
        vehicle:getEngineQuality() - vehicleModData.iMarTraitsEngineQualityAdjustment, 
        vehicle:getEngineLoudness() - vehicleModData.iMarTraitsEngineLoudnessAdjustment, 
        vehicle:getEnginePower() - vehicleModData.iMarTraitsEnginePowerAdjustment
    )
    vehicle:setMaxSpeed(vehicle:getMaxSpeed() - vehicleModData.fMarTraitsMaxSpeedAdjustment)
    vehicle:setMass(vehicle:getMass() - vehicleModData.iMarTraitsMassAdjustment)
    vehicle:setInitialMass(vehicle:getInitialMass() - vehicleModData.iMarTraitsInitialMassAdjustment)
    vehicle:updateTotalMass()
    vehicle:getScript():setOffroadEfficiency(vehicle:getScript():getOffroadEfficiency() - vehicleModData.fOffRoadEfficiencyAdjustment)
    vehicle:setRegulatorSpeed(vehicle:getRegulatorSpeed() - vehicleModData.fMarTraitsRegulatorSpeedAdjustment)

    vehicleModData.fMarTraitsBrakingForceAdjustment = 0
    vehicleModData.iMarTraitsEngineQualityAdjustment = 0
    vehicleModData.iMarTraitsEngineLoudnessAdjustment = 0
    vehicleModData.iMarTraitsEnginePowerAdjustment = 0
    vehicleModData.fMarTraitsMaxSpeedAdjustment = 0
    vehicleModData.iMarTraitsMassAdjustment = 0
    vehicleModData.iMarTraitsInitialMassAdjustment = 0
    vehicleModData.fOffRoadEfficiencyAdjustment = 0
    vehicleModData.fMarTraitsRegulatorSpeedAdjustment = 0
    vehicleModData.sMarTraitsState = MarTraits.DriverTraits.Normal
    print("Vehicle State: " .. vehicleModData.sMarTraitsState)
    vehicle:update()
end

MarTraits.setVehicleStateDriver = function(vehicle, driverState)
    -- Reset to default driver stats before anything else
    MarTraits.setVehicleStateNormalDriver(vehicle)

    local fMarTraitsBrakingForcePreAdjustment = vehicle:getBrakingForce()
    local iMarTraitsEngineQualityPreAdjustment = vehicle:getEngineQuality()
    local iMarTraitsEngineLoudnessPreAdjustment = vehicle:getEngineLoudness()
    local iMarTraitsEnginePowerPreAdjustment = vehicle:getEnginePower()
    local fMarTraitsMaxSpeedPreAdjustment = vehicle:getMaxSpeed()
    local iMarTraitsMassPreAdjustment = vehicle:getMass()
    local iMarTraitsInitialMassPreAdjustment = vehicle:getInitialMass()
    local fOffRoadEfficiencyPreAdjustment = vehicle:getScript():getOffroadEfficiency()
    local fMarTraitsRegulatorSpeedPreAdjustment = vehicle:getRegulatorSpeed()

    local vehicleModData = vehicle:getModData()

    -- Actually adjust stats here
    if driverState == MarTraits.DriverTraits.Keen then
        vehicle:setBrakingForce(fMarTraitsBrakingForcePreAdjustment * 2)
        vehicle:setEngineFeature(
            iMarTraitsEngineQualityPreAdjustment * 2, 
            iMarTraitsEngineLoudnessPreAdjustment * 0.85, 
            iMarTraitsEnginePowerPreAdjustment * 3
        )
        vehicle:setMaxSpeed(fMarTraitsMaxSpeedPreAdjustment * 1.25)
        vehicle:setMass(iMarTraitsMassPreAdjustment * 0.5)
        vehicle:setInitialMass(iMarTraitsInitialMassPreAdjustment * 0.5)
        vehicle:updateTotalMass()
        vehicle:getScript():setOffroadEfficiency(fOffRoadEfficiencyPreAdjustment * 2)
        vehicle:setRegulatorSpeed(fMarTraitsRegulatorSpeedPreAdjustment * 2)
        vehicle:update()
        vehicleModData.sMarTraitsState = MarTraits.DriverTraits.Keen
    elseif MarTraits.DriverTraits.Poor then
        vehicle:setBrakingForce(fMarTraitsMaxSpeedPreAdjustment * 0.5)
        vehicle:setEngineFeature(
            iMarTraitsMassPreAdjustment  * 0.5, 
            iMarTraitsEngineLoudnessPreAdjustment * 1.15, 
            iMarTraitsEnginePowerPreAdjustment * 0.66
        )
        vehicle:setMaxSpeed(fMarTraitsMaxSpeedPreAdjustment * 0.75)
        vehicle:setMass(iMarTraitsMassPreAdjustment * 1.33)
        vehicle:setInitialMass(iMarTraitsInitialMassPreAdjustment * 1.33)
        vehicle:updateTotalMass()
        vehicle:getScript():setOffroadEfficiency(fOffRoadEfficiencyPreAdjustment * 0.5)
        vehicle:setRegulatorSpeed(fMarTraitsRegulatorSpeedPreAdjustment * 0.66)
        vehicle:update()
        vehicleModData.sMarTraitsState = MarTraits.DriverTraits.Poor
    else return end -- If not keen or poor, its default so all is done.

    -- Save adjustments made so they can be used in finding the new ones later.
    vehicleModData.fMarTraitsBrakingForceAdjustment = vehicle:getBrakingForce() - fMarTraitsBrakingForcePreAdjustment
    vehicleModData.iMarTraitsEngineQualityAdjustment = vehicle:getEngineQuality() - iMarTraitsEngineQualityPreAdjustment
    vehicleModData.iMarTraitsEngineLoudnessAdjustment = vehicle:getEngineLoudness() - iMarTraitsEngineLoudnessPreAdjustment
    vehicleModData.iMarTraitsEnginePowerAdjustment = vehicle:getEnginePower() - iMarTraitsEnginePowerPreAdjustment
    vehicleModData.fMarTraitsMaxSpeedAdjustment = vehicle:getMaxSpeed() - fMarTraitsMaxSpeedPreAdjustment
    vehicleModData.iMarTraitsMassAdjustment = vehicle:getMass() - iMarTraitsMassPreAdjustment
    vehicleModData.iMarTraitsInitialMassAdjustment = vehicle:getInitialMass() - iMarTraitsInitialMassPreAdjustment
    vehicleModData.fOffRoadEfficiencyAdjustment = vehicle:getScript():getOffroadEfficiency() - fOffRoadEfficiencyPreAdjustment
    vehicleModData.fMarTraitsRegulatorSpeedAdjustment = vehicle:getRegulatorSpeed() - fMarTraitsRegulatorSpeedPreAdjustment
    print("Vehicle State: " .. vehicleModData.sMarTraitsState)
end

local function driverTraitUpdate(player)
    local vehicle = player:getVehicle()
    if not (vehicle:getDriver() == player) then return end
    local vehicleModData = vehicle:getModData()

    local poorDriver = false
    local keenDriver = false
    if player:HasTrait("Mar_KeenDriver") then keenDriver = true
    elseif player:HasTrait("Mar_PoorDriver") then poorDriver = true
    else
        print("New vehicle driver is " .. MarTraits.DriverTraits.Normal.. ", applying changes.")
        return 

        end

    if poorDriver and vehicleModData.sMarTraitsState ~= MarTraits.DriverTraits.Poor then
        print("New vehicle driver is " .. MarTraits.DriverTraits.Poor .. ", different from previous, applying changes.")
        MarTraits.setVehicleStateDriver(vehicle, true)
    elseif keenDriver and vehicleModData.sMarTraitsState ~= MarTraits.DriverTraits.Keen then
        print("New vehicle driver is " .. MarTraits.DriverTraits.Keen .. ", different from previous, applying changes.")
        MarTraits.setVehicleStateDriver(vehicle, false)
    end
end

Events.OnEnterVehicle.Add(driverTraitUpdate)