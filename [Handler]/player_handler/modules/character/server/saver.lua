----------------------------------------------------------------
--[[ Resource: Player Handler
     Script: modules: character: server: saver.lua
     Author: vStudio
     Developer(s): Mario, Tron, Aviril
     DOC: 31/01/2022
     Desc: Character Saver ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local imports = {
    pairs = pairs,
    tostring = tostring,
    isElement = isElement,
    destroyElement = destroyElement,
    getPlayerSerial = getPlayerSerial,
    getElementData = getElementData,
    setElementData = setElementData,
    toJSON = toJSON,
    math = math
}


----------------
--[[ Module ]]--
----------------

CCharacter.resetProgress = function(player, isForceReset, depDatas, saveProgress, loadProgress)
    if isForceReset then
        imports.setElementData(player, "Player:Initialized", nil)
        imports.setElementData(player, "Character:ID", nil)
    end

    if CPlayer.CAttachments[player] then
        for i, j in imports.pairs(CPlayer.CAttachments[player]) do
            if j and imports.isElement(j) then
                imports.destroyElement(j)
            end
        end
    end
    CPlayer.CAttachments[player] = nil
    playerInventorySlots[player] = nil

    local dataBuffer = {
        player = {},
        character = {},
    }
    if isForceReset then
        for i, j in imports.pairs(CCharacter.CBuffer[(depDatas.characterID)].identity) do
            imports.setElementData(player, "Character:"..i, nil)
        end
        for i = 1, #FRAMEWORK_CONFIGS["Player"]["Datas"], 1 do
            local j = FRAMEWORK_CONFIGS["Player"]["Datas"][i]
            dataBuffer.player[i] = {j, imports.tostring(imports.getElementData(player, "Player:"..j))}
            imports.setElementData(player, "Player:"..j, nil)
        end
    end
    for i = 1, #FRAMEWORK_CONFIGS["Character"]["Datas"], 1 do
        local j = FRAMEWORK_CONFIGS["Character"]["Datas"][i]
        dataBuffer.character[i] = {j, imports.tostring(imports.getElementData(player, "Character:"..j))}
        imports.setElementData(player, "Character:"..j, nil)
    end
    for i, j in imports.pairs(FRAMEWORK_CONFIGS["Inventory"]["Slots"]) do
        imports.setElementData(player, "Slot:"..i, nil)
        imports.setElementData(player, "Slot:Object:"..i, nil)
    end
    if saveProgress then
        CPlayer.setData(depDatas.serial, dataBuffer.player)
        CCharacter.setData(depDatas.characterID, dataBuffer.character)
    end
    for i, j in imports.pairs(CInventory.CItems) do
        if saveProgress then
            CInventory.setItemProperty(depDatas.inventoryID, {i}, {
                {dbify.Inventory.__connection__.itemFormat.counter, imports.max(0, imports.tonumber(imports.getElementData(player, "Item:"..i)) or 0)}
            })
        end
        imports.setElementData(player, "Item:"..i, (loadProgress and 0) or nil)
    end
    return true
end

CCharacter.loadProgress = function(player)
    if CPlayer.isInitialized(player) then return false end

    local characterID = imports.getElementData(player, "Character:ID")
    CCharacter.resetProgress(player, false, {
        characterID = characterID
    }, false, true)
    return true
end

CCharacter.saveProgress = function(player)
    if not CPlayer.isInitialized(player) then return false end

    local serial = imports.getPlayerSerial(player)
    local characterID = imports.getElementData(player, "Character:ID")
    local inventoryID = imports.getElementData(player, "Inventory:ID")
    CCharacter.setData(characterID, "location", imports.toJSON(CCharacter.getLocation(player)))
    CCharacter.resetProgress(player, true, {
        serial = serial,
        characterID = characterID,
        inventoryID = inventoryID
    }, true)
    return true
end