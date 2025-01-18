-- Just hooks onto these actions, and does the rest of whatever it was gonna do.

-- TODO: hook onto drinkfluid isocharacter stuff instead...
-- TODO: don't know how to check if item is alcoholic or not, seems isAlcoholic broke in b42, fix l8ter...
local _ISDrinkFluidAction_eat = ISDrinkFluidAction.eat
function ISDrinkFluidAction:eat(...)

	_ISDrinkFluidAction_eat(self, ...)

	if self.character:HasTrait("Mar_Alcoholic") then
		MarTraits.drinkAlcohol(self.character, self.item)
	end
end

local _ISDrinkFluidAction_perform = ISDrinkFluidAction.perform
function ISDrinkFluidAction:perform(...)

    _ISDrinkFluidAction_perform(self, ...)

	if self.character:HasTrait("Mar_Alcoholic") then
		MarTraits.drinkAlcohol(self.character, self.item)
	end
end

-- The fluid isn't drink if you stop
local _ISDrinkFluidAction_stop = ISDrinkFluidAction.stop
function ISDrinkFluidAction:stop(...)
	
    _ISDrinkFluidAction_stop(self, ...)

	if self.character:HasTrait("Mar_Alcoholic") then
		MarTraits.drinkAlcohol(self.character, self.item)
	end
end