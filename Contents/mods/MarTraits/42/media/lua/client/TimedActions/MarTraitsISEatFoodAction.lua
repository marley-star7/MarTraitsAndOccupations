require ("ISEatFoodAction.lua")

-- Just hooks onto these actions, and does the rest of whatever it was gonna do.
local _ISEatFoodAction_perform = ISEatFoodAction.perform
function ISEatFoodAction:perform(...)

    _ISEatFoodAction_perform(self, ...)

	if self.item:isAlcoholic() and self.character:HasTrait("Mar_Alcoholic") then
		MarTraits.drinkAlcohol(self.character, self.item)
	end
end

local _ISEatFoodAction_stop = ISEatFoodAction.stop
function ISEatFoodAction:stop(...)
	
    _ISEatFoodAction_stop(self, ...)

	if self.item:isAlcoholic() and self.character:HasTrait("Mar_Alcoholic") then
		MarTraits.drinkAlcohol(self.character, self.item)
	end
end