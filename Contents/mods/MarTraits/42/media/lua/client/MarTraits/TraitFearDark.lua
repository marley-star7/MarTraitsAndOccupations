-- If this value goes too low it will struggle to keep up with the natural panic loss
local fearDarkPanicReachSpeed = 0.5

-- TODO: add check for where your character is looking as well, so even if you have a big light source on you, you can still be scared if its generally dark elsewhere.
local function fearDarkUpdate(player)
	if not (player:HasTrait("Mar_Nyctophobic")) then return end

	local playerSquare = player:getSquare()
	local playerSquareLightLevel = playerSquare:getLightLevel(player:getPlayerNum())
	local stats = player:getStats()
	local currentPanic = stats:getPanic()
	local fearDarkPanicDest = 0
	local fearDarkThreshold = 0.75
	-- From testing it appears that stress scales from 0 to 1 with 1 being max stress.
	-- Light levels also go from 0 to 1 so we reverse that value to build up to stress on lower light levels.
	-- With that the threshold decides the light level value to start building stress at.
	if playerSquareLightLevel < fearDarkThreshold then -- Starts growing the stress.
		fearDarkPanicDest = ((fearDarkThreshold - playerSquareLightLevel)/fearDarkThreshold) * 200
	else
		fearDarkPanicDest = 0
	end

	local playerModData = player:getModData()
	local delta = getGameTime():getTimeDelta() -- So it doesn't change with frame rate.

	-- Get the old fear dark panic and lerp it towards current desired,
	local panicLast = playerModData.fMarTraitsPanicLastFearDarkUpdate or 0
	local newPanic = PZMath.lerp(currentPanic, currentPanic - panicLast + fearDarkPanicDest, fearDarkPanicReachSpeed * delta) -- Will lerp to zero if no destination set this frame.
	stats:setPanic(newPanic)
	playerModData.fMarTraitsPanicLastFearDarkUpdate = newPanic

	--print(fearDarkPanicDest)
end

Events.OnPlayerUpdate.Add(fearDarkUpdate)