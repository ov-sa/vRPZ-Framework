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
    isElement = isElement,
    getElementData = getElementData,
    math = math
}


---------------------------
--[[ Module: Inventory ]]--
---------------------------

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

    fetchItemName = function(item)
        local itemData = CInventory.fetchItem(item)
        return (itemData and itemData.data and itemData.data.name) or false
    end,

    fetchItemWeight = function(item)
        local itemData = CInventory.fetchItem(item)
        return (itemData and itemData.data and itemData.data.weight and imports.math.max(0, itemData.data.weight.horizontal*itemData.data.weight.vertical)) or false
    end,

    fetchItemObjectID = function(item)
        local itemData = CInventory.fetchItem(item)
        return (itemData and itemData.data and imports.tonumber(itemData.data.objectID)) or false
    end,

    fetchWeaponSlot = function(item)
        local itemData = CInventory.fetchItem(item)
        if itemData and itemData.slot and CInventory.CSlots["Weapon"][(itemData.slot)] then
            return itemData.slot, CInventory.CSlots["Weapon"][(itemData.slot)]
        end
        return false
    end,

    fetchWeaponID = function(item)
        local itemData = CInventory.fetchItem(item)
        local weaponSlot = CInventory.fetchWeaponSlot(item)
        return (itemData and weaponSlot and itemData.data.weapon and imports.tonumber(itemData.data.weapon.id)) or false
    end,

    fetchWeaponAmmo = function(item)
        local itemData = CInventory.fetchItem(item)
        local weaponSlot = CInventory.fetchWeaponSlot(item)
        return (itemData and weaponSlot and itemData.data.weapon and imports.tonumber(itemData.data.weapon.ammo)) or false
    end,

    fetchWeaponMag = function(item)
        local itemData = CInventory.fetchItem(item)
        local weaponSlot = CInventory.fetchWeaponSlot(item)
        return (itemData and weaponSlot and itemData.data.weapon and imports.tonumber(itemData.data.weapon.mag)) or 0
    end,

    fetchSlot = function(slot)
        if not slot then return false end
        return FRAMEWORK_CONFIGS["Inventory"]["Slots"][slot] or false
    end,

    fetchItemCount = function(parent, item)
        if not parent or not item or not imports.isElement(parent) or not CInventory.CItems[item] then return false end
        return imports.math.max(0, imports.tonumber(imports.getElementData(parent, "Item:"..item)) or 0)
    end
}

for i, j in imports.pairs(FRAMEWORK_CONFIGS["Inventory"]["Items"]) do
    if FRAMEWORK_CONFIGS["Inventory"]["Slots"][i] and (FRAMEWORK_CONFIGS["Inventory"]["Slots"][i].identifier == "Weapon") then
        CInventory.CSlots[(FRAMEWORK_CONFIGS["Inventory"]["Slots"][i].identifier)] = CInventory.CSlots[(FRAMEWORK_CONFIGS["Inventory"]["Slots"][i].identifier)] or {}
        CInventory.CSlots[(FRAMEWORK_CONFIGS["Inventory"]["Slots"][i].identifier)][i] = FRAMEWORK_CONFIGS["Inventory"]["Slots"][i]
    else
        CInventory.CSlots[(FRAMEWORK_CONFIGS["Inventory"]["Slots"][i].identifier)] = FRAMEWORK_CONFIGS["Inventory"]["Slots"][i]
    end
    for k, v in imports.pairs(j) do
        CInventory.CItems[k] = {slot = i, data = v}
    end
end