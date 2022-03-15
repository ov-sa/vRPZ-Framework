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
    setElementData = setElementData,
    math = math
}


-------------------
--[[ Variables ]]--
-------------------

local buffer = {}


-----------------------------------------
--[[ Function: Refreshes Ground Loot ]]--
-----------------------------------------

function refreshLoots(lootType)
    if not lootType or not availableLoots[lootType] then return false end
    buffer[lootType] = buffer[lootType] or {}
    if buffer[lootType] then
        for i, j in imports.pairs(buffer[lootType]) do
            if i and imports.isElement(i) then
                --TODO: RESET INVENTORY OF THE LOOT..
            end
        end
    else
        for i = 1, #availableLoots[lootType], 1 do
            local j = availableLoots[lootType][i]
            local marker = imports.createMarker(j.x, j.y, j.z, "cylinder", availableLoots[lootType].lootSize, 0, 0, 0, 0)
            imports.setElementData(marker, "Loot:Type", lootType)
            imports.setElementData(marker, "Loot:Name", availableLoots[lootType].lootName)
            imports.setElementData(marker, "Loot:Locked", availableLoots[lootType].lootLock)
            imports.setElementData(marker, "Inventory:Slots", imports.math.random(availableLoots[lootType].inventorySize[1], availableLoots[lootType].inventorySize[2]))
            imports.setElementData(marker, "Element:Parent", marker)
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
                imports.setElementData(marker, "Item:"..j.name, j.amountRange)
                if j.ammoRange then
                    local weaponAmmoName = exports.player_handler:getWeaponAmmoName(j.name)
                    if weaponAmmoName then
                        imports.setElementData(marker, "Item:"..weaponAmmoName, math.random(j.ammoRange[1], j.ammoRange[2]))
                    end
                end
            end
            buffer[lootType][marker] = true
        end
    end
    return true
end