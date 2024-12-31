local function marTraitAddXp(player, perk, amount)
	if (player:HasTrait("Mar_Artist")) then
		-- For some reason base game "Reluctant Fighter" / "Pacifist" you lose maintenance so I guess for consistency we do it here as well.
		local artistModifier = 0.25;
		if perk == Perks.Woodwork -- Carpentry
		or perk == Perks.Carving
		or perk == Perks.Cooking
		or perk == Perks.Electricity
		or perk == Perks.Glassmaking
		or perk == Perks.FlintKnapping -- Knapping
		or perk == Perks.Masonry
		or perk == Perks.Blacksmith -- Metalworking
		-- or perk == Perks.Mechanics -- You aren't really expressing yourself artistically with mechanics unlike the others.
		or perk == Perks.Pottery
		or perk == Perks.Tailoring
		or perk == Perks.MetalWelding -- Welding
		then
			amount = amount * artistModifier
			player:getXp():AddXP(perk, amount, false, false, false)
		end
	end

	if (player:HasTrait("Mar_WarMonger")) then
		-- For some reason base game "Reluctant Fighter" / "Pacifist" you lose maintenance so I guess for consistency we do it here as well.
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
end

Events.AddXP.Add(marTraitAddXp)