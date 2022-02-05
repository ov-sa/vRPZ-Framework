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
    tocolor = tocolor,
    ipairs = ipairs,
    addEvent = addEvent,
    addEventHandler = addEventHandler,
    dxDrawRectangle = dxDrawRectangle,
    dxDrawImage = dxDrawImage,
    dxDrawText = dxDrawText,
    dxGetTextWidth = dxGetTextWidth,
    interpolateBetween = interpolateBetween,
    getInterpolationProgress = getInterpolationProgress,
    table = table,
    math = math
}


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
    leftCurvedEdgePath = beautify.assets["images"]["curved_square/regular/left.rw"],
    rightCurvedEdgePath = beautify.assets["images"]["curved_square/regular/right.rw"]
}


------------------------------
--[[ Function: Renders UI ]]--
------------------------------

beautify.render.create(function()
    if #notifUI.buffer <= 0 then return false end

    local currentYOffset = imports.interpolateBetween(notifUI.currentYOffset, 0, 0, 0, 0, 0, imports.getInterpolationProgress(notifUI.slideTopTickCounter, notifUI.slideTopDuration), "OutBack")
    for i, j in imports.ipairs(notifUI.buffer) do
        local notifFontColor = j.fontColor or notifUI.defaultFontColor
        local notif_width, notif_height = imports.dxGetTextWidth(j.text, 1, notifUI.font), notifUI.height
        local notif_offsetX, notif_offsetY = 0, 0
        local notifAlphaPercent = 0
        if j.slideStatus == "forward" then
		    notif_offsetX, notif_offsetY = imports.interpolateBetween(CLIENT_MTA_RESOLUTION[1], notifUI.startY + ((i - 1)*(notifUI.height + notifUI.paddingY)) - notifUI.height, 0, (CLIENT_MTA_RESOLUTION[1]) - notifUI.startX - notif_width, notifUI.startY + ((i - 1)*(notifUI.height + notifUI.paddingY)) + currentYOffset, 0, imports.getInterpolationProgress(j.tickCounter, notifUI.slideInDuration), "InOutBack")
            notifAlphaPercent = imports.interpolateBetween(0, 0, 0, 1, 0, 0, imports.getInterpolationProgress(j.tickCounter, notifUI.slideInDuration), "Linear")
            if imports.math.round(notifAlphaPercent, 2) == 1 then
                if (CLIENT_CURRENT_TICK - j.tickCounter - notifUI.slideInDuration) >= notifUI.slideAnimDelayDuration then
                    j.slideStatus = "backward"
                    j.tickCounter = CLIENT_CURRENT_TICK
                    notifUI.currentYOffset = notifUI.height
                    notifUI.slideTopTickCounter = CLIENT_CURRENT_TICK
                end
            end
        else
		    notif_offsetX, notif_offsetY = imports.interpolateBetween((CLIENT_MTA_RESOLUTION[1]) - notifUI.startX - notif_width, notifUI.startY + ((i - 1)*(notifUI.height + notifUI.paddingY)), 0, CLIENT_MTA_RESOLUTION[1], notifUI.startY + ((i - 1)*(notifUI.height + notifUI.paddingY)) + (notifUI.height/2) - currentYOffset, 0, imports.getInterpolationProgress(j.tickCounter, notifUI.slideOutDuration), "InOutBack")
            notifAlphaPercent = imports.interpolateBetween(1, 0, 0, 0, 0, 0, imports.getInterpolationProgress(j.tickCounter, notifUI.slideOutDuration), "Linear")
        end
        imports.dxDrawRectangle(notif_offsetX, notif_offsetY, notif_width, notif_height, imports.tocolor(notifUI.bgColor[1], notifUI.bgColor[2], notifUI.bgColor[3], notifUI.bgColor[4]*notifAlphaPercent), false)
        imports.dxDrawImage(notif_offsetX - notif_height, notif_offsetY, notif_height, notif_height, notifUI.leftCurvedEdgePath, 0, 0, 0, imports.tocolor(notifUI.bgColor[1], notifUI.bgColor[2], notifUI.bgColor[3], notifUI.bgColor[4]*notifAlphaPercent), false)
        imports.dxDrawImage(notif_offsetX + notif_width, notif_offsetY, notif_height, notif_height, notifUI.rightCurvedEdgePath, 0, 0, 0, imports.tocolor(notifUI.bgColor[1], notifUI.bgColor[2], notifUI.bgColor[3], notifUI.bgColor[4]*notifAlphaPercent), false)
        imports.dxdrawText(j.text, notif_offsetX, notif_offsetY, notif_offsetX + notif_width, notif_offsetY + notif_height, imports.tocolor(notifFontColor[1], notifFontColor[2], notifFontColor[3], notifFontColor[4]*notifAlphaPercent), 1, notifUI.font, "center", "center", true, false, false, false, true)
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