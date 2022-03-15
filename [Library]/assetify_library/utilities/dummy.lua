----------------------------------------------------------------
--[[ Resource: Assetify Library
     Script: utilities: dummy.lua
     Server: -
     Author: OvileAmriam
     Developer(s): Aviril, Tron
     DOC: 19/10/2021 (OvileAmriam)
     Desc: Dummy Utilities ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local imports = {
    tonumber = tonumber,
    setmetatable = setmetatable,
    createObject = createObject,
    setElementDoubleSided = setElementDoubleSided
}


---------------------
--[[ Class: Bone ]]--
---------------------

dummy = {
    buffer = {}
}
dummy.__index = dummy

function dummy:create(...)
    local cObject = imports.setmetatable({}, {__index = self})
    if not cObject:load(...) then
        cObject = nil
        return false
    end
    return cObject
end

function dummy:destroy(...)
    if not self or (self == dummy) then return false end
    return self:unload(...)
end

function dummy:clearElementBuffer(element)
    if not element or not imports.isElement(element) then return false end
    if dummy.buffer[element] then
        dummy.buffer[element]:destroy()
    end
    return true
end

function dummy:load(element, parent, boneData)
    if not self or (self == dummy) then return false end
    if not element or not imports.isElement(element) or not parent or not imports.isElement(parent) or not boneData or (element == parent) or dummy.buffer[element] then return false end
    self.element = element
    self.parent = parent
    if not self:refresh(boneData) then return false end
    imports.setElementCollisionsEnabled(element, false)
    self.cStreamer = streamer:create(element, "dummy", {parent})
    dummy.buffer[element] = self
    dummy.buffer.parent[parent] = dummy.buffer.parent[parent] or {}
    dummy.buffer.parent[parent][self] = true
    return true
end

function dummy:unload()
    if not self or (self == dummy) then return false end
    if self.cStreamer then
        self.cStreamer:destroy()
    end
    dummy.buffer[(self.element)] = nil
    self = nil
    return true
end