-----------------
--[[ Imports ]]--
-----------------

local imports = {
    pairs = pairs,
    tonumber = tonumber,
    tostring = tostring,
    isElement = isElement,
    destroyElement = destroyElement,
    collectgarbage = collectgarbage,
    getPlayerSerial = getPlayerSerial,
    getElementData = getElementData,
    setElementData = setElementData,
    toJSON = toJSON,
    table = table,
    math = math
}


---------------------------
--[[ Module: Character ]]--
---------------------------

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
    CPlayer.CChannel[player] = nil
    CPlayer.CAttachments[player] = nil
    local dataBuffer = {
        player = {},
        character = {},
        inventory = {}
    }
    if isForceReset then
        for i = 1, #FRAMEWORK_CONFIGS["Player"]["Datas"], 1 do
            local j = FRAMEWORK_CONFIGS["Player"]["Datas"][i]
            dataBuffer.player[i] = {j, imports.getElementData(player, "Player:"..j)}
            imports.setElementData(player, "Player:Data:"..j, nil)
        end
        imports.setElementData(player, "Character:Identity", nil)
    end
    for i = 1, #FRAMEWORK_CONFIGS["Character"]["Datas"], 1 do
        local j = FRAMEWORK_CONFIGS["Character"]["Datas"][i]
        dataBuffer.character[i] = {j, imports.getElementData(player, "Character:Data:"..j)}
        imports.setElementData(player, "Character:"..j, nil)
    end
    for i, j in imports.pairs(FRAMEWORK_CONFIGS["Inventory"]["Slots"]) do
        imports.setElementData(player, "Slot:"..i, nil)
        imports.setElementData(player, "Slot:Object:"..i, nil)
    end
    imports.table.insert(dataBuffer.inventory, {"max_slots", CInventory.CBuffer[player].maxSlots})
    imports.table.insert(dataBuffer.inventory, {"slots", imports.toJSON(CInventory.CBuffer[player].slots)})
    for i, j in imports.pairs(CInventory.CItems) do
        if saveProgress then
            CInventory.setItemProperty(depDatas.inventoryID, {i}, {
                {dbify.inventory.connection.itemFormat.counter, imports.math.max(0, imports.tonumber(imports.getElementData(player, "Item:"..i)) or 0)}
            })
        end
        imports.setElementData(player, "Item:"..i, (loadProgress and 0) or nil)
    end
    if saveProgress then
        CPlayer.setData(depDatas.serial, dataBuffer.player)
        CCharacter.setData(depDatas.characterID, dataBuffer.character)
        CInventory.setData(depDatas.inventoryID, dataBuffer.inventory)
        CPlayer.CBuffer[(depDatas.serial)], CCharacter.CBuffer[(depDatas.characterID)], CInventory.CBuffer[(depDatas.inventoryID)] = nil, nil, nil
        imports.collectgarbage()
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
    local inventoryID = CCharacter.CBuffer[characterID].inventory
    CCharacter.setData(characterID, {
        {"location", imports.toJSON(CCharacter.getLocation(player))}
    })
    CCharacter.resetProgress(player, true, {
        serial = serial,
        characterID = characterID,
        inventoryID = inventoryID
    }, true)
    return true
end