------------------------------------
--[[ Function: Creates Item Box ]]--
------------------------------------

function createItemBox(parent, boxName)
    if not parent or not imports.isElement(parent) then return false end
    if not inventoryUI.buffer[parent] then
        if not boxName then
            local lootType = parent:getData("Loot:Type")
            if lootType then
                boxName = parent:getData("Loot:Name")
            end
            if not boxName then
                boxName = "??"
            end
        end
        inventoryUI.buffer[parent] = {
            title = boxName,
            templateIndex = templateIndex,
            renderTarget = DxRenderTarget(inventoryUI.ui.itemBox.templates[templateIndex].contentWrapper.width, inventoryUI.ui.itemBox.templates[templateIndex].contentWrapper.height, true),
            scroller = {
                percent = 0
            }
            inventory = {}
        }
        updateItemBox(parent)
    end
    return true
end



-----------------------------------
--[[ Function: Clears Item Box ]]--
-----------------------------------

function clearItemBox(parent)

    if not parent or not isElement(parent) or not inventoryUI.buffer[parent] then return false end

    inventoryUI.buffer[parent].inventory = {}
    inventoryUI.buffer[parent].__itemNameSlots = nil
    return true

end


------------------------------------
--[[ Function: Updates Item Box ]]--
------------------------------------

function updateItemBox(parent)

    if not parent or not isElement(parent) or not inventoryUI.buffer[parent] then return false end

    clearItemBox(parent)
    for itemType, itemDatas in pairs(inventoryDatas) do
        if itemDatas and type(itemDatas) == "table" then
            for index, value in ipairs(itemDatas) do
                local lootItemData = tonumber(parent:getData("Item:"..value.dataName)) or 0
                if lootItemData > 0 then
                    inventoryUI.buffer[parent].inventory[value.dataName] = (tonumber(inventoryUI.buffer[parent].inventory[value.dataName]) or 0) + lootItemData
                end
            end
        end
    end
    inventoryUI.buffer[parent].sortedCategories = nil
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