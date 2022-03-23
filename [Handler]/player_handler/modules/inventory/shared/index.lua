----------------------------------------------------------------
--[[ Resource: Player Handler
     Script: modules: inventory: shared: index.lua
     Author: vStudio
     Developer(s): Mario, Tron, Aviril
     DOC: 31/01/2022
     Desc: Inventory Module ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local imports = {
    pairs = pairs,
    tonumber = tonumber,
    isElement = isElement,
    getElementType = getElementType,
    getElementData = getElementData,
    math = math
}


---------------------------
--[[ Module: Inventory ]]--
---------------------------

CInventory = {
    CBuffer = {},
    CSlots = {},
    CItems = {},

    fetchItem = function(item)
        if not item or not CInventory.CItems[item] then return false end
        return CInventory.CItems[item]
    end,

    fetchItemSlot = function(item)
        local itemData = CInventory.fetchItem(item)
        return (itemData and itemData.slot) or false
    end,

    fetchItemName = function(item)
        local itemData = CInventory.fetchItem(item)
        return (itemData and itemData.data and itemData.data.name) or false
    end,

    fetchItemWeight = function(item)
        local itemData = CInventory.fetchItem(item)
        return (itemData and itemData.data and itemData.data.weight and imports.math.max(0, itemData.data.weight.rows*itemData.data.weight.columns)) or false
    end,

    fetchItemObjectID = function(item)
        local itemData = CInventory.fetchItem(item)
        return (itemData and itemData.data and imports.tonumber(itemData.data.objectID)) or false
    end,

    fetchWeaponSlot = function(item)
        local itemData = CInventory.fetchItem(item)
        if itemData and itemData.slot and CInventory.CSlots["Weapon"][(itemData.slot)] then
            return itemData.slot, CInventory.CSlots["Weapon"][(itemData.slot)]
        end
        return false
    end,

    fetchWeaponID = function(item)
        local itemData = CInventory.fetchItem(item)
        local weaponSlot = CInventory.fetchWeaponSlot(item)
        return (itemData and weaponSlot and itemData.data.weapon and imports.tonumber(itemData.data.weapon.id)) or false
    end,

    fetchWeaponAmmo = function(item)
        local itemData = CInventory.fetchItem(item)
        local weaponSlot = CInventory.fetchWeaponSlot(item)
        return (itemData and weaponSlot and itemData.data.weapon and imports.tonumber(itemData.data.weapon.ammo)) or false
    end,

    fetchWeaponMag = function(item)
        local itemData = CInventory.fetchItem(item)
        local weaponSlot = CInventory.fetchWeaponSlot(item)
        return (itemData and weaponSlot and itemData.data.weapon and imports.tonumber(itemData.data.weapon.mag)) or 0
    end,

    fetchSlot = function(slot)
        if not slot then return false end
        return FRAMEWORK_CONFIGS["Inventory"]["Slots"][slot] or false
    end,

    fetchItemCount = function(parent, item)
        if not parent or not item or not imports.isElement(parent) or not CInventory.CItems[item] then return false end
        return imports.math.max(0, imports.tonumber(imports.getElementData(parent, "Item:"..item)) or 0)
    end,

    fetchMaxSlotsMultiplier = function()
        return FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.rows*FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.columns
    end,

    fetchParentMaxSlots = function(parent)
        if not parent or not imports.isElement(parent) then return false end
        if imports.getElementType(parent) == "player" then
            if not CPlayer.isInitialized(parent) or (localPlayer and (localPlayer ~= parent)) then return false end
            return imports.math.max(CInventory.fetchMaxSlotsMultiplier(), (localPlayer and imports.tonumber(CInventory.CBuffer.maxSlots)) or (not localPlayer and CInventory.CBuffer[parent] and imports.tonumber(CInventory.CBuffer[parent].maxSlots)) or 0)
        end
        return imports.tonumber(imports.getElementData(parent, "Inventory:MaxSlots")) or 0
    end,

    fetchParentUsedSlots = function(parent)
        if not CPlayer.isInitialized(player) then return false end
        local totalSlots, assignedSlots = false, false
        if localPlayer then
            totalSlots = CInventory.fetchParentMaxSlots(player)
            assignedSlots = inventoryUI.slots.slots
        else
            if CInventory.CBuffer[parent] then
                totalSlots = CInventory.CBuffer[parent].maxSlots
                assignedSlots = CInventory.CBuffer[parent].slots
            end
        end
        if totalSlots and assignedSlots then
            local occupiedSlots = {}
            for i, j in pairs(assignedSlots) do
                local isSlotToBeConsidered = true
                if localPlayer then
                    if not tonumber(i) then
                        isSlotToBeConsidered = false
                    else
                        if j.movementType then
                            if j.movementType ~= "inventory" and j.movementType ~= "equipment" then
                                isSlotToBeConsidered = false
                            else
                                if j.movementType == "equipment" then
                                    if inventoryUI.attachedItem and (inventoryUI.attachedItem.itemBox == localPlayer) and (inventoryUI.attachedItem.prevSlotIndex == j.equipmentIndex) then                
                                        if not inventoryUI.attachedItem.animTickCounter then
                                            isSlotToBeConsidered = false
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
                if isSlotToBeConsidered then
                    local _itemDetails = getItemDetails(j.item)
                    if _itemDetails then
                        occupiedSlots[i] = true
                        local horizontalSlotsToOccupy = math.max(1, tonumber(_itemDetails.itemHorizontalSlots) or 1)
                        local verticalSlotsToOccupy = math.max(1, tonumber(_itemDetails.itemVerticalSlots) or 1)
                        for k = i, i + (horizontalSlotsToOccupy - 1), 1 do
                            for m = 1, verticalSlotsToOccupy, 1 do
                                local succeedingColumnIndex = k + (maximumInventoryRowSlots*(m - 1))
                                occupiedSlots[succeedingColumnIndex] = true
                            end
                        end
                    end
                end
            end
            return occupiedSlots
        end
        return false
    end
}

for i, j in imports.pairs(FRAMEWORK_CONFIGS["Inventory"]["Items"]) do
    if FRAMEWORK_CONFIGS["Inventory"]["Slots"][i] and (FRAMEWORK_CONFIGS["Inventory"]["Slots"][i].identifier == "Weapon") then
        CInventory.CSlots[(FRAMEWORK_CONFIGS["Inventory"]["Slots"][i].identifier)] = CInventory.CSlots[(FRAMEWORK_CONFIGS["Inventory"]["Slots"][i].identifier)] or {}
        CInventory.CSlots[(FRAMEWORK_CONFIGS["Inventory"]["Slots"][i].identifier)][i] = FRAMEWORK_CONFIGS["Inventory"]["Slots"][i]
    else
        CInventory.CSlots[(FRAMEWORK_CONFIGS["Inventory"]["Slots"][i].identifier)] = FRAMEWORK_CONFIGS["Inventory"]["Slots"][i]
    end
    for k, v in imports.pairs(j) do
        CInventory.CItems[k] = {slot = i, data = v}
    end
end