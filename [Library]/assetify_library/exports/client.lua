----------------------------------------------------------------
--[[ Resource: Assetify Library
     Script: exports: client.lua
     Server: -
     Author: OvileAmriam
     Developer(s): Aviril, Tron
     DOC: 19/10/2021 (OvileAmriam)
     Desc: Client Sided Exports ]]--
----------------------------------------------------------------


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

function createAssetDummy(assetType, assetName, objectData)
    if not assetType or not assetName or not availableAssetPacks[assetType] or not availableAssetPacks[assetType].rwDatas[assetName] then then return false end
    local cAsset = availableAssetPacks[assetType].rwDatas[assetName].unsyncedData.assetCache[i].cAsset
    if not cAsset then return false end
    local cModelInstance = imports.createObject(cAsset.syncedData.modelID, objectData.position.x, objectData.position.y, objectData.position.z, objectData.rotation.x, objectData.rotation.y, objectData.rotation.z)
    imports.setElementDoubleSided(cModelInstance, true)
    if cAsset.syncedData.collisionID then
        local cCollisionInstance = imports.createObject(cAsset.syncedData.collisionID, objectData.position.x, objectData.position.y, objectData.position.z, objectData.rotation.x, objectData.rotation.y, objectData.rotation.z)
        imports.setElementAlpha(cCollisionInstance, 0)
        local cStreamer = streamer:create(cModelInstance, "object", {cCollisionInstance})
    end
    return cModelInstance
end