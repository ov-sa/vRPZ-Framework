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
for i, j in imports.pairs(math.public) do
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

function math.public:findRotation2D(x1, y1, x2, y2) 
    x1, y1, x2, y2 = imports.tonumber(x1), imports.tonumber(y1), imports.tonumber(x2), imports.tonumber(y2)
    if not x1 or not y1 or not x2 or not y2 then return false end
    local rotation = -math.public:deg(math.public:atan2(x2 - x1, y2 - y1))
    return ((rotation < 0) and (rotation + 360)) or rotation
end

function math:findPointByRotation2D(x, y, distance, angle)
    x, y, distance, angle = imports.tonumber(x), imports.tonumber(y), imports.tonumber(distance), imports.tonumber(angle) or 0
    if not x or not y or not distance then return false end
    angle = math.public:rad(90 - angle)
    return x + (math.public:cos(angle)*distance), y + (math.public:sin(angle)*distance)
end