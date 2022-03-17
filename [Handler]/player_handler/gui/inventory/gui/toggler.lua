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

function isInventoryVisible()

    return inventoryCache.state

end


-------------------------------------------------------
--[[ Function: Retrieves Inventory's Enabled State ]]--
-------------------------------------------------------

function isInventoryEnabled()

    if not inventoryCache.isSlotsUpdated then return false end

    return inventoryCache.enabled

end


------------------------------------------------------------
--[[ Function: Enables/Disables Inventory Enabled State ]]--
------------------------------------------------------------

function enableInventory(state)

    if state then
        if not inventoryCache.enabled then
            inventoryCache.enabled = true
            if not isPlayerKnocked(localPlayer) then
                toggleControl("enter_exit", true)
            end
        end
    else
        if inventoryCache.enabled then
            inventoryCache.enabled = false
            toggleControl("enter_exit", false)
        end
    end

end
addEvent("onClientEnableInventory", true)
addEventHandler("onClientEnableInventory", root, enableInventory)


-----------------------------------------------
--[[ Event: On Client Inventory Sync Slots ]]--
-----------------------------------------------

addEvent("onClientInventorySyncSlots", true)
addEventHandler("onClientInventorySyncSlots", root, function(slotData)

    inventoryCache.inventorySlots = slotData
    inventoryCache.isSlotsUpdatePending = false
    inventoryCache.isSlotsUpdated = true

end)


-------------------------------------------
--[[ Event: On Client Inventory Update ]]--
-------------------------------------------

local function inventoryUpdate()

    inventoryCache.attachedItemOnCursor = nil
    updateItemBox(localPlayer)
    updateItemBox(inventoryCache.vicinity)

end
addEvent("onClientInventoryUpdate", true)
addEventHandler("onClientInventoryUpdate", root, inventoryUpdate)


------------------------------------------
--[[ Functions: Shows/Hides Inventory ]]--
------------------------------------------

function showInventory()

    if not isPlayerInitialized(localPlayer) or getPlayerHealth(localPlayer) <= 0 then closeInventory() return false end
    if inventoryCache.state then return false end
    
    createItemBox(inventoryCache.gui.equipment.startX + 250 + 50, inventoryCache.gui.equipment.startY + 25, 1, localPlayer, "Inventory")
    inventoryCache.vicinity = isPlayerInLoot(localPlayer)
    if inventoryCache.vicinity and isElement(inventoryCache.vicinity) then
        local vicinityLockedStatus = inventoryCache.vicinity:getData("Loot:Locked")
        if vicinityLockedStatus then
            inventoryCache.vicinity = false
            triggerEvent("onDisplayNotification", localPlayer, "Unfortunately, loot's inventory is locked!", {255, 80, 80, 255})
        else
            createItemBox(inventoryCache.gui.equipment.startX - inventoryCache.gui.itemBox.templates[2].width - 15, inventoryCache.gui.equipment.startY, 2, inventoryCache.vicinity)
        end
    end

    addEventHandler("onClientRender", root, displayInventoryUI)
    triggerEvent("onClientInventorySound", localPlayer, "inventory_open")
    inventoryCache.state = true
    showChat(false)
    showCursor(true)
    inventoryUpdate()

end

function closeInventory()

    if not inventoryCache.state then return false end

    if inventoryCache.isSlotsUpdatePending then
        triggerServerEvent("onClientRequestSyncInventorySlots", localPlayer)
    end
    detachInventoryItem(true)
    destroyItemBox(localPlayer)
    destroyItemBox(inventoryCache.vicinity)
    removeEventHandler("onClientRender", root, displayInventoryUI)
    inventoryCache.vicinity = nil
    inventoryCache.attachedItemOnCursor = nil
    inventoryCache.state = false
    showChat(true)
    showCursor(false)

end

bindKey("tab", "down", function()
    if isInventoryVisible() then
        closeInventory()
    else
        showInventory()
    end
end)


----------------------------------------
--[[ Event: On Client Player Wasted ]]--
----------------------------------------

addEventHandler("onClientPlayerWasted", localPlayer, function()

    closeInventory()
    inventoryCache.hotBarTable = {}

end)