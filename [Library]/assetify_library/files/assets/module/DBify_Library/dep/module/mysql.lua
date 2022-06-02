-----------------
--[[ Imports ]]--
-----------------

local imports = {
    type = type,
    unpack = unpack,
    tostring = tostring,
    tonumber = tonumber,
    dbConnect = dbConnect,
    dbQuery = dbQuery,
    dbPoll = dbPoll,
    dbExec = dbExec,
    table = table
}

string.parse = function(rawString)
    if not rawString then return false end
    if imports.tostring(rawString) == "nil" then
        rawString = nil
    elseif imports.tostring(rawString) == "false" then
        rawString = false
    elseif imports.tostring(rawString) == "true" then
        rawString = true
    end
    return imports.tonumber(rawString) or rawString
end

dbify.parseArgs = function(callbackIndex, ...)
    local rawArgs = {...}
    local cThread, callbackIndex = rawArgs[1], imports.tonumber(callbackIndex)
    if cThread and thread:isInstance(cThread) then
        if not callbackIndex then return false end
        imports.table.remove(rawArgs, 1)
        imports.table.insert(rawArgs, callbackIndex, function(...) return cThread:resolve(...) end)
    end
    return imports.unpack(rawArgs)
end

dbify.fetchArg = function(index, pool)
    index = imports.tonumber(index) or 1
    if not pool or (imports.type(pool) ~= "table") then return false end
    local argValue = pool[index]
    if (index > 0) and (index <= #pool) then imports.table.remove(pool, index) end
    return argValue
end


-----------------------
--[[ Module: MySQL ]]--
-----------------------

dbify.mysql = {
    connection = {
        instance = imports.dbConnect("mysql", "dbname="..(dbify.settings.credentials.database)..";host="..(dbify.settings.credentials.host)..";port="..(dbify.settings.credentials.port)..";charset=utf8;", dbify.settings.credentials.username, dbify.settings.credentials.password, dbify.settings.credentials.options) or false
    },

    table = {
        isValid = function(...)
            if not dbify.mysql.connection.instance then return false end
            local cArgs = {dbify.parseArgs(2, ...)}
            local tableName, callback = dbify.fetchArg(_, cArgs), dbify.fetchArg(_, cArgs)
            if not tableName or (imports.type(tableName) ~= "string") or not callback or (imports.type(callback) ~= "function") then return false end
            imports.dbQuery(function(queryHandler, arguments)
                local callbackReference = callback
                local result = imports.dbPoll(queryHandler, 0)
                result = ((result and (#result > 0)) and true) or false
                if callbackReference and (imports.type(callbackReference) == "function") then
                    callbackReference(result, arguments)
                end
            end, {cArgs}, dbify.mysql.connection.instance, "SELECT `table_name` FROM information_schema.tables WHERE `table_schema`=? AND `table_name`=?", dbify.settings.credentials.database, tableName)
            return true
        end,

        fetchContents = function(...)
            if not dbify.mysql.connection.instance then return false end
            local cArgs = {dbify.parseArgs(3, ...)}
            local tableName, keyColumns, callback = dbify.fetchArg(_, cArgs), dbify.fetchArg(_, cArgs), dbify.fetchArg(_, cArgs)
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
                }, cArgs)
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
                end, imports.unpack(cArgs))
            end
        end
    },

    column = {
        isValid = function(...)
            if not dbify.mysql.connection.instance then return false end
            local cArgs = {dbify.parseArgs(3, ...)}
            local tableName, columnName, callback = dbify.fetchArg(_, cArgs), dbify.fetchArg(_, cArgs), dbify.fetchArg(_, cArgs)
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
            end, imports.unpack(cArgs))
        end,

        areValid = function(...)
            if not dbify.mysql.connection.instance then return false end
            local cArgs = {dbify.parseArgs(3, ...)}
            local tableName, columns, callback = dbify.fetchArg(_, cArgs), dbify.fetchArg(_, cArgs), dbify.fetchArg(_, cArgs)
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
            end, columns, cArgs)
        end,

        delete = function(...)
            if not dbify.mysql.connection.instance then return false end
            local cArgs = {dbify.parseArgs(3, ...)}
            local tableName, columns, callback = dbify.fetchArg(_, cArgs), dbify.fetchArg(_, cArgs), dbify.fetchArg(_, cArgs)
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
            end, columns, cArgs)
        end
    },

    data = {
        set = function(...)
            if not dbify.mysql.connection.instance then return false end
            local cArgs = {dbify.parseArgs(4, ...)}
            local tableName, dataColumns, keyColumns, callback = dbify.fetchArg(_, cArgs), dbify.fetchArg(_, cArgs), dbify.fetchArg(_, cArgs), dbify.fetchArg(_, cArgs)
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
            }, cArgs)
        end,

        get = function(...)
            if not dbify.mysql.connection.instance then return false end
            local cArgs = {dbify.parseArgs(5, ...)}
            local tableName, dataColumns, keyColumns, soloFetch, callback = dbify.fetchArg(_, cArgs), dbify.fetchArg(_, cArgs), dbify.fetchArg(_, cArgs), dbify.fetchArg(_, cArgs), dbify.fetchArg(_, cArgs)
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
            }, cArgs)
        end
    }
}