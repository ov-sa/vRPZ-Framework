----------------------------------------------------------------
--[[ Resource: Player Handler
     Script: modules: character: server: index.lua
     Author: vStudio
     Developer(s): Mario, Tron, Aviril, Аниса
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


---------------------------
--[[ Module: Character ]]--
---------------------------

CCharacter.CBuffer = {}

CCharacter.fetch = function(characterID, ...)
    dbify.character.fetchAll({
        {dbify.character.__connection__.keyColumn, characterID}
    }, ...)
    return true
end

CCharacter.fetchOwned = function(serial, ...)
    dbify.character.fetchAll({
        {"owner", serial}
    }, ...)
    return true
end

CCharacter.create = function(serial, callback, ...)
    if (not serial or (imports.type(serial) ~= "string")) then return false end
    dbify.character.create(function(characterID, args)
        CCharacter.CBuffer[characterID] = {
            {"owner", args[1]}
        }
        dbify.character.setData(characterID, CCharacter.CBuffer[characterID])
        local callbackReference = callback
        if (callbackReference and (imports.type(callbackReference) == "function")) then
            imports.table.remove(args, 1)
            callbackReference(characterID, args)
        end
    end, serial, ...)
    return true
end

CCharacter.delete = function(characterID, callback, ...)
    dbify.character.delete(characterID, function(result, args)
        if result then
            CCharacter.CBuffer[characterID] = nil
        end
        local callbackReference = callback
        if (callbackReference and (imports.type(callbackReference) == "function")) then
            callbackReference(result, args)
        end
    end, ...)
    return true
end

CCharacter.setData = function(characterID, characterDatas, callback, ...)
    dbify.character.setData(characterID, characterDatas, function(result, args)
        if result and CCharacter.CBuffer[characterID] then
            for i = 1, #characterDatas, 1 do
                local j = characterDatas[i]
                CCharacter.CBuffer[characterID][(j[1])] = j[2]
            end
        end
        local callbackReference = callback
        if (callbackReference and (imports.type(callbackReference) == "function")) then
            imports.table.remove(args, 1)
            callbackReference(result, args)
        end
    end, characterDatas, ...)
    return true
end

CCharacter.getData = function(characterID, characterDatas, callback, ...)
    dbify.character.getData(characterID, characterDatas, function(result, args)
        local callbackReference = callback
        if (callbackReference and (imports.type(callbackReference) == "function")) then
            callbackReference(result, args)
        end
        if result and CCharacter.CBuffer[characterID] then
            for i, j in imports.pairs(characterDatas) do
                CCharacter.CBuffer[characterID][j] = result[j]
            end
        end
    end, ...)
    return true
end