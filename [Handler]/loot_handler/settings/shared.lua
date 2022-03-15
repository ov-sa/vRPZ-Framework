----------------------------------------------------------------
--[[ Resource: Loot Handler
     Script: settings: shared.lua
     Server: -
     Author: vStudio
     Developer: -
     DOC: 15/03/2022
     Desc: Shared Settings ]]--
----------------------------------------------------------------


------------------
--[[ Settings ]]--
------------------

resource = getResourceRootElement(getThisResource())

inventoryDatas = exports.config_loader:getConfigData("inventory_datas")
availableLootPoints = exports.config_loader:getConfigData("loot_spawnpoints")