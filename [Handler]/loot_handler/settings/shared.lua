----------------------------------------------------------------
--[[ Resource: Loot Handler
     Script: settings: shared.lua
     Server: -
     Author: vStudio
     Developer(s): Tron
     DOC: 15/03/2022
     Desc: Shared Settings ]]--
----------------------------------------------------------------


------------------
--[[ Settings ]]--
------------------

syncSettings = {
    syncRate = 500
}

FRAMEWORK_CONFIGS = {
    ["Loots"] = exports.config_loader:getConfig("Loots"),
    ["Inventory"] = exports.config_loader:getConfig("Inventory")
}