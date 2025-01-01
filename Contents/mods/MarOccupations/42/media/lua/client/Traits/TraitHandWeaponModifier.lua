local sledgehammerEnduranceModAdjustment = -1.5
local sledgehammerBaseSpeedAdjustment = 0.25
--local sledgehammerSwingTimeAdjustment = 0 -- For some reason not what sets swing time?
--local sledgehammerStrainModifierAdjustment = -0.25

local pickaxeEnduranceModAdjustment = 0
local pickaxeBaseSpeedAdjustment = 0.25

local itemTraitStates = 
{
    Demoman = "Mar_Demoman",
    PickaxeMan = "Mar_PickaxeMan",
    Normal = "Mar_Normal",
}

local sledgehammers = 
{
    ["Sledgehammer"] = true,
    ["Sledgehammer2"] = true ,
    ["SledgehammerForged"] = true,
}

local pickaxes = 
{
    ["PickAxe"] = true,
    ["PickAxeForged"] = true,
}

local function itemTypeIsOfTypes(itemTypeName, itemNameList)
    return itemNameList[itemTypeName] == true
end

local function setItemStateNormal(item)
    print("Player weapon data different from normal, changing item stats.")
    local itemModData = item:getModData()
    local enduranceModNormal = item:getEnduranceMod() - (itemModData.fMarTraitsEnduranceModAdjustment or 0)
    local baseSpeedNormal = item:getBaseSpeed() - (itemModData.fMarTraitsBaseSpeedAdjustment or 0)

    item:setEnduranceMod(enduranceModNormal)
    item:setBaseSpeed(baseSpeedNormal)
    itemModData.sMarTraitsState = itemTraitStates.Normal
end

local function traitHandWeaponModifier(player)
    player = getPlayer() -- For some reason need this to work...
    if player:getPrimaryHandItem() then
        local item = player:getPrimaryHandItem()
        local itemModData = item:getModData()
        local itemType = item:getType()

        if item:IsWeapon() then
            -- Sledgehammer
            if itemTypeIsOfTypes(itemType, sledgehammers) then

                local needsDemoChange = player:HasTrait("Mar_Demoman") --and itemModData.sMarTraitsState ~= itemTraitStates.Demoman
                local needsNormalChange = (not player:HasTrait("Mar_Demoman")) --and itemModData.sMarTraitsState ~= itemTraitStates.Normal

                local enduranceModNormal = item:getEnduranceMod() - (itemModData.fMarTraitsEnduranceModAdjustment or 0)
                local baseSpeedNormal = item:getBaseSpeed() - (itemModData.fMarTraitsBaseSpeedAdjustment or 0)

                if needsDemoChange then
                    print("Player has trait Demoman and weapon data not set, changing item stats.")
                    item:setEnduranceMod(enduranceModNormal + sledgehammerEnduranceModAdjustment)
                    item:setBaseSpeed(baseSpeedNormal + sledgehammerBaseSpeedAdjustment)
                    itemModData.sMarTraitsState = itemTraitStates.Demoman
                elseif needsNormalChange then
                    setItemStateNormal(item)
                end
                
                -- Save the adjusted values.
                itemModData.fMarTraitsEnduranceModAdjustment = item:getEnduranceMod() - enduranceModNormal
                itemModData.fMarTraitsBaseSpeedAdjustment = item:getBaseSpeed() - baseSpeedNormal
            end

            -- Pickaxe
            if itemTypeIsOfTypes(itemType, pickaxes) then
                
                local needsPickaxeChange = player:HasTrait("Mar_PickaxeMan")
                local needsNormalChange = (not player:HasTrait("Mar_PickaxeMan"))

                local enduranceModNormal = item:getEnduranceMod() - (itemModData.fMarTraitsEnduranceModAdjustment or 0)
                local baseSpeedNormal = item:getBaseSpeed() - (itemModData.fMarTraitsBaseSpeedAdjustment or 0)

                if needsPickaxeChange then
                    print("Player has trait PickaxeMan and weapon data not set, changing item stats.")
                    item:setEnduranceMod(enduranceModNormal + pickaxeEnduranceModAdjustment)
                    item:setBaseSpeed(baseSpeedNormal + pickaxeBaseSpeedAdjustment)
                    itemModData.sMarTraitsState = itemTraitStates.PickaxeMan
                elseif needsNormalChange then
                    setItemStateNormal(item)
                end
                
                -- Save the adjusted values.
                itemModData.fMarTraitsEnduranceModAdjustment = item:getEnduranceMod() - enduranceModNormal
                itemModData.fMarTraitsBaseSpeedAdjustment = item:getBaseSpeed() - baseSpeedNormal
            end
        end
    end
end

Events.OnEquipPrimary.Add(
    function(char, item) 
        traitHandWeaponModifier(char) 
    end
)

Events.OnCreatePlayer.Add(
    function(playerNum, player) 
        traitHandWeaponModifier(player)
    end
)

--[[
local function demomanOnWeaponSwing(player, weapon)
    if player:getPrimaryHandItem() then
        local item = player:getPrimaryHandItem()
        local itemModData = item:getModData()
        local itemType = player:getPrimaryHandItem():getType()

        if item:IsWeapon() then
            -- Sledgehammer
            if itemTypeIsSledgehammer(itemType) then
                weapon:muscl
                player:addCombatMuscleStrain(weapon, -99)
            end
        end
    end
end

Events.OnWeaponSwing.Add(demomanOnWeaponSwing)
]]--