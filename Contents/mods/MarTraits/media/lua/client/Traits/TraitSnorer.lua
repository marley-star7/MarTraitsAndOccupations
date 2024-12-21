MarTraits = MarTraits or {}

local currentSnoreSound = nil

--TODO: GET THE SOUND TO WORK!!!
function MarTraits.snorerUpdate()
	local player = getPlayer()
	if not player:HasTrait("Snorer") then return end

	local soundManager = getSoundManager()
	local soundVolume = .05
	if player:isAsleep() then

		stats = player:getStats()
		-- Snore louder if Smoker
		if player:HasTrait("Smoker") then
			soundVolume = soundVolume + .5
		end
		-- Snore louder if Drunk
		soundVolume = soundVolume + stats:getDrunkenness()
		-- Snore louder if Sick
		soundVolume = soundVolume + stats:getSickness()
		-- Snore louder if Has Cold
		if player:getBodyDamage():isHasACold() then
			soundVolume = soundVolume + 1.2
		end
		print(player:getStats():getDrunkenness())

		if ZombRand(30) == 0 then
			addSound(player, player:getX(), player:getY(), player:getZ(), 100 * soundVolume, 150 * soundVolume); -- range, then volume
			if soundVolume >= 1 then
				if player:isFemale() then
					currentSnoreSound = MarTraits.playSnoreSound("TraitSnorerVoiceFemale1Loud", soundVolume)
				else
					currentSnoreSound = MarTraits.playSnoreSound("TraitSnorerVoiceFemale1Loud", soundVolume)
				end
			else
				if player:isFemale() then
					currentSnoreSound = MarTraits.playSnoreSound("TraitSnorerVoiceFemale1Quiet", soundVolume)
				else
					currentSnoreSound = MarTraits.playSnoreSound("TraitSnorerVoiceFemale1Quiet", soundVolume)
				end
			end
		end
	else
		if currentSnoreSound then
			soundManager:StopSound(currentSnoreSound)
			currentSnoreSound = nil
		end
	end
end

function MarTraits.playSnoreSound(sound, soundVolume)
	if not currentSnoreSound == nil then
		return getSoundManager():PlaySound(sound, true, 2):setVolume(soundVolume)
	end
end

Events.EveryOneMinute.Add(MarTraits.snorerUpdate)