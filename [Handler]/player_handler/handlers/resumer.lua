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
imports.addEventHandler("Player:onSaveCharacter", root, function(character, characters)
    character = tonumber(character)
    if not character or not characters or not characters[character] then return false end

    local serial = CPlayer.getSerial(source)
    CCharacter.create(serial, function(characterID, args)
        CCharacter.setData(characterID, {
            {"identity", imports.toJSON(args[3])}
        }, function(result, args)
            if result then
                CCharacter.CBuffer[(args[1])].identity = args[4]
                imports.triggerClientEvent(args[2], "Client:onLoadCharacterID", args[2], args[3], args[1], args[4])
                --TODO: SAVE IT
                --CPlayer.setData(serial, {"character", characterID})
            end
            imports.triggerClientEvent(args[2], "Client:onSaveCharacter", args[2], (result and true) or false, args[3])
        end, characterID, args[1], args[2], args[3])
    end, source, i, characters[character].identity)
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

        --TODO: DEBUG..
        print(toJSON(result.characters))
        if (#result.characters > 0) then
            CCharacter.fetch(result.characters, function(result, args)
                args[2].characters = result
                for i = 1, #args[2].characters, 1 do
                    local j = args[2].characters[i]
                    j.identity = imports.fromJSON(j.identity)
                    CCharacter.CBuffer[(j[(dbify.character.__connection__.keyColumn)])] = j
                    CCharacter.CBuffer[(j[(dbify.character.__connection__.keyColumn)])][(dbify.character.__connection__.keyColumn)] = nil
                end
                if not args[2].characters[(args[2].character)] then args[2].character = 0 end
                imports.triggerClientEvent(args[1], "Client:onToggleLoginUI", args[1], true, {
                    character = args[2].character,
                    characters = args[2].characters,
                    vip = args[2].vip
                })
            end, args[1], result)
        else
            result.character = 0
            imports.triggerClientEvent(args[1], "Client:onToggleLoginUI", args[1], true, {
                character = result.character,
                characters = result.characters,
                vip = result.vip
            })
        end
    end, source)
end)