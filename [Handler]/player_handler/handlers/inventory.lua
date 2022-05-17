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


-------------------------------
--[[ Player: On Order Item ]]--
-------------------------------

imports.addEvent("Player:onAddItem", true)
imports.addEventHandler("Player:onAddItem", root, function(parent, item, prevSlot, newSlot, amount)
    if not CPlayer.isInitialized(source) then return false end
    prevSlot, newSlot, amount = imports.tonumber(prevSlot), imports.tonumber(newSlot), imports.tonumber(amount)
    local characterID = CPlayer.getCharacterID(source)
    local inventoryID = CPlayer.getInventoryID(source)

    print("WOOW 1: "..tostring(item).." : "..tostring(prevSlot).." : "..tostring(newSlot))
    if item and prevSlot and newSlot and amount and CInventory.isSlotAvailableForOrdering(source, item, newSlot) then
        print("WOOW 2")
        addItemCount(source, item, amount)
        removeItemCount(parent, item, amount)
        --TODO: WHY IS IT CLEARING WHEN VICINITY TO INVENTORY?
        --playerInventorySlots[source].slots[prevSlot] = nil --TODO: ONLY FOR ORDER
        CInventory.CBuffer[inventoryID].slots[newSlot] = {
            item = item
        }
    end
    --TODO: MAKE FUNCTON TO GET PLAYER;'S INVENTORY ID' and CHAR ID
    imports.triggerClientEvent(source, "Client:onSyncInventoryBuffer", source, CInventory.CBuffer[inventoryID])
end)


-------------------------------
--[[ Player: On Order Item ]]--
-------------------------------

imports.addEvent("Player:onOrderItem", true)
imports.addEventHandler("Player:onOrderItem", root, function(item, prevSlot, newSlot)

end)