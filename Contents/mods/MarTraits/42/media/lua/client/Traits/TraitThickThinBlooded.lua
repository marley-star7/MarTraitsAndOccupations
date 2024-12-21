MarTraits = MarTraits or {}

-- TODO: Figure out how to change the moodle for bleeding to say bleeding more or less with this trait.

local float MarTraits.timeTillNextBloodSplat = 0

MarTraits.thickThinBloodedOnPlayerDamage = function(player, damageType, damage)
	-- If not bleeding return
	if damageType ~= "BLEEDING" then return end

	local bleedMore = false
	if player:HasTrait("ThickBlooded") then
		bleedMore = false
	elseif player:HasTrait("ThinBlooded") then
		bleedMore = true
	else return end -- Has neither traits get out of here.

	local delta = getGameTime():getTimeDelta() -- So we don't bleed more depending on frame rate
	local bodydamage = player:getBodyDamage()
	local bleedingParts = bodydamage:getNumPartsBleeding()
	if bleedingParts > 0 then
		-- For each body part.
		for i = 0, player:getBodyDamage():getBodyParts():size() - 1 do
			local bodyPart = player:getBodyDamage():getBodyParts():get(i)
			if bodyPart:bleeding() and not bodyPart:IsBleedingStemmed() then
				if bleedMore then
					-- Divide by 100 so that it is a decimal, since they are stored in sandbox vars as a num between 1 and 100
					local bleedMoreAmount = SandboxVars.MarTraits.ThinBloodedBleedMoreModifier/100 * bodyPartLocationModifier * delta
					bodyPart:ReduceHealth(damage * 1.1)
					-- Add some more visual BLOOD to show you bleeding more
					if MarTraits.timeTillNextBloodSplat >= 2 - (bleedingParts/10) then
						MarTraits.timeTillNextBloodSplat = 0
						player:getChunk():addBloodSplat(player:getX(), player:getY(), player:getZ(), ZombRand(5))
					end
					MarTraits.timeTillNextBloodSplat = timeTillNextBloodSplat + bleedMoreAmount
					print("bleeding more " .. bleedMoreAmount)
				else -- Bleed less
					local bleedLessAmount = SandboxVars.MarTraits.ThickBloodedBleedLessModifier/100 * bodyPartLocationModifier * delta
					bodyPart:AddHealth(damage * 0.1)
					print("bleeding less " .. bleedLessAmount)
				end
			end
		end
	end
end

Events.OnPlayerGetDamage.Add(MarTraits.thickThinBloodedOnPlayerDamage)
