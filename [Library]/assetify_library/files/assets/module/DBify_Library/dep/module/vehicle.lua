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


-------------------------
--[[ Module: Vehicle ]]--
-------------------------

dbify.vehicle = {
    connection = {
        table = "dbify_vehicles",
        keyColumn = "id"
    },

    fetchAll = function(...)
        if not dbify.mysql.connection.instance then return false end
        local isAsync, cArgs = {dbify.parseArgs(2, ...)}
        local keyColumns, callback = dbify.fetchArg(_, cArgs), dbify.fetchArg(_, cArgs)
        local promise = function()
            return dbify.mysql.table.fetchContents(dbify.vehicle.connection.table, keyColumns, callback, imports.unpack(cArgs))
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
                local callbackReference = callback
                local _, _, vehicleID = imports.dbPoll(queryHandler, 0)
                local result = vehicleID or false
                if callbackReference and (imports.type(callbackReference) == "function") then
                    callbackReference(result, arguments)
                end
            end, {cArgs}, dbify.mysql.connection.instance, "INSERT INTO `??` (`??`) VALUES(NULL)", dbify.vehicle.connection.table, dbify.vehicle.connection.keyColumn)
            return true
        end
        return (isAsync and promise) or promise()
    end,

    delete = function(...)
        if not dbify.mysql.connection.instance then return false end
        local isAsync, cArgs = {dbify.parseArgs(2, ...)}
        local vehicleID, callback = dbify.fetchArg(_, cArgs), dbify.fetchArg(_, cArgs)
        if not vehicleID or (imports.type(vehicleID) ~= "number") then return false end
        local promise = function()
            return dbify.vehicle.getData(vehicleID, {dbify.vehicle.connection.keyColumn}, function(result, arguments)
                local callbackReference = callback
                if result then
                    result = imports.dbExec(dbify.mysql.connection.instance, "DELETE FROM `??` WHERE `??`=?", dbify.vehicle.connection.table, dbify.vehicle.connection.keyColumn, vehicleID)
                    if callbackReference and (imports.type(callbackReference) == "function") then
                        callbackReference(result, arguments)
                    end
                else
                    if callbackReference and (imports.type(callbackReference) == "function") then
                        callbackReference(false, arguments)
                    end
                end
            end, imports.unpack(cArgs))
        end
        return (isAsync and promise) or promise()
    end,

    setData = function(...)
        if not dbify.mysql.connection.instance then return false end
        local isAsync, cArgs = {dbify.parseArgs(3, ...)}
        local vehicleID, dataColumns, callback = dbify.fetchArg(_, cArgs), dbify.fetchArg(_, cArgs), dbify.fetchArg(_, cArgs)
        if not vehicleID or (imports.type(vehicleID) ~= "number") or not dataColumns or (imports.type(dataColumns) ~= "table") or (#dataColumns <= 0) then return false end
        local promise = function()
            return dbify.mysql.data.set(dbify.vehicle.connection.table, dataColumns, {
                {dbify.vehicle.connection.keyColumn, vehicleID}
            }, callback, imports.unpack(cArgs))
        end
        return (isAsync and promise) or promise()
    end,

    getData = function(...)
        if not dbify.mysql.connection.instance then return false end
        local isAsync, cArgs = {dbify.parseArgs(3, ...)}
        local vehicleID, dataColumns, callback = dbify.fetchArg(_, cArgs), dbify.fetchArg(_, cArgs), dbify.fetchArg(_, cArgs)
        if not vehicleID or (imports.type(vehicleID) ~= "number") or not dataColumns or (imports.type(dataColumns) ~= "table") or (#dataColumns <= 0) then return false end
        local promise = function()
            return dbify.mysql.data.get(dbify.vehicle.connection.table, dataColumns, {
                {dbify.vehicle.connection.keyColumn, vehicleID}
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
    imports.dbExec(dbify.mysql.connection.instance, "CREATE TABLE IF NOT EXISTS `??` (`??` INT AUTO_INCREMENT PRIMARY KEY)", dbify.vehicle.connection.table, dbify.vehicle.connection.keyColumn)
end)