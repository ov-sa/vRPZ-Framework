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

CGame.createExports({
    {exportName = "fetchInventory", moduleName = "CInventory", moduleMethod = "fetch"},
    {exportName = "ensureInventoryItems", moduleName = "CInventory", moduleMethod = "ensureItems"},
    {exportName = "createInventory", moduleName = "CInventory", moduleMethod = "create"},
    {exportName = "deleteInventory", moduleName = "CInventory", moduleMethod = "delete"},
    {exportName = "setInventoryData", moduleName = "CInventory", moduleMethod = "setData"},
    {exportName = "getInventoryData", moduleName = "CInventory", moduleMethod = "getData"},
    {exportName = "addInventoryItem", moduleName = "CInventory", moduleMethod = "addItem"},
    {exportName = "removeInventoryItem", moduleName = "CInventory", moduleMethod = "removeItem"},
    {exportName = "setInventoryItemProperty", moduleName = "CInventory", moduleMethod = "setItemProperty"},
    {exportName = "getInventoryItemProperty", moduleName = "CInventory", moduleMethod = "getItemProperty"},
    {exportName = "setInventoryItemData", moduleName = "CInventory", moduleMethod = "setItemData"},
    {exportName = "getInventoryItemData", moduleName = "CInventory", moduleMethod = "getItemData"},
    {exportName = "equipInventoryItem", moduleName = "CInventory", moduleMethod = "equipItem"}
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