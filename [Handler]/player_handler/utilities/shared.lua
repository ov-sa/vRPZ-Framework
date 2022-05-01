----------------------------------------------------------------
--[[ Resource: Player Handler
     Script: utilities: shared.lua
     Author: vStudio
     Developer(s): Mario, Tron, Aviril, Аниса
     DOC: 31/01/2022
     Desc: Shared Utilities ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

loadstring(exports.assetify_library:fetchImports())()
loadstring(exports.assetify_library:fetchThreader())()
local imports = {
    type = type,
    pairs = pairs,
    tostring = tostring,
    tonumber = tonumber,
    string = string,
    isElement = isElement,
    bindKey = bindKey,
    unbindKey = unbindKey,
    getResourceName = getResourceName,
    getResourceState = getResourceState,
    isElementWithinMarker = isElementWithinMarker,
    table = table,
    math = math,
    assetify = assetify
}


----------------------
--[[ Module: Game ]]--
----------------------

local scheduledExecs = {
    onLoad = {},
    onModuleLoad = {}
}
CGame = {
    execOnLoad = function(execFunc)
        if not execFunc then return false end
        imports.table.insert(scheduledExecs.onLoad, execFunc)
    end,
    execOnModuleLoad = function(execFunc)
        if not execFunc then return false end
        imports.table.insert(scheduledExecs.onModuleLoad, execFunc)
    end
}
imports.assetify.execOnLoad(function()
    for i = 1, #scheduledExecs.onLoad, 1 do
        imports.assetify.execOnLoad(scheduledExecs.onLoad[i])
    end
end)
imports.assetify.execOnModuleLoad(function()
    for i = 1, #scheduledExecs.onModuleLoad, 1 do
        imports.assetify.execOnModuleLoad(scheduledExecs.onModuleLoad[i])
    end
end)


----------------------------------------------
--[[ Function: Retrieves Resource's State ]]--
----------------------------------------------

function isResourceRunning(resourceName)
    if not resourceName then return false end
    local resourceInstance = imports.getResourceName(resourceName)
    if not resourceInstance or (imports.getResourceState(resourceInstance) ~= "running") then return false end
    return true
end


------------------------------
--[[ Function: Key Binder ]]--
------------------------------

function bindKey(...)
    imports.unbindKey(...)
    return imports.bindKey(...)
end


---------------------------------------
--[[ Function: Converts RGB to Hex ]]--
---------------------------------------

function rgbToHex(red, green, blue, alpha)
    red, green, blue, alpha = imports.tonumber(red), imports.tonumber(green), imports.tonumber(blue), imports.tonumber(alpha)
    if not red or not green or not blue then return false end
    red, green, blue, alpha = imports.math.min(255, imports.math.max(0, red)), imports.math.min(255, imports.math.max(0, green)), imports.math.min(255, imports.math.max(0, blue)), (alpha and imports.math.min(255, imports.math.max(0, alpha))) or false
    if alpha then
		return imports.string.format("#%.2X%.2X%.2X%.2X", red, green, blue, alpha)
	else
		return imports.string.format("#%.2X%.2X%.2X", red, green, blue)
	end
end


-------------------------------------------------------------
--[[ Function: Retrieves Position From Element's Offsets ]]--
-------------------------------------------------------------

function getPositionFromElementOffset(element, offX, offY, offZ)

    offX = tonumber(offX); offY = tonumber(offY); offZ = tonumber(offZ);
    if not element or not isElement(element) then return false end
    if not offX or not offY or not offZ then return false end

    local m = getElementMatrix(element)
    local x = offX * m[1][1] + offY * m[2][1] + offZ * m[3][1] + m[4][1]
    local y = offX * m[1][2] + offY * m[2][2] + offZ * m[3][2] + m[4][2]
    local z = offX * m[1][3] + offY * m[2][3] + offZ * m[3][3] + m[4][3]
    return x, y, z

end

function string.parse(rawString)
    if not rawString then return false end
    if imports.tostring(rawString) == "nil" then
        rawString = nil
    elseif imports.tostring(rawString) == "false" then
        rawString = false
    elseif imports.tostring(rawString) == "true" then
        rawString = true
    end
    return imports.tonumber(rawString) or rawString
end


--------------------------------------------------
--[[ Function: Finds Rotation b/w Coordinates ]]--
--------------------------------------------------

function findRotation(x1, y1, x2, y2) 

    x1 = tonumber(x1); y1 = tonumber(y1); x2 = tonumber(x2); y2 = tonumber(y2);
    if not x1 or not y1 or not x2 or not y2 then return false end

    local t = -math.deg(math.atan2(x2 - x1, y2 - y1))
    return t < 0 and t + 360 or t

end


------------------------------------------------------
--[[ Function: Returns Percentage Value Of Amount ]]--
------------------------------------------------------

function math.percent(percent, amount)

    percent = tonumber(percent)
    amount = tonumber(amount)
    if not percent or not amount then return false end

    return (amount*percent)/100

end


---------------------------------------
--[[ Function: Rounds Number Value ]]--
---------------------------------------

function math.round(number, decimals, method)

    number = tonumber(number)
    if not number then return false end
    
    decimals = decimals or 0
    local factor = 10 ^ decimals
    if (method == "ceil" or method == "floor") then
        return math[method](number*factor) / factor
    else
        return tonumber(("%."..decimals.."f"):format(number))
    end

end


----------------------------------------------------------
--[[ Function: Retrieves Point From Distance Rotation ]]--
----------------------------------------------------------

function getPointFromDistanceRotation(x, y, distance, angle)

    x = tonumber(x); y = tonumber(y); distance = tonumber(distance); angle = tonumber(angle);
    if not x or not y or not distance or not angle then return false end

    angle = math.rad(90 - angle)
    local dx = math.cos(angle)*distance
    local dy = math.sin(angle)*distance
    return x + dx, y + dy

end


-----------------------------------------------------------------
--[[ Function: Verifies Player & Element's Interaction Range ]]--
-----------------------------------------------------------------

function isPlayerWithinElementInteractionRange(player, element)

    if not CPlayer.isInitialized(player) or getCharacterHealth(player) <= 0 or not element or not isElement(element) then return false end

    local elementType = element:getType()
    local elementRange = false
    if elementType == "ped" then
        elementRange = serverNPCInteractionRange
    elseif elementType == "vehicle" then
        elementRange = serverVehicleInteractionRange
    elseif elementType == "object" then
        local isPickup = element:getData("Pickup:Type")
        if isPickup then
            elementRange = serverPickupInteractionRange
        end
    end
    if elementRange then
        local playerPosVector = player:getPosition()
        local elementPosVector = element:getPosition()
        return getDistanceBetweenPoints3D(playerPosVector.x, playerPosVector.y, playerPosVector.z, elementPosVector.x, elementPosVector.y, elementPosVector.z) <= elementRange
    end
    return false

end


---------------------------------------------------
--[[ Function: Retrieves Players Within Marker ]]--
---------------------------------------------------

function getPlayersWithinMarker(marker)
    if not marker or not imports.isElement(marker) then return false end
    local rangedPlayers = {}
    local playerList = Element.getAllByType("player")
    for i = 1, #playerList, 1 do
        local j = playerList[i]
        if CPlayer.isInitialized(j) and imports.isElementWithinMarker(j, marker) then
            imports.table.insert(rangedPlayers, j)
        end
    end
    return rangedPlayers
end


-------------------------------------------------
--[[ Function: Retrieves RGB From Percentage ]]--
-------------------------------------------------

function getRGBFromPercentage(percentage)

    percentage = tonumber(percentage)
    if not percentage then return false end
    if percentage < 0 then percentage = 0 end
    if percentage > 100 then percentage = 100 end

	if percentage > 50 then
		return (100 - percentage)*5.1, 255, 0
	elseif percentage == 50 then
        return 255, 255, 0
    else
        return 255, percentage*5.1, 0
    end

end


---------------------------------------------------
--[[ Function: Retrieves Vehicle's Door Amount ]]--
---------------------------------------------------

local availableDualDoorVehicles = {
    602, 496, 401, 518, 527, 589, 419, 587, 533, 526, 474, 545, 517, 410, 600, 436, 439, 549, 491,
    485, 431, 437, 574, 420, 525, 408, 552, 433, 407, 544, 601, 499, 524, 578, 406, 573, 455, 588,
    403, 423, 414, 443, 515, 514, 456, 422, 605, 582, 543, 583, 478, 554, 489, 505, 536, 575, 534,
    567, 535, 576, 412, 402, 542, 603, 475, 429, 541, 415, 480, 562, 565, 434, 494, 502, 503, 411,
    559, 561, 560, 506, 451, 558, 555, 477, 504, 483, 508, 500, 444, 556, 557, 495
}
function getVehicleDoorAmount(vehicle)

    if not vehicle or not isElement(vehicle) or vehicle:getType() ~= "vehicle" then return false end
    local vehicleType = vehicle:getVehicleType()
    if vehicleType ~= "Automobile" and vehicleType ~= "Monster Truck" then return 0 end

    local vehicleModel = vehicle:getModel()
    for i, j in ipairs(availableDualDoorVehicles) do
        if j == vehicleModel then
            return 2
        end
    end
    return 4

end


-----------------------------------------------------------
--[[ Function: Retrieves Vehicle's Compatible Upgrades ]]--
-----------------------------------------------------------

function getVehicleCompatibleUpgrades(vehicle)

    if not vehicle or not isElement(vehicle) or vehicle:getType() ~= "vehicle" then return false end

    local compatibleUpgrades = {}
    for i, j in ipairs(vehicle:getCompatibleUpgrades()) do
        local slotName = getVehicleUpgradeSlotName(j)
        if slotName then
            if not compatibleUpgrades[slotName] then
                compatibleUpgrades[slotName] = {}
            end
            table.insert(compatibleUpgrades[slotName], j)
        end
    end
    return compatibleUpgrades

end


-----------------------------------------------------
--[[ Function: Verifies Vehicle's Upgrade Status ]]--
-----------------------------------------------------

function hasVehicleUpgrade(vehicle, upgradeID)

    upgradeID = tonumber(upgradeID)
    if not vehicle or not isElement(vehicle) or vehicle:getType() ~= "vehicle" or not upgradeID then return false end

	for i = 0, 16, 1 do
		local currentUpgradeID = vehicle:getUpgradeOnSlot(i)
        if currentUpgradeID and currentUpgradeID == upgradeID then
            return true
        end
	end
	return false

end

---------------------------------------
--[[ Function: Table Binary Search ]]--
---------------------------------------

local fcompf = function(a,b) return a < b end
local fcompr = function(a,b) return a > b end
local default_fcompval = function(value) return value end
function binsearch(tbl,value,fcompval,reversed)
    local fcompval = fcompval or default_fcompval
    local fcomp = reversed and fcompr or fcompf
    local iStart,iEnd,iMid = 1, #tbl, 0
    while iStart <= iEnd do
        iMid = math.floor((iStart+iEnd)/2)
        local value2 = fcompval(tbl[iMid])

        if value == value2 then
            local tfound, num = {iMid,iMid}, iMid - 1
            while value == fcompval(tbl[num]) do
               tfound[1], num = num, num - 1
            end
            num = iMid + 1
            while value == fcompval(tbl[num]) do
               tfound[2], num = num, num + 1
            end
            return tfound
        elseif fcomp(value, value2) then
            iEnd = iMid - 1
        else
            iStart = iMid + 1
        end
    end
end

----------------------------------------------
--[[ Function: Get Player By Partial Name ]]--
----------------------------------------------

function getPlayerFromPartialName(name)
    local name = name and name:gsub("#%x%x%x%x%x%x", ""):lower() or nil
    if name then
        for _, player in ipairs(getElementsByType("player")) do
            local name_ = getPlayerName(player):gsub("#%x%x%x%x%x%x", ""):lower()
            if name_:find(name, 1, true) then
                return player
            end
        end
    end
end