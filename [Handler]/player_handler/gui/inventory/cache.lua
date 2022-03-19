----------------------------------------------------------------
--[[ Resource: Player Handler
     Script: handlers: inventory: gui: cache.lua
     Server: -
     Author: OvileAmriam
     Developer: -
     DOC: 18/12/2020 (OvileAmriam)
     Desc: Inventory Cache Handler ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local imports = {
    tocolor = tocolor,
    unpackColor = unpackColor,
    beautify = beautify,
    string = string
}


-------------------
--[[ Variables ]]--
-------------------

inventoryUI = {
    clientInventory = {
        equipment = {
            bottomTest = {
                {
                    title = "Primary",
                    startX = 1,
                    startY = 5 + 20,
                    width = 276,
                    height = 92
                },
                {
                    title = "Secondary",
                    startX = 278,
                    startY = 5 + 20,
                    width = 183,
                    height = 92
                }
            },
            rightTest = {
                {
                    title = "Helmet",
                    startX = 2,
                    startY = 0 + 24,
                    width = 92,
                    height = 92
                },
                {
                    title = "Vest",
                    startX = 2,
                    startY = 92 + 45 + 1 + 24,
                    width = 92,
                    height = 92
                },
                {
                    title = "Upper",
                    startX = 2,
                    startY = 92 + 45 + 1 + 45 + 1 + 45 + 1 + 45 + 1 + 24,
                    width = 92,
                    height = 92
                },
                {
                    title = "Lower",
                    startX = 2,
                    startY = 92 + 45 + 1 + 45 + 1 + 45 + 1 + 45 + 1 + 45 + 1 + 45 + 1 + 45 + 1 + 24,
                    width = 90,
                    height = 92
                },
                {
                    title = "Shoes",
                    startX = 2,
                    startY = 92 + 45 + 1 + 45 + 1 + 45 + 1 + 45 + 1 + 45 + 1 + 45 + 1 + 45 + 1 + 45 + 1 + 45 + 1 + 45 + 1 + 24,
                    width = 92,
                    height = 92
                },
            },
            leftTest = {
                {
                    title = "Backpack",
                    startX = 2,
                    startY = 0,
                    width = 138,
                    height = 138
                }
            }
        },
        startX = 0, startY = -110,
        width = 460, height = 552,
        bgColor = tocolor(0, 0, 0, 250),
        titlebar = {
            height = FRAMEWORK_CONFIGS["UI"]["Inventory"].titlebar.height,
            bgColor = imports.tocolor(imports.unpackColor(FRAMEWORK_CONFIGS["UI"]["Inventory"].titlebar.bgColor)),
            font = CGame.createFont(":beautify_library/files/assets/fonts/teko_medium.rw", 19), fontColor = imports.tocolor(imports.unpackColor(FRAMEWORK_CONFIGS["UI"]["Inventory"].titlebar.fontColor)),
            slot = {
                height = FRAMEWORK_CONFIGS["UI"]["Inventory"].titlebar.slot.height,
                bgColor = imports.tocolor(imports.unpackColor(FRAMEWORK_CONFIGS["UI"]["Inventory"].titlebar.slot.bgColor)),
                font = CGame.createFont(":beautify_library/files/assets/fonts/teko_medium.rw", 16), fontColor = imports.tocolor(imports.unpackColor(FRAMEWORK_CONFIGS["UI"]["Inventory"].titlebar.slot.fontColor))
            }
        },
        grids = {
            padding = 1,
            rows = 12,
            slotSize = 45,
            columns = 11
        }
    }
}

inventoryUI.clientInventory.startX, inventoryUI.clientInventory.startY = inventoryUI.clientInventory.startX + ((CLIENT_MTA_RESOLUTION[1] - inventoryUI.clientInventory.width)*0.5) + (inventoryUI.clientInventory.width*0.5), ((CLIENT_MTA_RESOLUTION[2] + inventoryUI.clientInventory.startY - inventoryUI.clientInventory.height - inventoryUI.clientInventory.titlebar.height)*0.5)


------------------------------
--[[ Function: Renders UI ]]--
------------------------------

inventoryUI.renderUI = function()
    local inventory_startX, inventory_startY = inventoryUI.clientInventory.startX, inventoryUI.clientInventory.startY + inventoryUI.clientInventory.titlebar.height
    imports.beautify.native.drawRectangle(inventory_startX, inventory_startY - inventoryUI.clientInventory.titlebar.height, inventoryUI.clientInventory.width, inventoryUI.clientInventory.titlebar.height, inventoryUI.clientInventory.titlebar.bgColor, false)
    imports.beautify.native.drawRectangle(inventory_startX, inventory_startY, inventoryUI.clientInventory.width, inventoryUI.clientInventory.height, inventoryUI.clientInventory.bgColor, false)
    local playerName = getPlayerName(localPlayer)
    imports.beautify.native.drawText(imports.string.upper(imports.string.spaceChars(playerName.."'s Inventory")), inventory_startX, inventory_startY - inventoryUI.clientInventory.titlebar.height, inventory_startX + inventoryUI.clientInventory.width, inventory_startY, inventoryUI.clientInventory.titlebar.fontColor, 1, inventoryUI.clientInventory.titlebar.font, "center", "center", true, false, false)
    
    local gridStartX, gridStartY = inventory_startX, inventory_startY + inventoryUI.clientInventory.grids.slotSize
    local gridColor = tocolor(FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].characters.categories.fontColor[1], FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].characters.categories.fontColor[2], FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].characters.categories.fontColor[3], 50)
    for i = 1, inventoryUI.clientInventory.grids.rows - 1, 1 do
        imports.beautify.native.drawRectangle(inventory_startX + inventoryUI.clientInventory.grids.padding, gridStartY, inventoryUI.clientInventory.width - (inventoryUI.clientInventory.grids.padding*2), 1, gridColor, false)
        gridStartY = gridStartY + inventoryUI.clientInventory.grids.slotSize + inventoryUI.clientInventory.grids.padding
    end
    for i = 1, inventoryUI.clientInventory.grids.columns - 1, 1 do
        if (i > 1) then
            imports.beautify.native.drawRectangle(gridStartX, inventory_startY + inventoryUI.clientInventory.grids.padding, 1, inventoryUI.clientInventory.height - (inventoryUI.clientInventory.grids.padding*2), gridColor, false)
        end
        gridStartX = gridStartX + inventoryUI.clientInventory.grids.slotSize + inventoryUI.clientInventory.grids.padding
    end

    for i, j in ipairs(inventoryUI.clientInventory.equipment.bottomTest) do
        local titleX, titleY = inventory_startX + j.startX, gridStartY + j.startY
        local titleWidth, titleHeight = j.width, j.height
        imports.beautify.native.drawRectangle(titleX, titleY - inventoryUI.clientInventory.titlebar.slot.height, j.width, inventoryUI.clientInventory.titlebar.slot.height, inventoryUI.clientInventory.titlebar.slot.bgColor, false)
        imports.beautify.native.drawText(imports.string.upper(imports.string.spaceChars(j.title)), titleX, titleY - inventoryUI.clientInventory.titlebar.slot.height + 2, titleX + titleWidth, titleY, inventoryUI.clientInventory.titlebar.slot.fontColor, 1, inventoryUI.clientInventory.titlebar.slot.font, "center", "center", true, false, false)
        imports.beautify.native.drawRectangle(titleX, titleY, titleWidth, titleHeight, inventoryUI.clientInventory.bgColor, false)
    end
    for i, j in ipairs(inventoryUI.clientInventory.equipment.rightTest) do
        local titleX, titleY = inventory_startX - j.startX - j.width, inventory_startY + j.startY
        local titleWidth, titleHeight = j.width, j.height
        imports.beautify.native.drawRectangle(titleX, titleY - inventoryUI.clientInventory.titlebar.slot.height, j.width, inventoryUI.clientInventory.titlebar.slot.height, inventoryUI.clientInventory.titlebar.slot.bgColor, false)
        imports.beautify.native.drawText(imports.string.upper(imports.string.spaceChars(j.title)), titleX, titleY - inventoryUI.clientInventory.titlebar.slot.height + 2, titleX + titleWidth, titleY, inventoryUI.clientInventory.titlebar.slot.fontColor, 1, inventoryUI.clientInventory.titlebar.slot.font, "center", "center", true, false, false)
        imports.beautify.native.drawRectangle(titleX, titleY, titleWidth, titleHeight, inventoryUI.clientInventory.bgColor, false)
    end
    for i, j in ipairs(inventoryUI.clientInventory.equipment.leftTest) do
        local titleX, titleY = inventory_startX + inventoryUI.clientInventory.width + j.startX, gridStartY - j.startY - j.height
        local titleWidth, titleHeight = j.width, j.height
        imports.beautify.native.drawRectangle(titleX, titleY - inventoryUI.clientInventory.titlebar.slot.height, j.width, inventoryUI.clientInventory.titlebar.slot.height, inventoryUI.clientInventory.titlebar.slot.bgColor, false)
        imports.beautify.native.drawText(imports.string.upper(imports.string.spaceChars(j.title)), titleX, titleY - inventoryUI.clientInventory.titlebar.slot.height + 2, titleX + titleWidth, titleY, inventoryUI.clientInventory.titlebar.slot.fontColor, 1, inventoryUI.clientInventory.titlebar.slot.font, "center", "center", true, false, false)
        imports.beautify.native.drawRectangle(titleX, titleY, titleWidth, titleHeight, inventoryUI.clientInventory.bgColor, false)
    end
end


