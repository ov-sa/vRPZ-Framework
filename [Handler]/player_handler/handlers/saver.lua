----------------------------------------------------------------
--[[ Resource: Player Handler
     Script: handlers: saver.lua
     Author: vStudio
     Developer(s): Mario, Tron
     DOC: 31/01/2022
     Desc: Saver Handler ]]--
----------------------------------------------------------------

--TODO: ... UPDATE

-----------------
--[[ Imports ]]--
-----------------

local imports = {
    addEventHandler = addEventHandler
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

    if not player or not isElement(player) or player:getType() ~= "player" or not isPlayerInitialized(player) then return false end

    --clearPlayerAllEquipmentSlots(player)
    --TODO: RESET ALL INVENTORY DATAS SOMEHOW... add another function clearPlayerAllInventory
    --[[
    for i, j in pairs(inventoryDatas) do
        for k, v in ipairs(j) do
            player:setData("Item:"..v.dataName, 0)
        end
    end
    ]]--
    --[[
    for i, j in ipairs(initialPlayerDatas) do
        local amount = j.amount
        if j.name == "Character:blood" then
            amount = getPlayerMaximumHealth(player)
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
                local itemDetails, itemCategory = getItemDetails(tempItems[generatedItemIndex].name)
                if itemDetails and itemCategory then
                    player:setData("Item:"..tempItems[generatedItemIndex].name, tempItems[generatedItemIndex].amount)
                end
                table.remove(tempItems, generatedItemIndex)
            end
        end
    end
    for i, j in ipairs(initialInventoryItems.fixed) do
        local itemDetails, itemCategory = getItemDetails(j.name)
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


-------------------------------------------------
--[[ Events: On Client Character Delete/Save ]]--
-------------------------------------------------

imports.addEvent("onClientCharacterDelete", true)
imports.addEventHandler("onClientCharacterDelete", root, function(characterID)
    characterID = tonumber(characterID)
    if not characterID or not characterCache[characterID] then return false end

    delSerialCharacter(characterID)
end)

imports.addEvent("onClientCharacterSave", true)
imports.addEventHandler("onClientCharacterSave", root, function(character, characters, unsavedCharacters)
    character = tonumber(character)
    if not character or not characters or not unsavedCharacters then return false end

    local serial = source:getSerial()
    for i, j in pairs(unsavedCharacters) do
        if characters[i] then
            for k, v in pairs(characterCache) do
                if v.identity["name"] == characters[i]["name"] then
                    triggerClientEvent(source, "onClientLoginUIEnable", source, true, true)
                    triggerClientEvent(source, "onClientRecieveCharacterSaveState", source, false, "Unfortunately, '"..characters[i]["name"].."' is already registered!", i)
                    return false
                end
            end
            local characterID = addSerialCharacter(serial)
            setCharacterData(characterID, "identity", toJSON(characters[i]))
            characterCache[characterID]["identity"] = fromJSON(characterCache[characterID]["identity"])
            triggerClientEvent(source, "onClientLoadCharacterID", source, i, characterID, characters[i])
        end
    end
    exports.serials_library:setSerialData(serial, "character", character)
    triggerClientEvent(source, "onClientRecieveCharacterSaveState", source, true)
end)


------------------------------------
--[[ Player: On Toggle Login UI ]]--
------------------------------------

imports.addEvent("Player:onToggleLoginUI", true)
imports.addEventHandler("Player:onToggleLoginUI", root, function()
    source:setName(getVoidGuestNick())
    local serial = source:getSerial()
    local lastCharacter = tonumber(exports.serials_library:getSerialData(serial, "character")) or 0
    local lastCharacters, serialCharacters = {}, getCharactersBySerial(serial)
    local isPlayerPremium = exports.serials_library:getSerialData(serial, "premimum")

    for i, j in ipairs(serialCharacters) do
        local _characterData = table.copy(characterCache[j].identity, true)
        _characterData._id = j
        table.insert(lastCharacters, _characterData)
    end
    if not lastCharacters[lastCharacter] then lastCharacter = 0 end
    source:setFrozen(true)
    triggerClientEvent(source, "onPlayerShowLoadingScreen", source, true)
    triggerClientEvent(source, "onPlayerShowLoginScreen", source, lastCharacter, lastCharacters, isPlayerPremium)
end)


-------------------------------------------
--[[ Function: Saves Player's Progress ]]--
-------------------------------------------

function savePlayerProgress(player, isClientQuitting)
    if not player or not isElement(player) or player:getType() ~= "player" or not isPlayerInitialized(player) then return false end

    local serial = player:getSerial()
    local posVector = player:getPosition()
    local rotVector = player:getRotation()
    local characterID = player:getData("Character:ID")
    local characterIdentity = getCharacterData(characterID, "identity")
    if player:isInWater() then posVector.z = posVector.z + 5 end

    setCharacterData(characterID, "location", toJSON({x = posVector.x, y = posVector.y, z = posVector.z, rotation = rotVector.z}))
    for i, j in ipairs(FRAMEWORK_CONFIGS["Player"]["Datas"]) do
        local data = tostring(player:getData("Player:"..j))
        exports.serials_library:setSerialData(serial, j, data)
    end
    for i, j in ipairs(FRAMEWORK_CONFIGS["Character"]["Datas"]) do
        local data = tostring(player:getData("Character:"..j))
        setCharacterData(characterID, j, data)
    end

    if playerAttachments[player] then
        for i, j in pairs(playerAttachments[player]) do
            if j and isElement(j) then
                j:destroy()
            end
        end
    end
    playerAttachments[player] = nil
    playerInventorySlots[player] = nil
    if not isClientQuitting then
        player:setData("Player:Initialized", nil)
        player:setData("Character:ID", nil)
        for i, j in pairs(characterIdentity) do
            player:setData("Character:"..i, nil)
        end
        for i, j in pairs(FRAMEWORK_CONFIGS["Inventory"]["Slots"]) do
            player:setData("Slot:"..i, nil)
            player:setData("Slot:Object:"..i, nil)
        end
        for i, j in ipairs(FRAMEWORK_CONFIGS["Player"]["Datas"]) do
            player:setData("Player:"..j, nil)
        end
        for i, j in ipairs(FRAMEWORK_CONFIGS["Character"]["Datas"]) do
            player:setData("Character:"..j, nil)
        end
        for i, j in pairs(FRAMEWORK_CONFIGS["Inventory"]["Items"]) do
            for k, v in pairs(j) do
                player:setData("Item:"..k, nil)
            end
        end
    end
    return true
end