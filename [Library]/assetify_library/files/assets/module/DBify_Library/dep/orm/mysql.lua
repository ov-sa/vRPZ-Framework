----------------------------------------------------------------
--[[ Resource: DBify Library
     Script: orm: mysql.lua
     Author: vStudio
     Developer(s): Aviril, Tron, Mario, Аниса
     DOC: 11/10/2021
     Desc: MySQL Handler ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local imports = {
    type = type,
    pairs = pairs,
    tostring = tostring,
    dbConnect = dbConnect,
    dbQuery = dbQuery,
    dbPoll = dbPoll,
    dbExec = dbExec,
    string = string,
    table = table,
    assetify = assetify
}


--------------------
--[[ ORM: MySQL ]]--
--------------------

dbify.mysql = {
    instance = imports.dbConnect("mysql", "dbname="..(dbify.settings.credentials.database)..";host="..(dbify.settings.credentials.host)..";port="..(dbify.settings.credentials.port)..";charset=utf8;", dbify.settings.credentials.username, dbify.settings.credentials.password, dbify.settings.credentials.options) or false,

    table = {
        fetchList = function(...)
            local self, cArgs = dbify.mysql.util.parseArgs(...)
            if not self then return false end
            local syntaxMsg = "dbify.mysql.table.fetchList()"
            return self:await(
                imports.assetify.thread:createPromise(function(resolve, reject)
                    if not dbify.mysql.util.isConnected(reject) then return end
                    imports.dbQuery(function(queryHandler)
                        local result = imports.dbPoll(queryHandler, 0)
                        result = result or false
                        local __result = (result and {}) or result
                        if __result then
                            local identifier = "table_name"
                            for i = 1, #result, 1 do
                                imports.table.insert(__result, result[i][identifier] or result[i][(imports.string.upper(identifier))])
                            end
                        end
                        resolve(__result, cArgs)
                    end, dbify.mysql.instance, "SELECT `table_name` FROM information_schema.tables WHERE `table_schema`=?", dbify.settings.credentials.database)
                end)
            )
        end,
    
        isValid = function(...)
            local self, cArgs = dbify.mysql.util.parseArgs(...)
            if not self then return false end
            local syntaxMsg = "dbify.mysql.table.isValid(string: tableName)"
            return self:await(
                imports.assetify.thread:createPromise(function(resolve, reject)
                    if not dbify.mysql.util.isConnected(reject) then return end
                    local tableName = dbify.mysql.util.fetchArg(_, cArgs)
                    if not tableName or (imports.type(tableName) ~= "string") then return dbify.mysql.util.throwError(reject, syntaxMsg) end
                    imports.dbQuery(function(queryHandler)
                        local result = imports.dbPoll(queryHandler, 0)
                        resolve(((result and (imports.table.length(result) > 0)) and true) or false, cArgs)
                    end, dbify.mysql.instance, "SELECT `table_name` FROM information_schema.tables WHERE `table_schema`=? AND `table_name`=?", dbify.settings.credentials.database, tableName)
                end)
            )
        end,

        areValid = function(...)
            local self, cArgs = dbify.mysql.util.parseArgs(...)
            if not self then return false end
            local syntaxMsg = "dbify.mysql.table.areValid(table: tables)"
            return self:await(
                imports.assetify.thread:createPromise(function(resolve, reject)
                    if not dbify.mysql.util.isConnected(reject) then return end
                    local tables, isFetchInvalid = dbify.mysql.util.fetchArg(_, cArgs), dbify.mysql.util.fetchArg(_, cArgs)
                    if not tables or (imports.type(tables) ~= "table") or (imports.table.length(tables) <= 0) then return dbify.mysql.util.throwError(reject, syntaxMsg) end
                    isFetchInvalid = (isFetchInvalid and true) or false
                    local queryString, queryArguments = "SELECT `table_name` FROM information_schema.tables WHERE `table_schema`=? AND (", {dbify.settings.credentials.database}
                    local __tables, redundantTables = {}, {}
                    for i = 1, imports.table.length(tables), 1 do
                        tables[i] = imports.tostring(tables[i])
                        local j = tables[i]
                        if not redundantTables[j] then
                            redundantTables[j] = true
                            imports.table.insert(__tables, j)
                        end
                    end
                    tables = __tables
                    for i = 1, imports.table.length(tables), 1 do
                        local j = tables[i]
                        imports.table.insert(queryArguments, j)
                        queryString = queryString..(((i > 1) and " ") or "").."`table_name`=?"..(((i < imports.table.length(tables)) and " OR") or "")
                    end
                    queryString = queryString..")"
                    imports.dbQuery(function(queryHandler)
                        local result = imports.dbPoll(queryHandler, 0)
                        result = result or false
                        local areValid = ((result and (imports.table.length(result) >= imports.table.length(tables))) and true) or false
                        if not isFetchInvalid then resolve(areValid, cArgs)
                        elseif areValid then resolve(not areValid, cArgs)
                        else
                            local identifier, invalidTables = "table_name", {}
                            for i = 1, imports.table.length(result), 1 do
                                local j = result[i][identifier] or result[i][(imports.string.upper(identifier))]
                                redundantTables[j] = nil
                            end
                            for i, j in imports.pairs(redundantTables) do
                                imports.table.insert(invalidTables, i)
                            end
                            resolve(((imports.table.length(invalidTables) > 0) and invalidTables) or false, cArgs)
                        end
                    end, dbify.mysql.instance, queryString, imports.table.unpack(queryArguments))
                end)
            )
        end,

        create = function(...)
            local self, cArgs = dbify.mysql.util.parseArgs(...)
            if not self then return false end
            local syntaxMsg = "dbify.mysql.table.create(string: tableName, table: structure)"
            return self:await(
                imports.assetify.thread:createPromise(function(resolve, reject)
                    if not dbify.mysql.util.isConnected(reject) then return end
                    local tableName, structure = dbify.mysql.util.fetchArg(_, cArgs), dbify.mysql.util.fetchArg(_, cArgs)
                    structure = dbify.mysql.util.parseStructure(structure)
                    if not tableName or (imports.type(tableName) ~= "string") or not structure then return dbify.mysql.util.throwError(reject, syntaxMsg) end
                    if dbify.mysql.table.isValid(tableName) then return dbify.mysql.util.throwError(reject, imports.string.format(dbify.mysql.util.errorTypes["table_existent"], tableName)) end                    
                    local queryString, queryArguments = "CREATE TABLE IF NOT EXISTS `??` (", {tableName}
                    for i = 1, imports.table.length(structure), 1 do
                        local j = structure[i]
                        queryString = queryString.."`??` "..j[2]..(((i < imports.table.length(structure)) and ", ") or "")
                        imports.table.insert(queryArguments, j[1])
                    end
                    queryString = queryString..")"
                    resolve((imports.dbExec(dbify.mysql.instance, queryString, imports.table.unpack(queryArguments)) and structure) or true, cArgs)
                end)
            )
        end,
    
        delete = function(...)
            local self, cArgs = dbify.mysql.util.parseArgs(...)
            if not self then return false end
            local syntaxMsg = "dbify.mysql.table.delete(table: tables)"
            return self:await(
                imports.assetify.thread:createPromise(function(resolve, reject)
                    if not dbify.mysql.util.isConnected(reject) then return end
                    local tables = dbify.mysql.util.fetchArg(_, cArgs)
                    if not tables or (imports.type(tables) ~= "table") or (imports.table.length(tables) <= 0) then return dbify.mysql.util.throwError(reject, syntaxMsg) end
                    if not dbify.mysql.table.areValid(tables) then return dbify.mysql.util.throwError(reject, imports.string.format(dbify.mysql.util.errorTypes["tables_non-existent"], dbify.settings.credentials.database)) end
                    local queryString, queryArguments = "DROP TABLE IF EXISTS ", {}
                    local __tables, redundantTables = {}, {}
                    for i = 1, imports.table.length(tables), 1 do
                        tables[i] = imports.tostring(tables[i])
                        local j = tables[i]
                        if not redundantTables[j] then
                            redundantTables[j] = true
                            imports.table.insert(__tables, j)
                        end
                    end
                    tables = __tables
                    for i = 1, imports.table.length(tables), 1 do
                        local j = tables[i]
                        imports.table.insert(queryArguments, j)
                        queryString = queryString.."`??`"..(((i < imports.table.length(tables)) and ", ") or "")
                    end
                    resolve(imports.dbExec(dbify.mysql.instance, queryString, imports.table.unpack(queryArguments)), cArgs)
                end)
            )
        end,

        truncate = function(...)
            local self, cArgs = dbify.mysql.util.parseArgs(...)
            if not self then return false end
            local syntaxMsg = "dbify.mysql.table.truncate(table: tables)"
            return self:await(
                imports.assetify.thread:createPromise(function(resolve, reject)
                    if not dbify.mysql.util.isConnected(reject) then return end
                    local tables = dbify.mysql.util.fetchArg(_, cArgs)
                    if not tables or (imports.type(tables) ~= "table") or (imports.table.length(tables) <= 0) then return dbify.mysql.util.throwError(reject, syntaxMsg) end
                    if not dbify.mysql.table.areValid(tables) then return dbify.mysql.util.throwError(reject, imports.string.format(dbify.mysql.util.errorTypes["tables_non-existent"], dbify.settings.credentials.database)) end
                    local queryString, queryArguments = "TRUNCATE TABLE ", {}
                    local __tables, redundantTables = {}, {}
                    for i = 1, imports.table.length(tables), 1 do
                        tables[i] = imports.tostring(tables[i])
                        local j = tables[i]
                        if not redundantTables[j] then
                            redundantTables[j] = true
                            imports.table.insert(__tables, j)
                        end
                    end
                    tables = __tables
                    for i = 1, imports.table.length(tables), 1 do
                        local j = tables[i]
                        imports.table.insert(queryArguments, j)
                        queryString = queryString.."`??`"..(((i < imports.table.length(tables)) and ", ") or "")
                    end
                    resolve(imports.dbExec(dbify.mysql.instance, queryString, imports.table.unpack(queryArguments)), cArgs)
                end)
            )
        end,

        fetchContents = function(...)
            local self, cArgs = dbify.mysql.util.parseArgs(...)
            if not self then return false end
            local syntaxMsg = "dbify.mysql.table.fetchContents(string: tableName, table: keyColumns, bool: isSoloFetch)"
            return self:await(
                imports.assetify.thread:createPromise(function(resolve, reject)
                    if not dbify.mysql.util.isConnected(reject) then return end
                    local tableName, keyColumns, isSoloFetch = dbify.mysql.util.fetchArg(_, cArgs), dbify.mysql.util.fetchArg(_, cArgs), dbify.mysql.util.fetchArg(_, cArgs)
                    if not tableName or (imports.type(tableName) ~= "string") or (keyColumns and (imports.type(keyColumns) ~= "table")) then return dbify.mysql.util.throwError(reject, syntaxMsg) end
                    keyColumns = (keyColumns and (imports.table.length(keyColumns) > 0) and keyColumns) or false
                    isSoloFetch = (isSoloFetch and true) or false
                    if not dbify.mysql.table.isValid(tableName) then return dbify.mysql.util.throwError(reject, imports.string.format(dbify.mysql.util.errorTypes["table_non-existent"], tableName)) end
                    local queryString, queryArguments = "SELECT * FROM `??`", {tableName}
                    if keyColumns then
                        queryString = queryString.." WHERE"
                        local __keyColumns, validateColumns, redundantColumns = {}, {}, {}
                        for i = 1, imports.table.length(keyColumns), 1 do
                            local j = keyColumns[i]
                            j[1] = imports.tostring(j[1])
                            if not redundantColumns[(j[1])] then
                                redundantColumns[(j[1])] = true
                                imports.table.insert(__keyColumns, j)
                                imports.table.insert(validateColumns, j[1])
                            end
                        end
                        keyColumns = __keyColumns
                        if not dbify.mysql.column.areValid(tableName, validateColumns) then return dbify.mysql.util.throwError(reject, imports.string.format(dbify.mysql.util.errorTypes["columns_non-existent"], tableName)) end
                        for i = 1, imports.table.length(keyColumns), 1 do
                            local j = keyColumns[i]
                            imports.table.insert(queryArguments, j[1])
                            imports.table.insert(queryArguments, imports.tostring(j[2]))
                            queryString = queryString.." `??`=?"..(((i < imports.table.length(keyColumns)) and " AND") or "")
                        end
                    end
                    imports.dbQuery(function(queryHandler)
                        local result = imports.dbPoll(queryHandler, 0)
                        result = result or false
                        if result and isSoloFetch then result = result[1] or false end
                        resolve(result, cArgs)
                    end, dbify.mysql.instance, queryString, imports.table.unpack(queryArguments))
                end)
            )
        end
    },

    column = {
        fetchList = function(...)
            local self, cArgs = dbify.mysql.util.parseArgs(...)
            if not self then return false end
            local syntaxMsg = "dbify.mysql.column.fetchList(string: tableName)"
            return self:await(
                imports.assetify.thread:createPromise(function(resolve, reject)
                    if not dbify.mysql.util.isConnected(reject) then return end
                    local tableName = dbify.mysql.util.fetchArg(_, cArgs)
                    if not tableName or (imports.type(tableName) ~= "string") then return dbify.mysql.util.throwError(reject, syntaxMsg) end
                    if not dbify.mysql.table.isValid(tableName) then return dbify.mysql.util.throwError(reject, imports.string.format(dbify.mysql.util.errorTypes["table_non-existent"], tableName)) end
                    imports.dbQuery(function(queryHandler)
                        local result = imports.dbPoll(queryHandler, 0)
                        result = result or false
                        local __result = (result and {}) or result
                        if __result then
                            local identifier = "column_name"
                            for i = 1, #result, 1 do
                                imports.table.insert(__result, result[i][identifier] or result[i][(imports.string.upper(identifier))])
                            end
                        end
                        resolve(__result, cArgs)
                    end, dbify.mysql.instance, "SELECT `column_name` FROM information_schema.columns WHERE `table_schema`=? AND `table_name`=?", dbify.settings.credentials.database, tableName)
                end)
            )
        end,

        isValid = function(...)
            local self, cArgs = dbify.mysql.util.parseArgs(...)
            if not self then return false end
            local syntaxMsg = "dbify.mysql.column.isValid(string: tableName, string: columnName)"
            return self:await(
                imports.assetify.thread:createPromise(function(resolve, reject)
                    if not dbify.mysql.util.isConnected(reject) then return end
                    local tableName, columnName = dbify.mysql.util.fetchArg(_, cArgs), dbify.mysql.util.fetchArg(_, cArgs)
                    if not tableName or (imports.type(tableName) ~= "string") or not columnName or (imports.type(columnName) ~= "string") then return dbify.mysql.util.throwError(reject, syntaxMsg) end
                    if not dbify.mysql.table.isValid(tableName) then return dbify.mysql.util.throwError(reject, imports.string.format(dbify.mysql.util.errorTypes["table_non-existent"], tableName)) end
                    imports.dbQuery(function(queryHandler)
                        local result = imports.dbPoll(queryHandler, 0)
                        resolve(((result and (imports.table.length(result) > 0)) and true) or false, cArgs)
                    end, dbify.mysql.instance, "SELECT `column_name` FROM information_schema.columns WHERE `table_schema`=? AND `table_name`=? AND `column_name`=?", dbify.settings.credentials.database, tableName, columnName)
                end)
            )
        end,

        areValid = function(...)
            local self, cArgs = dbify.mysql.util.parseArgs(...)
            if not self then return false end
            local syntaxMsg = "dbify.mysql.column.areValid(string: tableName, table: columns)"
            return self:await(
                imports.assetify.thread:createPromise(function(resolve, reject)
                    if not dbify.mysql.util.isConnected(reject) then return end
                    local tableName, columns, isFetchInvalid = dbify.mysql.util.fetchArg(_, cArgs), dbify.mysql.util.fetchArg(_, cArgs), dbify.mysql.util.fetchArg(_, cArgs)
                    if not tableName or (imports.type(tableName) ~= "string") or not columns or (imports.type(columns) ~= "table") or (imports.table.length(columns) <= 0) then return dbify.mysql.util.throwError(reject, syntaxMsg) end
                    isFetchInvalid = (isFetchInvalid and true) or false
                    if not dbify.mysql.table.isValid(tableName) then return dbify.mysql.util.throwError(reject, imports.string.format(dbify.mysql.util.errorTypes["table_non-existent"], tableName)) end
                    local queryString, queryArguments = "SELECT `column_name` FROM information_schema.columns WHERE `table_schema`=? AND `table_name`=? AND (", {dbify.settings.credentials.database, tableName}
                    local __columns, redundantColumns = {}, {}
                    for i = 1, imports.table.length(columns), 1 do
                        columns[i] = imports.tostring(columns[i])
                        local j = columns[i]
                        if not redundantColumns[j] then
                            redundantColumns[j] = true
                            imports.table.insert(__columns, j)
                        end
                    end
                    columns = __columns
                    for i = 1, imports.table.length(columns), 1 do
                        local j = columns[i]
                        imports.table.insert(queryArguments, j)
                        queryString = queryString..(((i > 1) and " ") or "").."`column_name`=?"..(((i < imports.table.length(columns)) and " OR") or "")
                    end
                    queryString = queryString..")"
                    imports.dbQuery(function(queryHandler)
                        local result = imports.dbPoll(queryHandler, 0)
                        result = result or false
                        local areValid = ((result and (imports.table.length(result) >= imports.table.length(columns))) and true) or false
                        if not isFetchInvalid then resolve(areValid, cArgs)
                        elseif areValid then resolve(not areValid, cArgs)
                        else
                            local identifier, invalidColumns = "column_name", {}
                            for i = 1, imports.table.length(result), 1 do
                                local j = result[i][identifier] or result[i][(imports.string.upper(identifier))]
                                redundantColumns[j] = nil
                            end
                            for i, j in imports.pairs(redundantColumns) do
                                imports.table.insert(invalidColumns, i)
                            end
                            resolve(((imports.table.length(invalidColumns) > 0) and invalidColumns) or false, cArgs)
                        end
                    end, dbify.mysql.instance, queryString, imports.table.unpack(queryArguments))
                end)
            )
        end,

        delete = function(...)
            local self, cArgs = dbify.mysql.util.parseArgs(...)
            if not self then return false end
            local syntaxMsg = "dbify.mysql.column.delete(string: tableName, table: columns)"
            return self:await(
                imports.assetify.thread:createPromise(function(resolve, reject)
                    if not dbify.mysql.util.isConnected(reject) then return end
                    local tableName, columns = dbify.mysql.util.fetchArg(_, cArgs), dbify.mysql.util.fetchArg(_, cArgs)
                    if not tableName or (imports.type(tableName) ~= "string") or not columns or (imports.type(columns) ~= "table") or (imports.table.length(columns) <= 0) then return dbify.mysql.util.throwError(reject, syntaxMsg) end
                    if not dbify.mysql.table.isValid(tableName) then return dbify.mysql.util.throwError(reject, imports.string.format(dbify.mysql.util.errorTypes["table_non-existent"], tableName)) end
                    if not dbify.mysql.column.areValid(tableName, columns) then return dbify.mysql.util.throwError(reject, imports.string.format(dbify.mysql.util.errorTypes["columns_non-existent"], tableName)) end
                    local queryString, queryArguments = "ALTER TABLE `??`", {tableName}
                    local __columns, redundantColumns = {}, {}
                    for i = 1, imports.table.length(columns), 1 do
                        columns[i] = imports.tostring(columns[i])
                        local j = columns[i]
                        if not redundantColumns[j] then
                            redundantColumns[j] = true
                            imports.table.insert(__columns, j)
                        end
                    end
                    columns = __columns
                    for i = 1, imports.table.length(columns), 1 do
                        local j = columns[i]
                        imports.table.insert(queryArguments, j)
                        queryString = queryString.." DROP COLUMN `??`"..(((i < imports.table.length(columns)) and ", ") or "")
                    end
                    resolve(imports.dbExec(dbify.mysql.instance, queryString, imports.table.unpack(queryArguments)), cArgs)
                end)
            )
        end
    },

    data = {
        set = function(...)
            local self, cArgs = dbify.mysql.util.parseArgs(...)
            if not self then return false end
            local syntaxMsg = "dbify.mysql.data.set(string: tableName, table: dataColumns, table: keyColumns)"
            return self:await(
                imports.assetify.thread:createPromise(function(resolve, reject)
                    if not dbify.mysql.util.isConnected(reject) then return end
                    local tableName, dataColumns, keyColumns = dbify.mysql.util.fetchArg(_, cArgs), dbify.mysql.util.fetchArg(_, cArgs), dbify.mysql.util.fetchArg(_, cArgs)
                    if not tableName or (imports.type(tableName) ~= "string") or not dataColumns or (imports.type(dataColumns) ~= "table") or (imports.table.length(dataColumns) <= 0) or not keyColumns or (imports.type(keyColumns) ~= "table") or (imports.table.length(keyColumns) <= 0) then return false end
                    local queryStrings, queryArguments = {"UPDATE `??` SET", " WHERE"}, {tableName}
                    local __keyColumns, __dataColumns, validateColumns, redundantColumns = {}, {}, {}, {}
                    for i = 1, imports.table.length(keyColumns), 1 do
                        local j = keyColumns[i]
                        j[1] = imports.tostring(j[1])
                        if not redundantColumns[(j[1])] then
                            redundantColumns[(j[1])] = true
                            imports.table.insert(__keyColumns, j)
                            imports.table.insert(validateColumns, j[1])
                        end
                    end
                    keyColumns, redundantColumns = __keyColumns, {}
                    if not dbify.mysql.column.areValid(tableName, validateColumns) then return dbify.mysql.util.throwError(reject, imports.string.format(dbify.mysql.util.errorTypes["columns_non-existent"], tableName)) end
                    validateColumns = {}
                    for i = 1, imports.table.length(dataColumns), 1 do
                        local j = dataColumns[i]
                        j[1] = imports.tostring(j[1])
                        if not redundantColumns[(j[1])] then
                            redundantColumns[(j[1])] = true
                            imports.table.insert(__dataColumns, j)
                            imports.table.insert(validateColumns, j[1])
                        end
                    end
                    dataColumns = __dataColumns
                    for i = 1, imports.table.length(keyColumns), 1 do
                        local j = keyColumns[i]
                        imports.table.insert(queryArguments, j[1])
                        imports.table.insert(queryArguments, imports.tostring(j[2]))
                        queryStrings[2] = queryStrings[2].." `??`=?"..(((i < imports.table.length(keyColumns)) and " AND") or "")
                    end
                    local queryLength = imports.table.length(queryArguments) - 1
                    local invalidColumns = dbify.mysql.column.areValid(tableName, validateColumns, true)
                    if invalidColumns then
                        local queryString, queryArguments = "ALTER TABLE `??`", {tableName}
                        for i = 1, imports.table.length(invalidColumns), 1 do
                            imports.table.insert(queryArguments, invalidColumns[i])
                            queryString = queryString.." ADD COLUMN `??` MEDIUMTEXT"..(((i < imports.table.length(invalidColumns)) and ", ") or "")
                        end
                        imports.dbExec(dbify.mysql.instance, queryString, imports.table.unpack(queryArguments))
                    end
                    for i = 1, imports.table.length(dataColumns), 1 do
                        local j = dataColumns[i]
                        imports.table.insert(queryArguments, imports.table.length(queryArguments) - queryLength + 1, j[1])
                        imports.table.insert(queryArguments, imports.table.length(queryArguments) - queryLength + 1, imports.tostring(j[2]))
                        queryStrings[1] = queryStrings[1].." `??`=?"..(((i < imports.table.length(dataColumns)) and ",") or "")
                    end
                    resolve(imports.dbExec(dbify.mysql.instance, queryStrings[1]..queryStrings[2], imports.table.unpack(queryArguments)), cArgs)
                end)
            )
        end,

        get = function(...)
            local self, cArgs = dbify.mysql.util.parseArgs(...)
            if not self then return false end
            local syntaxMsg = "dbify.mysql.data.get(string: tableName, table: dataColumns, table: keyColumns, bool: isSoloFetch)"
            return self:await(
                imports.assetify.thread:createPromise(function(resolve, reject)
                    if not dbify.mysql.util.isConnected(reject) then return end
                    local tableName, dataColumns, keyColumns, isSoloFetch = dbify.mysql.util.fetchArg(_, cArgs), dbify.mysql.util.fetchArg(_, cArgs), dbify.mysql.util.fetchArg(_, cArgs), dbify.mysql.util.fetchArg(_, cArgs)
                    if not tableName or (imports.type(tableName) ~= "string") or not dataColumns or (imports.type(dataColumns) ~= "table") or (imports.table.length(dataColumns) <= 0) or not keyColumns or (imports.type(keyColumns) ~= "table") or (imports.table.length(keyColumns) <= 0) then return false end
                    isSoloFetch = (isSoloFetch and true) or false
                    if not dbify.mysql.table.isValid(tableName) then return dbify.mysql.util.throwError(reject, imports.string.format(dbify.mysql.util.errorTypes["table_non-existent"], tableName)) end
                    local queryString, queryArguments = "SELECT", {}
                    local __keyColumns, __dataColumns, validateColumns, redundantColumns = {}, {}, {}, {}
                    for i = 1, imports.table.length(keyColumns), 1 do
                        local j = keyColumns[i]
                        j[1] = imports.tostring(j[1])
                        if not redundantColumns[(j[1])] then
                            redundantColumns[(j[1])] = true
                            imports.table.insert(__keyColumns, j)
                            imports.table.insert(validateColumns, j[1])
                        end
                    end
                    keyColumns, redundantColumns = __keyColumns, {}
                    if not dbify.mysql.column.areValid(tableName, validateColumns) then return dbify.mysql.util.throwError(reject, imports.string.format(dbify.mysql.util.errorTypes["columns_non-existent"], tableName)) end
                    validateColumns = {}
                    local dummyColumn, isDummyColumnAppended, isDummyColumnIncluded = keyColumns[1][1], false, false
                    for i = 1, imports.table.length(dataColumns), 1 do
                        dataColumns[i] = imports.tostring(dataColumns[i])
                        local j = dataColumns[i]
                        if not redundantColumns[j] then
                            redundantColumns[j] = true
                            isDummyColumnIncluded = isDummyColumnIncluded or (j == dummyColumn) or false
                            imports.table.insert(__dataColumns, j)
                            imports.table.insert(validateColumns, j)
                        end
                    end
                    dataColumns = __dataColumns
                    local invalidColumns = dbify.mysql.column.areValid(tableName, validateColumns, true)
                    if invalidColumns then
                        local validColumns = {}
                        for i = 1, imports.table.length(invalidColumns), 1 do
                            local j = invalidColumns[i]
                            redundantColumns[j] = nil
                        end
                        for i = 1, imports.table.length(dataColumns), 1 do
                            local j = dataColumns[i]
                            if redundantColumns[j] then
                                imports.table.insert(validColumns, j)
                            end
                        end
                        dataColumns = validColumns
                    end
                    if imports.table.length(dataColumns) <= 0 then
                        isDummyColumnAppended = true
                        imports.table.insert(dataColumns, dummyColumn)
                    end
                    for i = 1, imports.table.length(dataColumns), 1 do
                        local j = dataColumns[i]
                        imports.table.insert(queryArguments, j)
                        queryString = queryString.." `??`"..(((i < imports.table.length(dataColumns)) and ",") or "")
                    end
                    imports.table.insert(queryArguments, tableName)
                    queryString = queryString.." FROM `??` WHERE"
                    for i = 1, imports.table.length(keyColumns), 1 do
                        local j = keyColumns[i]
                        imports.table.insert(queryArguments, j[1])
                        imports.table.insert(queryArguments, imports.tostring(j[2]))
                        queryString = queryString.." `??`=?"..(((i < imports.table.length(keyColumns)) and " AND") or "")
                    end
                    imports.dbQuery(function(queryHandler)
                        local result = imports.dbPoll(queryHandler, 0)
                        result = result or false
                        if result and isSoloFetch then result = result[1] or false end
                        if result and isDummyColumnAppended and not isDummyColumnIncluded then
                            if isSoloFetch then result[dummyColumn] = nil
                            else
                                for i = 1, imports.table.length(result), 1 do
                                    result[i][dummyColumn] = nil
                                end
                            end
                        end
                        resolve(result, cArgs)
                    end, dbify.mysql.instance, queryString, imports.table.unpack(queryArguments))
                end)
            )
        end
    }
}