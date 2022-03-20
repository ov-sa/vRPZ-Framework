--[[
function inventoryUI.toggleUI(true)    
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
    detachInventoryItem(true)
    destroyItemBox(localPlayer)
    destroyItemBox(inventoryUI.vicinity)
    inventoryUI.vicinity = nil
end
]]