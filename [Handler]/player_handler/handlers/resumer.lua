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
    tonumber = tonumber,
    addEvent = addEvent,
    addEventHandler = addEventHandler,
    triggerClientEvent = triggerClientEvent,
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
    character = imports.tonumber(character)
    if not character or not characters or not characters[character] or characters[character].id then return false end

    local serial = CPlayer.getSerial(source)
    CCharacter.create(serial, function(characterID, args)
        CCharacter.setData(characterID, {
            {"identity", imports.toJSON(args[3])}
        }, function(result, args)
            if result then CCharacter.CBuffer[(args[3].id)].identity = args[3].identity end
            imports.triggerClientEvent(args[1], "Client:onSaveCharacter", args[1], (result and true) or false, args[2], (result and args[3]) or nil)
        end, args[1], args[2], {
            id = characterID,
            identity = args[3]
        })
    end, source, character, characters[character].identity)
end)


------------------------------------
--[[ Player: On Toggle Login UI ]]--
------------------------------------

imports.addEvent("Player:onToggleLoginUI", true)
imports.addEventHandler("Player:onToggleLoginUI", root, function()
    local serial = CPlayer.getSerial(source)
    CPlayer.fetch(serial, function(result, args)
        CCharacter.fetchOwned(args[2], function(result, args)
            args[3].character = args[3].character or 0
            args[3].vip = (args[3].vip and true) or false
            print(result)
        end, args[1], args[2], result)
        --TODO: DEBUG..
        --[[
        print(toJSON(result.characters))
        if (#result.characters > 0) then
            CCharacter.fetch(result.characters, function(result, args)
                args[2].characters = {}
                for i = 1, #result, 1 do
                    local j = result[i]
                    j.identity = imports.fromJSON(j.identity)
                    args[2].characters[i] = {
                        id = j.id,
                        identity = j.identity
                    }
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
        ]]--
    end, source, serial)
end)