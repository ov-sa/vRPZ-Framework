-----------------
--[[ Imports ]]--
-----------------

local imports = {
    pairs = pairs,
    tonumber = tonumber,
    isElement = isElement,
    getElementType = getElementType,
    getElementData = getElementData,
    table = table,
    math = math,
    string = string,
    assetify = assetify
}


---------------------------
--[[ Module: Inventory ]]--
---------------------------

CInventory = {
    CBuffer = {},
    CSlots = {},
    CItems = {}, CCategories = {},
    CRefs = {index = {}, ref = {}},

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
        return (itemData and itemData.data and itemData.data.itemName) or false
    end,

    fetchItemWeight = function(item)
        local itemData = CInventory.fetchItem(item)
        return (itemData and itemData.data and itemData.data.itemWeight.weight) or false
    end,

    fetchItemObjectID = function(item)
        local itemData = CInventory.fetchItem(item)
        --TODO: THIS SHOULDN'T WORK ANYWAY///
        return (itemData and itemData.data and imports.tonumber(itemData.data.objectID)) or false
    end,

    fetchWeaponSlot = function(item)
        local itemData = CInventory.fetchItem(item)
        if itemData and itemData.slot and CInventory.CSlots["Weapon"][(itemData.slot)] then
            return itemData.slot, CInventory.CSlots["Weapon"][(itemData.slot)]
        end
        return false
    end,

    fetchWeaponType = function(item)
        local itemData = CInventory.fetchItem(item)
        local weaponSlot = CInventory.fetchWeaponSlot(item)
        return (itemData and weaponSlot and itemData.data.weaponType) or false
    end,

    fetchWeaponID = function(item, baseType)
        baseType = baseType or "normal"
        local itemData = CInventory.fetchItem(item)
        local weaponSlot = CInventory.fetchWeaponSlot(item)
        return (itemData and weaponSlot and itemData.data.weaponBase and itemData.data.weaponBase[baseType] and imports.tonumber(itemData.data.weaponBase[baseType])) or false
    end,

    fetchWeaponAmmo = function(item)
        local itemData = CInventory.fetchItem(item)
        local weaponSlot = CInventory.fetchWeaponSlot(item)
        return (itemData and weaponSlot and itemData.data.weaponAmmo and imports.tonumber(itemData.data.weaponAmmo)) or false
    end,

    fetchWeaponMAG = function(item)
        local itemData = CInventory.fetchItem(item)
        local weaponSlot = CInventory.fetchWeaponSlot(item)
        return (itemData and weaponSlot and itemData.data.weaponMAG and imports.tonumber(itemData.data.weaponMAG)) or 0
    end,

    fetchSlot = function(slot)
        if not slot then return false end
        return FRAMEWORK_CONFIGS["Templates"]["Inventory"]["Slots"][slot] or false
    end,

    fetchSlotIndex = function(row, column)
        row, column = imports.tonumber(row), imports.tonumber(column)
        if not row or not column then return false end
        return (imports.math.max(0, row - 1)*FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.columns) + column
    end,

    fetchSlotLocation = function(slot)
        slot = imports.tonumber(slot)
        if not slot then return false end
        local row = imports.math.ceil(slot/FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.columns)
        local column = slot - (imports.math.max(0, row - 1)*FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.columns)
        return row, column
    end,

    fetchItemCount = function(parent, item)
        if not parent or not item or not imports.isElement(parent) or not CInventory.CItems[item] then return false end
        return imports.math.max(0, imports.tonumber(imports.getElementData(parent, "Item:"..item)) or 0)
    end,

    fetchMaxSlotsMultiplier = function()
        return FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.rows*FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.columns
    end,

    fetchParentMaxSlots = function(parent)
        if not parent or not imports.isElement(parent) then return false end
        if imports.getElementType(parent) == "player" then
            if not CPlayer.isInitialized(parent) or (localPlayer and (localPlayer ~= parent)) then return false end
            return imports.math.max(CInventory.fetchMaxSlotsMultiplier(), (localPlayer and imports.tonumber(CInventory.CBuffer.maxSlots)) or (not localPlayer and CInventory.CBuffer[parent] and imports.tonumber(CInventory.CBuffer[parent].maxSlots)) or 0)
        end
        return imports.tonumber(imports.getElementData(parent, "Inventory:MaxSlots")) or 0
    end,

    fetchParentAssignedSlots = function(parent)
        if not CPlayer.isInitialized(parent) or (not localPlayer and not CInventory.CBuffer[parent]) then return false end
        return (localPlayer and CInventory.CBuffer.slots) or (not localPlayer and CInventory.CBuffer[parent].slots)
    end,

    fetchParentUsedSlots = function(parent)
        if not CPlayer.isInitialized(parent) or (not localPlayer and not CInventory.CBuffer[parent]) then return false end
        local maxSlots, assignedSlots = CInventory.fetchParentMaxSlots(parent), CInventory.fetchParentAssignedSlots(parent)
        if not maxSlots or not assignedSlots then return false end
        local usedSlots = {}
        for i, j in imports.pairs(assignedSlots) do
            local isValidSlot = true
            if localPlayer then
                if FRAMEWORK_CONFIGS["Templates"]["Inventory"]["Slots"][i] then
                    isValidSlot = false
                else
                    if j.translation then
                        if (j.translation ~= "inventory") and (j.translation ~= "equipment") then
                            isValidSlot = false
                        else
                            if j.translation == "equipment" then
                                if inventoryUI.attachedItem and (inventoryUI.attachedItem.parent == localPlayer) and (inventoryUI.attachedItem.prevSlot == j.equipmentIndex) then                
                                    if not inventoryUI.attachedItem.animTickCounter then
                                        isValidSlot = false
                                    end
                                end
                            end
                        end
                    end
                end
            end
            if isValidSlot then
                usedSlots[i] = true
                for k = i, i + (CInventory.CItems[(j.item)].data.itemWeight.columns - 1), 1 do
                    for m = 1, CInventory.CItems[(j.item)].data.itemWeight.rows, 1 do
                        usedSlots[(k + (FRAMEWORK_CONFIGS["UI"]["Inventory"].inventory.columns*(m - 1)))] = true
                    end
                end
            end
        end
        return usedSlots
    end
}

