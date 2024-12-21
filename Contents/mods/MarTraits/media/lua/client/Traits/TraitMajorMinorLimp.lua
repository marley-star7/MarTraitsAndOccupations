MarTraits = MarTraits or {}

-- TODO: Make the trait not have to require a splint on if possible.

MarTraits.limpSpawn = function(player)
	if player:HasTrait("MajorLimp") then
		fractureHealLimit = 50
		splintStrength = .9
	elseif player:HasTrait("MinorLimp") then
		fractureHealLimit = 15
		splintStrength = 2
	else return end

	-- TODO: Add a table later for the injured trait so don't overlap stuff.
	local bodydamage = player:getBodyDamage();
	for i = 0, bodydamage:getBodyParts():size() - 1 do
		local bodyPart = bodydamage:getBodyParts():get(i);
		if bodyPart == player:getBodyDamage():getBodyPart(BodyPartType.FromString("LowerLeg_R")) then
			bodyPart:setFractureTime(fractureHealLimit)
			bodyPart:setSplint(true, splintStrength)
			bodyPart:setSplintItem("Base.Splint")
			break
		end
	end
end

MarTraits.limpUpdate = function(player)
	if player:HasTrait("MajorLimp") then
		fractureHealLimit = 50
		splintStrength = .9
	elseif player:HasTrait("MinorLimp") then
		fractureHealLimit = 15
		splintStrength = 2
	else return end

	local bodydamage = player:getBodyDamage();
	for i = 0, bodydamage:getBodyParts():size() - 1 do
		local bodyPart = bodydamage:getBodyParts():get(i);
		if bodyPart == player:getBodyDamage():getBodyPart(BodyPartType.FromString("LowerLeg_R")) then
			if bodyPart:getFractureTime() <= fractureHealLimit then
				bodyPart:setFractureTime(fractureHealLimit)
				if bodyPart:isSplint() then bodyPart:setSplintFactor(splintStrength) end
			end
		end
	end
end

Events.OnNewGame.Add(MarTraits.limpSpawn)
Events.OnPlayerUpdate.Add(MarTraits.limpUpdate)