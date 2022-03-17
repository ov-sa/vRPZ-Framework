----------------------------------------------------------------
--[[ Resource: Player Handler
     Script: handlers: inventory: gui: toggler.lua
     Server: -
     Author: OvileAmriam
     Developer: -
     DOC: 18/12/2020 (OvileAmriam)
     Desc: Inventory Toggler ]]--
----------------------------------------------------------------


----------------------------------------------------
--[[ Function: Retrieves Inventory's Visibility ]]--
----------------------------------------------------

isVisible = false
isSlotsUpdated = false
isEnabled = false

inventoryUI.isUIEnabled = function()
    return (inventoryUI.isSlotsUpdated and inventoryUI.isEnabled) or false
end

imports.addEvent("Client:onEnableInventoryUI", true)
imports.addEventHandler("Client:onEnableInventoryUI", root, function(state, isForced)
    if isForced then loginUI.isForcedDisabled = not state end
    inventoryUI.isEnabled = state
end)


-----------------------------------------------
--[[ Event: On Client Inventory Sync Slots ]]--
-----------------------------------------------

addEvent("Client:onSyncInventorySlots", true)
addEventHandler("Client:onSyncInventorySlots", root, function(slotData)
    inventoryUI.inventorySlots = slotData
    inventoryUI.isSlotsUpdatePending = false
    inventoryUI.isSlotsUpdated = true
end)


-------------------------------------------
--[[ Event: On Client Inventory Update ]]--
-------------------------------------------

local function inventoryUpdate()

    inventoryUI.attachedItemOnCursor = nil
    updateItemBox(localPlayer)
    updateItemBox(inventoryUI.vicinity)

end
addEvent("onClientInventoryUpdate", true)
addEventHandler("onClientInventoryUpdate", root, inventoryUpdate)


------------------------------------------
--[[ Functions: Shows/Hides Inventory ]]--
------------------------------------------

function showInventory()

    if not isPlayerInitialized(localPlayer) or getPlayerHealth(localPlayer) <= 0 then closeInventory() return false end
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

    addEventHandler("onClientRender", root, displayInventoryUI)
    triggerEvent("onClientInventorySound", localPlayer, "inventory_open")
    inventoryUI.isVisible = true
    showChat(false)
    showCursor(true)
    inventoryUpdate()

end

function closeInventory()

    if not inventoryUI.isVisible then return false end

    if inventoryUI.isSlotsUpdatePending then
        triggerServerEvent("onClientRequestSyncInventorySlots", localPlayer)
    end
    detachInventoryItem(true)
    destroyItemBox(localPlayer)
    destroyItemBox(inventoryUI.vicinity)
    removeEventHandler("onClientRender", root, displayInventoryUI)
    inventoryUI.vicinity = nil
    inventoryUI.attachedItemOnCursor = nil
    inventoryUI.isVisible = false
    showChat(true)
    showCursor(false)

end

imports.addEventHandler("onClientPlayerWasted", localPlayer, function() closeInventory() end)

imports.bindKey("tab", "down", function()
    if inventoryUI.isVisible() then
        closeInventory()
    else
        showInventory()
    end
end)