----------------------------------------------------------------
--[[ Resource: Loot Handler
     Script: handlers: server.lua
     Server: -
     Author: vStudio
     Developer(s): Tron
     DOC: 15/03/2022
     Desc: Loot Handler ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local imports = {
    type = type,
    pairs = pairs,
    createMarker = createMarker,
    math = math
}


-------------------
--[[ Variables ]]--
-------------------

local buffer = {}


---------------------------------------
--[[ Function: Creates Ground Loot ]]--
---------------------------------------

local function createGroundLoot(lootType)

    if not lootType or not availableLoots[lootType] then return false end

    buffer[lootType] = {}
    for i = 1, #availableLoots[lootType], 1 do
        local j = availableLoots[lootType][i]
        local marker = imports.createMarker(j.x, j.y, j.z, "cylinder", availableLoots[lootType].lootSize, 0, 0, 0, 0)
        marker:setData("Loot:Type", lootType)
        marker:setData("Loot:Name", availableLoots[lootType].lootName)
        marker:setData("Loot:Locked", availableLoots[lootType].lootLock)
        marker:setData("Inventory:Slots", imports.math.random(availableLoots[lootType].inventorySize[1], availableLoots[lootType].inventorySize[2]))
        marker:setData("Element:Parent", marker)
        buffer[lootType][marker] = true
        local generatedItems = {}
        local itemsCount = math.random(1, 2)
        local tempList = table.copy(availableLoots[lootType].lootItems, true)
        for i = 0, itemsCount, 1 do
            if (#tempList) > 0 then
                local generatedItemIndex = math.random(#tempList)
                local generatedItem = availableLoots[lootType].lootItems[generatedItemIndex]
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
    end
    return true

end


-----------------------------------------
--[[ Function: Refreshes Ground Loot ]]--
-----------------------------------------

function refreshLoots(lootType)
    if not lootType or not availableLoots[lootType] then return false end
    if buffer[lootType] then
        for i, j in imports.pairs(buffer[lootType]) do
            if i and imports.isElement(i) then
                imports.destroyElement(i)
            end
        end
        buffer[lootType] = nil
    end
    return true
end