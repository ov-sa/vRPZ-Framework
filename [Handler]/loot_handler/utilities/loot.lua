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
    attachElements = attachElements,
    destroyElement = destroyElement,
    addEvent = addEvent,
    addEventHandler = addEventHandler,
    triggerClientEvent = triggerClientEvent,
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
    imports.addEvent("Loot_Handler:onRecieveLoot", true)
    imports.addEventHandler("Loot_Handler:onRecieveLoot", root, function(lootType, lootData, colInstance)
        local cLoot = loot:create(lootType, lootData)
        cLoot.colInstance = colInstance
        loot.buffer.loot[(cLoot.colInstance)] = cLoot
        imports.attachElements(cLoot.lootInstance, cLoot.colInstance)
    end)

    function loot:load(lootType, lootData)
        if not self or (self == loot) then return false end
        if not lootType or not lootData then return false end
        self.lootType = lootType
        self.lootInstance = assetify.createDummy("object", lootType, lootData)
        if not self.lootInstance then return false end
        loot.buffer.element[(self.lootInstance)] = self
        return self.lootInstance
    end

    imports.addEventHandler("onClientResourceStart", resource, function()
        local booter = function() imports.triggerServerEvent("Assetify:onRequestLoots", localPlayer) end
        if imports.assetify.isLoaded() then
            booter()
        else
            local booterWrapper = nil
            booterWrapper = function()
                booter()
                imports.removeEventHandler("onAssetifyLoad", root, booterWrapper)
            end
            imports.addEventHandler("onAssetifyLoad", root, booterWrapper)
        end
    end)

    imports.addEventHandler("onClientElementDestroy", resourceRoot, function()
        if loot.buffer.loot[source] then
            loot.buffer.loot[source]:destroy()
        end
        loot.buffer.loot[source] = nil
    end)
else
    function loot:load(lootType, lootIndex)
        if not self or (self == loot) then return false end
        if not FRAMEWORK_CONFIGS["Loots"][lootType] then return false end
        local lootData = FRAMEWORK_CONFIGS["Loots"][lootType][lootIndex]
        self.lootType, self.lootIndex = lootType, lootIndex
        self.lootInstance = imports.createMarker(lootData.position.x, lootData.position.y, lootData.position.z, "cylinder", FRAMEWORK_CONFIGS["Loots"][lootType].size, 0, 0, 0, 0)
        imports.setElementData(self.lootInstance, "Loot:Type", lootType)
        imports.setElementData(self.lootInstance, "Loot:Name", FRAMEWORK_CONFIGS["Loots"][lootType].name)
        imports.setElementData(self.lootInstance, "Loot:Lock", FRAMEWORK_CONFIGS["Loots"][lootType].lock)
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
            thread:create(function(cThread)
                for i, j in imports.pairs(FRAMEWORK_CONFIGS["Inventory"]["Items"]) do
                    for k, v in imports.pairs(j) do
                        imports.setElementData(self.lootInstance, "Item:"..k, 0)
                        thread.pause()
                    end
                    thread.pause()
                end
                imports.setElementData(self.lootInstance, "Inventory:Slots", imports.math.random(FRAMEWORK_CONFIGS["Loots"][(self.lootType)].inventoryWeight[1], FRAMEWORK_CONFIGS["Loots"][(self.lootType)].inventoryWeight[2]))
                for i = 1, #FRAMEWORK_CONFIGS["Loots"][(self.lootType)].items, 1 do
                    local j = FRAMEWORK_CONFIGS["Loots"][(self.lootType)].items[i]
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
        return true
    end

    imports.addEventHandler("Loot_Handler:onRequestLoots", root, function()
        thread:create(function(cThread)
            for i, j in imports.pairs(loot.buffer.element) do
                if i and j then
                    imports.triggerClientEvent(source, "Loot_Handler:onRecieveLoot", source, j.lootType, FRAMEWORK_CONFIGS["Loots"][(j.lootType)][(j.lootIndex)], j.lootInstance)
                end
                thread.pause()
            end
        end):resume({
            executions = syncSettings.syncRate,
            frames = 1
        })
    end)
end