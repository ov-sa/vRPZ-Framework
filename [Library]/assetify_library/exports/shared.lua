----------------------------------------------------------------
--[[ Resource: Assetify Library
     Script: exports: shared.lua
     Server: -
     Author: OvileAmriam
     Developer(s): Aviril, Tron
     DOC: 19/10/2021 (OvileAmriam)
     Desc: Shared Exports ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local imports = {
    isElement = isElement,
    getElementType = getElementType,
    createObject = createObject,
    setElementDoubleSided = setElementDoubleSided
}


-------------------------
--[[ Functions: APIs ]]--
-------------------------

function setElementAsset(element, ...)
    if not element or not imports.isElement(element) then return false end
    local elementType = imports.getElementType(element)
    elementType = (((elementType == "ped") or (elementType == "player")) and "character") or elementType
    if not availableAssetPacks[elementType] then return false end
    local arguments = {...}
    return syncer:syncElementModel(element, elementType, arguments[1], arguments[2], arguments[3], arguments[4])
end

function createAssetObject(assetType, assetName, objectData)
    if not assetType or not assetName or not availableAssetPacks[assetType] or not availableAssetPacks[assetType].rwDatas[assetName] then then return false end
    local cAsset = availableAssetPacks[assetType].rwDatas[assetName].unsyncedData.assetCache[i].cAsset
    local cModelInstance = imports.createObject(cAsset.syncedData.modelID, objectData.position.x, objectData.position.y, objectData.position.z, objectData.rotation.x, objectData.rotation.y, objectData.rotation.z)
    imports.setElementDoubleSided(cModelInstance, true)
    if cAsset.syncedData.collisionID then
        local cCollisionInstance = imports.createObject(cAsset.syncedData.collisionID, objectData.position.x, objectData.position.y, objectData.position.z, objectData.rotation.x, objectData.rotation.y, objectData.rotation.z)
        imports.setElementAlpha(cCollisionInstance, 0)
        local cStreamer = streamer:create(cModelInstance, "object", {cCollisionInstance})
    end
    return cModelInstance
end