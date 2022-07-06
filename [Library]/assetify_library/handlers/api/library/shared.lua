----------------------------------------------------------------
--[[ Resource: Assetify Library
     Script: handlers. api: library: shared.lua
     Author: vStudio
     Developer(s): Aviril, Tron, Mario, Аниса
     DOC: 19/10/2021
     Desc: Library APIs ]]--
----------------------------------------------------------------


-----------------------
--[[ APIs: Library ]]--
-----------------------

manager.API.Library = {}

function manager.API.Library:isLoaded()
    return syncer.isLibraryLoaded
end

function manager.API.Library:isModuleLoaded()
    return syncer.isModuleLoaded
end