----------------------------------------------------------------
--[[ Resource: DBify Library
     Script: orm: util.lua
     Author: vStudio
     Developer(s): Aviril, Tron, Mario, Аниса
     DOC: 11/10/2021
     Desc: ORM Utilities ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

loadstring(exports.assetify_library:import("threader"))()
local imports = {
    type = type,
    pairs = pairs,
    tostring = tostring,
    tonumber = tonumber,
    table = table,
    string = string,
    math = math,
    assetify = assetify
}


-------------------
--[[ ORM: Util ]]--
-------------------

dbify.mysql.util = {
    keyTypes = {
        ["BOOLEAN"] = "boolean",
        ["TINYINT"] = "number",
        ["SMALLINT"] = "number",
        ["MEDIUMINT"] = "number",
        ["INT"] = "number",
        ["FLOAT"] = "number",
        ["DOUBLE"] = "number",
        ["BIGINT"] = "number",
        ["VARCHAR"] = "string",
        ["CHAR"] = "string",
        ["BINARY"] = "string",
        ["VARBINARY"] = "string",
        ["TINYBLOB"] = "string",
        ["BLOB"] = "string",
        ["MEDIUMBLOB"] = "string",
        ["LONGBLOB"] = "string",
        ["TINYTEXT"] = "string",
        ["TEXT"] = "string",
        ["MEDIUMTEXT"] = "string",
        ["LONGTEXT"] = "string"
    },

    errorTypes = {
        ["table_existent"] = "Table: '%s' already existing",
        ["table_non-existent"] = "Table: '%s' non-existent",
        ["tables_non-existent"] = "Database: '%s' doesn't contain enough specified tables(s) to process the query",
        ["columns_non-existent"] = "Table: '%s' doesn't contain enough specified column(s) to process the query"
    },
    
    isConnected = function(reject)
        if not dbify.mysql.instance then
            dbify.mysql.util.throwError(reject, "Connection Dead")
            return false
        end
        return true
    end,

    fetchArg = function(index, pool)
        index = imports.tonumber(index) or 1
        index = (((index - imports.math.floor(index)) == 0) and index) or 1
        if not pool or (imports.type(pool) ~= "table") then return false end
        local argValue = pool[index]
        imports.table.remove(pool, index)
        return argValue
    end,

    parseArgs = function(...)
        local cThread = imports.assetify.thread:getThread()
        if not cThread then return false end
        return cThread, imports.table.pack(...)
    end,

    parseStructure = function(structure)
        if not structure or (imports.type(structure) ~= "table") or (imports.table.length(structure) <= 0) then return false end
        local __structure, redundantColumns = {}, {}
        for i = 1, imports.table.length(structure), 1 do
            local j = structure[i]
            j[1] = imports.tostring(j[1])
            if not redundantColumns[(j[1])] then
                redundantColumns[(j[1])] = true
                j[2] = imports.string.upper(imports.tostring(j[2]))
                local matchString = false
                local isEnumIndex = imports.string.find(j[2], "ENUM")
                if isEnumIndex then
                    local preEnumMatch = imports.string.sub(j[2], 0, isEnumIndex)
                    local isPreEnumMatched = imports.string.find(preEnumMatch, ",")
                    if isPreEnumMatched then
                        j[2] = imports.string.sub(preEnumMatch, 0, isPreEnumMatched - 1)
                    else
                        isEnumIndex = isEnumIndex + 4
                        local __matchString = imports.string.sub(j[2], isEnumIndex, #j[2])
                        local isEnumEnter, isEnumExit = false, false
                        for i = 1, #__matchString, 1 do
                            local character = imports.string.sub(__matchString, i, i)
                            if character == "(" then
                                if isEnumEnter then return false end
                                isEnumEnter = true
                            elseif character == ")" then
                                if isEnumExit then return false end
                                isEnumExit = true
                                matchString = imports.string.sub(j[2], isEnumIndex + i, #j[2])
                                break
                            end
                        end
                    end
                end
                matchString = matchString or j[2]
                j[2] = imports.string.sub(j[2], 0, (#j[2] - #matchString) + (imports.string.find(matchString, ",") or (#matchString + 1)) - 1)
                j.__TMP = {}
                for k, v in imports.pairs(dbify.mysql.util.keyTypes) do
                    if imports.string.find(j[2], k) then
                        j.__TMP.type = v
                        j.__TMP.isAutoIncrement = (imports.string.find(j[2], "AUTO_INCREMENT") and true) or false
                        if j.__TMP.isAutoIncrement and (j.__TMP.type ~= "number") then return false end
                        break
                    end
                end
                j.__TMP.type = j.__TMP.type or "string"
                j.__TMP.isAutoIncrement = j.__TMP.isAutoIncrement or false
                j.__TMP.isNotNull = (imports.string.find(j[2], "NOT NULL") and true) or false
                j.__TMP.hasDefaultValue = ((j.__TMP.isAutoIncrement or imports.string.find(j[2], "DEFAULT")) and true) or false
                imports.table.insert(__structure, j)
                if imports.string.find(j[2], "PRIMARY KEY") then
                    if __structure.key then return false end
                    j.__TMP.isNotNull = true
                    __structure.key = imports.table.length(__structure)
                end
            end
        end
        structure = __structure
        return (structure and structure.key and (imports.table.length(structure) > 0) and structure) or false
    end,

    throwError = function(reject, errorMsg)
        if not errorMsg or (imports.type(errorMsg) ~= "string") then return false end
        return execFunction(reject, "DBify: Error ━│  "..errorMsg)
    end
}