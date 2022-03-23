----------------------------------------------------------------
--[[ Resource: Player Handler
     Script: handlers: inventory: essentials: equipment.lua
     Server: -
     Author: OvileAmriam
     Developer: -
     DOC: 18/12/2020 (OvileAmriam)
     Desc: Inventory Equipment's Essentials ]]--
----------------------------------------------------------------


-------------------
--[[ Variables ]]--
-------------------

playerAttachments = {}


-----------------------------------------------------
--[[ Function: Refreshes Player's Equipment Slot ]]--
-----------------------------------------------------

function refreshPlayerEquipmentSlot(player, slotIndex)

    if not player or not isElement(player) or player:getType() ~= "player" or not isPlayerInitialized(player) or not slotIndex or not characterSlots[slotIndex] or not playerAttachments[player] or not CInventory.CBuffer[parent] then return false end

    if CInventory.CBuffer[parent].slots[slotIndex] then
        local itemDetails, itemCategory = getItemDetails(CInventory.CBuffer[parent].slots[slotIndex])
        if itemDetails and itemCategory then
            local objectID, attachmentID, offsets = false, false, false
            if inventoryDatas[itemCategory].isWeaponCategory then
                attachmentID = "weapon"
                local isBackpackWeapon = false
                --TODO: CHECK IF IS UNOCCUPIED TOO :)
                --isBackpackWeapon = true
                objectID, offsets = getWeaponOffset(itemDetails.dataName, isBackpackWeapon)
            elseif inventoryDatas[itemCategory].isBackpackCategory then
                attachmentID = "backpack"
                objectID, offsets = getBackpackOffset(player:getModel(), itemDetails.dataName)
            end
            if objectID and attachmentID then
                if playerAttachments[player][slotIndex] and isElement(playerAttachments[player][slotIndex]) then
                    playerAttachments[player][slotIndex]:destroy()
                end
                playerAttachments[player][slotIndex] = nil
                playerAttachments[player][slotIndex] = Object(objectID, 0, 0, 0)
                playerAttachments[player][slotIndex]:setScale(offsets.scale)
                exports.bone_attach:attach(playerAttachments[player][slotIndex], player, attachmentID, offsets.offX, offsets.offY, offsets.offZ, offsets.rotX, offsets.rotY, offsets.rotZ)
            end
        end
        player:setData("Slot:"..slotIndex, CInventory.CBuffer[parent].slots[slotIndex])
        player:setData("Slot:Object:"..slotIndex, playerAttachments[player][slotIndex])
    else
        if playerAttachments[player][slotIndex] and isElement(playerAttachments[player][slotIndex]) then
            playerAttachments[player][slotIndex]:destroy()
        end
        player:setData("Slot:"..slotIndex, nil)
        player:setData("Slot:Object:"..slotIndex, nil)
    end
    if inventoryDatas[characterSlots[slotIndex].slotCategory] and inventoryDatas[characterSlots[slotIndex].slotCategory].isWeaponCategory then
        triggerEvent("onPlayerRefreshWeapon", player)
    end
    return true

end


---------------------------------------------------
--[[ Functions: Clears Player's Equipment Slot ]]--
---------------------------------------------------

function clearPlayerEquipmentSlot(player, slotIndex)

    if not player or not isElement(player) or player:getType() ~= "player" or not isPlayerInitialized(player) or not slotIndex or not characterSlots[slotIndex] or not playerAttachments[player] or not CInventory.CBuffer[parent] then return false end

    CInventory.CBuffer[parent].slots[slotIndex] = nil
    refreshPlayerEquipmentSlot(player, slotIndex)
    return true
    --[[
    --TODO: CHECK LATER
    if slotIndex == "helmet" then
        if verifySlot then
            local shieldHealth = getPlayerShieldHealth(localPlayer, "helmet")
            if shieldHealth and shieldHealth < 100 then
                setElementData(localPlayer, "Item:"..inventoryUI.helmet, (tonumber(getElementData(localPlayer, "Item:"..inventoryUI.helmet)) or 0) - 1)
                triggerEvent("onClientInventoryUpdate", localPlayer)
            end
        end
        setElementData(localPlayer, "Slot:helmet", nil)
        inventoryUI.helmet = nil
    elseif slotIndex == "armor" then
        if verifySlot then
            local shieldHealth = getPlayerShieldHealth(localPlayer, "armor")
            if shieldHealth and shieldHealth < 100 then
                setElementData(localPlayer, "Item:"..inventoryUI.armor, (tonumber(getElementData(localPlayer, "Item:"..inventoryUI.armor)) or 0) - 1)
                triggerEvent("onClientInventoryUpdate", localPlayer)
            end
        end
        setElementData(localPlayer, "Slot:armor", nil)
        inventoryUI.armor = nil
    elseif slotIndex == "backpack" then
        local player_usedSlots = getElementUsedSlots(localPlayer)
        if player_usedSlots and player_usedSlots > maximumInventorySlots then
            triggerEvent("displayClientInfo", localPlayer, "You can't remove this item.", {255, 0, 0})
            return false
        end
        setElementData(localPlayer, "Slot:backpack", nil)
        inventoryUI.backpack = nil
    elseif slotIndex == "primary" then
        triggerServerEvent("onPlayerRemoveWeapon", localPlayer, inventoryUI.primary)
        setElementData(localPlayer, "Slot:primary_weapon", nil)
        inventoryUI.primary = nil
    elseif slotIndex == "secondary" then
        triggerServerEvent("onPlayerRemoveWeapon", localPlayer, inventoryUI.secondary)
        setElementData(localPlayer, "Slot:secondary_weapon", nil)
        inventoryUI.secondary = nil
    elseif slotIndex == "tertiary" then
        triggerServerEvent("onPlayerRemoveWeapon", localPlayer, inventoryUI.tertiary)
        setElementData(localPlayer, "Slot:special_weapon", nil)
        inventoryUI.tertiary = nil
    else
        return false
    end
    return true
    ]]--

end

function clearPlayerAllEquipmentSlots(player)

    if not player or not isElement(player) or player:getType() ~= "player" or not isPlayerInitialized(player) then return false end

    for i, j in pairs(characterSlots) do
        if inventoryDatas[j.slotCategory] and not inventoryDatas[j.slotCategory].saveOnWasted then
            clearPlayerEquipmentSlot(i)
        end
    end

end