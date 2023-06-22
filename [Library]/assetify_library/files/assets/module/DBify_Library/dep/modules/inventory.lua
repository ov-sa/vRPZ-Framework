----------------------------------------------------------------
--[[ Resource: DBify Library
     Script: modules: inventory.lua
     Author: vStudio
     Developer(s): Aviril, Tron, Mario, Аниса
     DOC: 11/10/2021
     Desc: Inventory Module ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local imports = {
    type = type,
    pairs = pairs,
    tonumber = tonumber,
    tostring = tostring,
    dbQuery = dbQuery,
    dbPoll = dbPoll,
    dbExec = dbExec,
    table = table,
    string = string,
    table = table,
    math = math,
    assetify = assetify
}


---------------------------
--[[ Module: Inventory ]]--
---------------------------

local cModule = dbify.createModule({
    moduleName = "inventory",
    tableName = "dbify_inventories",
    structure = {
        {"id", "BIGINT AUTO_INCREMENT PRIMARY KEY"}
    }
})

local cItem = nil
cItem = {
    __TMP = {
        property = { amount = 0 },
        data = {}
    },

    modifyCount = function(syntaxMsg, action, ...)
        local self, cArgs = dbify.mysql.util.parseArgs(...)
        if not self then return false end
        return self:await(
            imports.assetify.thread:createPromise(function(resolve, reject)
                local identifier, items = dbify.mysql.util.fetchArg(_, cArgs), dbify.mysql.util.fetchArg(_, cArgs)
                if not identifier or (imports.type(identifier) ~= cModule.__TMP.structure[(cModule.__TMP.structure.key)].__TMP.type) or not items or (imports.type(items) ~= "table") or (imports.table.length(items) <= 0) then return dbify.mysql.util.throwError(reject, syntaxMsg) end
                items = imports.table.clone(items, true)
                local itemDatas = {}
                for i = 1, imports.table.length(items), 1 do
                    local j = items[i]
                    j[1] = "item_"..imports.tostring(j[1])
                    j[2] = imports.math.max(0, imports.tonumber(j[2]) or 0)
                    imports.table.insert(itemDatas, j[1])
                end
                itemDatas = cModule.getData(identifier, itemDatas)
                if not itemDatas then return resolve(itemDatas, cArgs) end
                for i = 1, imports.table.length(items) do
                    local j = items[i]
                    local itemData = (itemDatas[(j[1])] and imports.table.decode(itemDatas[(j[1])])) or false
                    itemData = (itemData and itemData.data and (imports.type(itemData.data) == "table") and itemData.property and (imports.type(itemData.property) == "table") and itemData) or false
                    itemData = itemData or imports.table.clone(cItem.__TMP, true)
                    itemData.property.amount = imports.math.max(0, (imports.tonumber(itemData.property.amount) or 0) + (j[2]*(((action == "push") and 1) or -1)))
                    itemData = imports.table.encode(itemData)
                    j[2] = itemData
                end
                resolve(cModule.setData(identifier, items), cArgs)
            end)
        )
    end,

    modifyProp = function(syntaxMsg, action, isData, ...)
        local self, cArgs = dbify.mysql.util.parseArgs(...)
        if not self then return false end
        return self:await(
            imports.assetify.thread:createPromise(function(resolve, reject)
                local identifier, items, props = dbify.mysql.util.fetchArg(_, cArgs), dbify.mysql.util.fetchArg(_, cArgs), dbify.mysql.util.fetchArg(_, cArgs)
                if not identifier or (imports.type(identifier) ~= cModule.__TMP.structure[(cModule.__TMP.structure.key)].__TMP.type) or not items or (imports.type(items) ~= "table") or (imports.table.length(items) <= 0) or not props or (imports.type(props) ~= "table") or (imports.table.length(props) <= 0) then return dbify.mysql.util.throwError(reject, syntaxMsg) end
                items = imports.table.clone(items, true)
                for i = 1, imports.table.length(items), 1 do
                    items[i] = "item_"..imports.tostring(items[i])
                end
                local itemDatas = cModule.getData(identifier, items)
                if not itemDatas then return resolve(itemDatas, cArgs) end
                local __itemDatas = {}
                for i, j in imports.pairs(itemDatas) do
                    j = (j and imports.table.decode(j)) or false
                    j = (j and j.data and (imports.type(j.data) == "table") and j.property and (imports.type(j.property) == "table") and j) or false
                    j = j or imports.table.clone(cItem.__TMP, true)
                    if action == "set" then
                        for k = 1, imports.table.length(props), 1 do
                            local v = props[k]
                            v[1] = imports.tostring(v[1])
                            if not isData then
                                if v[1] == "amount" then v[2] = imports.math.max(0, imports.tonumber(v[2]) or j.property[(v[1])]) end
                                j.property[(v[1])] = v[2]
                            else j.data[(v[1])] = v[2] end
                        end
                        imports.table.insert(__itemDatas, {i, imports.table.encode(j)})
                    else
                        i = imports.string.gsub(i, "item_", "", 1)
                        __itemDatas[i] = {}
                        for k = 1, imports.table.length(props), 1 do
                            props[k] = imports.tostring(props[k])
                            local v = props[k]
                            if not isData then __itemDatas[i][v] = j.property[v]
                            else __itemDatas[i][v] = j.data[v] end
                        end
                    end
                end
                if action == "set" then resolve(cModule.setData(identifier, __itemDatas), cArgs)
                else resolve(__itemDatas, cArgs) end
            end)
        )
    end 
}

cModule.ensureItems = function(...)
    local self, cArgs = dbify.mysql.util.parseArgs(...)
    if not self then return false end
    local syntaxMsg = "dbify.module.inventory.ensureItems()"
    return self:await(
        imports.assetify.thread:createPromise(function(resolve, reject)
            if not dbify.mysql.util.isConnected(reject) then return end
            local items = dbify.mysql.util.fetchArg(_, cArgs)
            if not items or (imports.type(items) ~= "table") then return false end
            items = imports.table.clone(items, true)
            local __items = {}
            for i, j in imports.pairs(items) do
                __items[("item_"..imports.tostring(i))] = true
            end
            items = __items
            local cThread = imports.assetify.thread:getThread()
            local itemsToBeDeleted = {}
            imports.dbQuery(function(queryHandler)
                local result = imports.dbPoll(queryHandler, 0)
                result = (result and (imports.table.length(result) > 0) and result) or false
                if result then
                    for i = 1, imports.table.length(result), 1 do
                        local j = result[i]
                        local identifier = "column_name"
                        local columnName = j[identifier] or j[(imports.string.upper(identifier))]
                        if not items[columnName] then
                            imports.table.insert(itemsToBeDeleted, columnName)
                        end
                    end
                end
                cThread:resume()
            end, dbify.mysql.instance, "SELECT `column_name` FROM information_schema.columns WHERE `table_schema`=? AND `table_name`=? AND `column_name` LIKE 'item_%'", dbify.settings.credentials.database, cModule.__TMP.tableName)
            cThread:pause()
            if imports.table.length(itemsToBeDeleted) > 0 then
                dbify.mysql.column.delete(cModule.__TMP.tableName, itemsToBeDeleted)
            end
            for i, j in imports.pairs(items) do
                if not dbify.mysql.column.isValid(cModule.__TMP.tableName, i) then
                    imports.dbExec(dbify.mysql.instance, "ALTER TABLE `??` ADD COLUMN `??` MEDIUMTEXT", cModule.__TMP.tableName, i)
                end
            end
            resolve(true, cArgs)
        end)
    )
end

cModule.item = {
    add = function(...)
        local syntaxMsg = "dbify.module[\""..(cModule.__TMP.moduleName).."\"].item.add("..(cModule.__TMP.structure[(cModule.__TMP.structure.key)].__TMP.type)..": "..(cModule.__TMP.structure[(cModule.__TMP.structure.key)][1])..", table: items)"
        return cItem.modifyCount(syntaxMsg, "push", ...)
    end,

    remove = function(...)
        local syntaxMsg = "dbify.module[\""..(cModule.__TMP.moduleName).."\"].item.remove("..(cModule.__TMP.structure[(cModule.__TMP.structure.key)].__TMP.type)..": "..(cModule.__TMP.structure[(cModule.__TMP.structure.key)][1])..", table: items)"
        return cItem.modifyCount(syntaxMsg, "pop", ...)
    end,

    setProperty = function(...)
        local syntaxMsg = "dbify.module[\""..(cModule.__TMP.moduleName).."\"].item.setProperty("..(cModule.__TMP.structure[(cModule.__TMP.structure.key)].__TMP.type)..": "..(cModule.__TMP.structure[(cModule.__TMP.structure.key)][1])..", table: items, table: properties)"
        return cItem.modifyProp(syntaxMsg, "set", false, ...)
    end,

    getProperty = function(...)
        local syntaxMsg = "dbify.module[\""..(cModule.__TMP.moduleName).."\"].item.getProperty("..(cModule.__TMP.structure[(cModule.__TMP.structure.key)].__TMP.type)..": "..(cModule.__TMP.structure[(cModule.__TMP.structure.key)][1])..", table: items, table: properties)"
        return cItem.modifyProp(syntaxMsg, "get", false, ...)
    end,

    setData = function(...)
        local syntaxMsg = "dbify.module[\""..(cModule.__TMP.moduleName).."\"].item.setData("..(cModule.__TMP.structure[(cModule.__TMP.structure.key)].__TMP.type)..": "..(cModule.__TMP.structure[(cModule.__TMP.structure.key)][1])..", table: items, table: datas)"
        return cItem.modifyProp(syntaxMsg, "set", true, ...)
    end,

    getData = function(...)
        local syntaxMsg = "dbify.module[\""..(cModule.__TMP.moduleName).."\"].item.getData("..(cModule.__TMP.structure[(cModule.__TMP.structure.key)].__TMP.type)..": "..(cModule.__TMP.structure[(cModule.__TMP.structure.key)][1])..", table: items, table: datas)"
        return cItem.modifyProp(syntaxMsg, "get", true, ...)
    end
}