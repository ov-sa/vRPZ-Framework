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


----------------------
--[[ Class: Dummy ]]--
----------------------

dummy = {
    buffer = {}
}
dummy.__index = dummy

function dummy:create(...)
    local cDummy = imports.setmetatable({}, {__index = self})
    if not cDummy:load(...) then
        cDummy = nil
        return false
    end
    return cDummy
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

function dummy:load(dummyData)
    if not self or (self == dummy) then return false end
    if not dummyData then return false end
    self.element = element
    imports.setElementCollisionsEnabled(element, false)
    self.cStreamer = streamer:create(element, "dummy", {parent})
    dummy.buffer[element] = self
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