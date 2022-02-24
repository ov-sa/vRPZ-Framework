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
    pairs = pairs,
    addEvent = addEvent,
    addEventHandler = addEventHandler,
    triggerClientEvent = triggerClientEvent,
    setElementFrozen = setElementFrozen,
    setPlayerName = setPlayerName,
    toJSON = toJSON,
    fromJSON = fromJSON,
    table = table
}


-------------------------------------
--[[ Player: On Delete Character ]]--
-------------------------------------

imports.addEvent("Player:onDeleteCharacter", true)
imports.addEventHandler("Player:onDeleteCharacter", root, function(characterID)
    CCharacter.delete(characterID)
end)


-----------------------------------
--[[ Player: On Save Character ]]--
-----------------------------------

imports.addEvent("Player:onSaveCharacter", true)
imports.addEventHandler("Player:onSaveCharacter", root, function(characterID, characters, unsavedCharacters)
    characterID = tonumber(characterID)
    if not characterID or not characterID or not unsavedCharacters then return false end

    local serial = CPlayer.getSerial(source)
    for i, j in imports.pairs(unsavedCharacters) do
        if characters[i] then
            local characterID = CCharacter.create(serial, function(characterID, args)
                CCharacter.setData(characterID, "identity", imports.toJSON(characters[i]))
                CCharacter.CBuffer[characterID].identity = imports.fromJSON(CCharacter.CBuffer[characterID].identity)
                imports.triggerClientEvent(args[1], "Client:onLoadCharacterID", args[1], i, characterID, characters[i])
            end, source)
        end
    end
    CPlayer.setData(serial, {"character", characterID})
    imports.triggerClientEvent(source, "Client:onSaveCharacter", source, true)
end)


------------------------------------
--[[ Player: On Toggle Login UI ]]--
------------------------------------

imports.addEvent("Player:onToggleLoginUI", true)
imports.addEventHandler("Player:onToggleLoginUI", root, function()
    imports.setElementFrozen(source, true)
    imports.setPlayerName(source, CPlayer.generateNick())

    CPlayer.fetch(CPlayer.getSerial(source), function(result, args)
        result.character = result.character or 0
        result.characters = (result.characters and imports.fromJSON(result.characters)) or {}
        result.vip = (result.vip and true) or false

        if (#result.characters > 0) then
            CCharacter.fetch(result.characters, function(result, args)
                args[2].characters = result
                for i = 1, #args[2].characters, 1 do
                    local j = args[2].characters[i]
                    j.identity = imports.fromJSON(j.identity)
                end
                if not args[2].characters[(args[2].character)] then args[2].character = 0 end
                --TODO: NOT FETCHING....
                print(toJSON(args[2].characters))
                imports.triggerClientEvent(args[1], "Client:onToggleLoginUI", args[1], true, {
                    character = args[2].character,
                    characters = args[2].characters,
                    vip = args[2].vip
                })
            end, args[1], result)
        else
            print("DOESNT EXIST..")
            result.character = 0
            imports.triggerClientEvent(args[1], "Client:onToggleLoginUI", args[1], true, {
                character = result.character,
                characters = result.characters,
                vip = result.vip
            })
        end
    end, source)
end)