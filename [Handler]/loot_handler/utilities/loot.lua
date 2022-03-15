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
    pairs = pairs,
    isElement = isElement,
    destroyElement = destroyElement,
    setmetatable = setmetatable,
    createMarker = createMarker,
    setElementData = setElementData
}


----------------------
--[[ Class: loot ]]--
----------------------

loot = {
    buffer = {
        element = {},
        loot = {}
    }
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
    if loot.buffer.element[element] then
        loot.buffer.element[element]:destroy()
    end
    return true
end

function loot:unload()
    if not self or (self == loot) then return false end
    if self.lootInstance then
        imports.destroyElement(self.lootInstance)
    end
    loot.buffer.element[self] = nil
    loot.buffer.loot[(self.lootType)][self] = nil
    self = nil
    return true
end

if localPlayer then
    function loot:load(lootType, lootData)
        if not self or (self == loot) then return false end
        if not lootType or not lootData then return false end
        self.lootType = lootType
        self.lootInstance = assetify.createDummy("object", lootType, lootData)
        if not self.lootInstance then return false end
        loot.buffer.element[(self.lootInstance)] = self
        return self.lootInstance
    end
else
    function loot:load(lootType, lootIndex)
        if not self or (self == loot) then return false end
        if not FRAMEWORK_CONFIGS["Loots"][lootType] then return false end
        local lootData = FRAMEWORK_CONFIGS["Loots"][lootType][lootIndex]
        self.lootType, self.lootIndex = lootType, lootIndex
        self.lootInstance = imports.createMarker(lootData.position.x, lootData.position.y, lootData.position.z, "cylinder", FRAMEWORK_CONFIGS["Loots"][lootType].lootSize, 0, 0, 0, 0)
        imports.setElementData(self.lootInstance, "Loot:Type", lootType)
        imports.setElementData(self.lootInstance, "Loot:Name", FRAMEWORK_CONFIGS["Loots"][lootType].lootName)
        imports.setElementData(self.lootInstance, "Loot:Locked", FRAMEWORK_CONFIGS["Loots"][lootType].lootLock)
        loot.buffer.element[(self.lootInstance)] = self
        loot.buffer.loot[lootType] = loot.buffer.loot[lootType] or {}
        loot.buffer.loot[lootType][self] = true
        return self.lootInstance
    end
end