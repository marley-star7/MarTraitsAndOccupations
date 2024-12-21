MarTraits = MarTraits or {}

local float totalUnhappynessEarnedFromGuns = 0
local float maxTotalUnhappynessEarnedFromGuns = 1500
local float unhappynessEarnedFromGuns = 0.1
local float maxUnhappynessEarnedFromGuns = 60
local boolean antiGunEarnsStress = true
local boolean antiGunEarnsPanic = true

-- TODO: This whole thing is quite poorly made.

function TraitAntiGunEveryOneMinute()
	player = getPlayer()
	if not player:HasTrait("AntiGun") then return end

	if player:getPrimaryHandItem() ~= nil then
		if player:getPrimaryHandItem():getSubCategory() == "Firearm" then
			if player:getCurrentState() == PlayerAimState.instance() or player:getCurrentState() == PlayerStrafeState.instance() then
				bodyDamage = player:getBodyDamage()
				unhappyness = bodyDamage:getUnhappynessLevel()
				if unhappyness <= maxUnhappynessEarnedFromGuns/2 then -- You can only gain so much unhappyness from simply aiming a gun
					bodyDamage:setUnhappynessLevel(unhappyness + unhappynessEarnedFromGuns)
					totalUnhappynessEarnedFromGuns = totalUnhappynessEarnedFromGuns + unhappynessEarnedFromGuns
				end
			end
		end
	end
end

function TraitAntiGunEveryHours()
	-- Player will gain less and less unhappyness from guns until no more
	-- Yes I know this is a fugly asf method of calculating this but I'm lazy so
	-- TODO: Probably rework this method of caculating unhappyness; it has not been properly tested at all.
	if totalUnhappynessEarnedFromGuns >= maxTotalUnhappynessEarnedFromGuns then
		unhappynessEarnedFromGuns = 0.001
		maxUnhappynessEarnedFromGuns = 10
	elseif totalUnhappynessEarnedFromGuns >= maxTotalUnhappynessEarnedFromGuns/2 then
		unhappynessEarnedFromGuns = 0.005
		maxUnhappynessEarnedFromGuns = 20
	elseif totalUnhappynessEarnedFromGuns >= maxTotalUnhappynessEarnedFromGuns/3 then
		unhappynessEarnedFromGuns = 0.025
		maxUnhappynessEarnedFromGuns = 30
	elseif totalUnhappynessEarnedFromGuns >= maxTotalUnhappynessEarnedFromGuns/5 then
		unhappynessEarnedFromGuns = 0.05
		maxUnhappynessEarnedFromGuns = 40
		antiGunEarnsStress = false
	elseif totalUnhappynessEarnedFromGuns >= maxTotalUnhappynessEarnedFromGuns/10 then
		unhappynessEarnedFromGuns = 0.075
		maxUnhappynessEarnedFromGuns = 50
		antiGunEarnsPanic = false
	else
		unhappynessEarnedFromGuns = 0.1
		maxUnhappynessEarnedFromGuns = 60
		antiGunEarnsStress = true
		antiGunEarnsPanic = true
	end
end

function TraitAntiGunOnPlayerAttackFinished(player, weapon)
	if not player:HasTrait("AntiGun") then return end
	if weapon:getSubCategory() == "Firearm" then
		if player:getCurrentState() == PlayerAimState.instance() or player:getCurrentState() == PlayerStrafeState.instance() then
			bodyDamage = player:getBodyDamage()
			unhappyness = bodyDamage:getUnhappynessLevel()
			if unhappyness <= maxUnhappynessEarnedFromGuns then
				bodyDamage:setUnhappynessLevel(unhappyness + unhappynessEarnedFromGuns * 100)
				if antiGunEarnsStress then
					player:getStats():setStress(player:getStats():getStress() + .2)
				end
				if antiGunEarnsPanic then
					player:getStats():setPanic(player:getStats():getPanic() + 30)
				end
				totalUnhappynessEarnedFromGuns = totalUnhappynessEarnedFromGuns + unhappynessEarnedFromGuns * 20
			end
		end
	end
end

function TraitAntiGunOnLevelPerk(player, perk, perkLevel)
	if not player:HasTrait("AntiGun") then return end
	if perk == Perks.Aiming then
		if perkLevel >= 6 then
			player:getTraits():remove("AntiGun")
			print("Anti-Gun Trait Removed")
		end
	end
end

function TraitAntiGunAddXp(player, perk, amount)
	if not player:HasTrait("AntiGun") then return end

	local modifier = -0.5;
	if perk == Perks.Aiming or perk == Perks.Reloading then
		print("Xp amount: " .. amount);
		amount = amount * modifier
		player:getXp():AddXP(perk, amount, false, false, false);
		print("Cruel newamount: " .. amount);
	end
end

Events.EveryOneMinute.Add(TraitAntiGunEveryOneMinute)
Events.OnPlayerAttackFinished.Add(TraitAntiGunOnPlayerAttackFinished)
Events.EveryHours.Add(TraitAntiGunEveryHours)
Events.LevelPerk.Add(TraitAntiGunOnLevelPerk)
Events.AddXP.Add(TraitAntiGunAddXp)
