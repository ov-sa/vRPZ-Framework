----------------------------------------------------------------
--[[ Resource: Assetify Library
     Script: exports: client.lua
     Server: -
     Author: OvileAmriam
     Developer(s): Aviril, Tron
     DOC: 19/10/2021 (OvileAmriam)
     Desc: Client Sided Exports ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local imports = {
    isElement = isElement,
    createObject = createObject,
    setElementDoubleSided = setElementDoubleSided
}


-------------------------
--[[ Functions: APIs ]]--
-------------------------

function isLibraryLoaded()
    return syncer.isLibraryLoaded
end

function getAssetData(...)
    return manager:getData(...)
end

function getAssetID(...)
    return manager:getID(...)
end

function isAssetLoaded(...)
    return manager:isLoaded(...)
end

function loadAsset(...)
    return manager:load(...)
end

function unloadAsset(...)
    return manager:unload(...)
end

function setBoneAttachment(...)
    return bone:create(...)
end

function setBoneDetachment(element)
    if not element or not imports.isElement(element) or not bone.buffer.element[element] then return false end
    return bone.buffer.element[element]:destroy()
end

function setBoneRefreshment(element, ...)
    if not element or not imports.isElement(element) or not bone.buffer.element[element] then return false end
    return bone.buffer.element[element]:destroy(...)
end

function clearBoneAttachment(element, ...)
    if not element or not imports.isElement(element) or not bone.buffer.element[element] then return false end
    return bone.buffer.element[element]:clearElementBuffer(...)
end

function createAssetDummy(assetType, assetName, dummyData)
    if not assetType or not assetName or not availableAssetPacks[assetType] or not availableAssetPacks[assetType].rwDatas[assetName] then then return false end
    local cAsset = availableAssetPacks[assetType].rwDatas[assetName].unsyncedData.assetCache[i].cAsset
    if not cAsset then return false end
    local cModelInstance = imports.createObject(cAsset.syncedData.modelID, dummyData.position.x, dummyData.position.y, dummyData.position.z, dummyData.rotation.x, dummyData.rotation.y, dummyData.rotation.z)
    imports.setElementDoubleSided(cModelInstance, true)
    if cAsset.syncedData.collisionID then
        local cCollisionInstance = imports.createObject(cAsset.syncedData.collisionID, dummyData.position.x, dummyData.position.y, dummyData.position.z, dummyData.rotation.x, dummyData.rotation.y, dummyData.rotation.z)
        imports.setElementAlpha(cCollisionInstance, 0)
        local cStreamer = streamer:create(cModelInstance, "object", {cCollisionInstance})
    end
    return cModelInstance
end