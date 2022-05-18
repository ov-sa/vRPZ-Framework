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

--[[
imports.addEvent("Player:onAddItem", true)
imports.addEventHandler("Player:onAddItem", root, function(parent, item, slot)
    if not CPlayer.isInitialized(source) then return false end
    slot = imports.tonumber(slot)
    local characterID = CPlayer.getCharacterID(source)
    local inventoryID = CPlayer.getInventoryID(source)
    if item and slot and CInventory.isSlotAvailableForOrdering(source, item, slot) then
        CInventory.addItemCount(source, item, 1)
        CInventory.removeItemCount(parent, item, 1)
        CInventory.CBuffer[inventoryID].slots[slot] = {item = item}
    end
    imports.triggerClientEvent(source, "Client:onSyncInventoryBuffer", source, CInventory.CBuffer[inventoryID])
end)

imports.addEvent("Player:onOrderItem", true)
imports.addEventHandler("Player:onOrderItem", root, function(item, prevSlot, newSlot)
    if not CPlayer.isInitialized(source) then return false end
    local characterID = CPlayer.getCharacterID(source)
    local inventoryID = CPlayer.getInventoryID(source)
    if item and prevSlot and newSlot then
        if FRAMEWORK_CONFIGS["Templates"]["Inventory"]["Slots"][newSlot] then
            --TODO: ADD AND UPDATE ATTACHMENT...
        else
            if CInventory.isSlotAvailableForOrdering(source, item, newSlot, not FRAMEWORK_CONFIGS["Templates"]["Inventory"]["Slots"][prevSlot]) then
                CInventory.CBuffer[inventoryID].slots[prevSlot] = nil
                CInventory.CBuffer[inventoryID].slots[newSlot] = {item = item}
                if FRAMEWORK_CONFIGS["Templates"]["Inventory"]["Slots"][prevSlot] then
                    --TODO: REMOVE AND UPDATE ATTACHMENT...
                end
            end
        end
    end
    imports.triggerClientEvent(source, "Client:onSyncInventoryBuffer", source, CInventory.CBuffer[inventoryID])
end)
]]