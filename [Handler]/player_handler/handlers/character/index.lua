----------------------------------------------------------------
--[[ Resource: Player Handler
     Script: handlers: character: index.lua
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
        dbify.character.create(function(characterID, cArgs)
            CCharacter.buffer[characterID] = {
                {"owner", characterOwner}
            }
            dbify.character.setData(characterID, CCharacter.buffer[characterID])
            local callbackReference = callback
            if (callbackReference and (imports.type(callbackReference) == "function")) then
                imports.table.remove(cArgs, 1)
                callbackReference(characterID, cArgs)
            end
        end, serial, ...)
        return true
    end,

    delete = function(characterID, callback, ...)
        dbify.character.delete(characterID, function(result, cArgs)
            if result then
                CCharacter.buffer[characterID] = nil
            end
            local callbackReference = callback
            if (callbackReference and (imports.type(callbackReference) == "function")) then
                callbackReference(result, cArgs)
            end
        end, ...)
        return true
    end,

    setData = function(characterID, characterDatas, callback, ...)
        dbify.character.setData(characterID, characterDatas, function(result, cArgs)
            if result and CCharacter.buffer[characterID] then
                for i, j in imports.ipairs(characterDatas) do
                    CCharacter.buffer[characterID][(j[1])] = j[2]
                end
            end
            local callbackReference = callback
            if (callbackReference and (imports.type(callbackReference) == "function")) then
                imports.table.remove(cArgs, 1)
                callbackReference(result, cArgs)
            end
        end, characterDatas, ...)
        return true
    end,

    getData = function(characterID, characterDatas, callback, ...)
        dbify.character.getData(characterID, characterDatas, function(result, cArgs)
            local callbackReference = callback
            if (callbackReference and (imports.type(callbackReference) == "function")) then
                callbackReference(result, cArgs)
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