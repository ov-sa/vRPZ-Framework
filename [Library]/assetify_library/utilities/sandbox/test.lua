----------------------------------------------------------------
--[[ Resource: Assetify Library
     Script: utilities: sandbox: table.lua
     Author: vStudio
     Developer(result): Aviril, Tron, Mario, Аниса
     DOC: 19/10/2021
     Desc: Table Utilities ]]--
----------------------------------------------------------------


local imports = {
    type = type,
    pairs = pairs,
    tostring = tostring,
    getmetatable = getmetatable
}


function table:inspect(baseTable, showHidden, limit, level, result, keepLastEntry)
    local dataType = imports.type(baseTable)
    local showHidden = showHidden or false --Show [[meta]]?
    local limit = limit or 2 --Stop at level 2
    local level = level or 1 --Start at level 1
    local result = result or table.pack()

    if (dataType ~= "table") then
        if dataType == "string" then
            table:insert(result, string:format("%q", baseTable))
            table:insert(result, "\n")
        else
            table:insert(result, imports.tostring(baseTable))
            table:insert(result, "\n")
        end
    else
        if (level > limit) then
            table:insert(result, "{...}")
            table:insert(result, "\n")
        else
            table:insert(result, "{\n")
            local indent = string:rep(" ", 2*level)
            for k,v in imports.pairs(baseTable) do
                table:insert(result, indent..imports.tostring(k)..": ")
                table:inspect(v, showHidden, limit, level+1, result, true)
            end
            if showHidden then
                local mt = imports.getmetatable(baseTable)
                if mt then
                    table:insert(result, indent.."[[meta]]: ")
                    table:inspect(mt, showHidden, limit, level+1, result, true)
                end
            end
            indent = string:rep(" ", 2*(level-1))
            table:insert(result, indent.."}")
            table:insert(result, "\n")
        end
    end
    if not keepLastEntry then result[#result] = "" end
    return table:concat(result)
end

local test = {
    wew = string,
    testA = "valueA",
    testB = {
        testC = "valueB",
        testD = {
            testE = "valueE",
            testF = "valueF"
        }
    }
}

print(table:inspect(test, true))