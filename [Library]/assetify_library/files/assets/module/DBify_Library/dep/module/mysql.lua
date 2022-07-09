-----------------
--[[ Imports ]]--
-----------------

loadstring(exports.assetify_library:import("threader"))()
local imports = {
    type = type,
    tostring = tostring,
    tonumber = tonumber,
    dbConnect = dbConnect,
    dbQuery = dbQuery,
    dbPoll = dbPoll,
    dbExec = dbExec,
    table = table,
    assetify = assetify
}

dbify.parseArgs = function(cbIndex, ...)
    local rawArgs = imports.table.pack(...)
    local cThread, cbIndex = rawArgs[1], imports.tonumber(cbIndex)
    if cThread and imports.assetify.thread:isInstance(cThread) then
        if not cbIndex then return false end
        imports.table.remove(rawArgs, 1)
        imports.table.insert(rawArgs, cbIndex, function(...) return cThread:resolve(...) end)
        return true, rawArgs
    end
    return false, rawArgs
end

dbify.fetchArg = function(index, pool)
    index = imports.tonumber(index) or 1
    if not pool or (imports.type(pool) ~= "table") then return false end
    local argValue = pool[index]
    imports.table.remove(pool, index)
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
            local isAsync, cArgs = dbify.parseArgs(2, ...)
            local tableName, callback = dbify.fetchArg(_, cArgs), dbify.fetchArg(_, cArgs)
            if not tableName or (imports.type(tableName) ~= "string") or not callback or (imports.type(callback) ~= "function") then return false end
            local promise = function()
                imports.dbQuery(function(queryHandler, cArgs)
                    local result = imports.dbPoll(queryHandler, 0)
                    result = ((result and (#result > 0)) and true) or false
                    execFunction(callback, result, cArgs)
                end, {cArgs}, dbify.mysql.connection.instance, "SELECT `table_name` FROM information_schema.tables WHERE `table_schema`=? AND `table_name`=?", dbify.settings.credentials.database, tableName)
                return true
            end
            return (isAsync and promise) or promise()
        end,

        fetchContents = function(...)
            if not dbify.mysql.connection.instance then return false end
            local isAsync, cArgs = dbify.parseArgs(3, ...)
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
                local promise = function()
                    return dbify.mysql.column.areValid(tableName, validateKeyColumns, function(areValid, cArgs)
                        if areValid then
                            local queryString, queryArguments = "SELECT * FROM `??` WHERE", {cArgs[1].tableName}
                            for i = 1, #cArgs[1].keyColumns, 1 do
                                local j = cArgs[1].keyColumns[i]
                                imports.table.insert(queryArguments, imports.tostring(j[1]))
                                imports.table.insert(queryArguments, imports.tostring(j[2]))
                                queryString = queryString.." `??`=?"..(((i < #cArgs[1].keyColumns) and " AND") or "")
                            end
                            imports.dbQuery(function(queryHandler, cArgs)
                                local result = imports.dbPoll(queryHandler, 0)
                                if result and (#result > 0) then
                                    execFunction(callback, result, cArgs)
                                else
                                    execFunction(callback, false, cArgs)
                                end
                            end, {cArgs[2]}, dbify.mysql.connection.instance, queryString, imports.table.unpack(queryArguments))
                        else
                            execFunction(callback, false, cArgs[2])
                        end
                    end, {
                        tableName = tableName,
                        keyColumns = keyColumns
                    }, cArgs)
                end
                return (isAsync and promise) or promise()
            else
                local promise = function()
                    return dbify.mysql.table.isValid(tableName, function(isValid, cArgs)
                        if isValid then
                            imports.dbQuery(function(queryHandler, cArgs)
                                local result = imports.dbPoll(queryHandler, 0)
                                if result and (#result > 0) then
                                    execFunction(callback, result, cArgs)
                                else
                                    execFunction(callback, false, cArgs)
                                end
                            end, {cArgs}, dbify.mysql.connection.instance, "SELECT * FROM `??`", tableName)
                        else
                            execFunction(callback, false, cArgs)
                        end
                    end, imports.table.unpack(cArgs))
                end
                return (isAsync and promise) or promise()
            end
        end
    },

    column = {
        isValid = function(...)
            if not dbify.mysql.connection.instance then return false end
            local isAsync, cArgs = dbify.parseArgs(3, ...)
            local tableName, columnName, callback = dbify.fetchArg(_, cArgs), dbify.fetchArg(_, cArgs), dbify.fetchArg(_, cArgs)
            if not tableName or (imports.type(tableName) ~= "string") or not columnName or (imports.type(columnName) ~= "string") or not callback or (imports.type(callback) ~= "function") then return false end
            local promise = function()
                return dbify.mysql.table.isValid(tableName, function(isValid, cArgs)
                    if isValid then
                        imports.dbQuery(function(queryHandler, cArgs)
                            local result = imports.dbPoll(queryHandler, 0)
                            result = ((result and (#result > 0)) and true) or false
                            execFunction(callback, result, cArgs)
                        end, {cArgs}, dbify.mysql.connection.instance, "SELECT `table_name` FROM information_schema.columns WHERE `table_schema`=? AND `table_name`=? AND `column_name`=?", dbify.settings.credentials.database, tableName, columnName)
                    else
                        execFunction(callback, false, cArgs)
                    end
                end, imports.table.unpack(cArgs))
            end
            return (isAsync and promise) or promise()
        end,

        areValid = function(...)
            if not dbify.mysql.connection.instance then return false end
            local isAsync, cArgs = dbify.parseArgs(3, ...)
            local tableName, columns, callback = dbify.fetchArg(_, cArgs), dbify.fetchArg(_, cArgs), dbify.fetchArg(_, cArgs)
            if not tableName or (imports.type(tableName) ~= "string") or not columns or (imports.type(columns) ~= "table") or (#columns <= 0) or not callback or (imports.type(callback) ~= "function") then return false end
            local promise = function()
                return dbify.mysql.table.isValid(tableName, function(isValid, cArgs)
                    if isValid then
                        local queryString, queryArguments = "SELECT `table_name` FROM information_schema.columns WHERE `table_schema`=? AND `table_name`=? AND (", {dbify.settings.credentials.database, tableName}
                        for i = 1, #cArgs[1], 1 do
                            local j = cArgs[1][i]
                            imports.table.insert(queryArguments, imports.tostring(j))
                            queryString = queryString..(((i > 1) and " ") or "").."`column_name`=?"..(((i < #cArgs[1]) and " OR") or "")
                        end
                        queryString = queryString..")"
                        imports.dbQuery(function(queryHandler, cArgs)
                            local result = imports.dbPoll(queryHandler, 0)
                            result = ((result and (#result >= #cArgs[1])) and true) or false
                            execFunction(callback, result, cArgs[2])
                        end, {cArgs}, dbify.mysql.connection.instance, queryString, imports.table.unpack(queryArguments))
                    else
                        execFunction(callback, false, cArgs[2])
                    end
                end, columns, cArgs)
            end
            return (isAsync and promise) or promise()
        end,

        delete = function(...)
            if not dbify.mysql.connection.instance then return false end
            local isAsync, cArgs = dbify.parseArgs(3, ...)
            local tableName, columns, callback = dbify.fetchArg(_, cArgs), dbify.fetchArg(_, cArgs), dbify.fetchArg(_, cArgs)
            if not tableName or (imports.type(tableName) ~= "string") or not columns or (imports.type(columns) ~= "table") or (#columns <= 0) then return false end
            local promise = function()
                return dbify.mysql.table.isValid(tableName, function(isValid, cArgs)
                    if isValid then
                        local queryString, queryArguments = "ALTER TABLE `??`", {tableName}
                        for i = 1, #cArgs[1], 1 do
                            local j = cArgs[1][i]
                            imports.table.insert(queryArguments, imports.tostring(j))
                            queryString = queryString.." DROP COLUMN `??`"..(((i < #cArgs[1]) and ", ") or "")
                        end
                        local result = imports.dbExec(dbify.mysql.connection.instance, queryString, imports.table.unpack(queryArguments))
                        execFunction(callback, result, cArgs[2])
                    else
                        execFunction(callback, false, cArgs[2])
                    end
                end, columns, cArgs)
            end
            return (isAsync and promise) or promise()
        end
    },

    data = {
        set = function(...)
            if not dbify.mysql.connection.instance then return false end
            local isAsync, cArgs = dbify.parseArgs(4, ...)
            local tableName, dataColumns, keyColumns, callback = dbify.fetchArg(_, cArgs), dbify.fetchArg(_, cArgs), dbify.fetchArg(_, cArgs), dbify.fetchArg(_, cArgs)
            if not tableName or (imports.type(tableName) ~= "string") or not dataColumns or (imports.type(dataColumns) ~= "table") or (#dataColumns <= 0) or not keyColumns or (imports.type(keyColumns) ~= "table") or (#keyColumns <= 0) then return false end
            local _validateKeyColumns, validateKeyColumns = {}, {}
            for i = 1, #keyColumns, 1 do
                local j = keyColumns[i]
                if not _validateKeyColumns[(j[1])] then
                    imports.table.insert(validateKeyColumns, j[1])
                end
            end
            local promise = function()
                return dbify.mysql.column.areValid(tableName, validateKeyColumns, function(areValid, cArgs)
                    if areValid then
                        local queryStrings, queryArguments = {"UPDATE `??` SET", " WHERE"}, {subLength = 0, cArgs = {}}
                        for i = 1, #cArgs[1].keyColumns, 1 do
                            local j = cArgs[1].keyColumns[i]
                            j[1] = imports.tostring(j[1])
                            imports.table.insert(queryArguments.cArgs, j[1])
                            imports.table.insert(queryArguments.cArgs, imports.tostring(j[2]))
                            queryStrings[2] = queryStrings[2].." `??`=?"..(((i < #cArgs[1].keyColumns) and " AND") or "")
                        end
                        queryArguments.subLength = #queryArguments.cArgs
                        imports.table.insert(queryArguments.cArgs, (#queryArguments.cArgs - queryArguments.subLength) + 1, cArgs[1].tableName)
                        for i = 1, #cArgs[1].dataColumns, 1 do
                            local j = cArgs[1].dataColumns[i]
                            j[1] = imports.tostring(j[1])
                            imports.table.insert(queryArguments.cArgs, (#queryArguments.cArgs - queryArguments.subLength) + 1, j[1])
                            imports.table.insert(queryArguments.cArgs, (#queryArguments.cArgs - queryArguments.subLength) + 1, imports.tostring(j[2]))
                            queryStrings[1] = queryStrings[1].." `??`=?"..(((i < #cArgs[1].dataColumns) and ",") or "")
                            dbify.mysql.column.isValid(cArgs[1].tableName, j[1], function(isValid, cArgs)
                                if not isValid then
                                    imports.dbExec(dbify.mysql.connection.instance, "ALTER TABLE `??` ADD COLUMN `??` TEXT", cArgs[1], cArgs[2])
                                end
                                if cArgs[3] then
                                    local result = imports.dbExec(dbify.mysql.connection.instance, cArgs[3].queryString, imports.table.unpack(cArgs[3].queryArguments))
                                    execFunction(callback, result, cArgs[4])
                                end
                            end, cArgs[1].tableName, j[1], ((i >= #cArgs[1].dataColumns) and {
                                queryString = queryStrings[1]..queryStrings[2],
                                queryArguments = queryArguments.cArgs
                            }) or false, ((i >= #cArgs[1].dataColumns) and cArgs[2]) or false)
                        end
                    else
                        execFunction(callback, false, cArgs[2])
                    end
                end, {
                    tableName = tableName,
                    dataColumns = dataColumns,
                    keyColumns = keyColumns
                }, cArgs)
            end
            return (isAsync and promise) or promise()
        end,

        get = function(...)
            if not dbify.mysql.connection.instance then return false end
            local isAsync, cArgs = dbify.parseArgs(5, ...)
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
            local promise = function()
                return dbify.mysql.column.areValid(tableName, validateColumns, function(areValid, cArgs)
                    if areValid then
                        local queryString, queryArguments = "SELECT", {}
                        for i = 1, #cArgs[1].dataColumns, 1 do
                            local j = cArgs[1].dataColumns[i]
                            imports.table.insert(queryArguments, imports.tostring(j))
                            queryString = queryString.." `??`"..(((i < #cArgs[1].dataColumns) and ",") or "")
                        end
                        imports.table.insert(queryArguments, cArgs[1].tableName)
                        queryString = queryString.." FROM `??` WHERE"
                        for i = 1, #cArgs[1].keyColumns, 1 do
                            local j = cArgs[1].keyColumns[i]
                            imports.table.insert(queryArguments, imports.tostring(j[1]))
                            imports.table.insert(queryArguments, imports.tostring(j[2]))
                            queryString = queryString.." `??`=?"..(((i < #cArgs[1].keyColumns) and " AND") or "")
                        end
                        imports.dbQuery(function(queryHandler, soloFetch, cArgs)
                            local result = imports.dbPoll(queryHandler, 0)
                            if result and (#result > 0) then
                                execFunction(callback, (soloFetch and result[1]) or result, cArgs)
                                return true
                            end
                            execFunction(callback, false, cArgs)
                        end, {cArgs[1].soloFetch, cArgs[2]}, dbify.mysql.connection.instance, queryString, imports.table.unpack(queryArguments))
                    else
                        execFunction(callback, false, cArgs[2])
                    end
                end, {
                    tableName = tableName,
                    dataColumns = dataColumns,
                    keyColumns = keyColumns,
                    soloFetch = soloFetch
                }, cArgs)
            end
            return (isAsync and promise) or promise()
        end
    }
}