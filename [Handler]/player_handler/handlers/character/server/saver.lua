----------------------------------------------------------------
--[[ Resource: Player Handler
     Script: handlers: character: server: saver.lua
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
    getPlayerSerial = getPlayerSerial,
    toJSON = toJSON
}


-------------------------
--[[ Character Class ]]--
-------------------------

CCharacter.saveProgress = function(player, isQuitting)
    if not CPlayer.isInitialized(player) then return false end

    local serial = imports.getPlayerSerial(player)
    local characterID = player:getData("Character:ID")
    local characterIdentity = CCharacter.getData(characterID, "identity")
    CCharacter.setData(characterID, "location", imports.toJSON(CPlayer.getLocation(player)))
    for i, j in imports.ipairs(FRAMEWORK_CONFIGS["Player"]["Datas"]) do
        local data = imports.tostring(player:getData("Player:"..j))
        exports.serials_library:setSerialData(serial, j, data)
    end
    for i, j in imports.ipairs(FRAMEWORK_CONFIGS["Character"]["Datas"]) do
        local data = imports.tostring(player:getData("Character:"..j))
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