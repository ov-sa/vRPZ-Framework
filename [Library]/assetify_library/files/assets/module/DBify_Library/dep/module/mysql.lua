-----------------
--[[ Imports ]]--
-----------------

local imports = {
    type = type,
    unpack = unpack,
    tostring = tostring,
    dbConnect = dbConnect,
    dbQuery = dbQuery,
    dbPoll = dbPoll,
    dbExec = dbExec,
    table = table
}


-----------------------
--[[ Module: MySQL ]]--
-----------------------

dbify.mysql = {
    connection = {
        instance = imports.dbConnect("mysql", "dbname="..(dbify.settings.credentials.database)..";host="..(dbify.settings.credentials.host)..";port="..(dbify.settings.credentials.port)..";charset=utf8;", dbify.settings.credentials.username, dbify.settings.credentials.password, dbify.settings.credentials.options) or false
    },

    table = {
        isValid = function(tableName, callback, ...)
            if not dbify.mysql.connection.instance then return false end
            if not tableName or (imports.type(tableName) ~= "string") or not callback or (imports.type(callback) ~= "function") then return false end
            imports.dbQuery(function(queryHandler, arguments)
                local callbackReference = callback
                local result = imports.dbPoll(queryHandler, 0)
                result = ((result and (#result > 0)) and true) or false
                if callbackReference and (imports.type(callbackReference) == "function") then
                    callbackReference(result, arguments)
                end
            end, {{...}}, dbify.mysql.connection.instance, "SELECT `table_name` FROM information_schema.tables WHERE `table_schema`=? AND `table_name`=?", dbify.settings.credentials.database, tableName)
            return true
        end,

        fetchContents = function(tableName, keyColumns, callback, ...)
            if not dbify.mysql.connection.instance then return false end
            if not tableName or (imports.type(tableName) ~= "string") or not callback or (imports.type(callback) ~= "function") then return false end
            keyColumns = ((keyColumns and (imports.type(keyColumns) == "table") and (#keyColumns > 0)) and keyColumns) or false
            if keyColumns then
                local _validateKeyColumns, validateKeyColumns = {}, {}
                for i = 1, #keyColumns, 1 do
                    local j = keyColumns[i]
                    if not _validateKeyColumns[(j[1])] then
                        imports.table.insert(validateKeyColumns, j[1])
                    end
                end
                return dbify.mysql.column.areValid(tableName, validateKeyColumns, function(areValid, arguments)
                    if areValid then
                        local queryString, queryArguments = "SELECT * FROM `??` WHERE", {arguments[1].tableName}
                        for i = 1, #arguments[1].keyColumns, 1 do
                            local j = arguments[1].keyColumns[i]
                            imports.table.insert(queryArguments, imports.tostring(j[1]))
                            imports.table.insert(queryArguments, imports.tostring(j[2]))
                            queryString = queryString.." `??`=?"..(((i < #arguments[1].keyColumns) and " AND") or "")
                        end
                        imports.dbQuery(function(queryHandler, arguments)
                            local callbackReference = callback
                            local result = imports.dbPoll(queryHandler, 0)
                            if result and (#result > 0) then
                                if callbackReference and (imports.type(callbackReference) == "function") then
                                    callbackReference(result, arguments)
                                end
                            else
                                callbackReference(false, arguments)
                            end
                        end, {arguments[2]}, dbify.mysql.connection.instance, queryString, imports.unpack(queryArguments))
                    else
                        local callbackReference = callback
                        if callbackReference and (imports.type(callbackReference) == "function") then
                            callbackReference(false, arguments[2])
                        end
                    end
                end, {
                    tableName = tableName,
                    keyColumns = keyColumns
                }, {...})
            else
                return dbify.mysql.table.isValid(tableName, function(isValid, arguments)
                    if isValid then
                        imports.dbQuery(function(queryHandler, arguments)
                            local callbackReference = callback
                            local result = imports.dbPoll(queryHandler, 0)
                            if result and (#result > 0) then
                                if callbackReference and (imports.type(callbackReference) == "function") then
                                    callbackReference(result, arguments)
                                end
                            else
                                callbackReference(false, arguments)
                            end
                        end, {arguments}, dbify.mysql.connection.instance, "SELECT * FROM `??`", tableName)
                    else
                        local callbackReference = callback
                        if callbackReference and (imports.type(callbackReference) == "function") then
                            callbackReference(false, arguments)
                        end
                    end
                end, ...)
            end
        end
    },

    column = {
        isValid = function(tableName, columnName, callback, ...)
            if not dbify.mysql.connection.instance then return false end
            if not tableName or (imports.type(tableName) ~= "string") or not columnName or (imports.type(columnName) ~= "string") or not callback or (imports.type(callback) ~= "function") then return false end
            return dbify.mysql.table.isValid(tableName, function(isValid, arguments)
                if isValid then
                    imports.dbQuery(function(queryHandler, arguments)
                        local callbackReference = callback
                        local result = imports.dbPoll(queryHandler, 0)
                        result = ((result and (#result > 0)) and true) or false
                        if callbackReference and (imports.type(callbackReference) == "function") then
                            callbackReference(result, arguments)
                        end
                    end, {arguments}, dbify.mysql.connection.instance, "SELECT `table_name` FROM information_schema.columns WHERE `table_schema`=? AND `table_name`=? AND `column_name`=?", dbify.settings.credentials.database, tableName, columnName)
                else
                    local callbackReference = callback
                    if callbackReference and (imports.type(callbackReference) == "function") then
                        callbackReference(false, arguments)
                    end
                end
            end, ...)
        end,

        areValid = function(tableName, columns, callback, ...)
            if not dbify.mysql.connection.instance then return false end
            if not tableName or (imports.type(tableName) ~= "string") or not columns or (imports.type(columns) ~= "table") or (#columns <= 0) or not callback or (imports.type(callback) ~= "function") then return false end
            return dbify.mysql.table.isValid(tableName, function(isValid, arguments)
                if isValid then
                    local queryString, queryArguments = "SELECT `table_name` FROM information_schema.columns WHERE `table_schema`=? AND `table_name`=? AND (", {dbify.settings.credentials.database, tableName}
                    for i = 1, #arguments[1], 1 do
                        local j = arguments[1][i]
                        imports.table.insert(queryArguments, imports.tostring(j))
                        queryString = queryString..(((i > 1) and " ") or "").."`column_name`=?"..(((i < #arguments[1]) and " OR") or "")
                    end
                    queryString = queryString..")"
                    imports.dbQuery(function(queryHandler, arguments)
                        local callbackReference = callback
                        local result = imports.dbPoll(queryHandler, 0)
                        result = ((result and (#result >= #arguments[1])) and true) or false
                        if callbackReference and (imports.type(callbackReference) == "function") then
                            callbackReference(result, arguments[2])
                        end
                    end, {arguments}, dbify.mysql.connection.instance, queryString, imports.unpack(queryArguments))
                else
                    local callbackReference = callback
                    if callbackReference and (imports.type(callbackReference) == "function") then
                        callbackReference(false, arguments[2])
                    end
                end
            end, columns, {...})
        end,

        delete = function(tableName, columns, callback, ...)
            if not dbify.mysql.connection.instance then return false end
            if not tableName or (imports.type(tableName) ~= "string") or not columns or (imports.type(columns) ~= "table") or (#columns <= 0) then return false end
            return dbify.mysql.table.isValid(tableName, function(isValid, arguments)
                if isValid then
                    local callbackReference = callback
                    local queryString, queryArguments = "ALTER TABLE `??`", {tableName}
                    for i = 1, #arguments[1], 1 do
                        local j = arguments[1][i]
                        imports.table.insert(queryArguments, imports.tostring(j))
                        queryString = queryString.." DROP COLUMN `??`"..(((i < #arguments[1]) and ", ") or "")
                    end
                    local result = imports.dbExec(dbify.mysql.connection.instance, queryString, imports.unpack(queryArguments))
                    if callbackReference and (imports.type(callbackReference) == "function") then
                        callbackReference(result, arguments[2])
                    end
                else
                    local callbackReference = callback
                    if callbackReference and (imports.type(callbackReference) == "function") then
                        callbackReference(false, arguments[2])
                    end
                end
            end, columns, {...})
        end
    },

    data = {
        set = function(tableName, dataColumns, keyColumns, callback, ...)
            if not dbify.mysql.connection.instance then return false end
            if not tableName or (imports.type(tableName) ~= "string") or not dataColumns or (imports.type(dataColumns) ~= "table") or (#dataColumns <= 0) or not keyColumns or (imports.type(keyColumns) ~= "table") or (#keyColumns <= 0) then return false end
            local _validateKeyColumns, validateKeyColumns = {}, {}
            for i = 1, #keyColumns, 1 do
                local j = keyColumns[i]
                if not _validateKeyColumns[(j[1])] then
                    imports.table.insert(validateKeyColumns, j[1])
                end
            end
            return dbify.mysql.column.areValid(tableName, validateKeyColumns, function(areValid, arguments)
                if areValid then
                    local queryStrings, queryArguments = {"UPDATE `??` SET", " WHERE"}, {subLength = 0, arguments = {}}
                    for i = 1, #arguments[1].keyColumns, 1 do
                        local j = arguments[1].keyColumns[i]
                        j[1] = imports.tostring(j[1])
                        imports.table.insert(queryArguments.arguments, j[1])
                        imports.table.insert(queryArguments.arguments, imports.tostring(j[2]))
                        queryStrings[2] = queryStrings[2].." `??`=?"..(((i < #arguments[1].keyColumns) and " AND") or "")
                    end
                    queryArguments.subLength = #queryArguments.arguments
                    imports.table.insert(queryArguments.arguments, (#queryArguments.arguments - queryArguments.subLength) + 1, arguments[1].tableName)
                    for i = 1, #arguments[1].dataColumns, 1 do
                        local j = arguments[1].dataColumns[i]
                        j[1] = imports.tostring(j[1])
                        imports.table.insert(queryArguments.arguments, (#queryArguments.arguments - queryArguments.subLength) + 1, j[1])
                        imports.table.insert(queryArguments.arguments, (#queryArguments.arguments - queryArguments.subLength) + 1, imports.tostring(j[2]))
                        queryStrings[1] = queryStrings[1].." `??`=?"..(((i < #arguments[1].dataColumns) and ",") or "")
                        dbify.mysql.column.isValid(arguments[1].tableName, j[1], function(isValid, arguments)
                            local callbackReference = callback
                            if not isValid then
                                imports.dbExec(dbify.mysql.connection.instance, "ALTER TABLE `??` ADD COLUMN `??` TEXT", arguments[1], arguments[2])
                            end
                            if arguments[3] then
                                local result = imports.dbExec(dbify.mysql.connection.instance, arguments[3].queryString, imports.unpack(arguments[3].queryArguments))
                                if callbackReference and (imports.type(callbackReference) == "function") then
                                    callbackReference(result, arguments[4])
                                end
                            end
                        end, arguments[1].tableName, j[1], ((i >= #arguments[1].dataColumns) and {
                            queryString = queryStrings[1]..queryStrings[2],
                            queryArguments = queryArguments.arguments
                        }) or false, ((i >= #arguments[1].dataColumns) and arguments[2]) or false)
                    end
                else
                    local callbackReference = callback
                    if callbackReference and (imports.type(callbackReference) == "function") then
                        callbackReference(false, arguments[2])
                    end
                end
            end, {
                tableName = tableName,
                dataColumns = dataColumns,
                keyColumns = keyColumns
            }, {...})
        end,

        get = function(tableName, dataColumns, keyColumns, soloFetch, callback, ...)
            if not dbify.mysql.connection.instance then return false end
            if not tableName or (imports.type(tableName) ~= "string") or not dataColumns or (imports.type(dataColumns) ~= "table") or (#dataColumns <= 0) or not keyColumns or (imports.type(keyColumns) ~= "table") or (#keyColumns <= 0) or not callback or (imports.type(callback) ~= "function") then return false end
            soloFetch = (soloFetch and true) or false
            local _validateColumns, validateColumns = {}, {}
            for i = 1, #dataColumns, 1 do
                local j = dataColumns[i]
                _validateColumns[j] = true
                imports.table.insert(validateColumns, j)
            end
            for i = 1, #keyColumns, 1 do
                local j = keyColumns[i]
                if not _validateColumns[(j[1])] then
                    _validateColumns[(j[1])] = true
                    imports.table.insert(validateColumns, j[1])
                end
            end
            return dbify.mysql.column.areValid(tableName, validateColumns, function(areValid, arguments)
                if areValid then
                    local queryString, queryArguments = "SELECT", {}
                    for i = 1, #arguments[1].dataColumns, 1 do
                        local j = arguments[1].dataColumns[i]
                        imports.table.insert(queryArguments, imports.tostring(j))
                        queryString = queryString.." `??`"..(((i < #arguments[1].dataColumns) and ",") or "")
                    end
                    imports.table.insert(queryArguments, arguments[1].tableName)
                    queryString = queryString.." FROM `??` WHERE"
                    for i = 1, #arguments[1].keyColumns, 1 do
                        local j = arguments[1].keyColumns[i]
                        imports.table.insert(queryArguments, imports.tostring(j[1]))
                        imports.table.insert(queryArguments, imports.tostring(j[2]))
                        queryString = queryString.." `??`=?"..(((i < #arguments[1].keyColumns) and " AND") or "")
                    end
                    imports.dbQuery(function(queryHandler, soloFetch, arguments)
                        local callbackReference = callback
                        local result = imports.dbPoll(queryHandler, 0)
                        if result and (#result > 0) then
                            if callbackReference and (imports.type(callbackReference) == "function") then
                                callbackReference((soloFetch and result[1]) or result, arguments)
                            end
                            return true
                        end
                        if callbackReference and (imports.type(callbackReference) == "function") then
                            callbackReference(false, arguments)
                        end
                    end, {arguments[1].soloFetch, arguments[2]}, dbify.mysql.connection.instance, queryString, imports.unpack(queryArguments))
                else
                    local callbackReference = callback
                    if callbackReference and (imports.type(callbackReference) == "function") then
                        callbackReference(false, arguments[2])
                    end
                end
            end, {
                tableName = tableName,
                dataColumns = dataColumns,
                keyColumns = keyColumns,
                soloFetch = soloFetch
            }, {...})
        end
    }
}