MarTraits = MarTraits or {}

-- TODO: Figure out how to change the moodle for bleeding to say bleeding more or less with this trait.
-- Doesn't seem possible in current update, bleeding moodle calculation is tied very closely to how many body parts are bleeding in source, not super accessible.

MarTraits.nextBloodSplatBuildRate = 0
MarTraits.thinBloodedBloodSplatModifier = 3

local function thickThinBloodedOnPlayerDamage(player, damageType, damage)
	-- If not bleeding return
	if damageType ~= "BLEEDING" then return end

	local bleedMore = false
	if player:HasTrait("Mar_ThickBlooded") then
		bleedMore = false
	elseif player:HasTrait("Mar_ThinBlooded") then
		bleedMore = true
	else return end -- Has neither traits get out of here.

	local bodydamage = player:getBodyDamage()
	local bleedingParts = bodydamage:getNumPartsBleeding()
	if bleedingParts <= 0 then return end
	-- For each body part.
	for i = 0, player:getBodyDamage():getBodyParts():size() - 1 do
		local bodyPart = player:getBodyDamage():getBodyParts():get(i)
		if bodyPart:bleeding() and not (bodyPart:IsBleedingStemmed()) then
			if bleedMore then
				-- Divide by 100 so that it is a decimal, since they are stored in sandbox vars as a num between 1 and 100
				local bleedMoreAmount = SandboxVars.MarTraits.ThinBloodedBleedMoreModifier/100
				local bleedDamage = damage * bleedMoreAmount
				player:getBodyDamage():ReduceGeneralHealth(bleedDamage)
				-- Add some more visual BLOOD to show you bleeding more
				if MarTraits.nextBloodSplatBuildRate >= 2 - (bleedingParts/10) then
					MarTraits.nextBloodSplatBuildRate = 0
					player:getChunk():addBloodSplat(player:getX(), player:getY(), player:getZ(), ZombRand(5))
				end
				MarTraits.nextBloodSplatBuildRate = MarTraits.nextBloodSplatBuildRate + bleedDamage * MarTraits.thinBloodedBloodSplatModifier
				--print("damage recieved = " + damage)
				--print("bleed damage added = " + damage * bleedMoreAmount)
			else -- Bleed less
				local bleedLessAmount = SandboxVars.MarTraits.ThickBloodedBleedLessModifier/100
				local bleedDamageReduce = damage * bleedLessAmount
				player:getBodyDamage():AddGeneralHealth(bleedDamageReduce)
				--print("damage recieved = " + damage)
				--print("bleeding damage removed = " + damage * bleedLessAmount)
			end
		end
	end
end

Events.OnPlayerGetDamage.Add(thickThinBloodedOnPlayerDamage)
