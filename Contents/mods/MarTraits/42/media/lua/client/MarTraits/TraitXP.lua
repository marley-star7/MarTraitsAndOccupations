local function marTraitAddXp(player, perk, amount)

	-- TODO: add sandbox settings for these modifiers.
	local creative = player:HasTrait("Mar_Creative")
	local uncreative = player:HasTrait("Mar_Uncreative")

	if creative or uncreative then
		local modifier = 0
		if creative then 
			modifier = 0.25
		else
			modifier = -0.25
		end

		if perk == Perks.Woodwork -- Carpentry
		or perk == Perks.Carving
		or perk == Perks.Cooking
		or perk == Perks.Electricity
		or perk == Perks.Glassmaking
		or perk == Perks.FlintKnapping -- Knapping
		or perk == Perks.Masonry
		or perk == Perks.Blacksmith -- Metalworking
		or perk == Perks.Mechanics
		or perk == Perks.Pottery
		or perk == Perks.Tailoring
		or perk == Perks.MetalWelding -- Welding
		then
			amount = amount * modifier
			player:getXp():AddXPNoMultiplier(perk, amount)
		end
	end

	if player:HasTrait("Mar_Artist") then
		local modifier = 0.35

		if perk == Perks.Woodwork -- Carpentry
		or perk == Perks.Carving
		or perk == Perks.Cooking
		or perk == Perks.Electricity
		or perk == Perks.Glassmaking
		or perk == Perks.FlintKnapping -- Knapping
		or perk == Perks.Masonry
		or perk == Perks.Blacksmith -- Metalworking
		--or perk == Perks.Mechanics -- You aren't really expressing yourself artistically with mechanics unlike the others.
		or perk == Perks.Pottery
		or perk == Perks.Tailoring
		or perk == Perks.MetalWelding -- Welding
		then
			amount = amount * modifier
			player:getXp():AddXPNoMultiplier(perk, amount)
		end
	end

	if (player:HasTrait("Mar_WarMonger")) then
		-- For some reason base game "Reluctant Fighter" / "Pacifist" you lose maintenance so I guess for consistency we do it here as well.
		local modifier = 0.25

		if perk == Perks.Axe
		or perk == Perks.SmallBlunt
		or perk == Perks.Blunt
		or perk == Perks.SmallBlade
		or perk == Perks.LongBlade
		or perk == Perks.Spear
		or perk == Perks.Aiming
		or perk == Perks.Maintenance
		then
			amount = amount * modifier
			player:getXp():AddXPNoMultiplier(perk, amount)
		end
	end
end

Events.AddXP.Add(marTraitAddXp)