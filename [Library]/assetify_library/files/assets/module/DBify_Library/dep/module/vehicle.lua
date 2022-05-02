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


-------------------------
--[[ Module: Vehicle ]]--
-------------------------

dbify.vehicle = {
    connection = {
        table = "server_vehicles",
        keyColumn = "id"
    },

    fetchAll = function(keyColumns, callback, ...)
        if not dbify.mysql.connection.instance then return false end
        return dbify.mysql.table.fetchContents(dbify.vehicle.connection.table, keyColumns, callback, ...)
    end,

    create = function(callback, ...)
        if not dbify.mysql.connection.instance then return false end
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

    delete = function(vehicleID, callback, ...)
        if not dbify.mysql.connection.instance then return false end
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

    setData = function(vehicleID, dataColumns, callback, ...)
        if not dbify.mysql.connection.instance then return false end
        if not vehicleID or (imports.type(vehicleID) ~= "number") or not dataColumns or (imports.type(dataColumns) ~= "table") or (#dataColumns <= 0) then return false end
        return dbify.mysql.data.set(dbify.vehicle.connection.table, dataColumns, {
            {dbify.vehicle.connection.keyColumn, vehicleID}
        }, callback, ...)
    end,

    getData = function(vehicleID, dataColumns, callback, ...)
        if not dbify.mysql.connection.instance then return false end
        if not vehicleID or (imports.type(vehicleID) ~= "number") or not dataColumns or (imports.type(dataColumns) ~= "table") or (#dataColumns <= 0) then return false end
        return dbify.mysql.data.get(dbify.vehicle.connection.table, dataColumns, {
            {dbify.vehicle.connection.keyColumn, vehicleID}
        }, true, callback, ...)
    end
}


-----------------------
--[[ Module Booter ]]--
-----------------------

imports.addEventHandler("onResourceStart", resourceRoot, function()
    if not dbify.mysql.connection.instance then return false end
    imports.dbExec(dbify.mysql.connection.instance, "CREATE TABLE IF NOT EXISTS `??` (`??` INT AUTO_INCREMENT PRIMARY KEY)", dbify.vehicle.connection.table, dbify.vehicle.connection.keyColumn)
end)