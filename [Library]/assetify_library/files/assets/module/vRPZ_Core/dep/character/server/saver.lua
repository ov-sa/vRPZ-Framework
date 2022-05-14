-----------------
--[[ Imports ]]--
-----------------

local imports = {
    type = type,
    pairs = pairs,
    tonumber = tonumber,
    isElement = isElement,
    getElementType = getElementType,
    destroyElement = destroyElement,
    collectgarbage = collectgarbage,
    getElementData = getElementData,
    setElementData = setElementData,
    toJSON = toJSON,
    table = table,
    math = math,
    dbify = dbify
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
            CInventory.setItemProperty(depDatas.inventoryID, {j.ref}, {
                {imports.dbify.inventory.connection.itemFormat.counter, imports.math.max(0, imports.tonumber(imports.getElementData(player, "Item:"..i)) or 0)}
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

CCharacter.loadInventory = function(player, depDatas, callback)
    if not player or not imports.isElement(player) or (imports.getElementType(player) ~= "player") then return false end
    CInventory.getItemProperty(depDatas.inventoryID, CInventory.CRefs.index, {imports.dbify.inventory.connection.itemFormat.counter}, function(result, args)
        local callbackReference = callback
        if not result and (CInventory.CRefs.index > 0) then
            if callback and (imports.type(callback) == "function") then
                callbackReference(false, args[1], args[2])
            end
            return false
        end
        CInventory.getData(args[2].inventoryID, {"max_slots", "slots"}, function(result, args)
            local callbackReference = callback
            result = result or {}
            result.max_slots, result.slots = imports.math.max(CInventory.fetchMaxSlotsMultiplier(), imports.tonumber(result.max_slots) or 0), (result.slots and imports.fromJSON(result.slots)) or {}
            CInventory.CBuffer[(args[2].characterID)] = {
                maxSlots = result.max_slots,
                slots = result.slots
            }
            for i, j in imports.pairs(args[3]) do
                imports.setElementData(args[1], "Item:"..(CInventory.CRefs.ref[i]), imports.tonumber(j[(imports.dbify.inventory.connection.itemFormat.counter)]) or 0)
            end
            if callback and (imports.type(callback) == "function") then
                callbackReference(true, args[1], args[2])
            end
        end, args[1], args[2], result)
    end, true, player, depDatas)
    return true
end

CCharacter.loadProgress = function(player, loadBuffer, resetProgress)
    if not player or not imports.isElement(player) or (imports.getElementType(player) ~= "player") then return false end
    local characterID = imports.getElementData(player, "Character:ID")
    if loadBuffer then
        local serial = CPlayer.getSerial(player)
        for i = 1, #FRAMEWORK_CONFIGS["Player"]["Datas"], 1 do
            local j = FRAMEWORK_CONFIGS["Player"]["Datas"][i]
            imports.setElementData(player, "Player:Data:"..j, CPlayer.CBuffer[serial][j])
        end
        for i = 1, #FRAMEWORK_CONFIGS["Character"]["Datas"], 1 do
            local j = FRAMEWORK_CONFIGS["Character"]["Datas"][i]
            imports.setElementData(player, "Character:Data:"..j, CCharacter.CBuffer[characterID][j])
        end
        CPlayer.setLogged(player, true)
    end
    if resetProgress then
        if not CPlayer.isInitialized(player) then return false end
        CCharacter.resetProgress(player, false, {
            characterID = characterID
        }, false, true)
        for i = 1, #FRAMEWORK_CONFIGS["Spawns"]["Datas"].generic, 1 do
            local j = FRAMEWORK_CONFIGS["Spawns"]["Datas"].generic[i]
            local value = j.amount
            if j.name == "Character:blood" then
                value = CCharacter.getMaxHealth(player)
            end
            imports.setElementData(player, j.name, value)
        end
    end
    return true
end

CCharacter.saveProgress = function(player)
    if not CPlayer.isInitialized(player) then return false end
    local serial = CPlayer.getSerial(player)
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
    CPlayer.setLogged(player, false)
    return true
end