----------------------------------------------------------------
--[[ Resource: Assetify Library
     Script: utilities: sandbox: math: index.lua
     Author: vStudio
     Developer(s): Aviril, Tron, Mario, Аниса
     DOC: 19/10/2021
     Desc: Math Utilities ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local imports = {
    type = type,
    pairs = pairs,
    tonumber = tonumber,
    loadstring = loadstring
}


---------------------
--[[ Class: Math ]]--
---------------------

local math = namespace:create("math", math)
for i, j in imports.pairs(math) do
    if imports.type(math.public[i]) == "function" then
        imports.loadstring([[
            local __math_]]..i..[[ = math.]]..i..[[
            function math:]]..i..[[(...) return __math_]]..i..[[(...) end
        ]])()
    end
end

function math.public:round(number, decimals)
    number = imports.tonumber(number)
    if not number then return false end
    return imports.tonumber(string:format("%."..(imports.tonumber(decimals) or 0).."f", number))
end