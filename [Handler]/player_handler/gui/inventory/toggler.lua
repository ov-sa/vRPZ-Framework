----------------------------------------------------------------
--[[ Resource: Player Handler
     Script: handlers: inventory: gui: toggler.lua
     Server: -
     Author: OvileAmriam
     Developer: -
     DOC: 18/12/2020 (OvileAmriam)
     Desc: Inventory Toggler ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local imports = {
    isElement = isElement,
    destroyElement = destroyElement,
    addEvent = addEvent,
    addEventHandler = addEventHandler,
    bindKey = bindKey,
    showChat = showChat,
    showCursor = showCursor,
    beautify = beautify,
    string = string,
}


-------------------------------
--[[ Functions: UI Helpers ]]--
-------------------------------

inventoryUI.isUIEnabled = function()
    return (inventoryUI.isUpdated and inventoryUI.isEnabled) or false
end

imports.addEvent("Client:onSyncInventorySlots", true)
imports.addEventHandler("Client:onSyncInventorySlots", root, function(slots)
    inventoryUI.slots = slots
    inventoryUI.isUpdated, inventoryUI.isUpdateScheduled = true, false
end)

imports.addEvent("Client:onEnableInventoryUI", true)
imports.addEventHandler("Client:onEnableInventoryUI", root, function(state, isForced)
    if isForced then loginUI.isForcedDisabled = not state end
    inventoryUI.isEnabled = state
end)

imports.addEvent("Client:onUpdateInventoryUI", true)
imports.addEventHandler("Client:onUpdateInventoryUI", root, function()
    inventoryUI.attachedItemOnCursor = nil
    updateItemBox(localPlayer)
    updateItemBox(inventoryUI.vicinity)
end)


------------------------------------------
--[[ Functions: Shows/Hides Inventory ]]--
------------------------------------------


inventoryUI.toggleUI = function(state)
    if state then
        if inventoryUI.clientInventory.element and imports.isElement(inventoryUI.clientInventory.element) then return false end
        --local panel_offsetY = inventoryUI.clientInventory.equipment.titlebar.height + inventoryUI.clientInventory.equipment.titlebar.paddingY
        inventoryUI.clientInventory.element = imports.beautify.card.create(inventoryUI.clientInventory.equipment.startX, inventoryUI.clientInventory.equipment.startY, 1366, 768, nil, false)
        imports.beautify.setUIVisible(inventoryUI.clientInventory.element, true)
        --[[
        for i = 1, #inventoryUI.categories, 1 do
            local j = inventoryUI.categories[i]
            j.offsetY = (inventoryUI.categories[(i - 1)] and (inventoryUI.categories[(i - 1)].offsetY + inventoryUI.categories.height + inventoryUI.categories[(i - 1)].height + inventoryUI.categories.paddingY)) or panel_offsetY
            if j.contents then
                for k, v in imports.pairs(j.contents) do
                    if v.isSlider then
                        v.element = imports.beautify.slider.create(inventoryUI.categories.paddingX, j.offsetY + inventoryUI.categories.height + v.startY + v.paddingY, inventoryUI.width - (inventoryUI.categories.paddingX*2), v.height, "horizontal", inventoryUI.clientInventory.element, false)
                        imports.beautify.setUIVisible(v.element, true)
                        imports.addEventHandler("onClientUISliderAltered", v.element, function() inventoryUI.updateCharacter() end)
                    elseif v.isSelector then
                        v.element = imports.beautify.selector.create(inventoryUI.categories.paddingX, j.offsetY + inventoryUI.categories.height + v.startY, inventoryUI.width - (inventoryUI.categories.paddingX*2), v.height, "horizontal", inventoryUI.clientInventory.element, false)
                        imports.beautify.selector.setDataList(v.element, v.content)
                        imports.beautify.setUIVisible(v.element, true)
                        imports.addEventHandler("onClientUISelectionAltered", v.element, function() inventoryUI.updateCharacter() end)
                    end
                end
            elseif j.isSelector then
                j.element = imports.beautify.selector.create(inventoryUI.categories.paddingX, j.offsetY + inventoryUI.categories.height, inventoryUI.width - (inventoryUI.categories.paddingX*2), j.height, "horizontal", inventoryUI.clientInventory.element, false)
                imports.beautify.selector.setDataList(j.element, j.content)
                imports.beautify.setUIVisible(j.element, true)
                imports.addEventHandler("onClientUISelectionAltered", j.element, function() inventoryUI.updateCharacter() end)
            end
        end
        ]]
        imports.beautify.render.create(function()
            
            --[[
            imports.beautify.native.drawRectangle(0, 0, inventoryUI.clientInventory.equipment.width, inventoryUI.clientInventory.equipment.titlebar.height, inventoryUI.clientInventory.equipment.titlebar.bgColor, false)
            imports.beautify.native.drawRectangle(0, inventoryUI.clientInventory.equipment.titlebar.height, inventoryUI.clientInventory.equipment.width, inventoryUI.clientInventory.equipment.height, inventoryUI.clientInventory.equipment.bgColor, false)
            imports.beautify.native.drawText(imports.string.upper(imports.string.spaceChars("Equipment")), 0, 0, inventoryUI.clientInventory.equipment.width, inventoryUI.clientInventory.equipment.titlebar.height, inventoryUI.clientInventory.equipment.titlebar.fontColor, 1, inventoryUI.clientInventory.equipment.titlebar.font, "center", "center", true, false, false)
            for i, j in ipairs(inventoryUI.clientInventory.equipment.slots) do
                --imports.beautify.native.drawRectangle(j.startX, j.startY, j.width, j.height, tocolor(10, 10, 10, 255), false)
                if not j.isUsed then
                    imports.beautify.native.drawImage(0, inventoryUI.clientInventory.equipment.titlebar.height, inventoryUI.clientInventory.equipment.width, inventoryUI.clientInventory.equipment.height, j.bgTexture, 0, 0, 0, tocolor(255, 255, 255, 255), false)
                end
            end
            ]]

            imports.beautify.native.drawRectangle(inventoryUI.clientInventory.equipment.width + inventoryUI.clientInventory.marginX, 0, inventoryUI.clientInventory.width, inventoryUI.clientInventory.equipment.titlebar.height, inventoryUI.clientInventory.equipment.titlebar.bgColor, false)
            imports.beautify.native.drawRectangle(inventoryUI.clientInventory.equipment.width + inventoryUI.clientInventory.marginX, inventoryUI.clientInventory.equipment.titlebar.height, inventoryUI.clientInventory.width, inventoryUI.clientInventory.equipment.height, inventoryUI.clientInventory.equipment.bgColor, false)
            local playerName = getPlayerName(localPlayer)
            imports.beautify.native.drawText(imports.string.upper(imports.string.spaceChars(playerName.."'s Inventory")), inventoryUI.clientInventory.equipment.width + inventoryUI.clientInventory.marginX, 0, inventoryUI.clientInventory.equipment.width + inventoryUI.clientInventory.marginX + inventoryUI.clientInventory.width, inventoryUI.clientInventory.equipment.titlebar.height, inventoryUI.clientInventory.equipment.titlebar.fontColor, 1, inventoryUI.clientInventory.equipment.titlebar.font, "center", "center", true, false, false)
            
            local gridStartX, gridStartY = inventoryUI.clientInventory.equipment.width + inventoryUI.clientInventory.marginX, inventoryUI.clientInventory.equipment.titlebar.height + inventoryUI.clientInventory.grids.slotSize
            local gridColor = tocolor(FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].characters.categories.fontColor[1], FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].characters.categories.fontColor[2], FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].characters.categories.fontColor[3], 50)
            for i = 1, inventoryUI.clientInventory.grids.rows - 1, 1 do
                imports.beautify.native.drawRectangle(inventoryUI.clientInventory.equipment.width + inventoryUI.clientInventory.marginX + inventoryUI.clientInventory.grids.padding, gridStartY, inventoryUI.clientInventory.width - (inventoryUI.clientInventory.grids.padding*2), 1, gridColor, false)
                gridStartY = gridStartY + inventoryUI.clientInventory.grids.slotSize + inventoryUI.clientInventory.grids.padding
            end
            for i = 1, inventoryUI.clientInventory.grids.columns - 1, 1 do
                if (i > 1) then
                    imports.beautify.native.drawRectangle(gridStartX, inventoryUI.clientInventory.equipment.titlebar.height + inventoryUI.clientInventory.grids.padding, 1, inventoryUI.clientInventory.equipment.height - (inventoryUI.clientInventory.grids.padding*2), gridColor, false)
                end
                gridStartX = gridStartX + inventoryUI.clientInventory.grids.slotSize + inventoryUI.clientInventory.grids.padding
            end


            for i, j in ipairs(inventoryUI.clientInventory.equipment.bottomTest) do
                local titleX, titleY = inventoryUI.clientInventory.equipment.width + inventoryUI.clientInventory.marginX + j.startX, gridStartY + j.startY
                local titleWidth, titleHeight = j.width, j.height
                local titlebarheigh = 20
                imports.beautify.native.drawRectangle(titleX, titleY - titlebarheigh, j.width, titlebarheigh, inventoryUI.clientInventory.equipment.rightTest.bgColor, false)
                imports.beautify.native.drawText(imports.string.upper(imports.string.spaceChars(j.title)), titleX, titleY - titlebarheigh + 2, titleX + titleWidth, titleY, inventoryUI.clientInventory.equipment.rightTest.fontColor, 1, inventoryUI.clientInventory.equipment.rightTest.font, "center", "center", true, false, false)
                imports.beautify.native.drawRectangle(titleX, titleY, titleWidth, titleHeight, inventoryUI.clientInventory.equipment.bgColor, false)
            end
            for i, j in ipairs(inventoryUI.clientInventory.equipment.rightTest) do
                local titleX, titleY = inventoryUI.clientInventory.equipment.width + inventoryUI.clientInventory.marginX - j.startX - j.width, inventoryUI.clientInventory.equipment.titlebar.height + j.startY
                local titleWidth, titleHeight = j.width, j.height
                local titlebarheigh = 20
                imports.beautify.native.drawRectangle(titleX, titleY - titlebarheigh, j.width, titlebarheigh, inventoryUI.clientInventory.equipment.rightTest.bgColor, false)
                imports.beautify.native.drawText(imports.string.upper(imports.string.spaceChars(j.title)), titleX, titleY - titlebarheigh + 2, titleX + titleWidth, titleY, inventoryUI.clientInventory.equipment.rightTest.fontColor, 1, inventoryUI.clientInventory.equipment.rightTest.font, "center", "center", true, false, false)
                imports.beautify.native.drawRectangle(titleX, titleY, titleWidth, titleHeight, inventoryUI.clientInventory.equipment.bgColor, false)
            end
            for i, j in ipairs(inventoryUI.clientInventory.equipment.leftTest) do
                local titlebarheigh = 20
                local titleX, titleY = inventoryUI.clientInventory.equipment.width + inventoryUI.clientInventory.marginX + inventoryUI.clientInventory.width + j.startX, gridStartY - j.startY - j.height
                local titleWidth, titleHeight = j.width, j.height
                imports.beautify.native.drawRectangle(titleX, titleY - titlebarheigh, j.width, titlebarheigh, inventoryUI.clientInventory.equipment.rightTest.bgColor, false)
                imports.beautify.native.drawText(imports.string.upper(imports.string.spaceChars(j.title)), titleX, titleY - titlebarheigh + 2, titleX + titleWidth, titleY, inventoryUI.clientInventory.equipment.rightTest.fontColor, 1, inventoryUI.clientInventory.equipment.rightTest.font, "center", "center", true, false, false)
                imports.beautify.native.drawRectangle(titleX, titleY, titleWidth, titleHeight, inventoryUI.clientInventory.equipment.bgColor, false)
            end
            --[[
            imports.beautify.native.drawText(imports.string.upper(imports.string.spaceChars(FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].characters.titlebar["Titles"][FRAMEWORK_LANGUAGE])), 0, 0, inventoryUI.width, inventoryUI.clientInventory.equipment.titlebar.height, inventoryUI.clientInventory.equipment.titlebar.fontColor, 1, inventoryUI.clientInventory.equipment.titlebar.font, "center", "center", true, false, false)
            imports.beautify.native.drawRectangle(0, inventoryUI.clientInventory.equipment.titlebar.height, inventoryUI.width, inventoryUI.clientInventory.equipment.titlebar.paddingY, inventoryUI.clientInventory.equipment.titlebar.shadowColor, false)
            for i = 1, #inventoryUI.categories, 1 do
                local j = inventoryUI.categories[i]
                local category_offsetY = j.offsetY + inventoryUI.categories.height
                imports.beautify.native.drawRectangle(0, j.offsetY, inventoryUI.width, inventoryUI.categories.height, inventoryUI.clientInventory.equipment.titlebar.bgColor, false)
                imports.beautify.native.drawText(j.title, 0, j.offsetY, inventoryUI.width, category_offsetY, inventoryUI.categories.fontColor, 1, inventoryUI.categories.font, "center", "center", true, false, false)
                imports.beautify.native.drawRectangle(0, category_offsetY, inventoryUI.width, j.height, inventoryUI.categories.bgColor, false)
                if j.contents then
                    for k, v in imports.pairs(j.contents) do
                        local title_height = inventoryUI.categories.height
                        local title_offsetY = category_offsetY + v.startY - title_height
                        imports.beautify.native.drawRectangle(0, title_offsetY, inventoryUI.width, title_height, inventoryUI.clientInventory.equipment.titlebar.bgColor, false)
                        imports.beautify.native.drawText(v.title, 0, title_offsetY, inventoryUI.width, title_offsetY + title_height, inventoryUI.clientInventory.equipment.titlebar.fontColor, 1, inventoryUI.categories.font, "center", "center", true, false, false)
                    end
                end
            end
            ]]
        end, {
            elementReference = inventoryUI.clientInventory.element,
            renderType = "preViewRTRender"
        })
    else
        if not inventoryUI.clientInventory.element or not imports.isElement(inventoryUI.clientInventory.element) then return false end
        imports.destroyElement(inventoryUI.clientInventory.element)
        inventoryUI.clientInventory.element = nil
    end
    inventoryUI.isVisible = (state and true) or false
    imports.showChat(not inventoryUI.isVisible)
    imports.showCursor(inventoryUI.isVisible, true) --TODO: RMEOVE FORCED CHECK LATER
    return true
