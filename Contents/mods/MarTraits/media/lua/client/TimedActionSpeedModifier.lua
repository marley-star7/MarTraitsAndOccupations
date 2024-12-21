require ("MarLibrary")

MarTraits = MarTraits or {}

MarTraits.TraitSpecificTimedActionSpeedList = MarTraits.TraitSpecificTimedActionSpeedList or {}

function MarTraits.TraitSpecificTimedActionSpeedListAdd(traitName, actions)
	local size = #MarTraits.TraitSpecificTimedActionSpeedList
	for i=0, size do
		local traitData = MarTraits.TraitSpecificTimedActionSpeedList[i]
		if traitData and traitData[1] == traitName then
			MarTraits.TraitSpecificTimedActionSpeedList[i] = {traitName, actions}
			print("Trait specific timed action speed list the same, speed changed.")
			return
		end
	end
	MarTraits.TraitSpecificTimedActionSpeedList[size + 1] = {traitName, actions}
end

MarTraits.workerTimedActionNoSpeedList = {
	"ISWalkToTimedAction",
	"ISPathFindAction",
	"ISReadABook",
	-- Really they eat faster?
	"ISTakeWaterAction",
	"ISEatFoodAction",
}

MarTraits.workerTimedActionSpeedUniqueList = {
	--== bigger values = less effect the traits have. ==--
	-- EX: 3 would cut the effect of the modifier in thirds, .1 would probably make it way more effective.
	ISInventoryTransferAction = .5, -- So stacking with dexterous is just like not crazy
}

MarTraits.fastSlowWorkerUpdate = function(player)
	if player:hasTimedActions() then
		local modifier = 0
		if player:HasTrait("FastWorker") then
			modifier = .5
		elseif player:HasTrait("SlowWorker") then
			modifier = -.5
		end

		local actions = player:getCharacterActions()
		local action = actions:get(0)
		local type = action:getMetaType()
		--print("Current action name is (" .. type .. ")")
		local delta = action:getJobDelta()
		local multiplier = getGameTime():getMultiplier()
		--Don't modify the action if it is in the Blacklist or if it has not yet started (is valid)
		-- Fast Slow Worker stuff first
		if MarLibrary.tableContains(MarTraits.workerTimedActionNoSpeedList, type) and delta > 0 then
			modifier = 0
		end
		-- Unique slower or quicker speeds for actions
		for checkType, value in pairs(MarTraits.workerTimedActionSpeedUniqueList) do
			if checkType == type then
				modifier = modifier * value
			end
		end

		for _, traitData in pairs(MarTraits.TraitSpecificTimedActionSpeedList) do
			if player:HasTrait(traitData[1]) then -- traitData 1 is trait name.
				for _, action in pairs(traitData[2]) do
					if action[1] == type then

						local speedMod = action[2]
						-- TODO: Doesn't work currently
						if traitData[3] then -- function to have conditions to the speed.
							local testFunc = traitData[3]
							speedMod = testFunc(player)
						end
						modifier = modifier + speedMod
					end
				end
			end
		end

		if delta < 0.99 - (modifier * 0.01) then
			--Don't overshoot it?
			action:setCurrentTime((action:getCurrentTime() + (modifier * multiplier)))
		end
	end
end

Events.OnPlayerUpdate.Add(MarTraits.fastSlowWorkerUpdate)