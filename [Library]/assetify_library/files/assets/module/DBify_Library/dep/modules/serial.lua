----------------------------------------------------------------
--[[ Resource: DBify Library
     Script: modules: serial.lua
     Author: vStudio
     Developer(s): Aviril, Tron, Mario, Аниса
     DOC: 11/10/2021
     Desc: Serial Module ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local imports = {
    getElementsByType = getElementsByType,
    addEventHandler = addEventHandler,
    getPlayerSerial = getPlayerSerial,
    table = table,
    assetify = assetify
}


------------------------
--[[ Module: Serial ]]--
------------------------

local cModule = dbify.createModule({
    moduleName = "serial",
    tableName = "dbify_serials",
    structure = {
        {"serial", "VARCHAR(100) PRIMARY KEY"}
    }
})

if dbify.settings.syncNativeSerials then
    imports.assetify.thread:create(function(self)
        local serverPlayers = imports.getElementsByType("player")
        for i = 1, imports.table.length(serverPlayers), 1 do
            cModule.create(imports.getPlayerSerial(serverPlayers[i]))
        end
    end):resume()
    imports.addEventHandler("onPlayerJoin", root, function()
        imports.assetify.thread:create(function(self)
            cModule.create(imports.getPlayerSerial(source))
        end):resume()
    end)
end