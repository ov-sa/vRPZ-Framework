----------------------------------------------------------------
--[[ Resource: Player Handler
     Script: handlers: inventory.lua
     Author: vStudio
     Developer(s): Mario, Tron, Aviril, Аниса
     DOC: 31/01/2022
     Desc: Inventory Handler ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local imports = {
    tonumber = tonumber,
    addEvent = addEvent,
    addEventHandler = addEventHandler,
    triggerClientEvent = triggerClientEvent
}


createPed(0, 0, 0, 0)--TODO: REMOVE LATER
-------------------------------
--[[ Player: On Order Item ]]--
-------------------------------

imports.addEvent("Player:onAddItem", true)
imports.addEventHandler("Player:onAddItem", root, function(parent, item, slot)
    if not CPlayer.isInitialized(source) then return false end
    slot = imports.tonumber(slot)

    local characterID = CPlayer.getCharacterID(source)
    local inventoryID = CPlayer.getInventoryID(source)
    print("WOOW 1: "..tostring(item).." : "..tostring(slot))
    if item and slot and CInventory.isSlotAvailableForOrdering(source, item, slot) then
        print("WOOW 2")
        CInventory.addItemCount(source, item, 1)
        CInventory.removeItemCount(parent, item, 1)
        --TODO: WHY IS IT CLEARING WHEN VICINITY TO INVENTORY?
        --playerInventorySlots[source].slots[prevSlot] = nil --TODO: ONLY FOR ORDER
        CInventory.CBuffer[inventoryID].slots[slot] = {
            item = item
        }
    end
    imports.triggerClientEvent(source, "Client:onSyncInventoryBuffer", source, CInventory.CBuffer[inventoryID])
end)


-------------------------------
--[[ Player: On Order Item ]]--
-------------------------------

imports.addEvent("Player:onOrderItem", true)
imports.addEventHandler("Player:onOrderItem", root, function(item, prevSlot, newSlot)
    if not CPlayer.isInitialized(source) then return false end
    prevSlot, newSlot = imports.tonumber(prevSlot), imports.tonumber(newSlot)

    local characterID = CPlayer.getCharacterID(source)
    local inventoryID = CPlayer.getInventoryID(source)
    if item and prevSlot and newSlot and CInventory.isSlotAvailableForOrdering(source, item, newSlot) then
        CInventory.CBuffer[inventoryID].slots[prevSlot] = nil
        CInventory.CBuffer[inventoryID].slots[newSlot] = {
            item = item
        }
    end
    imports.triggerClientEvent(source, "Client:onSyncInventoryBuffer", source, CInventory.CBuffer[inventoryID])
end)