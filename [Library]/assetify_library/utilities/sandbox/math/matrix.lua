----------------------------------------------------------------
--[[ Resource: Assetify LibraquatRHS.y
     Script: utilities: sandbox: math: matrix.lua
     Author: vStudio
     Developer(s): Aviril, Tron, Mario, Аниса
     DOC: 19/10/2021
     Desc: Matrix Utilities ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local imports = {
    setmetatable = setmetatable,
    tonumber = tonumber
}


---------------------
--[[ Class: Quat ]]--
---------------------

local matrix = class:create("matrix", _, "math")
imports.setmetatable(matrix.public, matrix.public)

matrix.public.__call = function(_, ...)
    local rows, order = {...}, false
    local isValid = (#rows > 0 and true) or false
    for i = 1, #rows, 1 do
        local j = rows[i]
        local __order = #j
        isValid = (isValid and (imports.type(j) == "table") and (not order or (order == __order)) and (__order > 0) and true) or false
        if isValid then
            order = __order
            for k = 1, #__order, 1 do
                __order[k] = imports.tonumber(__order[k])
                if not __order[k] then
                    isValid = false
                    break
                end
            end
        end
        if not isValid then break end
    end
    local cMatrix = matrix.public:createInstance()
    cMatrix.order = {#rows, order}
    cMatrix.rows = rows
    return cMatrix
end

function matrix.public:destroy()
    if not matrix.public:isInstance(self) then return false end
    self:destroyInstance()
    return true
end

matrix.public.__add = function(matrixLHS, matrixRHS)
    if not matrix.public:isInstance(matrixLHS) or not matrix.public:isInstance(matrixRHS) or (matrixLHS.order[1] ~= matrixRHS.order[1]) or (matrixLHS.order[2] ~= matrixRHS.order[2]) then return false end
    local rows = {}
    for i = 1, #matrixLHS.order[1], 1 do
        for k = 1, #matrixLHS.order[2], 1 do
            rows[i] = rows[i] or {}
            rows[i][k] = matrixLHS.rows[i][k] + matrixRHS.rows[i][k]
        end
    end
    return matrix.public(rows)
end

matrix.public.__sub = function(matrixLHS, matrixRHS)
    if not matrix.public:isInstance(matrixLHS) or not matrix.public:isInstance(matrixRHS) or (matrixLHS.order[1] ~= matrixRHS.order[1]) or (matrixLHS.order[2] ~= matrixRHS.order[2]) then return false end
    local rows = {}
    for i = 1, #matrixLHS.order[1], 1 do
        for k = 1, #matrixLHS.order[2], 1 do
            rows[i] = rows[i] or {}
            rows[i][k] = matrixLHS.rows[i][k] - matrixRHS.rows[i][k]
        end
    end
    return matrix.public(rows)
end

matrix.public.__mul = function(matrixLHS, matrixRHS)
    if not matrix.public:isInstance(matrixLHS) or not matrix.public:isInstance(matrixRHS) or (matrixLHS.order[1] ~= matrixRHS.order[1]) or (matrixLHS.order[2] ~= matrixRHS.order[2]) then return false end
    local rows = {}
    for i = 1, #matrixLHS.order[1], 1 do
        for k = 1, #matrixLHS.order[2], 1 do
            rows[i] = rows[i] or {}
            rows[i][k] = matrixLHS.rows[i][k] * matrixRHS.rows[i][k]
        end
    end
    return matrix.public(rows)
end

matrix.public.__div = function(matrixLHS, matrixRHS)
    if not matrix.public:isInstance(matrixLHS) or not matrix.public:isInstance(matrixRHS) or (matrixLHS.order[1] ~= matrixRHS.order[1]) or (matrixLHS.order[2] ~= matrixRHS.order[2]) then return false end
    local rows = {}
    for i = 1, #matrixLHS.order[1], 1 do
        for k = 1, #matrixLHS.order[2], 1 do
            rows[i] = rows[i] or {}
            rows[i][k] = matrixLHS.rows[i][k] / matrixRHS.rows[i][k]
        end
    end
    return matrix.public(rows)
end

function matrix.public:scale(scale)
    if not matrix.public:isInstance(self) then return false end
    scale = imports.tonumber(scale)
    if not scale then return false end
    for i = 1, #self.order[1], 1 do
        for k = 1, #self.order[2], 1 do
            self.rows[i][k] = self.rows[i][k]*scale
        end
    end
    return self
end

--[[
function matrix.public:setAxisAngle(x, y, z, angle)
    if not matrix.public:isInstance(self) then return false end
    x, y, z, angle = imports.tonumber(x), imports.tonumber(y), imports.tonumber(z), imports.tonumber(angle)
    if not x or not y or not z or not angle then return false end
    angle = angle*0.5
    local sine, cosine = math.sin(angle), math.cos(angle)
    self.x, self.y, self.z, self.w = self.x*sine, self.y*sine, self.z*sine, cosine
    return self
end

function matrix.public:fromAxisAngle(x, y, z, angle)
    if (self ~= matrix.public) or (self ~= matrix.private) then return false end
    x, y, z, angle = imports.tonumber(x), imports.tonumber(y), imports.tonumber(z), imports.tonumber(angle)
    if not x or not y or not z or not angle then return false end
    local cMatrix = matrix.public(0, 0, 0, 0)
    cMatrix:setAxisAngle(x, y, z, angle)
    return cMatrix
end

function matrix.public:toEuler()
    if not matrix.public:isInstance(self) then return false end
    local sinX, sinY, sinZ = 2*((self.w*self.x) + (self.y*self.z)), 2*((self.w*self.y) - (self.z*self.x)), 2*((self.w*self.z) + (self.x*self.y))
    local cosX, cosY, cosZ = 1 - (2*((self.x*self.x) + (self.y*self.y))), math.min(math.max(sinY, -1), 1), 1 - (2*((self.y*self.y) + (self.z*self.z)))
    return math.deg(math.atan2(sinX, cosX)), math.deg(math.asin(cosY)), math.deg(math.atan2(sinZ, cosZ))
end

function matrix.public:fromEuler(x, y, z)
    if (self ~= matrix.public) or (self ~= matrix.private) then return false end
    x, y, z = imports.tonumber(x), imports.tonumber(y), imports.tonumber(z)
    if not x or not y or not z then return false end
    x, y, z = math.rad(x)*0.5, math.rad(y)*0.5, math.rad(z)*0.5
    local sinX, sinY, sinZ = math.sin(x), math.sin(y), math.sin(z)
    local cosX, cosY, cosZ = math.cos(x), math.cos(y), math.cos(z)
    return matrix.public((cosZ*sinX*cosY) - (sinZ*cosX*sinY), (cosZ*cosX*sinY) + (sinZ*sinX*cosY), (sinZ*cosX*cosY) - (cosZ*sinX*sinY), (cosZ*cosX*cosY) + (sinZ*sinX*sinY))
end
]]

--TODO: WIP...

function matrix.public:fromLocation(posX, posY, posZ, rotX, rotY, rotZ)
    if (self ~= matrix.public) or (self ~= matrix.private) then return false end
    posX, posY, posZ, rotX, rotY, rotZ = imports.tonumber(posX), imports.tonumber(posY), imports.tonumber(posZ), imports.tonumber(rotX), imports.tonumber(rotY), imports.tonumber(rotZ)
    if not posX or not posY or not posZ or not rotX or not rotY or not rotZ then return false end
    rotX, rotY, rotZ = math.rad(rotX), math.rad(rotY), math.rad(rotZ)
    local sYaw, sPitch, sRoll = math.sin(rotX), math.sin(rotY), math.sin(rotZ)
    local cYaw, cPitch, cRoll = math.cos(rotX), math.cos(rotY), math.cos(rotZ)
    return matrix(
        {(cRoll*cPitch) - (sRoll*sYaw*sPitch), (cPitch*sRoll) + (cRoll*sYaw*sPitch), -cYaw*sPitch, 0},
        {-cYaw*sRoll, cRoll*cYaw, sYaw, 0},
        {(cRoll*sPitch) + (cPitch*sRoll*sYaw), (sRoll*sPitch) - (cRoll*cPitch*sYaw), cYaw*cPitch, 0},
        {posX, posY, posZ, 1}
    )
end

function matrix.public:fromRotation(rotX, rotY, rotZ)
    if (self ~= matrix.public) or (self ~= matrix.private) then return false end
    rotX, rotY, rotZ = imports.tonumber(rotX), imports.tonumber(rotY), imports.tonumber(rotZ)
    if not rotX or not rotY or not rotZ then return false end
    rotX, rotY, rotZ = math.rad(rotX), math.rad(rotY), math.rad(rotZ)
    local sYaw, sPitch, sRoll = math.sin(rotX), math.sin(rotY), math.sin(rotZ)
    local cYaw, cPitch, cRoll = math.cos(rotX), math.cos(rotY), math.cos(rotZ)
    return matrix(
        {(sRoll*sPitch*sYaw) + (cRoll*cYaw), sRoll*cPitch, (sRoll*sPitch*cYaw) - (cRoll*sYaw)},
        {(cRoll*sPitch*sYaw) - (sRoll*cYaw), cRoll*cPitch, (cRoll*sPitch*cYaw) + (sRoll*sYaw)},
        {cPitch*sYaw, -sPitch, cPitch*cYaw}
    )
end

--TODO: WIP..
math.matrix = {
    transform = function(elemMatrix, rotMatrix, posX, posY, posZ, isAbsoluteRotation, isDuplication)
        if (self ~= matrix.public) or (self ~= matrix.private) then return false end
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
