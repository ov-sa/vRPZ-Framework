----------------------------------------------------------------
--[[ Resource: DBify Library
     Script: modules: vehicle.lua
     Author: vStudio
     Developer(s): Aviril, Tron, Mario, Аниса
     DOC: 11/10/2021
     Desc: Vehicle Module ]]--
----------------------------------------------------------------


-------------------------
--[[ Module: Vehicle ]]--
-------------------------

local cModule = dbify.createModule({
    moduleName = "vehicle",
    tableName = "dbify_vehicles",
    structure = {
        {"id", "BIGINT AUTO_INCREMENT PRIMARY KEY"}
    }
})