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
    addEvent = addEvent,
    addEventHandler = addEventHandler,
    bindKey = bindKey,
    beautify = beautify
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
        --local panel_offsetY = inventoryUI.titlebar.height + inventoryUI.titlebar.paddingY
        inventoryUI.clientInventory.element = imports.beautify.card.create(inventoryUI.clientInventory.startX, inventoryUI.clientInventory.startY, inventoryUI.clientInventory.width, inventoryUI.clientInventory.height, nil, false)
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
            imports.beautify.native.drawRectangle(0, 0, inventoryUI.width, inventoryUI.titlebar.height, inventoryUI.titlebar.bgColor, false)
            imports.beautify.native.drawText(imports.string.upper(imports.string.spaceChars(FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].characters.titlebar["Titles"][FRAMEWORK_LANGUAGE])), 0, 0, inventoryUI.width, inventoryUI.titlebar.height, inventoryUI.titlebar.fontColor, 1, inventoryUI.titlebar.font, "center", "center", true, false, false)
            imports.beautify.native.drawRectangle(0, inventoryUI.titlebar.height, inventoryUI.width, inventoryUI.titlebar.paddingY, inventoryUI.titlebar.shadowColor, false)
            for i = 1, #inventoryUI.categories, 1 do
                local j = inventoryUI.categories[i]
                local category_offsetY = j.offsetY + inventoryUI.categories.height
                imports.beautify.native.drawRectangle(0, j.offsetY, inventoryUI.width, inventoryUI.categories.height, inventoryUI.titlebar.bgColor, false)
                imports.beautify.native.drawText(j.title, 0, j.offsetY, inventoryUI.width, category_offsetY, inventoryUI.categories.fontColor, 1, inventoryUI.categories.font, "center", "center", true, false, false)
                imports.beautify.native.drawRectangle(0, category_offsetY, inventoryUI.width, j.height, inventoryUI.categories.bgColor, false)
                if j.contents then
                    for k, v in imports.pairs(j.contents) do
                        local title_height = inventoryUI.categories.height
                        local title_offsetY = category_offsetY + v.startY - title_height
                        imports.beautify.native.drawRectangle(0, title_offsetY, inventoryUI.width, title_height, inventoryUI.titlebar.bgColor, false)
                        imports.beautify.native.drawText(v.title, 0, title_offsetY, inventoryUI.width, title_offsetY + title_height, inventoryUI.titlebar.fontColor, 1, inventoryUI.categories.font, "center", "center", true, false, false)
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
    imports.showCursor(inventoryUI.isVisible)
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