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
    json = json,
    table = table,
    math = math,
    assetify = assetify,
    dbify = dbify
}


-----------------
--[[ cUtility ]]--
-----------------

local cUtility = {
    resetProgress = function(cThread, player, isForceReset, deps, saveProgress, loadProgress)
        if isForceReset then
            imports.assetify.syncer.setEntityData(player, "Character:ID", nil)
        end
        for i, j in imports.pairs(CPlayer.CAttachments[player]) do
            if j and imports.isElement(j) then
                imports.destroyElement(j)
            end
        end
        CPlayer.CChannel[player] = nil
        CPlayer.CAttachments[player] = nil
        local buffer = {player = {}, character = {}, inventory = {}}
        if isForceReset then
            for i = 1, #FRAMEWORK_CONFIGS["Player"]["Datas"], 1 do
                local j = FRAMEWORK_CONFIGS["Player"]["Datas"][i]
                buffer.player[i] = {j, imports.assetify.syncer.getEntityData(player, "Player:"..j)}
                imports.assetify.syncer.setEntityData(player, "Player:Data:"..j, nil)
            end
            imports.assetify.syncer.setEntityData(player, "Character:Identity", nil)
        end
        for i = 1, #FRAMEWORK_CONFIGS["Character"]["Datas"], 1 do
            local j = FRAMEWORK_CONFIGS["Character"]["Datas"][i]
            buffer.character[i] = {j, imports.assetify.syncer.getEntityData(player, "Character:Data:"..j)}
            imports.assetify.syncer.setEntityData(player, "Character:"..j, nil)
        end
        for i, j in imports.pairs(FRAMEWORK_CONFIGS["Templates"]["Inventory"]["Slots"]) do
            imports.assetify.syncer.setEntityData(player, "Slot:"..i, nil)
            imports.assetify.syncer.setEntityData(player, "Slot:Object:"..i, nil)
        end
        imports.table.insert(buffer.inventory, {"max_slots", CInventory.CBuffer[(deps.inventoryID)].maxSlots})
        imports.table.insert(buffer.inventory, {"slots", imports.json.encode(CInventory.CBuffer[(deps.inventoryID)].slots)})
        for i, j in imports.pairs(CInventory.CItems) do
            if saveProgress then
                CInventory.setItemProperty(cThread, deps.inventoryID, {j.ref}, {
                    {imports.dbify.inventory.connection.item.counter, imports.math.max(0, imports.tonumber(imports.assetify.syncer.getEntityData(player, "Item:"..i)) or 0)}
                })
            end
            imports.assetify.syncer.setEntityData(player, "Item:"..i, (loadProgress and 0) or nil)
        end
        if saveProgress then
            CPlayer.setData(cThread, deps.serial, buffer.player)
            CCharacter.setData(cThread, deps.characterID, buffer.character)
            CInventory.setData(cThread, deps.inventoryID, buffer.inventory)
            CPlayer.CBuffer[(deps.serial)], CCharacter.CBuffer[(deps.characterID)], CInventory.CBuffer[(deps.inventoryID)] = nil, nil, nil
            imports.collectgarbage()
        end
        return true
    end
}


---------------------------
--[[ Module: Character ]]--
---------------------------

CCharacter.loadInventory = function(cThread, player, deps)
    if not cThread then return false end
    if not player or not imports.isElement(player) or (imports.getElementType(player) ~= "player") or not deps then return false end
    local DItemProperty = CInventory.getItemProperty(cThread, deps.inventoryID, CInventory.CRefs.index, {imports.dbify.inventory.connection.item.counter}, true)
    if not DItemProperty and (#CInventory.CRefs.index > 0) then return false end
    local DInventoryProperty = CInventory.getData(cThread, deps.inventoryID, {"max_slots", "slots"})
    DInventoryProperty = DInventoryProperty or {}
    DInventoryProperty.max_slots, DInventoryProperty.slots = imports.math.max(CInventory.fetchMaxSlotsMultiplier(), imports.tonumber(DInventoryProperty.max_slots) or 0), (DInventoryProperty.slots and imports.json.decode(DInventoryProperty.slots)) or {}
    CInventory.CBuffer[(deps.characterID)] = {
        maxSlots = DInventoryProperty.max_slots,
        slots = DInventoryProperty.slots
    }
    for i, j in imports.pairs(DItemProperty) do
        imports.assetify.syncer.setEntityData(player, "Item:"..(CInventory.CRefs.ref[i]), imports.tonumber(j[(imports.dbify.inventory.connection.item.counter)]) or 0)
    end
    return true
end

CCharacter.loadProgress = function(player, loadCharacterID, resetProgress)
    if not player or not imports.isElement(player) or (imports.getElementType(player) ~= "player") then return false end
    local characterID = loadCharacterID or CPlayer.getCharacterID(player, true)
    if loadCharacterID then
        local serial = CPlayer.getSerial(player)
        CPlayer.CAttachments[player] = {}
        for i = 1, #FRAMEWORK_CONFIGS["Player"]["Datas"], 1 do
            local j = FRAMEWORK_CONFIGS["Player"]["Datas"][i]
            imports.assetify.syncer.setEntityData(player, "Player:Data:"..j, CPlayer.CBuffer[serial][j])
        end
        for i = 1, #FRAMEWORK_CONFIGS["Character"]["Datas"], 1 do
            local j = FRAMEWORK_CONFIGS["Character"]["Datas"][i]
            imports.assetify.syncer.setEntityData(player, "Character:Data:"..j, CCharacter.CBuffer[characterID][j])
        end
        CPlayer.setLogged(player, true)
    end
    if resetProgress then
        if not CPlayer.isInitialized(player) then return false end
        cUtility.resetProgress(player, false, {
            characterID = characterID
        }, false, true)
        for i = 1, #FRAMEWORK_CONFIGS["Spawns"]["Datas"].generic, 1 do
            local j = FRAMEWORK_CONFIGS["Spawns"]["Datas"].generic[i]
            local value = j.amount
            if j.name == "Character:blood" then
                value = CCharacter.getMaxHealth(player)
            end
            imports.assetify.syncer.setEntityData(player, j.name, value)
        end
    end
    return true
end

CCharacter.saveProgress = function(cThread, player)
    if not cThread then return false end
    if not CPlayer.isInitialized(player) then return false end
    local serial = CPlayer.getSerial(player)
    local characterID = CPlayer.getCharacterID(player)
    local inventoryID = CPlayer.getInventoryID(player)
    CCharacter.setData(cThread, characterID, {
        {"location", imports.json.encode(CCharacter.getLocation(player))}
    })
    cUtility.resetProgress(cThread, player, true, {
        serial = serial,
        characterID = characterID,
        inventoryID = inventoryID
    }, true)
    CPlayer.setLogged(player, false)
    return true
end