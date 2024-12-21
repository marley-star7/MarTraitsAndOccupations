-- TODO: obviously this isn't finished, need some way to get television, radio, and the such data in order to determine those electronics.

function MicrowaveSyndromeOnPlayerUpdateByDelta(player)
	if not player:HasTrait("MicrowaveSyndrome") then return end
	local bodyDamage = player:getBodyDamage()
	local head = player:getBodyDamage():getBodyPart(BodyPartType.FromString("Head"))

	local playerSquare = player:getSquare()
	local electricityPain = 0
	if playerSquare:haveElectricity() then
		-- print("Generator power pain")
		electricityPain = electricityPain + 40
	end

	-- For some godforsaken reason, you CAN'T GET THE ROOM LIGHTS ARRAY, It exists as a value but only as a field, with no getter, goddammit.
	playerRoom = playerSquare:getRoom()

	if playerRoom then
		local roomDef = playerRoom:getRoomDef()
		local roomObjects = roomDef:getObjects()
		for i = 0, roomObjects:size() -1, 1 do
			object = lightSwitches:get(i)
			object:getType()
		end

		local lightSwitches = playerRoom:getLightSwitches()
		for i = 0, lightSwitches:size() -1, 1 do
			switch = lightSwitches:get(i)
			if switch:getPower() then
				if switch:isActivated() then
					-- print("Light switch activated pain")
					electricityPain = electricityPain + 25
				end
			else
			end
		end
	end
	print(electricityPain)
	head:setAdditionalPain(electricityPain)
end