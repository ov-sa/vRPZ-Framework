----------------------------------------------------------------
--[[ Resource: Player Handler
     Script: settings: shared.lua
     Author: vStudio
     Developer(s): Mario, Tron
     DOC: 31/01/2022
     Desc: Shared Settings ]]--
----------------------------------------------------------------


------------------
--[[ Settings ]]--
------------------

resource = getResourceRootElement(getThisResource())

FRAMEWORK_CONFIGS = {
    ["Game"] = exports.config_loader:getConfig("Game"),
    ["UI"] = exports.config_loader:getConfig("UI")
}