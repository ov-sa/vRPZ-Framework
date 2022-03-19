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
    unpackColor = unpackColor,
    isElement = isElement,
    destroyElement = destroyElement,
    addEvent = addEvent,
    addEventHandler = addEventHandler,
    bindKey = bindKey,
    getPlayerName = getPlayerName,
    showChat = showChat,
    showCursor = showCursor,
    string = string,
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


----------------------------------------
--[[ Client: On Toggle Inventory UI ]]--
----------------------------------------

inventoryUI.toggleUI = function(state)
    if state then
        if inventoryUI.isVisible then return false end
        inventoryUI.clientInventory.name = imports.string.upper(imports.string.spaceChars(imports.getPlayerName(localPlayer).."'s Inventory"))
        inventoryUI.opacityAdjuster.element = imports.beautify.slider.create(inventoryUI.opacityAdjuster.startX, inventoryUI.opacityAdjuster.startY, inventoryUI.opacityAdjuster.width, inventoryUI.opacityAdjuster.height, "vertical", nil, false)
        inventoryUI.opacityAdjuster.percent = inventoryUI.opacityAdjuster.percent or 100
        imports.beautify.slider.setPercent(inventoryUI.opacityAdjuster.element, inventoryUI.opacityAdjuster.percent)
        imports.beautify.slider.setText(inventoryUI.opacityAdjuster.element, "Opacity")
        imports.beautify.slider.setTextColor(inventoryUI.opacityAdjuster.element, FRAMEWORK_CONFIGS["UI"]["Inventory"].titlebar.fontColor)
        imports.beautify.render.create(inventoryUI.renderUI, {
            elementReference = inventoryUI.opacityAdjuster.element,
            renderType = "preRender"
        })
        imports.beautify.setUIVisible(inventoryUI.opacityAdjuster.element, true)
    else
        if not inventoryUI.isVisible then return false end
        inventoryUI.clientInventory.name = nil
        if inventoryUI.opacityAdjuster.element and imports.isElement(inventoryUI.opacityAdjuster.element) then
            imports.destroyElement(inventoryUI.opacityAdjuster.element)
        end
        inventoryUI.opacityAdjuster.element = nil
    end
    inventoryUI.isVisible = (state and true) or false
    imports.showChat(not inventoryUI.isVisible)
    imports.showCursor(inventoryUI.isVisible, true) --TODO: RMEOVE FORCED CHECK LATER
    return true
end

imports.addEvent("Client:onToggleInventoryUI", true)
imports.addEventHandler("Client:onToggleInventoryUI", root, inventoryUI.toggleUI)
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