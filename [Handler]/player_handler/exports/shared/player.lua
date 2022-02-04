----------------------------------------------------------------
--[[ Resource: Player Handler
     Script: exports: shared: player.lua
     Author: vStudio
     Developer(s): Mario, Tron
     DOC: 31/01/2022
     Desc: Player Shared Exports ]]--
----------------------------------------------------------------


-------------------------------------------------
--[[ Function: Retrieves Player's Occupation ]]--
-------------------------------------------------

function getPlayerOccupation(player)

    if (not player or not isElement(player) or (player:getType() ~= "player")) then return false end
    if not isPlayerInitialized(player) then return false end

    local playerOccupation = player:getData("Character:occupation")
    if playerOccupation and playerOccupations[playerOccupation] then
        return playerOccupation
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
        if getItemDetails(item) then
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


----------------------------------------------
--[[ Function: Checks Player's Loot State ]]--
----------------------------------------------

function isPlayerInLoot(player)

    if (not player or not isElement(player) or (player:getType() ~= "player")) then return false end
    if not isPlayerInitialized(player) then return false end

    if player:getData("Character:Looting") then
        local marker = player:getData("Loot:Marker")
        if marker and isElement(marker) then
            return marker
        end
    end
    return false

end