----------------------------------------------------------------
--[[ Resource: Loot Handler
     Script: utilities: loot.lua
     Server: -
     Author: vStudio
     Developer(s): Tron
     DOC: 15/03/2022
     Desc: Loot Utilities ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local imports = {
    isElement = isElement,
    setmetatable = setmetatable
}


----------------------
--[[ Class: loot ]]--
----------------------

loot = {
    buffer = {}
}
loot.__index = loot

function loot:create(...)
    local cLoot = imports.setmetatable({}, {__index = self})
    if not cLoot:load(...) then
        cLoot = nil
        return false
    end
    return cLoot
end

function loot:destroy(...)
    if not self or (self == loot) then return false end
    return self:unload(...)
end

function loot:clearElementBuffer(element)
    if not element or not imports.isElement(element) then return false end
    if loot.buffer[element] then
        loot.buffer[element]:destroy()
    end
    return true
end

function loot:load(lootType, lootData)
    if not self or (self == loot) then return false end
    if not lootType or not lootData then return false end
    self.lootType = lootType
    self.lootInstance = assetify.createDummy("object", lootType, lootData)
    if not self.lootInstance then return false end
    loot.buffer[(self.lootInstance)] = self
    return self.lootInstance
end

function loot:unload()
    if not self or (self == loot) then return false end
    loot.buffer[self] = nil
    self = nil
    return true
end