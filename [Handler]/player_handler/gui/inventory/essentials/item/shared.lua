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