imports.assetify.execOnLoad(function()
    local CItems, CWeapons = imports.assetify.getAssets("inventory"), imports.assetify.getAssets("weapon")
    for i, j in imports.pairs(FRAMEWORK_CONFIGS["Templates"]["Inventory"]["Slots"]) do
        if j.identifier == "Weapon" then
            CInventory.CSlots[(j.identifier)] = CInventory.CSlots[(j.identifier)] or {}
            CInventory.CSlots[(j.identifier)][i] = j
        else
            CInventory.CSlots[(j.identifier)] = j
        end
        CInventory.CCategories[i] = {}
    end
    if CItems then
        for i = 1, #CItems, 1 do
            local j = CItems[i]
            local cAsset = imports.assetify.getAsset("inventory", j)
            if cAsset and cAsset.manifestData.itemSlot and FRAMEWORK_CONFIGS["Templates"]["Inventory"]["Slots"][(cAsset.manifestData.itemSlot)] then
                CInventory.CItems[j] = {pack = "inventory", ref = imports.string.lower(j), slot = cAsset.manifestData.itemSlot, data = cAsset.manifestData}
                CInventory.CCategories[(cAsset.manifestData.itemSlot)][j] = true
            end
        end
    end
    if CWeapons then
        for i = 1, #CWeapons, 1 do
            local j = CWeapons[i]
            local cAsset = imports.assetify.getAsset("weapon", j)
            if cAsset and cAsset.manifestData.itemSlot and FRAMEWORK_CONFIGS["Templates"]["Inventory"]["Slots"][(cAsset.manifestData.itemSlot)] and (FRAMEWORK_CONFIGS["Templates"]["Inventory"]["Slots"][(cAsset.manifestData.itemSlot)].identifier == "Weapon") then
                CInventory.CItems[j] = {pack = "weapon", ref = imports.string.lower(j), slot = cAsset.manifestData.itemSlot, data = cAsset.manifestData}
                CInventory.CCategories[(cAsset.manifestData.itemSlot)][j] = true
            end
        end
    end
    for i, j in imports.pairs(CInventory.CItems) do
        CInventory.CRefs.ref[(j.ref)] = i
        imports.table.insert(CInventory.CRefs.index, j.ref)
        j.data.itemWeight = j.data.itemWeight or {}
        j.data.itemWeight.rows, j.data.itemWeight.columns = imports.math.max(1, imports.tonumber(j.data.itemWeight.rows) or 0), imports.math.max(1, imports.tonumber(j.data.itemWeight.columns) or 0)        
        j.data.itemWeight.weight = j.data.itemWeight.rows*j.data.itemWeight.columns
    end
end)