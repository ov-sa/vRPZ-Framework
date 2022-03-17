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

    inventoryCache.isSlotsUpdated = false
    inventoryCache.inventorySlots.slots[slotIndex] = {
        item = item,
        loot = loot,
        isOrdering = false,
        movementType = "inventory"
    }
    triggerServerEvent("onPlayerMoveItemInInventory", localPlayer, item, slotIndex, loot)
    return true

end

function moveItemInLoot(item, slotIndex, loot)

    slotIndex = tonumber(slotIndex)
    if not item or not slotIndex or not loot or not isElement(loot) then return false end
    local itemDetails = getItemDetails(item)
    local itemAmountData = tonumber(localPlayer:getData("Item:"..item)) or 0
    if not itemDetails or itemAmountData <= 0 then return false end

    inventoryCache.isSlotsUpdated = false
    inventoryCache.inventorySlots.slots[slotIndex] = {
        item = item,
        loot = loot,
        movementType = "loot"
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
    local itemAmountData = tonumber(localPlayer:getData("Item:"..item)) or 0
    if not itemDetails or itemAmountData <= 0 then return false end

    inventoryCache.isSlotsUpdated = false
    inventoryCache.isSlotsUpdatePending = true
    inventoryCache.inventorySlots.slots[prevSlotIndex] = nil
    inventoryCache.inventorySlots.slots[newSlotIndex] = {
        item = item,
        isOrdering = true,
        movementType = "inventory"
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

    inventoryCache.isSlotsUpdated = false
    if loot == localPlayer then
        inventoryCache.inventorySlots.slots[prevSlotIndex] = {
            item = item,
            isAutoReserved = false,
            movementType = "equipment"
        }
    else
        inventoryCache.inventorySlots.slots[reservedSlotIndex] = {
            item = item,
            loot = loot,
            isAutoReserved = true,
            movementType = "equipment"
        }
    end
    inventoryCache.inventorySlots.slots[newSlotIndex] = item
    triggerServerEvent("onPlayerEquipItemInInventory", localPlayer, item, prevSlotIndex, reservedSlotIndex, newSlotIndex, loot)
    return true

end

function unequipItemInInventory(item, prevSlotIndex, newSlotIndex, loot, reservedSlotIndex)

    newSlotIndex, reservedSlotIndex = tonumber(newSlotIndex), tonumber(reservedSlotIndex)
    if not item or not prevSlotIndex or not characterSlots[prevSlotIndex] or not newSlotIndex or not loot or not isElement(loot) then return false end
    local itemDetails = getItemDetails(item)
    local itemAmountData = tonumber(localPlayer:getData("Item:"..item)) or 0
    if not itemDetails or itemAmountData <= 0 then return false end
    if not reservedSlotIndex then
        reservedSlotIndex = false
        for i, j in pairs(inventoryCache.inventorySlots.slots) do
            if tonumber(i) then
                if j.movementType and j.movementType == "equipment" and prevSlotIndex == j.equipmentIndex then
                    reservedSlotIndex = i
                    break
                end
            end
        end
    end
    if not reservedSlotIndex then return false end

    inventoryCache.isSlotsUpdated = false
    inventoryCache.inventorySlots.slots[prevSlotIndex] = nil
    if loot == localPlayer then
        inventoryCache.isSlotsUpdatePending = true
        inventoryCache.inventorySlots.slots[reservedSlotIndex] = nil
        inventoryCache.inventorySlots.slots[newSlotIndex] = {
            item = item,
            isOrdering = true,
            movementType = "inventory"
        }
    else
        inventoryCache.inventorySlots.slots[reservedSlotIndex] = {
            item = item,
            loot = loot,
            movementType = "loot"
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

        localPlayer:setData("Item:"..item, itemAmountData - itemAmount)
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
        if (tonumber(localPlayer:getData("Item:"..item)) or 0) <= 0 then
            triggerEvent("onPlayerResetVision", localPlayer)
        end
    end

    for i, _ in pairs(availableWeaponSlots) do
        local playerSlotWeapon = localPlayer:getData("Slot:"..i)
        if playerSlotWeapon then
            if (playerSlotWeapon == item) and ((itemAmountData - itemAmount) <= 0) then
                triggerServerEvent("onPlayerRemoveWeapon", localPlayer, item)
                localPlayer:setData("Slot:"..i, nil)
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