
require('NPCs/MainCreationMethods');
-- Learn how to delete this stuff after the code has ran and is done.
local float targetX = 0;
local float targetY = 0;
local float targetZ = .1;

function AttemptTeleportPlayer()
	local player = getPlayer();
	local spawnAttempts = 0;
	player:setX(targetX);
	player:setY(targetY);
	player:setZ(targetZ);
	--[[
	repeat
		player:setX(targetX);
		player:setY(targetY);
		player:setZ(targetZ);
		spawnAttempts = spawnAttempts + 1;
		print("Player random spawn teleport attempted:", spawnAttempts " times.");
	until (player:getX() == targetX and player:getY() == targetX and player.getZ == targetZ)
	print("Random spawn teleport success! Teleported player to : " .. targetX .. "," .. targetY "," .. targetZ);
	--]]
	-- Stops this code from running all the time, your cpu will thank you..
	Events.OnTick.Remove(AttemptTeleportPlayer);
end

function FindRandomValidSpawnPosition(player)
	local world = getWorld()
	local metaGrid = world:getMetaGrid()

	repeat
		local targetX = ZombRand(0, metaGrid:getMaxX() * 300)
		local targetY = ZombRand(0, metaGrid:getMaxY() * 300)
	until (world:isValidSquare(targetX, targetY, 0))
	repeat
		targetZ = ZombRand(.1, metaGrid:getHeight());
		-- We find the Z height to spawn after finding a valid X and Y so this runs more efficient.
		-- Most Z heights are not valid besides 0 so this just checks that if there is one above that have a chance to spawn there
	until (world:isValidSquare(targetX, targetY, targetZ)) -- Current PZ build only supports 7 floors high so possible Z height is set to that.
	-- Begin attempting to teleport player to location.

	Events.OnTick.Add(AttemptTeleportPlayer);
	-- Remove all items.
	player:clearWornItems();
	player:getInventory():removeAllItems();
	--player:createKeyRing();
end

--[[
		targetX = ZombRand(worldMap:getMinXInSquares(), worldMap:getMaxXInSquares());
		targetY = ZombRand(worldMap:getMinYInSquares(), worldMap:getMaxYInSquares());
		--spawnSquare = cell:getGridSquare(targetX, targetY, 0);
	--until (spawnSquare ~= null and spawnSquare:isSafeToSpawn())
]]--

function DeprivedDebugKey()
	if key == Keyboard.KEY_F9  then
		local player = _player;
		FindRandomValidSpawnPosition(player);
	end
end

