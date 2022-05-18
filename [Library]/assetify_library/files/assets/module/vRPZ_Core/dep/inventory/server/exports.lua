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
    {exportName = "getInventoryItemData", moduleName = "CInventory", moduleMethod = "getItemData"}
})


----------------
--[[ Events ]]--
----------------

imports.addEvent("Player:onAddItem", true)
imports.addEventHandler("Player:onAddItem", root, function(parent, item, slot)
    if not CPlayer.isInitialized(source) then return false end
    local characterID = CPlayer.getCharacterID(source)
    local inventoryID = CPlayer.getInventoryID(source)
    if parent and item and slot then
        if CInventory.isSlotAvailableForOrdering(source, item, slot) then
            CInventory.addItemCount(source, item, 1)
            CInventory.removeItemCount(parent, item, 1)
            CInventory.CBuffer[inventoryID].slots[slot] = {item = item}
            if FRAMEWORK_CONFIGS["Templates"]["Inventory"]["Slots"][slot] then
                --TODO: Add AND UPDATE ATTACHMENT...
            end
        end
    end
    imports.triggerClientEvent(source, "Client:onSyncInventoryBuffer", source, CInventory.CBuffer[inventoryID])
end)

imports.addEvent("Player:onOrderItem", true)
imports.addEventHandler("Player:onOrderItem", root, function(item, prevSlot, slot)
    if not CPlayer.isInitialized(source) then return false end
    local characterID = CPlayer.getCharacterID(source)
    local inventoryID = CPlayer.getInventoryID(source)
    if item and prevSlot and slot then
        if CInventory.isSlotAvailableForOrdering(source, item, slot, true) then
            CInventory.CBuffer[inventoryID].slots[prevSlot] = nil
            CInventory.CBuffer[inventoryID].slots[slot] = {item = item}
            if FRAMEWORK_CONFIGS["Templates"]["Inventory"]["Slots"][prevSlot] then
                --TODO: REMOVE AND UPDATE ATTACHMENT...
            end
            if FRAMEWORK_CONFIGS["Templates"]["Inventory"]["Slots"][slot] then
                --TODO: Add AND UPDATE ATTACHMENT...
            end
        end
    end
    imports.triggerClientEvent(source, "Client:onSyncInventoryBuffer", source, CInventory.CBuffer[inventoryID])
end)

imports.addEvent("Player:onDropItem", true)
imports.addEventHandler("Player:onDropItem", root, function(vicinity, item, prevSlot)
    if not CPlayer.isInitialized(source) then return false end
    local characterID = CPlayer.getCharacterID(source)
    local inventoryID = CPlayer.getInventoryID(source)
    if parent and item and prevSlot and CInventory.isVicinityAvailableForDropping(vicinity, item) then
        CInventory.addItemCount(vicinity, item, 1)
        CInventory.removeItemCount(source, item, 1)
        CInventory.CBuffer[inventoryID].slots[prevSlot] = nil
    end
    imports.triggerClientEvent(source, "Client:onSyncInventoryBuffer", source, CInventory.CBuffer[inventoryID])
end)