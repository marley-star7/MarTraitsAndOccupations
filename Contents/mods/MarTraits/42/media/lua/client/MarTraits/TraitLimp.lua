-- TODO: Make the trait not require fracture injury if possible, be unlisted permanent limp.

local function getMajorLimpInjuryLocation()
	if SandboxVars.MarTraits.MajorLimpRightLeg then
		return BodyPartType.LowerLeg_R
	else 
		return BodyPartType.LowerLeg_L 
	end
end

local function getMinorLimpInjuryLocation()
	if SandboxVars.MarTraits.MinorLimpRightLeg then
		return BodyPartType.LowerLeg_R
	else 
		return BodyPartType.LowerLeg_L 
	end
end

local function getBrokeLegInjuryLocation()
	if SandboxVars.MarTraits.BrokeLegRightLeg then
		return BodyPartType.LowerLeg_R
	else 
		return BodyPartType.LowerLeg_L 
	end
end

local function limpTraitUpdate(player)
	local major = false
	local minor = false
	local legInjuryLocation
	if player:HasTrait("Mar_MajorLimp") then
		major = true
		legInjuryLocation = getMajorLimpInjuryLocation()
	elseif player:HasTrait("Mar_MinorLimp") then
		minor = true
		legInjuryLocation = getMinorLimpInjuryLocation()
	else return end
	
	local limpHealLimit = 0
	local limpHealLimitIncreasePerSplintFactor
	local limpDamageHealBack = 0
	if major then
		limpHealLimit = SandboxVars.MarTraits.MajorLimpFractureStrength
		limpHealLimitIncreasePerSplintFactor = SandboxVars.MarTraits.MajorLimpHealLimitIncreasePerSplintFactor
		limpDamageHealBack = SandboxVars.MarTraits.MajorLimpNoInjuryDamageLossReduction/100
	elseif minor then
		limpHealLimit = SandboxVars.MarTraits.MinorLimpFractureStrength
		limpHealLimitIncreasePerSplintFactor = SandboxVars.MarTraits.MinorLimpHealLimitIncreasePerSplintFactor
		limpDamageHealBack = SandboxVars.MarTraits.MinorLimpNoInjuryDamageLossReduction/100
	end

	-- Noooo sprinting with a limp now mister :]
	player:setAllowSprint(false)
	local bodydamage = player:getBodyDamage();
	for i = 0, bodydamage:getBodyParts():size() - 1 do
		local bodyPart = bodydamage:getBodyParts():get(i);
		if bodyPart == player:getBodyDamage():getBodyPart(legInjuryLocation) then
			-- To make sure the limp isn't torturous with no splint, but not negated entirely with a good one, 
			-- we make sure to add a small extra limit to the heal to simulate still having the limp.
			local totalLimpHealLimit = limpHealLimit + bodyPart:getSplintFactor() * limpHealLimitIncreasePerSplintFactor
			local delta = getGameTime():getTimeDelta()

			local fractureTime = bodyPart:getFractureTime()
			if fractureTime <= totalLimpHealLimit then
				bodyPart:setFractureTime(totalLimpHealLimit)
			elseif fractureTime <= (limpHealLimit + limpHealLimitIncreasePerSplintFactor * 10) then -- 10 is max doctor level.
				bodyPart:setFractureTime(totalLimpHealLimit)
				bodyPart:setFractureTime(fractureTime - limpDamageHealBack * SandboxVars.MarTraits.LimpTraitsHealLimitReturnSpeed * delta)
			end
			-- A little messy but a necessary workaround to make sure removing a stilt does not make your injury worse for some reason.

			-- If we do not have an injury, do not lose health so quickly since this is a long time wound.
			if bodyPart:getBleedingTime() <= 0 then
				bodyPart:AddHealth(limpDamageHealBack * delta)
			end
		end
	end
end

local function limpTraitsOnCreatePlayer(player)
	local major = false
	local minor = false
	local broken = false
	local legInjuryLocation
	if player:HasTrait("Mar_MajorLimp") then
		major = true
		legInjuryLocation = getMajorLimpInjuryLocation()
	elseif player:HasTrait("Mar_MinorLimp") then
		minor = true
		legInjuryLocation = getMinorLimpInjuryLocation()
	elseif player:HasTrait("Mar_BrokeLeg") then
		broken = true
		legInjuryLocation = getBrokeLegInjuryLocation()
	else return end

	if major or minor then
		-- Set inital limp stuff so that the splint works.
		limpTraitUpdate(player)
	end

	local splintStrength = SandboxVars.MarTraits.LimpTraitsStartingSplintStrength/10
	-- Add the starting splint.
	local bodydamage = player:getBodyDamage();
	for i = 0, bodydamage:getBodyParts():size() - 1 do
		local bodyPart = bodydamage:getBodyParts():get(i);
		if bodyPart == player:getBodyDamage():getBodyPart(legInjuryLocation) then
			if minor or major then
				bodyPart:setSplintItem("Base.Splint")
				bodyPart:setSplint(true, splintStrength)
				bodyPart:setSplintFactor(splintStrength)
			elseif broken then
				bodyPart:setFractureTime(SandboxVars.MarTraits.BrokeLegFractureTime)
				-- TODO: Maybe add functionality so the trait is only removed once your broken leg is fully healed?
				player:getTraits():remove("Mar_BrokeLeg")
				bodyPart:setBandaged(true, SandboxVars.MarTraits.BrokeLegFractureTime)
				bodyPart:setBandageType("Base.AlcoholBandage")
				bodyPart:setSplintItem("Base.Splint")
				bodyPart:setSplint(true, splintStrength)
				bodyPart:setSplintFactor(splintStrength)
			end
		end
	end
end

Events.OnCreatePlayer.Add(
	function (playerNum, player) limpTraitsOnCreatePlayer(player) end
)

Events.OnPlayerUpdate.Add(limpTraitUpdate)