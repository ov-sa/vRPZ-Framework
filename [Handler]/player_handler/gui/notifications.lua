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

local notifUI = {
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
    leftCurvedEdgePath = beautify.assets["images"]["curved_square/regular/left.rw"],
    rightCurvedEdgePath = beautify.assets["images"]["curved_square/regular/right.rw"]
}


---------------------------------
--[[ Event: On Client Render ]]--
---------------------------------

beautify.render.create(function()

    if #notifUI.buffer <= 0 then return false end

    local currentYOffset = interpolateBetween(notifUI.currentYOffset, 0, 0, 0, 0, 0, getInterpolationProgress(notifUI.slideTopTickCounter, notifUI.slideTopDuration), "OutBack")
    for i, j in ipairs(notifUI.buffer) do
        local notifFontColor = j.fontColor or notifUI.defaultFontColor
        local notif_width, notif_height = dxGetTextWidth(j.text, 1, notifUI.font), notifUI.height
        local notif_offsetX, notif_offsetY = 0, 0
        local notifAlphaPercent = 0
        if j.slideStatus == "forward" then
		    notif_offsetX, notif_offsetY = interpolateBetween(CLIENT_MTA_RESOLUTION[1], notifUI.startY + ((i - 1)*(notifUI.height + notifUI.paddingY)) - notifUI.height, 0, (CLIENT_MTA_RESOLUTION[1]) - notifUI.startX - notif_width, notifUI.startY + ((i - 1)*(notifUI.height + notifUI.paddingY)) + currentYOffset, 0, getInterpolationProgress(j.tickCounter, notifUI.slideInDuration), "InOutBack")
            notifAlphaPercent = interpolateBetween(0, 0, 0, 1, 0, 0, getInterpolationProgress(j.tickCounter, notifUI.slideInDuration), "Linear")
            if math.round(notifAlphaPercent, 2) == 1 then
                if (CLIENT_CURRENT_TICK - j.tickCounter - notifUI.slideInDuration) >= notifUI.slideAnimDelayDuration then
                    j.slideStatus = "backward"
                    j.tickCounter = CLIENT_CURRENT_TICK
                    notifUI.currentYOffset = notifUI.height
                    notifUI.slideTopTickCounter = CLIENT_CURRENT_TICK
                end
            end
        else
		    notif_offsetX, notif_offsetY = interpolateBetween((CLIENT_MTA_RESOLUTION[1]) - notifUI.startX - notif_width, notifUI.startY + ((i - 1)*(notifUI.height + notifUI.paddingY)), 0, CLIENT_MTA_RESOLUTION[1], notifUI.startY + ((i - 1)*(notifUI.height + notifUI.paddingY)) + (notifUI.height/2) - currentYOffset, 0, getInterpolationProgress(j.tickCounter, notifUI.slideOutDuration), "InOutBack")
            notifAlphaPercent = interpolateBetween(1, 0, 0, 0, 0, 0, getInterpolationProgress(j.tickCounter, notifUI.slideOutDuration), "Linear")
        end
        dxDrawRectangle(notif_offsetX, notif_offsetY, notif_width, notif_height, tocolor(notifUI.bgColor[1], notifUI.bgColor[2], notifUI.bgColor[3], notifUI.bgColor[4]*notifAlphaPercent), false)
        dxDrawImage(notif_offsetX - notif_height, notif_offsetY, notif_height, notif_height, notifUI.leftCurvedEdgePath, 0, 0, 0, tocolor(notifUI.bgColor[1], notifUI.bgColor[2], notifUI.bgColor[3], notifUI.bgColor[4]*notifAlphaPercent), false)
        dxDrawImage(notif_offsetX + notif_width, notif_offsetY, notif_height, notif_height, notifUI.rightCurvedEdgePath, 0, 0, 0, tocolor(notifUI.bgColor[1], notifUI.bgColor[2], notifUI.bgColor[3], notifUI.bgColor[4]*notifAlphaPercent), false)
        dxDrawBorderedText(notifUI.fontBorderWeight, {notifUI.fontBorderColor[1], notifUI.fontBorderColor[2], notifUI.fontBorderColor[3], notifUI.fontBorderColor[4]*notifAlphaPercent}, j.text, notif_offsetX, notif_offsetY, notif_offsetX + notif_width, notif_offsetY + notif_height, tocolor(notifFontColor[1], notifFontColor[2], notifFontColor[3], notifFontColor[4]*notifAlphaPercent), 1, notifUI.font, "center", "center", true, false, false, false, true)
        if j.slideStatus == "backward" then
            if math.round(notifAlphaPercent, 2) == 0 then
                table.remove(notifUI.buffer, i)
            end
        end
    end

end)
--end, true, "low-10")


----------------------------------------
--[[ Event: On Display Notification ]]--
----------------------------------------

addEvent("Player:onDisplayNotification", true)
addEventHandler("Player:onDisplayNotification", root, function(notifMessage, notifColor)

    if not notifMessage or type(notifMessage) ~= "string" or notifMessage == "" then return false end

    table.insert(notifUI.buffer, {
        text = notifMessage,
        fontColor = notifColor,
        slideStatus = "forward",
        tickCounter = CLIENT_CURRENT_TICK
    })

end)