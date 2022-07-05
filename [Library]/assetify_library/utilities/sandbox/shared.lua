----------------------------------------------------------------
--[[ Resource: Assetify Library
     Script: utilities: sandbox: shared.lua
     Author: vStudio
     Developer(s): Aviril, Tron, Mario, Аниса
     DOC: 19/10/2021
     Desc: Shared Utilities ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local imports = {
    type = type,
    tonumber = tonumber,
    decodeString = decodeString,
    isElement = isElement,
    destroyElement = destroyElement,
    getElementMatrix = getElementMatrix,
    getElementPosition = getElementPosition,
    table = table,
    string = string,
    math = math
}


---------------
--[[ Utils ]]--
---------------

decodeString = function(decodeType, decodeData, decodeOptions, removeNull)
    if not decodeData or (imports.type(decodeData) ~= "string") then return false end
    local rawString = imports.decodeString(decodeType, decodeData, decodeOptions)
    if not rawString then return false end
    if removeNull then
        rawString = imports.string.gsub(rawString, imports.string.char(0), "")
    end
    return rawString
end

isElement = function(element)
    return (element and imports.isElement(element)) or false
end

destroyElement = function(element)
    return (isElement(element) and imports.destroyElement(element)) or false
end

getElementPosition = function(element, offX, offY, offZ)
    if not offX or not offY or not offZ then
        return imports.getElementPosition(element)
    else
        if not element or not imports.isElement(element) then return false end
        offX, offY, offZ = imports.tonumber(offX) or 0, imports.tonumber(offY) or 0, imports.tonumber(offZ) or 0
        local cMatrix = imports.getElementMatrix(element)
        return (offX*cMatrix[1][1]) + (offY*cMatrix[2][1]) + (offZ*cMatrix[3][1]) + cMatrix[4][1], (offX*cMatrix[1][2]) + (offY*cMatrix[2][2]) + (offZ*cMatrix[3][2]) + cMatrix[4][2], (offX*cMatrix[1][3]) + (offY*cMatrix[2][3]) + (offZ*cMatrix[3][3]) + cMatrix[4][3]
    end
end

getDistanceBetweenPoints2D = function(x1, y1, x2, y2)
    x1, y1, x2, y2 = imports.tonumber(x1), imports.tonumber(y1), imports.tonumber(x2), imports.tonumber(y2)
    if not x1 or not y1 or not x2 or not y2 then return false end
    return imports.math.sqrt(((x2 - x1)^2) + ((y2 - y1)^2))
end

getDistanceBetweenPoints3D = function(x1, y1, z1, x2, y2, z2)
    x1, y1, z1, x2, y2, z2 = imports.tonumber(x1), imports.tonumber(y1), imports.tonumber(z1), imports.tonumber(x2), imports.tonumber(y2), imports.tonumber(z2)
    if not x1 or not y1 or not z1 or not x2 or not y2 or not z2 then return false end
    return imports.math.sqrt(((x2 - x1)^2) + ((y2 - y1)^2) + ((z2 - z1)^2))
end


---------------------
--[[ Class: Math ]]--
---------------------

math.percent = function(amount, percent)
    amount, percent = imports.tonumber(amount), imports.tonumber(percent)
    if not percent or not amount then return false end
    return amount*percent*0.01
end

math.round = function(number, decimals)
    number = imports.tonumber(number)
    if not number then return false end
    decimals = imports.tonumber(decimals) or 0
    return imports.tonumber(imports.string.format("%."..decimals.."f", number))
end

math.findRotation2D = function(x1, y1, x2, y2) 
    x1, y1, x2, y2 = imports.tonumber(x1), imports.tonumber(y1), imports.tonumber(x2), imports.tonumber(y2)
    if not x1 or not y1 or not x2 or not y2 then return false end
    local rotAngle = -imports.math.deg(imports.math.atan2(x2 - x1, y2 - y1))
    return ((rotAngle < 0) and (rotAngle + 360)) or rotAngle
end

math.findDistRotationPoint2D = function(x, y, distance, angle)
    x, y, distance, angle = imports.tonumber(x), imports.tonumber(y), imports.tonumber(distance), imports.tonumber(angle)
    if not x or not y or not distance then return false end
    angle = angle or 0
    angle = imports.math.rad(90 - angle)
    return x + (imports.math.cos(angle)*distance), y + (imports.math.sin(angle)*distance)
end


-----------------------
--[[ Class: Matrix ]]--
-----------------------

matrix = {
    fromPosition = function(posX, posY, posZ, rotX, rotY, rotZ)
        if not posX or not posY or not posZ or not rotX or not rotY or not rotZ then return false end
        rotX, rotY, rotZ = imports.math.rad(rotX), imports.math.rad(rotY), imports.math.rad(rotZ)
        local sYaw, cYaw = imports.math.sin(rotX), imports.math.cos(rotX)
        local sPitch, cPitch = imports.math.sin(rotY), imports.math.cos(rotY)
        local sRoll, cRoll = imports.math.sin(rotZ), imports.math.cos(rotZ)
        return {
            {(cRoll*cPitch) - (sRoll*sYaw*sPitch), (cPitch*sRoll) + (cRoll*sYaw*sPitch), -cYaw*sPitch, 0},
            {-cYaw*sRoll, cRoll*cYaw, sYaw, 0},
            {(cRoll*sPitch) + (cPitch*sRoll*sYaw), (sRoll*sPitch) - (cRoll*cPitch*sYaw), cYaw*cPitch, 0},
            {posX, posY, posZ, 1}
        }
    end,

    fromRotation = function(rotX, rotY, rotZ)
        if not rotX or not rotY or not rotZ then return false end
        rotX, rotY, rotZ = imports.math.rad(rotX), imports.math.rad(rotY), imports.math.rad(rotZ)
        local sYaw, cYaw = imports.math.sin(rotX), imports.math.cos(rotX)
        local sPitch, cPitch = imports.math.sin(rotY), imports.math.cos(rotY)
        local sRoll, cRoll = imports.math.sin(rotZ), imports.math.cos(rotZ)
        return {
            {(sRoll*sPitch*sYaw) + (cRoll*cYaw), sRoll*cPitch, (sRoll*sPitch*cYaw) - (cRoll*sYaw)},
            {(cRoll*sPitch*sYaw) - (sRoll*cYaw), cRoll*cPitch, (cRoll*sPitch*cYaw) + (sRoll*sYaw)},
            {cPitch*sYaw, -sPitch, cPitch*cYaw}
        }
    end,

    transform = function(elemMatrix, rotMatrix, posX, posY, posZ, isAbsoluteRotation, isDuplication)
        if not elemMatrix or not rotMatrix or not posX or not posY or not posZ then return false end
        if isAbsoluteRotation then
            if isDuplication then elemMatrix = table.clone(elemMatrix, true) end
            for i = 1, 3, 1 do
                for k = 1, 3, 1 do
                    elemMatrix[i][k] = 1
                end
            end
        end
        return {
            {
                (elemMatrix[2][1]*rotMatrix[1][2]) + (elemMatrix[1][1]*rotMatrix[1][1]) + (rotMatrix[1][3]*elemMatrix[3][1]),
                (elemMatrix[3][2]*rotMatrix[1][3]) + (elemMatrix[1][2]*rotMatrix[1][1]) + (elemMatrix[2][2]*rotMatrix[1][2]),
                (elemMatrix[2][3]*rotMatrix[1][2]) + (elemMatrix[3][3]*rotMatrix[1][3]) + (rotMatrix[1][1]*elemMatrix[1][3]),
                0
            },
            {
                (rotMatrix[2][3]*elemMatrix[3][1]) + (elemMatrix[2][1]*rotMatrix[2][2]) + (rotMatrix[2][1]*elemMatrix[1][1]),
                (elemMatrix[3][2]*rotMatrix[2][3]) + (elemMatrix[2][2]*rotMatrix[2][2]) + (elemMatrix[1][2]*rotMatrix[2][1]),
                (rotMatrix[2][1]*elemMatrix[1][3]) + (elemMatrix[3][3]*rotMatrix[2][3]) + (elemMatrix[2][3]*rotMatrix[2][2]),
                0
            },
            {
                (elemMatrix[2][1]*rotMatrix[3][2]) + (rotMatrix[3][3]*elemMatrix[3][1]) + (rotMatrix[3][1]*elemMatrix[1][1]),
                (elemMatrix[3][2]*rotMatrix[3][3]) + (elemMatrix[2][2]*rotMatrix[3][2]) + (rotMatrix[3][1]*elemMatrix[1][2]),
                (rotMatrix[3][1]*elemMatrix[1][3]) + (elemMatrix[3][3]*rotMatrix[3][3]) + (elemMatrix[2][3]*rotMatrix[3][2]),
                0
            },
            {
                (posZ*elemMatrix[1][1]) + (posY*elemMatrix[2][1]) - (posX*elemMatrix[3][1]) + elemMatrix[4][1],
                (posZ*elemMatrix[1][2]) + (posY*elemMatrix[2][2]) - (posX*elemMatrix[3][2]) + elemMatrix[4][2],
                (posZ*elemMatrix[1][3]) + (posY*elemMatrix[2][3]) - (posX*elemMatrix[3][3]) + elemMatrix[4][3],
                1
            }
        }
    end
}