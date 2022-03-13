----------------------------------------------------------------
--[[ Resource: Assetify Library
     Script: utilities: bone.lua
     Server: -
     Author: OvileAmriam
     Developer(s): Aviril, Tron
     DOC: 19/10/2021 (OvileAmriam)
     Desc: Bone Utilities ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local imports = {
    isElement = isElement,
    getElementType = getElementType,
    setElementMatrix = setElementMatrix,
    setElementPosition = setElementPosition,
    getElementBoneMatrix = getElementBoneMatrix,
    setElementCollisionsEnabled = setElementCollisionsEnabled,
    math = math,
    matrix = matrix
}


---------------------
--[[ Class: Bone ]]--
---------------------

bone = {
    ids = {
        ped = {1, 2, 3, 4, 5, 6, 7, 8, 21, 22, 23, 24, 25, 26, 31, 32, 33, 34, 35, 36, 41, 42, 43, 44, 51, 52, 53, 54},
        vehicle = {}
    },
    buffer = {},
    cache = {}
}
bone.__index = bone

for i, j in imports.pairs(bone.ids) do
    local indexes = {}
    for k = 1, #j, 1 do indexes[(j[k])] = true end
    bone.ids[i] = indexes
end

function bone:create(...)
    local cBone = imports.setmetatable({}, {__index = self})
    if not cBone:load(...) then
        cBone = nil
        return false
    end
    return cBone
end

function bone:destroy(...)
    if not self or (self == bone) then return false end
    return self:unload(...)
end

function bone:load(entity, parent, boneData)
    if not self or (self == bone) then return false end
    if not entity or not imports.isElement(entity) or not parent or not imports.isElement(parent) or not boneData then return false end
    self.entity = entity
    self.parent = parent
    if not self:refresh(boneData) then return false end
    imports.setElementCollisionsEnabled(entity, false)
    self.cStreamer = streamer:create(entity, "bone", {parent})
    return true
end

function bone:unload()
    if not self or (self == bone) then return false end
    if self.cStreamer then
        self.cStreamer:destroy()
    end
    self = nil
    return true
end

function bone:refresh(boneData)
    if not self or (self == bone) then return false end
    local parentType = imports.getElementType(self.parent)
    if parentType or not bone.ids[parentType] then return false end
    boneData.id = imports.tonumber(boneData.id)
    if not boneData.id or not bone.ids[parentType][(boneData.id)] or not boneData.position or not boneData.rotation then return false end
    boneData.position.x, boneData.position.y, boneData.position.z = imports.tonumber(boneData.position.x) or 0, imports.tonumber(boneData.position.y) or 0, imports.tonumber(boneData.position.z) or 0
    boneData.rotation.x, boneData.rotation.y, boneData.rotation.z = imports.tonumber(boneData.position.x) or 0, imports.tonumber(boneData.position.y) or 0, imports.tonumber(boneData.position.z) or 0
    boneData.rotationMatrix = imports.matrix.fromRotation(boneData.rotation.x, boneData.rotation.y, boneData.rotation.z)
    self.boneData = boneData
    return true
end

function self:update()
    if not self or (self == bone) then return false end
    --bone.cache[(self.parent)] = bone.cache[(self.parent)] or {}
    bone.cache[(self.parent)] = {}
    bone.cache[(self.parent)][(self.boneData.id)] = bone.cache[(self.parent)][(self.boneData.id)] or imports.getElementBoneMatrix(parent, self.boneData.id)
    if bone.cache[(self.parent)][(self.boneData.id)] then
        imports.setElementMatrix(self.entity, imports.matrix.transform(bone.cache[(self.parent)][(self.boneData.id)], self.boneData.rotationMatrix, self.boneData.position.x, self.boneData.position.y, self.boneData.position.z))
    end
end