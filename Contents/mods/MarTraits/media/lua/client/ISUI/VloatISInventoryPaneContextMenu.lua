--[[
local function VloatOnFillInventoryObjectContextMenu(playerNum, context, items)
    -- Get context thing.
    map = nil
    literature = nil
    player = getSpecificPlayer(playerNum)

    -- Loop through the items.
    for i,v in ipairs(items) do
        testItem = v
        if not instanceof(v, "InventoryItem") then

            if #v.items == 2 then
                editItem = v.items[1]
            end
            testItem = v.items[1]
        else
            editItem = v
        end

        if testItem:IsMap() then
            map = testItem
        elseif testItem:getCategory() == "Literature" then
            literature = testItem
        end

        -- TODO: Really? the "getOptionFromName" "name" is actually just the text used in game? Does that mean this breaks on translation???
        if player:HasTrait("blind") then
            if map then
                contextMenuCheckMap = context:getOptionFromName("Read Map")
                contextMenuCheckMap.notAvailable = true
                local tooltip = ISInventoryPaneContextMenu.addToolTip()
                tooltip.description = getText("ContextMenu_Blind")
                contextMenuCheckMap.tooltip = tooltip
            end
            if literature then
                contextMenuRead = context:getOptionFromName("Read")
                contextMenuRead.notAvailable = true
                local tooltip = ISInventoryPaneContextMenu.addToolTip()
                tooltip.description = getText("ContextMenu_Blind")
                contextMenuRead.tooltip = tooltip
            end
        end
    end
end

Events.OnFillInventoryObjectContextMenu.Add(VloatOnFillInventoryObjectContextMenu)
]]--