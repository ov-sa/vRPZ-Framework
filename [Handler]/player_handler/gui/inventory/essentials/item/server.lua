-------------------------------------------------------
--[[ Events: On Player Move Item In Inventory/Loot ]]--
-------------------------------------------------------

addEvent("onPlayerMoveItemInInventory", true)
addEventHandler("onPlayerMoveItemInInventory", root, function(item, slotIndex, loot)

    if not CPlayer.isInitialized(source) then return false end

    slotIndex = tonumber(slotIndex)
    if item and slotIndex and loot and isElement(loot) and isPlayerSlotAvailableForOrdering(source, item, slotIndex) then
        local itemDetails, itemCategory = getItemDetails(item)
        local itemAmountData = tonumber(loot:getData("Item:"..item)) or 0
        if itemDetails and itemCategory and itemAmountData > 0 then
            local itemAmount = 1
            playerInventorySlots[source].slots[slotIndex] = {
                item = item
            }
            loot:setData("Item:"..item, itemAmountData - itemAmount)
            setElementData(source, "Item:"..item, (tonumber(getElementData(source, "Item:"..item)) or 0) + itemAmount)
            if inventoryDatas[itemCategory].isAmmoCategory then
                triggerEvent("onPlayerRefreshWeaponAmmo", source, item)
            end
            return true
        end
    end
    triggerClientEvent(source, "Client:onSyncInventoryBuffer", source, playerInventorySlots[source])

end)

addEvent("onPlayerMoveItemInLoot", true)
addEventHandler("onPlayerMoveItemInLoot", root, function(item, slotIndex, loot)

    if not CPlayer.isInitialized(source) then return false end

    slotIndex = tonumber(slotIndex)
    if item and slotIndex and loot and isElement(loot) and playerInventorySlots[source].slots[slotIndex] then
        local itemDetails, itemCategory = getItemDetails(item)
        local itemAmountData = tonumber(getElementData(source, "Item:"..item)) or 0
        if itemDetails and itemCategory and itemAmountData > 0 then
            local itemAmount = 1
            local itemWeight = getItemWeight(item)
            local usedSlots = getElementUsedSlots(loot)
            local maxSlots = CInventory.fetchParentMaxSlots(loot)
            if (itemAmount*itemWeight) > (maxSlots - usedSlots) then
                triggerClientEvent(source, "onDisplayNotification", source, "Unfortunately, Loot is full!", {255, 80, 80, 255})
            else
                playerInventorySlots[source].slots[slotIndex] = nil
                loot:setData("Item:"..item, (tonumber(loot:getData("Item:"..item)) or 0) + itemAmount)
                setElementData(source, "Item:"..item, itemAmountData - itemAmount)
                if inventoryDatas[itemCategory].isAmmoCategory then
                    triggerEvent("onPlayerRefreshWeaponAmmo", source, item)
                end
                return true
            end
        end
    end
    triggerClientEvent(source, "Client:onSyncInventoryBuffer", source, playerInventorySlots[source])

end)


-----------------------------------------------------------------
--[[ Events: On Player Order/Equip/Unequip Item In Inventory ]]--
-----------------------------------------------------------------

addEvent("onPlayerOrderItemInInventory", true)
addEventHandler("onPlayerOrderItemInInventory", root, function(item, prevSlotIndex, newSlotIndex)

    if not CPlayer.isInitialized(source) then return false end

    prevSlotIndex, newSlotIndex = tonumber(prevSlotIndex), tonumber(newSlotIndex)
    if item and prevSlotIndex and newSlotIndex and isPlayerSlotAvailableForOrdering(source, item, newSlotIndex) then
        local itemDetails = getItemDetails(item)
        local itemAmountData = tonumber(getElementData(source, "Item:"..item)) or 0
        if itemDetails and itemAmountData > 0 then
            playerInventorySlots[source].slots[prevSlotIndex] = nil
            playerInventorySlots[source].slots[newSlotIndex] = {
                item = item
            }
        end
    end
    triggerClientEvent(source, "Client:onSyncInventoryBuffer", source, playerInventorySlots[source])

end)

