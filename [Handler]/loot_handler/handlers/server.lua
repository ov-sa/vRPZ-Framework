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
    pairs = pairs,
    isElement = isElement,
    setElementData = setElementData,
    math = math
}


-----------------------------------------
--[[ Functions: Refreshes Loot/Loots ]]--
-----------------------------------------

function refreshLoot(lootInstance, lootItems)
    if not lootInstance or not lootItems then return false end
    imports.setElementData(lootInstance, "Inventory:Slots", imports.math.random(FRAMEWORK_CONFIGS["Loots"][lootType].inventoryWeight[1], FRAMEWORK_CONFIGS["Loots"][lootType].inventoryWeight[2]))
    for i = 1, #lootItems, 1 do
        local j = lootItems[i]
        imports.setElementData(lootInstance, "Item:"..j.name, imports.math.random(j.amount[1], j.amount[2]))
        if j.ammo then --TODO: CHEKC IF ITS WEAPON..
            local ammoName = exports.player_handler:getammoName(j.name) --TODO: CHANE..
            imports.setElementData(lootInstance, "Item:"..ammoName, imports.math.random(j.ammo[1], j.ammo[2]))
        end
    end
end

function refreshLoots(lootType)
    if not lootType or not FRAMEWORK_CONFIGS["Loots"][lootType] then return false end
    loot.buffer.loot[lootType] = loot.buffer.loot[lootType] or {}
    if loot.buffer.loot[lootType] then
        thread:create(function(cThread)
            for i, j in imports.pairs(loot.buffer.loot[lootType]) do
                if i and imports.isElement(i) then
                    --TODO: RESET INVENTORY OF THE LOOT..
                    refreshLoot(lootInstance, FRAMEWORK_CONFIGS["Loots"][lootType].lootItems)
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
                local lootInstance loot:create(lootType, i)
                loot.buffer.loot[lootType][lootInstance] = true
                refreshLoot(lootInstance, FRAMEWORK_CONFIGS["Loots"][lootType].lootItems)
                thread.pause()
            end
        end):resume({
            executions = syncSettings.syncRate,
            frames = 1
        })
    end
    return true
end