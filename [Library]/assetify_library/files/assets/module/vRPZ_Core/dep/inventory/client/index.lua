-----------------
--[[ Imports ]]--
-----------------

local imports = {
    pairs = pairs,
    tonumber = tonumber,
    getElementType = getElementType,
    math = math,
    assetify = assetify
}


---------------------------
--[[ Module: Inventory ]]--
---------------------------

CInventory.fetchSlotDimensions = function(rows, columns)
    rows, columns = imports.tonumber(rows), imports.tonumber(columns)
    if not rows or not columns then return false end
    return (FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.slotSize + FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.dividerSize)*imports.math.max(0, columns) + FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.dividerSize, (FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.slotSize + FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.dividerSize)*imports.math.max(0, rows) + FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.dividerSize
end

CInventory.fetchParentMaxSlots = function(parent)
    if imports.getElementType(parent) == "player" then
        if not CPlayer.isInitialized(parent) then return false end
        return imports.math.max(CInventory.fetchMaxSlotsMultiplier(), CInventory.CBuffer.maxSlots or 0)
    end
    return false
end

CInventory.fetchParentAssignedSlots = function(parent)
    if imports.getElementType(parent) == "player" then
        if not CPlayer.isInitialized(parent) then return false end
        return CInventory.CBuffer.slots
    end
    return false
end

CInventory.fetchParentUsedSlots = function(parent)
    local maxSlots, assignedSlots = CInventory.fetchParentMaxSlots(parent), CInventory.fetchParentAssignedSlots(parent)
    if not maxSlots or not assignedSlots then return false end
    local usedSlots = {}
    for i, j in imports.pairs(assignedSlots) do
        local isValidSlot = true
        if localPlayer then
            if FRAMEWORK_CONFIGS["Templates"]["Inventory"]["Slots"][i] then
                isValidSlot = false
            else
                if j.translation then
                    if (j.translation ~= "inventory") and (j.translation ~= "equipment") then
                        isValidSlot = false
                    else
                        if j.translation == "equipment" then
                            if inventoryUI.attachedItem and (inventoryUI.attachedItem.parent == localPlayer) and (inventoryUI.attachedItem.prevSlot == j.equipmentIndex) then                
                                if not inventoryUI.attachedItem.animTickCounter then
                                    isValidSlot = false
                                end
                            end
                        end
                    end
                end
            end
        end
        if isValidSlot then
            usedSlots[i] = true
            for k = i, i + (CInventory.CItems[(j.item)].data.itemWeight.columns - 1), 1 do
                for m = 1, CInventory.CItems[(j.item)].data.itemWeight.rows, 1 do
                    usedSlots[(k + (FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.columns*(m - 1)))] = true
                end
            end
        end
    end
    return usedSlots
end

CInventory.isSlotAvailableForOrdering = function(item, slot, isEquipped)
    slot = imports.tonumber(slot)
    if not CPlayer.isInitialized(localPlayer) or not item or not slot or not isInventoryUIEnabled() then return false end
    local itemData = CInventory.fetchItem(item)
    if not itemData then return false end
    local maxSlots, usedSlots = CInventory.fetchParentMaxSlots(localPlayer), CInventory.fetchParentUsedSlots(localPlayer)
    if not maxSlots or not usedSlots or (slot > maxSlots) or usedSlots[slot] then return false end
    if not isEquipped then
        --TODO: ...
        --local usedSlots = getElementUsedSlots(localPlayer)
        --if (maxSlots - usedSlots) < CInventory.fetchItemWeight(item) then return false end
    end
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
    return true
end

imports.assetify.execOnLoad(function()
    for i, j in imports.pairs(CInventory.CItems) do
        j.icon = {
            inventory = imports.assetify.getAssetDep(j.pack, i, "texture", "inventory"),
            hud = imports.assetify.getAssetDep(j.slot, i, "texture", "hud")
        }
        j.dimensions = {CInventory.fetchSlotDimensions(j.data.itemWeight.rows, j.data.itemWeight.columns)}
    end
end)