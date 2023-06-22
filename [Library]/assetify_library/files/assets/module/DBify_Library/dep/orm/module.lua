----------------------------------------------------------------
--[[ Resource: DBify Library
     Script: orm: module.lua
     Author: vStudio
     Developer(s): Aviril, Tron, Mario, Аниса
     DOC: 11/10/2021
     Desc: Module Handler ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local imports = {
    type = type,
    loadstring = loadstring,
    dbExec = dbExec,
    table = table,
    string = string,
    assetify = assetify
}


---------------------
--[[ ORM: Module ]]--
---------------------

local template = [[
    local imports = {
        type = type,
        tonumber = tonumber,
        dbQuery = dbQuery,
        dbPoll = dbPoll,
        dbExec = dbExec,
        table = table,
        assetify = assetify
    }

    return {
        fetchAll = function(...)
            local self, cArgs = dbify.mysql.util.parseArgs(...)
            if not self then return false end
            local syntaxMsg = "dbify.module[\"<moduleName>\"].fetchAll(table: keyColumns, bool: isSoloFetch)"
            return self:await(
                imports.assetify.thread:createPromise(function(resolve, reject)
                    local keyColumns, isSoloFetch = dbify.mysql.util.fetchArg(_, cArgs), dbify.mysql.util.fetchArg(_, cArgs)
                    resolve(dbify.mysql.table.fetchContents(dbify.module["<moduleName>"].__TMP.tableName, keyColumns, isSoloFetch), cArgs)
                end)
            )
        end,
        
        create = function(...)
            local self, cArgs = dbify.mysql.util.parseArgs(...)
            if not self then return false end
            return self:await(
                imports.assetify.thread:createPromise(function(resolve, reject)
                    local queryStrings, queryArguments, querySubArguments = {"INSERT INTO `??` (", " VALUES("}, {dbify.module["<moduleName>"].__TMP.tableName}, {}
                    for i = 1, imports.table.length(dbify.module["<moduleName>"].__TMP.structure), 1 do
                        local j = dbify.module["<moduleName>"].__TMP.structure[i]
                        local isPrimaryKey = i == dbify.module["<moduleName>"].__TMP.structure.key
                        if not isPrimaryKey or not j.__TMP.isAutoIncrement then
                            local queryArg = dbify.mysql.util.fetchArg(_, cArgs)
                            local isNonLastIndex = ((i < imports.table.length(dbify.module["<moduleName>"].__TMP.structure)) and ((dbify.module["<moduleName>"].__TMP.structure.key < imports.table.length(dbify.module["<moduleName>"].__TMP.structure)) or ((i + 1) ~= dbify.module["<moduleName>"].__TMP.structure.key) or not dbify.module["<moduleName>"].__TMP.structure[(dbify.module["<moduleName>"].__TMP.structure.key)].__TMP.isAutoIncrement) and true) or false
                            queryStrings[1], queryStrings[2] = queryStrings[1].."`??`"..((isNonLastIndex and ", ") or ""), queryStrings[2].."?"..((isNonLastIndex and ", ") or "")
                            imports.table.insert(queryArguments, j[1])
                            imports.table.insert(querySubArguments, queryArg)
                            local isArgNil = queryArg == nil
                            local isArgMatched = imports.type(queryArg) == j.__TMP.type
                            if (j.__TMP.hasDefaultValue and not isArgNil and not isArgMatched) or (not j.__TMP.hasDefaultValue and j.__TMP.isNotNull and (isArgNil or not isArgMatched)) then
                                local syntaxMsg = "dbify.module[\"<moduleName>\"].create("
                                for k = 1, imports.table.length(dbify.module["<moduleName>"].__TMP.structure), 1 do
                                    local v = dbify.module["<moduleName>"].__TMP.structure[k]
                                    if (k ~= dbify.module["<moduleName>"].__TMP.structure.key) or not v.__TMP.isAutoIncrement then
                                        local isNonLastIndex = ((k < imports.table.length(dbify.module["<moduleName>"].__TMP.structure)) and ((dbify.module["<moduleName>"].__TMP.structure.key < imports.table.length(dbify.module["<moduleName>"].__TMP.structure)) or ((k + 1) ~= dbify.module["<moduleName>"].__TMP.structure.key) or not dbify.module["<moduleName>"].__TMP.structure[(dbify.module["<moduleName>"].__TMP.structure.key)].__TMP.isAutoIncrement) and true) or false
                                        syntaxMsg = syntaxMsg..(v.__TMP.type)..": "..v[1]..((isNonLastIndex and ", ") or "")
                                    end
                                end
                                syntaxMsg = syntaxMsg..")"
                                return dbify.mysql.util.throwError(reject, syntaxMsg)
                            end
                            if isPrimaryKey then
                                local isExisting = dbify.module["<moduleName>"].getData(queryArg, {j[1]})
                                if isExisting then return resolve(not isExisting, cArgs) end
                            end
                        end
                    end
                    for i = 1, imports.table.length(querySubArguments), 1 do
                        local j = querySubArguments[i]
                        imports.table.insert(queryArguments, j)
                    end
                    queryStrings[1], queryStrings[2] = queryStrings[1]..")", queryStrings[2]..")"
                    if dbify.module["<moduleName>"].__TMP.structure[(dbify.module["<moduleName>"].__TMP.structure.key)].__TMP.isAutoIncrement then
                        imports.dbQuery(function(queryHandler)
                            local _, _, identifierID = imports.dbPoll(queryHandler, 0)
                            local result = imports.tonumber(identifierID) or false
                            resolve(result, cArgs)
                        end, dbify.mysql.instance, queryStrings[1]..queryStrings[2], imports.table.unpack(queryArguments))
                    else
                        resolve(imports.dbExec(dbify.mysql.instance, queryStrings[1]..queryStrings[2], imports.table.unpack(queryArguments)), cArgs) 
                    end
                end)
            )
        end,
    
        delete = function(...)
            local self, cArgs = dbify.mysql.util.parseArgs(...)
            if not self then return false end
            local syntaxMsg = "dbify.module[\"<moduleName>\"].delete("..dbify.module["<moduleName>"].__TMP.structure[(dbify.module["<moduleName>"].__TMP.structure.key)].__TMP.type..": "..dbify.module["<moduleName>"].__TMP.structure[(dbify.module["<moduleName>"].__TMP.structure.key)][1]..")"
            return self:await(
                imports.assetify.thread:createPromise(function(resolve, reject)
                    local identifier = dbify.mysql.util.fetchArg(_, cArgs)
                    if not identifier or (imports.type(identifier) ~= dbify.module["<moduleName>"].__TMP.structure[(dbify.module["<moduleName>"].__TMP.structure.key)].__TMP.type) then return dbify.mysql.util.throwError(reject, syntaxMsg) end
                    local isExisting = dbify.module["<moduleName>"].getData(identifier, {dbify.module["<moduleName>"].__TMP.structure[(dbify.module["<moduleName>"].__TMP.structure.key)][1]})
                    if not isExisting then return resolve(isExisting, cArgs) end
                    resolve(imports.dbExec(dbify.mysql.instance, "DELETE FROM `??` WHERE `??`=?", dbify.module["<moduleName>"].__TMP.tableName, dbify.module["<moduleName>"].__TMP.structure[(dbify.module["<moduleName>"].__TMP.structure.key)][1], identifier), cArgs)
                end)
            )
        end,
    
        setData = function(...)
            local self, cArgs = dbify.mysql.util.parseArgs(...)
            if not self then return false end
            local syntaxMsg = "dbify.module[\"<moduleName>\"].setData("..dbify.module["<moduleName>"].__TMP.structure[(dbify.module["<moduleName>"].__TMP.structure.key)].__TMP.type..": "..dbify.module["<moduleName>"].__TMP.structure[(dbify.module["<moduleName>"].__TMP.structure.key)][1]..", table: dataColumns)"
            return self:await(
                imports.assetify.thread:createPromise(function(resolve, reject)
                    local identifier, dataColumns = dbify.mysql.util.fetchArg(_, cArgs), dbify.mysql.util.fetchArg(_, cArgs)
                    if not identifier or (imports.type(identifier) ~= dbify.module["<moduleName>"].__TMP.structure[(dbify.module["<moduleName>"].__TMP.structure.key)].__TMP.type) or not dataColumns or (imports.type(dataColumns) ~= "table") or (imports.table.length(dataColumns) <= 0) then return dbify.mysql.util.throwError(reject, syntaxMsg) end
                    local isExisting = dbify.module["<moduleName>"].getData(identifier, {dbify.module["<moduleName>"].__TMP.structure[(dbify.module["<moduleName>"].__TMP.structure.key)][1]})
                    if not isExisting then return resolve(isExisting, cArgs) end
                    resolve(dbify.mysql.data.set(dbify.module["<moduleName>"].__TMP.tableName, dataColumns, { {dbify.module["<moduleName>"].__TMP.structure[(dbify.module["<moduleName>"].__TMP.structure.key)][1], identifier} }), cArgs)                        
                end)
            )
        end,
    
        getData = function(...)
            local self, cArgs = dbify.mysql.util.parseArgs(...)
            if not self then return false end
            local syntaxMsg = "dbify.module[\"<moduleName>\"].getData("..dbify.module["<moduleName>"].__TMP.structure[(dbify.module["<moduleName>"].__TMP.structure.key)].__TMP.type..": "..dbify.module["<moduleName>"].__TMP.structure[(dbify.module["<moduleName>"].__TMP.structure.key)][1]..", table: dataColumns)"
            return self:await(
                imports.assetify.thread:createPromise(function(resolve, reject)
                    local identifier, dataColumns = dbify.mysql.util.fetchArg(_, cArgs), dbify.mysql.util.fetchArg(_, cArgs)
                    if not identifier or (imports.type(identifier) ~= dbify.module["<moduleName>"].__TMP.structure[(dbify.module["<moduleName>"].__TMP.structure.key)].__TMP.type) or not dataColumns or (imports.type(dataColumns) ~= "table") or (imports.table.length(dataColumns) <= 0) then return dbify.mysql.util.throwError(reject, syntaxMsg) end
                    resolve(dbify.mysql.data.get(dbify.module["<moduleName>"].__TMP.tableName, dataColumns, { {dbify.module["<moduleName>"].__TMP.structure[(dbify.module["<moduleName>"].__TMP.structure.key)][1], identifier} }, true), cArgs)                        
                end)
            )
        end
    }
]]

dbify.module = {}
dbify.createModule = function(config)
    if not config or (imports.type(config) ~= "table") then return false end
    config.moduleName = (config.moduleName and (imports.type(config.moduleName) == "string") and config.moduleName) or false
    if not config.moduleName then return false end
    config.structure = dbify.mysql.util.parseStructure(config.structure)
    if not config.structure then return false end
    local queryString, queryArguments = "CREATE TABLE IF NOT EXISTS `??` (", {config.tableName}
    for i = 1, imports.table.length(config.structure), 1 do
        local j = config.structure[i]
        queryString = queryString.."`??` "..j[2]..(((i < imports.table.length(config.structure)) and ", ") or "")
        imports.table.insert(queryArguments, j[1])
    end
    queryString = queryString..")"
    if not imports.dbExec(dbify.mysql.instance, queryString, imports.table.unpack(queryArguments)) then return false end
    dbify.module[(config.moduleName)] = imports.loadstring(imports.string.gsub(template, "<moduleName>", config.moduleName))()
    dbify.module[(config.moduleName)].__TMP = config
    return dbify.module[(config.moduleName)]
end