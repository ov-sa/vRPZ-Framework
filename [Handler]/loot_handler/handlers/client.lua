----------------------------------------------------------------
--[[ Resource: Ground Loot Handler
     Script: handlers: client.lua
     Server: -
     Author: vStudio
     Developer: -
     DOC: 14/12/2020
     Desc: Ground Loot Handler ]]--
----------------------------------------------------------------


-------------------
--[[ Variables ]]--
-------------------

local groundLoots = {}


---------------------------------------
--[[ Function: Updates Ground Loot ]]--
---------------------------------------

local function updateGroundLoot(lootMarker)

    if not lootMarker or not isElement(lootMarker) or lootMarker:getType() ~= "marker" then return false end
    local lootType = lootMarker:getData("Loot:Type")
    if not lootType or lootType ~= "groundloot" then return false end

    local lootDatas = {}
    local lootItemDatas = {}
    for i, j in pairs(inventoryDatas) do
        for k, v in ipairs(j) do
            lootDatas[v.dataName] = tonumber(lootMarker:getData("Item:"..v.dataName)) or 0
        end
    end
    for i, j in pairs(lootDatas) do
        if (tonumber(j) or 0) > 0 then
            lootItemDatas[i] = true
        end
    end

    if not groundLoots[lootMarker] then
        groundLoots[lootMarker] = {}
    else
        for i, j in pairs(groundLoots[lootMarker]) do
            if i ~= "__isToBeUpdated" then
                if not lootItemDatas[i] then
                    if j and isElement(j) then
                        j:destroy()
                    end
                    groundLoots[lootMarker][i] = nil
                end
            end
        end
    end
    for i, j in pairs(lootItemDatas) do
        if not groundLoots[lootMarker][i] and not isElement(groundLoots[lootMarker][i]) then
            local itemDetails = exports.player_handler:getItemDetails(i)
            if itemDetails and itemDetails.itemPickupDetails then
                local pickupData = itemDetails.itemPickupDetails
                local objectID = tonumber(pickupData.objectID)
                if not objectID then objectID = tonumber(itemDetails.itemObjectID) end
                if objectID then
                    local posVector = lootMarker:getPosition()
                    posVector.x = posVector.x + math.random(-0.5, 0.5) * math.cos(math.rad(math.random(0, 360) + 90))
                    posVector.y = posVector.y + math.random(-0.5, 0.5) * math.sin(math.rad(math.random(0, 360) + 90))
                    posVector.z = posVector.z + 0.1
                    groundLoots[lootMarker][i] = Object(objectID, posVector.x, posVector.y, posVector.z + (tonumber(pickupData.offZ) or 0), tonumber(pickupData.rotX) or 0, 0, math.random(0, 360))    
                    groundLoots[lootMarker][i]:setScale(tonumber(pickupData.scale) or 1)
                    groundLoots[lootMarker][i]:setCollisionsEnabled(false)
                    groundLoots[lootMarker][i]:setDoubleSided(true)
                end
            end
        end
    end
    groundLoots[lootMarker].__isToBeUpdated = false
    return true

end

addEventHandler("onClientElementDataChange", resourceRoot, function(key, oldValue, newValue)

    if source:getType() ~= "marker" or not string.find(key, "Item:", 1) then return false end

    if not isElementStreamedIn(source) then
        if groundLoots[source] then
            groundLoots[source].__isToBeUpdated = true
        end
    else
        updateGroundLoot(source)
    end
    
end)

addEventHandler("onClientElementStreamIn", resourceRoot, function()

    if groundLoots[source] then
        if groundLoots[source].__isToBeUpdated then
            updateGroundLoot(source)
        end
    else
        updateGroundLoot(source)
    end

end)


------------------------------------------
--[[ Event: On Client Element Destroy ]]--
------------------------------------------

addEventHandler("onClientElementDestroy", resourceRoot, function()

    if not groundLoots[source] then return false end

    for i, j in pairs(groundLoots[source]) do
        if i ~= "__isToBeUpdated" then
            if j and isElement(j) then
                j:destroy()
            end
        end
    end
    groundLoots[source] = nil
    return true

end)