function TraitCruelAddXp(player, perk, amount)
	if not player:HasTrait("Cruel") then return end

	-- For some reason base game Pacifist you lose maintenance sooo I guess for consistency we do it here as well.
	local cruelModifier = 0.25;
	if perk == Perks.Axe
	or perk == Perks.SmallBlunt
	or perk == Perks.Blunt
	or perk == Perks.SmallBlade
	or perk == Perks.LongBlade
	or perk == Perks.Spear
	or perk == Perks.Aiming
	or perk == Perks.Maintenance
	then
		amount = amount * cruelModifier
		player:getXp():AddXP(perk, amount, false, false, false)
	end
end

Events.AddXP.Add(TraitCruelAddXp)