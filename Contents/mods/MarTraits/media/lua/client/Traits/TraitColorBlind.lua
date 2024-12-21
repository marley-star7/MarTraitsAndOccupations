-- TODO: Do the night vision goggles make you see better? probably work that one out.
function enableColorBlind(player, playerNum)
	player:setWearingNightVisionGoggles(true)
end

local function TraitColorBlindCheck(playerNum, player)
	if player and player:HasTrait("ColorBlind") then
		enableColorBlindOverlay(player, playerNum)
	end
end

Events.OnCreatePlayer.Add(TraitColorBlindCheck)
Events.OnPreUIDraw.Add(TraitColorBlindCheck)