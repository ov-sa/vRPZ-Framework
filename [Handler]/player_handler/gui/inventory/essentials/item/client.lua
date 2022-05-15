----------------------------------------------------------------
--[[ Resource: Player Handler
     Script: handlers: inventory: essentials: item: client.lua
     Server: -
     Author: OvileAmriam
     Developer: -
     DOC: 18/12/2020 (OvileAmriam)
     Desc: Inventory Item's Essentials ]]--
----------------------------------------------------------------


-------------------------------------------------
--[[ Functions: Moves Item In Inventory/Loot ]]--
-------------------------------------------------

function moveItemInInventory(item, slotIndex, loot)

    slotIndex = tonumber(slotIndex)
    if not item or not slotIndex or not loot or not isElement(loot) then return false end
    local itemDetails = getItemDetails(item)
    local itemAmountData = tonumber(loot:getData("Item:"..item)) or 0
    if not itemDetails or itemAmountData <= 0 then return false end

    inventoryUI.isSynced = false
    CInventory.CBuffer.slots[slotIndex] = {
        item = item,
        loot = loot,
        isOrdering = false,
        translation = "inventory"
    }
    triggerServerEvent("onPlayerMoveItemInInventory", localPlayer, item, slotIndex, loot)
    return true

end

function moveItemInLoot(item, slotIndex, loot)

    slotIndex = tonumber(slotIndex)
    if not item or not slotIndex or not loot or not isElement(loot) then return false end
    local itemDetails = getItemDetails(item)
    local itemAmountData = tonumber(getElementData(localPlayer, "Item:"..item)) or 0
    if not itemDetails or itemAmountData <= 0 then return false end

    inventoryUI.isSynced = false
    CInventory.CBuffer.slots[slotIndex] = {
        item = item,
        loot = loot,
        translation = "loot"
    }
    triggerServerEvent("onPlayerMoveItemInLoot", localPlayer, item, slotIndex, loot)
    return true

end


-------------------------------------------------------------
--[[ Functions: Orders/Equips/Unequips Item In Inventory ]]--
-------------------------------------------------------------

function orderItemInInventory(item, prevSlotIndex, newSlotIndex)

    prevSlotIndex, newSlotIndex = tonumber(prevSlotIndex), tonumber(newSlotIndex)
    if not item or not prevSlotIndex or not newSlotIndex then return false end
    local itemDetails = getItemDetails(item)
    local itemAmountData = tonumber(getElementData(localPlayer, "Item:"..item)) or 0
    if not itemDetails or itemAmountData <= 0 then return false end

    inventoryUI.isSynced = false
    inventoryUI.isSyncScheduled = true
    CInventory.CBuffer.slots[prevSlotIndex] = nil
    CInventory.CBuffer.slots[newSlotIndex] = {
        item = item,
        isOrdering = true,
        translation = "inventory"
    }
    triggerServerEvent("onPlayerOrderItemInInventory", localPlayer, item, prevSlotIndex, newSlotIndex)
    return true

end

function equipItemInInventory(item, prevSlotIndex, reservedSlotIndex, newSlotIndex, loot)

    prevSlotIndex, reservedSlotIndex = tonumber(prevSlotIndex), tonumber(reservedSlotIndex)
    if not item or not prevSlotIndex or not reservedSlotIndex or not newSlotIndex or not characterSlots[newSlotIndex] or not loot or not isElement(loot) then return false end
    local itemDetails = getItemDetails(item)
    local itemAmountData = tonumber(loot:getData("Item:"..item)) or 0
    if not itemDetails or itemAmountData <= 0 then return false end

    inventoryUI.isSynced = false
    if loot == localPlayer then
        CInventory.CBuffer.slots[prevSlotIndex] = {
            item = item,
            isAutoReserved = false,
            translation = "equipment"
        }
    else
        CInventory.CBuffer.slots[reservedSlotIndex] = {
            item = item,
            loot = loot,
            isAutoReserved = true,
            translation = "equipment"
        }
    end
    CInventory.CBuffer.slots[newSlotIndex] = item
    triggerServerEvent("onPlayerEquipItemInInventory", localPlayer, item, prevSlotIndex, reservedSlotIndex, newSlotIndex, loot)
    return true

end

function unequipItemInInventory(item, prevSlotIndex, newSlotIndex, loot, reservedSlotIndex)

    newSlotIndex, reservedSlotIndex = tonumber(newSlotIndex), tonumber(reservedSlotIndex)
    if not item or not prevSlotIndex or not characterSlots[prevSlotIndex] or not newSlotIndex or not loot or not isElement(loot) then return false end
    local itemDetails = getItemDetails(item)
    local itemAmountData = tonumber(getElementData(localPlayer, "Item:"..item)) or 0
    if not itemDetails or itemAmountData <= 0 then return false end
    if not reservedSlotIndex then
        reservedSlotIndex = false
        for i, j in pairs(CInventory.CBuffer.slots) do
            if tonumber(i) then
                if j.translation and j.translation == "equipment" and prevSlotIndex == j.equipmentIndex then
                    reservedSlotIndex = i
                    break
                end
            end
        end
    end
    if not reservedSlotIndex then return false end

    inventoryUI.isSynced = false
    CInventory.CBuffer.slots[prevSlotIndex] = nil
    if loot == localPlayer then
        inventoryUI.isSyncScheduled = true
        CInventory.CBuffer.slots[reservedSlotIndex] = nil
        CInventory.CBuffer.slots[newSlotIndex] = {
            item = item,
            isOrdering = true,
            translation = "inventory"
        }
    else
        CInventory.CBuffer.slots[reservedSlotIndex] = {
            item = item,
            loot = loot,
            translation = "loot"
        }
    end
    triggerServerEvent("onPlayerUnequipItemInInventory", localPlayer, item, prevSlotIndex, reservedSlotIndex, newSlotIndex, loot)
    return true

end


-----------------------------------------------
--[[ Function: Moves Item Out OF Inventory ]]--
-----------------------------------------------

--[[
function moveItemOutOfInventory(item, loot)

    if loot and isElement(loot) then
        if itemAmount > itemAmountData then itemAmount = itemAmountData end

        setElementData(localPlayer, "Item:"..item, itemAmountData - itemAmount)
        local posVector = localPlayer:getPosition()
        local itemData = {
            x = posVector.x + math.random(-1, 1) * math.cos(math.rad(math.random(0, 360) + 90)),
            y = posVector.y + math.random(-1, 1) * math.sin(math.rad(math.random(0, 360) + 90)),
            z = getGroundPosition(posVector.x, posVector.y, posVector.z) + 0.1,
            item = item,
            value = itemAmount
        }
        triggerServerEvent("onPlayerCreatePickupItem", localPlayer, itemData)
    end

    if availableGoggles[item] then
        if (tonumber(getElementData(localPlayer, "Item:"..item)) or 0) <= 0 then
            triggerEvent("onPlayerResetVision", localPlayer)
        end
    end

    for i, _ in pairs(availableWeaponSlots) do
        local playerSlotWeapon = getElementData(localPlayer, "Slot:"..i)
        if playerSlotWeapon then
            if (playerSlotWeapon == item) and ((itemAmountData - itemAmount) <= 0) then
                triggerServerEvent("onPlayerRemoveWeapon", localPlayer, item)
                setElementData(localPlayer, "Slot:"..i, nil)
            else
                local weaponAmmo = getWeaponAmmoName(playerSlotWeapon)
                if weaponAmmo and weaponAmmo == item then
                    triggerServerEvent("onPlayerDropWeaponAmmo", localPlayer)
                end
            end
        end
    end
    return true

end
]]--