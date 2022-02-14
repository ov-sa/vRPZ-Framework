----------------------------------------------------------------
--[[ Resource: Player Handler
     Script: gui: notification.lua
     Author: vStudio
     Developer(s): Mario, Tron, Aviril
     DOC: 31/01/2022
     Desc: Notification UI Handler ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local imports = {
    type = type,
    ipairs = ipairs,
    tocolor = tocolor,
    addEvent = addEvent,
    addEventHandler = addEventHandler,
    interpolateBetween = interpolateBetween,
    getInterpolationProgress = getInterpolationProgress,
    table = table,
    math = math,
    beautify = beautify
}


-------------------
--[[ Variables ]]--
-------------------

local notifUI = {
    buffer = {},
    startX = 50, startY = 15, paddingY = 5, offsetY = 0,
    slideTopTickCounter = CLIENT_CURRENT_TICK,
    font = FRAMEWORK_FONTS[6],
    leftEdgeTexture = imports.beautify.assets["images"]["curved_square/regular/left.rw"],
    rightEdgeTexture = imports.beautify.assets["images"]["curved_square/regular/right.rw"]
}


------------------------------
--[[ Function: Renders UI ]]--
------------------------------

imports.beautify.render.create(function()
    if #notifUI.buffer <= 0 then return false end

    local offsetY = imports.interpolateBetween(notifUI.offsetY, 0, 0, 0, 0, 0, imports.getInterpolationProgress(notifUI.slideTopTickCounter, FRAMEWORK_CONFIGS["UI"]["Notification"].slideTopDuration), "OutBack")
    for i, j in imports.ipairs(notifUI.buffer) do
        local notifFontColor = j.fontColor or FRAMEWORK_CONFIGS["UI"]["Notification"].fontColor
        local notif_width, notif_height = imports.beautify.native.getTextWidth(j.text, 1, notifUI.font), FRAMEWORK_CONFIGS["UI"]["Notification"].height
        local notif_offsetX, notif_offsetY = 0, 0
        local notifAlphaPercent = 0
        if j.slideStatus == "forward" then
		    notif_offsetX, notif_offsetY = imports.interpolateBetween(CLIENT_MTA_RESOLUTION[1], notifUI.startY + ((i - 1)*(FRAMEWORK_CONFIGS["UI"]["Notification"].height + notifUI.paddingY)) - FRAMEWORK_CONFIGS["UI"]["Notification"].height, 0, (CLIENT_MTA_RESOLUTION[1]) - notifUI.startX - notif_width, notifUI.startY + ((i - 1)*(FRAMEWORK_CONFIGS["UI"]["Notification"].height + notifUI.paddingY)) + offsetY, 0, imports.getInterpolationProgress(j.tickCounter, FRAMEWORK_CONFIGS["UI"]["Notification"].slideInDuration), "InOutBack")
            notifAlphaPercent = imports.interpolateBetween(0, 0, 0, 1, 0, 0, imports.getInterpolationProgress(j.tickCounter, FRAMEWORK_CONFIGS["UI"]["Notification"].slideInDuration), "Linear")
            if imports.math.round(notifAlphaPercent, 2) == 1 then
                if (CLIENT_CURRENT_TICK - j.tickCounter - FRAMEWORK_CONFIGS["UI"]["Notification"].slideInDuration) >= FRAMEWORK_CONFIGS["UI"]["Notification"].slideDelayDuration then
                    j.slideStatus = "backward"
                    j.tickCounter = CLIENT_CURRENT_TICK
                    notifUI.offsetY = FRAMEWORK_CONFIGS["UI"]["Notification"].height
                    notifUI.slideTopTickCounter = CLIENT_CURRENT_TICK
                end
            end
        else
		    notif_offsetX, notif_offsetY = imports.interpolateBetween((CLIENT_MTA_RESOLUTION[1]) - notifUI.startX - notif_width, notifUI.startY + ((i - 1)*(FRAMEWORK_CONFIGS["UI"]["Notification"].height + notifUI.paddingY)), 0, CLIENT_MTA_RESOLUTION[1], notifUI.startY + ((i - 1)*(FRAMEWORK_CONFIGS["UI"]["Notification"].height + notifUI.paddingY)) + (FRAMEWORK_CONFIGS["UI"]["Notification"].height*0.5) - offsetY, 0, imports.getInterpolationProgress(j.tickCounter, FRAMEWORK_CONFIGS["UI"]["Notification"].slideOutDuration), "InOutBack")
            notifAlphaPercent = imports.interpolateBetween(1, 0, 0, 0, 0, 0, imports.getInterpolationProgress(j.tickCounter, FRAMEWORK_CONFIGS["UI"]["Notification"].slideOutDuration), "Linear")
        end
        imports.beautify.native.drawRectangle(notif_offsetX, notif_offsetY, notif_width, notif_height, imports.tocolor(FRAMEWORK_CONFIGS["UI"]["Notification"].bgColor[1], FRAMEWORK_CONFIGS["UI"]["Notification"].bgColor[2], FRAMEWORK_CONFIGS["UI"]["Notification"].bgColor[3], FRAMEWORK_CONFIGS["UI"]["Notification"].bgColor[4]*notifAlphaPercent), false)
        imports.beautify.native.drawImage(notif_offsetX - notif_height, notif_offsetY, notif_height, notif_height, notifUI.leftEdgeTexture, 0, 0, 0, imports.tocolor(FRAMEWORK_CONFIGS["UI"]["Notification"].bgColor[1], FRAMEWORK_CONFIGS["UI"]["Notification"].bgColor[2], FRAMEWORK_CONFIGS["UI"]["Notification"].bgColor[3], FRAMEWORK_CONFIGS["UI"]["Notification"].bgColor[4]*notifAlphaPercent), false)
        imports.beautify.native.drawImage(notif_offsetX + notif_width, notif_offsetY, notif_height, notif_height, notifUI.rightEdgeTexture, 0, 0, 0, imports.tocolor(FRAMEWORK_CONFIGS["UI"]["Notification"].bgColor[1], FRAMEWORK_CONFIGS["UI"]["Notification"].bgColor[2], FRAMEWORK_CONFIGS["UI"]["Notification"].bgColor[3], FRAMEWORK_CONFIGS["UI"]["Notification"].bgColor[4]*notifAlphaPercent), false)
        imports.beautify.native.drawText(j.text, notif_offsetX, notif_offsetY, notif_offsetX + notif_width, notif_offsetY + notif_height, imports.tocolor(notifFontColor[1], notifFontColor[2], notifFontColor[3], notifFontColor[4]*notifAlphaPercent), 1, notifUI.font, "center", "center", true, false, false, false, true)
        if j.slideStatus == "backward" then
            if imports.math.round(notifAlphaPercent, 2) == 0 then
                imports.table.remove(notifUI.buffer, i)
            end
        end
    end
end, {
    renderType = "input"
})


---------------------------------
--[[ Client: On Notification ]]--
---------------------------------

imports.addEvent("Client:onNotification", true)
imports.addEventHandler("Client:onNotification", root, function(message, color)
    if (not message or imports.type(message) ~= "string" or message == "") then return false end

    imports.table.insert(notifUI.buffer, {
        text = message,
        fontColor = color,
        slideStatus = "forward",
        tickCounter = CLIENT_CURRENT_TICK
    })
end)