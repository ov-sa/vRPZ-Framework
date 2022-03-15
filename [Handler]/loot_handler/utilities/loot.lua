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
    setElementData = setElementData,
    math = math
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
        imports.setElementData(self.lootInstance, "Loot:Lock", FRAMEWORK_CONFIGS["Loots"][lootType].lootLock)
        loot.buffer.element[(self.lootInstance)] = self
        loot.buffer.loot[lootType] = loot.buffer.loot[lootType] or {}
        loot.buffer.loot[lootType][self] = true
        return self.lootInstance
    end

    function loot:refresh(lootType)
        if self == loot then
            thread:create(function(cThread)
                if loot.buffer.loot[lootType] then
                    for i, j in imports.pairs(loot.buffer.loot[lootType]) do
                        if j then i:refresh() end
                        thread.pause()
                    end
                else
                    for i = 1, #FRAMEWORK_CONFIGS["Loots"][lootType], 1 do
                        local cLoot = loot:create(lootType, i)
                        cLoot:refresh()
                        thread.pause()
                    end
                end
            end):resume({
                executions = syncSettings.syncRate,
                frames = 1
            })
        else
            if not self.lootInstance or not lootItems then return false end
            imports.setElementData(self.lootInstance, "Inventory:Slots", imports.math.random(FRAMEWORK_CONFIGS["Loots"][(self.lootType)].inventoryWeight[1], FRAMEWORK_CONFIGS["Loots"][(self.lootType)].inventoryWeight[2]))
            thread:create(function(cThread)
                for i, j in imports.pairs(FRAMEWORK_CONFIGS["Inventory"]["Items"]) do
                    for k, v in imports.pairs(j) do
                        imports.setElementData(self.lootInstance, "Item:"..k, 0)
                        thread.pause()
                    end
                    thread.pause()
                end
                for i = 1, #FRAMEWORK_CONFIGS["Loots"][(self.lootType)].lootItems, 1 do
                    local j = FRAMEWORK_CONFIGS["Loots"][(self.lootType)].lootItems[i]
                    if j.amount then
                        local itemData = exports.player_handler:fetchInventoryItem(j.item)
                        if itemData then
                            imports.setElementData(self.lootInstance, "Item:"..j.item, imports.math.random(j.amount[1], j.amount[2]))
                            if j.ammo then
                                local weaponAmmo = exports.player_handler:fetchInventoryWeaponAmmo(j.item)
                                if weaponAmmo then
                                    imports.setElementData(self.lootInstance, "Item:"..weaponAmmo, imports.math.random(j.ammo[1], j.ammo[2]))
                                end
                            end
                        end
                    end
                    thread.pause()
                end
            end):resume({
                executions = syncSettings.syncRate,
                frames = 1
            })
        end
    end
end