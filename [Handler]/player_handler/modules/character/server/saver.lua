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

CCharacter.resetProgress = function(player, isForceReset, skipResetSync, saveProgress)
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

    if not skipResetSync then
        if isForceReset then
            for i, j in imports.pairs(characterIdentity) do
                imports.setElementData(player, "Character:"..i, nil)
            end
            for i = 1, #FRAMEWORK_CONFIGS["Player"]["Datas"], 1 do
                local j = FRAMEWORK_CONFIGS["Player"]["Datas"][i]
                if saveProgress then
                    dbify.serial.setData(saveProgress.serial, {
                        {j, imports.tostring(imports.getElementData(player, "Player:"..j))}
                    })
                end
                imports.setElementData(player, "Player:"..j, nil)
            end
        end
        for i = 1, #FRAMEWORK_CONFIGS["Character"]["Datas"], 1 do
            local j = FRAMEWORK_CONFIGS["Character"]["Datas"][i]
            if saveProgress then
                CCharacter.setData(saveProgress.characterID, j, imports.tostring(imports.getElementData(player, "Character:"..j)))
            end
            imports.setElementData(player, "Character:"..j, nil)
        end
        for i, j in imports.pairs(FRAMEWORK_CONFIGS["Inventory"]["Slots"]) do
            imports.setElementData(player, "Slot:"..i, nil)
            imports.setElementData(player, "Slot:Object:"..i, nil)
        end
        for i, j in imports.pairs(CInventory.CItems) do
            if saveProgress then
                dbify.Inventory.setData(saveProgress.inventoryID, {
                    {i, imports.max(0, imports.tonumber(imports.getElementData(player, "Item:"..i)) or 0)}
                })
            end
            imports.setElementData(player, "Item:"..i, nil)
        end
    end
    return true
end

CCharacter.loadProgress = function(player, isForceReset)
    if CPlayer.isInitialized(player) then return false end

    CCharacter.resetProgress(player, isForceReset)
    for i = 1, #FRAMEWORK_CONFIGS["Player"]["Datas"], 1 do
        local j = FRAMEWORK_CONFIGS["Player"]["Datas"][i]
        imports.setElementData(player, "Player:"..j, nil)
    end
    for i = 1, #FRAMEWORK_CONFIGS["Character"]["Datas"], 1 do
        local j = FRAMEWORK_CONFIGS["Character"]["Datas"][i]
        imports.setElementData(player, "Character:"..j, nil)
    end
    for i, j in imports.pairs(FRAMEWORK_CONFIGS["Inventory"]["Slots"]) do
        imports.setElementData(player, "Slot:"..i, nil)
        imports.setElementData(player, "Slot:Object:"..i, nil)
    end
    for i, j in imports.pairs(FRAMEWORK_CONFIGS["Inventory"]["Items"]) do
        for k, v in imports.pairs(j) do
            imports.setElementData(player, "Item:"..k, 0)
        end
    end
    return true
end

CCharacter.saveProgress = function(player, skipResetSync)
    if not CPlayer.isInitialized(player) then return false end

    local serial = imports.getPlayerSerial(player)
    local characterID = imports.getElementData(player, "Character:ID")
    local inventoryID = imports.getElementData(player, "Inventory:ID")
    local characterIdentity = CCharacter.getData(characterID, "identity") --TODO: IS THIS NEEDED??
    CCharacter.setData(characterID, "location", imports.toJSON(CCharacter.getLocation(player)))
    CCharacter.resetProgress(player, true, skipResetSync, {
        serial = serial,
        characterID = characterID,
        inventoryID = inventoryID
    })
    return true
end