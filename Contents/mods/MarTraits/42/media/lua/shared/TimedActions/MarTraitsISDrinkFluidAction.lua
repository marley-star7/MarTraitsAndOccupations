require ("TimedActions/ISDrinkFluidAction")

-- Just hooks onto these actions, and does the rest of whatever it was gonna do.

local _ISDrinkFluidAction_eat = ISDrinkFluidAction.eat
function ISDrinkFluidAction:eat(...)

	_ISDrinkFluidAction_eat(self, ...)

	if self.item:isAlcoholic() and self.character:HasTrait("Mar_Alcoholic") then
		MarTraits.drinkAlcohol(self.character, self.item)
	end
end

local _ISDrinkFluidAction_perform = ISDrinkFluidAction.perform
function ISDrinkFluidAction:perform(...)

    _ISDrinkFluidAction_perform(self, ...)
	-- TODO: figure out the class or something so that i can check the acohol level.
	if self.item:isAlcoholic() and self.character:HasTrait("Mar_Alcoholic") then
		MarTraits.drinkAlcohol(self.character, self.item)
	end
end

-- The fluid isn't drink if you stop
local _ISDrinkFluidAction_stop = ISDrinkFluidAction.stop
function ISDrinkFluidAction:stop(...)
	
    _ISDrinkFluidAction_stop(self, ...)

	if self.item:isAlcoholic() and self.character:HasTrait("Mar_Alcoholic") then
		MarTraits.drinkAlcohol(self.character, self.item)
	end
end