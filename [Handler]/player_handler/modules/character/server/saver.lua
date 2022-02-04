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
    ipairs = ipairs,
    tostring = tostring,
    isElement = isElement,
    destroyElement = destroyElement,
    getPlayerSerial = getPlayerSerial,
    getElementData = getElementData,
    setElementData = setElementData,
    toJSON = toJSON
}


-------------------------
--[[ Character Class ]]--
-------------------------

CCharacter.saveProgress = function(player, isQuitting)
    if not CPlayer.isInitialized(player) then return false end

    local serial = imports.getPlayerSerial(player)
    local characterID = imports.getElementData(player, "Character:ID")
    local characterIdentity = CCharacter.getData(characterID, "identity")
    CCharacter.setData(characterID, "location", imports.toJSON(CCharacter.getLocation(player)))
    for i, j in imports.ipairs(FRAMEWORK_CONFIGS["Player"]["Datas"]) do
        local data = imports.tostring(imports.getElementData(player, "Player:"..j))
        exports.serials_library:setSerialData(serial, j, data)
    end
    for i, j in imports.ipairs(FRAMEWORK_CONFIGS["Character"]["Datas"]) do
        local data = imports.tostring(imports.getElementData(player, "Character:"..j))
        CCharacter.setData(characterID, j, data)
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
    if not isQuitting then
        imports.setElementData(player, "Player:Initialized", nil)
        imports.setElementData(player, "Character:ID", nil)
        for i, j in imports.pairs(characterIdentity) do
            imports.setElementData(player, "Character:"..i, nil)
        end
        for i, j in imports.ipairs(FRAMEWORK_CONFIGS["Player"]["Datas"]) do
            imports.setElementData(player, "Player:"..j, nil)
        end
        for i, j in imports.ipairs(FRAMEWORK_CONFIGS["Character"]["Datas"]) do
            imports.setElementData(player, "Character:"..j, nil)
        end
        for i, j in imports.pairs(FRAMEWORK_CONFIGS["Inventory"]["Slots"]) do
            imports.setElementData(player, "Slot:"..i, nil)
            imports.setElementData(player, "Slot:Object:"..i, nil)
        end
        for i, j in imports.pairs(FRAMEWORK_CONFIGS["Inventory"]["Items"]) do
            for k, v in imports.pairs(j) do
                imports.setElementData(player, "Item:"..k, nil)
            end
        end
    end
    return true
end