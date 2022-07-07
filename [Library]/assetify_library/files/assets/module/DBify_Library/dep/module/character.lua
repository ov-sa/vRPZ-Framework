-----------------
--[[ Imports ]]--
-----------------

local imports = {
    type = type,
    addEventHandler = addEventHandler,
    dbQuery = dbQuery,
    dbPoll = dbPoll,
    dbExec = dbExec,
    table = table,
    assetify = assetify
}


---------------------------
--[[ Module: Character ]]--
---------------------------

dbify.character = {
    connection = {
        table = "dbify_characters",
        key = "id"
    },

    fetchAll = function(...)
        if not dbify.mysql.connection.instance then return false end
        local isAsync, cArgs = dbify.parseArgs(2, ...)
        local keyColumns, callback = dbify.fetchArg(_, cArgs), dbify.fetchArg(_, cArgs)
        local promise = function()
            return dbify.mysql.table.fetchContents(dbify.character.connection.table, keyColumns, callback, imports.table:unpack(cArgs))
        end
        return (isAsync and promise) or promise()
    end,

    create = function(...)
        if not dbify.mysql.connection.instance then return false end
        local isAsync, cArgs = dbify.parseArgs(1, ...)
        local callback = dbify.fetchArg(_, cArgs)
        if not callback or (imports.type(callback) ~= "function") then return false end
        local promise = function()
            imports.dbQuery(function(queryHandler, cArgs)
                local _, _, characterID = imports.dbPoll(queryHandler, 0)
                local result = characterID or false
                execFunction(callback, result, cArgs)
            end, {cArgs}, dbify.mysql.connection.instance, "INSERT INTO `??` (`??`) VALUES(NULL)", dbify.character.connection.table, dbify.character.connection.key)
            return true
        end
        return (isAsync and promise) or promise()
    end,

    delete = function(...)
        if not dbify.mysql.connection.instance then return false end
        local isAsync, cArgs = dbify.parseArgs(2, ...)
        local characterID, callback = dbify.fetchArg(_, cArgs), dbify.fetchArg(_, cArgs)
        if not characterID or (imports.type(characterID) ~= "number") then return false end
        local promise = function()
            return dbify.character.getData(characterID, {dbify.character.connection.key}, function(result, cArgs)
                if result then
                    result = imports.dbExec(dbify.mysql.connection.instance, "DELETE FROM `??` WHERE `??`=?", dbify.character.connection.table, dbify.character.connection.key, characterID)
                    execFunction(callback, result, cArgs)
                else
                    execFunction(callback, false, cArgs)
                end
            end, imports.table:unpack(cArgs))
        end
        return (isAsync and promise) or promise()
    end,

    setData = function(...)
        if not dbify.mysql.connection.instance then return false end
        local isAsync, cArgs = dbify.parseArgs(3, ...)
        local characterID, dataColumns, callback = dbify.fetchArg(_, cArgs), dbify.fetchArg(_, cArgs), dbify.fetchArg(_, cArgs)
        if not characterID or (imports.type(characterID) ~= "number") or not dataColumns or (imports.type(dataColumns) ~= "table") or (#dataColumns <= 0) then return false end
        local promise = function()
            return dbify.mysql.data.set(dbify.character.connection.table, dataColumns, {
                {dbify.character.connection.key, characterID}
            }, callback, imports.table:unpack(cArgs))
        end
        return (isAsync and promise) or promise()
    end,

    getData = function(...)
        if not dbify.mysql.connection.instance then return false end
        local isAsync, cArgs = dbify.parseArgs(3, ...)
        local characterID, dataColumns, callback = dbify.fetchArg(_, cArgs), dbify.fetchArg(_, cArgs), dbify.fetchArg(_, cArgs)
        if not characterID or (imports.type(characterID) ~= "number") or not dataColumns or (imports.type(dataColumns) ~= "table") or (#dataColumns <= 0) then return false end
        local promise = function()
            return dbify.mysql.data.get(dbify.character.connection.table, dataColumns, {
                {dbify.character.connection.key, characterID}
            }, true, callback, imports.table:unpack(cArgs))
        end
        return (isAsync and promise) or promise()
    end
}


-----------------------
--[[ Module Booter ]]--
-----------------------

imports.assetify.scheduler.execOnModuleLoad(function()
    if not dbify.mysql.connection.instance then return false end
    imports.dbExec(dbify.mysql.connection.instance, "CREATE TABLE IF NOT EXISTS `??` (`??` INT AUTO_INCREMENT PRIMARY KEY)", dbify.character.connection.table, dbify.character.connection.key)
end)