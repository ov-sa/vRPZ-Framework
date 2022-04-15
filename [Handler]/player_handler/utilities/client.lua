----------------------------------------------------------------
--[[ Resource: Player Handler
     Script: utilities: client.lua
     Author: vStudio
     Developer(s): Mario, Tron, Aviril, Аниса
     DOC: 31/01/2022
     Desc: Client Sided Utilities ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

loadstring(exports.beautify_library:fetchImports())()
local imports = {
    pairs = pairs,
    tonumber = tonumber,
    addEvent = addEvent,
    addEventHandler = addEventHandler,
    getElementType = getElementType,
    guiSetInputMode = guiSetInputMode,
    setWeather = setWeather,
    setTime = setTime,
    setBlurLevel  = setBlurLevel,
    toggleControl = toggleControl,
    setCloudsEnabled = setCloudsEnabled,
    setTrafficLightState = setTrafficLightState,
    setPedTargetingMarkerEnabled = setPedTargetingMarkerEnabled,
    setPlayerHudComponentVisible = setPlayerHudComponentVisible,
    setCameraFieldOfView = setCameraFieldOfView,
    showChat = showChat,
    showCursor = showCursor
}


---------------------------------------
--[[ Function: Overrides Show Chat ]]--
---------------------------------------

function showChat(bool, isForced)
    return ((isForced or not bool or not CGame.isUIVisible()) and imports.showChat(bool)) or false
end
function showCursor(bool, isForced)
    return ((isForced or bool or not CGame.isUIVisible()) and imports.showCursor(bool)) or false
end
imports.addEvent("Client:onToggleChat", true)
imports.addEventHandler("Client:onToggleChat", root, showChat)


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
        DxTexture("files/images/hud/curved_square/left.png", "dxt5", true, "clamp"),
        DxTexture("files/images/hud/curved_square/right.png", "dxt5", true, "clamp")
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
    dxDrawBorderedText(outlineWeight, outlineColor, placeHolder:gsub("."," %0"):sub(2), overlay_startX, overlay_startY - (borderSize*2), overlay_startX + overlay_width, overlay_startY - (borderSize*2), borderColor, 1, CGame.createFont(1, 15), "center", "bottom", false, false, false)
    return true

end
]]


-----------------------------------------
--[[ Event: On Client Resource Start ]]--
-----------------------------------------

imports.addEventHandler("onClientResourceStart", resource, function()
    showChat(false, true)
    CPlayer.setLanguage("RU") --TODO: UPDATE
    imports.setBlurLevel(0)
    imports.toggleControl("fire", true)
    imports.toggleControl("action", false)
    imports.toggleControl("radar", false)
    imports.setCloudsEnabled(false)
    imports.setTrafficLightState("disabled")
    imports.setPedTargetingMarkerEnabled(false)
    imports.setPlayerHudComponentVisible("all", false)
    imports.setPlayerHudComponentVisible("crosshair", true)
    for i, j in imports.pairs(FRAMEWORK_CONFIGS["Game"]["Camera_FOV"]) do
        imports.setCameraFieldOfView(i, j)
    end

    imports.addEventHandler("onClientGUIClick", root, function()
        local guiElement = imports.getElementType(source)
        if ((guiElement == "gui-edit") or (guiElement == "gui-memo")) then
            imports.guiSetInputMode("no_binds_when_editing")
        else
            imports.guiSetInputMode("allow_binds")
        end
    end)

    imports.addEventHandler("onClientPlayerJoin", root, function()
        CGame.loadAnim(source, "vRPZ_Military")
    end)

    imports.addEvent("Client:onSyncWeather", true)
    imports.addEventHandler("Client:onSyncWeather", root, function(serverWeather, serverTime)
        serverWeather = imports.tonumber(serverWeather)
        if not serverWeather or not serverTime then return false end
        imports.setWeather(serverWeather)
        imports.setTime(serverTime[1], serverTime[2])
        return true
    end)
end)
