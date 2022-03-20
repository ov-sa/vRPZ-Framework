----------------------------------------------------------------
--[[ Resource: Player Handler
     Script: handlers: inventory: essentials: item: shared.lua
     Server: -
     Author: OvileAmriam
     Developer: -
     DOC: 18/12/2020 (OvileAmriam)
     Desc: Inventory Item's Essentials ]]--
----------------------------------------------------------------


-----------------------------------------------------
--[[ Function: Retrieves Player's Occupied Slots ]]--
-----------------------------------------------------

function getPlayerOccupiedSlots(player)

    if not player or not isElement(player) or player:getType() ~= "player" then return false end
    if not CPlayer.isInitialized(player) then return false end

    local totalSlots, assignedSlots = false, false
    if localPlayer then
        totalSlots = getElementMaxSlots(player)
        assignedSlots = inventoryUI.slots.slots
    else
        if playerInventorySlots[player] then
            totalSlots = playerInventorySlots[player].maxSlots
            assignedSlots = playerInventorySlots[player].slots
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
            totalSlots = getElementMaxSlots(player)
            occupiedSlots = getPlayerOccupiedSlots(player)
        end
    else
        if playerInventorySlots[player] then
            totalSlots = playerInventorySlots[player].maxSlots
            occupiedSlots = getPlayerOccupiedSlots(player)
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
            if inventoryUI.gui.equipment.grids[slotIndex] and not inventoryUI.slots.slots[slotIndex] and inventoryUI.gui.equipment.grids[slotIndex].slotCategory and inventoryUI.gui.equipment.grids[slotIndex].slotCategory == inventoryUI.attachedItem.category then
                if not viaClientInventory then
                    local totalSlots = getElementMaxSlots(player)
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
        if playerInventorySlots[player] and not playerInventorySlots[player].slots[slotIndex] then
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
    local maxSlots = getElementMaxSlots(loot)
    if not usedSlots or not maxSlots then return false end

    local itemWeight = getItemWeight(item)
    local remainingSlots = maxSlots - usedSlots
    return itemWeight <= remainingSlots

end