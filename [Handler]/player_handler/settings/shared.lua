----------------------------------------------------------------
--[[ Resource: Player Handler
     Script: settings: shared.lua
     Author: vStudio
     Developer(s): Mario, Tron, Aviril
     DOC: 31/01/2022
     Desc: Shared Settings ]]--
----------------------------------------------------------------


------------------
--[[ Settings ]]--
------------------

resource = getResourceRootElement(getThisResource())

FRAMEWORK_CONFIGS = {
    ["Game"] = exports.config_loader:getConfig("Game"),
    ["UI"] = exports.config_loader:getConfig("UI"),
    ["Player"] = exports.config_loader:getConfig("Player"),
    ["Character"] = exports.config_loader:getConfig("Character"),
    ["Inventory"] = exports.config_loader:getConfig("Inventory")
}