end
imports.bindKey(FRAMEWORK_CONFIGS["Inventory"]["UI_ToggleKey"], "down", function() inventoryUI.toggleUI(not inventoryUI.isVisible) end)
imports.addEventHandler("onClientPlayerWasted", localPlayer, function() inventoryUI.toggleUI(false) end)


--[[
function inventoryUI.toggleUI(true)

    if not isPlayerInitialized(localPlayer) or getPlayerHealth(localPlayer) <= 0 then inventoryUI.toggleUI(false) return false end
    if inventoryUI.isVisible then return false end
    
    createItemBox(inventoryUI.gui.equipment.startX + 250 + 50, inventoryUI.gui.equipment.startY + 25, 1, localPlayer, "Inventory")
    inventoryUI.vicinity = isPlayerInLoot(localPlayer)
    if inventoryUI.vicinity and isElement(inventoryUI.vicinity) then
        local vicinityLockedStatus = inventoryUI.vicinity:getData("Loot:Locked")
        if vicinityLockedStatus then
            inventoryUI.vicinity = false
            triggerEvent("onDisplayNotification", localPlayer, "Unfortunately, loot's inventory is locked!", {255, 80, 80, 255})
        else
            createItemBox(inventoryUI.gui.equipment.startX - inventoryUI.gui.itemBox.templates[2].width - 15, inventoryUI.gui.equipment.startY, 2, inventoryUI.vicinity)
        end
    end
    triggerEvent("onClientInventorySound", localPlayer, "inventory_open")
    showChat(false)
    showCursor(true)
    triggerEvent("Client:onUpdateInventoryUI", localPlayer)
    inventoryUpdate()

end

function inventoryUI.toggleUI(false)

    if not inventoryUI.isVisible then return false end

    if inventoryUI.isUpdateScheduled then
        triggerServerEvent("onClientRequestSyncInventorySlots", localPlayer)
    end
    detachInventoryItem(true)
    destroyItemBox(localPlayer)
    destroyItemBox(inventoryUI.vicinity)
    inventoryUI.vicinity = nil
    inventoryUI.attachedItemOnCursor = nil
    showChat(true)
    showCursor(false)

end
]]