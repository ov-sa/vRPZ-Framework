-----------------
--[[ Imports ]]--
-----------------

local imports = {
    type = type,
    unpack = unpack,
    addEventHandler = addEventHandler,
    dbQuery = dbQuery,
    dbPoll = dbPoll,
    dbExec = dbExec,
    assetify = assetify
}


---------------------------
--[[ Module: Character ]]--
---------------------------

dbify.character = {
    connection = {
        table = "dbify_characters",
        keyColumn = "id"
    },

    fetchAll = function(...)
        if not dbify.mysql.connection.instance then return false end
        local isAsync, cArgs = {dbify.parseArgs(2, ...)}
        local keyColumns, callback = dbify.fetchArg(_, cArgs), dbify.fetchArg(_, cArgs)
        local promise = function()
            return dbify.mysql.table.fetchContents(dbify.character.connection.table, keyColumns, callback, imports.unpack(cArgs))
        end
        return (isAsync and promise) or promise()
    end,

    create = function(...)
        if not dbify.mysql.connection.instance then return false end
        local isAsync, cArgs = {dbify.parseArgs(1, ...)}
        local callback = dbify.fetchArg(_, cArgs)
        if not callback or (imports.type(callback) ~= "function") then return false end
        local promise = function()
            imports.dbQuery(function(queryHandler, arguments)
                local cbRef = callback
                local _, _, characterID = imports.dbPoll(queryHandler, 0)
                local result = characterID or false
                if cbRef and (imports.type(cbRef) == "function") then
                    cbRef(result, arguments)
                end
            end, {cArgs}, dbify.mysql.connection.instance, "INSERT INTO `??` (`??`) VALUES(NULL)", dbify.character.connection.table, dbify.character.connection.keyColumn)
            return true
        end
        return (isAsync and promise) or promise()
    end,

    delete = function(...)
        if not dbify.mysql.connection.instance then return false end
        local isAsync, cArgs = {dbify.parseArgs(2, ...)}
        local characterID, callback = dbify.fetchArg(_, cArgs), dbify.fetchArg(_, cArgs)
        if not characterID or (imports.type(characterID) ~= "number") then return false end
        local promise = function()
            return dbify.character.getData(characterID, {dbify.character.connection.keyColumn}, function(result, arguments)
                local cbRef = callback
                if result then
                    result = imports.dbExec(dbify.mysql.connection.instance, "DELETE FROM `??` WHERE `??`=?", dbify.character.connection.table, dbify.character.connection.keyColumn, characterID)
                    if cbRef and (imports.type(cbRef) == "function") then
                        cbRef(result, arguments)
                    end
                else
                    if cbRef and (imports.type(cbRef) == "function") then
                        cbRef(false, arguments)
                    end
                end
            end, imports.unpack(cArgs))
        end
        return (isAsync and promise) or promise()
    end,

    setData = function(...)
        if not dbify.mysql.connection.instance then return false end
        local isAsync, cArgs = {dbify.parseArgs(3, ...)}
        local characterID, dataColumns, callback = dbify.fetchArg(_, cArgs), dbify.fetchArg(_, cArgs), dbify.fetchArg(_, cArgs)
        if not characterID or (imports.type(characterID) ~= "number") or not dataColumns or (imports.type(dataColumns) ~= "table") or (#dataColumns <= 0) then return false end
        local promise = function()
            return dbify.mysql.data.set(dbify.character.connection.table, dataColumns, {
                {dbify.character.connection.keyColumn, characterID}
            }, callback, imports.unpack(cArgs))
        end
        return (isAsync and promise) or promise()
    end,

    getData = function(...)
        if not dbify.mysql.connection.instance then return false end
        local isAsync, cArgs = {dbify.parseArgs(3, ...)}
        local characterID, dataColumns, callback = dbify.fetchArg(_, cArgs), dbify.fetchArg(_, cArgs), dbify.fetchArg(_, cArgs)
        if not characterID or (imports.type(characterID) ~= "number") or not dataColumns or (imports.type(dataColumns) ~= "table") or (#dataColumns <= 0) then return false end
        local promise = function()
            return dbify.mysql.data.get(dbify.character.connection.table, dataColumns, {
                {dbify.character.connection.keyColumn, characterID}
            }, true, callback, imports.unpack(cArgs))
        end
        return (isAsync and promise) or promise()
    end
}


-----------------------
--[[ Module Booter ]]--
-----------------------

imports.assetify.execOnModuleLoad(function()
    if not dbify.mysql.connection.instance then return false end
    imports.dbExec(dbify.mysql.connection.instance, "CREATE TABLE IF NOT EXISTS `??` (`??` INT AUTO_INCREMENT PRIMARY KEY)", dbify.character.connection.table, dbify.character.connection.keyColumn)
end)