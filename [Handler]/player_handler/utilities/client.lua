----------------------------------------------------------------
--[[ Resource: Player Handler
     Script: utilities: client.lua
     Author: vStudio
     Developer(s): Mario, Tron
     DOC: 31/01/2022
     Desc: Client Sided Utilities ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

loadstring(exports.beautify_library:fetchImports())()
local imports = {
    tonumber = tonumber,
    addEvent = addEvent,
    addEventHandler = addEventHandler,
    triggerEvent = triggerEvent,
    triggerServerEvent = triggerServerEvent,
    getElementType = getElementType,
    guiSetInputMode = guiSetInputMode,
    setWeather = setWeather,
    setTime = setTime,
    showChat = showChat,
    toggleControl = toggleControl,
    setTrafficLightState = setTrafficLightState,
    setPedTargetingMarkerEnabled = setPedTargetingMarkerEnabled,
    setPedTargetingMarkerEnabled = setPedTargetingMarkerEnabled
}


---------------------------------------
--[[ Function: Overrides Show Chat ]]--
---------------------------------------

function showChat(bool, isForced)
    if isForced or (not bool) then
        return imports.showChat(bool)
    else
        local conditionChecks = {
            isPlayerInitialized(localPlayer),
            not isLoginScreenVisible(),
            not isWastedScreenVisible(),
            not isSpawnScreenVisible(),
            not isDashboardVisible(),
            not isMapOpened(),
            not isMapOpened()
        }
        local isStateValid = true
        for i, j in imports.ipairs(conditionChecks) do
            if not j then
                isStateValid = false
                break
            end
        end
        if isStateValid then
            return imports.showChat(bool)
        end
    end
    return false
end
imports.addEvent("Player:onToggleChat", true)
imports.addEventHandler("Player:onToggleChat", root, showChat)


------------------------------------------------
--[[ Function: Verifies Player's Clear View ]]--
------------------------------------------------
--TODO: NEEEDS TO BE MOVED
--[[
function isObjectAroundPlayer(player, distance, height, initialHeight, targetMaterial, ignoredElements, ignoredMaterials)

    distance = imports.tonumber(distance)
    height = imports.tonumber(height)
    if not player or not isElement(player) or player:getType() ~= "player" or not distance or not height then return false end

    local posVector = player:getPosition()
    for i = 0, 360, 1 do
        local nx, ny = getPointFromDistanceRotation(posVector.x, posVector.y, distance, i)
        local hit, hitX, hitY, hitZ, hitElement, normalX, normalY, normalZ, material = processLineOfSight(posVector.x, posVector.y, posVector.z + (imports.tonumber(initialHeight) or 0), nx, ny, posVector.z + height, true, true, false, true, false)
        if hit then
            local isElementIgnored = false
            local isMaterialIgnored = false
            if ignoredElements then
                for i, j in ipairs(ignoredElements) do
                    if j and isElement(j) and j == hitElement then
                        isElementIgnored = true
                        break
                    end
                end
            end
            if ignoredMaterials then
                for i, j in ipairs(ignoredMaterials) do
                    if j == material then
                        isMaterialIgnored = true
                        break
                    end
                end
            end
            if not isElementIgnored and not isMaterialIgnored then
                if targetMaterial then
                    if targetMaterial == material then
                        return material, hitElement, hitX, hitY, hitZ
                    end
                else
                    return material, hitElement, hitX, hitY, hitZ
                end
            end
        end
    end
    return false

end
]]

--------------------------------------
--[[ Function: Draws Progress Bar ]]--
--------------------------------------
--TODO: NEEEDS TO BE MOVED
--[[
local progressBarDatas = {
    edgePaths = {
        DxTexture("files/images/hud/curved_square/left.png", "argb", true, "clamp"),
        DxTexture("files/images/hud/curved_square/right.png", "argb", true, "clamp")
    },
    borderAnimTickCounter = CLIENT_CURRENT_TICK,
    borderAnimDuration = 2500
}

function drawProgressBar(percent, placeHolder)

    percent = imports.tonumber(percent)
    if not percent then return false end
    percent = math.max(0, math.min(100, percent))
    placeHolder = (placeHolder and tostring(placeHolder)) or ""

    local barPadding, borderSize = 8, 2
    local overlay_width, overlay_height = 290, 20
    local overlay_startX, overlay_startY = (sX - overlay_width)/2, sY - overlay_height - 35
    local barColor, borderColor, percentageColor = tocolor(0, 0, 0, 250), tocolor(50, 75, 200, 255*interpolateBetween(0.25, 0, 0, 1, 0, 0, getInterpolationProgress(progressBarDatas.borderAnimTickCounter, progressBarDatas.borderAnimDuration), "CosineCurve")), {getRGBFromPercentage(percent)}
    local outlineWeight, outlineColor = 0.5, {0, 0, 0, 255}
    percentageColor[4] = 75
    dxDrawImage(overlay_startX - borderSize, overlay_startY - borderSize, overlay_height + (borderSize*2), overlay_height + (borderSize*2), progressBarDatas.edgePaths[1], 0, 0, 0, borderColor, false)
    dxDrawImage(overlay_startX + overlay_width - overlay_height - borderSize, overlay_startY - borderSize, overlay_height + (borderSize*2), overlay_height + (borderSize*2), progressBarDatas.edgePaths[2], 0, 0, 0, borderColor, false)
    dxDrawRectangle(overlay_startX + overlay_height + borderSize, overlay_startY - borderSize, overlay_width - (overlay_height*2) - (borderSize*2), overlay_height + (borderSize*2), borderColor, false)
    dxDrawImage(overlay_startX, overlay_startY, overlay_height, overlay_height, progressBarDatas.edgePaths[1], 0, 0, 0, barColor, false)
    dxDrawImage(overlay_startX + overlay_width - overlay_height, overlay_startY, overlay_height, overlay_height, progressBarDatas.edgePaths[2], 0, 0, 0, barColor, false)
    dxDrawRectangle(overlay_startX + overlay_height, overlay_startY, overlay_width - (overlay_height*2), overlay_height, barColor, false)
    dxDrawRectangle(overlay_startX + barPadding, overlay_startY + barPadding, (overlay_width - (barPadding*2))*(percent/100), overlay_height - (barPadding*2), tocolor(unpack(percentageColor)), false)
    dxDrawBorderedText(outlineWeight, outlineColor, placeHolder:gsub("."," %0"):sub(2), overlay_startX, overlay_startY - (borderSize*2), overlay_startX + overlay_width, overlay_startY - (borderSize*2), borderColor, 1, FRAMEWORK_FONTS[8], "center", "bottom", false, false, false)
    return true

end
]]


---------------------------------------
--[[ Function: Draws Bordered Text ]]--
---------------------------------------
--TODO: NEEEDS TO BE MOVED
function dxDrawBorderedText(outlineWeight, outlineColor, text, left, top, right, bottom, color, scale, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
    outlineWeight = imports.tonumber(outlineWeight); left = imports.tonumber(left); top = imports.tonumber(top); right = imports.tonumber(right); bottom = imports.tonumber(bottom); scale = imports.tonumber(scale);
    if not outlineWeight or not outlineColor or not left or not top or not right or not bottom  or not color or not scale or not font then return false end

    for oX = (outlineWeight * -1), outlineWeight do
        for oY = (outlineWeight * -1), outlineWeight do
            dxDrawText(text, left + oX, top + oY, right + oX, bottom + oY, tocolor(unpack(outlineColor)), scale, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
        end
    end
    dxDrawText(text, left, top, right, bottom, color, scale, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
    return true
end


--------------------------------
--[[ Event: On Sync Weather ]]--
--------------------------------

imports.addEvent("Player:onSyncWeather", true)
imports.addEventHandler("Player:onSyncWeather", root, function(serverWeather, serverTime)
    serverWeather = imports.tonumber(serverWeather)
    if not serverWeather or not serverTime then return false end
    imports.setWeather(serverWeather)
    imports.setTime(serverTime[1], serverTime[2])
    return true
end)


------------------------------------
--[[ Event: On Client GUI Click ]]--
------------------------------------

imports.addEventHandler("onClientGUIClick", root, function()
    local guiElement = imports.getElementType(source)
    if ((guiElement == "gui-edit") or (guiElement == "gui-memo")) then
        imports.guiSetInputMode("no_binds_when_editing")
    else
        imports.guiSetInputMode("allow_binds")
    end
end)


-----------------------------------------
--[[ Event: On Client Resource Start ]]--
-----------------------------------------

imports.addEventHandler("onClientResourceStart", resource, function()
    imports.toggleControl("fire", true)
    imports.toggleControl("action", false)
    imports.toggleControl("radar", false)
    imports.setTrafficLightState("disabled")
    imports.setPedTargetingMarkerEnabled(false)
    imports.setPlayerHudComponentVisible("all", false)
    imports.setPlayerHudComponentVisible("crosshair", true)
end)