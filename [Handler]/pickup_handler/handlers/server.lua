----------------------------------------------------------------
--[[ Resource: Pickup Handler
     Script: handlers: server.lua
     Server: -
     Author: OvileAmriam
     Developer: -
     DOC: 22/03/2021 (OvileAmriam)
     Desc: Pickup Handler ]]--
----------------------------------------------------------------


--------------------------------------------------
--[[ Functions: Creates/Destroys Pick Up Item ]]--
--------------------------------------------------

function createPickupItem(pickupDatas, expiryDuration)

    expiryDuration = tonumber(expiryDuration)
    if not pickupDatas or type(pickupDatas) ~= "table" or not pickupDatas.item then return false end
    local itemDetails = exports.player_handler:getItemDetails(pickupDatas.item)
    if not itemDetails or not itemDetails.itemPickupDetails then return false end
    local pickupData = itemDetails.itemPickupDetails
    local objectID = tonumber(pickupData.objectID)
    if not objectID then objectID = tonumber(itemDetails.itemObjectID) end
    if not objectID then return false end

    local createdPickup = Object(objectID, pickupDatas.x, pickupDatas.y, pickupDatas.z + (tonumber(pickupData.offZ) or 0), tonumber(pickupData.rotX) or 0, tonumber(pickupData.rotY) or 0, math.random(0, 360))
    createdPickup:setScale(tonumber(pickupData.scale) or 1)
    createdPickup:setDoubleSided(true)
    createdPickup:setData("Pickup:Type", "item")
    createdPickup:setData("Pickup:Name", itemDetails.itemName)
    createdPickup:setData("Pickup:Owner", pickupDatas.owner)
    createdPickup:setData("Pickup:OwnerID", pickupDatas.ownerID)
    createdPickup:setData("Pickup:Item", pickupDatas.item)
    createdPickup:setData("Pickup:ItemValue", pickupDatas.value or 1)
    createdPickup:setData("Pickup:ExpiryTimer", Timer(function(createdPickup)
        destroyPickupItem(createdPickup) 
    end, expiryDuration or pickupExpiryDuration, 1, createdPickup), false)
    return pickup

end
addEvent("createPickupItem", true)
addEventHandler("createPickupItem", root, createPickupItem)

function destroyPickupItem(pickup)

    if not pickup or not isElement(pickup) then return false end
    local pickupType = pickup:getData("Pickup:Type")
    if not pickupType then return false end

    if pickupType == "item" then
        local expiryTimer = pickup:getData("Pickup:ExpiryTimer")
        if expiryTimer and expiryTimer:isValid() then expiryTimer:destroy() end
        pickup:destroy()
    end

end
addEvent("destroyPickupItem", true)
addEventHandler("destroyPickupItem", root, destroyPickupItem)