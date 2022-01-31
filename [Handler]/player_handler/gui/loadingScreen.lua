----------------------------------------------------------------
--[[ Resource: Player Handler
     Script: gui: loadingScreen.lua
     Server: -
     Author: OvileAmriam
     Developer: -
     DOC: 18/12/2020 (OvileAmriam)
     Desc: Loading Screen UI ]]--
----------------------------------------------------------------


-------------------
--[[ Variables ]]--
-------------------

loadingScreenCache = {
    animStatus = "backward",
    animFadeInDuration = 500,
    animFadeOutDuration = 2500,
    animFadeDelayDuration = 2000,
    fadeAnimPercent = 0,
    tickCounter = getTickCount(),
    loader = {
        startX = 0,
        startY = (sY/768)*15,
        width = 90,
        height = 90,
        tickCounter = getTickCount(),
        animDuration = 750,
        rotationValue = 0,
        bgPath = DxTexture("files/images/loading/loader.png", "argb", true, "clamp")
    }
}
loadingScreenCache.loader.startX = loadingScreenCache.loader.startX + ((sX - loadingScreenCache.loader.width)/2)
loadingScreenCache.loader.startY = loadingScreenCache.loader.startY + ((sY - loadingScreenCache.loader.height)/2)


---------------------------------
--[[ Event: On Client Render ]]--
---------------------------------

addEventHandler("onClientRender", root, function()

    if loadingScreenCache.animStatus == "forward" or loadingScreenCache.animStatus == "reverse_backward" then
        loadingScreenCache.fadeAnimPercent = interpolateBetween(loadingScreenCache.fadeAnimPercent, 0, 0, 1, 0, 0, getInterpolationProgress(loadingScreenCache.tickCounter, loadingScreenCache.animFadeInDuration), "Linear")
        if loadingScreenCache.animStatus == "reverse_backward" and math.round(loadingScreenCache.fadeAnimPercent, 2) == 1 then
            if (getTickCount() - loadingScreenCache.tickCounter) >= (loadingScreenCache.animFadeInDuration + loadingScreenCache.animFadeDelayDuration) then
                loadingScreenCache.animStatus = "backward"
                loadingScreenCache.tickCounter = getTickCount()
            end
        end
    elseif loadingScreenCache.animStatus == "backward" then
        loadingScreenCache.fadeAnimPercent = interpolateBetween(loadingScreenCache.fadeAnimPercent, 0, 0, 0, 0, 0, getInterpolationProgress(loadingScreenCache.tickCounter, loadingScreenCache.animFadeOutDuration), "Linear")
    end
    loadingScreenCache.loader.rotationValue = interpolateBetween(0, 0, 0, 360, 0, 0, getInterpolationProgress(loadingScreenCache.loader.tickCounter, loadingScreenCache.loader.animDuration), "Linear")
    if math.round(loadingScreenCache.loader.rotationValue, 2) == 360 then
        loadingScreenCache.loader.tickCounter = getTickCount()
    end
    dxDrawRectangle(0, 0, sX, sY, tocolor(0, 0, 0, 255*loadingScreenCache.fadeAnimPercent), true)
    dxDrawImage(loadingScreenCache.loader.startX, loadingScreenCache.loader.startY, loadingScreenCache.loader.width, loadingScreenCache.loader.height, loadingScreenCache.loader.bgPath, loadingScreenCache.loader.rotationValue, 0, 0, tocolor(255, 255, 255, 200*loadingScreenCache.fadeAnimPercent), true)

end)


----------------------------------------------------
--[[ Events: On Player Show/Hide Loading Screen ]]--
----------------------------------------------------

addEvent("onPlayerShowLoadingScreen", true)
addEventHandler("onPlayerShowLoadingScreen", root, function(isLoginMusicToBeShuffled)

    if loadingScreenCache.animStatus == "forward" then return false end
    
    loadingScreenCache.animStatus = "forward"
    loadingScreenCache.tickCounter = getTickCount()
    loadingScreenCache.loader.tickCounter = getTickCount()
    triggerEvent("onLoginSoundStart", localPlayer, (isLoginMusicToBeShuffled and true) or false)
    return true

end)

addEvent("onPlayerHideLoadingScreen", true)
addEventHandler("onPlayerHideLoadingScreen", root, function()

    if loadingScreenCache.animStatus == "backward" or loadingScreenCache.animStatus == "reverse_backward" then return false end

    loadingScreenCache.animStatus = "reverse_backward"
    loadingScreenCache.tickCounter = getTickCount()
    if not loginScreenCache.state then
        triggerEvent("onLoginSoundStop", localPlayer)
    end
    return true

end)