addEvent("onPlayerEquipItemInInventory", true)
addEventHandler("onPlayerEquipItemInInventory", root, function(item, prevSlotIndex, reservedSlotIndex, newSlotIndex, loot)

    if not CPlayer.isInitialized(source) then return false end

    prevSlotIndex, reservedSlotIndex = tonumber(prevSlotIndex), tonumber(reservedSlotIndex)
    if item and prevSlotIndex and reservedSlotIndex and newSlotIndex and characterSlots[newSlotIndex] and loot and isElement(loot) and isPlayerSlotAvailableForEquipping(source, item, newSlotIndex) then
        local itemDetails = getItemDetails(item)
        local itemAmountData = tonumber(loot:getData("Item:"..item)) or 0
        if itemDetails and itemAmountData > 0 then
            if loot == source then
                playerInventorySlots[source].slots[prevSlotIndex] = {
                    item = item,
                    equipmentIndex = newSlotIndex,
                    translation = "equipment"
                }
                playerInventorySlots[source].slots[newSlotIndex] = item
                refreshPlayerEquipmentSlot(source, newSlotIndex)
            else
                local itemAmount = 1
                playerInventorySlots[source].slots[reservedSlotIndex] = {
                    item = item,
                    equipmentIndex = newSlotIndex,
                    translation = "equipment"
                }
                playerInventorySlots[source].slots[newSlotIndex] = item
                refreshPlayerEquipmentSlot(source, newSlotIndex)
                loot:setData("Item:"..item, itemAmountData - itemAmount)
                setElementData(source, "Item:"..item, (tonumber(getElementData(source, "Item:"..item)) or 0) + itemAmount)
                return true
            end
        end
    end
    triggerClientEvent(source, "Client:onSyncInventoryBuffer", source, playerInventorySlots[source])

end)

addEvent("onPlayerUnequipItemInInventory", true)
addEventHandler("onPlayerUnequipItemInInventory", root, function(item, prevSlotIndex, reservedSlotIndex, newSlotIndex, loot)

    if not CPlayer.isInitialized(source) then return false end

    reservedSlotIndex, newSlotIndex = tonumber(reservedSlotIndex), tonumber(newSlotIndex)
    if item and prevSlotIndex and characterSlots[prevSlotIndex] and reservedSlotIndex and newSlotIndex and loot and isElement(loot) and playerInventorySlots[source].slots[prevSlotIndex] then
        local itemDetails = getItemDetails(item)
        local itemAmountData = tonumber(getElementData(source, "Item:"..item)) or 0
        if itemDetails and itemAmountData > 0 then
            if loot == source then
                playerInventorySlots[source].slots[prevSlotIndex] = nil
                playerInventorySlots[source].slots[reservedSlotIndex] = nil
                refreshPlayerEquipmentSlot(source, prevSlotIndex)
                if isPlayerSlotAvailableForOrdering(source, item, newSlotIndex, true) then
                    playerInventorySlots[source].slots[newSlotIndex] = {
                        item = item
                    }
                end
            else
                local itemAmount = 1
                local itemWeight = getItemWeight(item)
                local usedSlots = getElementUsedSlots(loot)
                local maxSlots = CInventory.fetchParentMaxSlots(loot)
                if (itemAmount*itemWeight) > (maxSlots - usedSlots) then
                    triggerClientEvent(source, "onDisplayNotification", source, "Unfortunately, Loot is full!", {255, 80, 80, 255})
                else
                    playerInventorySlots[source].slots[prevSlotIndex] = nil
                    playerInventorySlots[source].slots[reservedSlotIndex] = nil
                    refreshPlayerEquipmentSlot(source, prevSlotIndex)
                    loot:setData("Item:"..item, (tonumber(loot:getData("Item:"..item)) or 0) + itemAmount)
                    setElementData(source, "Item:"..item, itemAmountData - itemAmount)
                    return true
                end
            end
        end
    end
    triggerClientEvent(source, "Client:onSyncInventoryBuffer", source, playerInventorySlots[source])

end)