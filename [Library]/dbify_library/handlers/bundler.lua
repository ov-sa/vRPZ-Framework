----------------------------------------------------------------
--[[ Resource: DBify Library
     Script: handlers: bundler.lua
     Server: -
     Author: OvileAmriam
     Developer: Aviril
     DOC: 09/10/2021 (OvileAmriam)
     Desc: Bundler Handler ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local imports = {
    tostring = tostring,
    resourceName = getResourceName(getThisResource()),
    addEventHandler = addEventHandler,
    fetchFileData = fetchFileData,
    dbConnect = dbConnect,
    table = {
        insert = table.insert
    }
}


-------------------
--[[ Variables ]]--
-------------------

local bundlerData = false


---------------------------------------------
--[[ Functions: Fetches Imports/Database ]]--
---------------------------------------------

function fetchImports(recieveData)

    if not bundlerData then return false end

    if recieveData == true then
        return bundlerData
    else
        return [[
        local importList = call(getResourceFromName("]]..imports.resourceName..[["), "fetchImports", true)
        for i = 1, #importList, 1 do
            loadstring(importList[i])()
        end
        ]]
    end

end

function fetchDatabase()

    return dbSettings.instance
    
end


-----------------------------------------
--[[ Event: On Client Resource Start ]]--
-----------------------------------------

imports.addEventHandler("onResourceStart", resourceRoot, function(resourceSource)

    dbSettings.instance = imports.dbConnect("mysql", "dbname="..dbSettings.database..";host="..dbSettings.host..";port="..dbSettings.port..";charset=utf8;", dbSettings.username, dbSettings.password, dbSettings.options) or false

    local importedModules = {
        bundler = [[
            dbify = {
                imports = {
                    type = type,
                    pairs = pairs,
                    table = {
                        clone = function(recievedTable, isRecursiveMode)
                            if not recievedTable or dbify.imports.type(recievedTable) ~= "table" then return false end
                            local clonedTable = {}
                            for i, j in dbify.imports.pairs(recievedTable) do
                                if dbify.imports.type(j) == "table" and isRecursiveMode then
                                    clonedTable[i] = dbify.imports.table.clone(j, true)
                                else
                                    clonedTable[i] = j
                                end
                            end
                            return clonedTable
                        end
                    }
                }
            }
        ]],
        modules = {
            mysql = imports.fetchFileData("files/modules/mysql.lua")..[[
                imports.resource = getResourceFromName("]]..imports.resourceName..[[")
                dbify.mysql.__connection__.databaseName = "]]..dbSettings.database..[["
                dbify.mysql.__connection__.instance()
            ]],
            account = imports.fetchFileData("files/modules/account.lua")..[[
                dbify.account.__connection__.autoSync = ]]..imports.tostring(syncSettings.syncAccounts)..[[
            ]],
            serial = imports.fetchFileData("files/modules/serial.lua")..[[
                dbify.serial.__connection__.autoSync = ]]..imports.tostring(syncSettings.syncSerials)..[[
            ]],
            character = imports.fetchFileData("files/modules/character.lua"),
            vehicle = imports.fetchFileData("files/modules/vehicle.lua"),
            inventory = imports.fetchFileData("files/modules/inventory.lua")
        }
    }

    bundlerData = {}
    imports.table.insert(bundlerData, importedModules.bundler)
    imports.table.insert(bundlerData, importedModules.modules.mysql)
    imports.table.insert(bundlerData, importedModules.modules.account)
    imports.table.insert(bundlerData, importedModules.modules.serial)
    imports.table.insert(bundlerData, importedModules.modules.character)
    imports.table.insert(bundlerData, importedModules.modules.vehicle)
    imports.table.insert(bundlerData, importedModules.modules.inventory)

end)