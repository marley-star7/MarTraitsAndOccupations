MarTraits = MarTraits or {}
-- MoreTraits ran this every hour.
-- But I can't think of a scenario where you wouldn't load into the the game and not have every recipe already on that run.
-- Even when a new mod is added I'm fairly certain OnCreatePlayer runs whenever the game starts up, so its gucci?
-- Sooo... TODO: Figure out if this teaches you modded recipes properly.

MarTraits.traitIngenuitiveLearnRecipes = function(player)
	player = getPlayer()
	if not player:HasTrait("ingenuitive") then return end

	local recipes = getScriptManager():getAllRecipes()
	for i = recipes:size() - 1, 0, -1 do
		local recipe = recipes:get(i);
		if recipe:needToBeLearn() == true then
			if player:isRecipeKnown(recipe) == false then
				player:learnRecipe(recipe:getOriginalname())
			end
		end
	end
end

Events.OnCreatePlayer.Add(MarTraits.traitIngenuitiveLearnRecipes)