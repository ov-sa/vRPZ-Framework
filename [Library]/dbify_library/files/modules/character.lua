----------------------------------------------------------------
--[[ Resource: DBify Library
     Files: modules: character.lua
     Server: -
     Author: OvileAmriam
     Developer: Aviril
     DOC: 09/10/2021 (OvileAmriam)
     Desc: Character Module ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local imports = {
    type = type,
    addEventHandler = addEventHandler,
    dbQuery = dbQuery,
    dbPoll = dbPoll,
    dbExec = dbExec
}


-------------------
--[[ Variables ]]--
-------------------

dbify["character"] = {
    __connection__ = {
        table = "user_characters",
        keyColumn = "id"
    },

    fetchAll = function(keyColumns, callback, ...)
        if not dbify.mysql.__connection__.instance then return false end
        return dbify.mysql.table.fetchContents(dbify.character.__connection__.table, keyColumns, callback, ...)
    end,

    create = function(callback, ...)
        if not dbify.mysql.__connection__.instance then return false end
        if not callback or (imports.type(callback) ~= "function") then return false end
        imports.dbQuery(function(queryHandler, arguments)
            local callbackReference = callback
            local _, _, characterID = imports.dbPoll(queryHandler, 0)
            local result = characterID or false
            if callbackReference and (imports.type(callbackReference) == "function") then
                callbackReference(result, arguments)
            end
        end, {{...}}, dbify.mysql.__connection__.instance, "INSERT INTO `??` (`??`) VALUES(NULL)", dbify.character.__connection__.table, dbify.character.__connection__.keyColumn)
        return true
    end,

    delete = function(characterID, callback, ...)
        if not dbify.mysql.__connection__.instance then return false end
        if not characterID or (imports.type(characterID) ~= "number") then return false end
        return dbify.character.getData(characterID, {dbify.character.__connection__.keyColumn}, function(result, arguments)
            local callbackReference = callback
            if result then
                result = imports.dbExec(dbify.mysql.__connection__.instance, "DELETE FROM `??` WHERE `??`=?", dbify.character.__connection__.table, dbify.character.__connection__.keyColumn, characterID)
                if callbackReference and (imports.type(callbackReference) == "function") then
                    callbackReference(result, arguments)
                end
            else
                if callbackReference and (imports.type(callbackReference) == "function") then
                    callbackReference(false, arguments)
                end
            end
        end, ...)
    end,

    setData = function(characterID, dataColumns, callback, ...)
        if not dbify.mysql.__connection__.instance then return false end
        if not characterID or (imports.type(characterID) ~= "number") or not dataColumns or (imports.type(dataColumns) ~= "table") or (#dataColumns <= 0) then return false end
        return dbify.mysql.data.set(dbify.character.__connection__.table, dataColumns, {
            {dbify.character.__connection__.keyColumn, characterID}
        }, callback, ...)
    end,

    getData = function(characterID, dataColumns, callback, ...)
        if not dbify.mysql.__connection__.instance then return false end
        if not characterID or (imports.type(characterID) ~= "number") or not dataColumns or (imports.type(dataColumns) ~= "table") or (#dataColumns <= 0) then return false end
        return dbify.mysql.data.get(dbify.character.__connection__.table, dataColumns, {
            {dbify.character.__connection__.keyColumn, characterID}
        }, true, callback, ...)
    end
}


----------------------------------
--[[ Event: On Resource-Start ]]--
----------------------------------

imports.addEventHandler("onResourceStart", resourceRoot, function()

    if not dbify.mysql.__connection__.instance then return false end
    imports.dbExec(dbify.mysql.__connection__.instance, "CREATE TABLE IF NOT EXISTS `??` (`??` INT AUTO_INCREMENT PRIMARY KEY)", dbify.character.__connection__.table, dbify.character.__connection__.keyColumn)

end)