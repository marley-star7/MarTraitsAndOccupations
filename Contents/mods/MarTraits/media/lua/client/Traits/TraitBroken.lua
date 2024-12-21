function TraitBroken(player)
	if player:HasTrait("broke") then
		-- TODO: Add a table later for the injured trait so don't overlap stuff.
		local bodydamage = player:getBodyDamage();
		for i = 0, bodydamage:getBodyParts():size() - 1 do
			local bodyPart = bodydamage:getBodyParts():get(i);
			if bodyPart == player:getBodyDamage():getBodyPart(BodyPartType.FromString("LowerLeg_R")) then
				bodyPart:AddDamage(20)
				bodyPart:setFractureTime(50)
				bodyPart:setSplint(true, 0.9)
				bodyPart:setSplintItem("Base.Splint")
				bodyPart:setBandaged(true, 5, true, "Base.AlcoholBandage");
				bodydamage:setInfected(false)
				bodydamage:setInfectionLevel(0)
				break
			end
		end
	end
end

Events.OnNewGame.Add(TraitBroken);