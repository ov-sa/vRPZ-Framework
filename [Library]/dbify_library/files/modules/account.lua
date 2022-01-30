----------------------------------------------------------------
--[[ Resource: DBify Library
     Files: modules: account.lua
     Server: -
     Author: OvileAmriam
     Developer: Aviril
     DOC: 09/10/2021 (OvileAmriam)
     Desc: Account Module ]]--
----------------------------------------------------------------


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
    dbExec = dbExec
}


-------------------
--[[ Variables ]]--
-------------------

dbify["account"] = {
    __connection__ = {
        table = "user_accounts",
        keyColumn = "name"
    },

    fetchAll = function(keyColumns, callback, ...)
        if not dbify.mysql.__connection__.instance then return false end
        return dbify.mysql.table.fetchContents(dbify.account.__connection__.table, keyColumns, callback, ...)
    end,

    create = function(accountName, callback, ...)
        if not dbify.mysql.__connection__.instance then return false end
        if not accountName or (imports.type(accountName) ~= "string") then return false end
        return dbify.account.getData(accountName, {dbify.account.__connection__.keyColumn}, function(result, arguments)
            local callbackReference = callback
            if not result then
                result = imports.dbExec(dbify.mysql.__connection__.instance, "INSERT INTO `??` (`??`) VALUES(?)", dbify.account.__connection__.table, dbify.account.__connection__.keyColumn, accountName)
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
        if not dbify.mysql.__connection__.instance then return false end
        if not accountName or (imports.type(accountName) ~= "string") then return false end
        return dbify.account.getData(accountName, {dbify.account.__connection__.keyColumn}, function(result, arguments)
            local callbackReference = callback
            if result then
                result = imports.dbExec(dbify.mysql.__connection__.instance, "DELETE FROM `??` WHERE `??`=?", dbify.account.__connection__.table, dbify.account.__connection__.keyColumn, accountName)
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
        if not dbify.mysql.__connection__.instance then return false end
        if not accountName or (imports.type(accountName) ~= "string") or not dataColumns or (imports.type(dataColumns) ~= "table") or (#dataColumns <= 0) then return false end
        return dbify.mysql.data.set(dbify.account.__connection__.table, dataColumns, {
            {dbify.account.__connection__.keyColumn, accountName}
        }, callback, ...)
    end,

    getData = function(accountName, dataColumns, callback, ...)
        if not dbify.mysql.__connection__.instance then return false end
        if not accountName or (imports.type(accountName) ~= "string") or not dataColumns or (imports.type(dataColumns) ~= "table") or (#dataColumns <= 0) then return false end
        return dbify.mysql.data.get(dbify.account.__connection__.table, dataColumns, {
            {dbify.account.__connection__.keyColumn, accountName}
        }, true, callback, ...)
    end
}


------------------------------------------------
--[[ Events: On Resource-Start/Player-Login ]]--
------------------------------------------------

imports.addEventHandler("onResourceStart", resourceRoot, function()

    if not dbify.mysql.__connection__.instance then return false end
    imports.dbExec(dbify.mysql.__connection__.instance, "CREATE TABLE IF NOT EXISTS `??` (`??` VARCHAR(100) PRIMARY KEY)", dbify.account.__connection__.table, dbify.account.__connection__.keyColumn)
    if dbify.account.__connection__.autoSync then
        local playerList = imports.getElementsByType("player")
        for i = 1, #playerList, 1 do
            local playerAccount = imports.getPlayerAccount(playerList[i])
            if playerAccount and not imports.isGuestAccount(playerAccount) then
                dbify.account.create(imports.getAccountName(playerAccount))
            end
        end
    end

end)

imports.addEventHandler("onPlayerLogin", root, function(_, playerAccount)

    if not dbify.mysql.__connection__.instance then return false end
    if dbify.account.__connection__.autoSync then
        dbify.account.create(imports.getAccountName(playerAccount))
    end

end)