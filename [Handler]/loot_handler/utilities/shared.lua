----------------------------------------------------------------
--[[ Resource: Loot Handler
     Script: utilities: shared.lua
     Server: -
     Author: vStudio
     Developer(s): Tron
     DOC: 15/03/2022
     Desc: Shared Utilities ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local imports = {
    type = type,
    pairs = pairs
}


----------------------
--[[ Class: Table ]]--
----------------------

function table.clone(baseTable, isRecursive)
    if not baseTable or imports.type(baseTable) ~= "table" then return false end
    local clonedTable = {}
    for i, j in imports.pairs(baseTable) do
        if imports.type(j) == "table" and isRecursive then
            clonedTable[i] = table.clone(j, true)
        else
            clonedTable[i] = j
        end
    end
    return clonedTable
end
