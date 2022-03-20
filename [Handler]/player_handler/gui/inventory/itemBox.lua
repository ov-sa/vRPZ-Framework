------------------------------------
--[[ Function: Creates Item Box ]]--
------------------------------------

function createItemBox(startX, startY, templateIndex, inventoryParent, boxName)

    startX = tonumber(startX); startY = tonumber(startY); templateIndex = tonumber(templateIndex);
    if not startX or not startY or not templateIndex or not inventoryUI.gui.itemBox.templates[templateIndex] or not inventoryParent or not isElement(inventoryParent) then return false end

    if not inventoryUI.buffer[inventoryParent] then
        if not boxName then
            local lootType = inventoryParent:getData("Loot:Type")
            if lootType then
                boxName = inventoryParent:getData("Loot:Name")
            end
            if not boxName then
                boxName = "??"
            end
        end
        inventoryUI.buffer[inventoryParent] = {
            gui = {
                startX = startX,
                startY = startY,
                title = boxName,
                templateIndex = templateIndex,
                renderTarget = DxRenderTarget(inventoryUI.gui.itemBox.templates[templateIndex].contentWrapper.width, inventoryUI.gui.itemBox.templates[templateIndex].contentWrapper.height, true),
                scroller = {
                    percent = 0
                }
            },
            lootItems = {}
        }
        updateItemBox(inventoryParent)
    end
    return true

end


-------------------------------------
--[[ Function: Destroys Item Box ]]--
-------------------------------------

function destroyItemBox(inventoryParent)

    if not inventoryParent or not isElement(inventoryParent) then return false end

    if inventoryUI.buffer[inventoryParent] and inventoryUI.buffer[inventoryParent].gui then
        if inventoryUI.buffer[inventoryParent].gui.renderTarget and isElement(inventoryUI.buffer[inventoryParent].gui.renderTarget) then
            inventoryUI.buffer[inventoryParent].gui.renderTarget:destroy()
        end
    end
    inventoryUI.buffer[inventoryParent] = nil
    return true

end


-----------------------------------
--[[ Function: Clears Item Box ]]--
-----------------------------------

function clearItemBox(inventoryParent)

    if not inventoryParent or not isElement(inventoryParent) or not inventoryUI.buffer[inventoryParent] then return false end

    inventoryUI.buffer[inventoryParent].lootItems = {}
    inventoryUI.buffer[inventoryParent].__itemNameSlots = nil
    return true

end


------------------------------------
--[[ Function: Updates Item Box ]]--
------------------------------------

function updateItemBox(inventoryParent)

    if not inventoryParent or not isElement(inventoryParent) or not inventoryUI.buffer[inventoryParent] then return false end

    clearItemBox(inventoryParent)
    for itemType, itemDatas in pairs(inventoryDatas) do
        if itemDatas and type(itemDatas) == "table" then
            for index, value in ipairs(itemDatas) do
                local lootItemData = tonumber(inventoryParent:getData("Item:"..value.dataName)) or 0
                if lootItemData > 0 then
                    inventoryUI.buffer[inventoryParent].lootItems[value.dataName] = (tonumber(inventoryUI.buffer[inventoryParent].lootItems[value.dataName]) or 0) + lootItemData
                end
            end
        end
    end
    inventoryUI.buffer[inventoryParent].sortedCategories = nil
    return true

end


-------------------------------------------
--[[ Function: Attaches Inventory Item ]]--
-------------------------------------------

function attachInventoryItem(itemBox, item, category, prevSlotIndex, occupiedRowSlots, occupiedColumnSlots, prevPosX, prevPosY, prevWidth, prevHeight, offsetX, offsetY)

    if inventoryUI.attachedItem then return false end

    if itemBox == localPlayer then
        prevSlotIndex = (inventoryUI.gui.equipment.grids[prevSlotIndex] and prevSlotIndex) or tonumber(prevSlotIndex)
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
        isEquippedItem = (inventoryUI.gui.equipment.grids[prevSlotIndex] and true) or false,
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