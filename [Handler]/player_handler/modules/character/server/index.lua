----------------------------------------------------------------
--[[ Resource: Player Handler
     Script: modules: character: server: index.lua
     Author: vStudio
     Developer(s): Mario, Tron, Aviril
     DOC: 31/01/2022
     Desc: Character Module ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local imports = {
    type = type,
    pairs = pairs,
    table = table
}


----------------
--[[ Module ]]--
----------------

CCharacter = {
    CBuffer = {},

    fetch = function(characterID, ...)
        dbify.character.fetchAll({
            {dbify.character.__connection__.keyColumn, characterID}
        }, ...)
        return true
    end,

    create = function(serial, callback, ...)
        if (not serial or (imports.type(serial) ~= "string")) then return false end
        dbify.character.create(function(characterID, Args)
            CCharacter.CBuffer[characterID] = {
                {"owner", Args[1]}
            }
            dbify.character.setData(characterID, CCharacter.CBuffer[characterID])
            local callbackReference = callback
            if (callbackReference and (imports.type(callbackReference) == "function")) then
                imports.table.remove(Args, 1)
                callbackReference(characterID, Args)
            end
        end, serial, ...)
        return true
    end,

    delete = function(characterID, callback, ...)
        dbify.character.delete(characterID, function(result, Args)
            if result then
                CCharacter.CBuffer[characterID] = nil
            end
            local callbackReference = callback
            if (callbackReference and (imports.type(callbackReference) == "function")) then
                callbackReference(result, Args)
            end
        end, ...)
        return true
    end,

    setData = function(characterID, characterDatas, callback, ...)
        dbify.character.setData(characterID, characterDatas, function(result, Args)
            if result and CCharacter.CBuffer[characterID] then
                for i = 1, #characterDatas, 1 do
                    local j = characterDatas[i]
                    CCharacter.CBuffer[characterID][(j[1])] = j[2]
                end
            end
            local callbackReference = callback
            if (callbackReference and (imports.type(callbackReference) == "function")) then
                imports.table.remove(Args, 1)
                callbackReference(result, Args)
            end
        end, characterDatas, ...)
        return true
    end,

    getData = function(characterID, characterDatas, callback, ...)
        dbify.character.getData(characterID, characterDatas, function(result, Args)
            local callbackReference = callback
            if (callbackReference and (imports.type(callbackReference) == "function")) then
                callbackReference(result, Args)
            end
            if result and CCharacter.CBuffer[characterID] then
                for i, j in imports.pairs(characterDatas) do
                    CCharacter.CBuffer[characterID][j] = result[j]
                end
            end
        end, ...)
        return true
    end
}