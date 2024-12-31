MarOccupations = MarOccupations or {}
MarOccupations.defenseTacticsActivate = function(player)
    if not player:HasTrait("DefenseTactics") then return end
    if player:getHitReaction() == "Bite" then
        player:setHitReaction("BiteDefended")
    end
end

Events.OnPlayerGetDamage.Add(MarOccupations.defenseTacticsActivate)