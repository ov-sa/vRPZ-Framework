----------------------------------------------------------------
--[[ Resource: Assetify Library
     Script: handlers. api: library: shared.lua
     Author: vStudio
     Developer(s): Aviril, Tron, Mario, Аниса
     DOC: 19/10/2021
     Desc: Library APIs ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local imports = {
    isElement = isElement
}


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

function manager.API.Library:fetchAssets(...)
    return manager:fetchAssets(...)
end

function manager.API.Library:getAssetData(...)
    return manager:getAssetData(...)
end

function manager.API.Library:getAssetDep(...)
    return manager:getAssetDep(...)
end

function manager.API.Library:setElementAsset(...)
    return syncer:syncElementModel(_, ...)
end

function manager.API.Library:getElementAssetInfo(element)
    if not element or not imports.isElement(element) or not syncer.syncedElements[element] then return false end
    return syncer.syncedElements[element].type, syncer.syncedElements[element].name, syncer.syncedElements[element].clump, syncer.syncedElements[element].clumpMaps
end

function manager.API.Library:setGlobalData(...)
    return syncer:syncGlobalData(...)
end

function manager.API.Library:getGlobalData(data)
    return syncer.syncedGlobalDatas[data]
end

function manager.API.Library:setEntityData(data)
    return syncer:syncEntityData(table:unpack(table:pack(...), 3))
end

function manager.API.Library:getEntityData(element, data)
    return syncer.syncedEntityDatas[element] and syncer.syncedEntityDatas[element][data]
end

--TODO: WIP..
function createAssetDummy(...) local cDummy = syncer:syncDummySpawn(_, ...); return (cDummy and cDummy.cDummy) or false end
function setBoneAttachment(...) return syncer:syncBoneAttachment(_, ...) end
function setBoneDetachment(...) return syncer:syncBoneDetachment(_, ...) end
function setBoneRefreshment(...) return syncer:syncBoneRefreshment(_, ...) end
function clearBoneAttachment(element) return syncer:syncClearBoneAttachment(_, element) end
