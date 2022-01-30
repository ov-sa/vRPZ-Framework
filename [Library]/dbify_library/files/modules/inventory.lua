----------------------------------------------------------------
--[[ Resource: DBify Library
     Files: modules: inventory.lua
     Server: -
     Author: OvileAmriam
     Developer: Aviril
     DOC: 09/10/2021 (OvileAmriam)
     Desc: Inventory Module ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local imports = {
    type = type,
    pairs = pairs,
    ipairs = ipairs,
    tonumber = tonumber,
    tostring = tostring,
    toJSON = toJSON,
    fromJSON = fromJSON,
    addEventHandler = addEventHandler,
    dbQuery = dbQuery,
    dbPoll = dbPoll,
    dbExec = dbExec,
    table = {
        insert = table.insert
    },
    string = {
        gsub = string.gsub
    },
    math = {
        max = math.max
    }
}


-------------------
--[[ Variables ]]--
-------------------

dbify["inventory"] = {
    __connection__ = {
        table = "server_inventories",
        keyColumn = "id",
        itemFormat = {
            counter = "amount",
            content = {
                data = {},
                property = {
                    amount = 0
                }
            }
        }
    },

    fetchAll = function(keyColumns, callback, ...)
        if not dbify.mysql.__connection__.instance then return false end
        return dbify.mysql.table.fetchContents(dbify.inventory.__connection__.table, keyColumns, callback, ...)
    end,

    ensureItems = function(items, callback, ...)
        if not dbify.mysql.__connection__.instance then return false end
        if not items or (imports.type(items) ~= "table") or not callback or (imports.type(callback) ~= "function") then return false end
        imports.dbQuery(function(queryHandler, arguments)
            local callbackReference = callback
            local result = imports.dbPoll(queryHandler, 0)
            local itemsToBeAdded, itemsToBeDeleted = {}, {}
            if result and (#result > 0) then
                for i, j in imports.ipairs(result) do
                    local columnName = j["COLUMN_NAME"]
                    local itemIndex = imports.string.gsub(columnName, "item_", "", 1)
                    if not arguments[1].items[itemIndex] then
                        imports.table.insert(itemsToBeDeleted, columnName)
                    end
                end
            end
            for i, j in imports.pairs(arguments[1].items) do
                imports.table.insert(itemsToBeAdded, "item_"..i)
            end
            arguments[1].items = itemsToBeAdded
            if #itemsToBeDeleted > 0 then
                dbify.mysql.column.delete(dbify.inventory.__connection__.table, itemsToBeDeleted, function(result, arguments)
                    if result then
                        for i, j in imports.ipairs(arguments[1].items) do
                            dbify.mysql.column.isValid(dbify.inventory.__connection__.table, j, function(isValid, arguments)
                                local callbackReference = callback
                                if not isValid then
                                    imports.dbExec(dbify.mysql.__connection__.instance, "ALTER TABLE `??` ADD COLUMN `??` TEXT", dbify.inventory.__connection__.table, arguments[1])
                                end
                                if arguments[2] then
                                    if callbackReference and (imports.type(callbackReference) == "function") then
                                        callbackReference(true, arguments[2])
                                    end
                                end
                            end, j, ((i >= #arguments[1].items) and arguments[2]) or false)
                        end
                    else
                        local callbackReference = callback
                        if callbackReference and (imports.type(callbackReference) == "function") then
                            callbackReference(result, arguments[2])
                        end
                    end
                end, arguments[1], arguments[2])
            else
                for i, j in imports.ipairs(arguments[1].items) do
                    dbify.mysql.column.isValid(dbify.inventory.__connection__.table, j, function(isValid, arguments)
                        local callbackReference = callback
                        if not isValid then
                            imports.dbExec(dbify.mysql.__connection__.instance, "ALTER TABLE `??` ADD COLUMN `??` TEXT", dbify.inventory.__connection__.table, arguments[1])
                        end
                        if arguments[2] then
                            if callbackReference and (imports.type(callbackReference) == "function") then
                                callbackReference(true, arguments[2])
                            end
                        end
                    end, j, ((i >= #arguments[1].items) and arguments[2]) or false)
                end
            end
        end, {{{
            items = items
        }, {...}}}, dbify.mysql.__connection__.instance, "SELECT `column_name` FROM information_schema.columns WHERE `table_schema`=? AND `table_name`=? AND `column_name` LIKE 'item_%'", dbify.mysql.__connection__.databaseName, dbify.inventory.__connection__.table)
        return true
    end,

    create = function(callback, ...)
        if not dbify.mysql.__connection__.instance then return false end
        if not callback or (imports.type(callback) ~= "function") then return false end
        imports.dbQuery(function(queryHandler, arguments)
            local callbackReference = callback
            local _, _, inventoryID = imports.dbPoll(queryHandler, 0)
            local result = inventoryID or false
            if callbackReference and (imports.type(callbackReference) == "function") then
                callbackReference(result, arguments)
            end
        end, {{...}}, dbify.mysql.__connection__.instance, "INSERT INTO `??` (`??`) VALUES(NULL)", dbify.inventory.__connection__.table, dbify.inventory.__connection__.keyColumn)
        return true
    end,

    delete = function(inventoryID, callback, ...)
        if not dbify.mysql.__connection__.instance then return false end
        if not inventoryID or (imports.type(inventoryID) ~= "number") then return false end
        return dbify.inventory.getData(inventoryID, {dbify.inventory.__connection__.keyColumn}, function(result, arguments)
            local callbackReference = callback
            if result then
                result = imports.dbExec(dbify.mysql.__connection__.instance, "DELETE FROM `??` WHERE `??`=?", dbify.inventory.__connection__.table, dbify.inventory.__connection__.keyColumn, inventoryID)
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

    setData = function(inventoryID, dataColumns, callback, ...)
        if not dbify.mysql.__connection__.instance then return false end
        if not inventoryID or (imports.type(inventoryID) ~= "number") or not dataColumns or (imports.type(dataColumns) ~= "table") or (#dataColumns <= 0) then return false end
        return dbify.mysql.data.set(dbify.inventory.__connection__.table, dataColumns, {
            {dbify.inventory.__connection__.keyColumn, inventoryID}
        }, callback, ...)
    end,

    getData = function(inventoryID, dataColumns, callback, ...)
        if not dbify.mysql.__connection__.instance then return false end
        if not inventoryID or (imports.type(inventoryID) ~= "number") or not dataColumns or (imports.type(dataColumns) ~= "table") or (#dataColumns <= 0) then return false end
        return dbify.mysql.data.get(dbify.inventory.__connection__.table, dataColumns, {
            {dbify.inventory.__connection__.keyColumn, inventoryID}
        }, true, callback, ...)
    end,

    item = {
        __utilities__ = {
            pushnpop = function(inventoryID, items, processType, callback, ...)
                if not dbify.mysql.__connection__.instance then return false end
                if not inventoryID or (imports.type(inventoryID) ~= "number") or not items or (imports.type(items) ~= "table") or (#items <= 0) or not processType or (imports.type(processType) ~= "string") or ((processType ~= "push") and (processType ~= "pop")) then return false end
                return dbify.inventory.fetchAll({
                    {dbify.inventory.__connection__.keyColumn, inventoryID},
                }, function(result, arguments)
                    if result then
                        result = result[1]
                        for i, j in imports.ipairs(arguments[1].items) do
                            j[1] = "item_"..imports.tostring(j[1])
                            j[2] = imports.math.max(0, imports.tonumber(j[2]) or 0)
                            local prevItemData = result[(j[1])]
                            prevItemData = (prevItemData and imports.fromJSON(prevItemData)) or false
                            prevItemData = (prevItemData and prevItemData.data and (imports.type(prevItemData.data) == "table") and prevItemData.item and (imports.type(prevItemData.item) == "table") and prevItemData) or false
                            if not prevItemData then
                                prevItemData = dbify.imports.table.clone(dbify.inventory.__connection__.itemFormat.content, true)
                            end
                            prevItemData.property[(dbify.inventory.__connection__.itemFormat.counter)] = j[2] + (imports.math.max(0, imports.tonumber(prevItemData.property[(dbify.inventory.__connection__.itemFormat.counter)]) or 0)*((arguments[1].processType == "push" and 1) or -1))
                            arguments[1].items[i][2] = imports.toJSON(prevItemData)
                        end
                        dbify.inventory.setData(arguments[1].inventoryID, arguments[1].items, function(result, arguments)
                            local callbackReference = callback
                            if callbackReference and (imports.type(callbackReference) == "function") then
                                callbackReference(result, arguments)
                            end
                        end, arguments[2])
                    else
                        local callbackReference = callback
                        if callbackReference and (imports.type(callbackReference) == "function") then
                            callbackReference(false, arguments[2])
                        end
                    end
                end, {
                    inventoryID = inventoryID,
                    items = items,
                    processType = processType
                }, {...})
            end,

            property_setnget = function(inventoryID, items, properties, processType, callback, ...)
                if not dbify.mysql.__connection__.instance then return false end
                if not inventoryID or (imports.type(inventoryID) ~= "number") or not items or (imports.type(items) ~= "table") or (#items <= 0) or not properties or (imports.type(properties) ~= "table") or (#properties <= 0) or not processType or (imports.type(processType) ~= "string") or ((processType ~= "set") and (processType ~= "get")) then return false end
                for i, j in imports.ipairs(items) do
                    items[i] = "item_"..imports.tostring(j)
                end
                return dbify.inventory.getData(inventoryID, items, function(result, arguments)
                    local callbackReference = callback
                    if result then
                        local properties = {}
                        for i, j in imports.pairs(result) do
                            j = (j and imports.fromJSON(j)) or false
                            j = (j and j.data and (imports.type(j.data) == "table") and j.property and (imports.type(j.property) == "table") and j) or false
                            if arguments[1].processType == "set" then
                                if not j then
                                    j = dbify.imports.table.clone(dbify.inventory.__connection__.itemFormat.content, true)
                                end
                                for k, v in imports.ipairs(arguments[1].properties) do
                                    v[1] = imports.tostring(v[1])
                                    if v[1] == dbify.inventory.__connection__.itemFormat.counter then
                                        v[2] = imports.math.max(0, imports.tonumber(v[2]) or j.property[(v[1])])
                                    end
                                    j.property[(v[1])] = v[2]
                                end
                                imports.table.insert(properties, {i, imports.toJSON(j)})
                            else
                                local itemIndex = imports.string.gsub(i, "item_", "", 1)
                                properties[itemIndex] = {}
                                if j then
                                    for k, v in imports.ipairs(arguments[1].properties) do
                                        v = imports.tostring(v)
                                        properties[itemIndex][v] = j.property[v]
                                    end
                                end
                            end
                        end
                        if arguments[1].processType == "set" then
                            dbify.inventory.setData(arguments[1].inventoryID, properties, function(result, arguments)
                                local callbackReference = callback
                                if callbackReference and (imports.type(callbackReference) == "function") then
                                    callbackReference(result, arguments)
                                end
                            end, arguments[2])
                        else
                            if callbackReference and (imports.type(callbackReference) == "function") then
                                callbackReference(properties, arguments[2])
                            end
                        end
                    else
                        if callbackReference and (imports.type(callbackReference) == "function") then
                            callbackReference(false, arguments[2])
                        end
                    end
                end, {
                    inventoryID = inventoryID,
                    properties = properties,
                    processType = processType
                }, {...})
            end,

            data_setnget = function(inventoryID, items, datas, processType, callback, ...)
                if not dbify.mysql.__connection__.instance then return false end
                if not inventoryID or (imports.type(inventoryID) ~= "number") or not items or (imports.type(items) ~= "table") or (#items <= 0) or not datas or (imports.type(datas) ~= "table") or (#datas <= 0) or not processType or (imports.type(processType) ~= "string") or ((processType ~= "set") and (processType ~= "get")) then return false end
                for i, j in imports.ipairs(items) do
                    items[i] = "item_"..imports.tostring(j)
                end
                return dbify.inventory.getData(inventoryID, items, function(result, arguments)
                    local callbackReference = callback
                    if result then
                        local datas = {}
                        for i, j in imports.pairs(result) do
                            j = (j and imports.fromJSON(j)) or false
                            j = (j and j.data and (imports.type(j.data) == "table") and j.property and (imports.type(j.property) == "table") and j) or false
                            if arguments[1].processType == "set" then
                                if not j then
                                    j = dbify.imports.table.clone(dbify.inventory.__connection__.itemFormat.content, true)
                                end
                                for k, v in imports.ipairs(arguments[1].datas) do
                                    j.data[imports.tostring(v[1])] = v[2]
                                end
                                imports.table.insert(datas, {i, imports.toJSON(j)})
                            else
                                local itemIndex = imports.string.gsub(i, "item_", "", 1)
                                datas[itemIndex] = {}
                                if j then
                                    for k, v in imports.ipairs(arguments[1].datas) do
                                        v = imports.tostring(v)
                                        datas[itemIndex][v] = j.data[v]
                                    end
                                end
                            end
                        end
                        if arguments[1].processType == "set" then
                            dbify.inventory.setData(arguments[1].inventoryID, datas, function(result, arguments)
                                local callbackReference = callback
                                if callbackReference and (imports.type(callbackReference) == "function") then
                                    callbackReference(result, arguments)
                                end
                            end, arguments[2])
                        else
                            if callbackReference and (imports.type(callbackReference) == "function") then
                                callbackReference(datas, arguments[2])
                            end
                        end
                    else
                        if callbackReference and (imports.type(callbackReference) == "function") then
                            callbackReference(false, arguments[2])
                        end
                    end
                end, {
                    inventoryID = inventoryID,
                    datas = datas,
                    processType = processType
                }, {...})
            end
        },

        add = function(inventoryID, items, callback, ...)
            return dbify.inventory.item.__utilities__.pushnpop(inventoryID, items, "push", callback, ...)
        end,

        remove = function(inventoryID, items, callback, ...)
            return dbify.inventory.item.__utilities__.pushnpop(inventoryID, items, "pop", callback, ...)
        end,

        setProperty = function(inventoryID, items, properties, callback, ...)        
            return dbify.inventory.item.__utilities__.property_setnget(inventoryID, items, properties, "set", callback, ...)
        end,

        getProperty = function(inventoryID, items, properties, callback, ...)        
            return dbify.inventory.item.__utilities__.property_setnget(inventoryID, items, properties, "get", callback, ...)
        end,

        setData = function(inventoryID, items, datas, callback, ...)        
            return dbify.inventory.item.__utilities__.data_setnget(inventoryID, items, datas, "set", callback, ...)
        end,

        getData = function(inventoryID, items, datas, callback, ...)        
            return dbify.inventory.item.__utilities__.data_setnget(inventoryID, items, datas, "get", callback, ...)
        end
    }
}


----------------------------------
--[[ Event: On Resource-Start ]]--
----------------------------------

imports.addEventHandler("onResourceStart", resourceRoot, function()

    if not dbify.mysql.__connection__.instance then return false end
    imports.dbExec(dbify.mysql.__connection__.instance, "CREATE TABLE IF NOT EXISTS `??` (`??` INT AUTO_INCREMENT PRIMARY KEY)", dbify.inventory.__connection__.table, dbify.inventory.__connection__.keyColumn)

end)