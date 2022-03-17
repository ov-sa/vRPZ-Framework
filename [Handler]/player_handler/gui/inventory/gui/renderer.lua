----------------------------------------------------------------
--[[ Resource: Player Handler
     Script: handlers: inventory: gui: renderer.lua
     Server: -
     Author: OvileAmriam
     Developer: -
     DOC: 18/12/2020 (OvileAmriam)
     Desc: Inventory Renderer ]]--
----------------------------------------------------------------


-------------------
--[[ Variables ]]--
-------------------

local iconTextures = {}
local iconDimensions = {}
local prevScrollState = false
local prevLMBClickState = false
local prevRMBClickState = false
local prevLMBDoubleClickTick = false
local prevScrollStreak = {state = false, tickCounter = false, streak = 1}
local sortedCategories = {
    "primary_weapon",
    "secondary_weapon",
    "Ammo",
    "special_weapon",
    "Medical",
    "Nutrition",
    "Backpack",
    "Helmet",
    "Armor",
    "Suit",
    "Tent",
    "Other",
    "Build",
    "Utility"
}


--------------------------------------
--[[ Function: Displays Inventory ]]--
--------------------------------------

function displayInventoryUI()

    if not isPlayerInitialized(localPlayer) or getPlayerHealth(localPlayer) <= 0 then return false end

    local isLMBClicked = false
    local isRMBClicked = false
    local isLMBDoubleClicked = false
    local isInventoryEnabled = isInventoryEnabled()
    local isItemAvailableForOrdering = false
    local isItemAvailableForDropping = false
    local isItemAvailableForEquipping = false
    local equipmentInformation = false
    local playerName = getElementData(localPlayer, "Character:name") or ""
    local playerMaxSlots = getElementMaxSlots(localPlayer)
    local playerUsedSlots = getElementUsedSlots(localPlayer)
    local equipmentInformationColor = inventoryCache.gui.equipment.description.fontColor
    local inventoryOpacityPercent = inventoryCache.gui.tranparencyAdjuster.minPercent + (1 - inventoryCache.gui.tranparencyAdjuster.minPercent)*inventoryCache.gui.tranparencyAdjuster.percent
    if not GuiElement.isMTAWindowActive() then
        if not prevLMBClickState then
            if getKeyState("mouse1") and not inventoryCache.attachedItemOnCursor then
                isLMBClicked = true
                prevLMBClickState = true
                if prevLMBDoubleClickTick then
                    if (getTickCount() - prevLMBDoubleClickTick) <= 200 then
                        isLMBDoubleClicked = true
                    end
                    prevLMBDoubleClickTick = false
                else
                    prevLMBDoubleClickTick = getTickCount()
                end
            end
        else
            if not getKeyState("mouse1") then
                prevLMBClickState = false
            end
        end
        if not prevRMBClickState then
            if getKeyState("mouse2") then
                isRMBClicked = true
                prevRMBClickState = true
            end
        else
            if not getKeyState("mouse2") then
                prevRMBClickState = false
            end
        end
    end

    --Draws Equipment
    dxSetRenderTarget()
    dxDrawImage(inventoryCache.gui.equipment.startX, inventoryCache.gui.equipment.startY - inventoryCache.gui.equipment.titleBar.height, inventoryCache.gui.equipment.titleBar.height, inventoryCache.gui.equipment.titleBar.height, inventoryCache.gui.equipment.titleBar.leftEdgePath, 0, 0, 0, tocolor(inventoryCache.gui.equipment.titleBar.bgColor[1], inventoryCache.gui.equipment.titleBar.bgColor[2], inventoryCache.gui.equipment.titleBar.bgColor[3], inventoryCache.gui.equipment.titleBar.bgColor[4]*inventoryOpacityPercent), inventoryCache.gui.postGUI)
    dxDrawRectangle(inventoryCache.gui.equipment.startX + inventoryCache.gui.equipment.titleBar.height, inventoryCache.gui.equipment.startY - inventoryCache.gui.equipment.titleBar.height, inventoryCache.gui.equipment.width - inventoryCache.gui.equipment.titleBar.height, inventoryCache.gui.equipment.titleBar.height, tocolor(inventoryCache.gui.equipment.titleBar.bgColor[1], inventoryCache.gui.equipment.titleBar.bgColor[2], inventoryCache.gui.equipment.titleBar.bgColor[3], inventoryCache.gui.equipment.titleBar.bgColor[4]*inventoryOpacityPercent), inventoryCache.gui.postGUI)
    dxDrawImage(inventoryCache.gui.equipment.startX, inventoryCache.gui.equipment.startY, inventoryCache.gui.equipment.width, inventoryCache.gui.equipment.height, inventoryCache.gui.equipment.bgPath, 0, 0, 0, tocolor(inventoryCache.gui.equipment.bgColor[1], inventoryCache.gui.equipment.bgColor[2], inventoryCache.gui.equipment.bgColor[3], inventoryCache.gui.equipment.bgColor[4]*inventoryOpacityPercent), inventoryCache.gui.postGUI)
    dxDrawBorderedText(inventoryCache.gui.equipment.titleBar.outlineWeight, inventoryCache.gui.equipment.titleBar.fontColor, string.upper(playerName.."'S EQUIPMENT   |   "..playerUsedSlots.."/"..playerMaxSlots), inventoryCache.gui.equipment.startX + inventoryCache.gui.equipment.titleBar.height, inventoryCache.gui.equipment.startY - inventoryCache.gui.equipment.titleBar.height, inventoryCache.gui.equipment.startX + inventoryCache.gui.equipment.width - inventoryCache.gui.equipment.titleBar.height, inventoryCache.gui.equipment.startY, tocolor(inventoryCache.gui.equipment.titleBar.fontColor[1], inventoryCache.gui.equipment.titleBar.fontColor[2], inventoryCache.gui.equipment.titleBar.fontColor[3], inventoryCache.gui.equipment.titleBar.fontColor[4]*inventoryOpacityPercent), 1, inventoryCache.gui.equipment.titleBar.font, "right", "center", true, false, inventoryCache.gui.postGUI)
    dxDrawRectangle(inventoryCache.gui.equipment.startX, inventoryCache.gui.equipment.startY, inventoryCache.gui.equipment.width, inventoryCache.gui.equipment.titleBar.dividerSize, tocolor(inventoryCache.gui.equipment.titleBar.dividerColor[1], inventoryCache.gui.equipment.titleBar.dividerColor[2], inventoryCache.gui.equipment.titleBar.dividerColor[3], inventoryCache.gui.equipment.titleBar.dividerColor[4]*inventoryOpacityPercent), inventoryCache.gui.postGUI)
    for i, j in pairs(inventoryCache.gui.equipment.grids) do
        local itemDetails, itemCategory = false, false
        if inventoryCache.inventorySlots and inventoryCache.inventorySlots.slots[i] then
            itemDetails, itemCategory = getItemDetails(inventoryCache.inventorySlots.slots[i])
        end
        dxDrawImage(j.startX - j.borderSize, j.startY - j.borderSize, j.height/2 + j.borderSize, j.height/2 + j.borderSize, inventoryCache.gui.equipment.slotTopLeftCurvedEdgeBGPath, 0, 0, 0, tocolor(j.borderColor[1], j.borderColor[2], j.borderColor[3], j.borderColor[4]*inventoryOpacityPercent), inventoryCache.gui.postGUI)
        dxDrawImage(j.startX + j.width - j.height/2, j.startY - j.borderSize, j.height/2 + j.borderSize, j.height/2 + j.borderSize, inventoryCache.gui.equipment.slotTopRightCurvedEdgeBGPath, 0, 0, 0, tocolor(j.borderColor[1], j.borderColor[2], j.borderColor[3], j.borderColor[4]*inventoryOpacityPercent), inventoryCache.gui.postGUI)
        dxDrawImage(j.startX - j.borderSize, j.startY + j.height - j.height/2, j.height/2 + j.borderSize, j.height/2 + j.borderSize, inventoryCache.gui.equipment.slotBottomLeftCurvedEdgeBGPath, 0, 0, 0, tocolor(j.borderColor[1], j.borderColor[2], j.borderColor[3], j.borderColor[4]*inventoryOpacityPercent), inventoryCache.gui.postGUI)
        dxDrawImage(j.startX + j.width - j.height/2, j.startY + j.height - j.height/2, j.height/2 + j.borderSize, j.height/2 + j.borderSize, inventoryCache.gui.equipment.slotBottomRightCurvedEdgeBGPath, 0, 0, 0, tocolor(j.borderColor[1], j.borderColor[2], j.borderColor[3], j.borderColor[4]*inventoryOpacityPercent), inventoryCache.gui.postGUI)
        if j.width > j.height then
            dxDrawRectangle(j.startX + j.height/2, j.startY - j.borderSize, j.width - j.height, j.height + (j.borderSize*2), tocolor(j.borderColor[1], j.borderColor[2], j.borderColor[3], j.borderColor[4]*inventoryOpacityPercent), inventoryCache.gui.postGUI)
        end
        dxDrawImage(j.startX, j.startY, j.height/2, j.height/2, inventoryCache.gui.equipment.slotTopLeftCurvedEdgeBGPath, 0, 0, 0, tocolor(j.bgColor[1], j.bgColor[2], j.bgColor[3], j.bgColor[4]*inventoryOpacityPercent), inventoryCache.gui.postGUI)
        dxDrawImage(j.startX + j.width - j.height/2, j.startY, j.height/2, j.height/2, inventoryCache.gui.equipment.slotTopRightCurvedEdgeBGPath, 0, 0, 0, tocolor(j.bgColor[1], j.bgColor[2], j.bgColor[3], j.bgColor[4]*inventoryOpacityPercent), inventoryCache.gui.postGUI)
        dxDrawImage(j.startX, j.startY + j.height - j.height/2, j.height/2, j.height/2, inventoryCache.gui.equipment.slotBottomLeftCurvedEdgeBGPath, 0, 0, 0, tocolor(j.bgColor[1], j.bgColor[2], j.bgColor[3], j.bgColor[4]*inventoryOpacityPercent), inventoryCache.gui.postGUI)
        dxDrawImage(j.startX + j.width - j.height/2, j.startY + j.height - j.height/2, j.height/2, j.height/2, inventoryCache.gui.equipment.slotBottomRightCurvedEdgeBGPath, 0, 0, 0, tocolor(j.bgColor[1], j.bgColor[2], j.bgColor[3], j.bgColor[4]*inventoryOpacityPercent), inventoryCache.gui.postGUI)
        if j.width > j.height then
            dxDrawRectangle(j.startX + j.height/2, j.startY, j.width - j.height, j.height, tocolor(j.bgColor[1], j.bgColor[2], j.bgColor[3], j.bgColor[4]*inventoryOpacityPercent), inventoryCache.gui.postGUI)
        end
        local isSlotHovered = isMouseOnPosition(j.startX, j.startY, j.width, j.height) and isInventoryEnabled
        if itemDetails and itemCategory then
            if iconTextures[itemDetails.iconPath] then
                if not inventoryCache.attachedItemOnCursor or (inventoryCache.attachedItemOnCursor.itemBox ~= localPlayer) or (inventoryCache.attachedItemOnCursor.prevSlotIndex ~= i) then                
                    dxDrawImage(j.startX + (j.paddingX/2), j.startY + (j.paddingY/2), j.width - j.paddingX, j.height - j.paddingY, iconTextures[itemDetails.iconPath], 0, 0, 0, tocolor(255, 255, 255, 255*inventoryOpacityPercent), inventoryCache.gui.postGUI)
                end
                if isSlotHovered then
                    equipmentInformation = itemDetails.itemName..":\n"..itemDetails.description
                    if isLMBClicked then
                        local horizontalSlotsToOccupy = math.max(1, tonumber(itemDetails.itemHorizontalSlots) or 1)
                        local verticalSlotsToOccupy = math.max(1, tonumber(itemDetails.itemVerticalSlots) or 1)
                        local cursor_offsetX, cursor_offsetY = getAbsoluteCursorPosition()
                        local prev_offsetX, prev_offsetY = j.startX + (j.paddingX/2), j.startY + (j.paddingY/2)
                        local prev_width, prev_height = j.width - j.paddingX, j.height - j.paddingY
                        local attached_offsetX, attached_offsetY = cursor_offsetX - prev_offsetX, cursor_offsetY - prev_offsetY
                        attachInventoryItem(localPlayer, itemDetails.dataName, itemCategory, i, horizontalSlotsToOccupy, verticalSlotsToOccupy, prev_offsetX, prev_offsetY, prev_width, prev_height, attached_offsetX, attached_offsetY)
                    end
                end
            end
        else
            if j.bgImage then
                local isPlaceHolderToBeShown = true
                local placeHolderColor = {255, 255, 255, 255}
                if inventoryCache.attachedItemOnCursor then
                    if not inventoryCache.attachedItemOnCursor.animTickCounter then
                        if isSlotHovered and isInventoryEnabled then
                            local isSlotAvailable, slotIndex = isPlayerSlotAvailableForEquipping(localPlayer, inventoryCache.attachedItemOnCursor.item, i, inventoryCache.attachedItemOnCursor.itemBox == localPlayer)
                            if isSlotAvailable then
                                isItemAvailableForEquipping = {
                                    slotIndex = i,
                                    reservedSlot = slotIndex,
                                    offsetX = j.startX + (j.paddingX/2),
                                    offsetY = j.startY + (j.paddingY/2),
                                    loot = inventoryCache.attachedItemOnCursor.itemBox
                                }
                            end
                            placeHolderColor = (isSlotAvailable and j.availableBGColor) or j.unavailableBGColor
                        end
                    else
                        if inventoryCache.attachedItemOnCursor.releaseType and inventoryCache.attachedItemOnCursor.releaseType == "equipping" and inventoryCache.attachedItemOnCursor.prevSlotIndex == i then
                            isPlaceHolderToBeShown = false
                        end
                    end
                end
                if isPlaceHolderToBeShown then
                    dxDrawImage(j.startX, j.startY, j.width, j.height, j.bgImage, 0, 0, 0, tocolor(placeHolderColor[1], placeHolderColor[2], placeHolderColor[3], placeHolderColor[4]*inventoryOpacityPercent), inventoryCache.gui.postGUI)	
                end
            end
        end
    end

    --Draws ItemBoxes
    for i, j in pairs(itemBoxesCache) do
        if i and isElement(i) and j then
            local maxSlots = getElementMaxSlots(i)
            local usedSlots = getElementUsedSlots(i)
            local sortedItems = {}
            local template = inventoryCache.gui.itemBox.templates[j.gui.templateIndex]
            if j.gui.templateIndex == 1 then
                if not j.sortedCategories then
                    j.sortedCategories = {}
                    for k, v in pairs(inventoryDatas) do
                        for key, value in ipairs(v) do
                            if j.lootItems[value.dataName] then
                                for x = 1, j.lootItems[value.dataName], 1 do
                                    table.insert(j.sortedCategories, {item = value.dataName, itemValue = 1})
                                end
                            end
                        end
                    end
                end
                sortedItems = j.sortedCategories
                dxDrawImage(j.gui.startX - template.borderSize, j.gui.startY - template.borderSize, template.height/10 + template.borderSize, template.height/10 + template.borderSize, inventoryCache.gui.equipment.slotTopLeftCurvedEdgeBGPath, 0, 0, 0, tocolor(template.borderColor[1], template.borderColor[2], template.borderColor[3], template.borderColor[4]*inventoryOpacityPercent), inventoryCache.gui.postGUI)
                dxDrawImage(j.gui.startX + template.width - template.height/10, j.gui.startY - template.borderSize, template.height/10 + template.borderSize, template.height/10 + template.borderSize, inventoryCache.gui.equipment.slotTopRightCurvedEdgeBGPath, 0, 0, 0, tocolor(template.borderColor[1], template.borderColor[2], template.borderColor[3], template.borderColor[4]*inventoryOpacityPercent), inventoryCache.gui.postGUI)
                dxDrawImage(j.gui.startX - template.borderSize, j.gui.startY + template.height - template.height/10, template.height/10 + template.borderSize, template.height/10 + template.borderSize, inventoryCache.gui.equipment.slotBottomLeftCurvedEdgeBGPath, 0, 0, 0, tocolor(template.borderColor[1], template.borderColor[2], template.borderColor[3], template.borderColor[4]*inventoryOpacityPercent), inventoryCache.gui.postGUI)
                dxDrawImage(j.gui.startX + template.width - template.height/10, j.gui.startY + template.height - template.height/10, template.height/10 + template.borderSize, template.height/10 + template.borderSize, inventoryCache.gui.equipment.slotBottomRightCurvedEdgeBGPath, 0, 0, 0, tocolor(template.borderColor[1], template.borderColor[2], template.borderColor[3], template.borderColor[4]*inventoryOpacityPercent), inventoryCache.gui.postGUI)
                dxDrawRectangle(j.gui.startX - template.borderSize, j.gui.startY + template.height/10, template.height/10 + template.borderSize, template.height - template.height/5, tocolor(template.borderColor[1], template.borderColor[2], template.borderColor[3], template.borderColor[4]*inventoryOpacityPercent), inventoryCache.gui.postGUI)
                dxDrawRectangle(j.gui.startX + template.width - template.height/10, j.gui.startY + template.height/10, template.height/10 + template.borderSize, template.height - template.height/5, tocolor(template.borderColor[1], template.borderColor[2], template.borderColor[3], template.borderColor[4]*inventoryOpacityPercent), inventoryCache.gui.postGUI)
                dxDrawRectangle(j.gui.startX + template.height/10, j.gui.startY - template.borderSize, template.width - template.height/5, template.height + (template.borderSize*2), tocolor(template.borderColor[1], template.borderColor[2], template.borderColor[3], template.borderColor[4]*inventoryOpacityPercent), inventoryCache.gui.postGUI)
                dxDrawImage(j.gui.startX, j.gui.startY, template.height/10, template.height/10, inventoryCache.gui.equipment.slotTopLeftCurvedEdgeBGPath, 0, 0, 0, tocolor(template.bgColor[1], template.bgColor[2], template.bgColor[3], template.bgColor[4]*inventoryOpacityPercent), inventoryCache.gui.postGUI)
                dxDrawImage(j.gui.startX + template.width - template.height/10, j.gui.startY, template.height/10, template.height/10, inventoryCache.gui.equipment.slotTopRightCurvedEdgeBGPath, 0, 0, 0, tocolor(template.bgColor[1], template.bgColor[2], template.bgColor[3], template.bgColor[4]*inventoryOpacityPercent), inventoryCache.gui.postGUI)
                dxDrawImage(j.gui.startX, j.gui.startY + template.height - template.height/10, template.height/10, template.height/10, inventoryCache.gui.equipment.slotBottomLeftCurvedEdgeBGPath, 0, 0, 0, tocolor(template.bgColor[1], template.bgColor[2], template.bgColor[3], template.bgColor[4]*inventoryOpacityPercent), inventoryCache.gui.postGUI)
                dxDrawImage(j.gui.startX + template.width - template.height/10, j.gui.startY + template.height - template.height/10, template.height/10, template.height/10, inventoryCache.gui.equipment.slotBottomRightCurvedEdgeBGPath, 0, 0, 0, tocolor(template.bgColor[1], template.bgColor[2], template.bgColor[3], template.bgColor[4]*inventoryOpacityPercent), inventoryCache.gui.postGUI)
                dxDrawRectangle(j.gui.startX, j.gui.startY + template.height/10, template.height/10, template.height - template.height/5, tocolor(template.bgColor[1], template.bgColor[2], template.bgColor[3], template.bgColor[4]*inventoryOpacityPercent), inventoryCache.gui.postGUI)
                dxDrawRectangle(j.gui.startX + template.width - template.height/10, j.gui.startY + template.height/10, template.height/10, template.height - template.height/5, tocolor(template.bgColor[1], template.bgColor[2], template.bgColor[3], template.bgColor[4]*inventoryOpacityPercent), inventoryCache.gui.postGUI)
                dxDrawRectangle(j.gui.startX + template.height/10, j.gui.startY, template.width - template.height/5, template.height, tocolor(template.bgColor[1], template.bgColor[2], template.bgColor[3], template.bgColor[4]*inventoryOpacityPercent), inventoryCache.gui.postGUI)
                dxSetRenderTarget(j.gui.renderTarget, true)
                local totalSlots, assignedItems, occupiedSlots = math.min(maxSlots, math.max(maxSlots, #sortedItems)), {}, getPlayerOccupiedSlots(localPlayer) or {}
                local totalContentHeight = template.contentWrapper.padding + template.contentWrapper.itemGrid.padding + (math.max(0, math.ceil(maxSlots/maximumInventoryRowSlots) - 1)*(template.contentWrapper.itemGrid.slot.size + template.contentWrapper.itemGrid.padding)) + template.contentWrapper.itemGrid.slot.size + template.contentWrapper.itemGrid.padding
                local exceededContentHeight =  totalContentHeight - template.contentWrapper.height
                dxSetRenderTarget(j.gui.renderTarget, true)
                if inventoryCache.inventorySlots then
                    for k, v in pairs(inventoryCache.inventorySlots.slots) do
                        if tonumber(k) then
                            local isSlotToBeDrawn = true
                            if v.movementType and v.movementType ~= "inventory" then
                                isSlotToBeDrawn = false
                            end
                            if not inventoryCache.isSlotsUpdated then
                                if v.movementType == "equipment" and v.isAutoReserved then
                                    if (tonumber(j.lootItems[v.item]) or 0) <= 0 then
                                        if not sortedItems["__"..v.item] then
                                            table.insert(sortedItems, {item = v.item, itemValue = 1})
                                            sortedItems["__"..v.item] = true
                                        end
                                    end
                                end
                            end
                            if isSlotToBeDrawn then
                                if v.movementType then
                                    local itemDetails, itemCategory = getItemDetails(v.item)
                                    if itemDetails and itemCategory and iconTextures[itemDetails.iconPath] then
                                        local slotIndex = k
                                        if slotIndex then
                                            local horizontalSlotsToOccupy = math.max(1, tonumber(itemDetails.itemHorizontalSlots) or 1)
                                            local verticalSlotsToOccupy = math.max(1, tonumber(itemDetails.itemVerticalSlots) or 1)
                                            local iconWidth, iconHeight = 0, template.contentWrapper.itemGrid.slot.size*verticalSlotsToOccupy
                                            local originalWidth, originalHeight = iconDimensions[itemDetails.iconPath].width, iconDimensions[itemDetails.iconPath].height
                                            iconWidth = (originalWidth / originalHeight)*iconHeight
                                            local slot_row = math.ceil(slotIndex/maximumInventoryRowSlots)
                                            local slot_column = slotIndex - (math.max(0, slot_row - 1)*maximumInventoryRowSlots)
                                            local slot_offsetX, slot_offsetY = template.contentWrapper.padding + template.contentWrapper.itemGrid.padding + (math.max(0, slot_column - 1)*(template.contentWrapper.itemGrid.slot.size + template.contentWrapper.itemGrid.padding)), template.contentWrapper.padding + template.contentWrapper.itemGrid.padding + (math.max(0, slot_row - 1)*(template.contentWrapper.itemGrid.slot.size + template.contentWrapper.itemGrid.padding)) - (exceededContentHeight*j.gui.scroller.percent*0.01)
                                            local slotWidth, slotHeight = horizontalSlotsToOccupy*template.contentWrapper.itemGrid.slot.size + ((horizontalSlotsToOccupy - 1)*template.contentWrapper.itemGrid.padding), verticalSlotsToOccupy*template.contentWrapper.itemGrid.slot.size + ((verticalSlotsToOccupy - 1)*template.contentWrapper.itemGrid.padding)
                                            if not inventoryCache.attachedItemOnCursor or (inventoryCache.attachedItemOnCursor.itemBox ~= i) or (inventoryCache.attachedItemOnCursor.prevSlotIndex ~= slotIndex) then
                                                dxDrawImage(slot_offsetX + ((slotWidth - iconWidth)/2), slot_offsetY + ((slotHeight - iconHeight)/2), iconWidth, iconHeight, iconTextures[itemDetails.iconPath], 0, 0, 0, tocolor(255, 255, 255, 255), false)
                                            end
                                        end
                                    end
                                else
                                    for m, n in ipairs(sortedItems) do
                                        if v.item == n.item then
                                            if not assignedItems[m] then
                                                assignedItems[m] = k
                                                break
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
                for k, v in ipairs(sortedItems) do
                    local itemDetails, itemCategory = getItemDetails(v.item)
                    if itemDetails and itemCategory and iconTextures[itemDetails.iconPath] then
                        local slotIndex = assignedItems[k] or false
                        if slotIndex then
                            local horizontalSlotsToOccupy = math.max(1, tonumber(itemDetails.itemHorizontalSlots) or 1)
                            local verticalSlotsToOccupy = math.max(1, tonumber(itemDetails.itemVerticalSlots) or 1)
                            local iconWidth, iconHeight = 0, template.contentWrapper.itemGrid.slot.size*verticalSlotsToOccupy
                            local originalWidth, originalHeight = iconDimensions[itemDetails.iconPath].width, iconDimensions[itemDetails.iconPath].height
                            iconWidth = (originalWidth / originalHeight)*iconHeight
                            local slot_row = math.ceil(slotIndex/maximumInventoryRowSlots)
                            local slot_column = slotIndex - (math.max(0, slot_row - 1)*maximumInventoryRowSlots)
                            local slot_offsetX, slot_offsetY = template.contentWrapper.padding + template.contentWrapper.itemGrid.padding + (math.max(0, slot_column - 1)*(template.contentWrapper.itemGrid.slot.size + template.contentWrapper.itemGrid.padding)), template.contentWrapper.padding + template.contentWrapper.itemGrid.padding + (math.max(0, slot_row - 1)*(template.contentWrapper.itemGrid.slot.size + template.contentWrapper.itemGrid.padding)) - (exceededContentHeight*j.gui.scroller.percent*0.01)
                            local slotWidth, slotHeight = horizontalSlotsToOccupy*template.contentWrapper.itemGrid.slot.size + ((horizontalSlotsToOccupy - 1)*template.contentWrapper.itemGrid.padding), verticalSlotsToOccupy*template.contentWrapper.itemGrid.slot.size + ((verticalSlotsToOccupy - 1)*template.contentWrapper.itemGrid.padding)
                            local isItemToBeDrawn = true
                            if inventoryCache.attachedItemOnCursor and (inventoryCache.attachedItemOnCursor.itemBox == i) and (inventoryCache.attachedItemOnCursor.prevSlotIndex == slotIndex) then 
                                if not inventoryCache.attachedItemOnCursor.reservedSlotType then
                                    isItemToBeDrawn = false
                                end
                            end
                            if isItemToBeDrawn then
                                dxDrawImage(slot_offsetX + ((slotWidth - iconWidth)/2), slot_offsetY + ((slotHeight - iconHeight)/2), iconWidth, iconHeight, iconTextures[itemDetails.iconPath], 0, 0, 0, tocolor(255, 255, 255, 255), false)
                            end
                            if not inventoryCache.attachedItemOnCursor and isInventoryEnabled then
                                if (slot_offsetY >= 0) and ((slot_offsetY + slotHeight) <= template.contentWrapper.height) then
                                    local isSlotHovered = isMouseOnPosition(j.gui.startX + template.contentWrapper.startX + slot_offsetX, j.gui.startY + template.contentWrapper.startY + slot_offsetY, slotWidth, slotHeight)
                                    if isSlotHovered then
                                        equipmentInformation = itemDetails.itemName..":\n"..itemDetails.description
                                        if isLMBClicked then
                                            local cursor_offsetX, cursor_offsetY = getAbsoluteCursorPosition()
                                            local prev_offsetX, prev_offsetY = j.gui.startX + template.contentWrapper.startX + slot_offsetX, j.gui.startY + template.contentWrapper.startY + slot_offsetY
                                            local prev_width, prev_height = iconWidth, iconHeight
                                            local attached_offsetX, attached_offsetY = cursor_offsetX - prev_offsetX, cursor_offsetY - prev_offsetY
                                            attachInventoryItem(i, v.item, itemCategory, slotIndex, horizontalSlotsToOccupy, verticalSlotsToOccupy, prev_offsetX, prev_offsetY, prev_width, prev_height, attached_offsetX, attached_offsetY)
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
                for k = 1, totalSlots, 1 do
                    if not occupiedSlots[k] then
                        local slot_row = math.ceil(k/maximumInventoryRowSlots)
                        local slot_column = k - (math.max(0, slot_row - 1)*maximumInventoryRowSlots)
                        local slot_offsetX, slot_offsetY = template.contentWrapper.padding + template.contentWrapper.itemGrid.padding + (math.max(0, slot_column - 1)*(template.contentWrapper.itemGrid.slot.size + template.contentWrapper.itemGrid.padding)), template.contentWrapper.padding + template.contentWrapper.itemGrid.padding + (math.max(0, slot_row - 1)*(template.contentWrapper.itemGrid.slot.size + template.contentWrapper.itemGrid.padding)) - (exceededContentHeight*j.gui.scroller.percent*0.01)
                        local isSlotToBeDrawn = true
                        if inventoryCache.attachedItemOnCursor and inventoryCache.attachedItemOnCursor.itemBox and isElement(inventoryCache.attachedItemOnCursor.itemBox) and inventoryCache.attachedItemOnCursor.itemBox ~= localPlayer and inventoryCache.attachedItemOnCursor.animTickCounter and inventoryCache.attachedItemOnCursor.releaseType and inventoryCache.attachedItemOnCursor.releaseType == "ordering" then
                            local slotIndexesToOccupy = {}
                            for m = inventoryCache.attachedItemOnCursor.prevSlotIndex, inventoryCache.attachedItemOnCursor.prevSlotIndex + (inventoryCache.attachedItemOnCursor.occupiedRowSlots - 1), 1 do
                                if m <= totalSlots then
                                    for x = 1, inventoryCache.attachedItemOnCursor.occupiedColumnSlots, 1 do
                                        local succeedingColumnIndex = m + (maximumInventoryRowSlots*(x - 1))
                                        if succeedingColumnIndex <= totalSlots then
                                            if k == succeedingColumnIndex then
                                                isSlotToBeDrawn = false
                                                break
                                            end
                                        end
                                    end
                                end
                            end
                        end
                        if isSlotToBeDrawn then
                            dxDrawRectangle(slot_offsetX, slot_offsetY, template.contentWrapper.itemGrid.slot.size, template.contentWrapper.itemGrid.slot.size, tocolor(unpack(template.contentWrapper.itemGrid.slot.bgColor)), false)
                        end
                    else
                        if inventoryCache.inventorySlots.slots[k] and inventoryCache.inventorySlots.slots[k].movementType and inventoryCache.inventorySlots.slots[k].movementType == "equipment" then
                            local itemDetails, itemCategory = getItemDetails(inventoryCache.inventorySlots.slots[k].item)
                            if itemDetails and itemCategory then
                                local horizontalSlotsToOccupy = math.max(1, tonumber(itemDetails.itemHorizontalSlots) or 1)
                                local verticalSlotsToOccupy = math.max(1, tonumber(itemDetails.itemVerticalSlots) or 1)
                                local slot_row = math.ceil(k/maximumInventoryRowSlots)
                                local slot_column = k - (math.max(0, slot_row - 1)*maximumInventoryRowSlots)
                                local slot_offsetX, slot_offsetY = template.contentWrapper.padding + template.contentWrapper.itemGrid.padding + (math.max(0, slot_column - 1)*(template.contentWrapper.itemGrid.slot.size + template.contentWrapper.itemGrid.padding)), template.contentWrapper.padding + template.contentWrapper.itemGrid.padding + (math.max(0, slot_row - 1)*(template.contentWrapper.itemGrid.slot.size + template.contentWrapper.itemGrid.padding)) - (exceededContentHeight*j.gui.scroller.percent*0.01)
                                local slotWidth, slotHeight = horizontalSlotsToOccupy*template.contentWrapper.itemGrid.slot.size + ((horizontalSlotsToOccupy - 1)*template.contentWrapper.itemGrid.padding), verticalSlotsToOccupy*template.contentWrapper.itemGrid.slot.size + ((verticalSlotsToOccupy - 1)*template.contentWrapper.itemGrid.padding)
                                local equippedIndex = inventoryCache.inventorySlots.slots[k].equipmentIndex
                                if not equippedIndex then
                                    for m, n in pairs(inventoryCache.gui.equipment.grids) do
                                        if inventoryCache.inventorySlots.slots[m] and inventoryCache.inventorySlots.slots[m] == inventoryCache.inventorySlots.slots[k].item then
                                            equippedIndex = m
                                            break
                                        end
                                    end
                                end
                                if equippedIndex then
                                    dxDrawText(string.upper("EQUIPPED: "..equippedIndex), slot_offsetX, slot_offsetY, slot_offsetX + slotWidth, slot_offsetY + slotHeight, tocolor(unpack(template.contentWrapper.itemGrid.slot.fontColor)), 1, template.contentWrapper.itemGrid.slot.font, "right", "bottom", true, true, false)
                                end
                            end
                        end
                    end
                end
                if inventoryCache.attachedItemOnCursor and not inventoryCache.attachedItemOnCursor.animTickCounter then
                    for k = 1, totalSlots, 1 do
                        if not occupiedSlots[k] then
                            local slot_row = math.ceil(k/maximumInventoryRowSlots)
                            local slot_column = k - (math.max(0, slot_row - 1)*maximumInventoryRowSlots)
                            local slot_offsetX, slot_offsetY = template.contentWrapper.padding + template.contentWrapper.itemGrid.padding + (math.max(0, slot_column - 1)*(template.contentWrapper.itemGrid.slot.size + template.contentWrapper.itemGrid.padding)), template.contentWrapper.padding + template.contentWrapper.itemGrid.padding + (math.max(0, slot_row - 1)*(template.contentWrapper.itemGrid.slot.size + template.contentWrapper.itemGrid.padding)) - (exceededContentHeight*j.gui.scroller.percent*0.01)
                            if (slot_offsetY >= 0) and ((slot_offsetY + template.contentWrapper.itemGrid.slot.size) <= template.contentWrapper.height) then
                                local isSlotHovered = isMouseOnPosition(j.gui.startX + template.contentWrapper.startX + slot_offsetX, j.gui.startY + template.contentWrapper.startY + slot_offsetY, template.contentWrapper.itemGrid.slot.size, template.contentWrapper.itemGrid.slot.size)
                                if isSlotHovered then
                                    local isSlotAvailable = isPlayerSlotAvailableForOrdering(localPlayer, inventoryCache.attachedItemOnCursor.item, k, inventoryCache.attachedItemOnCursor.isEquippedItem)
                                    if isSlotAvailable then
                                        isItemAvailableForOrdering = {
                                            slotIndex = k,
                                            offsetX = slot_offsetX,
                                            offsetY = slot_offsetY
                                        }
                                    end
                                    for m = k, k + (inventoryCache.attachedItemOnCursor.occupiedRowSlots - 1), 1 do
                                        for x = 1, inventoryCache.attachedItemOnCursor.occupiedColumnSlots, 1 do
                                            local succeedingColumnIndex = m + (maximumInventoryRowSlots*(x - 1))
                                            if succeedingColumnIndex <= totalSlots and not occupiedSlots[succeedingColumnIndex] then
                                                local _slot_row = math.ceil(succeedingColumnIndex/maximumInventoryRowSlots)
                                                local _slot_column = succeedingColumnIndex - (math.max(0, _slot_row - 1)*maximumInventoryRowSlots)
                                                local _slot_offsetX, _slot_offsetY = template.contentWrapper.padding + template.contentWrapper.itemGrid.padding + (math.max(0, _slot_column - 1)*(template.contentWrapper.itemGrid.slot.size + template.contentWrapper.itemGrid.padding)), template.contentWrapper.padding + template.contentWrapper.itemGrid.padding + (math.max(0, _slot_row - 1)*(template.contentWrapper.itemGrid.slot.size + template.contentWrapper.itemGrid.padding)) - (exceededContentHeight*j.gui.scroller.percent*0.01)
                                                if _slot_column >= slot_column then
                                                    dxDrawRectangle(_slot_offsetX, _slot_offsetY, template.contentWrapper.itemGrid.slot.size, template.contentWrapper.itemGrid.slot.size, tocolor(unpack((isSlotAvailable and template.contentWrapper.itemGrid.slot.availableBGColor) or template.contentWrapper.itemGrid.slot.unavailableBGColor)), false)
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
                dxSetRenderTarget()
                dxDrawImage(j.gui.startX + template.contentWrapper.startX, j.gui.startY + template.contentWrapper.startY, template.contentWrapper.width, template.contentWrapper.height, j.gui.renderTarget, 0, 0, 0, tocolor(255, 255, 255, 255*inventoryOpacityPercent), inventoryCache.gui.postGUI)
                if exceededContentHeight > 0 then
                    local scrollOverlayStartX, scrollOverlayStartY = j.gui.startX + template.scrollBar.overlay.startX, j.gui.startY + template.scrollBar.overlay.startY
                    local scrollOverlayWidth, scrollOverlayHeight =  template.scrollBar.overlay.width, template.scrollBar.overlay.height
                    dxDrawRectangle(scrollOverlayStartX, scrollOverlayStartY, scrollOverlayWidth, scrollOverlayHeight, tocolor(template.scrollBar.overlay.bgColor[1], template.scrollBar.overlay.bgColor[2], template.scrollBar.overlay.bgColor[3], template.scrollBar.overlay.bgColor[4]*inventoryOpacityPercent), inventoryCache.gui.postGUI)
                    local scrollBarWidth, scrollBarHeight =  scrollOverlayWidth, template.scrollBar.bar.height
                    local scrollBarStartX, scrollBarStartY = scrollOverlayStartX, scrollOverlayStartY + ((scrollOverlayHeight - scrollBarHeight)*j.gui.scroller.percent*0.01)
                    dxDrawRectangle(scrollBarStartX, scrollBarStartY, scrollBarWidth, scrollBarHeight, tocolor(template.scrollBar.bar.bgColor[1], template.scrollBar.bar.bgColor[2], template.scrollBar.bar.bgColor[3], template.scrollBar.bar.bgColor[4]*inventoryOpacityPercent), inventoryCache.gui.postGUI)
                    if prevScrollState and (not inventoryCache.attachedItemOnCursor or not inventoryCache.attachedItemOnCursor.animTickCounter) and (isMouseOnPosition(scrollOverlayStartX, scrollOverlayStartY, scrollOverlayWidth, scrollOverlayHeight) or isMouseOnPosition(j.gui.startX + template.contentWrapper.startX, j.gui.startY + template.contentWrapper.startY, template.contentWrapper.width, template.contentWrapper.height)) then
                        if prevScrollState == "up" then
                            if j.gui.scroller.percent <= 0 then
                                j.gui.scroller.percent = 0
                            else
                                if exceededContentHeight < template.contentWrapper.height then
                                    j.gui.scroller.percent = j.gui.scroller.percent - (10*prevScrollStreak.streak)
                                else
                                    j.gui.scroller.percent = j.gui.scroller.percent - (1*prevScrollStreak.streak)
                                end
                                if j.gui.scroller.percent <= 0 then j.gui.scroller.percent = 0 end
                            end
                        elseif prevScrollState == "down" then
                            if j.gui.scroller.percent >= 100 then
                                j.gui.scroller.percent = 100
                            else
                                if exceededContentHeight < template.contentWrapper.height then
                                    j.gui.scroller.percent = j.gui.scroller.percent + (10*prevScrollStreak.streak)
                                else
                                    j.gui.scroller.percent = j.gui.scroller.percent + (1*prevScrollStreak.streak)
                                end
                                if j.gui.scroller.percent >= 100 then j.gui.scroller.percent = 100 end
                            end
                        end
                        prevScrollState = false
                    end
                end
            else
                if not j.sortedCategories then
                    j.sortedCategories = {}
                    for k, v in ipairs(sortedCategories) do
                        if inventoryDatas[v] then
                            for key, value in ipairs(inventoryDatas[v]) do
                                if j.lootItems[value.dataName] then
                                    table.insert(j.sortedCategories, {item = value.dataName, itemValue = j.lootItems[value.dataName]})
                                end
                            end
                        end
                    end
                    for k, v in pairs(inventoryDatas) do
                        local isSortedCategory = false
                        for m, n in ipairs(sortedCategories) do
                            if k == n then
                                isSortedCategory = true
                                break
                            end
                        end
                        if not isSortedCategory then
                            for key, value in ipairs(v) do
                                if j.lootItems[value.dataName] then
                                    table.insert(j.sortedCategories, {item = value.dataName, itemValue = j.lootItems[value.dataName]})
                                end
                            end
                        end
                    end
                end
                sortedItems = j.sortedCategories
                dxDrawImage(j.gui.startX + template.width - inventoryCache.gui.equipment.titleBar.height, j.gui.startY - inventoryCache.gui.equipment.titleBar.height, inventoryCache.gui.equipment.titleBar.height, inventoryCache.gui.equipment.titleBar.height, inventoryCache.gui.equipment.titleBar.rightEdgePath, 0, 0, 0, tocolor(inventoryCache.gui.equipment.titleBar.bgColor[1], inventoryCache.gui.equipment.titleBar.bgColor[2], inventoryCache.gui.equipment.titleBar.bgColor[3], inventoryCache.gui.equipment.titleBar.bgColor[4]*inventoryOpacityPercent), inventoryCache.gui.postGUI)
                dxDrawRectangle(j.gui.startX, j.gui.startY - inventoryCache.gui.equipment.titleBar.height, template.width - inventoryCache.gui.equipment.titleBar.height, inventoryCache.gui.equipment.titleBar.height, tocolor(inventoryCache.gui.equipment.titleBar.bgColor[1], inventoryCache.gui.equipment.titleBar.bgColor[2], inventoryCache.gui.equipment.titleBar.bgColor[3], inventoryCache.gui.equipment.titleBar.bgColor[4]*inventoryOpacityPercent), inventoryCache.gui.postGUI)
                dxDrawBorderedText(inventoryCache.gui.equipment.titleBar.outlineWeight, inventoryCache.gui.equipment.titleBar.fontColor, string.upper(j.gui.title.."   |   "..usedSlots.."/"..maxSlots), j.gui.startX + inventoryCache.gui.equipment.titleBar.height, j.gui.startY - inventoryCache.gui.equipment.titleBar.height, inventoryCache.gui.equipment.startX + template.width - inventoryCache.gui.equipment.titleBar.height, inventoryCache.gui.equipment.startY, tocolor(inventoryCache.gui.equipment.titleBar.fontColor[1], inventoryCache.gui.equipment.titleBar.fontColor[2], inventoryCache.gui.equipment.titleBar.fontColor[3], inventoryCache.gui.equipment.titleBar.fontColor[4]*inventoryOpacityPercent), 1, inventoryCache.gui.equipment.titleBar.font, "left", "center", true, false, inventoryCache.gui.postGUI)
                dxDrawImage(j.gui.startX, j.gui.startY + template.height, inventoryCache.gui.equipment.titleBar.height, inventoryCache.gui.equipment.titleBar.height, inventoryCache.gui.equipment.titleBar.invertedEdgePath, 0, 0, 0, tocolor(inventoryCache.gui.equipment.titleBar.bgColor[1], inventoryCache.gui.equipment.titleBar.bgColor[2], inventoryCache.gui.equipment.titleBar.bgColor[3], inventoryCache.gui.equipment.titleBar.bgColor[4]*inventoryOpacityPercent), inventoryCache.gui.postGUI)
                dxDrawRectangle(j.gui.startX + inventoryCache.gui.equipment.titleBar.height, j.gui.startY + template.height, template.width - inventoryCache.gui.equipment.titleBar.height, inventoryCache.gui.equipment.titleBar.height, tocolor(inventoryCache.gui.equipment.titleBar.bgColor[1], inventoryCache.gui.equipment.titleBar.bgColor[2], inventoryCache.gui.equipment.titleBar.bgColor[3], inventoryCache.gui.equipment.titleBar.bgColor[4]*inventoryOpacityPercent), inventoryCache.gui.postGUI)
                local templateBGColor = table.copy(template.bgColor, true)
                if inventoryCache.attachedItemOnCursor and not inventoryCache.attachedItemOnCursor.animTickCounter and inventoryCache.attachedItemOnCursor.itemBox == localPlayer then
                    local isLootHovered = isMouseOnPosition(j.gui.startX + template.contentWrapper.startX, j.gui.startY + template.contentWrapper.startY, template.contentWrapper.width, template.contentWrapper.height) and not isItemAvailableForOrdering
                    if isLootHovered then
                        if isLootSlotAvailableForDropping(i, inventoryCache.attachedItemOnCursor.item) then
                            local itemSlotIndex = false
                            for k, v in ipairs(sortedItems) do
                                if v.item == inventoryCache.attachedItemOnCursor.item then
                                    itemSlotIndex = k
                                    break
                                end
                            end
                            if not itemSlotIndex then itemSlotIndex = (#sortedItems) + 1 end
                            isItemAvailableForDropping = {
                                slotIndex = itemSlotIndex,
                                loot = i
                            }
                            templateBGColor[1] = template.contentWrapper.itemSlot.availableBGColor[1]
                            templateBGColor[2] = template.contentWrapper.itemSlot.availableBGColor[2]
                            templateBGColor[3] = template.contentWrapper.itemSlot.availableBGColor[3]
                        else
                            templateBGColor[1] = template.contentWrapper.itemSlot.unavailableBGColor[1]
                            templateBGColor[2] = template.contentWrapper.itemSlot.unavailableBGColor[2]
                            templateBGColor[3] = template.contentWrapper.itemSlot.unavailableBGColor[3]
                        end
                    end
                end
                dxDrawImage(j.gui.startX, j.gui.startY, template.width, template.height, template.bgImage, 0, 0, 0, tocolor(templateBGColor[1], templateBGColor[2], templateBGColor[3], templateBGColor[4]*inventoryOpacityPercent), inventoryCache.gui.postGUI)
                dxDrawRectangle(j.gui.startX, j.gui.startY, template.width, inventoryCache.gui.equipment.titleBar.dividerSize, tocolor(inventoryCache.gui.equipment.titleBar.dividerColor[1], inventoryCache.gui.equipment.titleBar.dividerColor[2], inventoryCache.gui.equipment.titleBar.dividerColor[3], inventoryCache.gui.equipment.titleBar.dividerColor[4]*inventoryOpacityPercent), inventoryCache.gui.postGUI)
                dxDrawRectangle(j.gui.startX, j.gui.startY + template.height - inventoryCache.gui.equipment.titleBar.dividerSize, template.width, inventoryCache.gui.equipment.titleBar.dividerSize, tocolor(inventoryCache.gui.equipment.titleBar.dividerColor[1], inventoryCache.gui.equipment.titleBar.dividerColor[2], inventoryCache.gui.equipment.titleBar.dividerColor[3], inventoryCache.gui.equipment.titleBar.dividerColor[4]*inventoryOpacityPercent), inventoryCache.gui.postGUI)
                dxSetRenderTarget(j.gui.renderTarget, true)
                local totalContentHeight = template.contentWrapper.itemSlot.startY + ((template.contentWrapper.itemSlot.paddingY + template.contentWrapper.itemSlot.height)*(#sortedItems))
                local exceededContentHeight =  totalContentHeight - template.contentWrapper.height
                if not j.__itemNameSlots then j.__itemNameSlots = {} end
                if not inventoryCache.isSlotsUpdated then
                    for k, v in pairs(inventoryCache.inventorySlots.slots) do
                        if tonumber(k) and v.loot and v.loot == i then
                            if v.movementType then
                                if v.movementType == "loot" and (tonumber(j.lootItems[v.item]) or 0) <= 0 then
                                    if not sortedItems["__"..v.item] then
                                        table.insert(sortedItems, {item = v.item, itemValue = 1})
                                        sortedItems["__"..v.item] = true
                                    end
                                elseif not inventoryCache.attachedItemOnCursor then
                                    if (v.movementType == "inventory" and not v.isOrdering) or (v.movementType == "equipment" and v.isAutoReserved) then
                                        if not sortedItems["__"..v.item] then
                                            for m, n in ipairs(sortedItems) do
                                                if n.item == v.item then
                                                    if n.itemValue == 1 then
                                                        table.remove(sortedItems, m)
                                                    else
                                                        n.itemValue = n.itemValue - 1
                                                    end
                                                    sortedItems["__"..v.item] = true
                                                    break
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                            break
                        end
                    end
                end
                for k, v in ipairs(sortedItems) do
                    local slot_offsetX, slot_offsetY = template.contentWrapper.itemSlot.startX, template.contentWrapper.itemSlot.startY + ((template.contentWrapper.itemSlot.paddingY + template.contentWrapper.itemSlot.height)*(k - 1))
                    local slotWidth, slotHeight = template.contentWrapper.width + template.contentWrapper.itemSlot.width, template.contentWrapper.itemSlot.height
                    if exceededContentHeight > 0 then slot_offsetY = slot_offsetY - (exceededContentHeight*j.gui.scroller.percent*0.01) end
                    dxDrawImage(slot_offsetX, slot_offsetY, slotWidth, slotHeight, template.contentWrapper.itemSlot.bgImage, 0, 0, 0, tocolor(255, 255, 255, 255), false)
                    local itemDetails, itemCategory = getItemDetails(v.item)
                    if itemDetails and itemCategory then
                        if iconTextures[itemDetails.iconPath] then
                            if not j.__itemNameSlots[itemDetails.dataName] then
                                j.__itemNameSlots[itemDetails.dataName] = {
                                    hoverAnimPercent = 0,
                                    hoverAlphaPercent = 0,
                                    hoverStatus = "backward",
                                    hoverAnimTickCounter = getTickCount() - template.contentWrapper.itemSlot.itemName.hoverAnimDuration
                                }
                            end
                            local iconStartX, iconStartY = slot_offsetX + template.contentWrapper.itemSlot.iconSlot.startX, slot_offsetY + template.contentWrapper.itemSlot.iconSlot.startY
                            local iconWidth, iconHeight = 0, template.contentWrapper.itemSlot.iconSlot.height
                            local originalWidth, originalHeight = iconDimensions[itemDetails.iconPath].width, iconDimensions[itemDetails.iconPath].height
                            iconWidth = (originalWidth / originalHeight)*iconHeight
                            local isSlotHovered = isMouseOnPosition(j.gui.startX + template.contentWrapper.startX, j.gui.startY + template.contentWrapper.startY, template.contentWrapper.width, template.contentWrapper.height) and isMouseOnPosition(j.gui.startX + template.contentWrapper.startX + slot_offsetX, j.gui.startY + template.contentWrapper.startY + slot_offsetY, slotWidth, slotHeight) and (slot_offsetY >= 0) and ((slot_offsetY + slotHeight) <= template.contentWrapper.height) and not inventoryCache.attachedItemOnCursor and isInventoryEnabled
                            if isSlotHovered then
                                equipmentInformation = itemDetails.itemName..":\n"..itemDetails.description
                                if j.__itemNameSlots[itemDetails.dataName].hoverStatus ~= "forward" then
                                    j.__itemNameSlots[itemDetails.dataName].hoverStatus = "forward"
                                    j.__itemNameSlots[itemDetails.dataName].hoverAnimTickCounter = getTickCount()
                                end
                            else
                                if j.__itemNameSlots[itemDetails.dataName].hoverStatus ~= "backward" then
                                    j.__itemNameSlots[itemDetails.dataName].hoverStatus = "backward"
                                    j.__itemNameSlots[itemDetails.dataName].hoverAnimTickCounter = getTickCount()
                                end
                            end
                            if j.__itemNameSlots[itemDetails.dataName].hoverStatus == "forward" then
                                j.__itemNameSlots[itemDetails.dataName].hoverAnimPercent = interpolateBetween(j.__itemNameSlots[itemDetails.dataName].hoverAnimPercent, 0, 0, 1, 0, 0, getInterpolationProgress(j.__itemNameSlots[itemDetails.dataName].hoverAnimTickCounter, template.contentWrapper.itemSlot.itemName.hoverAnimDuration), "OutBounce")
                                j.__itemNameSlots[itemDetails.dataName].hoverAlphaPercent = interpolateBetween(j.__itemNameSlots[itemDetails.dataName].hoverAlphaPercent, 0, 0, 1, 0, 0, getInterpolationProgress(j.__itemNameSlots[itemDetails.dataName].hoverAnimTickCounter, template.contentWrapper.itemSlot.itemName.hoverAnimDuration*2), "OutBounce")
                            else
                                j.__itemNameSlots[itemDetails.dataName].hoverAnimPercent = interpolateBetween(j.__itemNameSlots[itemDetails.dataName].hoverAnimPercent, 0, 0, 0, 0, 0, getInterpolationProgress(j.__itemNameSlots[itemDetails.dataName].hoverAnimTickCounter, template.contentWrapper.itemSlot.itemName.hoverAnimDuration), "OutBounce")
                                j.__itemNameSlots[itemDetails.dataName].hoverAlphaPercent = interpolateBetween(j.__itemNameSlots[itemDetails.dataName].hoverAlphaPercent, 0, 0, 0, 0, 0, getInterpolationProgress(j.__itemNameSlots[itemDetails.dataName].hoverAnimTickCounter, template.contentWrapper.itemSlot.itemName.hoverAnimDuration*0.5), "OutBounce")
                            end
                            local lootItemValue = v.itemValue
                            if inventoryCache.attachedItemOnCursor then
                                if inventoryCache.attachedItemOnCursor.itemBox == i then
                                    if inventoryCache.attachedItemOnCursor.releaseIndex then
                                        if inventoryCache.attachedItemOnCursor.releaseIndex == k then
                                            lootItemValue = lootItemValue - 1
                                        end
                                    elseif inventoryCache.attachedItemOnCursor.prevSlotIndex == k then
                                        lootItemValue = lootItemValue - 1
                                    end
                                end
                            end
                            if lootItemValue > 0 then
                                dxDrawImage(iconStartX, iconStartY, iconWidth, iconHeight, iconTextures[itemDetails.iconPath], 0, 0, 0, tocolor(255, 255, 255, 255), false)
                                dxDrawText(tostring(lootItemValue), slot_offsetX, slot_offsetY, slot_offsetX + slotWidth - template.contentWrapper.itemSlot.itemCounter.paddingX, slot_offsetY + slotHeight - template.contentWrapper.itemSlot.itemCounter.paddingY, tocolor(unpack(template.contentWrapper.itemSlot.itemCounter.fontColor)), 1, template.contentWrapper.itemSlot.itemCounter.font, "right", "bottom", true, false, false)
                            end
                            dxDrawImageSection(slot_offsetX, slot_offsetY, slotWidth, slotHeight, 0, 0, slotWidth*j.__itemNameSlots[itemDetails.dataName].hoverAnimPercent, slotHeight, template.contentWrapper.itemSlot.itemName.bgImage, 0, 0, 0, tocolor(255, 255, 255, 255), false)
                            dxDrawText(string.upper(itemDetails.itemName), slot_offsetX, slot_offsetY, slot_offsetX + slotWidth - template.contentWrapper.itemSlot.itemName.paddingX, slot_offsetY + slotHeight, tocolor(template.contentWrapper.itemSlot.itemName.fontColor[1], template.contentWrapper.itemSlot.itemName.fontColor[2], template.contentWrapper.itemSlot.itemName.fontColor[3], template.contentWrapper.itemSlot.itemName.fontColor[4]*j.__itemNameSlots[itemDetails.dataName].hoverAlphaPercent), 1, template.contentWrapper.itemSlot.itemName.font, "right", "center", true, false, false)
                            if isSlotHovered then
                                if isLMBClicked then
                                    local horizontalSlotsToOccupy = math.max(1, tonumber(itemDetails.itemHorizontalSlots) or 1)
                                    local verticalSlotsToOccupy = math.max(1, tonumber(itemDetails.itemVerticalSlots) or 1)
                                    local cursor_offsetX, cursor_offsetY = getAbsoluteCursorPosition()
                                    local prev_offsetX, prev_offsetY = j.gui.startX + template.contentWrapper.startX + iconStartX, j.gui.startY + template.contentWrapper.startY + iconStartY
                                    local prev_width, prev_height = iconWidth, iconHeight
                                    local attached_offsetX, attached_offsetY = cursor_offsetX - prev_offsetX, cursor_offsetY - prev_offsetY
                                    attachInventoryItem(i, v.item, itemCategory, k, horizontalSlotsToOccupy, verticalSlotsToOccupy, prev_offsetX, prev_offsetY, prev_width, prev_height, attached_offsetX, attached_offsetY)
                                elseif isRMBClicked then
                                    --TODO: ...
                                end
                            end
                        end
                    end
                end
                dxSetRenderTarget()
                dxDrawImage(j.gui.startX + template.contentWrapper.startX, j.gui.startY + template.contentWrapper.startY, template.contentWrapper.width, template.contentWrapper.height, j.gui.renderTarget, 0, 0, 0, tocolor(255, 255, 255, 255*inventoryOpacityPercent), inventoryCache.gui.postGUI)
                if exceededContentHeight > 0 then
                    local scrollOverlayStartX, scrollOverlayStartY = j.gui.startX + template.scrollBar.overlay.startX, j.gui.startY + template.scrollBar.overlay.startY
                    local scrollOverlayWidth, scrollOverlayHeight =  template.scrollBar.overlay.width, template.scrollBar.overlay.height
                    dxDrawRectangle(scrollOverlayStartX, scrollOverlayStartY, scrollOverlayWidth, scrollOverlayHeight, tocolor(template.scrollBar.overlay.bgColor[1], template.scrollBar.overlay.bgColor[2], template.scrollBar.overlay.bgColor[3], template.scrollBar.overlay.bgColor[4]*inventoryOpacityPercent), inventoryCache.gui.postGUI)
                    local scrollBarWidth, scrollBarHeight =  scrollOverlayWidth, template.scrollBar.bar.height
                    local scrollBarStartX, scrollBarStartY = scrollOverlayStartX, scrollOverlayStartY + ((scrollOverlayHeight - scrollBarHeight)*j.gui.scroller.percent*0.01)
                    dxDrawRectangle(scrollBarStartX, scrollBarStartY, scrollBarWidth, scrollBarHeight, tocolor(template.scrollBar.bar.bgColor[1], template.scrollBar.bar.bgColor[2], template.scrollBar.bar.bgColor[3], template.scrollBar.bar.bgColor[4]*inventoryOpacityPercent), inventoryCache.gui.postGUI)
                    if prevScrollState and (isMouseOnPosition(scrollOverlayStartX, scrollOverlayStartY, scrollOverlayWidth, scrollOverlayHeight) or isMouseOnPosition(j.gui.startX + template.contentWrapper.startX, j.gui.startY + template.contentWrapper.startY, template.contentWrapper.width, template.contentWrapper.height)) then
                        if prevScrollState == "up" then
                            if j.gui.scroller.percent <= 0 then
                                j.gui.scroller.percent = 0
                            else
                                if exceededContentHeight < template.contentWrapper.height then
                                    j.gui.scroller.percent = j.gui.scroller.percent - (10*prevScrollStreak.streak)
                                else
                                    j.gui.scroller.percent = j.gui.scroller.percent - (1*prevScrollStreak.streak)
                                end
                                if j.gui.scroller.percent <= 0 then j.gui.scroller.percent = 0 end
                            end
                        elseif prevScrollState == "down" then
                            if j.gui.scroller.percent >= 100 then
                                j.gui.scroller.percent = 100
                            else
                                if exceededContentHeight < template.contentWrapper.height then
                                    j.gui.scroller.percent = j.gui.scroller.percent + (10*prevScrollStreak.streak)
                                else
                                    j.gui.scroller.percent = j.gui.scroller.percent + (1*prevScrollStreak.streak)
                                end
                                if j.gui.scroller.percent >= 100 then j.gui.scroller.percent = 100 end
                            end
                        end
                        prevScrollState = false
                    end
                end
            end
        end
    end

    --Draws Information
    dxSetRenderTarget()
    dxDrawImage(inventoryCache.gui.equipment.description.startX, inventoryCache.gui.equipment.description.startY, inventoryCache.gui.equipment.description.height/2, inventoryCache.gui.equipment.description.height/2, inventoryCache.gui.equipment.slotTopLeftCurvedEdgeBGPath, 0, 0, 0, tocolor(inventoryCache.gui.equipment.description.bgColor[1], inventoryCache.gui.equipment.description.bgColor[2], inventoryCache.gui.equipment.description.bgColor[3], inventoryCache.gui.equipment.description.bgColor[4]*inventoryOpacityPercent), inventoryCache.gui.postGUI)
    dxDrawImage(inventoryCache.gui.equipment.description.startX + inventoryCache.gui.equipment.description.width - inventoryCache.gui.equipment.description.height/2, inventoryCache.gui.equipment.description.startY, inventoryCache.gui.equipment.description.height/2, inventoryCache.gui.equipment.description.height/2, inventoryCache.gui.equipment.slotTopRightCurvedEdgeBGPath, 0, 0, 0, tocolor(inventoryCache.gui.equipment.description.bgColor[1], inventoryCache.gui.equipment.description.bgColor[2], inventoryCache.gui.equipment.description.bgColor[3], inventoryCache.gui.equipment.description.bgColor[4]*inventoryOpacityPercent), inventoryCache.gui.postGUI)
    dxDrawImage(inventoryCache.gui.equipment.description.startX, inventoryCache.gui.equipment.description.startY + inventoryCache.gui.equipment.description.height - inventoryCache.gui.equipment.description.height/2, inventoryCache.gui.equipment.description.height/2, inventoryCache.gui.equipment.description.height/2, inventoryCache.gui.equipment.slotBottomLeftCurvedEdgeBGPath, 0, 0, 0, tocolor(inventoryCache.gui.equipment.description.bgColor[1], inventoryCache.gui.equipment.description.bgColor[2], inventoryCache.gui.equipment.description.bgColor[3], inventoryCache.gui.equipment.description.bgColor[4]*inventoryOpacityPercent), inventoryCache.gui.postGUI)
    dxDrawImage(inventoryCache.gui.equipment.description.startX + inventoryCache.gui.equipment.description.width - inventoryCache.gui.equipment.description.height/2, inventoryCache.gui.equipment.description.startY + inventoryCache.gui.equipment.description.height - inventoryCache.gui.equipment.description.height/2, inventoryCache.gui.equipment.description.height/2, inventoryCache.gui.equipment.description.height/2, inventoryCache.gui.equipment.slotBottomRightCurvedEdgeBGPath, 0, 0, 0, tocolor(inventoryCache.gui.equipment.description.bgColor[1], inventoryCache.gui.equipment.description.bgColor[2], inventoryCache.gui.equipment.description.bgColor[3], inventoryCache.gui.equipment.description.bgColor[4]*inventoryOpacityPercent), inventoryCache.gui.postGUI)
    dxDrawRectangle(inventoryCache.gui.equipment.description.startX + inventoryCache.gui.equipment.description.height/2, inventoryCache.gui.equipment.description.startY, inventoryCache.gui.equipment.description.width - inventoryCache.gui.equipment.description.height, inventoryCache.gui.equipment.description.height, tocolor(inventoryCache.gui.equipment.description.bgColor[1], inventoryCache.gui.equipment.description.bgColor[2], inventoryCache.gui.equipment.description.bgColor[3], inventoryCache.gui.equipment.description.bgColor[4]*inventoryOpacityPercent), inventoryCache.gui.postGUI)
    if equipmentInformation then
        dxDrawText(tostring(equipmentInformation), inventoryCache.gui.equipment.description.startX + inventoryCache.gui.equipment.description.padding, inventoryCache.gui.equipment.description.startY + inventoryCache.gui.equipment.description.padding, inventoryCache.gui.equipment.description.startX + inventoryCache.gui.equipment.description.width - inventoryCache.gui.equipment.description.padding, inventoryCache.gui.equipment.description.startY + inventoryCache.gui.equipment.description.height - inventoryCache.gui.equipment.description.padding, tocolor(equipmentInformationColor[1], equipmentInformationColor[2], equipmentInformationColor[3], equipmentInformationColor[4]*inventoryOpacityPercent), 1, inventoryCache.gui.equipment.description.font, "left", "top", true, true, inventoryCache.gui.postGUI)
    end

    --Draws Lock Stat
    local lockStat_offsetX, lockStat_offsetY = inventoryCache.gui.lockStat.startX + (inventoryCache.gui.equipment.startX + inventoryCache.gui.equipment.width - inventoryCache.gui.lockStat.iconSize), inventoryCache.gui.equipment.startY + inventoryCache.gui.lockStat.startY
    dxDrawImage(lockStat_offsetX, lockStat_offsetY, inventoryCache.gui.lockStat.iconSize, inventoryCache.gui.lockStat.iconSize, ((isInventoryEnabled and not inventoryCache.attachedItemOnCursor) and inventoryCache.gui.lockStat.unlockedIconPath) or inventoryCache.gui.lockStat.lockedIconPath, 0, 0, 0, tocolor(inventoryCache.gui.lockStat.iconColor[1], inventoryCache.gui.lockStat.iconColor[2], inventoryCache.gui.lockStat.iconColor[3], inventoryCache.gui.lockStat.iconColor[4]*inventoryOpacityPercent), inventoryCache.gui.postGUI)

    --Draws Transparency Adjuster
    local thumb_offsetX, thumb_offsetY = inventoryCache.gui.tranparencyAdjuster.startX + ((inventoryCache.gui.tranparencyAdjuster.width - inventoryCache.gui.tranparencyAdjuster.thumbSize)*inventoryCache.gui.tranparencyAdjuster.percent), inventoryCache.gui.tranparencyAdjuster.startY + ((inventoryCache.gui.tranparencyAdjuster.height - inventoryCache.gui.tranparencyAdjuster.thumbSize)/2)
    local isThumbHovered = isMouseOnPosition(thumb_offsetX, thumb_offsetY, inventoryCache.gui.tranparencyAdjuster.thumbSize, inventoryCache.gui.tranparencyAdjuster.thumbSize)
    local isTransparencyAdjusterHovered = isMouseOnPosition(inventoryCache.gui.tranparencyAdjuster.startX - inventoryCache.gui.tranparencyAdjuster.slideRange, inventoryCache.gui.tranparencyAdjuster.startY - inventoryCache.gui.tranparencyAdjuster.slideRange, inventoryCache.gui.tranparencyAdjuster.width + (inventoryCache.gui.tranparencyAdjuster.slideRange*2), inventoryCache.gui.tranparencyAdjuster.height + (inventoryCache.gui.tranparencyAdjuster.slideRange*2))
    if isTransparencyAdjusterHovered then
        if getKeyState("mouse1") and not GuiElement.isMTAWindowActive() and not inventoryCache.attachedItemOnCursor then
            local currentThumbOffsetX = getAbsoluteCursorPosition() - inventoryCache.gui.tranparencyAdjuster.startX + (inventoryCache.gui.tranparencyAdjuster.thumbSize/2)
            inventoryCache.gui.tranparencyAdjuster.percent = math.min(100, math.max(0, math.floor((currentThumbOffsetX / inventoryCache.gui.tranparencyAdjuster.width)*100)))
            inventoryCache.gui.tranparencyAdjuster.percent = inventoryCache.gui.tranparencyAdjuster.percent/100
        end
    end
    dxDrawRectangle(thumb_offsetX - inventoryCache.gui.tranparencyAdjuster.borderSize, thumb_offsetY - inventoryCache.gui.tranparencyAdjuster.borderSize, inventoryCache.gui.tranparencyAdjuster.thumbSize + (inventoryCache.gui.tranparencyAdjuster.borderSize*2), inventoryCache.gui.tranparencyAdjuster.thumbSize + (inventoryCache.gui.tranparencyAdjuster.borderSize*2), tocolor(inventoryCache.gui.tranparencyAdjuster.borderColor[1], inventoryCache.gui.tranparencyAdjuster.borderColor[2], inventoryCache.gui.tranparencyAdjuster.borderColor[3], inventoryCache.gui.tranparencyAdjuster.borderColor[4]*inventoryOpacityPercent), inventoryCache.gui.postGUI)
    dxDrawRectangle(thumb_offsetX, thumb_offsetY, inventoryCache.gui.tranparencyAdjuster.thumbSize, inventoryCache.gui.tranparencyAdjuster.thumbSize, tocolor(inventoryCache.gui.tranparencyAdjuster.thumbColor[1], inventoryCache.gui.tranparencyAdjuster.thumbColor[2], inventoryCache.gui.tranparencyAdjuster.thumbColor[3], inventoryCache.gui.tranparencyAdjuster.thumbColor[4]*inventoryOpacityPercent), inventoryCache.gui.postGUI)

    if inventoryCache.attachedItemOnCursor then
        local itemDetails = getItemDetails(inventoryCache.attachedItemOnCursor.item)
        if not itemDetails then
            detachInventoryItem(true)
        else
            local horizontalSlotsToOccupy = inventoryCache.attachedItemOnCursor.occupiedRowSlots
            local verticalSlotsToOccupy = inventoryCache.attachedItemOnCursor.occupiedColumnSlots
            local iconWidth, iconHeight = 0, inventoryCache.gui.itemBox.templates[1].contentWrapper.itemGrid.slot.size*verticalSlotsToOccupy
            local originalWidth, originalHeight = iconDimensions[itemDetails.iconPath].width, iconDimensions[itemDetails.iconPath].height
            iconWidth = (originalWidth / originalHeight)*iconHeight
            if (GuiElement.isMTAWindowActive() or not getKeyState("mouse1") or not isInventoryEnabled) and (not inventoryCache.attachedItemOnCursor.animTickCounter) then
                prevScrollState = false
                if isItemAvailableForOrdering then
                    local slotWidth, slotHeight = horizontalSlotsToOccupy*inventoryCache.gui.itemBox.templates[1].contentWrapper.itemGrid.slot.size + ((horizontalSlotsToOccupy - 1)*inventoryCache.gui.itemBox.templates[1].contentWrapper.itemGrid.padding), verticalSlotsToOccupy*inventoryCache.gui.itemBox.templates[1].contentWrapper.itemGrid.slot.size + ((verticalSlotsToOccupy - 1)*inventoryCache.gui.itemBox.templates[1].contentWrapper.itemGrid.padding)
                    local releaseIndex = inventoryCache.attachedItemOnCursor.prevSlotIndex
                    inventoryCache.attachedItemOnCursor.prevSlotIndex = isItemAvailableForOrdering.slotIndex
                    inventoryCache.attachedItemOnCursor.prevPosX = itemBoxesCache[localPlayer].gui.startX + inventoryCache.gui.itemBox.templates[1].contentWrapper.startX + isItemAvailableForOrdering.offsetX + ((slotWidth - iconWidth)/2)
                    inventoryCache.attachedItemOnCursor.prevPosY = itemBoxesCache[localPlayer].gui.startY + inventoryCache.gui.itemBox.templates[1].contentWrapper.startY + isItemAvailableForOrdering.offsetY + ((slotHeight - iconHeight)/2)
                    inventoryCache.attachedItemOnCursor.releaseType = "ordering"
                    inventoryCache.attachedItemOnCursor.releaseIndex = releaseIndex
                    if inventoryCache.attachedItemOnCursor.itemBox == localPlayer then
                        if inventoryCache.attachedItemOnCursor.isEquippedItem then
                            unequipItemInInventory(inventoryCache.attachedItemOnCursor.item, releaseIndex, isItemAvailableForOrdering.slotIndex, localPlayer)
                        else
                            orderItemInInventory(inventoryCache.attachedItemOnCursor.item, releaseIndex, isItemAvailableForOrdering.slotIndex)
                        end
                    end
                    triggerEvent("onClientInventorySound", localPlayer, "inventory_move_item")
                elseif isItemAvailableForDropping then
                    local totalLootItems = 0
                    for index, _ in pairs(itemBoxesCache[isItemAvailableForDropping.loot].lootItems) do
                        totalLootItems = totalLootItems + 1
                    end
                    local template = inventoryCache.gui.itemBox.templates[(itemBoxesCache[isItemAvailableForDropping.loot].gui.templateIndex)]
                    local totalContentHeight = template.contentWrapper.itemSlot.startY + ((template.contentWrapper.itemSlot.paddingY + template.contentWrapper.itemSlot.height)*totalLootItems)
                    local exceededContentHeight =  totalContentHeight - template.contentWrapper.height
                    local slot_offsetY = template.contentWrapper.itemSlot.startY + ((template.contentWrapper.itemSlot.paddingY + template.contentWrapper.itemSlot.height)*(isItemAvailableForDropping.slotIndex - 1))
                    local slotWidth, slotHeight = 0, template.contentWrapper.itemSlot.iconSlot.height
                    slotWidth = (originalWidth / originalHeight)*slotHeight
                    if exceededContentHeight > 0 then
                        slot_offsetY = slot_offsetY - (exceededContentHeight*itemBoxesCache[isItemAvailableForDropping.loot].gui.scroller.percent*0.01)
                        if slot_offsetY < 0 then
                            local finalScrollPercent = itemBoxesCache[isItemAvailableForDropping.loot].gui.scroller.percent + (slot_offsetY/exceededContentHeight)*100
                            slot_offsetY = template.contentWrapper.itemSlot.paddingY
                            inventoryCache.attachedItemOnCursor.__scrollItemBox = {initial = itemBoxesCache[isItemAvailableForDropping.loot].gui.scroller.percent, final = finalScrollPercent, tickCounter = getTickCount()}
                        elseif (slot_offsetY + template.contentWrapper.itemSlot.height + template.contentWrapper.itemSlot.paddingY) > template.contentWrapper.height then
                            local finalScrollPercent = itemBoxesCache[isItemAvailableForDropping.loot].gui.scroller.percent + (((slot_offsetY + template.contentWrapper.itemSlot.height + template.contentWrapper.itemSlot.paddingY) - template.contentWrapper.height)/exceededContentHeight)*100
                            slot_offsetY = template.contentWrapper.height - (template.contentWrapper.itemSlot.height + template.contentWrapper.itemSlot.paddingY)
                            inventoryCache.attachedItemOnCursor.__scrollItemBox = {initial = itemBoxesCache[isItemAvailableForDropping.loot].gui.scroller.percent, final = finalScrollPercent, tickCounter = getTickCount()}
                        end
                    end
                    local releaseIndex = inventoryCache.attachedItemOnCursor.prevSlotIndex
                    inventoryCache.attachedItemOnCursor.__finalWidth, inventoryCache.attachedItemOnCursor.__finalHeight = slotWidth, slotHeight
                    inventoryCache.attachedItemOnCursor.prevWidth, inventoryCache.attachedItemOnCursor.prevHeight = inventoryCache.attachedItemOnCursor.__width, inventoryCache.attachedItemOnCursor.__height
                    inventoryCache.attachedItemOnCursor.sizeAnimTickCounter = getTickCount()
                    inventoryCache.attachedItemOnCursor.prevSlotIndex = isItemAvailableForDropping.slotIndex
                    inventoryCache.attachedItemOnCursor.prevPosX = itemBoxesCache[isItemAvailableForDropping.loot].gui.startX + template.contentWrapper.startX + template.contentWrapper.itemSlot.startX + template.contentWrapper.itemSlot.iconSlot.startX
                    inventoryCache.attachedItemOnCursor.prevPosY = itemBoxesCache[isItemAvailableForDropping.loot].gui.startY + template.contentWrapper.startY + slot_offsetY
                    inventoryCache.attachedItemOnCursor.releaseType = "dropping"
                    inventoryCache.attachedItemOnCursor.releaseLoot = isItemAvailableForDropping.loot
                    inventoryCache.attachedItemOnCursor.releaseIndex = releaseIndex
                    if inventoryCache.attachedItemOnCursor.isEquippedItem then
                        local reservedSlotIndex = false
                        inventoryCache.isSlotsUpdatePending = true
                        inventoryCache.inventorySlots.slots[releaseIndex] = nil
                        for i, j in pairs(inventoryCache.inventorySlots.slots) do
                            if tonumber(i) then
                                if j.movementType and j.movementType == "equipment" and releaseIndex == j.equipmentIndex then
                                    reservedSlotIndex = i
                                    break
                                end
                            end
                        end
                        if reservedSlotIndex then
                            inventoryCache.attachedItemOnCursor.reservedSlotType = "equipment"
                            inventoryCache.attachedItemOnCursor.reservedSlot = reservedSlotIndex
                            inventoryCache.inventorySlots.slots[reservedSlotIndex] = {
                                item = inventoryCache.attachedItemOnCursor.item,
                                loot = isItemAvailableForDropping.loot,
                                movementType = "loot"
                            }
                        end
                    else
                        inventoryCache.isSlotsUpdatePending = true
                        inventoryCache.inventorySlots.slots[releaseIndex] = {
                            item = inventoryCache.attachedItemOnCursor.item,
                            loot = isItemAvailableForDropping.loot,
                            movementType = "loot"
                        }
                    end
                    triggerEvent("onClientInventorySound", localPlayer, "inventory_move_item")
                elseif isItemAvailableForEquipping then
                    local slotWidth, slotHeight = inventoryCache.gui.equipment.grids[isItemAvailableForEquipping.slotIndex].width - inventoryCache.gui.equipment.grids[isItemAvailableForEquipping.slotIndex].paddingX, inventoryCache.gui.equipment.grids[isItemAvailableForEquipping.slotIndex].height - inventoryCache.gui.equipment.grids[isItemAvailableForEquipping.slotIndex].paddingY
                    local releaseIndex = inventoryCache.attachedItemOnCursor.prevSlotIndex
                    local reservedSlot = isItemAvailableForEquipping.reservedSlot or releaseIndex
                    inventoryCache.attachedItemOnCursor.__finalWidth, inventoryCache.attachedItemOnCursor.__finalHeight = slotWidth, slotHeight
                    inventoryCache.attachedItemOnCursor.prevWidth, inventoryCache.attachedItemOnCursor.prevHeight = inventoryCache.attachedItemOnCursor.__width, inventoryCache.attachedItemOnCursor.__height
                    inventoryCache.attachedItemOnCursor.sizeAnimTickCounter = getTickCount()
                    inventoryCache.attachedItemOnCursor.prevSlotIndex = isItemAvailableForEquipping.slotIndex
                    inventoryCache.attachedItemOnCursor.prevPosX = isItemAvailableForEquipping.offsetX
                    inventoryCache.attachedItemOnCursor.prevPosY = isItemAvailableForEquipping.offsetY
                    inventoryCache.attachedItemOnCursor.releaseType = "equipping"
                    inventoryCache.attachedItemOnCursor.releaseLoot = isItemAvailableForEquipping.loot
                    inventoryCache.attachedItemOnCursor.releaseIndex = releaseIndex
                    inventoryCache.attachedItemOnCursor.reservedSlot = reservedSlot
                    if loot == localPlayer then
                        inventoryCache.isSlotsUpdatePending = true
                        inventoryCache.inventorySlots.slots[reservedSlot] = {
                            item = inventoryCache.attachedItemOnCursor.item,
                            movementType = "equipment"
                        }
                    else
                        inventoryCache.isSlotsUpdatePending = true
                        inventoryCache.inventorySlots.slots[reservedSlot] = {
                            item = inventoryCache.attachedItemOnCursor.item,
                            loot = isItemAvailableForEquipping.loot,
                            isAutoReserved = true,
                            movementType = "equipment"
                        }
                    end
                    triggerEvent("onClientInventorySound", localPlayer, "inventory_move_item")
                else
                    if inventoryCache.attachedItemOnCursor.itemBox and isElement(inventoryCache.attachedItemOnCursor.itemBox) and itemBoxesCache[inventoryCache.attachedItemOnCursor.itemBox] then
                        if inventoryCache.attachedItemOnCursor.itemBox == localPlayer then
                            local maxSlots = getElementMaxSlots(inventoryCache.attachedItemOnCursor.itemBox)
                            local totalContentHeight = inventoryCache.gui.itemBox.templates[1].contentWrapper.padding + inventoryCache.gui.itemBox.templates[1].contentWrapper.itemGrid.padding + (math.max(0, math.ceil(maxSlots/maximumInventoryRowSlots) - 1)*(inventoryCache.gui.itemBox.templates[1].contentWrapper.itemGrid.slot.size + inventoryCache.gui.itemBox.templates[1].contentWrapper.itemGrid.padding)) + inventoryCache.gui.itemBox.templates[1].contentWrapper.itemGrid.slot.size + inventoryCache.gui.itemBox.templates[1].contentWrapper.itemGrid.padding
                            local exceededContentHeight =  totalContentHeight - inventoryCache.gui.itemBox.templates[1].contentWrapper.height
                            if exceededContentHeight > 0 then
                                local slot_row = math.ceil(inventoryCache.attachedItemOnCursor.prevSlotIndex/maximumInventoryRowSlots)
                                local slot_offsetY = inventoryCache.gui.itemBox.templates[1].contentWrapper.padding + inventoryCache.gui.itemBox.templates[1].contentWrapper.itemGrid.padding + (math.max(0, slot_row - 1)*(inventoryCache.gui.itemBox.templates[1].contentWrapper.itemGrid.slot.size + inventoryCache.gui.itemBox.templates[1].contentWrapper.itemGrid.padding)) - (exceededContentHeight*itemBoxesCache[localPlayer].gui.scroller.percent*0.01)
                                local slot_prevOffsetY = inventoryCache.attachedItemOnCursor.prevPosY - itemBoxesCache[localPlayer].gui.startY - inventoryCache.gui.itemBox.templates[1].contentWrapper.startY
                                if (math.round(slot_offsetY, 2) ~= math.round(slot_prevOffsetY, 2)) then
                                    local finalScrollPercent = itemBoxesCache[localPlayer].gui.scroller.percent + ((slot_offsetY - slot_prevOffsetY)/exceededContentHeight)*100
                                    inventoryCache.attachedItemOnCursor.__scrollItemBox = {initial = itemBoxesCache[localPlayer].gui.scroller.percent, final = finalScrollPercent, tickCounter = getTickCount()}
                                end
                            end
                        else
                            local totalLootItems = 0
                            for index, _ in pairs(itemBoxesCache[inventoryCache.attachedItemOnCursor.itemBox].lootItems) do
                                totalLootItems = totalLootItems + 1
                            end
                            local template = inventoryCache.gui.itemBox.templates[(itemBoxesCache[inventoryCache.attachedItemOnCursor.itemBox].gui.templateIndex)]
                            local totalContentHeight = template.contentWrapper.itemSlot.startY + ((template.contentWrapper.itemSlot.paddingY + template.contentWrapper.itemSlot.height)*totalLootItems)
                            local exceededContentHeight =  totalContentHeight - template.contentWrapper.height
                            inventoryCache.attachedItemOnCursor.__finalWidth, inventoryCache.attachedItemOnCursor.__finalHeight = inventoryCache.attachedItemOnCursor.prevWidth, inventoryCache.attachedItemOnCursor.prevHeight
                            inventoryCache.attachedItemOnCursor.prevWidth, inventoryCache.attachedItemOnCursor.prevHeight = inventoryCache.attachedItemOnCursor.__width, inventoryCache.attachedItemOnCursor.__height
                            inventoryCache.attachedItemOnCursor.sizeAnimTickCounter = getTickCount()
                            if exceededContentHeight > 0 then
                                local slot_offsetY = template.contentWrapper.itemSlot.startY + ((template.contentWrapper.itemSlot.paddingY + template.contentWrapper.itemSlot.height)*(inventoryCache.attachedItemOnCursor.prevSlotIndex - 1)) + template.contentWrapper.itemSlot.paddingY - (exceededContentHeight*itemBoxesCache[inventoryCache.attachedItemOnCursor.itemBox].gui.scroller.percent*0.01)
                                local slot_prevOffsetY = inventoryCache.attachedItemOnCursor.prevPosY - itemBoxesCache[inventoryCache.attachedItemOnCursor.itemBox].gui.startY - template.contentWrapper.startY
                                if (math.round(slot_offsetY, 2) ~= math.round(slot_prevOffsetY, 2)) then
                                    local finalScrollPercent = itemBoxesCache[inventoryCache.attachedItemOnCursor.itemBox].gui.scroller.percent + ((slot_offsetY - slot_prevOffsetY)/exceededContentHeight)*100
                                    inventoryCache.attachedItemOnCursor.__scrollItemBox = {initial = itemBoxesCache[inventoryCache.attachedItemOnCursor.itemBox].gui.scroller.percent, final = finalScrollPercent, tickCounter = getTickCount()}
                                end
                            end
                        end
                        triggerEvent("onClientInventorySound", localPlayer, "inventory_rollback_item")
                    end
                end
                detachInventoryItem()
            end
            if not inventoryCache.attachedItemOnCursor.__finalWidth or not inventoryCache.attachedItemOnCursor.__finalHeight then
                inventoryCache.attachedItemOnCursor.__width, inventoryCache.attachedItemOnCursor.__height = interpolateBetween(inventoryCache.attachedItemOnCursor.prevWidth, inventoryCache.attachedItemOnCursor.prevHeight, 0, iconWidth, iconHeight, 0, getInterpolationProgress(inventoryCache.attachedItemOnCursor.sizeAnimTickCounter, inventoryCache.attachedItemAnimDuration/3), "OutBack")
            else
                inventoryCache.attachedItemOnCursor.__width, inventoryCache.attachedItemOnCursor.__height = interpolateBetween(inventoryCache.attachedItemOnCursor.prevWidth, inventoryCache.attachedItemOnCursor.prevHeight, 0, inventoryCache.attachedItemOnCursor.__finalWidth, inventoryCache.attachedItemOnCursor.__finalHeight, 0, getInterpolationProgress(inventoryCache.attachedItemOnCursor.sizeAnimTickCounter, inventoryCache.attachedItemAnimDuration/3), "OutBack")
            end
            if inventoryCache.attachedItemOnCursor.animTickCounter then
                local icon_offsetX, icon_offsetY = interpolateBetween(inventoryCache.attachedItemOnCursor.__posX, inventoryCache.attachedItemOnCursor.__posY, 0, inventoryCache.attachedItemOnCursor.prevPosX, inventoryCache.attachedItemOnCursor.prevPosY, 0, getInterpolationProgress(inventoryCache.attachedItemOnCursor.animTickCounter, inventoryCache.attachedItemAnimDuration), "OutBounce")
                if inventoryCache.attachedItemOnCursor.__scrollItemBox then
                    itemBoxesCache[(inventoryCache.attachedItemOnCursor.releaseLoot or inventoryCache.attachedItemOnCursor.itemBox)].gui.scroller.percent = interpolateBetween(inventoryCache.attachedItemOnCursor.__scrollItemBox.initial, 0, 0, inventoryCache.attachedItemOnCursor.__scrollItemBox.final, 0, 0, getInterpolationProgress(inventoryCache.attachedItemOnCursor.__scrollItemBox.tickCounter, inventoryCache.attachedItemAnimDuration), "OutBounce")
                end
                dxDrawImage(icon_offsetX, icon_offsetY, inventoryCache.attachedItemOnCursor.__width, inventoryCache.attachedItemOnCursor.__height, iconTextures[itemDetails.iconPath], 0, 0, 0, tocolor(255, 255, 255, 255), false)
                if (math.round(icon_offsetX, 2) == math.round(inventoryCache.attachedItemOnCursor.prevPosX, 2)) and (math.round(icon_offsetY, 2) == math.round(inventoryCache.attachedItemOnCursor.prevPosY, 2)) then
                    if inventoryCache.attachedItemOnCursor.releaseType and inventoryCache.attachedItemOnCursor.releaseType == "equipping" then
                        equipItemInInventory(inventoryCache.attachedItemOnCursor.item, inventoryCache.attachedItemOnCursor.releaseIndex, inventoryCache.attachedItemOnCursor.reservedSlot, inventoryCache.attachedItemOnCursor.prevSlotIndex, inventoryCache.attachedItemOnCursor.itemBox)
                    else
                        if inventoryCache.attachedItemOnCursor.itemBox ~= localPlayer then
                            if inventoryCache.attachedItemOnCursor.releaseType and inventoryCache.attachedItemOnCursor.releaseType == "ordering" then
                                if not inventoryCache.attachedItemOnCursor.isEquippedItem then
                                    moveItemInInventory(inventoryCache.attachedItemOnCursor.item, inventoryCache.attachedItemOnCursor.prevSlotIndex, inventoryCache.attachedItemOnCursor.itemBox)
                                end
                            end
                        else
                            if inventoryCache.attachedItemOnCursor.releaseType and inventoryCache.attachedItemOnCursor.releaseType == "dropping" then
                                if inventoryCache.attachedItemOnCursor.isEquippedItem then
                                    unequipItemInInventory(inventoryCache.attachedItemOnCursor.item, inventoryCache.attachedItemOnCursor.releaseIndex, inventoryCache.attachedItemOnCursor.prevSlotIndex, inventoryCache.attachedItemOnCursor.releaseLoot, inventoryCache.attachedItemOnCursor.reservedSlot)
                                else
                                    moveItemInLoot(inventoryCache.attachedItemOnCursor.item, inventoryCache.attachedItemOnCursor.releaseIndex, inventoryCache.attachedItemOnCursor.releaseLoot)
                                end
                            end
                        end
                    end
                    detachInventoryItem(true)
                end
            else
                local cursor_offsetX, cursor_offsetY = getAbsoluteCursorPosition()
                dxDrawImage(cursor_offsetX - inventoryCache.attachedItemOnCursor.offsetX, cursor_offsetY - inventoryCache.attachedItemOnCursor.offsetY, inventoryCache.attachedItemOnCursor.__width, inventoryCache.attachedItemOnCursor.__height, iconTextures[itemDetails.iconPath], 0, 0, 0, tocolor(255, 255, 255, 255), false)
            end
        end
    end

    prevScrollState = false

end


------------------------------
--[[ Event: On Client Key ]]--
------------------------------

addEventHandler("onClientKey", root, function(button, state)

    if not isInventoryVisible() or GuiElement.isMTAWindowActive() or (inventoryCache.attachedItemOnCursor and inventoryCache.attachedItemOnCursor.animTickCounter) then return false end

    if button == "mouse_wheel_up" then
        if not prevScrollStreak.state or prevScrollStreak.state ~= "up" then
            prevScrollStreak.state = "up"
            prevScrollStreak.streak = 1
            prevScrollStreak.tickCounter = getTickCount()
        else
            if (getTickCount() - prevScrollStreak.tickCounter) < 250 then
                prevScrollStreak.streak = prevScrollStreak.streak + 0.5
            else
                prevScrollStreak.streak = 1
            end
            prevScrollStreak.tickCounter = getTickCount()
        end
        prevScrollState = "up"
    elseif button == "mouse_wheel_down" then
        if not prevScrollStreak.state or prevScrollStreak.state ~= "down" then
            prevScrollStreak.state = "down"
            prevScrollStreak.streak = 1
            prevScrollStreak.tickCounter = getTickCount()
        else
            if (getTickCount() - prevScrollStreak.tickCounter) < 250 then
                prevScrollStreak.streak = prevScrollStreak.streak + 0.5
            else
                prevScrollStreak.streak = 1
            end
            prevScrollStreak.tickCounter = getTickCount()
        end
        prevScrollState = "down"
    end

end)


-----------------------------------------
--[[ Event: On Client Resource Start ]]--
-----------------------------------------

addEventHandler("onClientResourceStart", resource, function()

    for i, j in pairs(inventoryDatas) do
        for k, v in ipairs(j) do
            iconTextures[v.iconPath] = DxTexture(v.iconPath, "argb", true, "clamp")
            local originalWidth, originalHeight = dxGetMaterialSize(iconTextures[v.iconPath])
            iconDimensions[v.iconPath] = {width = originalWidth, height = originalHeight}
        end
    end

end)