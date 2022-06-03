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
    json = json,
    table = table,
    math = math,
    dbify = dbify,
    thread = thread
}


---------------------------
--[[ Module: Character ]]--
---------------------------

CCharacter.resetProgress = function(player, isForceReset, depDatas, saveProgress, loadProgress)
    return imports.thread:create(function(self)
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
        local buffer = {player = {}, character = {}, inventory = {}}
        if isForceReset then
            for i = 1, #FRAMEWORK_CONFIGS["Player"]["Datas"], 1 do
                local j = FRAMEWORK_CONFIGS["Player"]["Datas"][i]
                buffer.player[i] = {j, imports.getElementData(player, "Player:"..j)}
                imports.setElementData(player, "Player:Data:"..j, nil)
            end
            imports.setElementData(player, "Character:Identity", nil)
        end
        for i = 1, #FRAMEWORK_CONFIGS["Character"]["Datas"], 1 do
            local j = FRAMEWORK_CONFIGS["Character"]["Datas"][i]
            buffer.character[i] = {j, imports.getElementData(player, "Character:Data:"..j)}
            imports.setElementData(player, "Character:"..j, nil)
        end
        for i, j in imports.pairs(FRAMEWORK_CONFIGS["Templates"]["Inventory"]["Slots"]) do
            imports.setElementData(player, "Slot:"..i, nil)
            imports.setElementData(player, "Slot:Object:"..i, nil)
        end
        imports.table.insert(buffer.inventory, {"max_slots", CInventory.CBuffer[(depDatas.inventoryID)].maxSlots})
        imports.table.insert(buffer.inventory, {"slots", imports.json.encode(CInventory.CBuffer[(depDatas.inventoryID)].slots)})
        for i, j in imports.pairs(CInventory.CItems) do
            if saveProgress then
                CInventory.setItemProperty(self, depDatas.inventoryID, {j.ref}, {
                    {imports.dbify.inventory.connection.itemFormat.counter, imports.math.max(0, imports.tonumber(imports.getElementData(player, "Item:"..i)) or 0)}
                })
            end
            imports.setElementData(player, "Item:"..i, (loadProgress and 0) or nil)
        end
        if saveProgress then
            CPlayer.setData(self, depDatas.serial, buffer.player)
            CCharacter.setData(self, depDatas.characterID, buffer.character)
            CInventory.setData(self, depDatas.inventoryID, buffer.inventory)
            CPlayer.CBuffer[(depDatas.serial)], CCharacter.CBuffer[(depDatas.characterID)], CInventory.CBuffer[(depDatas.inventoryID)] = nil, nil, nil
            imports.collectgarbage()
        end
    end):resume()
end

CCharacter.loadInventory = function(cThread, player, depDatas)
    if not cThread then return false end
    if not player or not imports.isElement(player) or (imports.getElementType(player) ~= "player") or not depDatas then return false end
    local DItemProperty = CInventory.getItemProperty(cThread, depDatas.inventoryID, CInventory.CRefs.index, {imports.dbify.inventory.connection.itemFormat.counter}, true)
    if not DItemProperty and (#CInventory.CRefs.index > 0) then return false end
    local DInventoryProperty = CInventory.getData(cThread, depDatas.inventoryID, {"max_slots", "slots"})
    DInventoryProperty = DInventoryProperty or {}
    DInventoryProperty.max_slots, DInventoryProperty.slots = imports.math.max(CInventory.fetchMaxSlotsMultiplier(), imports.tonumber(DInventoryProperty.max_slots) or 0), (DInventoryProperty.slots and imports.json.decode(DInventoryProperty.slots)) or {}
    CInventory.CBuffer[(depDatas.characterID)] = {
        maxSlots = DInventoryProperty.max_slots,
        slots = DInventoryProperty.slots
    }
    for i, j in imports.pairs(DItemProperty) do
        imports.setElementData(player, "Item:"..(CInventory.CRefs.ref[i]), imports.tonumber(j[(imports.dbify.inventory.connection.itemFormat.counter)]) or 0)
    end
    return true
end

CCharacter.loadProgress = function(player, loadCharacterID, resetProgress)
    if not player or not imports.isElement(player) or (imports.getElementType(player) ~= "player") then return false end
    local characterID = loadCharacterID or CPlayer.getCharacterID(player, true)
    if loadCharacterID then
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
    local characterID = CPlayer.getCharacterID(player)
    local inventoryID = CPlayer.getInventoryID(player)
    CCharacter.setData(characterID, {
        {"location", imports.json.encode(CCharacter.getLocation(player))}
    })
    CCharacter.resetProgress(player, true, {
        serial = serial,
        characterID = characterID,
        inventoryID = inventoryID
    }, true)
    CPlayer.setLogged(player, false)
    return true
end