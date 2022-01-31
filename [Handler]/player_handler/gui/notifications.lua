----------------------------------------------------------------
--[[ Resource: Player Handler
     Script: gui: notifications.lua
     Server: -
     Author: OvileAmriam
     Developer: -
     DOC: 18/11/2020 (OvileAmriam)
     Desc: Notifications Handler ]]--
----------------------------------------------------------------


-------------------
--[[ Variables ]]--
-------------------

local screenX, screenY = sX/1366, sY/768
local notificationsCache = {
    startX = 50,
    startY = 15,
    height = 30,
    paddingY = 5,
    currentYOffset = 0,
    buffer = {},
    slideInDuration = 850,
    slideOutDuration = 500,
    slideTopDuration = 500,
    slideAnimDelayDuration = 2000,
    slideTopTickCounter = CLIENT_CURRENT_TICK,
    font = FRAMEWORK_FONTS[8],
    bgColor = {0, 0, 0, 240},
    defaultFontColor = {175, 175, 175, 255},
    fontBorderWeight = 0.25,
    fontBorderColor = {0, 0, 0, 200},
    leftCurvedEdgePath = DxTexture("files/images/hud/curved_square/left.png", "argb", true, "clamp"),
    rightCurvedEdgePath = DxTexture("files/images/hud/curved_square/right.png", "argb", true, "clamp")
}


---------------------------------
--[[ Event: On Client Render ]]--
---------------------------------

addEventHandler("onClientRender", root, function()


    if #notificationsCache.buffer <= 0 then return false end

    local currentYOffset = interpolateBetween(notificationsCache.currentYOffset, 0, 0, 0, 0, 0, getInterpolationProgress(notificationsCache.slideTopTickCounter, notificationsCache.slideTopDuration), "OutBack")
    for i, j in ipairs(notificationsCache.buffer) do
        local notifFontColor = j.fontColor or notificationsCache.defaultFontColor
        local notif_width, notif_height = dxGetTextWidth(j.text, 1, notificationsCache.font), notificationsCache.height
        local notif_offsetX, notif_offsetY = 0, 0
        local notifAlphaPercent = 0
        if j.slideStatus == "forward" then
		    notif_offsetX, notif_offsetY = interpolateBetween(screenX*1366, notificationsCache.startY + ((i - 1)*(notificationsCache.height + notificationsCache.paddingY)) - notificationsCache.height, 0, (screenX*1366) - notificationsCache.startX - notif_width, notificationsCache.startY + ((i - 1)*(notificationsCache.height + notificationsCache.paddingY)) + currentYOffset, 0, getInterpolationProgress(j.tickCounter, notificationsCache.slideInDuration), "InOutBack")
            notifAlphaPercent = interpolateBetween(0, 0, 0, 1, 0, 0, getInterpolationProgress(j.tickCounter, notificationsCache.slideInDuration), "Linear")
            if math.round(notifAlphaPercent, 2) == 1 then
                if (CLIENT_CURRENT_TICK - j.tickCounter - notificationsCache.slideInDuration) >= notificationsCache.slideAnimDelayDuration then
                    j.slideStatus = "backward"
                    j.tickCounter = CLIENT_CURRENT_TICK
                    notificationsCache.currentYOffset = notificationsCache.height
                    notificationsCache.slideTopTickCounter = CLIENT_CURRENT_TICK
                end
            end
        else
		    notif_offsetX, notif_offsetY = interpolateBetween((screenX*1366) - notificationsCache.startX - notif_width, notificationsCache.startY + ((i - 1)*(notificationsCache.height + notificationsCache.paddingY)), 0, screenX*1366, notificationsCache.startY + ((i - 1)*(notificationsCache.height + notificationsCache.paddingY)) + (notificationsCache.height/2) - currentYOffset, 0, getInterpolationProgress(j.tickCounter, notificationsCache.slideOutDuration), "InOutBack")
            notifAlphaPercent = interpolateBetween(1, 0, 0, 0, 0, 0, getInterpolationProgress(j.tickCounter, notificationsCache.slideOutDuration), "Linear")
        end
        dxDrawRectangle(notif_offsetX, notif_offsetY, notif_width, notif_height, tocolor(notificationsCache.bgColor[1], notificationsCache.bgColor[2], notificationsCache.bgColor[3], notificationsCache.bgColor[4]*notifAlphaPercent), false)
        dxDrawImage(notif_offsetX - notif_height, notif_offsetY, notif_height, notif_height, notificationsCache.leftCurvedEdgePath, 0, 0, 0, tocolor(notificationsCache.bgColor[1], notificationsCache.bgColor[2], notificationsCache.bgColor[3], notificationsCache.bgColor[4]*notifAlphaPercent), false)
        dxDrawImage(notif_offsetX + notif_width, notif_offsetY, notif_height, notif_height, notificationsCache.rightCurvedEdgePath, 0, 0, 0, tocolor(notificationsCache.bgColor[1], notificationsCache.bgColor[2], notificationsCache.bgColor[3], notificationsCache.bgColor[4]*notifAlphaPercent), false)
        dxDrawBorderedText(notificationsCache.fontBorderWeight, {notificationsCache.fontBorderColor[1], notificationsCache.fontBorderColor[2], notificationsCache.fontBorderColor[3], notificationsCache.fontBorderColor[4]*notifAlphaPercent}, j.text, notif_offsetX, notif_offsetY, notif_offsetX + notif_width, notif_offsetY + notif_height, tocolor(notifFontColor[1], notifFontColor[2], notifFontColor[3], notifFontColor[4]*notifAlphaPercent), 1, notificationsCache.font, "center", "center", true, false, false, false, true)
        if j.slideStatus == "backward" then
            if math.round(notifAlphaPercent, 2) == 0 then
                table.remove(notificationsCache.buffer, i)
            end
        end
    end

end, true, "low-10")


----------------------------------------
--[[ Event: On Display Notification ]]--
----------------------------------------

addEvent("onDisplayNotification", true)
addEventHandler("onDisplayNotification", root, function(notifMessage, notifColor)

    if not notifMessage or type(notifMessage) ~= "string" or notifMessage == "" then return false end

    table.insert(notificationsCache.buffer, {
        text = notifMessage,
        fontColor = notifColor,
        slideStatus = "forward",
        tickCounter = CLIENT_CURRENT_TICK
    })

end)