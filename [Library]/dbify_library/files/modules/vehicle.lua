----------------------------------------------------------------
--[[ Resource: DBify Library
     Files: modules: vehicle.lua
     Server: -
     Author: OvileAmriam
     Developer: Aviril
     DOC: 09/10/2021 (OvileAmriam)
     Desc: Vehicle Module ]]--
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

dbify["vehicle"] = {
    __connection__ = {
        table = "server_vehicles",
        keyColumn = "id"
    },

    fetchAll = function(keyColumns, callback, ...)
        if not dbify.mysql.__connection__.instance then return false end
        return dbify.mysql.table.fetchContents(dbify.vehicle.__connection__.table, keyColumns, callback, ...)
    end,

    create = function(callback, ...)
        if not dbify.mysql.__connection__.instance then return false end
        if not callback or (imports.type(callback) ~= "function") then return false end
        imports.dbQuery(function(queryHandler, arguments)
            local callbackReference = callback
            local _, _, vehicleID = imports.dbPoll(queryHandler, 0)
            local result = vehicleID or false
            if callbackReference and (imports.type(callbackReference) == "function") then
                callbackReference(result, arguments)
            end
        end, {{...}}, dbify.mysql.__connection__.instance, "INSERT INTO `??` (`??`) VALUES(NULL)", dbify.vehicle.__connection__.table, dbify.vehicle.__connection__.keyColumn)
        return true
    end,

    delete = function(vehicleID, callback, ...)
        if not dbify.mysql.__connection__.instance then return false end
        if not vehicleID or (imports.type(vehicleID) ~= "number") then return false end
        return dbify.vehicle.getData(vehicleID, {dbify.vehicle.__connection__.keyColumn}, function(result, arguments)
            local callbackReference = callback
            if result then
                result = imports.dbExec(dbify.mysql.__connection__.instance, "DELETE FROM `??` WHERE `??`=?", dbify.vehicle.__connection__.table, dbify.vehicle.__connection__.keyColumn, vehicleID)
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
        if not dbify.mysql.__connection__.instance then return false end
        if not vehicleID or (imports.type(vehicleID) ~= "number") or not dataColumns or (imports.type(dataColumns) ~= "table") or (#dataColumns <= 0) then return false end
        return dbify.mysql.data.set(dbify.vehicle.__connection__.table, dataColumns, {
            {dbify.vehicle.__connection__.keyColumn, vehicleID}
        }, callback, ...)
    end,

    getData = function(vehicleID, dataColumns, callback, ...)
        if not dbify.mysql.__connection__.instance then return false end
        if not vehicleID or (imports.type(vehicleID) ~= "number") or not dataColumns or (imports.type(dataColumns) ~= "table") or (#dataColumns <= 0) then return false end
        return dbify.mysql.data.get(dbify.vehicle.__connection__.table, dataColumns, {
            {dbify.vehicle.__connection__.keyColumn, vehicleID}
        }, true, callback, ...)
    end
}


----------------------------------
--[[ Event: On Resource-Start ]]--
----------------------------------

imports.addEventHandler("onResourceStart", resourceRoot, function()

    if not dbify.mysql.__connection__.instance then return false end
    imports.dbExec(dbify.mysql.__connection__.instance, "CREATE TABLE IF NOT EXISTS `??` (`??` INT AUTO_INCREMENT PRIMARY KEY)", dbify.vehicle.__connection__.table, dbify.vehicle.__connection__.keyColumn)

end)