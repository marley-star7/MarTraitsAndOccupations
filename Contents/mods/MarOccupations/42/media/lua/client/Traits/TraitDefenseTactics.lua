require("MarLibrary.Events")
require("MarLibrary.lua")

MarOccupations = MarOccupations or {}

local currentZombieAttackersList = {}

local function addZombieAttackingPlayerToDropQueue(player, zombieToAdd)
    -- Check if zombie is already in the queue
    for _, zombieInQueue in ipairs(currentZombieAttackersList) do
        if zombieInQueue == zombieToAdd then
            return  -- Zombie is already in the queue, exit
        end
    end

    -- Zombie not in queue, add it
    table.insert(currentZombieAttackersList, zombieToAdd)

    -- Set up a delayed function to drop the zombie after a short delay
    MarLibrary.delayFuncByDelta(function(player, zombieToDrop, zombieAttackerList)
        -- Ensure the zombie is the most recent one attacking the player, and player is still in attack with it.
        local size = #currentZombieAttackersList
        if zombieToDrop == currentZombieAttackersList[size] and player:getHitReaction() == "BiteFast" then
            -- Apply stagger, knockdown, and hit reactions to the zombie
            --zombieToDrop:setStaggerBack(true)
            --zombieToDrop:setHitForce(2.0)
            -- Wait a little longer to knock them down.
            MarLibrary.delayFuncByDelta(function(zombieToDrop)
                zombieToDrop:setKnockedDown(true)
                zombieToDrop:setHitReaction("")
                zombieToDrop:setHitForce(2.0)
                end,
                0.3,
                zombieToDrop
            )
        end
        -- Remove the zombie from the drop list.
        for i = 1, size do
            if currentZombieAttackersList[i] == zombieToDrop then
                table.remove(currentZombieAttackersList, i)
            end
        end
    end, 
    0.3, -- Time after
    player, zombieToAdd, currentZombieAttackersList -- this is the zombie to drop parameter.
)

    --[[
    print(attacker:getAttackOutcome())
    attacker:setAttackDidDamage(false)
    --attacker:setAttackOutcome("fail")
    ]]--
end

MarOccupations.defenseTacticsActivate = function(player)
    if not player:HasTrait("Mar_DefenseTactics") then return end
    local attacker = player:getAttackedBy()
    if attacker:isZombie() then
        print(attacker:getAttackOutcome())
    end

    local bite = false
    local biteDefend = false
    if player:getHitReaction() == "Bite" then bite = true end
    if player:getHitReaction() == "BiteDefend" then biteDefend = true end

	if bite then
		player:setHitReaction("BiteFast")
    elseif biteDefend then
		player:setHitReaction("BiteDefendFast")
	else return end -- Do not continue to zombie stuff.

    if attacker:isZombie() then
        addZombieAttackingPlayerToDropQueue(player, attacker)
    end
end

MarLibrary.Events.OnZombieGrabBiteAttemptOnPlayer:Add("defenseTacticsActivate", MarOccupations.defenseTacticsActivate)