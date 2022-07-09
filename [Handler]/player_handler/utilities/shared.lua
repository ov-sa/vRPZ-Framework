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

resource = getResourceRootElement(getThisResource())
loadstring(exports.assetify_library:import("*"))()
local imports = {
    tonumber = tonumber,
    isElement = isElement,
    bindKey = bindKey,
    unbindKey = unbindKey,
    isElementWithinMarker = isElementWithinMarker,
    string = string,
    table = table,
    math = math,
    assetify = assetify
}
CGame = {
    execOnLoad = imports.assetify.scheduler.execScheduleOnLoad,
    execOnModuleLoad = imports.assetify.scheduler.execScheduleOnModuleLoad
}


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
    red, green, blue, alpha = imports.math:min(255, imports.math:max(0, red)), imports.math:min(255, imports.math:max(0, green)), imports.math:min(255, imports.math:max(0, blue)), (alpha and imports.math:min(255, imports.math:max(0, alpha))) or false
    if alpha then
		return imports.string:format("#%.2X%.2X%.2X%.2X", red, green, blue, alpha)
	else
		return imports.string:format("#%.2X%.2X%.2X", red, green, blue)
	end
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
            imports.table:insert(rangedPlayers, j)
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
            table:insert(compatibleUpgrades[slotName], j)
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
        iMid = math:floor((iStart+iEnd)/2)
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