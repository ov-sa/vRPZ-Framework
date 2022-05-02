----------------------------------------------------------------
--[[ Resource: Player Handler
     Script: exports: shared: main.lua
     Author: vStudio
     Developer(s): Mario, Tron, Aviril, Аниса
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
    isElement = isElement
}


-------------------------------------------------------
--[[ Functions: Retrieves Element's Max/Used Slots ]]--
-------------------------------------------------------

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