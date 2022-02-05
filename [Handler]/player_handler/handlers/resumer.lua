----------------------------------------------------------------
--[[ Resource: Player Handler
     Script: handlers: resumer.lua
     Author: vStudio
     Developer(s): Mario, Tron, Aviril
     DOC: 31/01/2022
     Desc: Resumer Handler ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local imports = {
    addEvent = addEvent,
    addEventHandler = addEventHandler,
    triggerClientEvent = triggerClientEvent,
    setElementFrozen = setElementFrozen,
    setPlayerName = setPlayerName,
    table = table
}


-------------------------------------------------
--[[ Events: On Client Character Delete/Save ]]--
-------------------------------------------------

imports.addEvent("Player:onDeleteCharacter", true)
imports.addEventHandler("Player:onDeleteCharacter", root, function(characterID)
    CCharacter.delete(characterID)
end)

imports.addEvent("Player:onSaveCharacter", true)
imports.addEventHandler("Player:onSaveCharacter", root, function(character, characters, unsavedCharacters)
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
            CCharacter.setData(characterID, "identity", toJSON(characters[i]))
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
    imports.setElementFrozen(source, true)
    imports.setPlayerName(source, CPlayer.generateNick())
    local lastCharacter = CPlayer.getData(CPlayer.getSerial(source), {
        "character",
        "characters",
        "premimum"
    }, function(result)
        result.character = result.character or 0
        result.characters = result.characters or {}
        for i, j in ipairs(result.characters) do
            --[[
            local _characterData = table.copy(characterCache[j].identity, true)
            _characterData._id = j
            imports.table.insert(characters, _characterData)
            ]]
            --TODO: FETCH CHARACTER'S IDENTITY AND LOAD IT
        end
        if not result.characters[(result.character)] then result.character = 0 end
        imports.triggerClientEvent(source, "Client:onToggleLoadingUI", source, {
            character = result.character,
            characters = result.characters,
            isPremium = result.premimum
        })
    end)
end)