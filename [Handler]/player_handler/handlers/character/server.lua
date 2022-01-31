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
    tonumber = tonumber,
    table = table
}


-------------------------
--[[ Character Class ]]--
-------------------------

CCharacter = {
    buffer = {},

    fetchCharacters = function(characterID, ...)
        characterID = imports.tonumber(characterID)
        if not characterID then return false end
        dbify.character.fetchAll({
            {dbify.character.__connection__.keyColumn, characterID}
        }, ...)
        return true
    end,

    create = function(serial)
        if (not serial or (imports.type(serial) ~= "string")) then return false end
        dbify.character.create(function(characterID, characterOwner)
            CCharacter.buffer[characterID] = {
                {"owner", characterOwner}
            }
            dbify.character.setData(characterID, CCharacter.buffer[characterID])
        end, serial)
        return true
    end,

    delete = function(characterID)
        characterID = imports.tonumber(characterID)
        if not characterID then return false end
        dbify.character.delete(characterID, function(result)
            if result then
                CCharacter.buffer[characterID] = nil
            end
        end)
        return true
    end,

    setData = function(characterID, ...)
        dbify.character.setData(characterID, characterDatas, ...)
        --return CCharacter.buffer[characterID][data]
        return true
    end,

    getData = function(characterID, ...)
        dbify.character.getData(characterID, ...)
        --USE CALLBACK..
        --CCharacter.buffer[characterID][data] = value
        return true
    end
}