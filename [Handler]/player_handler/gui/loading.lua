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

loadingScreenCache = {
    animStatus = "backward",
    animFadeInDuration = 500,
    animFadeOutDuration = 2500,
    animFadeDelayDuration = 2000,
    fadeAnimPercent = 0,
    tickCounter = CLIENT_CURRENT_TICK,
    loader = {
        startX = 0,
        startY = (CLIENT_MTA_RESOLUTION[2]/768)*15,
        width = 90,
        height = 90,
        tickCounter = CLIENT_CURRENT_TICK,
        animDuration = 750,
        rotationValue = 0,
        bgPath = imports.dxCreateTexture("files/images/loading/loader.png", "argb", true, "clamp")
    }
}
loadingScreenCache.loader.startX = loadingScreenCache.loader.startX + ((CLIENT_MTA_RESOLUTION[1] - loadingScreenCache.loader.width)/2)
loadingScreenCache.loader.startY = loadingScreenCache.loader.startY + ((CLIENT_MTA_RESOLUTION[2] - loadingScreenCache.loader.height)/2)


---------------------------------
--[[ Event: On Client Render ]]--
---------------------------------

imports.addEventHandler("onClientRender", root, function()

    if ((loadingScreenCache.animStatus == "forward") or (loadingScreenCache.animStatus == "reverse_backward")) then
        loadingScreenCache.fadeAnimPercent = imports.interpolateBetween(loadingScreenCache.fadeAnimPercent, 0, 0, 1, 0, 0, imports.getInterpolationProgress(loadingScreenCache.tickCounter, loadingScreenCache.animFadeInDuration), "Linear")
        if loadingScreenCache.animStatus == "reverse_backward" and imports.math.round(loadingScreenCache.fadeAnimPercent, 2) == 1 then
            if (CLIENT_CURRENT_TICK - loadingScreenCache.tickCounter) >= (loadingScreenCache.animFadeInDuration + loadingScreenCache.animFadeDelayDuration) then
                loadingScreenCache.animStatus = "backward"
                loadingScreenCache.tickCounter = CLIENT_CURRENT_TICK
            end
        end
    elseif loadingScreenCache.animStatus == "backward" then
        loadingScreenCache.fadeAnimPercent = imports.interpolateBetween(loadingScreenCache.fadeAnimPercent, 0, 0, 0, 0, 0, imports.getInterpolationProgress(loadingScreenCache.tickCounter, loadingScreenCache.animFadeOutDuration), "Linear")
    end

    loadingScreenCache.loader.rotationValue = imports.interpolateBetween(0, 0, 0, 360, 0, 0, imports.getInterpolationProgress(loadingScreenCache.loader.tickCounter, loadingScreenCache.loader.animDuration), "Linear")
    if imports.math.round(loadingScreenCache.loader.rotationValue, 2) == 360 then
        loadingScreenCache.loader.tickCounter = CLIENT_CURRENT_TICK
    end
    imports.dxDrawRectangle(0, 0, CLIENT_MTA_RESOLUTION[1], CLIENT_MTA_RESOLUTION[2], imports.tocolor(0, 0, 0, 255*loadingScreenCache.fadeAnimPercent), true)
    imports.dxDrawImage(loadingScreenCache.loader.startX, loadingScreenCache.loader.startY, loadingScreenCache.loader.width, loadingScreenCache.loader.height, loadingScreenCache.loader.bgPath, loadingScreenCache.loader.rotationValue, 0, 0, imports.tocolor(255, 255, 255, 200*loadingScreenCache.fadeAnimPercent), true)

end)


------------------------------------------------
--[[ Events: On Player Show/Hide Loading UI ]]--
------------------------------------------------

imports.addEvent("Player:onHideLoadingUI", true)
imports.addEventHandler("Player:onHideLoadingUI", root, function(shuffleMusic)

    if loadingScreenCache.animStatus == "forward" then return false end
    
    loadingScreenCache.animStatus = "forward"
    loadingScreenCache.tickCounter = CLIENT_CURRENT_TICK
    loadingScreenCache.loader.tickCounter = CLIENT_CURRENT_TICK
    imports.triggerEvent("onLoginSoundStart", localPlayer, (shuffleMusic and true) or false)
    return true

end)

imports.addEvent("Player:onShowLoadingUI", true)
imports.addEventHandler("Player:onShowLoadingUI", root, function()

    if ((loadingScreenCache.animStatus == "backward") or (loadingScreenCache.animStatus == "reverse_backward")) then return false end

    loadingScreenCache.animStatus = "reverse_backward"
    loadingScreenCache.tickCounter = CLIENT_CURRENT_TICK
    if not loginScreenCache.state then
        imports.triggerEvent("onLoginSoundStop", localPlayer)
    end
    return true

end)