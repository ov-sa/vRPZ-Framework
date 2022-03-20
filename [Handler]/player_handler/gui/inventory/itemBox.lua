

inventoryUI.updateBuffer = function(parent)
    if not parent or not imports.isElement(parent) or not inventoryUI.buffer[parent] then return false end
    inventoryUI.buffer[parent].inventory = {}
    inventoryUI.buffer[parent].itemBuffer = nil
    for i, j in imports.pairs(CInventory.CItems) do
        local itemCount = CInventory.fetchItemCount(parent, i)
        if itemCount > 0 then
            inventoryUI.buffer[parent].inventory[value.dataName] = itemCount
        end
    end
    inventoryUI.buffer[parent].sortedItems = nil
    return true
end


-------------------------------------------
--[[ Function: Attaches Inventory Item ]]--
-------------------------------------------

function attachInventoryItem(itemBox, item, category, prevSlotIndex, occupiedRowSlots, occupiedColumnSlots, prevPosX, prevPosY, prevWidth, prevHeight, offsetX, offsetY)

    if inventoryUI.attachedItem then return false end

    if itemBox == localPlayer then
        prevSlotIndex = (inventoryUI.ui.equipment.grids[prevSlotIndex] and prevSlotIndex) or tonumber(prevSlotIndex)
    else
        prevSlotIndex = tonumber(prevSlotIndex)
    end
    occupiedRowSlots = tonumber(occupiedRowSlots)
    occupiedColumnSlots = tonumber(occupiedColumnSlots)
    prevPosX = tonumber(prevPosX); prevPosY = tonumber(prevPosY)
    prevWidth = tonumber(prevWidth); prevHeight = tonumber(prevHeight)
    offsetX = tonumber(offsetX); offsetY = tonumber(offsetY)
    if not itemBox or not isElement(itemBox) or not item or not category or not prevSlotIndex or not occupiedRowSlots or not occupiedColumnSlots or not prevPosX or not prevPosY or not prevWidth or not prevHeight or not offsetX or not offsetY then return false end

    inventoryUI.attachedItem = {
        itemBox = itemBox,
        item = item,
        category = category,
        isEquippedItem = (inventoryUI.ui.equipment.grids[prevSlotIndex] and true) or false,
        prevSlotIndex = prevSlotIndex,
        occupiedRowSlots = occupiedRowSlots,
        occupiedColumnSlots = occupiedColumnSlots,
        prevPosX = prevPosX,
        prevPosY = prevPosY,
        prevWidth = prevWidth,
        prevHeight = prevHeight,
        offsetX = offsetX,
        offsetY = offsetY,
        sizeAnimTickCounter = getTickCount()
    }
    return true

end