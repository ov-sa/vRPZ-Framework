----------------------------------------------------------------
--[[ Resource: Player Handler
     Script: handlers: saver.lua
     Author: vStudio
     Developer(s): Mario, Tron, Aviril
     DOC: 31/01/2022
     Desc: Saver Handler ]]--
----------------------------------------------------------------

--TODO: ... UPDATE

-----------------
--[[ Imports ]]--
-----------------

local imports = {
    addEvent = addEvent,
    addEventHandler = addEventHandler,
}


-------------------
--[[ Variables ]]--
-------------------

local initialPlayerDatas = {
    {name = "Character:pain", amount = 0},
    {name = "Character:cold", amount = 0},
    {name = "Character:hunger", amount = 100},
    {name = "Character:thirst", amount = 100},
    {name = "Character:blood", amount = nil},
    {name = "Character:bleeding", amount = 0},
    {name = "Character:infection", amount = 0},
    {name = "Character:brokenbone", amount = 0},
    {name = "Character:temperature", amount = 38}
}

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

function loadPlayerDefaultDatas(player)
    if not CPlayer.isInitialized(player) then return false end

    CCharacter.loadProgress(player, true)
    --[[
    for i, j in ipairs(initialPlayerDatas) do
        local amount = j.amount
        if j.name == "Character:blood" then
            amount = getCharacterMaximumHealth(player)
        else
            if amount and type(amount) == "function" then
                amount = amount()
            end
        end
        player:setData(j.name, amount)
    end
    ]]
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