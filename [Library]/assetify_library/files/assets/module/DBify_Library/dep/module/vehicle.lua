-----------------
--[[ Imports ]]--
-----------------

local imports = {
    type = type,
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
    async = {
        fetchAll = 2,
        create = 1,
        delete = 2,
        setData = 3,
        getData = 3
    },

    fetchAll = function(...)
        if not dbify.mysql.connection.instance then return false end
        local keyColumns, callback, ... = dbify.parse(2, ...)
        return dbify.mysql.table.fetchContents(dbify.vehicle.connection.table, keyColumns, callback, ...)
    end,

    create = function(...)
        if not dbify.mysql.connection.instance then return false end
        local callback, ... = dbify.parse(1, ...)
        if not callback or (imports.type(callback) ~= "function") then return false end
        imports.dbQuery(function(queryHandler, arguments)
            local callbackReference = callback
            local _, _, vehicleID = imports.dbPoll(queryHandler, 0)
            local result = vehicleID or false
            if callbackReference and (imports.type(callbackReference) == "function") then
                callbackReference(result, arguments)
            end
        end, {{...}}, dbify.mysql.connection.instance, "INSERT INTO `??` (`??`) VALUES(NULL)", dbify.vehicle.connection.table, dbify.vehicle.connection.keyColumn)
        return true
    end,

    delete = function(...)
        if not dbify.mysql.connection.instance then return false end
        local vehicleID, callback, ... = dbify.parse(2, ...)
        if not vehicleID or (imports.type(vehicleID) ~= "number") then return false end
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
        end, ...)
    end,

    setData = function(...)
        if not dbify.mysql.connection.instance then return false end
        local vehicleID, dataColumns, callback, ... = dbify.parse(3, ...)
        if not vehicleID or (imports.type(vehicleID) ~= "number") or not dataColumns or (imports.type(dataColumns) ~= "table") or (#dataColumns <= 0) then return false end
        return dbify.mysql.data.set(dbify.vehicle.connection.table, dataColumns, {
            {dbify.vehicle.connection.keyColumn, vehicleID}
        }, callback, ...)
    end,

    getData = function(...)
        if not dbify.mysql.connection.instance then return false end
        local vehicleID, dataColumns, callback, ... = dbify.parse(3, ...)
        if not vehicleID or (imports.type(vehicleID) ~= "number") or not dataColumns or (imports.type(dataColumns) ~= "table") or (#dataColumns <= 0) then return false end
        return dbify.mysql.data.get(dbify.vehicle.connection.table, dataColumns, {
            {dbify.vehicle.connection.keyColumn, vehicleID}
        }, true, callback, ...)
    end
}


-----------------------
--[[ Module Booter ]]--
-----------------------

imports.assetify.execOnModuleLoad(function()
    if not dbify.mysql.connection.instance then return false end
    imports.dbExec(dbify.mysql.connection.instance, "CREATE TABLE IF NOT EXISTS `??` (`??` INT AUTO_INCREMENT PRIMARY KEY)", dbify.vehicle.connection.table, dbify.vehicle.connection.keyColumn)
end)