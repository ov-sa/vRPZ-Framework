-----------------
--[[ Imports ]]--
-----------------

local imports = {
    pairs = pairs,
    tonumber = tonumber,
    isElement = isElement,
    getElementType = getElementType,
    string = string,
    math = math,
    assetify = assetify,
    dbify = dbify
}


---------------------------
--[[ Module: Inventory ]]--
---------------------------

CInventory.fetch = function(inventoryID, ...)
    imports.dbify.inventory.fetchAll({
        {imports.dbify.inventory.connection.keyColumn, inventoryID}
    }, ...)
    return true
end
CInventory.ensureItems = imports.dbify.inventory.ensureItems
CInventory.create = imports.dbify.inventory.create
CInventory.delete = imports.dbify.inventory.delete
CInventory.setData = imports.dbify.inventory.setData
CInventory.getData = imports.dbify.inventory.getData
CInventory.addItem = imports.dbify.inventory.item.add
CInventory.removeItem = imports.dbify.inventory.item.remove
CInventory.setItemProperty = imports.dbify.inventory.item.setProperty
CInventory.getItemProperty = imports.dbify.inventory.item.getProperty
CInventory.setItemData = imports.dbify.inventory.item.setData
CInventory.getItemData = imports.dbify.inventory.item.getData

CInventory.fetchParentMaxSlots = function(parent)
    if not parent or not imports.isElement(parent) then return false end
    if imports.getElementType(parent) == "player" then
        if not CPlayer.isInitialized(parent) then return false end
        local inventoryID = CPlayer.getInventoryID(parent)
        return imports.math.max(CInventory.fetchMaxSlotsMultiplier(), (inventoryID and CInventory.CBuffer[inventoryID].maxSlots) or 0)
    else
        --TODO: Get data max slots here..
    end
    return false
end

CInventory.fetchParentAssignedSlots = function(parent)
    if not parent or not imports.isElement(parent) then return false end
    if not CPlayer.isInitialized(parent) then return false end
    local inventoryID = CPlayer.getInventoryID(parent)
    return (inventoryID and CInventory.CBuffer[inventoryID].slots) or false
end

CInventory.fetchParentUsedSlots = function(parent)
    local maxSlots, assignedSlots = CInventory.fetchParentMaxSlots(parent), CInventory.fetchParentAssignedSlots(parent)
    if not maxSlots or not assignedSlots then return false end
    local usedSlots = {}
    for i, j in imports.pairs(assignedSlots) do
        if FRAMEWORK_CONFIGS["Templates"]["Inventory"]["Slots"][i] then
            usedSlots[i] = true
        else
            for k = i, i + (CInventory.CItems[(j.item)].data.itemWeight.columns - 1), 1 do
                for m = 1, CInventory.CItems[(j.item)].data.itemWeight.rows, 1 do
                    usedSlots[(k + (FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.columns*(m - 1)))] = true
                end
            end
        end
    end
    return usedSlots
end

CInventory.fetchParentMaxWeight = CInventory.fetchParentMaxSlots

CInventory.fetchParentUsedWeight = function(parent)
    if not parent or not imports.isElement(parent) then return false end
    if (imports.getElementType(parent) == "player") and not CPlayer.isInitialized(parent) then return false end
    local usedWeight = 0
    for i, j in imports.pairs(CInventory.CItems) do
        usedWeight = usedWeight + (CInventory.fetchItemCount(parent, i)*CInventory.fetchItemWeight(i))
    end
    return imports.math.min(CInventory.fetchParentMaxWeight(parent), usedWeight)
end

CInventory.isSlotAvailableForOrdering = function(player, item, slot, isEquipped)
    local isEquipmentSlot = FRAMEWORK_CONFIGS["Templates"]["Inventory"]["Slots"][slot]
    if not isEquipmentSlot then slot = imports.tonumber(slot) end
    if not CPlayer.isInitialized(player) or not item or not slot then return false end
    local itemData = CInventory.fetchItem(item)
    if not itemData then return false end
    local maxSlots, usedSlots = CInventory.fetchParentMaxSlots(player), CInventory.fetchParentUsedSlots(player)
    if not maxSlots or not usedSlots or (isEquipmentSlot and (not itemData.slot or (itemData.slot ~= slot))) or (not isEquipmentSlot and (slot > maxSlots)) or usedSlots[slot] then return false end
    if isEquipped then
        if not isEquipmentSlot then
            for i = slot, slot + (itemData.data.itemWeight.columns - 1), 1 do
                for j = 1, itemData.data.itemWeight.rows, 1 do
                    usedSlots[(i + (FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.columns*(j - 1)))] = nil
                end
            end
        end
    else
        if (maxSlots - CInventory.fetchParentUsedWeight(player)) < CInventory.fetchItemWeight(item) then return false end
    end
    if not isEquipmentSlot then
        local slotRow, slotColumn = CInventory.fetchSlotLocation(slot)
        if (itemData.data.itemWeight.columns - 1) > (FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.columns - slotColumn) then return false end
        for i = slot, slot + (itemData.data.itemWeight.columns - 1), 1 do
            if (i > maxSlots) or usedSlots[i] then
                return false
            else
                for k = 2, itemData.data.itemWeight.rows, 1 do
                    local v = i + (FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.columns*(k - 1))
                    if (v > maxSlots) or usedSlots[v] then
                        return false
                    end
                end
            end
        end
    end
    return true
end

imports.assetify.execOnLoad(function()
    local CItems = {}
    for i, j in imports.pairs(CInventory.CItems) do
        CItems[(imports.string.lower(i))] = true
    end
    CInventory.ensureItems(CItems)
end)