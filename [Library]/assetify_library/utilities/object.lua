----------------------------------------------------------------
--[[ Resource: Assetify Library
     Script: utilities: object.lua
     Server: -
     Author: OvileAmriam
     Developer(s): Aviril, Tron
     DOC: 19/10/2021 (OvileAmriam)
     Desc: Object Utilities ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local imports = {
    pairs = pairs,
    tonumber = tonumber,
    isElement = isElement,
    setmetatable = setmetatable,
    getElementType = getElementType,
    setElementPosition = setElementPosition,
    setElementCollisionsEnabled = setElementCollisionsEnabled,
    math = math,
    matrix = matrix
}


---------------------
--[[ Class: Bone ]]--
---------------------

object = {
    buffer = {}
}
object.__index = object

function object:create(...)
    local cObject = imports.setmetatable({}, {__index = self})
    if not cObject:load(...) then
        cObject = nil
        return false
    end
    return cObject
end

function object:destroy(...)
    if not self or (self == object) then return false end
    return self:unload(...)
end

function object:clearElementBuffer(element)
    if not element or not imports.isElement(element) then return false end
    if object.buffer.element[element] then
        object.buffer.element[element]:destroy()
    end
    if object.buffer.parent[element] then
        for i, j in imports.pairs(object.buffer.parent[element]) do
            i:destroy()
        end
    end
    object.buffer.parent[element] = nil
    return true
end

function object:load(element, parent, boneData)
    if not self or (self == object) then return false end
    if not element or not imports.isElement(element) or not parent or not imports.isElement(parent) or not boneData or (element == parent) or object.buffer.element[element] then return false end
    self.element = element
    self.parent = parent
    if not self:refresh(boneData) then return false end
    imports.setElementCollisionsEnabled(element, false)
    self.cStreamer = streamer:create(element, "object", {parent})
    object.buffer.element[element] = self
    object.buffer.parent[parent] = object.buffer.parent[parent] or {}
    object.buffer.parent[parent][self] = true
    return true
end

function object:unload()
    if not self or (self == object) then return false end
    if self.cStreamer then
        self.cStreamer:destroy()
    end
    object.buffer.element[(self.element)] = nil
    self = nil
    return true
end

function object:refresh(boneData)
    if not self or (self == object) then return false end
    local parentType = imports.getElementType(self.parent)
    parentType = (parentType == "player" and "ped") or parentType
    if not parentType or not object.ids[parentType] then return false end
    boneData.id = imports.tonumber(boneData.id)
    if not boneData.id or not object.ids[parentType][(boneData.id)] or not boneData.position or not boneData.rotation then return false end
    boneData.position.x, boneData.position.y, boneData.position.z = imports.tonumber(boneData.position.x) or 0, imports.tonumber(boneData.position.y) or 0, imports.tonumber(boneData.position.z) or 0
    boneData.rotation.x, boneData.rotation.y, boneData.rotation.z = imports.tonumber(boneData.position.x) or 0, imports.tonumber(boneData.position.y) or 0, imports.tonumber(boneData.position.z) or 0
    boneData.rotationMatrix = imports.matrix.fromRotation(boneData.rotation.x, boneData.rotation.y, boneData.rotation.z)
    self.boneData = boneData
    return true
end