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
    pairs = pairs,
    tonumber = tonumber,
    table = table
}


----------------------------------------------------
--[[ Functions: Retrieves/Sets Character's Data ]]--
----------------------------------------------------

function getCharacterData(characterID, data, viaFetch)

    characterID = imports.tonumber(characterID)
    if not characterID or not CCharacter.buffer[characterID] then return false end

    if not viaFetch then
        return CCharacter.buffer[characterID][data]
    else
        return exports.mysql_library:getRowData(connection.tableName, characterID, connection.keyColumnName, data)
    end

end

function setCharacterData(characterID, data, value)

    characterID = imports.tonumber(characterID)
    if not characterID or not CCharacter.buffer[characterID] then return false end

    if not exports.mysql_library:setRowData(connection.tableName, characterID, connection.keyColumnName, data, tostring(value)) then return false end
    CCharacter.buffer[characterID][data] = value
    return true

end


-------------------------
--[[ Character Class ]]--
-------------------------

CCharacter = {
    buffer = {},

    fetchCharacters = function(characterID, ...)
        characterID = imports.tonumber(characterID)
        if not characterID or not CCharacter.buffer[characterID] then return false end
        dbify.character.fetchAll({
            {dbify.character.__connection__.keyColumn, characterID}
        }, ...)
        return true
    end,

    create = function(serial)
        if (not serial or (imports.type(serial) ~= "string")) then return false end
        dbify.character.create(function(characterID, characterOwner)
            dbify.character.setData(characterID, {
                {"owner", characterOwner}
            })
        end, serial)
        return true
    end,

    delete = function(characterID)
        characterID = imports.tonumber(characterID)
        if not characterID or not CCharacter.buffer[characterID] then return false end
        dbify.character.delete(characterID, function(result)
            if result then
                CCharacter.buffer[characterID] = nil
            end
        end)
        return true
    end
}