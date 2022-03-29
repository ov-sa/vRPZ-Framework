----------------------------------------------------------------
--[[ Resource: Assetify Mapper
     Script: gui: notif.lua
     Author: vStudio
     Developer(s): Tron
     DOC: 25/03/2022
     Desc: Notif UI Handler ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local imports = {
    type = type,
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

mapper.ui.notif = {
    buffer = {},
    startX = -5, startY = 5, paddingY = 5, offsetY = 0,
    slideTopTickCounter = CLIENT_CURRENT_TICK,
    --font = CGame.createFont(":beautify_library/files/assets/fonts/teko_medium.rw", 17),
    leftEdgeTexture = imports.beautify.assets["images"]["curved_square/regular/left.rw"],
    rightEdgeTexture = imports.beautify.assets["images"]["curved_square/regular/right.rw"]
}


-------------------------------------
--[[ Functions: Renders Notif UI ]]--
-------------------------------------

mapper.ui.notif.renderUI = function()
    if #mapper.ui.renderNotif.buffer <= 0 then
        return imports.beautify.render.remove(mapper.ui.notif.renderUI, {renderType = "input"})
    end

    local offsetY = imports.interpolateBetween(mapper.ui.renderNotif.offsetY, 0, 0, 0, 0, 0, imports.getInterpolationProgress(mapper.ui.renderNotif.slideTopTickCounter, FRAMEWORK_CONFIGS["UI"]["Notification"].slideTopDuration), "OutBack")
    for i = 1, #mapper.ui.renderNotif.buffer, 1 do
        local j = mapper.ui.renderNotif.buffer[i]
        if j then
            local notifFontColor = j.fontColor or FRAMEWORK_CONFIGS["UI"]["Notification"].fontColor
            local notif_width, notif_height = imports.beautify.native.getTextWidth(j.text, 1, mapper.ui.renderNotif.font), FRAMEWORK_CONFIGS["UI"]["Notification"].height
            local notif_offsetX, notif_offsetY = 0, 0
            local notifAlphaPercent = 0
            if j.slideStatus == "forward" then
                notif_offsetX, notif_offsetY = imports.interpolateBetween(CLIENT_MTA_RESOLUTION[1], mapper.ui.renderNotif.startY + ((i - 1)*(FRAMEWORK_CONFIGS["UI"]["Notification"].height + mapper.ui.renderNotif.paddingY)) - FRAMEWORK_CONFIGS["UI"]["Notification"].height, 0, (CLIENT_MTA_RESOLUTION[1]) + mapper.ui.renderNotif.startX - notif_width - notif_height, mapper.ui.renderNotif.startY + ((i - 1)*(FRAMEWORK_CONFIGS["UI"]["Notification"].height + mapper.ui.renderNotif.paddingY)) + offsetY, 0, imports.getInterpolationProgress(j.tickCounter, FRAMEWORK_CONFIGS["UI"]["Notification"].slideInDuration), "InOutBack")
                notifAlphaPercent = imports.interpolateBetween(0, 0, 0, 1, 0, 0, imports.getInterpolationProgress(j.tickCounter, FRAMEWORK_CONFIGS["UI"]["Notification"].slideInDuration), "Linear")
                if imports.math.round(notifAlphaPercent, 2) == 1 then
                    if (CLIENT_CURRENT_TICK - j.tickCounter - FRAMEWORK_CONFIGS["UI"]["Notification"].slideInDuration) >= FRAMEWORK_CONFIGS["UI"]["Notification"].slideDelayDuration then
                        j.slideStatus = "backward"
                        j.tickCounter = CLIENT_CURRENT_TICK
                        mapper.ui.renderNotif.offsetY = FRAMEWORK_CONFIGS["UI"]["Notification"].height
                        mapper.ui.renderNotif.slideTopTickCounter = CLIENT_CURRENT_TICK
                    end
                end
            else
                notif_offsetX, notif_offsetY = imports.interpolateBetween((CLIENT_MTA_RESOLUTION[1]) + mapper.ui.renderNotif.startX - notif_width - notif_height, mapper.ui.renderNotif.startY + ((i - 1)*(FRAMEWORK_CONFIGS["UI"]["Notification"].height + mapper.ui.renderNotif.paddingY)), 0, CLIENT_MTA_RESOLUTION[1], mapper.ui.renderNotif.startY + ((i - 1)*(FRAMEWORK_CONFIGS["UI"]["Notification"].height + mapper.ui.renderNotif.paddingY)) + (FRAMEWORK_CONFIGS["UI"]["Notification"].height*0.5) - offsetY, 0, imports.getInterpolationProgress(j.tickCounter, FRAMEWORK_CONFIGS["UI"]["Notification"].slideOutDuration), "InOutBack")
                notifAlphaPercent = imports.interpolateBetween(1, 0, 0, 0, 0, 0, imports.getInterpolationProgress(j.tickCounter, FRAMEWORK_CONFIGS["UI"]["Notification"].slideOutDuration), "Linear")
            end
            imports.beautify.native.drawRectangle(notif_offsetX, notif_offsetY, notif_width, notif_height, imports.tocolor(FRAMEWORK_CONFIGS["UI"]["Notification"].bgColor[1], FRAMEWORK_CONFIGS["UI"]["Notification"].bgColor[2], FRAMEWORK_CONFIGS["UI"]["Notification"].bgColor[3], FRAMEWORK_CONFIGS["UI"]["Notification"].bgColor[4]*notifAlphaPercent), false)
            imports.beautify.native.drawImage(notif_offsetX - notif_height, notif_offsetY, notif_height, notif_height, mapper.ui.renderNotif.leftEdgeTexture, 0, 0, 0, imports.tocolor(FRAMEWORK_CONFIGS["UI"]["Notification"].bgColor[1], FRAMEWORK_CONFIGS["UI"]["Notification"].bgColor[2], FRAMEWORK_CONFIGS["UI"]["Notification"].bgColor[3], FRAMEWORK_CONFIGS["UI"]["Notification"].bgColor[4]*notifAlphaPercent), false)
            imports.beautify.native.drawImage(notif_offsetX + notif_width, notif_offsetY, notif_height, notif_height, mapper.ui.renderNotif.rightEdgeTexture, 0, 0, 0, imports.tocolor(FRAMEWORK_CONFIGS["UI"]["Notification"].bgColor[1], FRAMEWORK_CONFIGS["UI"]["Notification"].bgColor[2], FRAMEWORK_CONFIGS["UI"]["Notification"].bgColor[3], FRAMEWORK_CONFIGS["UI"]["Notification"].bgColor[4]*notifAlphaPercent), false)
            imports.beautify.native.drawText(j.text, notif_offsetX, notif_offsetY, notif_offsetX + notif_width, notif_offsetY + notif_height, imports.tocolor(notifFontColor[1], notifFontColor[2], notifFontColor[3], notifFontColor[4]*notifAlphaPercent), 1, mapper.ui.renderNotif.font, "center", "center", true, false, false, false, true)
            if j.slideStatus == "backward" then
                if imports.math.round(notifAlphaPercent, 2) == 0 then
                    imports.table.remove(mapper.ui.renderNotif.buffer, i)
                end
            end
        end
    end
end


--------------------------------
--[[ Event: On Notification ]]--
--------------------------------

imports.addEvent("Assetify_Mapper:onNotification", true)
imports.addEventHandler("Assetify_Mapper:onNotification", root, function(message, color)
    if (not message or imports.type(message) ~= "string" or message == "") then return false end

    imports.table.insert(mapper.ui.renderNotif.buffer, {
        text = message,
        fontColor = color,
        slideStatus = "forward",
        tickCounter = CLIENT_CURRENT_TICK
    })
    if #mapper.ui.renderNotif.buffer <= 1 then
        imports.beautify.render.create(mapper.ui.notif.renderUI, {renderType = "input"})
    end
end)