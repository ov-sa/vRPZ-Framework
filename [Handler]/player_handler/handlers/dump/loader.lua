----------------------------------------------------------------
--[[ Resource: Player Handler
     Script: handlers: saver.lua
     Author: vStudio
     Developer(s): Mario, Tron, Aviril
     DOC: 31/01/2022
     Desc: Saver Handler ]]--
----------------------------------------------------------------


-------------------
--[[ Variables ]]--
-------------------

--[[
local initialInventoryItems = {

    variable = {
        {
            minAssignedItems = 1,
            {name = "Crowbar", amount = 1},
            {name = "Hatchet", amount = 1},
            {name = "Knife", amount = 1},
            {name = "Shovel", amount = 1}
        },
        {
            minAssignedItems = 1,
            {name = "Water Bottle", amount = 1},
            {name = "Empty Water Bottle", amount = 1},
            {name = "Beans", amount = 1},
            {name = "Compass", amount = 1},
            {name = "Clock", amount = 1}
        }
    },
    fixed = {
        {name = "Bandage", amount = 1},
        {name = "Morphine", amount = 1},
        {name = "Painkiller", amount = 1},
        {name = "Survivor Suit", amount = 1},
        {name = "GPS", amount = 1},
        {name = "Map", amount = 1},
        {name = "Talon Backpack", amount = 1}
    }

}
]]--


----------------------------------------------
--[[ Function: Loads Default Player Datas ]]--
----------------------------------------------

CCharacter.loadProgress = function(player)
    --[[
    for i, j in ipairs(initialInventoryItems.variable) do
        local currentAssignedItems = 0
        local minAssignedItems = tonumber(j.minAssignedItems)
        if minAssignedItems and (minAssignedItems > 0) and (#j > 0) then
            if minAssignedItems > #j then minAssignedItems = #j end
            local tempItems = j
            for k = 1, minAssignedItems, 1 do
                local generatedItemIndex = math.random(#tempItems)
                local itemDetails, itemCategory = fetchInventoryItem(tempItems[generatedItemIndex].name)
                if itemDetails and itemCategory then
                    player:setData("Item:"..tempItems[generatedItemIndex].name, tempItems[generatedItemIndex].amount)
                end
                table.remove(tempItems, generatedItemIndex)
            end
        end
    end
    for i, j in ipairs(initialInventoryItems.fixed) do
        local itemDetails, itemCategory = fetchInventoryItem(j.name)
        if itemDetails and itemCategory then
            player:setData("Item:"..j.name, j.amount)
            if itemCategory == "Backpack" then
                player:setData("Slot:backpack", j.name)
            end
        end
    end
    ]]--
    return true
end