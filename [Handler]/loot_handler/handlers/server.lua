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
    isElement = isElement,
    createMarker = createMarker,
    setElementData = setElementData,
    math = math
}


-------------------
--[[ Variables ]]--
-------------------

local buffer = {}


-----------------------------------------
--[[ Functions: Refreshes Loot/Loots ]]--
-----------------------------------------

function refreshLoot(lootMarker, lootItems)
    if not lootMarker or not lootItems then return false end
    imports.setElementData(lootMarker, "Inventory:Slots", imports.math.random(FRAMEWORK_CONFIGS["Loots"][lootType].inventoryWeight[1], FRAMEWORK_CONFIGS["Loots"][lootType].inventoryWeight[2]))
    for i = 1, #lootItems, 1 do
        local j = lootItems[i]
        imports.setElementData(lootMarker, "Item:"..j.name, imports.math.random(j.amount[1], j.amount[2]))
        if j.ammo then --TODO: CHEKC IF ITS WEAPON..
            local ammoName = exports.player_handler:getammoName(j.name) --TODO: CHANE..
            imports.setElementData(lootMarker, "Item:"..ammoName, imports.math.random(j.ammo[1], j.ammo[2]))
        end
    end
end

function refreshLoots(lootType)
    if not lootType or not FRAMEWORK_CONFIGS["Loots"][lootType] then return false end
    buffer[lootType] = buffer[lootType] or {}
    if buffer[lootType] then
        thread:create(function(cThread)
            for i, j in imports.pairs(buffer[lootType]) do
                if i and imports.isElement(i) then
                    --TODO: RESET INVENTORY OF THE LOOT..
                    refreshLoot(lootMarker, FRAMEWORK_CONFIGS["Loots"][lootType].lootItems)
                end
                thread.pause()
            end
        end):resume({
            executions = syncSettings.syncRate,
            frames = 1
        })
    else
        thread:create(function(cThread)
            for i = 1, #FRAMEWORK_CONFIGS["Loots"][lootType], 1 do
                local j = FRAMEWORK_CONFIGS["Loots"][lootType][i]
                local lootMarker = imports.createMarker(j.x, j.y, j.z, "cylinder", FRAMEWORK_CONFIGS["Loots"][lootType].lootSize, 0, 0, 0, 0)
                imports.setElementData(lootMarker, "Loot:Type", lootType)
                imports.setElementData(lootMarker, "Loot:Name", FRAMEWORK_CONFIGS["Loots"][lootType].lootName)
                imports.setElementData(lootMarker, "Loot:Locked", FRAMEWORK_CONFIGS["Loots"][lootType].lootLock)
                buffer[lootType][lootMarker] = true
                refreshLoot(lootMarker, FRAMEWORK_CONFIGS["Loots"][lootType].lootItems)
                thread.pause()
            end
        end):resume({
            executions = syncSettings.syncRate,
            frames = 1
        })
    end
    return true
end