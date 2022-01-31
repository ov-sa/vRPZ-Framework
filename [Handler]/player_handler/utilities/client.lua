----------------------------------------------------------------
--[[ Resource: Player Handler
     Script: utilities: client.lua
     Author: vStudio
     Developer(s): Tron
     DOC: 31/01/2022
     Desc: Client Sided Utilities ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

loadstring(exports.beautify_library:fetchImports())()
local imports = {
    setWeather = setWeather,
    setTime = setTime
}


------------------------------------
--[[ Event: On Client GUI Click ]]--
------------------------------------

addEventHandler("onClientGUIClick", root, function()

    local guiElement = source:getType()
    if guiElement == "gui-edit" or guiElement == "gui-memo" then
        GuiElement.setInputMode("no_binds_when_editing")
    else
        GuiElement.setInputMode("allow_binds")
    end

end)


---------------------------------------
--[[ Function: Overrides Show Chat ]]--
---------------------------------------

local _showChat = showChat
function showChat(bool, isForced)

    if isForced then
        return _showChat(bool)
    else
        if bool then
            --if isPlayerInitialized(localPlayer) and not loginUICache.state and not isWastedScreenVisible() and not isSpawnScreenVisible() and not isDashboardVisible() and not isMapOpened() and getClientSetting("checkbox", "chat_state") then
              --  return _showChat(bool)
            --end
        else
            return _showChat(bool)
        end
        return false
    end

end
addEvent("Player-Handler:onToggleChat", true)
addEventHandler("Player-Handler:onToggleChat", root, showChat)


-------------------------------------------------------
--[[ Function: Retrieves Drop Position From Screen ]]--
-------------------------------------------------------

--[[
function getDropPositionFromScreen(cursor_offsetX, cursor_offsetY)

    cursor_offsetX, cursor_offsetY = tonumber(cursor_offsetX), tonumber(cursor_offsetY)
    if not cursor_offsetX or not cursor_offsetY then
        cursor_offsetX, cursor_offsetY = getAbsoluteCursorPosition()
    end
    if cursor_offsetX and cursor_offsetY then
        local posVector = localPlayer:getPosition()
        local cameraMatrix, worldMatrix = {getCameraMatrix()}, {getWorldFromScreenPosition(cursor_offsetX, cursor_offsetY, 10)}
        local sightMatrix = {processLineOfSight(cameraMatrix[1], cameraMatrix[2], cameraMatrix[3], worldMatrix[1], worldMatrix[2], worldMatrix[3])}
        if sightMatrix[1] then
            sightMatrix[4] = getGroundPosition(sightMatrix[2], sightMatrix[3], sightMatrix[4] + 1)
            if sightMatrix[4] and getDistanceBetweenPoints3D(posVector.x, posVector.y, posVector.z, sightMatrix[2], sightMatrix[3], sightMatrix[4]) <= serverPickupInteractionRange then
                return sightMatrix[2], sightMatrix[3], sightMatrix[4]
            end
        end
    end
    return false

end
]]


------------------------------------------------
--[[ Function: Verifies Player's Clear View ]]--
------------------------------------------------

function isObjectAroundPlayer(player, distance, height, initialHeight, targetMaterial, ignoredElements, ignoredMaterials)

    distance = tonumber(distance)
    height = tonumber(height)
    if not player or not isElement(player) or player:getType() ~= "player" or not distance or not height then return false end

    local posVector = player:getPosition()
    for i = 0, 360, 1 do
        local nx, ny = getPointFromDistanceRotation(posVector.x, posVector.y, distance, i)
        local hit, hitX, hitY, hitZ, hitElement, normalX, normalY, normalZ, material = processLineOfSight(posVector.x, posVector.y, posVector.z + (tonumber(initialHeight) or 0), nx, ny, posVector.z + height, true, true, false, true, false)
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


--------------------------------------
--[[ Function: Draws Progress Bar ]]--
--------------------------------------

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

    percent = tonumber(percent)
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

function dxDrawBorderedText(outlineWeight, outlineColor, text, left, top, right, bottom, color, scale, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)

    outlineWeight = tonumber(outlineWeight); left = tonumber(left); top = tonumber(top); right = tonumber(right); bottom = tonumber(bottom); scale = tonumber(scale);
    if not outlineWeight or not outlineColor or not left or not top or not right or not bottom  or not color or not scale or not font then return false end

    for oX = (outlineWeight * -1), outlineWeight do
        for oY = (outlineWeight * -1), outlineWeight do
            dxDrawText(text, left + oX, top + oY, right + oX, bottom + oY, tocolor(unpack(outlineColor)), scale, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
        end
    end
    dxDrawText(text, left, top, right, bottom, color, scale, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
    return true

end


---------------------------------------
--[[ Event: On Sync Server Weather ]]--
---------------------------------------

addEvent("Player-Handler:onSyncServerWeather", true)
addEventHandler("Player-Handler:onSyncServerWeather", root, function(serverWeather, serverTime)

    serverWeather = tonumber(serverWeather)
    if not serverWeather or not serverTime then return false end

    imports.setWeather(serverWeather)
    imports.setTime(serverTime[1], serverTime[2])
    return true

end)