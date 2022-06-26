-----------------
--[[ Imports ]]--
-----------------

local imports = {
    type = type,
    getElementsByType = getElementsByType,
    addEventHandler = addEventHandler,
    getPlayerAccount = getPlayerAccount,
    isGuestAccount = isGuestAccount,
    getAccountName = getAccountName,
    dbExec = dbExec,
    table = table,
    assetify = assetify
}


-------------------------
--[[ Module: Account ]]--
-------------------------

dbify.account = {
    connection = {
        table = "dbify_accounts",
        key = "name"
    },

    fetchAll = function(...)
        if not dbify.mysql.connection.instance then return false end
        local isAsync, cArgs = dbify.parseArgs(2, ...)
        local keyColumns, callback = dbify.fetchArg(_, cArgs), dbify.fetchArg(_, cArgs)
        local promise = function()
            return dbify.mysql.table.fetchContents(dbify.account.connection.table, keyColumns, callback, imports.table.unpack(cArgs))
        end
        return (isAsync and promise) or promise()
    end,

    create = function(...)
        if not dbify.mysql.connection.instance then return false end
        local isAsync, cArgs = dbify.parseArgs(2, ...)
        local accountName, callback = dbify.fetchArg(_, cArgs), dbify.fetchArg(_, cArgs)
        if not accountName or (imports.type(accountName) ~= "string") then return false end
        local promise = function()
            return dbify.account.getData(accountName, {dbify.account.connection.key}, function(result, cArgs)
                local callback = callback
                if not result then
                    result = imports.dbExec(dbify.mysql.connection.instance, "INSERT INTO `??` (`??`) VALUES(?)", dbify.account.connection.table, dbify.account.connection.key, accountName)
                    if callback and (imports.type(callback) == "function") then
                        callback(result, cArgs)
                    end
                else
                    if callback and (imports.type(callback) == "function") then
                        callback(false, cArgs)
                    end
                end
            end, imports.table.unpack(cArgs))
        end
        return (isAsync and promise) or promise()
    end,

    delete = function(...)
        if not dbify.mysql.connection.instance then return false end
        local isAsync, cArgs = dbify.parseArgs(2, ...)
        local accountName, callback = dbify.fetchArg(_, cArgs), dbify.fetchArg(_, cArgs)
        if not accountName or (imports.type(accountName) ~= "string") then return false end
        local promise = function()
            return dbify.account.getData(accountName, {dbify.account.connection.key}, function(result, cArgs)
                local callback = callback
                if result then
                    result = imports.dbExec(dbify.mysql.connection.instance, "DELETE FROM `??` WHERE `??`=?", dbify.account.connection.table, dbify.account.connection.key, accountName)
                    if callback and (imports.type(callback) == "function") then
                        callback(result, cArgs)
                    end
                else
                    if callback and (imports.type(callback) == "function") then
                        callback(false, cArgs)
                    end
                end
            end, imports.table.unpack(cArgs))
        end
        return (isAsync and promise) or promise()
    end,

    setData = function(...)
        if not dbify.mysql.connection.instance then return false end
        local isAsync, cArgs = dbify.parseArgs(3, ...)
        local accountName, dataColumns, callback = dbify.fetchArg(_, cArgs), dbify.fetchArg(_, cArgs), dbify.fetchArg(_, cArgs)
        if not accountName or (imports.type(accountName) ~= "string") or not dataColumns or (imports.type(dataColumns) ~= "table") or (#dataColumns <= 0) then return false end
        local promise = function()
            return dbify.mysql.data.set(dbify.account.connection.table, dataColumns, {
                {dbify.account.connection.key, accountName}
            }, callback, imports.table.unpack(cArgs))
        end
        return (isAsync and promise) or promise()
    end,

    getData = function(...)
        if not dbify.mysql.connection.instance then return false end
        local isAsync, cArgs = dbify.parseArgs(3, ...)
        local accountName, dataColumns, callback = dbify.fetchArg(_, cArgs), dbify.fetchArg(_, cArgs), dbify.fetchArg(_, cArgs)
        if not accountName or (imports.type(accountName) ~= "string") or not dataColumns or (imports.type(dataColumns) ~= "table") or (#dataColumns <= 0) then return false end
        local promise = function()
            return dbify.mysql.data.get(dbify.account.connection.table, dataColumns, {
                {dbify.account.connection.key, accountName}
            }, true, callback, imports.table.unpack(cArgs))
        end
        return (isAsync and promise) or promise()
    end
}


-----------------------
--[[ Module Booter ]]--
-----------------------

imports.assetify.scheduler.execOnModuleLoad(function()
    if not dbify.mysql.connection.instance then return false end
    imports.dbExec(dbify.mysql.connection.instance, "CREATE TABLE IF NOT EXISTS `??` (`??` VARCHAR(100) PRIMARY KEY)", dbify.account.connection.table, dbify.account.connection.key)
    if dbify.settings.syncAccount then
        local playerList = imports.getElementsByType("player")
        for i = 1, #playerList, 1 do
            local playerAccount = imports.getPlayerAccount(playerList[i])
            if playerAccount and not imports.isGuestAccount(playerAccount) then
                dbify.account.create(imports.getAccountName(playerAccount))
            end
        end
        imports.addEventHandler("onPlayerLogin", root, function(_, currAccount)
            if not dbify.mysql.connection.instance then return false end
            dbify.account.create(imports.getAccountName(currAccount))
        end)
    end
end)