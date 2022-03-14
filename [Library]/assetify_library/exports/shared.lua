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
    getElementType = getElementType
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