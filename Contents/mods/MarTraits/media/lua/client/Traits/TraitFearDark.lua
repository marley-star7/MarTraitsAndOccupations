MarTraits = MarTraits or {}

local float fearDarkPanic = 0
-- TODO: General code cleanup and stuff, also find out how the interaction with Cat Eyes trait is going to work, wether incompatible or helps this trait.
function MarTraits.fearDarkUpdate(player)
	if player:HasTrait("Nyctophobic") == false then
		return
	end

	local playerSquareLightLevel = player:getSquare():getLightLevel(player:getPlayerNum())
	local stats = player:getStats()
	local panic = stats:getPanic()
	local float fearDarkPanicDest = 0
	local float fearDarkThreshold = 0.75
	-- From testing it appears that stress scales from 0 to 1 with 1 being max stress.
	-- Light levels also go from 0 to 1 so we reverse that value to build up to stress on lower light levels.
	-- With that the threshold decides the light level value to start building stress at.
	if playerSquareLightLevel < fearDarkThreshold then -- Starts growing the stress.
		fearDarkPanicDest = ((fearDarkThreshold - playerSquareLightLevel)/fearDarkThreshold) * 200
	else
		fearDarkPanicDest = 0
	end
	local fearDarkPanicLastAdded = fearDarkPanic
	fearDarkPanic = PZMath.lerp(panic, panic - fearDarkPanicLastAdded + fearDarkPanicDest, 0.01) -- Will lerp to zero if no destination set this frame.
	stats:setPanic(fearDarkPanic)
end

Events.OnPlayerUpdate.Add(MarTraits.fearDarkUpdate)

-- TODO: General code cleanup and stuff, also find out how the interaction with Cat Eyes trait is going to work, wether incompatible or helps this trait.