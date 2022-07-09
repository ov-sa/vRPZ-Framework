-----------------
--[[ Imports ]]--
-----------------

local imports = {
    pairs = pairs,
    tonumber = tonumber,
    isElement = isElement,
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
    return (FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.slotSize + FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.dividerSize)*imports.math:max(0, columns) + FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.dividerSize, (FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.slotSize + FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.dividerSize)*imports.math:max(0, rows) + FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.dividerSize
end

CInventory.fetchParentMaxSlots = function(parent)
    if not parent or not imports.isElement(parent) then return false end
    if imports.getElementType(parent) == "player" then
        if not CPlayer.isInitialized(parent) and (parent ~= localPlayer) then return false end
        return imports.math:max(CInventory.fetchMaxSlotsMultiplier(), CInventory.CBuffer.maxSlots or 0)
    else
        return imports.math:max(0, imports.tonumber(CGame.getEntityData(parent, "Inventory:MaxSlots")) or 0)
    end
    return false
end

CInventory.fetchParentAssignedSlots = function(parent)
    if not parent or not imports.isElement(parent) then return false end
    if not CPlayer.isInitialized(parent) or (parent ~= localPlayer) then return false end
    return CInventory.CBuffer.slots
end

CInventory.fetchParentUsedSlots = function(parent)
    local maxSlots, assignedSlots = CInventory.fetchParentMaxSlots(parent), CInventory.fetchParentAssignedSlots(parent)
    if not maxSlots or not assignedSlots then return false end
    local usedSlots = {}
    for i, j in imports.pairs(assignedSlots) do
        local isValidSlot = true
        if FRAMEWORK_CONFIGS["Templates"]["Inventory"]["Slots"][i] then
            usedSlots[i] = true
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
        if isValidSlot then
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
    if (imports.getElementType(parent) == "player") and (not CPlayer.isInitialized(parent) or (parent ~= localPlayer)) then return false end
    local usedWeight = 0
    for i, j in imports.pairs(CInventory.CItems) do
        usedWeight = usedWeight + (CInventory.fetchItemCount(parent, i)*CInventory.fetchItemWeight(i))
    end
    return imports.math:min(CInventory.fetchParentMaxWeight(parent), usedWeight)
end

CInventory.isSlotAvailableForOrdering = function(item, prevSlot, slot, isEquipped)
    local isEquipmentSlot = FRAMEWORK_CONFIGS["Templates"]["Inventory"]["Slots"][slot]
    if not isEquipmentSlot then slot = imports.tonumber(slot) end
    if not CPlayer.isInitialized(localPlayer) or not item or not slot or not isInventoryUIEnabled() then return false end
    local itemData = CInventory.fetchItem(item)
    if not itemData then return false end
    local maxSlots, usedSlots = CInventory.fetchParentMaxSlots(localPlayer), CInventory.fetchParentUsedSlots(localPlayer)
    if not maxSlots or not usedSlots or (isEquipmentSlot and (not itemData.slot or (itemData.slot ~= slot))) or (not isEquipmentSlot and (slot > maxSlots)) then return false end
    if isEquipped then
        if not prevSlot or not usedSlots[prevSlot] then return false end
        if not CInventory.CBuffer.slots[prevSlot] or (CInventory.CBuffer.slots[prevSlot].item ~= item) then return false end
        if not isEquipmentSlot and not FRAMEWORK_CONFIGS["Templates"]["Inventory"]["Slots"][prevSlot] then
            prevSlot = imports.tonumber(prevSlot)
            if not prevSlot then return false end
            for i = prevSlot, prevSlot + (itemData.data.itemWeight.columns - 1), 1 do
                for k = 1, itemData.data.itemWeight.rows, 1 do
                    usedSlots[(i + (FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.columns*(k - 1)))] = nil
                end
            end
        end
    else
        if (maxSlots - CInventory.fetchParentUsedWeight(localPlayer)) < CInventory.fetchItemWeight(item) then return false end
    end
    if isEquipmentSlot then
        if usedSlots[slot] then return false end
    else
        local slotRow, slotColumn = CInventory.fetchSlotLocation(slot)
        if (itemData.data.itemWeight.columns - 1) > (FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.columns - slotColumn) then return false end
        for i = slot, slot + (itemData.data.itemWeight.columns - 1), 1 do
            for k = 1, itemData.data.itemWeight.rows, 1 do
                local v = i + (FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.columns*(k - 1))
                if (v > maxSlots) or usedSlots[v] then
                    return false
                end
            end
        end
    end
    return true
end

imports.assetify.scheduler.execOnLoad(function()
    for i, j in imports.pairs(CInventory.CItems) do
        j.icon = {
            inventory = imports.assetify.getAssetDep(j.pack, i, "texture", "inventory"),
            hud = imports.assetify.getAssetDep(j.pack, i, "texture", "hud")
        }
        j.dimensions = {CInventory.fetchSlotDimensions(j.data.itemWeight.rows, j.data.itemWeight.columns)}
    end
end)