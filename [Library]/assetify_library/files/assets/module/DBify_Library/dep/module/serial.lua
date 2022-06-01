-----------------
--[[ Imports ]]--
-----------------

local imports = {
    type = type,
    getElementsByType = getElementsByType,
    addEventHandler = addEventHandler,
    getPlayerSerial = getPlayerSerial,
    dbExec = dbExec,
    assetify = assetify
}


------------------------
--[[ Module: Serial ]]--
------------------------

dbify.serial = {
    connection = {
        table = "dbify_serials",
        keyColumn = "serial"
    },
    async = {
        fetchAll = 2,
        create = 2,
        delete = 2,
        setData = 3,
        getData = 3
    },

    fetchAll = function(keyColumns, callback, ...)
        if not dbify.mysql.connection.instance then return false end
        return dbify.mysql.table.fetchContents(dbify.serial.connection.table, keyColumns, callback, ...)
    end,

    create = function(serial, callback, ...)
        if not dbify.mysql.connection.instance then return false end
        if not serial or (imports.type(serial) ~= "string") then return false end
        return dbify.serial.getData(serial, {dbify.serial.connection.keyColumn}, function(result, arguments)
            local callbackReference = callback
            if not result then
                result = imports.dbExec(dbify.mysql.connection.instance, "INSERT INTO `??` (`??`) VALUES(?)", dbify.serial.connection.table, dbify.serial.connection.keyColumn, serial)
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

    delete = function(serial, callback, ...)
        if not dbify.mysql.connection.instance then return false end
        if not serial or (imports.type(serial) ~= "string") then return false end
        return dbify.serial.getData(serial, {dbify.serial.connection.keyColumn}, function(result, arguments)
            local callbackReference = callback
            if result then
                result = imports.dbExec(dbify.mysql.connection.instance, "DELETE FROM `??` WHERE `??`=?", dbify.serial.connection.table, dbify.serial.connection.keyColumn, serial)
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

    setData = function(serial, dataColumns, callback, ...)
        if not dbify.mysql.connection.instance then return false end
        if not serial or (imports.type(serial) ~= "string") or not dataColumns or (imports.type(dataColumns) ~= "table") or (#dataColumns <= 0) then return false end
        return dbify.mysql.data.set(dbify.serial.connection.table, dataColumns, {
            {dbify.serial.connection.keyColumn, serial}
        }, callback, ...)
    end,

    getData = function(serial, dataColumns, callback, ...)
        if not dbify.mysql.connection.instance then return false end
        if not serial or (imports.type(serial) ~= "string") or not dataColumns or (imports.type(dataColumns) ~= "table") or (#dataColumns <= 0) then return false end
        return dbify.mysql.data.get(dbify.serial.connection.table, dataColumns, {
            {dbify.serial.connection.keyColumn, serial}
        }, true, callback, ...)
    end
}
dbify.createAsync(dbify.serial)


-----------------------
--[[ Module Booter ]]--
-----------------------

imports.assetify.execOnModuleLoad(function()
    if not dbify.mysql.connection.instance then return false end
    imports.dbExec(dbify.mysql.connection.instance, "CREATE TABLE IF NOT EXISTS `??` (`??` VARCHAR(100) PRIMARY KEY)", dbify.serial.connection.table, dbify.serial.connection.keyColumn)
    if dbify.settings.syncSerial then
        local playerList = imports.getElementsByType("player")
        for i = 1, #playerList, 1 do
            local playerSerial = imports.getPlayerSerial(playerList[i])
            dbify.serial.create(playerSerial)
        end
        imports.addEventHandler("onPlayerJoin", root, function()
            if not dbify.mysql.connection.instance then return false end
            dbify.serial.create(imports.getPlayerSerial(source))
        end)
    end
end)