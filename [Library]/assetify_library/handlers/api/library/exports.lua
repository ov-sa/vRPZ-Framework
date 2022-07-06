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
        {name = "isModuleLoaded", API = "isModuleLoaded"}
    },
    client = {},
    server = {}
})