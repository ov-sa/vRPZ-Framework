----------------------------------------------------------------
--[[ Resource: Player Handler
     Script: gui: loading.lua
     Author: vStudio
     Developer(s): Mario, Tron
     DOC: 31/01/2022
     Desc: Loading UI Handler ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local imports = {
    tocolor = tocolor,
    addEvent = addEvent,
    addEventHandler = addEventHandler,
    triggerEvent = triggerEvent,
    dxCreateTexture = dxCreateTexture,
    dxDrawRectangle = dxDrawRectangle,
    dxDrawImage = dxDrawImage,
    dxDrawText = dxDrawText,
    interpolateBetween = interpolateBetween,
    getInterpolationProgress = getInterpolationProgress,
    math = math
}


-------------------
--[[ Variables ]]--
-------------------

loadingUI = {
    animStatus = "backward",
    animFadeInDuration = 500,
    animFadeOutDuration = 2500,
    animFadeDelayDuration = 2000,
    fadeAnimPercent = 0,
    tickCounter = CLIENT_CURRENT_TICK,
    bgColor = {0, 0, 0, 255},
    loader = {
        startX = 0,
        startY = (CLIENT_MTA_RESOLUTION[2]/768)*-15,
        size = 50,
        tickCounter = CLIENT_CURRENT_TICK,
        animDuration = 750,
        rotationValue = 0,
        bgColor = {200, 200, 200, 255},
        bgPath = imports.dxCreateTexture("files/images/loading/loader.png", "argb", true, "clamp")
    },
    hint = {
        paddingX = 5,
        paddingY = 10,
        text = "",
        font = FRAMEWORK_FONTS[1],
        fontColor = imports.tocolor(200, 200, 200, 255)
    }
}
loadingUI.loader.startX = loadingUI.loader.startX + ((CLIENT_MTA_RESOLUTION[1] - loadingUI.loader.size)/2)
loadingUI.loader.startY = loadingUI.loader.startY + ((CLIENT_MTA_RESOLUTION[2] - loadingUI.loader.size)/2)


------------------------------
--[[ Function: Renders UI ]]--
------------------------------

beautify.render.create(function()
    if ((loadingUI.animStatus == "forward") or (loadingUI.animStatus == "reverse_backward")) then
        loadingUI.fadeAnimPercent = imports.interpolateBetween(loadingUI.fadeAnimPercent, 0, 0, 1, 0, 0, imports.getInterpolationProgress(loadingUI.tickCounter, loadingUI.animFadeInDuration), "Linear")
        if loadingUI.animStatus == "reverse_backward" and imports.math.round(loadingUI.fadeAnimPercent, 2) == 1 then
            if (CLIENT_CURRENT_TICK - loadingUI.tickCounter) >= (loadingUI.animFadeInDuration + loadingUI.animFadeDelayDuration) then
                loadingUI.animStatus = "backward"
                loadingUI.tickCounter = CLIENT_CURRENT_TICK
            end
        end
    elseif loadingUI.animStatus == "backward" then
        loadingUI.fadeAnimPercent = imports.interpolateBetween(loadingUI.fadeAnimPercent, 0, 0, 0, 0, 0, imports.getInterpolationProgress(loadingUI.tickCounter, loadingUI.animFadeOutDuration), "Linear")
    end

    loadingUI.loader.rotationValue = imports.interpolateBetween(0, 0, 0, 360, 0, 0, imports.getInterpolationProgress(loadingUI.loader.tickCounter, loadingUI.loader.animDuration), "Linear")
    if imports.math.round(loadingUI.loader.rotationValue, 2) == 360 then
        loadingUI.loader.tickCounter = CLIENT_CURRENT_TICK
    end
    imports.dxDrawRectangle(0, 0, CLIENT_MTA_RESOLUTION[1], CLIENT_MTA_RESOLUTION[2], imports.tocolor(loadingUI.bgColor[1], loadingUI.bgColor[2], loadingUI.bgColor[3], loadingUI.bgColor[4]*loadingUI.fadeAnimPercent), true)
    imports.dxDrawImage(loadingUI.loader.startX, loadingUI.loader.startY, loadingUI.loader.size, loadingUI.loader.size, loadingUI.loader.bgPath, loadingUI.loader.rotationValue, 0, 0, imports.tocolor(loadingUI.loader.bgColor[1], loadingUI.loader.bgColor[2], loadingUI.loader.bgColor[3], loadingUI.loader.bgColor[4]*loadingUI.fadeAnimPercent), true)
    imports.dxDrawText(loadingUI.hint.text, loadingUI.hint.paddingX, loadingUI.loader.startY + loadingUI.loader.size + loadingUI.hint.paddingY, CLIENT_MTA_RESOLUTION[1] - loadingUI.hint.paddingX, CLIENT_MTA_RESOLUTION[2] - loadingUI.hint.paddingY, loadingUI.hint.fontColor, 1, loadingUI.hint.font, "center", "top", true, true, true)
end)


-------------------------------------
--[[ Event: On Toggle Loading UI ]]--
-------------------------------------

imports.addEvent("Client:onToggleLoadingUI", true)
imports.addEventHandler("Client:onToggleLoadingUI", root, function(state, arguments)
    if state then
        if (state and (loadingUI.animStatus == "forward")) then return false end
        loadingUI.animStatus = "forward"
        loadingUI.tickCounter = CLIENT_CURRENT_TICK
        loadingUI.loader.tickCounter = CLIENT_CURRENT_TICK
        loadingUI.hint.text = FRAMEWORK_CONFIGS["UI"]["Loading"]["Hints"][imports.math.random(#FRAMEWORK_CONFIGS["UI"]["Loading"]["Hints"])] or loadingUI.hint.text
        --TODO: ,,,
        imports.triggerEvent("onLoginSoundStart", localPlayer, (arguments and arguments.shuffleMusic and true) or false)
    else
        if ((loadingUI.animStatus == "backward") or (loadingUI.animStatus == "reverse_backward")) then return false end
        loadingUI.animStatus = "reverse_backward"
        loadingUI.tickCounter = CLIENT_CURRENT_TICK
        if not loginUI.state then
            imports.triggerEvent("onLoginSoundStop", localPlayer)
        end
    end
    return true
end)