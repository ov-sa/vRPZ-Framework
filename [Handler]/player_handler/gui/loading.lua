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
    loader = {
        startX = 0,
        startY = (CLIENT_MTA_RESOLUTION[2]/768)*15,
        width = 80,
        height = 80,
        tickCounter = CLIENT_CURRENT_TICK,
        animDuration = 750,
        rotationValue = 0,
        bgPath = imports.dxCreateTexture("files/images/loading/loader.png", "argb", true, "clamp")
    }
}
loadingUI.loader.startX = loadingUI.loader.startX + ((CLIENT_MTA_RESOLUTION[1] - loadingUI.loader.width)/2)
loadingUI.loader.startY = loadingUI.loader.startY + ((CLIENT_MTA_RESOLUTION[2] - loadingUI.loader.height)/2)


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
    imports.dxDrawRectangle(0, 0, CLIENT_MTA_RESOLUTION[1], CLIENT_MTA_RESOLUTION[2], imports.tocolor(0, 0, 0, 255*loadingUI.fadeAnimPercent), true)
    imports.dxDrawImage(loadingUI.loader.startX, loadingUI.loader.startY, loadingUI.loader.width, loadingUI.loader.height, loadingUI.loader.bgPath, loadingUI.loader.rotationValue, 0, 0, imports.tocolor(255, 255, 255, 200*loadingUI.fadeAnimPercent), true)

end)


------------------------------------------------
--[[ Events: On Player Show/Hide Loading UI ]]--
------------------------------------------------

imports.addEvent("Player:onHideLoadingUI", true)
imports.addEventHandler("Player:onHideLoadingUI", root, function(shuffleMusic)

    if loadingUI.animStatus == "forward" then return false end
    
    loadingUI.animStatus = "forward"
    loadingUI.tickCounter = CLIENT_CURRENT_TICK
    loadingUI.loader.tickCounter = CLIENT_CURRENT_TICK
    imports.triggerEvent("onLoginSoundStart", localPlayer, (shuffleMusic and true) or false)
    return true

end)

imports.addEvent("Player:onShowLoadingUI", true)
imports.addEventHandler("Player:onShowLoadingUI", root, function()

    if ((loadingUI.animStatus == "backward") or (loadingUI.animStatus == "reverse_backward")) then return false end

    loadingUI.animStatus = "reverse_backward"
    loadingUI.tickCounter = CLIENT_CURRENT_TICK
    if not loginUI.state then
        imports.triggerEvent("onLoginSoundStop", localPlayer)
    end
    return true

end)