----------------------------------------------------------------
--[[ Resource: Player Handler
     Script: gui: notification.lua
     Author: vStudio
     Developer(s): Mario, Tron, Aviril, Аниса
     DOC: 31/01/2022
     Desc: Notification UI Handler ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local imports = {
    tocolor = tocolor,
    interpolateBetween = interpolateBetween,
    getInterpolationProgress = getInterpolationProgress,
    table = table,
    math = math,
    beautify = beautify,
    assetify = assetify
}


-------------------
--[[ Namespace ]]--
-------------------

local notifUI = assetify.namespace:create("notifUI")
CGame.execOnModuleLoad(function()
notifUI.private.buffer = {}
notifUI.private.startX, notifUI.private.startY, notifUI.private.paddingY, notifUI.private.offsetY = -5, 5, 10, 0
notifUI.private.slideTopTickCounter = CLIENT_CURRENT_TICK
notifUI.private.font = CGame.createFont(2, 10)


------------------------------
--[[ Function: Renders UI ]]--
------------------------------

notifUI.private.renderUI = function()
    if #notifUI.private.buffer <= 0 then
        return imports.beautify.render.remove(notifUI.private.renderUI, {renderType = "input"})
    end

    local offsetY = imports.interpolateBetween(notifUI.private.offsetY, 0, 0, 0, 0, 0, imports.getInterpolationProgress(notifUI.private.slideTopTickCounter, FRAMEWORK_CONFIGS["UI"]["Notification"].slideTopDuration), "OutBack")
    for i = 1, #notifUI.private.buffer, 1 do
        local j = notifUI.private.buffer[i]
        if j then
            local notif_offsetX, notif_offsetY = 0, 0
            local notif_fontColor = j.fontColor or FRAMEWORK_CONFIGS["UI"]["Notification"].fontColor
            if j.slideStatus == "forward" then
                notif_offsetX, notif_offsetY = imports.interpolateBetween(CLIENT_MTA_RESOLUTION[1], notifUI.private.startY + ((i - 1)*(FRAMEWORK_CONFIGS["UI"]["Notification"].height + notifUI.private.paddingY)) - FRAMEWORK_CONFIGS["UI"]["Notification"].height, 0, (CLIENT_MTA_RESOLUTION[1]) + notifUI.private.startX - j.width, notifUI.private.startY + ((i - 1)*(FRAMEWORK_CONFIGS["UI"]["Notification"].height + notifUI.private.paddingY)) + offsetY, 0, imports.getInterpolationProgress(j.tickCounter, FRAMEWORK_CONFIGS["UI"]["Notification"].slideInDuration), "InOutBack")
                j.alphaPercent = imports.interpolateBetween(0, 0, 0, 1, 0, 0, imports.getInterpolationProgress(j.tickCounter, FRAMEWORK_CONFIGS["UI"]["Notification"].slideInDuration), "Linear")
                if imports.math.round(j.alphaPercent, 2) == 1 then
                    if (CLIENT_CURRENT_TICK - j.tickCounter - FRAMEWORK_CONFIGS["UI"]["Notification"].slideInDuration) >= FRAMEWORK_CONFIGS["UI"]["Notification"].slideDelayDuration then
                        j.slideStatus = "backward"
                        j.tickCounter = CLIENT_CURRENT_TICK
                        notifUI.private.offsetY = FRAMEWORK_CONFIGS["UI"]["Notification"].height
                        notifUI.private.slideTopTickCounter = CLIENT_CURRENT_TICK
                    end
                end
            else
                notif_offsetX, notif_offsetY = imports.interpolateBetween((CLIENT_MTA_RESOLUTION[1]) + notifUI.private.startX - j.width, notifUI.private.startY + ((i - 1)*(FRAMEWORK_CONFIGS["UI"]["Notification"].height + notifUI.private.paddingY)), 0, CLIENT_MTA_RESOLUTION[1], notifUI.private.startY + ((i - 1)*(FRAMEWORK_CONFIGS["UI"]["Notification"].height + notifUI.private.paddingY)) + (FRAMEWORK_CONFIGS["UI"]["Notification"].height*0.5) - offsetY, 0, imports.getInterpolationProgress(j.tickCounter, FRAMEWORK_CONFIGS["UI"]["Notification"].slideOutDuration), "InOutBack")
                j.alphaPercent = imports.interpolateBetween(1, 0, 0, 0, 0, 0, imports.getInterpolationProgress(j.tickCounter, FRAMEWORK_CONFIGS["UI"]["Notification"].slideOutDuration), "Linear")
            end
            imports.beautify.native.drawText(j.text, notif_offsetX, notif_offsetY, notif_offsetX + j.width, notif_offsetY + FRAMEWORK_CONFIGS["UI"]["Notification"].height, imports.tocolor(notif_fontColor[1], notif_fontColor[2], notif_fontColor[3], notif_fontColor[4]*j.alphaPercent), 1, notifUI.private.font.instance, "center", "center", true, false, false, false, true)
            if j.slideStatus == "backward" then
                if imports.math.round(j.alphaPercent, 2) == 0 then
                    imports.table.remove(notifUI.private.buffer, i)
                end
            end
        end
    end
end


---------------------------------
--[[ Client: On Notification ]]--
---------------------------------

imports.assetify.network:create("Client:onNotification"):on(function(message, color)
    if not message then return false end

    imports.table.insert(notifUI.private.buffer, {
        text = message,
        width = imports.beautify.native.getTextWidth(message, 1, notifUI.private.font.instance),
        fontColor = color,
        slideStatus = "forward",
        tickCounter = CLIENT_CURRENT_TICK
    })
    if #notifUI.private.buffer <= 1 then
        imports.beautify.render.create(notifUI.private.renderUI, {renderType = "input"})
    end
end)
end)