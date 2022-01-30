----------------------------------------------------------------
--[[ Resource: Config Loader
     Script: exports: shared.lua
     Author: vStudio
     Developer(s): Tron
     DOC: 25/01/2022
     Desc: Shared Exports ]]--
----------------------------------------------------------------


------------------------------------
--[[ Function: Retrieves Config ]]--
------------------------------------

function getConfig(...)

    local indexes = {...}
    local currentPointer = configVars
    if #indexes <= 0 then return false end

    for i, j in ipairs(indexes) do
        if j then
            currentPointer = currentPointer[j]
            if ((i < #indexes) and (not currentPointer or (type(currentPointer) ~= "table"))) then
                return false
            end
        else
            return false
        end
    end
    return currentPointer

end