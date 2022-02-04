----------------------------------------------------------------
--[[ Resource: Player Handler
     Script: utilities: shared.lua
     Author: vStudio
     Developer(s): Mario, Tron
     DOC: 31/01/2022
     Desc: Shared Utilities ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

loadstring(exports.assetify_library:fetchImports())()

--TODO:NEEDS TO BE OPTIMIZED...

----------------------------------------------
--[[ Function: Retrieves Resource's State ]]--
----------------------------------------------

function isResourceRunning(resourceName)
    if not resourceName then return false end
    local serverResource = Resource.getFromName(resourceName)
    if not serverResource or serverResource:getState() ~= "running" then return false end
    return true
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


--------------------------------------------------
--[[ Function: Finds Rotation b/w Coordinates ]]--
--------------------------------------------------

function findRotation(x1, y1, x2, y2) 

    x1 = tonumber(x1); y1 = tonumber(y1); x2 = tonumber(x2); y2 = tonumber(y2);
    if not x1 or not y1 or not x2 or not y2 then return false end

    local t = -math.deg(math.atan2(x2 - x1, y2 - y1))
    return t < 0 and t + 360 or t

end


-------------------------------------------
--[[ Function: Retrieves Copy Of Table ]]--
-------------------------------------------

--TODO: MAKE BEAUTIFY UTILS SHARED...
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


------------------------------------------------------
--[[ Function: Returns Percentage Value Of Amount ]]--
------------------------------------------------------

function math.percent(percent, amount)

    percent = tonumber(percent)
    amount = tonumber(amount)
    if not percent or not amount then return false end

    return (amount*percent)/100

end


------------------------------------------
--[[ Function: Returns Percent Chance ]]--
------------------------------------------

function math.percentChance(percent, repeatTime)

    percent = tonumber(percent)
    repeatTime = tonumber(repeatTime)
    if not percent or not repeatTime then return false end

    local hits = 0
    for i = 1, repeatTime do
        local number = math.random(0, 200)/2
        if number <= (percent or 0.28) then
            hits = hits + 1
        end
    end
    return hits

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

    if not CPlayer.isInitialized(player) or getPlayerHealth(player) <= 0 or not element or not isElement(element) then return false end

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


--------------------------------------------------
--[[ Function: Verifies Player's Marker State ]]--
--------------------------------------------------

function isPlayerWithinMarker(player, marker)
        
    if not CPlayer.isInitialized(player) or not marker or not isElement(marker) then return false end

    local markerSize = marker:getSize()
    local playerPosVector = player:getPosition()        
    local markerPosVector = marker:getPosition()
    return getDistanceBetweenPoints3D(playerPosVector.x, playerPosVector.y, playerPosVector.z, markerPosVector.x, markerPosVector.y, markerPosVector.z) <= (markerSize*2)

end


---------------------------------------------------
--[[ Function: Retrieves Players Within Marker ]]--
---------------------------------------------------

function getPlayersWithinMarker(marker)

    if not marker or not isElement(marker) then return false end

    local players = {}
    for i, j in ipairs(Element.getAllByType("player")) do
        if CPlayer.isInitialized(j) and isPlayerWithinMarker(j, marker) then
            table.insert(players, j)
        end
    end
    return players

end


----------------------------------------
--[[ Function: Formats Milliseconds ]]--
----------------------------------------

function formatMilliseconds(milliseconds)

    milliseconds = tonumber(milliseconds)
    if not milliseconds then return false end

    local totalseconds = math.floor(milliseconds / 1000)
    local seconds = totalseconds % 60
    local minutes = math.floor(totalseconds / 60)
    local hours = math.floor(minutes / 60)
    minutes = minutes % 60
    return string.format("%02d:%02d:%02d", hours, minutes, seconds)

end


---------------------------------
--[[ Function: Splits String ]]--
---------------------------------

function string.split(string, separator)

    if not string or type(string) ~= "string" then return false end

    local t = {}
    if separator == nil then separator = "%s" end
    for str in string.gmatch(string, "([^"..separator.."]+)") do
        table.insert(t, str)
    end
    return t

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


--------------------------------------
--[[ Functions: Reads/Writes File ]]--
--------------------------------------

function readFile(filePath)

    if not filePath or type(filePath) ~= "string" or not File.exists(filePath) then return false end
    local file = File(filePath)
    if not file then return false end

    local fileSize = file:getSize()
    local fileData = file:read(fileSize)
    file:close()
    return fileData

end

function writeFile(filePath, fileData)

    if not filePath or not fileData or type(filePath) ~= "string" then return false end
    if File.exists(filePath) then File.delete(filePath) end

    local file = File.new(filePath)  
    file:write(fileData)
    file:close()
    return true

end