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

librarySettings = {
    buildRate = 500
}

availableLoots = exports.config_loader:getConfigData("loot_spawnpoints")
