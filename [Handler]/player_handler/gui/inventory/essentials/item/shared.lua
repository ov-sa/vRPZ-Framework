----------------------------------------------------------------
--[[ Resource: Player Handler
     Script: handlers: inventory: essentials: item: shared.lua
     Server: -
     Author: OvileAmriam
     Developer: -
     DOC: 18/12/2020 (OvileAmriam)
     Desc: Inventory Item's Essentials ]]--
----------------------------------------------------------------


-----------------------------------------------------------------------------
--[[ Functions: Verifies Player's/Equipment's/Loot's Slot's Availability ]]--
-----------------------------------------------------------------------------

function isPlayerSlotAvailableForOrdering(player, item, slotIndex, isEquippedItem)

    slotIndex = tonumber(slotIndex)
    if not player or not isElement(player) or player:getType() ~= "player" or not item or not slotIndex then return false end
    if not CPlayer.isInitialized(player) then return false end
    local itemDetails = getItemDetails(item)
    if not itemDetails then return false end

    local itemWeight = getItemWeight(item)
    local totalSlots, occupiedSlots = false, false
    if localPlayer then
        if inventoryUI.isUIEnabled() then
            totalSlots = CInventory.fetchParentMaxSlots(player)
            occupiedSlots = CInventory.fetchParentUsedSlots(player)
        end
    else
        if CInventory.CBuffer[parent] then
            totalSlots = CInventory.CBuffer[parent].maxSlots
            occupiedSlots = CInventory.fetchParentUsedSlots(player)
        end
    end
    if totalSlots and occupiedSlots and slotIndex <= totalSlots and not occupiedSlots[slotIndex] then
        if not isEquippedItem then
            local usedSlots = getElementUsedSlots(player)
            if (totalSlots - usedSlots) < itemWeight then return false end
        end
        local slot_row = math.ceil(slotIndex/maximumInventoryRowSlots)
        local slot_column = slotIndex - (math.max(0, slot_row - 1)*maximumInventoryRowSlots)
        local horizontalSlotsToOccupy = math.max(1, tonumber(itemDetails.itemHorizontalSlots) or 1)
        local verticalSlotsToOccupy = math.max(1, tonumber(itemDetails.itemVerticalSlots) or 1)
        if (horizontalSlotsToOccupy - 1) <= (maximumInventoryRowSlots - slot_column) then
            for i = slotIndex, slotIndex + (horizontalSlotsToOccupy - 1), 1 do
                if i > totalSlots or occupiedSlots[i] then
                    return false
                else
                    for k = 2, verticalSlotsToOccupy, 1 do
                        local succeedingColumnIndex = i + (maximumInventoryRowSlots*(k - 1))
                        if succeedingColumnIndex > totalSlots or occupiedSlots[succeedingColumnIndex] then
                            return false
                        end
                    end
                end
            end
            return true
        end
    end
    return false

end

function isPlayerSlotAvailableForEquipping(player, item, slotIndex, viaClientInventory)

    if not player or not isElement(player) or player:getType() ~= "player" or not item or not slotIndex or not characterSlots[slotIndex] then return false end
    if not CPlayer.isInitialized(player) then return false end
    local itemDetails = getItemDetails(item)
    if not itemDetails then return false end

    if localPlayer then
        if inventoryUI.isUIEnabled() then
            if inventoryUI.gui.equipment.grids[slotIndex] and not CInventory.CBuffer.slots[slotIndex] and inventoryUI.gui.equipment.grids[slotIndex].slotCategory and inventoryUI.gui.equipment.grids[slotIndex].slotCategory == inventoryUI.attachedItem.category then
                if not viaClientInventory then
                    local totalSlots = CInventory.fetchParentMaxSlots(player)
                    if totalSlots then
                        for i = 1, totalSlots, 1 do
                            if isPlayerSlotAvailableForOrdering(player, item, i) then
                                return true, i
                            end
                        end
                    end
                else
                    return true
                end
            end
        end
    else
        if CInventory.CBuffer[parent] and not CInventory.CBuffer[parent].slots[slotIndex] then
            return true
        end
    end
    return false

end

function isLootSlotAvailableForDropping(loot, item)

    if not loot or not isElement(loot) or not item then return false end
    local itemDetails = getItemDetails(item)
    if not itemDetails then return false end
    local usedSlots = getElementUsedSlots(loot)
    local maxSlots = CInventory.fetchParentMaxSlots(loot)
    if not usedSlots or not maxSlots then return false end

    local itemWeight = getItemWeight(item)
    local remainingSlots = maxSlots - usedSlots
    return itemWeight <= remainingSlots

end