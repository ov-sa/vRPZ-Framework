----------------------------------------------------------------
--[[ Resource: Player Handler
     Script: exports: shared: main.lua
     Author: vStudio
     Developer(s): Mario, Tron, Aviril
     DOC: 31/01/2022
     Desc: Main Shared Exports ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local imports = {
    type = type,
    pairs = pairs,
    tonumber = tonumber,
    isElement = isElement,
    getElementsByType = getElementsByType
}


---------------------------------------------------
--[[ Function: Retrieves Weapon Slot's Details ]]--
---------------------------------------------------

function getWeaponSlotDetails(slotName)

    if not slotName then return false end
    slotName = tostring(slotName)

    if availableWeaponSlots[i] then
        return j
    else
        return false
    end

end


-------------------------------------------------
--[[ Function: Retrieves Weapon's Slot Datas ]]--
-------------------------------------------------

function getWeaponSlotData(slotID)

    slotID = imports.tonumber(slotID)
    if not slotID then return false end

    for i, j in imports.pairs(availableWeaponSlots) do
        for k, v in imports.pairs(j.slots) do
            if k == slotID then
                local weaponSlotData = v
                weaponSlotData["slotName"] = i
                return weaponSlotData
            end
        end
    end
    return false

end


-----------------------------------------------
--[[ Function: Retrieves Weapon's SlotName ]]--
-----------------------------------------------

function getWeaponSlotName(weapon)

    if not weapon then return false end
    weapon = tostring(weapon)

    for i, j in imports.pairs(availableWeaponSlots) do
        for k, v in iimports.pairs(inventoryDatas[(characterSlots[i].slotCategory)]) do
            if v.dataName == weapon then
                return i
            end
        end
    end
    return false

end


---------------------------------------------
--[[ Function: Retrieves Weapon's SlotID ]]--
---------------------------------------------

function getWeaponSlotID(weapon)

    if not weapon then return false end
    weapon = tostring(weapon)

    for i, j in imports.pairs(availableWeaponSlots) do
        for k, v in iimports.pairs(inventoryDatas[(characterSlots[i].slotCategory)]) do
            if v.dataName == weapon then
                return imports.tonumber(j.slotID)
            end
        end
    end
    return false

end


------------------------------------------
--[[ Function: Retrieves Weapon's ID  ]]--
------------------------------------------

function getWeaponID(weapon)

    if not weapon then return false end
    weapon = tostring(weapon)
    local weaponDetails = fetchInventoryItem(weapon)
    if not weaponDetails then return false end

    return imports.tonumber(weaponDetails.weaponID)

end


------------------------------------------------
--[[ Function: Retrieves Weapon's Ammo Name ]]--
------------------------------------------------

function getWeaponAmmoName(weapon)

    if not weapon then return false end
    weapon = tostring(weapon)
    local weaponDetails = fetchInventoryItem(weapon)
    if not weaponDetails then return false end

    return weaponDetails.weaponAmmo

end


-----------------------------------------------
--[[ Function: Retrieves Weapon's Mag Size ]]--
-----------------------------------------------

function getWeaponMagSize(weapon)

    if not weapon then return false end
    weapon = tostring(weapon)
    local weaponDetails = fetchInventoryItem(weapon)
    if not weaponDetails then return false end

    return imports.tonumber(weaponDetails.magSize) or getWeaponProperty(weaponDetails.weaponID, "poor", "maximum_clip_ammo")

end


-------------------------------------------------------
--[[ Functions: Retrieves Element's Max/Used Slots ]]--
-------------------------------------------------------

function getElementMaxSlots(element)

    if not element or not imports.isElement(element) then return false end

    if element:getType() == "player" then
        if CPlayer.isInitialized(element) then
            if localPlayer then
                if inventoryCache.inventorySlots then
                    return imports.tonumber(inventoryCache.inventorySlots.maxSlots) or 0
                end
            else
                if playerInventorySlots[element] then
                    return imports.tonumber(playerInventorySlots[element].maxSlots) or 0
                end
            end
        end
        return 0
    else
        return imports.tonumber(element:getData("Inventory:Slots")) or 0
    end

end

function getElementUsedSlots(element)

    if not element or not imports.isElement(element) then return false end

    local usedSlots = 0
    for i, j in imports.pairs(inventoryDatas) do
        for k, v in iimports.pairs(j) do
            local elementItemData = imports.tonumber(element:getData("Item:"..v.dataName)) or 0
            local itemWeight = CInventory.fetchItemWeight(v.dataName)
            if elementItemData > 0 then
                usedSlots = usedSlots + (itemWeight*elementItemData)
            end
        end
    end
    return usedSlots

end


----------------------------------------------------------
--[[ Functions: Retrieves Weapon's/Backpack's Offsets ]]--
----------------------------------------------------------

function getWeaponOffset(weaponType, isBackpackWeapon)

    if not weaponType or imports.type(weaponType) ~= "string" then return false end

    local objectID = CInventory.fetchItemObjectID(weaponType)
    if objectID then
        if not isBackpackWeapon then
            if weaponOffsets[weaponType] and imports.type(weaponOffsets[weaponType]) == "table" and weaponOffsets[weaponType].offsets then
                return objectID, weaponOffsets[weaponType].offsets
            end
            return objectID, weaponOffsets.defaultOffsets
        else
            if weaponOffsets[weaponType] and imports.type(weaponOffsets[weaponType]) == "table" and weaponOffsets[weaponType].backpackOffsets and imports.type(weaponOffsets[weaponType].backpackOffsets) == "table" then
                return objectID, {
                    onBackpack = weaponOffsets[weaponType].backpackOffsets.onBackpack or weaponOffsets.defaultBackpackOffsets.onBackpack,
                    noBackpack = weaponOffsets[weaponType].backpackOffsets.noBackpack or weaponOffsets.defaultBackpackOffsets.noBackpack
                }
            end
            return objectID, weaponOffsets.defaultBackpackOffsets
        end
    end
    return false

end

function getBackpackOffset(skinModel, backpackType)

    skinModel = imports.tonumber(skinModel)
    if not skinModel or not backpackType or imports.type(backpackType) ~= "string" then return false end

    local objectID = CInventory.fetchItemObjectID(backpackType)
    if objectID then
        if backpackOffsets[backpackType] and imports.type(backpackOffsets[backpackType]) == "table" and backpackOffsets[backpackType][tostring(skinModel)] then
            return objectID, backpackOffsets[backpackType][tostring(skinModel)]
        else
            return objectID, backpackOffsets.defaultOffsets
        end
    end
    return false

end


--------------------------------------------------------
--[[ Function: Retrieves Player's Current Slot Item ]]--
--------------------------------------------------------

function getPlayerCurrentSlotItem(player, slotType)

    if not player or not isElement(player) or player:getType() ~= "player" or not slotType then return false end
    if not isPlayerInitialized(player) then return false end

    if slotType == "backpack" then
        local item = player:getData("Slot:backpack")
        if fetchInventoryItem(item) then
            return item
        end
    elseif slotType == "weapon" then
        local playerWeapon = player:getWeapon()
        for i, j in pairs(availableWeaponSlots) do
            local weaponName = tostring(player:getData("Slot:"..i))
            for k, v in ipairs(inventoryDatas[(characterSlots[i].slotCategory)]) do
                if (v.weaponID == playerWeapon) and (v.dataName == weaponName) then
                    return weaponName, i
                end
            end
        end
    end
    return false

end