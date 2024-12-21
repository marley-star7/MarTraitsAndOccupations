MarTraits = MarTraits or {}

function MarTraits.leadFootUpdate(player)
	local shoes = player:getClothingItem_Feet()
	local itemdata = nil
	if shoes ~= nil then
		itemdata = shoes:getModData()
		local origstomp = itemdata.origStomp
		if origstomp == nil then
			origstomp = shoes:getStompPower()
			itemdata.origStomp = origstomp
			itemdata.stompState = "Normal"
		end

		if player:HasTrait("LeadFoot") then
			if itemdata.stompState ~= "LeadFoot" then
				local newstomp = origstomp + SandboxVars.MarTraits.StompTraitBonus
				shoes:setStompPower(newstomp)
				itemdata.stompState = "LeadFoot"
			end
		else
			if shoes:getStompPower() ~= origstomp then
				shoes:setStompPower(origstomp)
				itemdata.stompState = "Normal"
			end
		end
	end
end

-- TODO: Change this to maybe run just whenever you swap shoes?
-- Currently this runs whenever you kill a zombie.
Events.OnCharacterDeath.Add(MarTraits.leadFootUpdate)