----------------------------------------------------------------
--[[ Resource: Player Handler
     Script: exports: shared: player.lua
     Author: vStudio
     Developer(s): Mario, Tron
     DOC: 31/01/2022
     Desc: Main Shared Exports ]]--
----------------------------------------------------------------

------------------------------------------------------------
--[[ Function: Retrieves Player's Initialization Status ]]--
------------------------------------------------------------

function isPlayerInitialized(player)

    if not player or not isElement(player) or player:getType() ~= "player" then return false end

    return player:getData("Player:Initialized") or false

end


----------------------------------------------------
--[[ Function: Retrieves Player By Character ID ]]--
----------------------------------------------------

function getPlayerByCharacterID(characterID)

    if not characterID then return false end

    for i, j in ipairs(Element.getAllByType("player")) do
        if isPlayerInitialized(j) then
            local _characterID = j:getData("Character:ID")
            if _characterID == characterID then
                return j
            end
        end
    end
    return false

end


---------------------------------------------
--[[ Function: Retrieves Player's Health ]]--
---------------------------------------------

function getPlayerHealth(player)

    if not player or not isElement(player) or player:getType() ~= "player" then return false end
    if not isPlayerInitialized(player) then return false end

    return tonumber(player:getData("Character:blood")) or 0

end


-----------------------------------------------------
--[[ Function: Retrieves Player's Maximum Health ]]--
-----------------------------------------------------

function getPlayerMaximumHealth(player)

    if not player or not isElement(player) or player:getType() ~= "player" then return false end
    if not isPlayerInitialized(player) then return false end

    return characterMaximumBlood

end


--------------------------------------------------
--[[ Functions: Sets/Retrieves Player's Money ]]--
--------------------------------------------------

function setPlayerMoney(player, money)

    money = tonumber(money)
    if not player or not isElement(player) or player:getType() ~= "player" or not money then return false end
    if not isPlayerInitialized(player) then return false end

    return player:setData("Character:money", math.max(0, money))

end

function getPlayerMoney(player)

    if not player or not isElement(player) or player:getType() ~= "player" then return false end
    if not isPlayerInitialized(player) then return false end

    return tonumber(player:getData("Character:money")) or 0

end


-------------------------------------------------
--[[ Function: Retrieves Player's Occupation ]]--
-------------------------------------------------

function getPlayerOccupation(player)

    if not player or not isElement(player) or player:getType() ~= "player" then return false end
    if not isPlayerInitialized(player) then return false end

    local playerOccupation = player:getData("Character:occupation")
    if playerOccupation and playerOccupations[playerOccupation] then
        return playerOccupation
    end
    return false

end


----------------------------------------------
--[[ Function: Retrieves Player's Faction ]]--
----------------------------------------------

function getPlayerFaction(player)

    if not player or not isElement(player) or player:getType() ~= "player" then return false end
    if not isPlayerInitialized(player) then return false end

    return player:getData("Character:Faction") or false

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

    if not player or not isElement(player) or player:getType() ~= "player" then return false end
    if not isPlayerInitialized(player) then return false end

    if player:getData("Character:Looting") then
        local marker = player:getData("Loot:Marker")
        if marker and isElement(marker) then
            return marker
        end
    end
    return false

end


----------------------------------------------------------
--[[ FUnction: Checks Player's Weapon Reloading State ]]--
----------------------------------------------------------

function isPlayerReloadingWeapon(player)

    if not player or not isElement(player) or player:getType() ~= "player" then return false end
    if not isPlayerInitialized(player) then return false end

    return player:getData("Character:ReloadingWeapon") or false

end


---------------------------------------------------
--[[ Function: Checks Player's Knockdown State ]]--
---------------------------------------------------

function isPlayerKnocked(player)

    if not player or not isElement(player) or player:getType() ~= "player" then return false end
    if not isPlayerInitialized(player) then return false end

    return player:getData("Character:Knocked") or false

end