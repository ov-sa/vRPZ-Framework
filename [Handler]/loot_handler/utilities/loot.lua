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

function loot:load(assetType, assetName, lootData)
    if not self or (self == loot) then return false end
    if not assetType or not assetName or not lootData or not lootData.position or not lootData.rotation or not availableAssetPacks[assetType] or not availableAssetPacks[assetType].rwDatas[assetName] then return false end
    local cAsset = availableAssetPacks[assetType].rwDatas[assetName].cAsset
    if not cAsset then return false end
    lootData.position.x, lootData.position.y, lootData.position.z = imports.tonumber(lootData.position.x) or 0, imports.tonumber(lootData.position.y) or 0, imports.tonumber(lootData.position.z) or 0
    lootData.rotation.x, lootData.rotation.y, lootData.rotation.z = imports.tonumber(lootData.position.x) or 0, imports.tonumber(lootData.position.y) or 0, imports.tonumber(lootData.position.z) or 0
    self.assetType, self.assetName = assetType, assetName
    self.cModelInstance = imports.createObject(cAsset.syncedData.modelID, lootData.position.x, lootData.position.y, lootData.position.z, lootData.rotation.x, lootData.rotation.y, lootData.rotation.z)
    imports.setElementDoubleSided(self.cModelInstance, true)
    imports.setElementDimension(self.cModelInstance, imports.tonumber(lootData.dimension) or 0)
    imports.setElementInterior(self.cModelInstance, imports.tonumber(lootData.interior) or 0)
    if cAsset.syncedData.collisionID then
        self.cCollisionInstance = imports.createObject(cAsset.syncedData.collisionID, lootData.position.x, lootData.position.y, lootData.position.z, lootData.rotation.x, lootData.rotation.y, lootData.rotation.z)
        imports.setElementAlpha(self.cCollisionInstance, 0)
        self.cStreamer = streamer:create(self.cModelInstance, "loot", {self.cCollisionInstance})
    end
    loot.buffer[(self.cModelInstance)] = self
    return self.cModelInstance
end

function loot:unload()
    if not self or (self == loot) then return false end
    loot.buffer[self] = nil
    self = nil
    return true
end