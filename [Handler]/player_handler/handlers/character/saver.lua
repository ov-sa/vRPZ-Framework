----------------------------------------------------------------
--[[ Resource: Player Handler
     Script: handlers: character: saver.lua
     Author: vStudio
     Developer(s): Mario, Tron
     DOC: 31/01/2022
     Desc: Character Saver ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local imports = {
    pairs = pairs,
    ipairs = ipairs,
    tostring = tostring,
    isElement = isElement,
    destroyElement = destroyElement,
    getElementPosition = getElementPosition,
    getElementRotation = getElementRotation
}


-------------------------
--[[ Character Class ]]--
-------------------------

CCharacter.saveProgress = function(player, isClientQuitting)
    if not isPlayerInitialized(player) then return false end

    local serial = player:getSerial()
    local posVector = imports.getElementPosition(player)
    local rotVector = imports.getElementRotation(player)
    local characterID = player:getData("Character:ID")
    local characterIdentity = getCharacterData(characterID, "identity")
    if player:isInWater() then posVector.z = posVector.z + 5 end
    CCharacter.setData(characterID, "location", toJSON({x = posVector.x, y = posVector.y, z = posVector.z, rotation = rotVector.z}))
    for i, j in imports.ipairs(FRAMEWORK_CONFIGS["Player"]["Datas"]) do
        local data = imports.tostring(player:getData("Player:"..j))
        exports.serials_library:setSerialData(serial, j, data)
    end
    for i, j in imports.ipairs(FRAMEWORK_CONFIGS["Character"]["Datas"]) do
        local data = imports.tostring(player:getData("Character:"..j))
        CCharacter.setData(characterID, j, data)
    end

    if playerAttachments[player] then
        for i, j in imports.pairs(playerAttachments[player]) do
            if j and imports.isElement(j) then
                imports.destroyElement(j)
            end
        end
    end
    playerAttachments[player] = nil
    playerInventorySlots[player] = nil
    if not isClientQuitting then
        player:setData("Player:Initialized", nil)
        player:setData("Character:ID", nil)
        for i, j in imports.pairs(characterIdentity) do
            player:setData("Character:"..i, nil)
        end
        for i, j in imports.ipairs(FRAMEWORK_CONFIGS["Player"]["Datas"]) do
            player:setData("Player:"..j, nil)
        end
        for i, j in imports.ipairs(FRAMEWORK_CONFIGS["Character"]["Datas"]) do
            player:setData("Character:"..j, nil)
        end
        for i, j in imports.pairs(FRAMEWORK_CONFIGS["Inventory"]["Slots"]) do
            player:setData("Slot:"..i, nil)
            player:setData("Slot:Object:"..i, nil)
        end
        for i, j in imports.pairs(FRAMEWORK_CONFIGS["Inventory"]["Items"]) do
            for k, v in imports.pairs(j) do
                player:setData("Item:"..k, nil)
            end
        end
    end
    return true
end