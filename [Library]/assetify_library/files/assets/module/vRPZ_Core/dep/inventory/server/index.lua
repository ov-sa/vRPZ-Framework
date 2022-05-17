-----------------
--[[ Imports ]]--
-----------------

local imports = {
    pairs = pairs,
    tonumber = tonumber,
    getElementType = getElementType,
    math = math,
    string = string,
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
    if imports.getElementType(parent) == "player" then
        if not CPlayer.isInitialized(parent) then return false end
        local inventoryID = CPlayer.getInventoryID(parent)
        return imports.math.max(CInventory.fetchMaxSlotsMultiplier(), (inventoryID and CInventory.CBuffer[inventoryID].maxSlots) or 0)
    end
    return false
end

CInventory.fetchParentAssignedSlots = function(parent)
    if imports.getElementType(parent) == "player" then
        if not CPlayer.isInitialized(parent) then return false end
        local inventoryID = CPlayer.getInventoryID(parent)
        return (inventoryID and CInventory.CBuffer[inventoryID].slots) or false
    end
    return false
end

CInventory.isSlotAvailableForOrdering = function(player, item, slot, isEquipped)
    slot = imports.tonumber(slot)
    print("test 1")
    if not CPlayer.isInitialized(player) or not item or not slot then return false end
    local itemData = CInventory.fetchItem(item)
    if not itemData then return false end
    print("test 2")
    local maxSlots, usedSlots = CInventory.fetchParentMaxSlots(player), CInventory.fetchParentUsedSlots(player)
    if not maxSlots or not usedSlots or (slot > maxSlots) or usedSlots[slot] then return false end
    print("test 3")
    if not isEquipped then
        --TODO: ...
        --local usedSlots = getElementUsedSlots(player)
        --if (maxSlots - usedSlots) < CInventory.fetchItemWeight(item) then return false end
    end
    local slotRow, slotColumn = CInventory.fetchSlotLocation(slot)
    if (itemData.data.itemWeight.columns - 1) > (FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.columns - slotColumn) then return false end
    print("test 4")
    for i = slot, slot + (itemData.data.itemWeight.columns - 1), 1 do
        if (i > maxSlots) or usedSlots[i] then
            print("test 5")
            return false
        else
            for k = 2, itemData.data.itemWeight.rows, 1 do
                local v = i + (FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.columns*(k - 1))
                if (v > maxSlots) or usedSlots[v] then
                    print("test 6")
                    return false
                end
            end
        end
    end
    print("test 7")
    return true
end

imports.assetify.execOnLoad(function()
    local CItems = {}
    for i, j in imports.pairs(CInventory.CItems) do
        CItems[(imports.string.lower(i))] = true
    end
    CInventory.ensureItems(CItems)
end)