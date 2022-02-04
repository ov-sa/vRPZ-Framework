----------------------------------------------------------------
--[[ Resource: Player Handler
     Script: modules: inventory: shared: index.lua
     Author: vStudio
     Developer(s): Mario, Tron, Aviril
     DOC: 31/01/2022
     Desc: Inventory Module ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local imports = {
    tonumber = tonumber,
    pairs = pairs,
    math = math
}


----------------------
--[[ Player Class ]]--
----------------------

CInventory = {
    CSlots = {},
    CItems = {},

    fetchItem = function(item)
        if not item or not CInventory.CItems[item] then return false end
        return CInventory.CItems[item]
    end,

    fetchItemSlot = function(item)
        local itemData = CInventory.fetchItem(item)
        return (itemData and itemData.slot) or false
    end,

    fetchItemSlotID = function(item)
        local itemData = CInventory.fetchItem(item)
        return (itemData and itemData.slot and CInventory.CSlots["Weapon"][(itemData.slot)] and imports.tonumber(itemData.data.slotID)) or false
    end,

    fetchItemName = function(item)
        local itemData = CInventory.fetchItem(item)
        return (itemData and itemData.data and itemData.data.name) or false
    end,

    fetchItemWeight = function(item)
        local itemData = CInventory.fetchItem(item)
        return (itemData and itemData.data and imports.math.max(0, imports.tonumber(itemData.data.weight) or 0)) or false
    end,

    fetchItemObjectID = function(item)
        local itemData = CInventory.fetchItem(item)
        return (itemData and itemData.data and imports.tonumber(itemData.data.objectID)) or false
    end,

    fetchSlot = function(slot)
        if not slot then return false end
        return FRAMEWORK_CONFIGS["Inventory"]["Slots"][slot] or false
    end  
}

for i, j in imports.pairs(FRAMEWORK_CONFIGS["Inventory"]["Items"]) do
    if FRAMEWORK_CONFIGS["Inventory"]["Slots"][i] and (FRAMEWORK_CONFIGS["Inventory"]["Slots"][i].slotIdentifier == "Weapon") then
        CInventory.CSlots[(FRAMEWORK_CONFIGS["Inventory"]["Slots"][i].slotIdentifier)] = CInventory.CSlots[(FRAMEWORK_CONFIGS["Inventory"]["Slots"][i].slotIdentifier)] or {}
        CInventory.CSlots[(FRAMEWORK_CONFIGS["Inventory"]["Slots"][i].slotIdentifier)][i] = FRAMEWORK_CONFIGS["Inventory"]["Slots"][i]
    else
        CInventory.CSlots[(FRAMEWORK_CONFIGS["Inventory"]["Slots"][i].slotIdentifier)] = FRAMEWORK_CONFIGS["Inventory"]["Slots"][i]
    end
    for k, v in imports.pairs(j) do
        CInventory.CItems[k] = {slot = i, data = v}
    end
end