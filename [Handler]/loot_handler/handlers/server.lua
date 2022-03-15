----------------------------------------------------------------
--[[ Resource: Loot Handler
     Script: handlers: server.lua
     Server: -
     Author: vStudio
     Developer: -
     DOC: 15/03/2022
     Desc: Loot Handler ]]--
----------------------------------------------------------------


-------------------
--[[ Variables ]]--
-------------------

local createdgroundLoots = {}


---------------------------------------
--[[ Function: Creates Ground Loot ]]--
---------------------------------------

local function createGroundLoot(lootType)

    if not lootType or not availableLootPoints[lootType] then return false end

    Async:setPriority("low")
    createdgroundLoots[lootType] = {}
    Async:foreach(availableLootPoints[lootType], function(j)
        local marker = Marker(j.x, j.y, j.z, "cylinder", 2, 0, 0, 0, 0)
        marker:setData("Loot:Type", "groundloot")
        marker:setData("Loot:Name", tostring(availableLootPoints[lootType].lootName))
        marker:setData("Loot:Locked", availableLootPoints[lootType].lockedStatus)
        marker:setData("Inventory:Slots", math.random(1, 6))
        marker:setData("Element:Parent", marker)
        table.insert(createdgroundLoots[lootType], marker)

        local generatedItems = {}
        local itemsCount = math.random(1, 2)
        local tempList = table.copy(availableLootPoints[lootType].lootItems, true)
        for i = 0, itemsCount, 1 do
            if (#tempList) > 0 then
                local generatedItemIndex = math.random(#tempList)
                local generatedItem = availableLootPoints[lootType].lootItems[generatedItemIndex]
                table.insert(generatedItems, generatedItem)
                table.remove(tempList, generatedItemIndex)
            end
        end
        for i, j in ipairs(generatedItems) do
            marker:setData("Item:"..j.name, j.amountRange)
            if j.ammoRange then
                local weaponAmmoName = exports.player_handler:getWeaponAmmoName(j.name)
                if weaponAmmoName then
                    marker:setData("Item:"..weaponAmmoName, math.random(j.ammoRange[1], j.ammoRange[2]))
                end
            end
        end
    end, function()
        triggerEvent("onAsyncLoadGroundLoots", root, lootType)
    end)
    return true

end


-----------------------------------------
--[[ Function: Refreshes Ground Loot ]]--
-----------------------------------------

function refreshGroundLoot(lootType)

    if not lootType or not availableLootPoints[lootType] then return false end

    if createdgroundLoots[lootType] then
        Async:setPriority("low")
        Async:foreach(createdgroundLoots[lootType], function(j)
            if j and isElement(j) then
                j:destroy()
            end
        end, function()
            createdgroundLoots[lootType] = nil
            createGroundLoot(lootType)
        end)
    else
        createGroundLoot(lootType)
    end
    return true

end