----------------------------------------------------------------
--[[ Resource: Player Handler
     Script: handlers: character: server.lua
     Author: vStudio
     Developer(s): Mario, Tron
     DOC: 31/01/2022
     Desc: Character Handler ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local imports = {
    type = type,
    pairs = pairs,
    ipairs = ipairs,
    table = table
}


-------------------------
--[[ Character Class ]]--
-------------------------

CCharacter = {
    buffer = {},

    fetchCharacters = function(characterID, ...)
        dbify.character.fetchAll({
            {dbify.character.__connection__.keyColumn, characterID}
        }, ...)
        return true
    end,

    create = function(serial, callback, ...)
        if (not serial or (imports.type(serial) ~= "string")) then return false end
        dbify.character.create(function(characterID, arguments)
            CCharacter.buffer[characterID] = {
                {"owner", characterOwner}
            }
            dbify.character.setData(characterID, CCharacter.buffer[characterID])
            local callbackReference = callback
            if (callbackReference and (imports.type(callbackReference) == "function")) then
                imports.table.remove(arguments, 1)
                callbackReference(characterID, arguments)
            end
        end, serial, ...)
        return true
    end,

    delete = function(characterID)
        dbify.character.delete(characterID, function(result)
            if result then
                CCharacter.buffer[characterID] = nil
            end
        end)
        return true
    end,

    setData = function(characterID, characterDatas, callback, ...)
        dbify.character.setData(characterID, characterDatas, function(result, arguments)
            if result and CCharacter.buffer[characterID] then
                for i, j in imports.ipairs(characterDatas) do
                    CCharacter.buffer[characterID][(j[1])] = j[2]
                end
            end
            local callbackReference = callback
            if (callbackReference and (imports.type(callbackReference) == "function")) then
                imports.table.remove(arguments, 1)
                callbackReference(result, arguments)
            end
        end, characterDatas, ...)
        return true
    end,

    getData = function(characterID, characterDatas, callback, ...)
        dbify.character.getData(characterID, characterDatas, function(result, arguments)
            local callbackReference = callback
            if (callbackReference and (imports.type(callbackReference) == "function")) then
                callbackReference(result, arguments)
            end
            if result and CCharacter.buffer[characterID] then
                for i, j in imports.pairs(characterDatas) do
                    CCharacter.buffer[characterID][j] = result[j]
                end
            end
        end, ...)
        return true
    end
}