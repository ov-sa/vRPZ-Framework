-----------------
--[[ Imports ]]--
-----------------

local imports = {
    addEvent = addEvent,
    addEventHandler = addEventHandler,
    triggerClientEvent = triggerClientEvent
}


-----------------
--[[ Exports ]]--
-----------------

CGame.exportModule("CInventory", {
    "fetch",
    "ensureItems",
    "create",
    "delete",
    "setData",
    "getData",
    "addItem",
    "removeItem",
    "setItemProperty",
    "getItemProperty",
    "setItemData",
    "getItemData",
    "equipItem"
})


----------------
--[[ Events ]]--
----------------

imports.addEvent("Player:onAddItem", true)
imports.addEventHandler("Player:onAddItem", root, function(vicinity, item, slot)
    if not CPlayer.isInitialized(source) then return false end
    local inventoryID = CPlayer.getInventoryID(source)
    if CInventory.isSlotAvailableForOrdering(source, item, _, slot) then
        CInventory.addItemCount(source, item, 1)
        CInventory.removeItemCount(vicinity, item, 1)
        if FRAMEWORK_CONFIGS["Templates"]["Inventory"]["Slots"][slot] then return CInventory.equipItem(source, item, _, slot) end
        CInventory.CBuffer[inventoryID].slots[slot] = {item = item}
    end
    imports.triggerClientEvent(source, "Client:onSyncInventoryBuffer", source, CInventory.CBuffer[inventoryID])
end)

imports.addEvent("Player:onOrderItem", true)
imports.addEventHandler("Player:onOrderItem", root, function(item, prevSlot, slot)
    if not CPlayer.isInitialized(source) then return false end
    if FRAMEWORK_CONFIGS["Templates"]["Inventory"]["Slots"][slot] then return CInventory.equipItem(source, item, prevSlot, slot, true) end
    if FRAMEWORK_CONFIGS["Templates"]["Inventory"]["Slots"][prevSlot] then return CInventory.dequipItem(source, item, prevSlot, slot, true) end
    local inventoryID = CPlayer.getInventoryID(source)
    if CInventory.isSlotAvailableForOrdering(source, item, prevSlot, slot, true) then
        CInventory.CBuffer[inventoryID].slots[prevSlot] = nil
        CInventory.CBuffer[inventoryID].slots[slot] = {item = item}
    end
    imports.triggerClientEvent(source, "Client:onSyncInventoryBuffer", source, CInventory.CBuffer[inventoryID])
end)

imports.addEvent("Player:onDropItem", true)
imports.addEventHandler("Player:onDropItem", root, function(vicinity, item, amount, prevSlot)
    if not CPlayer.isInitialized(source) then return false end
    local inventoryID = CPlayer.getInventoryID(source)
    if prevSlot and CInventory.isVicinityAvailableForDropping(vicinity, item, amount) then
        CInventory.addItemCount(vicinity, item, amount)
        CInventory.removeItemCount(source, item, amount)
        if FRAMEWORK_CONFIGS["Templates"]["Inventory"]["Slots"][prevSlot] then return CInventory.dequipItem(source, item, prevSlot) end
        CInventory.CBuffer[inventoryID].slots[prevSlot] = nil
    end
    imports.triggerClientEvent(source, "Client:onSyncInventoryBuffer", source, CInventory.CBuffer[inventoryID])
end)