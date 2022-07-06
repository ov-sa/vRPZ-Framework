----------------------------------------------------------------
--[[ Resource: Assetify Library
     Script: handlers. api: library: exports.lua
     Author: vStudio
     Developer(s): Aviril, Tron, Mario, Аниса
     DOC: 19/10/2021
     Desc: Library APIs ]]--
----------------------------------------------------------------


-----------------
--[[ Exports ]]--
-----------------

manager:exportAPI("Library", {
    shared = {
        {name = "isLibraryLoaded", API = "isLoaded"},
        {name = "isModuleLoaded", API = "isModuleLoaded"},
        {name = "getLibraryAssets", API = "fetchAssets"},
        {name = "getAssetData", API = "getAssetData"},
        {name = "getAssetDep", API = "getAssetDep"},
        {name = "setElementAsset", API = "setElementAsset"},
        {name = "getElementAssetInfo", API = "getElementAssetInfo"},
        {name = "setGlobalData", API = "setGlobalData"},
        {name = "getGlobalData", API = "getGlobalData"},
        {name = "setEntityData", API = "setEntityData"},
        {name = "getEntityData", API = "getEntityData"}
    },
    client = {},
    server = {}
})