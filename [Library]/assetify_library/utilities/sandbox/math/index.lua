----------------------------------------------------------------
--[[ Resource: Assetify Library
     Script: utilities: sandbox: math: index.lua
     Author: vStudio
     Developer(s): Aviril, Tron, Mario, Аниса
     DOC: 19/10/2021
     Desc: Math Utilities ]]--
----------------------------------------------------------------


---------------------
--[[ Class: Math ]]--
---------------------

local math = namespace:create("math", math)

math.round = function(number, decimals)
    number = imports.tonumber(number)
    if not number then return false end
    return imports.tonumber(imports.string:format("%."..(imports.tonumber(decimals) or 0).."f", number))
end