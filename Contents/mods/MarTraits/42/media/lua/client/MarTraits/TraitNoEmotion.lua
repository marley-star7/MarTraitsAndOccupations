-- Alot of code for this one huh?
local function noEmotionUpdate(player)
	if not (player:HasTrait("Mar_NoEmotion")) then return end

	local stats = player:getStats()
    local bodyDamage = player:getBodyDamage()
    bodyDamage:setUnhappynessLevel(0)
    stats:setPanic(0)
end

Events.OnPlayerUpdate.Add(noEmotionUpdate)