-------------------
--[[ Variables ]]--
-------------------

--[[
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
]]


--------------------------------------
--[[ Function: Displays Inventory ]]--
--------------------------------------

--[[
function displayInventoryUI()

    if not isPlayerInitialized(localPlayer) or getPlayerHealth(localPlayer) <= 0 then return false end

    local isLMBClicked = false
    local isRMBClicked = false
    local isLMBDoubleClicked = false
    local isInventoryEnabled = inventoryUI.isUIEnabled()
    local isItemAvailableForOrdering = false
    local isItemAvailableForDropping = false
    local isItemAvailableForEquipping = false
    local equipmentInformation = false
    local playerName = getElementData(localPlayer, "Character:name") or ""
    local playerMaxSlots = getElementMaxSlots(localPlayer)
    local playerUsedSlots = getElementUsedSlots(localPlayer)
    local equipmentInformationColor = inventoryUI.gui.equipment.description.fontColor
    local inventoryOpacityPercent = inventoryUI.gui.tranparencyAdjuster.minPercent + (1 - inventoryUI.gui.tranparencyAdjuster.minPercent)*inventoryUI.gui.tranparencyAdjuster.percent
    if not GuiElement.isMTAWindowActive() then
        if not prevLMBClickState then
            if getKeyState("mouse1") and not inventoryUI.attachedItemOnCursor then
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
    imports.beautify.native.drawImage(inventoryUI.gui.equipment.startX, inventoryUI.gui.equipment.startY - inventoryUI.gui.equipment.titlebar.height, inventoryUI.gui.equipment.titlebar.height, inventoryUI.gui.equipment.titlebar.height, inventoryUI.gui.equipment.titlebar.leftEdgePath, 0, 0, 0, tocolor(inventoryUI.gui.equipment.titlebar.bgColor[1], inventoryUI.gui.equipment.titlebar.bgColor[2], inventoryUI.gui.equipment.titlebar.bgColor[3], inventoryUI.gui.equipment.titlebar.bgColor[4]*inventoryOpacityPercent), inventoryUI.gui.postGUI)
    dxDrawRectangle(inventoryUI.gui.equipment.startX + inventoryUI.gui.equipment.titlebar.height, inventoryUI.gui.equipment.startY - inventoryUI.gui.equipment.titlebar.height, inventoryUI.gui.equipment.width - inventoryUI.gui.equipment.titlebar.height, inventoryUI.gui.equipment.titlebar.height, tocolor(inventoryUI.gui.equipment.titlebar.bgColor[1], inventoryUI.gui.equipment.titlebar.bgColor[2], inventoryUI.gui.equipment.titlebar.bgColor[3], inventoryUI.gui.equipment.titlebar.bgColor[4]*inventoryOpacityPercent), inventoryUI.gui.postGUI)
    imports.beautify.native.drawImage(inventoryUI.gui.equipment.startX, inventoryUI.gui.equipment.startY, inventoryUI.gui.equipment.width, inventoryUI.gui.equipment.height, inventoryUI.gui.equipment.bgPath, 0, 0, 0, tocolor(inventoryUI.gui.equipment.bgColor[1], inventoryUI.gui.equipment.bgColor[2], inventoryUI.gui.equipment.bgColor[3], inventoryUI.gui.equipment.bgColor[4]*inventoryOpacityPercent), inventoryUI.gui.postGUI)
    dxDrawBorderedText(inventoryUI.gui.equipment.titlebar.outlineWeight, inventoryUI.gui.equipment.titlebar.fontColor, string.upper(playerName.."'S EQUIPMENT   |   "..playerUsedSlots.."/"..playerMaxSlots), inventoryUI.gui.equipment.startX + inventoryUI.gui.equipment.titlebar.height, inventoryUI.gui.equipment.startY - inventoryUI.gui.equipment.titlebar.height, inventoryUI.gui.equipment.startX + inventoryUI.gui.equipment.width - inventoryUI.gui.equipment.titlebar.height, inventoryUI.gui.equipment.startY, tocolor(inventoryUI.gui.equipment.titlebar.fontColor[1], inventoryUI.gui.equipment.titlebar.fontColor[2], inventoryUI.gui.equipment.titlebar.fontColor[3], inventoryUI.gui.equipment.titlebar.fontColor[4]*inventoryOpacityPercent), 1, inventoryUI.gui.equipment.titlebar.font, "right", "center", true, false, inventoryUI.gui.postGUI)
    dxDrawRectangle(inventoryUI.gui.equipment.startX, inventoryUI.gui.equipment.startY, inventoryUI.gui.equipment.width, inventoryUI.gui.equipment.titlebar.dividerSize, tocolor(inventoryUI.gui.equipment.titlebar.dividerColor[1], inventoryUI.gui.equipment.titlebar.dividerColor[2], inventoryUI.gui.equipment.titlebar.dividerColor[3], inventoryUI.gui.equipment.titlebar.dividerColor[4]*inventoryOpacityPercent), inventoryUI.gui.postGUI)
    for i, j in pairs(inventoryUI.gui.equipment.grids) do
        local itemDetails, itemCategory = false, false
        if inventoryUI.slots and inventoryUI.slots.slots[i] then
            itemDetails, itemCategory = getItemDetails(inventoryUI.slots.slots[i])
        end
        imports.beautify.native.drawImage(j.startX - j.borderSize, j.startY - j.borderSize, j.height/2 + j.borderSize, j.height/2 + j.borderSize, inventoryUI.gui.equipment.slotTopLeftCurvedEdgeBGPath, 0, 0, 0, tocolor(j.borderColor[1], j.borderColor[2], j.borderColor[3], j.borderColor[4]*inventoryOpacityPercent), inventoryUI.gui.postGUI)
        imports.beautify.native.drawImage(j.startX + j.width - j.height/2, j.startY - j.borderSize, j.height/2 + j.borderSize, j.height/2 + j.borderSize, inventoryUI.gui.equipment.slotTopRightCurvedEdgeBGPath, 0, 0, 0, tocolor(j.borderColor[1], j.borderColor[2], j.borderColor[3], j.borderColor[4]*inventoryOpacityPercent), inventoryUI.gui.postGUI)
        imports.beautify.native.drawImage(j.startX - j.borderSize, j.startY + j.height - j.height/2, j.height/2 + j.borderSize, j.height/2 + j.borderSize, inventoryUI.gui.equipment.slotBottomLeftCurvedEdgeBGPath, 0, 0, 0, tocolor(j.borderColor[1], j.borderColor[2], j.borderColor[3], j.borderColor[4]*inventoryOpacityPercent), inventoryUI.gui.postGUI)
        imports.beautify.native.drawImage(j.startX + j.width - j.height/2, j.startY + j.height - j.height/2, j.height/2 + j.borderSize, j.height/2 + j.borderSize, inventoryUI.gui.equipment.slotBottomRightCurvedEdgeBGPath, 0, 0, 0, tocolor(j.borderColor[1], j.borderColor[2], j.borderColor[3], j.borderColor[4]*inventoryOpacityPercent), inventoryUI.gui.postGUI)
        if j.width > j.height then
            dxDrawRectangle(j.startX + j.height/2, j.startY - j.borderSize, j.width - j.height, j.height + (j.borderSize*2), tocolor(j.borderColor[1], j.borderColor[2], j.borderColor[3], j.borderColor[4]*inventoryOpacityPercent), inventoryUI.gui.postGUI)
        end
        imports.beautify.native.drawImage(j.startX, j.startY, j.height/2, j.height/2, inventoryUI.gui.equipment.slotTopLeftCurvedEdgeBGPath, 0, 0, 0, tocolor(j.bgColor[1], j.bgColor[2], j.bgColor[3], j.bgColor[4]*inventoryOpacityPercent), inventoryUI.gui.postGUI)
        imports.beautify.native.drawImage(j.startX + j.width - j.height/2, j.startY, j.height/2, j.height/2, inventoryUI.gui.equipment.slotTopRightCurvedEdgeBGPath, 0, 0, 0, tocolor(j.bgColor[1], j.bgColor[2], j.bgColor[3], j.bgColor[4]*inventoryOpacityPercent), inventoryUI.gui.postGUI)
        imports.beautify.native.drawImage(j.startX, j.startY + j.height - j.height/2, j.height/2, j.height/2, inventoryUI.gui.equipment.slotBottomLeftCurvedEdgeBGPath, 0, 0, 0, tocolor(j.bgColor[1], j.bgColor[2], j.bgColor[3], j.bgColor[4]*inventoryOpacityPercent), inventoryUI.gui.postGUI)
        imports.beautify.native.drawImage(j.startX + j.width - j.height/2, j.startY + j.height - j.height/2, j.height/2, j.height/2, inventoryUI.gui.equipment.slotBottomRightCurvedEdgeBGPath, 0, 0, 0, tocolor(j.bgColor[1], j.bgColor[2], j.bgColor[3], j.bgColor[4]*inventoryOpacityPercent), inventoryUI.gui.postGUI)
        if j.width > j.height then
            dxDrawRectangle(j.startX + j.height/2, j.startY, j.width - j.height, j.height, tocolor(j.bgColor[1], j.bgColor[2], j.bgColor[3], j.bgColor[4]*inventoryOpacityPercent), inventoryUI.gui.postGUI)
        end
        local isSlotHovered = isMouseOnPosition(j.startX, j.startY, j.width, j.height) and isInventoryEnabled
        if itemDetails and itemCategory then
            if iconTextures[itemDetails.iconPath] then
                if not inventoryUI.attachedItemOnCursor or (inventoryUI.attachedItemOnCursor.itemBox ~= localPlayer) or (inventoryUI.attachedItemOnCursor.prevSlotIndex ~= i) then                
                    imports.beautify.native.drawImage(j.startX + (j.paddingX/2), j.startY + (j.paddingY/2), j.width - j.paddingX, j.height - j.paddingY, iconTextures[itemDetails.iconPath], 0, 0, 0, tocolor(255, 255, 255, 255*inventoryOpacityPercent), inventoryUI.gui.postGUI)
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
                if inventoryUI.attachedItemOnCursor then
                    if not inventoryUI.attachedItemOnCursor.animTickCounter then
                        if isSlotHovered and isInventoryEnabled then
                            local isSlotAvailable, slotIndex = isPlayerSlotAvailableForEquipping(localPlayer, inventoryUI.attachedItemOnCursor.item, i, inventoryUI.attachedItemOnCursor.itemBox == localPlayer)
                            if isSlotAvailable then
                                isItemAvailableForEquipping = {
                                    slotIndex = i,
                                    reservedSlot = slotIndex,
                                    offsetX = j.startX + (j.paddingX/2),
                                    offsetY = j.startY + (j.paddingY/2),
                                    loot = inventoryUI.attachedItemOnCursor.itemBox
                                }
                            end
                            placeHolderColor = (isSlotAvailable and j.availableBGColor) or j.unavailableBGColor
                        end
                    else
                        if inventoryUI.attachedItemOnCursor.releaseType and inventoryUI.attachedItemOnCursor.releaseType == "equipping" and inventoryUI.attachedItemOnCursor.prevSlotIndex == i then
                            isPlaceHolderToBeShown = false
                        end
                    end
                end
                if isPlaceHolderToBeShown then
                    imports.beautify.native.drawImage(j.startX, j.startY, j.width, j.height, j.bgImage, 0, 0, 0, tocolor(placeHolderColor[1], placeHolderColor[2], placeHolderColor[3], placeHolderColor[4]*inventoryOpacityPercent), inventoryUI.gui.postGUI)	
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
            local template = inventoryUI.gui.itemBox.templates[j.gui.templateIndex]
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
                imports.beautify.native.drawImage(j.gui.startX - template.borderSize, j.gui.startY - template.borderSize, template.height/10 + template.borderSize, template.height/10 + template.borderSize, inventoryUI.gui.equipment.slotTopLeftCurvedEdgeBGPath, 0, 0, 0, tocolor(template.borderColor[1], template.borderColor[2], template.borderColor[3], template.borderColor[4]*inventoryOpacityPercent), inventoryUI.gui.postGUI)
                imports.beautify.native.drawImage(j.gui.startX + template.width - template.height/10, j.gui.startY - template.borderSize, template.height/10 + template.borderSize, template.height/10 + template.borderSize, inventoryUI.gui.equipment.slotTopRightCurvedEdgeBGPath, 0, 0, 0, tocolor(template.borderColor[1], template.borderColor[2], template.borderColor[3], template.borderColor[4]*inventoryOpacityPercent), inventoryUI.gui.postGUI)
                imports.beautify.native.drawImage(j.gui.startX - template.borderSize, j.gui.startY + template.height - template.height/10, template.height/10 + template.borderSize, template.height/10 + template.borderSize, inventoryUI.gui.equipment.slotBottomLeftCurvedEdgeBGPath, 0, 0, 0, tocolor(template.borderColor[1], template.borderColor[2], template.borderColor[3], template.borderColor[4]*inventoryOpacityPercent), inventoryUI.gui.postGUI)
                imports.beautify.native.drawImage(j.gui.startX + template.width - template.height/10, j.gui.startY + template.height - template.height/10, template.height/10 + template.borderSize, template.height/10 + template.borderSize, inventoryUI.gui.equipment.slotBottomRightCurvedEdgeBGPath, 0, 0, 0, tocolor(template.borderColor[1], template.borderColor[2], template.borderColor[3], template.borderColor[4]*inventoryOpacityPercent), inventoryUI.gui.postGUI)
                dxDrawRectangle(j.gui.startX - template.borderSize, j.gui.startY + template.height/10, template.height/10 + template.borderSize, template.height - template.height/5, tocolor(template.borderColor[1], template.borderColor[2], template.borderColor[3], template.borderColor[4]*inventoryOpacityPercent), inventoryUI.gui.postGUI)
                dxDrawRectangle(j.gui.startX + template.width - template.height/10, j.gui.startY + template.height/10, template.height/10 + template.borderSize, template.height - template.height/5, tocolor(template.borderColor[1], template.borderColor[2], template.borderColor[3], template.borderColor[4]*inventoryOpacityPercent), inventoryUI.gui.postGUI)
                dxDrawRectangle(j.gui.startX + template.height/10, j.gui.startY - template.borderSize, template.width - template.height/5, template.height + (template.borderSize*2), tocolor(template.borderColor[1], template.borderColor[2], template.borderColor[3], template.borderColor[4]*inventoryOpacityPercent), inventoryUI.gui.postGUI)
                imports.beautify.native.drawImage(j.gui.startX, j.gui.startY, template.height/10, template.height/10, inventoryUI.gui.equipment.slotTopLeftCurvedEdgeBGPath, 0, 0, 0, tocolor(template.bgColor[1], template.bgColor[2], template.bgColor[3], template.bgColor[4]*inventoryOpacityPercent), inventoryUI.gui.postGUI)
                imports.beautify.native.drawImage(j.gui.startX + template.width - template.height/10, j.gui.startY, template.height/10, template.height/10, inventoryUI.gui.equipment.slotTopRightCurvedEdgeBGPath, 0, 0, 0, tocolor(template.bgColor[1], template.bgColor[2], template.bgColor[3], template.bgColor[4]*inventoryOpacityPercent), inventoryUI.gui.postGUI)
                imports.beautify.native.drawImage(j.gui.startX, j.gui.startY + template.height - template.height/10, template.height/10, template.height/10, inventoryUI.gui.equipment.slotBottomLeftCurvedEdgeBGPath, 0, 0, 0, tocolor(template.bgColor[1], template.bgColor[2], template.bgColor[3], template.bgColor[4]*inventoryOpacityPercent), inventoryUI.gui.postGUI)
                imports.beautify.native.drawImage(j.gui.startX + template.width - template.height/10, j.gui.startY + template.height - template.height/10, template.height/10, template.height/10, inventoryUI.gui.equipment.slotBottomRightCurvedEdgeBGPath, 0, 0, 0, tocolor(template.bgColor[1], template.bgColor[2], template.bgColor[3], template.bgColor[4]*inventoryOpacityPercent), inventoryUI.gui.postGUI)
                dxDrawRectangle(j.gui.startX, j.gui.startY + template.height/10, template.height/10, template.height - template.height/5, tocolor(template.bgColor[1], template.bgColor[2], template.bgColor[3], template.bgColor[4]*inventoryOpacityPercent), inventoryUI.gui.postGUI)
                dxDrawRectangle(j.gui.startX + template.width - template.height/10, j.gui.startY + template.height/10, template.height/10, template.height - template.height/5, tocolor(template.bgColor[1], template.bgColor[2], template.bgColor[3], template.bgColor[4]*inventoryOpacityPercent), inventoryUI.gui.postGUI)
                dxDrawRectangle(j.gui.startX + template.height/10, j.gui.startY, template.width - template.height/5, template.height, tocolor(template.bgColor[1], template.bgColor[2], template.bgColor[3], template.bgColor[4]*inventoryOpacityPercent), inventoryUI.gui.postGUI)
                dxSetRenderTarget(j.gui.renderTarget, true)
                local totalSlots, assignedItems, occupiedSlots = math.min(maxSlots, math.max(maxSlots, #sortedItems)), {}, getPlayerOccupiedSlots(localPlayer) or {}
                local totalContentHeight = template.contentWrapper.padding + template.contentWrapper.itemGrid.padding + (math.max(0, math.ceil(maxSlots/maximumInventoryRowSlots) - 1)*(template.contentWrapper.itemGrid.slot.size + template.contentWrapper.itemGrid.padding)) + template.contentWrapper.itemGrid.slot.size + template.contentWrapper.itemGrid.padding
                local exceededContentHeight =  totalContentHeight - template.contentWrapper.height
                dxSetRenderTarget(j.gui.renderTarget, true)
                if inventoryUI.slots then
                    for k, v in pairs(inventoryUI.slots.slots) do
                        if tonumber(k) then
                            local isSlotToBeDrawn = true
                            if v.movementType and v.movementType ~= "inventory" then
                                isSlotToBeDrawn = false
                            end
                            if not inventoryUI.isUpdated then
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
                                            if not inventoryUI.attachedItemOnCursor or (inventoryUI.attachedItemOnCursor.itemBox ~= i) or (inventoryUI.attachedItemOnCursor.prevSlotIndex ~= slotIndex) then
                                                imports.beautify.native.drawImage(slot_offsetX + ((slotWidth - iconWidth)/2), slot_offsetY + ((slotHeight - iconHeight)/2), iconWidth, iconHeight, iconTextures[itemDetails.iconPath], 0, 0, 0, tocolor(255, 255, 255, 255), false)
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
                            if inventoryUI.attachedItemOnCursor and (inventoryUI.attachedItemOnCursor.itemBox == i) and (inventoryUI.attachedItemOnCursor.prevSlotIndex == slotIndex) then 
                                if not inventoryUI.attachedItemOnCursor.reservedSlotType then
                                    isItemToBeDrawn = false
                                end
                            end
                            if isItemToBeDrawn then
                                imports.beautify.native.drawImage(slot_offsetX + ((slotWidth - iconWidth)/2), slot_offsetY + ((slotHeight - iconHeight)/2), iconWidth, iconHeight, iconTextures[itemDetails.iconPath], 0, 0, 0, tocolor(255, 255, 255, 255), false)
                            end
                            if not inventoryUI.attachedItemOnCursor and isInventoryEnabled then
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
                        if inventoryUI.attachedItemOnCursor and inventoryUI.attachedItemOnCursor.itemBox and isElement(inventoryUI.attachedItemOnCursor.itemBox) and inventoryUI.attachedItemOnCursor.itemBox ~= localPlayer and inventoryUI.attachedItemOnCursor.animTickCounter and inventoryUI.attachedItemOnCursor.releaseType and inventoryUI.attachedItemOnCursor.releaseType == "ordering" then
                            local slotIndexesToOccupy = {}
                            for m = inventoryUI.attachedItemOnCursor.prevSlotIndex, inventoryUI.attachedItemOnCursor.prevSlotIndex + (inventoryUI.attachedItemOnCursor.occupiedRowSlots - 1), 1 do
                                if m <= totalSlots then
                                    for x = 1, inventoryUI.attachedItemOnCursor.occupiedColumnSlots, 1 do
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
                        if inventoryUI.slots.slots[k] and inventoryUI.slots.slots[k].movementType and inventoryUI.slots.slots[k].movementType == "equipment" then
                            local itemDetails, itemCategory = getItemDetails(inventoryUI.slots.slots[k].item)
                            if itemDetails and itemCategory then
                                local horizontalSlotsToOccupy = math.max(1, tonumber(itemDetails.itemHorizontalSlots) or 1)
                                local verticalSlotsToOccupy = math.max(1, tonumber(itemDetails.itemVerticalSlots) or 1)
                                local slot_row = math.ceil(k/maximumInventoryRowSlots)
                                local slot_column = k - (math.max(0, slot_row - 1)*maximumInventoryRowSlots)
                                local slot_offsetX, slot_offsetY = template.contentWrapper.padding + template.contentWrapper.itemGrid.padding + (math.max(0, slot_column - 1)*(template.contentWrapper.itemGrid.slot.size + template.contentWrapper.itemGrid.padding)), template.contentWrapper.padding + template.contentWrapper.itemGrid.padding + (math.max(0, slot_row - 1)*(template.contentWrapper.itemGrid.slot.size + template.contentWrapper.itemGrid.padding)) - (exceededContentHeight*j.gui.scroller.percent*0.01)
                                local slotWidth, slotHeight = horizontalSlotsToOccupy*template.contentWrapper.itemGrid.slot.size + ((horizontalSlotsToOccupy - 1)*template.contentWrapper.itemGrid.padding), verticalSlotsToOccupy*template.contentWrapper.itemGrid.slot.size + ((verticalSlotsToOccupy - 1)*template.contentWrapper.itemGrid.padding)
                                local equippedIndex = inventoryUI.slots.slots[k].equipmentIndex
                                if not equippedIndex then
                                    for m, n in pairs(inventoryUI.gui.equipment.grids) do
                                        if inventoryUI.slots.slots[m] and inventoryUI.slots.slots[m] == inventoryUI.slots.slots[k].item then
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
                if inventoryUI.attachedItemOnCursor and not inventoryUI.attachedItemOnCursor.animTickCounter then
                    for k = 1, totalSlots, 1 do
                        if not occupiedSlots[k] then
                            local slot_row = math.ceil(k/maximumInventoryRowSlots)
                            local slot_column = k - (math.max(0, slot_row - 1)*maximumInventoryRowSlots)
                            local slot_offsetX, slot_offsetY = template.contentWrapper.padding + template.contentWrapper.itemGrid.padding + (math.max(0, slot_column - 1)*(template.contentWrapper.itemGrid.slot.size + template.contentWrapper.itemGrid.padding)), template.contentWrapper.padding + template.contentWrapper.itemGrid.padding + (math.max(0, slot_row - 1)*(template.contentWrapper.itemGrid.slot.size + template.contentWrapper.itemGrid.padding)) - (exceededContentHeight*j.gui.scroller.percent*0.01)
                            if (slot_offsetY >= 0) and ((slot_offsetY + template.contentWrapper.itemGrid.slot.size) <= template.contentWrapper.height) then
                                local isSlotHovered = isMouseOnPosition(j.gui.startX + template.contentWrapper.startX + slot_offsetX, j.gui.startY + template.contentWrapper.startY + slot_offsetY, template.contentWrapper.itemGrid.slot.size, template.contentWrapper.itemGrid.slot.size)
                                if isSlotHovered then
                                    local isSlotAvailable = isPlayerSlotAvailableForOrdering(localPlayer, inventoryUI.attachedItemOnCursor.item, k, inventoryUI.attachedItemOnCursor.isEquippedItem)
                                    if isSlotAvailable then
                                        isItemAvailableForOrdering = {
                                            slotIndex = k,
                                            offsetX = slot_offsetX,
                                            offsetY = slot_offsetY
                                        }
                                    end
                                    for m = k, k + (inventoryUI.attachedItemOnCursor.occupiedRowSlots - 1), 1 do
                                        for x = 1, inventoryUI.attachedItemOnCursor.occupiedColumnSlots, 1 do
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
                imports.beautify.native.drawImage(j.gui.startX + template.contentWrapper.startX, j.gui.startY + template.contentWrapper.startY, template.contentWrapper.width, template.contentWrapper.height, j.gui.renderTarget, 0, 0, 0, tocolor(255, 255, 255, 255*inventoryOpacityPercent), inventoryUI.gui.postGUI)
                if exceededContentHeight > 0 then
                    local scrollOverlayStartX, scrollOverlayStartY = j.gui.startX + template.scrollBar.overlay.startX, j.gui.startY + template.scrollBar.overlay.startY
                    local scrollOverlayWidth, scrollOverlayHeight =  template.scrollBar.overlay.width, template.scrollBar.overlay.height
                    dxDrawRectangle(scrollOverlayStartX, scrollOverlayStartY, scrollOverlayWidth, scrollOverlayHeight, tocolor(template.scrollBar.overlay.bgColor[1], template.scrollBar.overlay.bgColor[2], template.scrollBar.overlay.bgColor[3], template.scrollBar.overlay.bgColor[4]*inventoryOpacityPercent), inventoryUI.gui.postGUI)
                    local scrollBarWidth, scrollBarHeight =  scrollOverlayWidth, template.scrollBar.bar.height
                    local scrollBarStartX, scrollBarStartY = scrollOverlayStartX, scrollOverlayStartY + ((scrollOverlayHeight - scrollBarHeight)*j.gui.scroller.percent*0.01)
                    dxDrawRectangle(scrollBarStartX, scrollBarStartY, scrollBarWidth, scrollBarHeight, tocolor(template.scrollBar.bar.bgColor[1], template.scrollBar.bar.bgColor[2], template.scrollBar.bar.bgColor[3], template.scrollBar.bar.bgColor[4]*inventoryOpacityPercent), inventoryUI.gui.postGUI)
                    if prevScrollState and (not inventoryUI.attachedItemOnCursor or not inventoryUI.attachedItemOnCursor.animTickCounter) and (isMouseOnPosition(scrollOverlayStartX, scrollOverlayStartY, scrollOverlayWidth, scrollOverlayHeight) or isMouseOnPosition(j.gui.startX + template.contentWrapper.startX, j.gui.startY + template.contentWrapper.startY, template.contentWrapper.width, template.contentWrapper.height)) then
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
                imports.beautify.native.drawImage(j.gui.startX + template.width - inventoryUI.gui.equipment.titlebar.height, j.gui.startY - inventoryUI.gui.equipment.titlebar.height, inventoryUI.gui.equipment.titlebar.height, inventoryUI.gui.equipment.titlebar.height, inventoryUI.gui.equipment.titlebar.rightEdgePath, 0, 0, 0, tocolor(inventoryUI.gui.equipment.titlebar.bgColor[1], inventoryUI.gui.equipment.titlebar.bgColor[2], inventoryUI.gui.equipment.titlebar.bgColor[3], inventoryUI.gui.equipment.titlebar.bgColor[4]*inventoryOpacityPercent), inventoryUI.gui.postGUI)
                dxDrawRectangle(j.gui.startX, j.gui.startY - inventoryUI.gui.equipment.titlebar.height, template.width - inventoryUI.gui.equipment.titlebar.height, inventoryUI.gui.equipment.titlebar.height, tocolor(inventoryUI.gui.equipment.titlebar.bgColor[1], inventoryUI.gui.equipment.titlebar.bgColor[2], inventoryUI.gui.equipment.titlebar.bgColor[3], inventoryUI.gui.equipment.titlebar.bgColor[4]*inventoryOpacityPercent), inventoryUI.gui.postGUI)
                dxDrawBorderedText(inventoryUI.gui.equipment.titlebar.outlineWeight, inventoryUI.gui.equipment.titlebar.fontColor, string.upper(j.gui.title.."   |   "..usedSlots.."/"..maxSlots), j.gui.startX + inventoryUI.gui.equipment.titlebar.height, j.gui.startY - inventoryUI.gui.equipment.titlebar.height, inventoryUI.gui.equipment.startX + template.width - inventoryUI.gui.equipment.titlebar.height, inventoryUI.gui.equipment.startY, tocolor(inventoryUI.gui.equipment.titlebar.fontColor[1], inventoryUI.gui.equipment.titlebar.fontColor[2], inventoryUI.gui.equipment.titlebar.fontColor[3], inventoryUI.gui.equipment.titlebar.fontColor[4]*inventoryOpacityPercent), 1, inventoryUI.gui.equipment.titlebar.font, "left", "center", true, false, inventoryUI.gui.postGUI)
                imports.beautify.native.drawImage(j.gui.startX, j.gui.startY + template.height, inventoryUI.gui.equipment.titlebar.height, inventoryUI.gui.equipment.titlebar.height, inventoryUI.gui.equipment.titlebar.invertedEdgePath, 0, 0, 0, tocolor(inventoryUI.gui.equipment.titlebar.bgColor[1], inventoryUI.gui.equipment.titlebar.bgColor[2], inventoryUI.gui.equipment.titlebar.bgColor[3], inventoryUI.gui.equipment.titlebar.bgColor[4]*inventoryOpacityPercent), inventoryUI.gui.postGUI)
                dxDrawRectangle(j.gui.startX + inventoryUI.gui.equipment.titlebar.height, j.gui.startY + template.height, template.width - inventoryUI.gui.equipment.titlebar.height, inventoryUI.gui.equipment.titlebar.height, tocolor(inventoryUI.gui.equipment.titlebar.bgColor[1], inventoryUI.gui.equipment.titlebar.bgColor[2], inventoryUI.gui.equipment.titlebar.bgColor[3], inventoryUI.gui.equipment.titlebar.bgColor[4]*inventoryOpacityPercent), inventoryUI.gui.postGUI)
                local templateBGColor = table.copy(template.bgColor, true)
                if inventoryUI.attachedItemOnCursor and not inventoryUI.attachedItemOnCursor.animTickCounter and inventoryUI.attachedItemOnCursor.itemBox == localPlayer then
                    local isLootHovered = isMouseOnPosition(j.gui.startX + template.contentWrapper.startX, j.gui.startY + template.contentWrapper.startY, template.contentWrapper.width, template.contentWrapper.height) and not isItemAvailableForOrdering
                    if isLootHovered then
                        if isLootSlotAvailableForDropping(i, inventoryUI.attachedItemOnCursor.item) then
                            local itemSlotIndex = false
                            for k, v in ipairs(sortedItems) do
                                if v.item == inventoryUI.attachedItemOnCursor.item then
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
                imports.beautify.native.drawImage(j.gui.startX, j.gui.startY, template.width, template.height, template.bgImage, 0, 0, 0, tocolor(templateBGColor[1], templateBGColor[2], templateBGColor[3], templateBGColor[4]*inventoryOpacityPercent), inventoryUI.gui.postGUI)
                dxDrawRectangle(j.gui.startX, j.gui.startY, template.width, inventoryUI.gui.equipment.titlebar.dividerSize, tocolor(inventoryUI.gui.equipment.titlebar.dividerColor[1], inventoryUI.gui.equipment.titlebar.dividerColor[2], inventoryUI.gui.equipment.titlebar.dividerColor[3], inventoryUI.gui.equipment.titlebar.dividerColor[4]*inventoryOpacityPercent), inventoryUI.gui.postGUI)
                dxDrawRectangle(j.gui.startX, j.gui.startY + template.height - inventoryUI.gui.equipment.titlebar.dividerSize, template.width, inventoryUI.gui.equipment.titlebar.dividerSize, tocolor(inventoryUI.gui.equipment.titlebar.dividerColor[1], inventoryUI.gui.equipment.titlebar.dividerColor[2], inventoryUI.gui.equipment.titlebar.dividerColor[3], inventoryUI.gui.equipment.titlebar.dividerColor[4]*inventoryOpacityPercent), inventoryUI.gui.postGUI)
                dxSetRenderTarget(j.gui.renderTarget, true)
                local totalContentHeight = template.contentWrapper.itemSlot.startY + ((template.contentWrapper.itemSlot.paddingY + template.contentWrapper.itemSlot.height)*(#sortedItems))
                local exceededContentHeight =  totalContentHeight - template.contentWrapper.height
                if not j.__itemNameSlots then j.__itemNameSlots = {} end
                if not inventoryUI.isUpdated then
                    for k, v in pairs(inventoryUI.slots.slots) do
                        if tonumber(k) and v.loot and v.loot == i then
                            if v.movementType then
                                if v.movementType == "loot" and (tonumber(j.lootItems[v.item]) or 0) <= 0 then
                                    if not sortedItems["__"..v.item] then
                                        table.insert(sortedItems, {item = v.item, itemValue = 1})
                                        sortedItems["__"..v.item] = true
                                    end
                                elseif not inventoryUI.attachedItemOnCursor then
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
                    imports.beautify.native.drawImage(slot_offsetX, slot_offsetY, slotWidth, slotHeight, template.contentWrapper.itemSlot.bgImage, 0, 0, 0, tocolor(255, 255, 255, 255), false)
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
                            local isSlotHovered = isMouseOnPosition(j.gui.startX + template.contentWrapper.startX, j.gui.startY + template.contentWrapper.startY, template.contentWrapper.width, template.contentWrapper.height) and isMouseOnPosition(j.gui.startX + template.contentWrapper.startX + slot_offsetX, j.gui.startY + template.contentWrapper.startY + slot_offsetY, slotWidth, slotHeight) and (slot_offsetY >= 0) and ((slot_offsetY + slotHeight) <= template.contentWrapper.height) and not inventoryUI.attachedItemOnCursor and isInventoryEnabled
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
                            if inventoryUI.attachedItemOnCursor then
                                if inventoryUI.attachedItemOnCursor.itemBox == i then
                                    if inventoryUI.attachedItemOnCursor.releaseIndex then
                                        if inventoryUI.attachedItemOnCursor.releaseIndex == k then
                                            lootItemValue = lootItemValue - 1
                                        end
                                    elseif inventoryUI.attachedItemOnCursor.prevSlotIndex == k then
                                        lootItemValue = lootItemValue - 1
                                    end
                                end
                            end
                            if lootItemValue > 0 then
                                imports.beautify.native.drawImage(iconStartX, iconStartY, iconWidth, iconHeight, iconTextures[itemDetails.iconPath], 0, 0, 0, tocolor(255, 255, 255, 255), false)
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
                imports.beautify.native.drawImage(j.gui.startX + template.contentWrapper.startX, j.gui.startY + template.contentWrapper.startY, template.contentWrapper.width, template.contentWrapper.height, j.gui.renderTarget, 0, 0, 0, tocolor(255, 255, 255, 255*inventoryOpacityPercent), inventoryUI.gui.postGUI)
                if exceededContentHeight > 0 then
                    local scrollOverlayStartX, scrollOverlayStartY = j.gui.startX + template.scrollBar.overlay.startX, j.gui.startY + template.scrollBar.overlay.startY
                    local scrollOverlayWidth, scrollOverlayHeight =  template.scrollBar.overlay.width, template.scrollBar.overlay.height
                    dxDrawRectangle(scrollOverlayStartX, scrollOverlayStartY, scrollOverlayWidth, scrollOverlayHeight, tocolor(template.scrollBar.overlay.bgColor[1], template.scrollBar.overlay.bgColor[2], template.scrollBar.overlay.bgColor[3], template.scrollBar.overlay.bgColor[4]*inventoryOpacityPercent), inventoryUI.gui.postGUI)
                    local scrollBarWidth, scrollBarHeight =  scrollOverlayWidth, template.scrollBar.bar.height
                    local scrollBarStartX, scrollBarStartY = scrollOverlayStartX, scrollOverlayStartY + ((scrollOverlayHeight - scrollBarHeight)*j.gui.scroller.percent*0.01)
                    dxDrawRectangle(scrollBarStartX, scrollBarStartY, scrollBarWidth, scrollBarHeight, tocolor(template.scrollBar.bar.bgColor[1], template.scrollBar.bar.bgColor[2], template.scrollBar.bar.bgColor[3], template.scrollBar.bar.bgColor[4]*inventoryOpacityPercent), inventoryUI.gui.postGUI)
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
    imports.beautify.native.drawImage(inventoryUI.gui.equipment.description.startX, inventoryUI.gui.equipment.description.startY, inventoryUI.gui.equipment.description.height/2, inventoryUI.gui.equipment.description.height/2, inventoryUI.gui.equipment.slotTopLeftCurvedEdgeBGPath, 0, 0, 0, tocolor(inventoryUI.gui.equipment.description.bgColor[1], inventoryUI.gui.equipment.description.bgColor[2], inventoryUI.gui.equipment.description.bgColor[3], inventoryUI.gui.equipment.description.bgColor[4]*inventoryOpacityPercent), inventoryUI.gui.postGUI)
    imports.beautify.native.drawImage(inventoryUI.gui.equipment.description.startX + inventoryUI.gui.equipment.description.width - inventoryUI.gui.equipment.description.height/2, inventoryUI.gui.equipment.description.startY, inventoryUI.gui.equipment.description.height/2, inventoryUI.gui.equipment.description.height/2, inventoryUI.gui.equipment.slotTopRightCurvedEdgeBGPath, 0, 0, 0, tocolor(inventoryUI.gui.equipment.description.bgColor[1], inventoryUI.gui.equipment.description.bgColor[2], inventoryUI.gui.equipment.description.bgColor[3], inventoryUI.gui.equipment.description.bgColor[4]*inventoryOpacityPercent), inventoryUI.gui.postGUI)
    imports.beautify.native.drawImage(inventoryUI.gui.equipment.description.startX, inventoryUI.gui.equipment.description.startY + inventoryUI.gui.equipment.description.height - inventoryUI.gui.equipment.description.height/2, inventoryUI.gui.equipment.description.height/2, inventoryUI.gui.equipment.description.height/2, inventoryUI.gui.equipment.slotBottomLeftCurvedEdgeBGPath, 0, 0, 0, tocolor(inventoryUI.gui.equipment.description.bgColor[1], inventoryUI.gui.equipment.description.bgColor[2], inventoryUI.gui.equipment.description.bgColor[3], inventoryUI.gui.equipment.description.bgColor[4]*inventoryOpacityPercent), inventoryUI.gui.postGUI)
    imports.beautify.native.drawImage(inventoryUI.gui.equipment.description.startX + inventoryUI.gui.equipment.description.width - inventoryUI.gui.equipment.description.height/2, inventoryUI.gui.equipment.description.startY + inventoryUI.gui.equipment.description.height - inventoryUI.gui.equipment.description.height/2, inventoryUI.gui.equipment.description.height/2, inventoryUI.gui.equipment.description.height/2, inventoryUI.gui.equipment.slotBottomRightCurvedEdgeBGPath, 0, 0, 0, tocolor(inventoryUI.gui.equipment.description.bgColor[1], inventoryUI.gui.equipment.description.bgColor[2], inventoryUI.gui.equipment.description.bgColor[3], inventoryUI.gui.equipment.description.bgColor[4]*inventoryOpacityPercent), inventoryUI.gui.postGUI)
    dxDrawRectangle(inventoryUI.gui.equipment.description.startX + inventoryUI.gui.equipment.description.height/2, inventoryUI.gui.equipment.description.startY, inventoryUI.gui.equipment.description.width - inventoryUI.gui.equipment.description.height, inventoryUI.gui.equipment.description.height, tocolor(inventoryUI.gui.equipment.description.bgColor[1], inventoryUI.gui.equipment.description.bgColor[2], inventoryUI.gui.equipment.description.bgColor[3], inventoryUI.gui.equipment.description.bgColor[4]*inventoryOpacityPercent), inventoryUI.gui.postGUI)
    if equipmentInformation then
        dxDrawText(tostring(equipmentInformation), inventoryUI.gui.equipment.description.startX + inventoryUI.gui.equipment.description.padding, inventoryUI.gui.equipment.description.startY + inventoryUI.gui.equipment.description.padding, inventoryUI.gui.equipment.description.startX + inventoryUI.gui.equipment.description.width - inventoryUI.gui.equipment.description.padding, inventoryUI.gui.equipment.description.startY + inventoryUI.gui.equipment.description.height - inventoryUI.gui.equipment.description.padding, tocolor(equipmentInformationColor[1], equipmentInformationColor[2], equipmentInformationColor[3], equipmentInformationColor[4]*inventoryOpacityPercent), 1, inventoryUI.gui.equipment.description.font, "left", "top", true, true, inventoryUI.gui.postGUI)
    end

    --Draws Lock Stat
    local lockStat_offsetX, lockStat_offsetY = inventoryUI.gui.lockStat.startX + (inventoryUI.gui.equipment.startX + inventoryUI.gui.equipment.width - inventoryUI.gui.lockStat.iconSize), inventoryUI.gui.equipment.startY + inventoryUI.gui.lockStat.startY
    imports.beautify.native.drawImage(lockStat_offsetX, lockStat_offsetY, inventoryUI.gui.lockStat.iconSize, inventoryUI.gui.lockStat.iconSize, ((isInventoryEnabled and not inventoryUI.attachedItemOnCursor) and inventoryUI.gui.lockStat.unlockedIconPath) or inventoryUI.gui.lockStat.lockedIconPath, 0, 0, 0, tocolor(inventoryUI.gui.lockStat.iconColor[1], inventoryUI.gui.lockStat.iconColor[2], inventoryUI.gui.lockStat.iconColor[3], inventoryUI.gui.lockStat.iconColor[4]*inventoryOpacityPercent), inventoryUI.gui.postGUI)

    --Draws Transparency Adjuster
    local thumb_offsetX, thumb_offsetY = inventoryUI.gui.tranparencyAdjuster.startX + ((inventoryUI.gui.tranparencyAdjuster.width - inventoryUI.gui.tranparencyAdjuster.thumbSize)*inventoryUI.gui.tranparencyAdjuster.percent), inventoryUI.gui.tranparencyAdjuster.startY + ((inventoryUI.gui.tranparencyAdjuster.height - inventoryUI.gui.tranparencyAdjuster.thumbSize)/2)
    local isThumbHovered = isMouseOnPosition(thumb_offsetX, thumb_offsetY, inventoryUI.gui.tranparencyAdjuster.thumbSize, inventoryUI.gui.tranparencyAdjuster.thumbSize)
    local isTransparencyAdjusterHovered = isMouseOnPosition(inventoryUI.gui.tranparencyAdjuster.startX - inventoryUI.gui.tranparencyAdjuster.slideRange, inventoryUI.gui.tranparencyAdjuster.startY - inventoryUI.gui.tranparencyAdjuster.slideRange, inventoryUI.gui.tranparencyAdjuster.width + (inventoryUI.gui.tranparencyAdjuster.slideRange*2), inventoryUI.gui.tranparencyAdjuster.height + (inventoryUI.gui.tranparencyAdjuster.slideRange*2))
    if isTransparencyAdjusterHovered then
        if getKeyState("mouse1") and not GuiElement.isMTAWindowActive() and not inventoryUI.attachedItemOnCursor then
            local currentThumbOffsetX = getAbsoluteCursorPosition() - inventoryUI.gui.tranparencyAdjuster.startX + (inventoryUI.gui.tranparencyAdjuster.thumbSize/2)
            inventoryUI.gui.tranparencyAdjuster.percent = math.min(100, math.max(0, math.floor((currentThumbOffsetX / inventoryUI.gui.tranparencyAdjuster.width)*100)))
            inventoryUI.gui.tranparencyAdjuster.percent = inventoryUI.gui.tranparencyAdjuster.percent/100
        end
    end
    dxDrawRectangle(thumb_offsetX - inventoryUI.gui.tranparencyAdjuster.borderSize, thumb_offsetY - inventoryUI.gui.tranparencyAdjuster.borderSize, inventoryUI.gui.tranparencyAdjuster.thumbSize + (inventoryUI.gui.tranparencyAdjuster.borderSize*2), inventoryUI.gui.tranparencyAdjuster.thumbSize + (inventoryUI.gui.tranparencyAdjuster.borderSize*2), tocolor(inventoryUI.gui.tranparencyAdjuster.borderColor[1], inventoryUI.gui.tranparencyAdjuster.borderColor[2], inventoryUI.gui.tranparencyAdjuster.borderColor[3], inventoryUI.gui.tranparencyAdjuster.borderColor[4]*inventoryOpacityPercent), inventoryUI.gui.postGUI)
    dxDrawRectangle(thumb_offsetX, thumb_offsetY, inventoryUI.gui.tranparencyAdjuster.thumbSize, inventoryUI.gui.tranparencyAdjuster.thumbSize, tocolor(inventoryUI.gui.tranparencyAdjuster.thumbColor[1], inventoryUI.gui.tranparencyAdjuster.thumbColor[2], inventoryUI.gui.tranparencyAdjuster.thumbColor[3], inventoryUI.gui.tranparencyAdjuster.thumbColor[4]*inventoryOpacityPercent), inventoryUI.gui.postGUI)

    if inventoryUI.attachedItemOnCursor then
        local itemDetails = getItemDetails(inventoryUI.attachedItemOnCursor.item)
        if not itemDetails then
            detachInventoryItem(true)
        else
            local horizontalSlotsToOccupy = inventoryUI.attachedItemOnCursor.occupiedRowSlots
            local verticalSlotsToOccupy = inventoryUI.attachedItemOnCursor.occupiedColumnSlots
            local iconWidth, iconHeight = 0, inventoryUI.gui.itemBox.templates[1].contentWrapper.itemGrid.slot.size*verticalSlotsToOccupy
            local originalWidth, originalHeight = iconDimensions[itemDetails.iconPath].width, iconDimensions[itemDetails.iconPath].height
            iconWidth = (originalWidth / originalHeight)*iconHeight
            if (GuiElement.isMTAWindowActive() or not getKeyState("mouse1") or not isInventoryEnabled) and (not inventoryUI.attachedItemOnCursor.animTickCounter) then
                prevScrollState = false
                if isItemAvailableForOrdering then
                    local slotWidth, slotHeight = horizontalSlotsToOccupy*inventoryUI.gui.itemBox.templates[1].contentWrapper.itemGrid.slot.size + ((horizontalSlotsToOccupy - 1)*inventoryUI.gui.itemBox.templates[1].contentWrapper.itemGrid.padding), verticalSlotsToOccupy*inventoryUI.gui.itemBox.templates[1].contentWrapper.itemGrid.slot.size + ((verticalSlotsToOccupy - 1)*inventoryUI.gui.itemBox.templates[1].contentWrapper.itemGrid.padding)
                    local releaseIndex = inventoryUI.attachedItemOnCursor.prevSlotIndex
                    inventoryUI.attachedItemOnCursor.prevSlotIndex = isItemAvailableForOrdering.slotIndex
                    inventoryUI.attachedItemOnCursor.prevPosX = itemBoxesCache[localPlayer].gui.startX + inventoryUI.gui.itemBox.templates[1].contentWrapper.startX + isItemAvailableForOrdering.offsetX + ((slotWidth - iconWidth)/2)
                    inventoryUI.attachedItemOnCursor.prevPosY = itemBoxesCache[localPlayer].gui.startY + inventoryUI.gui.itemBox.templates[1].contentWrapper.startY + isItemAvailableForOrdering.offsetY + ((slotHeight - iconHeight)/2)
                    inventoryUI.attachedItemOnCursor.releaseType = "ordering"
                    inventoryUI.attachedItemOnCursor.releaseIndex = releaseIndex
                    if inventoryUI.attachedItemOnCursor.itemBox == localPlayer then
                        if inventoryUI.attachedItemOnCursor.isEquippedItem then
                            unequipItemInInventory(inventoryUI.attachedItemOnCursor.item, releaseIndex, isItemAvailableForOrdering.slotIndex, localPlayer)
                        else
                            orderItemInInventory(inventoryUI.attachedItemOnCursor.item, releaseIndex, isItemAvailableForOrdering.slotIndex)
                        end
                    end
                    triggerEvent("onClientInventorySound", localPlayer, "inventory_move_item")
                elseif isItemAvailableForDropping then
                    local totalLootItems = 0
                    for index, _ in pairs(itemBoxesCache[isItemAvailableForDropping.loot].lootItems) do
                        totalLootItems = totalLootItems + 1
                    end
                    local template = inventoryUI.gui.itemBox.templates[(itemBoxesCache[isItemAvailableForDropping.loot].gui.templateIndex)]
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
                            inventoryUI.attachedItemOnCursor.__scrollItemBox = {initial = itemBoxesCache[isItemAvailableForDropping.loot].gui.scroller.percent, final = finalScrollPercent, tickCounter = getTickCount()}
                        elseif (slot_offsetY + template.contentWrapper.itemSlot.height + template.contentWrapper.itemSlot.paddingY) > template.contentWrapper.height then
                            local finalScrollPercent = itemBoxesCache[isItemAvailableForDropping.loot].gui.scroller.percent + (((slot_offsetY + template.contentWrapper.itemSlot.height + template.contentWrapper.itemSlot.paddingY) - template.contentWrapper.height)/exceededContentHeight)*100
                            slot_offsetY = template.contentWrapper.height - (template.contentWrapper.itemSlot.height + template.contentWrapper.itemSlot.paddingY)
                            inventoryUI.attachedItemOnCursor.__scrollItemBox = {initial = itemBoxesCache[isItemAvailableForDropping.loot].gui.scroller.percent, final = finalScrollPercent, tickCounter = getTickCount()}
                        end
                    end
                    local releaseIndex = inventoryUI.attachedItemOnCursor.prevSlotIndex
                    inventoryUI.attachedItemOnCursor.__finalWidth, inventoryUI.attachedItemOnCursor.__finalHeight = slotWidth, slotHeight
                    inventoryUI.attachedItemOnCursor.prevWidth, inventoryUI.attachedItemOnCursor.prevHeight = inventoryUI.attachedItemOnCursor.__width, inventoryUI.attachedItemOnCursor.__height
                    inventoryUI.attachedItemOnCursor.sizeAnimTickCounter = getTickCount()
                    inventoryUI.attachedItemOnCursor.prevSlotIndex = isItemAvailableForDropping.slotIndex
                    inventoryUI.attachedItemOnCursor.prevPosX = itemBoxesCache[isItemAvailableForDropping.loot].gui.startX + template.contentWrapper.startX + template.contentWrapper.itemSlot.startX + template.contentWrapper.itemSlot.iconSlot.startX
                    inventoryUI.attachedItemOnCursor.prevPosY = itemBoxesCache[isItemAvailableForDropping.loot].gui.startY + template.contentWrapper.startY + slot_offsetY
                    inventoryUI.attachedItemOnCursor.releaseType = "dropping"
                    inventoryUI.attachedItemOnCursor.releaseLoot = isItemAvailableForDropping.loot
                    inventoryUI.attachedItemOnCursor.releaseIndex = releaseIndex
                    if inventoryUI.attachedItemOnCursor.isEquippedItem then
                        local reservedSlotIndex = false
                        inventoryUI.isUpdateScheduled = true
                        inventoryUI.slots.slots[releaseIndex] = nil
                        for i, j in pairs(inventoryUI.slots.slots) do
                            if tonumber(i) then
                                if j.movementType and j.movementType == "equipment" and releaseIndex == j.equipmentIndex then
                                    reservedSlotIndex = i
                                    break
                                end
                            end
                        end
                        if reservedSlotIndex then
                            inventoryUI.attachedItemOnCursor.reservedSlotType = "equipment"
                            inventoryUI.attachedItemOnCursor.reservedSlot = reservedSlotIndex
                            inventoryUI.slots.slots[reservedSlotIndex] = {
                                item = inventoryUI.attachedItemOnCursor.item,
                                loot = isItemAvailableForDropping.loot,
                                movementType = "loot"
                            }
                        end
                    else
                        inventoryUI.isUpdateScheduled = true
                        inventoryUI.slots.slots[releaseIndex] = {
                            item = inventoryUI.attachedItemOnCursor.item,
                            loot = isItemAvailableForDropping.loot,
                            movementType = "loot"
                        }
                    end
                    triggerEvent("onClientInventorySound", localPlayer, "inventory_move_item")
                elseif isItemAvailableForEquipping then
                    local slotWidth, slotHeight = inventoryUI.gui.equipment.grids[isItemAvailableForEquipping.slotIndex].width - inventoryUI.gui.equipment.grids[isItemAvailableForEquipping.slotIndex].paddingX, inventoryUI.gui.equipment.grids[isItemAvailableForEquipping.slotIndex].height - inventoryUI.gui.equipment.grids[isItemAvailableForEquipping.slotIndex].paddingY
                    local releaseIndex = inventoryUI.attachedItemOnCursor.prevSlotIndex
                    local reservedSlot = isItemAvailableForEquipping.reservedSlot or releaseIndex
                    inventoryUI.attachedItemOnCursor.__finalWidth, inventoryUI.attachedItemOnCursor.__finalHeight = slotWidth, slotHeight
                    inventoryUI.attachedItemOnCursor.prevWidth, inventoryUI.attachedItemOnCursor.prevHeight = inventoryUI.attachedItemOnCursor.__width, inventoryUI.attachedItemOnCursor.__height
                    inventoryUI.attachedItemOnCursor.sizeAnimTickCounter = getTickCount()
                    inventoryUI.attachedItemOnCursor.prevSlotIndex = isItemAvailableForEquipping.slotIndex
                    inventoryUI.attachedItemOnCursor.prevPosX = isItemAvailableForEquipping.offsetX
                    inventoryUI.attachedItemOnCursor.prevPosY = isItemAvailableForEquipping.offsetY
                    inventoryUI.attachedItemOnCursor.releaseType = "equipping"
                    inventoryUI.attachedItemOnCursor.releaseLoot = isItemAvailableForEquipping.loot
                    inventoryUI.attachedItemOnCursor.releaseIndex = releaseIndex
                    inventoryUI.attachedItemOnCursor.reservedSlot = reservedSlot
                    if loot == localPlayer then
                        inventoryUI.isUpdateScheduled = true
                        inventoryUI.slots.slots[reservedSlot] = {
                            item = inventoryUI.attachedItemOnCursor.item,
                            movementType = "equipment"
                        }
                    else
                        inventoryUI.isUpdateScheduled = true
                        inventoryUI.slots.slots[reservedSlot] = {
                            item = inventoryUI.attachedItemOnCursor.item,
                            loot = isItemAvailableForEquipping.loot,
                            isAutoReserved = true,
                            movementType = "equipment"
                        }
                    end
                    triggerEvent("onClientInventorySound", localPlayer, "inventory_move_item")
                else
                    if inventoryUI.attachedItemOnCursor.itemBox and isElement(inventoryUI.attachedItemOnCursor.itemBox) and itemBoxesCache[inventoryUI.attachedItemOnCursor.itemBox] then
                        if inventoryUI.attachedItemOnCursor.itemBox == localPlayer then
                            local maxSlots = getElementMaxSlots(inventoryUI.attachedItemOnCursor.itemBox)
                            local totalContentHeight = inventoryUI.gui.itemBox.templates[1].contentWrapper.padding + inventoryUI.gui.itemBox.templates[1].contentWrapper.itemGrid.padding + (math.max(0, math.ceil(maxSlots/maximumInventoryRowSlots) - 1)*(inventoryUI.gui.itemBox.templates[1].contentWrapper.itemGrid.slot.size + inventoryUI.gui.itemBox.templates[1].contentWrapper.itemGrid.padding)) + inventoryUI.gui.itemBox.templates[1].contentWrapper.itemGrid.slot.size + inventoryUI.gui.itemBox.templates[1].contentWrapper.itemGrid.padding
                            local exceededContentHeight =  totalContentHeight - inventoryUI.gui.itemBox.templates[1].contentWrapper.height
                            if exceededContentHeight > 0 then
                                local slot_row = math.ceil(inventoryUI.attachedItemOnCursor.prevSlotIndex/maximumInventoryRowSlots)
                                local slot_offsetY = inventoryUI.gui.itemBox.templates[1].contentWrapper.padding + inventoryUI.gui.itemBox.templates[1].contentWrapper.itemGrid.padding + (math.max(0, slot_row - 1)*(inventoryUI.gui.itemBox.templates[1].contentWrapper.itemGrid.slot.size + inventoryUI.gui.itemBox.templates[1].contentWrapper.itemGrid.padding)) - (exceededContentHeight*itemBoxesCache[localPlayer].gui.scroller.percent*0.01)
                                local slot_prevOffsetY = inventoryUI.attachedItemOnCursor.prevPosY - itemBoxesCache[localPlayer].gui.startY - inventoryUI.gui.itemBox.templates[1].contentWrapper.startY
                                if (math.round(slot_offsetY, 2) ~= math.round(slot_prevOffsetY, 2)) then
                                    local finalScrollPercent = itemBoxesCache[localPlayer].gui.scroller.percent + ((slot_offsetY - slot_prevOffsetY)/exceededContentHeight)*100
                                    inventoryUI.attachedItemOnCursor.__scrollItemBox = {initial = itemBoxesCache[localPlayer].gui.scroller.percent, final = finalScrollPercent, tickCounter = getTickCount()}
                                end
                            end
                        else
                            local totalLootItems = 0
                            for index, _ in pairs(itemBoxesCache[inventoryUI.attachedItemOnCursor.itemBox].lootItems) do
                                totalLootItems = totalLootItems + 1
                            end
                            local template = inventoryUI.gui.itemBox.templates[(itemBoxesCache[inventoryUI.attachedItemOnCursor.itemBox].gui.templateIndex)]
                            local totalContentHeight = template.contentWrapper.itemSlot.startY + ((template.contentWrapper.itemSlot.paddingY + template.contentWrapper.itemSlot.height)*totalLootItems)
                            local exceededContentHeight =  totalContentHeight - template.contentWrapper.height
                            inventoryUI.attachedItemOnCursor.__finalWidth, inventoryUI.attachedItemOnCursor.__finalHeight = inventoryUI.attachedItemOnCursor.prevWidth, inventoryUI.attachedItemOnCursor.prevHeight
                            inventoryUI.attachedItemOnCursor.prevWidth, inventoryUI.attachedItemOnCursor.prevHeight = inventoryUI.attachedItemOnCursor.__width, inventoryUI.attachedItemOnCursor.__height
                            inventoryUI.attachedItemOnCursor.sizeAnimTickCounter = getTickCount()
                            if exceededContentHeight > 0 then
                                local slot_offsetY = template.contentWrapper.itemSlot.startY + ((template.contentWrapper.itemSlot.paddingY + template.contentWrapper.itemSlot.height)*(inventoryUI.attachedItemOnCursor.prevSlotIndex - 1)) + template.contentWrapper.itemSlot.paddingY - (exceededContentHeight*itemBoxesCache[inventoryUI.attachedItemOnCursor.itemBox].gui.scroller.percent*0.01)
                                local slot_prevOffsetY = inventoryUI.attachedItemOnCursor.prevPosY - itemBoxesCache[inventoryUI.attachedItemOnCursor.itemBox].gui.startY - template.contentWrapper.startY
                                if (math.round(slot_offsetY, 2) ~= math.round(slot_prevOffsetY, 2)) then
                                    local finalScrollPercent = itemBoxesCache[inventoryUI.attachedItemOnCursor.itemBox].gui.scroller.percent + ((slot_offsetY - slot_prevOffsetY)/exceededContentHeight)*100
                                    inventoryUI.attachedItemOnCursor.__scrollItemBox = {initial = itemBoxesCache[inventoryUI.attachedItemOnCursor.itemBox].gui.scroller.percent, final = finalScrollPercent, tickCounter = getTickCount()}
                                end
                            end
                        end
                        triggerEvent("onClientInventorySound", localPlayer, "inventory_rollback_item")
                    end
                end
                detachInventoryItem()
            end
            if not inventoryUI.attachedItemOnCursor.__finalWidth or not inventoryUI.attachedItemOnCursor.__finalHeight then
                inventoryUI.attachedItemOnCursor.__width, inventoryUI.attachedItemOnCursor.__height = interpolateBetween(inventoryUI.attachedItemOnCursor.prevWidth, inventoryUI.attachedItemOnCursor.prevHeight, 0, iconWidth, iconHeight, 0, getInterpolationProgress(inventoryUI.attachedItemOnCursor.sizeAnimTickCounter, inventoryUI.attachedItemAnimDuration/3), "OutBack")
            else
                inventoryUI.attachedItemOnCursor.__width, inventoryUI.attachedItemOnCursor.__height = interpolateBetween(inventoryUI.attachedItemOnCursor.prevWidth, inventoryUI.attachedItemOnCursor.prevHeight, 0, inventoryUI.attachedItemOnCursor.__finalWidth, inventoryUI.attachedItemOnCursor.__finalHeight, 0, getInterpolationProgress(inventoryUI.attachedItemOnCursor.sizeAnimTickCounter, inventoryUI.attachedItemAnimDuration/3), "OutBack")
            end
            if inventoryUI.attachedItemOnCursor.animTickCounter then
                local icon_offsetX, icon_offsetY = interpolateBetween(inventoryUI.attachedItemOnCursor.__posX, inventoryUI.attachedItemOnCursor.__posY, 0, inventoryUI.attachedItemOnCursor.prevPosX, inventoryUI.attachedItemOnCursor.prevPosY, 0, getInterpolationProgress(inventoryUI.attachedItemOnCursor.animTickCounter, inventoryUI.attachedItemAnimDuration), "OutBounce")
                if inventoryUI.attachedItemOnCursor.__scrollItemBox then
                    itemBoxesCache[(inventoryUI.attachedItemOnCursor.releaseLoot or inventoryUI.attachedItemOnCursor.itemBox)].gui.scroller.percent = interpolateBetween(inventoryUI.attachedItemOnCursor.__scrollItemBox.initial, 0, 0, inventoryUI.attachedItemOnCursor.__scrollItemBox.final, 0, 0, getInterpolationProgress(inventoryUI.attachedItemOnCursor.__scrollItemBox.tickCounter, inventoryUI.attachedItemAnimDuration), "OutBounce")
                end
                imports.beautify.native.drawImage(icon_offsetX, icon_offsetY, inventoryUI.attachedItemOnCursor.__width, inventoryUI.attachedItemOnCursor.__height, iconTextures[itemDetails.iconPath], 0, 0, 0, tocolor(255, 255, 255, 255), false)
                if (math.round(icon_offsetX, 2) == math.round(inventoryUI.attachedItemOnCursor.prevPosX, 2)) and (math.round(icon_offsetY, 2) == math.round(inventoryUI.attachedItemOnCursor.prevPosY, 2)) then
                    if inventoryUI.attachedItemOnCursor.releaseType and inventoryUI.attachedItemOnCursor.releaseType == "equipping" then
                        equipItemInInventory(inventoryUI.attachedItemOnCursor.item, inventoryUI.attachedItemOnCursor.releaseIndex, inventoryUI.attachedItemOnCursor.reservedSlot, inventoryUI.attachedItemOnCursor.prevSlotIndex, inventoryUI.attachedItemOnCursor.itemBox)
                    else
                        if inventoryUI.attachedItemOnCursor.itemBox ~= localPlayer then
                            if inventoryUI.attachedItemOnCursor.releaseType and inventoryUI.attachedItemOnCursor.releaseType == "ordering" then
                                if not inventoryUI.attachedItemOnCursor.isEquippedItem then
                                    moveItemInInventory(inventoryUI.attachedItemOnCursor.item, inventoryUI.attachedItemOnCursor.prevSlotIndex, inventoryUI.attachedItemOnCursor.itemBox)
                                end
                            end
                        else
                            if inventoryUI.attachedItemOnCursor.releaseType and inventoryUI.attachedItemOnCursor.releaseType == "dropping" then
                                if inventoryUI.attachedItemOnCursor.isEquippedItem then
                                    unequipItemInInventory(inventoryUI.attachedItemOnCursor.item, inventoryUI.attachedItemOnCursor.releaseIndex, inventoryUI.attachedItemOnCursor.prevSlotIndex, inventoryUI.attachedItemOnCursor.releaseLoot, inventoryUI.attachedItemOnCursor.reservedSlot)
                                else
                                    moveItemInLoot(inventoryUI.attachedItemOnCursor.item, inventoryUI.attachedItemOnCursor.releaseIndex, inventoryUI.attachedItemOnCursor.releaseLoot)
                                end
                            end
                        end
                    end
                    detachInventoryItem(true)
                end
            else
                local cursor_offsetX, cursor_offsetY = getAbsoluteCursorPosition()
                imports.beautify.native.drawImage(cursor_offsetX - inventoryUI.attachedItemOnCursor.offsetX, cursor_offsetY - inventoryUI.attachedItemOnCursor.offsetY, inventoryUI.attachedItemOnCursor.__width, inventoryUI.attachedItemOnCursor.__height, iconTextures[itemDetails.iconPath], 0, 0, 0, tocolor(255, 255, 255, 255), false)
            end
        end
    end

    prevScrollState = false

end
]]--

-----------------------------------------
--[[ Event: On Client Resource Start ]]--
-----------------------------------------

--[[
addEventHandler("onClientResourceStart", resource, function()

    for i, j in pairs(inventoryDatas) do
        for k, v in ipairs(j) do
            iconTextures[v.iconPath] = DxTexture(v.iconPath, "argb", true, "clamp")
            local originalWidth, originalHeight = dxGetMaterialSize(iconTextures[v.iconPath])
            iconDimensions[v.iconPath] = {width = originalWidth, height = originalHeight}
        end
    end

end)
]]