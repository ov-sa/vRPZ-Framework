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
    assetify = assetify
}


-------------------------
--[[ Module: Account ]]--
-------------------------

dbify.account = {
    connection = {
        table = "dbify_accounts",
        keyColumn = "name"
    },

    fetchAll = function(keyColumns, callback, ...)
        if not dbify.mysql.connection.instance then return false end
        return dbify.mysql.table.fetchContents(dbify.account.connection.table, keyColumns, callback, ...)
    end,

    create = function(accountName, callback, ...)
        if not dbify.mysql.connection.instance then return false end
        if not accountName or (imports.type(accountName) ~= "string") then return false end
        return dbify.account.getData(accountName, {dbify.account.connection.keyColumn}, function(result, arguments)
            local callbackReference = callback
            if not result then
                result = imports.dbExec(dbify.mysql.connection.instance, "INSERT INTO `??` (`??`) VALUES(?)", dbify.account.connection.table, dbify.account.connection.keyColumn, accountName)
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

    delete = function(accountName, callback, ...)
        if not dbify.mysql.connection.instance then return false end
        if not accountName or (imports.type(accountName) ~= "string") then return false end
        return dbify.account.getData(accountName, {dbify.account.connection.keyColumn}, function(result, arguments)
            local callbackReference = callback
            if result then
                result = imports.dbExec(dbify.mysql.connection.instance, "DELETE FROM `??` WHERE `??`=?", dbify.account.connection.table, dbify.account.connection.keyColumn, accountName)
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

    setData = function(accountName, dataColumns, callback, ...)
        if not dbify.mysql.connection.instance then return false end
        if not accountName or (imports.type(accountName) ~= "string") or not dataColumns or (imports.type(dataColumns) ~= "table") or (#dataColumns <= 0) then return false end
        return dbify.mysql.data.set(dbify.account.connection.table, dataColumns, {
            {dbify.account.connection.keyColumn, accountName}
        }, callback, ...)
    end,

    getData = function(accountName, dataColumns, callback, ...)
        if not dbify.mysql.connection.instance then return false end
        if not accountName or (imports.type(accountName) ~= "string") or not dataColumns or (imports.type(dataColumns) ~= "table") or (#dataColumns <= 0) then return false end
        return dbify.mysql.data.get(dbify.account.connection.table, dataColumns, {
            {dbify.account.connection.keyColumn, accountName}
        }, true, callback, ...)
    end
}


-----------------------
--[[ Module Booter ]]--
-----------------------

imports.assetify.execOnModuleLoad(function()
    if not dbify.mysql.connection.instance then return false end
    imports.dbExec(dbify.mysql.connection.instance, "CREATE TABLE IF NOT EXISTS `??` (`??` VARCHAR(100) PRIMARY KEY)", dbify.account.connection.table, dbify.account.connection.keyColumn)
    if dbify.account.connection.autoSync then
        local playerList = imports.getElementsByType("player")
        for i = 1, #playerList, 1 do
            local playerAccount = imports.getPlayerAccount(playerList[i])
            if playerAccount and not imports.isGuestAccount(playerAccount) then
                dbify.account.create(imports.getAccountName(playerAccount))
            end
        end
    end

    if dbify.settings.syncAccount then
        imports.addEventHandler("onPlayerLogin", root, function(_, playerAccount)
            if not dbify.mysql.connection.instance then return false end
            dbify.account.create(imports.getAccountName(playerAccount))
        end)
    end
end)