MarTraits = MarTraits or {}

-- think about messing with thermoregulator regulation stuff too for perk
local float previousTemperature = -9999
-- TODO: this is just like... there has got to be a more CPU friendly way to do this that isn't ugly but not rn please lol I finally got this to work.
-- TODO: Justt kiddinggg this doesn't work. This trait idea just might actually be impossible.
MarTraits.temperatureToleranceUpdate = function(player)
	local bodyDamage = player:getBodyDamage()
	local currentTemperature = bodyDamage:getTemperature()

	local thermoregulator = bodyDamage:getThermoregulator()
	local setPoint = thermoregulator:getSetPoint() -- the ideal temp for the player.

	if previousTemperature == -9999 then --get initial value
		previousTemperature = currentTemperature
		print("Setting initial.")
	end

	local deltaTemperature = currentTemperature - previousTemperature
	local traitTemperatureDifference = 0
	if (currentTemperature > previousTemperature) then -- TEMPERATURE INCREASING
		local tempIncreaseModifier = 0
		if (currentTemperature > setPoint) then -- IS HOTTER THAN NORMAL
			if player:HasTrait("HeatIntolerant") then
				tempIncreaseModifier = 1
			elseif player:HasTrait("HeatTolerant") then
				tempIncreaseModifier = -0.5
			end
		else ------------------------------------- IS COLDER THAN NORMAL
			if player:HasTrait("ColdIntolerant") then
				tempIncreaseModifier = -0.5
			elseif player:HasTrait("ColdTolerant") then
				tempIncreaseModifier = 0.5
			end
		end
		traitTemperatureDifference = deltaTemperature * tempIncreaseModifier
	else -- currentTemperature < previousTemperature -- TEMPERATURE DECREASING
		local tempDecreaseModifier = 0
		if (currentTemperature > setPoint) then -- IS HOTTER THAN NORMAL
			if player:HasTrait("HeatIntolerant") then
				tempDecreaseModifier = -0.5
			elseif player:HasTrait("HeatTolerant") then
				tempDecreaseModifier = 0.5
			end
		else ------------------------------------- IS COLDER THAN NORMAL
			if player:HasTrait("ColdIntolerant") then
				tempDecreaseModifier = 1
			elseif player:HasTrait("ColdTolerant") then
				tempDecreaseModifier = -0.5
			end
		end
		traitTemperatureDifference = deltaTemperature * tempDecreaseModifier
	end
	local newTemperature = (currentTemperature + traitTemperatureDifference)
	bodyDamage:setTemperature(newTemperature)
	previousTemperature = newTemperature
end

Events.OnPlayerUpdate.Add(MarTraits.temperatureToleranceUpdate)