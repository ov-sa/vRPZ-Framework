----------------------------------------------------------------
--[[ Resource: Player Handler
     Script: handlers: inventory: gui: itemUser.lua
     Server: -
     Author: OvileAmriam
     Developer: -
     DOC: 18/12/2020 (OvileAmriam)
     Desc: Item User Handler ]]--
----------------------------------------------------------------

--TODO: ...

-------------------------------------
--[[ Function: Requests Item Use ]]--
-------------------------------------

function requestUseItem(item)

    --[[
    if not item or localPlayer:getData("Player:Proned") or getPedSimplestTask(localPlayer) == "TASK_SIMPLE_IN_AIR" then return false end
    local itemDetails, itemCategory = getItemDetails(item)
    if not itemDetails or not itemCategory then return false end
    local playerVehicle = localPlayer:getOccupiedVehicle()

    if itemCategory == "primary_weapon" or itemCategory == "secondary_weapon" or itemCategory == "special_weapon" then
        local weaponSlotName = getWeaponSlotName(itemDetails.dataName)
        if not weaponSlotName then return false end
        local currentWeapon = localPlayer:getData("Slot:"..weaponSlotName)
        if currentWeapon and currentWeapon == itemDetails.dataName then return false end
        if itemDetails.weaponAmmo == "Melee" then
            triggerServerEvent("onPlayerRefreshWeapon", localPlayer, itemDetails.dataName)
        else
            if (tonumber(localPlayer:getData("Item:"..itemDetails.weaponAmmo)) or 0) <= 0 then
                triggerEvent("displayClientInfo", localPlayer, "You don't have the ammunition of this weapon. ("..tostring(getItemName(itemDetails.weaponAmmo))..")", {255, 0, 0})
                return false
            end
            triggerServerEvent("onPlayerRefreshWeapon", localPlayer, itemDetails.dataName)
            triggerEvent("onClientWeaponArmSound", localPlayer)
        end
        if weaponSlotName == "primary_weapon" then
            inventoryCache.primary = itemDetails.dataName
        elseif weaponSlotName == "secondary_weapon" then
            inventoryCache.secondary = itemDetails.dataName
        elseif weaponSlotName == "special_weapon" then
            inventoryCache.tertiary = itemDetails.dataName
        end
    elseif itemCategory == "Backpack" then
        if not inventoryCache.backpack then
            localPlayer:setData("Slot:backpack", itemDetails.dataName)
            inventoryCache.backpack = itemDetails.dataName
        else
            local usedSlots = getElementUsedSlots(localPlayer)
            if (usedSlots < itemDetails.backpackSlots) then
                localPlayer:setData("Slot:backpack", itemDetails.dataName)
                inventoryCache.backpack = itemDetails.dataName
            else
                triggerEvent("displayClientInfo", localPlayer, "This backpack is too small.", {255, 0, 0})
            end
        end
    elseif itemCategory == "Helmet" then
        if not inventoryCache.helmet then
            localPlayer:setData("Slot:helmet", itemDetails.dataName)
        else
            if inventoryCache.helmet ~= itemDetails.dataName then
                localPlayer:setData("Slot:helmet", itemDetails.dataName)
            end
        end
        inventoryCache.helmet = itemDetails.dataName
    elseif itemCategory == "Armor" then
        if not inventoryCache.armor then
            localPlayer:setData("Slot:armor", itemDetails.dataName)
        else
            if inventoryCache.armor ~= itemDetails.dataName then
                localPlayer:setData("Slot:armor", itemDetails.dataName)
            end
        end
        inventoryCache.armor = itemDetails.dataName
    elseif isInventoryEnabled() then
        if itemCategory == "Nutrition" then
            if itemDetails.nutritionAction == "eat" then
                if (tonumber(localPlayer:getData("Player:hunger")) or 0) < 100 then
                    enableInventory(false)
                    triggerServerEvent("onPlayerConsumeNutrition", localPlayer, itemDetails.dataName, itemDetails.nutritionAction)
                end
            elseif itemDetails.nutritionAction == "drink" then
                if (tonumber(localPlayer:getData("Player:thirst")) or 0) < 100 then
                    enableInventory(false)
                    triggerServerEvent("onPlayerConsumeNutrition", localPlayer, itemDetails.dataName, itemDetails.nutritionAction)
                end
            end
        elseif itemCategory == "Suit" then
            if playerVehicle then return false end
            local playerModel = source:getModel()
            if itemDetails.dataName == "Survivor Suit" then
                local gender = source:getData("Player:Gender")
                if gender == playerClothes["Gender"][1] then
                    if playerModel == 0 then
                        return false
                    end
                else
                    if playerModel == 35 then
                        return false
                    end
                end
            else
                if playerModel == itemDetails.skinModel then
                    return false
                end
            end
            closeInventory()
            enableInventory(false)
            triggerServerEvent("onPlayerRequestClothing", localPlayer, itemDetails.dataName)
        elseif itemCategory == "Tent" then
            if isPlayerReadyForPlaceBuilding(localPlayer) then
                enableInventory(false)
                placeBuilding(itemDetails.dataName, "place_tent")
            else
                triggerEvent("displayClientInfo", localPlayer, "You can't build the place here.", {255, 0, 0})
            end
        elseif itemCategory == "Build" then
            if isPlayerReadyForPlaceBuilding(localPlayer) then
                enableInventory(false)
                placeBuilding(itemDetails.dataName, itemDetails.buildTaskID)
            else
                triggerEvent("displayClientInfo", localPlayer, "You can't build the place here.", {255, 0, 0})
            end
        elseif itemDetails.dataName == "Flare" then
            if playerVehicle then return false end
            enableInventory(false)
            local posVector = localPlayer:getPosition()
            local rotVector = localPlayer:getRotation()
            local place = {
                x = posVector.x,
                y = posVector.y,
                z = getGroundPosition(posVector.x, posVector.y, posVector.z) + 0.1,
            }
            triggerServerEvent("onPlayerPlaceBengale", localPlayer, place)
        elseif itemCategory == "Medical" then
            if itemDetails.dataName == "Painkiller" then
                if (tonumber(localPlayer:getData("Player:pain")) or 0) <= 0 then triggerEvent("displayClientInfo", localPlayer, "You don't feel pain.", {255, 0, 0}) return false end
            elseif itemDetails.dataName == "Antibiotics" then
                if (tonumber(localPlayer:getData("Player:infection")) or 0) <= 0 then triggerEvent("displayClientInfo", localPlayer, "You aren't infected.", {255, 0, 0}) return false end
            elseif itemDetails.dataName == "Morphine" then
                if (tonumber(localPlayer:getData("Player:brokenbone")) or 0) <= 0 then triggerEvent("displayClientInfo", localPlayer, "Your bones aren't broken.", {255, 0, 0}) return false end
            elseif itemDetails.dataName == "First Aid Kit" then
                if getPlayerHealth(localPlayer) >= getPlayerMaximumHealth(localPlayer) then triggerEvent("displayClientInfo", localPlayer, "Your health appears fine.", {255, 0, 0}) return false end
            elseif itemDetails.dataName == "Bandage" then
                if (tonumber(localPlayer:getData("Player:bleeding")) or 0) <= 0 then triggerEvent("displayClientInfo", localPlayer, "You are not bleeding.", {255, 0, 0}) return false end
            elseif itemDetails.dataName == "Heatpack" then
                if (tonumber(localPlayer:getData("Player:cold")) or 0) <= 0 then triggerEvent("displayClientInfo", localPlayer, "You don't feel cold.", {255, 0, 0}) return false end
            elseif string.find(itemDetails.dataName, "Blood Bag") then
                local playerBloodGroup = localPlayer:getData("Player:bloodgroup")
                if not getItemDetails("Blood Bag ("..playerBloodGroup..")") then triggerEvent("displayClientInfo", localPlayer, "You can't transfuse.", {255, 0, 0}) return false end
                local bloodbagType = string.gsub(itemDetails.dataName, "Blood Bag ", "", 1)
                bloodbagType = string.sub(bloodbagType, 2, #bloodbagType - 1)
                if bloodbagType ~= playerBloodGroup then triggerEvent("displayClientInfo", localPlayer, "Your blood group doesn't match with the blood bag.", {255, 0, 0}) return false end
                if getPlayerHealth(localPlayer) >= getPlayerMaximumHealth(localPlayer) then triggerEvent("displayClientInfo", localPlayer, "You can't do more transfusion.", {255, 0, 0}) return false end
            elseif itemDetails.dataName == "Blood Transfuser" then
                local playerBloodGroup = localPlayer:getData("Player:bloodgroup")
                if not getItemDetails("Blood Bag ("..playerBloodGroup..")") then triggerEvent("displayClientInfo", localPlayer, "You can't transfuse.", {255, 0, 0}) return false end
                if (getPlayerHealth(localPlayer) - 4000) < 4000 then triggerEvent("displayClientInfo", localPlayer, "You can't do more transfusion.", {255, 0, 0}) return false end
            elseif itemDetails.dataName == "Steroids" then
                if localPlayer:getData("Player:OnSteroids") then triggerEvent("displayClientInfo", localPlayer, "You are already on "..tostring(getItemName("Steroids"))..".", {255, 0, 0}) return false end
            elseif itemDetails.dataName == "Antiradiation Pills" then
                if not isPlayerOnRadiation() then triggerEvent("displayClientInfo", localPlayer, "You are already on "..tostring(getItemName("Antiradiation Pills"))..".", {255, 0, 0}) return false end
            end
            enableInventory(false)
            triggerServerEvent("onPlayerConsumeMedicine", localPlayer, itemDetails.dataName)
        else
            return false
        end
    end
    ]]--
    return true

end