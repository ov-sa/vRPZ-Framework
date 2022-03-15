----------------------------------------------------------------
--[[ Resource: Ground Loot Handler
     Script: utilities: shared.lua
     Server: -
     Author: vStudio
     Developer: -
     DOC: 14/12/2020
     Desc: Shared Utilities ]]--
----------------------------------------------------------------


-------------------------------------------
--[[ Function: Retrieves Copy Of Table ]]--
-------------------------------------------

function table.copy(recievedTable, recursive)

    if not recievedTable or type(recievedTable) ~= "table" then return false end

    local copiedTable = {}
    for key, value in pairs(recievedTable) do
        if type(value) == "table" and recursive then
            copiedTable[key] = table.copy(value, true)
        else
            copiedTable[key] = value
        end
    end
    return copiedTable

end