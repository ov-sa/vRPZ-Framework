----------------------------------------------------------------
--[[ Resource: Player Handler
     Script: handlers: inventory: essentials: loot.lua
     Server: -
     Author: OvileAmriam
     Developer: -
     DOC: 18/12/2020 (OvileAmriam)
     Desc: Inventory Loot's Essentials ]]--
----------------------------------------------------------------


local imports = {
    isElement = isElement
}
-------------------
--[[ Variables ]]--
-------------------

local lootExitTimers = {}


-------------------------------------
--[[ Event: On Client Marker Hit ]]--
-------------------------------------

addEventHandler("onClientMarkerHit", root, function(hitElement, isDimensionMatching)

    if not hitElement or not imports.isElement(hitElement) or (hitElement ~= localPlayer) or not isDimensionMatching or (localPlayer:getInterior() ~= source:getInterior()) or not isElementWithinMarker(localPlayer, source) then return false end
    if not isPlayerInitialized(localPlayer) or getPlayerHealth(localPlayer) <= 0 or localPlayer:getOccupiedVehicle() then return false end

    local markerParent = source:getData("Element:Parent")
    local lootType = source:getData("Loot:Type")
    local lootName = source:getData("Loot:Name")
    local pedTask = tostring(getPedSimplestTask(localPlayer))
    if not markerParent or not isElement(markerParent) or not lootType or not lootName then return false end
    if markerParent == localPlayer then return false end
    if pedTask == "TASK_SIMPLE_GO_TO_POINT" then return false end
    local selectedLootConfig = lootTypeConfig[lootType]
    if not selectedLootConfig then return false end

    if lootExitTimers[source] and lootExitTimers[source]:isValid() then
        lootExitTimers[source]:destroy()
        lootExitTimers[source] = nil
    end
    local marker = localPlayer:getData("Loot:Marker")
    if marker and isElement(marker) and marker == source then return false end

    --[[
    --TODO: ADD LATER REVIVER
    if lootType == "reviver" then
        if source:getData("Loot:Captured") or (#(getPlayersWithinMarker(source)) > 2) then
            return false
        end
    else
        ]]--
        if #(getPlayersWithinMarker(source)) > 1 then return false end
        --[[
        if lootType == "vehicle" then
            if markerParent:getType() ~= "vehicle" or exports.vehicle_handler:isVehicleOnRepair(markerParent) or markerParent:isInWater() or markerParent:isBlown() or markerParent:getController() then
                return false
            end
        end
        ]]--
    --end

    localPlayer:setData("Loot:Marker", source)
    localPlayer:setData("Character:Looting", selectedLootConfig.lootStatus)

end)


---------------------------------------
--[[ Event: On Client Marker Leave ]]--
---------------------------------------

addEventHandler("onClientMarkerLeave", root, function(hitElement)

    if not hitElement or not isElement(hitElement) or (hitElement ~= localPlayer) then return false end

    local markerParent = source:getData("Element:Parent")
    if not markerParent or not isElement(markerParent) then return false end
    if markerParent == localPlayer then return false end

    if not lootExitTimers[source] or not lootExitTimers[source]:isValid() then
        lootExitTimers[source] = Timer(function(_marker)
            if _marker and isElement(_marker) then
                lootExitTimers[_marker] = nil
                local marker = localPlayer:getData("Loot:Marker")
                if marker and isElement(marker) and marker == _marker then
                    if not localPlayer:isWithinMarker(_marker) then
                        localPlayer:setData("Loot:Marker", nil)
                        localPlayer:setData("Character:Looting", nil)
                        if isInventoryVisible() then
                            closeInventory()
                        end
                    end
                end
            end
        end, 1000, 1, source)
    end

end)


---------------------------------------------
--[[ Function: Checks Vehicle's Entrance ]]--
---------------------------------------------

local function checkVehicleEntrance(player, seat)

    if not player or not isElement(player) or (player ~= localPlayer) then return false end
    if not isPlayerInitialized(localPlayer) or getPlayerHealth(localPlayer) <= 0 then cancelEvent() return false end
    --TODO: DISABLE LATER IF PLAYER IS TRYING TO ENTER VEHICLE WHILE ON REPAIR STATE
    --if exports.vehicle_handler:isVehicleOnRepair(source) then cancelEvent() return false end

    local marker = localPlayer:getData("Loot:Marker")
    if marker and isElement(marker) then
        localPlayer:setData("Loot:Marker", nil)
        localPlayer:setData("Character:Looting", nil)
        if isInventoryVisible() then
            closeInventory()
        end
    end

end
addEventHandler("onClientVehicleEnter", root, checkVehicleEntrance)
addEventHandler("onClientVehicleStartEnter", root, checkVehicleEntrance)


------------------------------------------
--[[ Event: On Client Vehicle Explode ]]--
------------------------------------------

addEventHandler("onClientVehicleExplode", root, function()

    local _marker = source:getData("Element:Parent")
    if not _marker or not isElement(_marker) then return false end

    if lootExitTimers[_marker] and lootExitTimers[_marker]:isValid() then
        lootExitTimers[_marker]:destroy()
        lootExitTimers[_marker] = nil
    end
    local marker = localPlayer:getData("Loot:Marker")
    if marker and isElement(marker) and marker == _marker then
        localPlayer:setData("Loot:Marker", nil)
        localPlayer:setData("Character:Looting", nil)
        if isInventoryVisible() then
            closeInventory()
        end
    end

end)


------------------------------------------
--[[ Event: On Client Element Destroy ]]--
------------------------------------------

addEventHandler("onClientElementDestroy", root, function()

    if lootExitTimers[source] and lootExitTimers[source]:isValid() then
        lootExitTimers[source]:destroy()
        lootExitTimers[source] = nil
    end
    local marker = localPlayer:getData("Loot:Marker")
    if marker and isElement(marker) and marker == source then
        localPlayer:setData("Loot:Marker", nil)
        localPlayer:setData("Character:Looting", nil)
        if isInventoryVisible() then
            closeInventory()
        end
        triggerServerEvent("onClientRequestSyncInventorySlots", source)
    end

end)