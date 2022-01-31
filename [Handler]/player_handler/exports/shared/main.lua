----------------------------------------------------------------
--[[ Resource: Player Handler
     Script: exports: shared: main.lua
     Author: vStudio
     Developer(s): Mario, Tron
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
    getElements = Element.getAllByimports.type
}


-------------------------------------------
--[[ Function: Retrieves Server's Tick ]]--
-------------------------------------------

local serverTickSyncer = nil
function getServerTick()

    local currentTick = 0
    if not serverTickSyncer or not imports.isElement(serverTickSyncer) then
        local tickSyncers = imports.getElements("Server:TickSyncer", resourceRoot)
        if #tickSyncers > 0 then
            serverTickSyncer = tickSyncers[1]
        end
    end
    if serverTickSyncer and imports.isElement(serverTickSyncer) then
        currentTick = imports.tonumber(serverTickSyncer:getData("Server:TickSyncer")) or 0
    end
    return currentTick

end


------------------------------------------
--[[ Function: Retrieves Current Time ]]--
------------------------------------------

function getCurrentTime()

    local hour, minutes = getTime()
    hour = ((hour < 10) and "0"..hour) or hour
    minutes = ((minutes < 10) and "0"..minutes) or minutes 
    return hour, minutes

end


--------------------------------------------
--[[ Function: Retrieves Item's Details ]]--
--------------------------------------------

function getItemDetails(item)

    if not item then return false end

    for i, j in imports.pairs(inventoryDatas) do
        for key, value in iimports.pairs(j) do
            if value.dataName == item then
                return value, i
            end
        end
    end
    return false

end


-----------------------------------------
--[[ Function: Retrieves Item's Name ]]--
-----------------------------------------

function getItemName(item)

    if not item then return false end
    local itemDetails = getItemDetails(item)
    if not itemDetails then return false end

    return itemDetails.itemName

end


-------------------------------------------
--[[ Function: Retrieves Item's Weight ]]--
-------------------------------------------

function getItemWeight(item)

    if not item then return false end
    local itemDetails = getItemDetails(item)
    if not itemDetails then return false end

    return imports.tonumber(itemDetails.itemWeight) or 1

end


---------------------------------------------
--[[ Function: Retrieves Item's ObjectID ]]--
---------------------------------------------

function getItemObjectID(item)

    if not item then return false end
    local itemDetails = getItemDetails(item)
    if not itemDetails then return false end

    return imports.tonumber(itemDetails.itemObjectID)

end


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
    local weaponDetails = getItemDetails(weapon)
    if not weaponDetails then return false end

    return imports.tonumber(weaponDetails.weaponID)

end


------------------------------------------------
--[[ Function: Retrieves Weapon's Ammo Name ]]--
------------------------------------------------

function getWeaponAmmoName(weapon)

    if not weapon then return false end
    weapon = tostring(weapon)
    local weaponDetails = getItemDetails(weapon)
    if not weaponDetails then return false end

    return weaponDetails.weaponAmmo

end


-----------------------------------------------
--[[ Function: Retrieves Weapon's Mag Size ]]--
-----------------------------------------------

function getWeaponMagSize(weapon)

    if not weapon then return false end
    weapon = tostring(weapon)
    local weaponDetails = getItemDetails(weapon)
    if not weaponDetails then return false end

    return imports.tonumber(weaponDetails.magSize) or getWeaponProperty(weaponDetails.weaponID, "poor", "maximum_clip_ammo")

end


-------------------------------------------------------
--[[ Functions: Retrieves Element's Max/Used Slots ]]--
-------------------------------------------------------

function getElementMaxSlots(element)

    if not element or not imports.isElement(element) then return false end

    if element:getimports.type() == "player" then
        if isPlayerInitialized(element) then
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
            local itemWeight = getItemWeight(v.dataName)
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

function getWeaponOffset(weaponimports.type, isBackpackWeapon)

    if not weaponimports.type or imports.type(weaponimports.type) ~= "string" then return false end

    local objectID = getItemObjectID(weaponimports.type)
    if objectID then
        if not isBackpackWeapon then
            if weaponOffsets[weaponimports.type] and imports.type(weaponOffsets[weaponimports.type]) == "table" and weaponOffsets[weaponimports.type].offsets then
                return objectID, weaponOffsets[weaponimports.type].offsets
            end
            return objectID, weaponOffsets.defaultOffsets
        else
            if weaponOffsets[weaponimports.type] and imports.type(weaponOffsets[weaponimports.type]) == "table" and weaponOffsets[weaponimports.type].backpackOffsets and imports.type(weaponOffsets[weaponimports.type].backpackOffsets) == "table" then
                return objectID, {
                    onBackpack = weaponOffsets[weaponimports.type].backpackOffsets.onBackpack or weaponOffsets.defaultBackpackOffsets.onBackpack,
                    noBackpack = weaponOffsets[weaponimports.type].backpackOffsets.noBackpack or weaponOffsets.defaultBackpackOffsets.noBackpack
                }
            end
            return objectID, weaponOffsets.defaultBackpackOffsets
        end
    end
    return false

end

function getBackpackOffset(skinModel, backpackimports.type)

    skinModel = imports.tonumber(skinModel)
    if not skinModel or not backpackimports.type or imports.type(backpackimports.type) ~= "string" then return false end

    local objectID = getItemObjectID(backpackimports.type)
    if objectID then
        if backpackOffsets[backpackimports.type] and imports.type(backpackOffsets[backpackimports.type]) == "table" and backpackOffsets[backpackimports.type][tostring(skinModel)] then
            return objectID, backpackOffsets[backpackimports.type][tostring(skinModel)]
        else
            return objectID, backpackOffsets.defaultOffsets
        end
    end
    return false

end