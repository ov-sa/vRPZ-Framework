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
    fromJSON = fromJSON,
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
    }, function(result, Args)
        result.character = result.character or 0
        result.characters = (result.characters and imports.fromJSON(result.characters)) or {}
        if (#result.characters > 0) then
            CCharacter.fetch(result.characters, function(result, Args)
                Args[2].characters = result
                for i = 1, #Args[2].characters, 1 do
                    local j = Args[2].characters[i]
                    j.identity = imports.fromJSON(j.identity)
                end
                if not Args[2].characters[(Args[2].character)] then Args[2].character = 0 end
                imports.triggerClientEvent(Args[1], "Client:onToggleLoadingUI", Args[1], {
                    character = Args[2].character,
                    characters = Args[2].characters,
                    isPremium = Args[2].premimum
                }, Args[1], result)
            end)
        end
    end, source)
end)