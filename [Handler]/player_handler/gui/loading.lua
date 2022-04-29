----------------------------------------------------------------
--[[ Resource: Player Handler
     Script: gui: loading.lua
     Author: vStudio
     Developer(s): Mario, Tron, Aviril, Аниса
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
    interpolateBetween = interpolateBetween,
    getInterpolationProgress = getInterpolationProgress,
    math = math,
    beautify = beautify,
    assetify = assetify
}


-------------------
--[[ Variables ]]--
-------------------

local loadingUI = {
    animStatus = "backward",
    fadeAnimPercent = 0,
    tickCounter = CLIENT_CURRENT_TICK,
    loader = {
        startX = 0, startY = (CLIENT_MTA_RESOLUTION[2]/768)*-15,
        tickCounter = CLIENT_CURRENT_TICK,
        bgTexture = imports.beautify.native.createTexture("files/images/loading/loader.rw", "dxt5", true, "clamp")
    },
    hint = {
        paddingX = 5, paddingY = 15,
        text = "",
        font = CGame.createFont(1, 23)
    }
}

loadingUI.loader.startX = loadingUI.loader.startX + ((CLIENT_MTA_RESOLUTION[1] - FRAMEWORK_CONFIGS["UI"]["Loading"].loader.size)*0.5)
loadingUI.loader.startY = loadingUI.loader.startY + ((CLIENT_MTA_RESOLUTION[2] - FRAMEWORK_CONFIGS["UI"]["Loading"].loader.size)*0.5)


------------------------------
--[[ Function: Renders UI ]]--
------------------------------

loadingUI.renderUI = function()
    local isVisible = false
    if ((loadingUI.animStatus == "forward") or (loadingUI.animStatus == "reverse_backward")) then
        isVisible = true
        if loadingUI.fadeAnimPercent < 1 then
            loadingUI.fadeAnimPercent = imports.interpolateBetween(loadingUI.fadeAnimPercent, 0, 0, 1, 0, 0, imports.getInterpolationProgress(loadingUI.tickCounter, FRAMEWORK_CONFIGS["UI"]["Loading"].fadeInDuration), "Linear")
        end
        if (loadingUI.animStatus == "reverse_backward") and (imports.math.round(loadingUI.fadeAnimPercent, 2) == 1) then
            if ((CLIENT_CURRENT_TICK - loadingUI.tickCounter) >= (FRAMEWORK_CONFIGS["UI"]["Loading"].fadeInDuration + FRAMEWORK_CONFIGS["UI"]["Loading"].fadeDelayDuration)) then
                loadingUI.animStatus = "backward"
                loadingUI.tickCounter = CLIENT_CURRENT_TICK
            end
        end
    elseif loadingUI.animStatus == "backward" then
        if loadingUI.fadeAnimPercent > 0 then
            isVisible = true
            loadingUI.fadeAnimPercent = imports.interpolateBetween(loadingUI.fadeAnimPercent, 0, 0, 0, 0, 0, imports.getInterpolationProgress(loadingUI.tickCounter, FRAMEWORK_CONFIGS["UI"]["Loading"].fadeOutDuration), "Linear")
        end
    end

    loadingUI.isVisible = isVisible
    if not loadingUI.isVisible then
        return imports.beautify.render.remove(loadingUI.renderUI)
    end
    loadingUI.loader.rotationValue = imports.interpolateBetween(0, 0, 0, 360, 0, 0, imports.getInterpolationProgress(loadingUI.loader.tickCounter, FRAMEWORK_CONFIGS["UI"]["Loading"].loader.animDuration), "Linear")
    if imports.math.round(loadingUI.loader.rotationValue, 2) == 360 then
        loadingUI.loader.tickCounter = CLIENT_CURRENT_TICK
    end
    local cDownloaded, cBandwidth, cProgress = imports.assetify.getProgress()
    imports.beautify.native.drawRectangle(0, 0, CLIENT_MTA_RESOLUTION[1], CLIENT_MTA_RESOLUTION[2], imports.tocolor(FRAMEWORK_CONFIGS["UI"]["Loading"].bgColor[1], FRAMEWORK_CONFIGS["UI"]["Loading"].bgColor[2], FRAMEWORK_CONFIGS["UI"]["Loading"].bgColor[3], FRAMEWORK_CONFIGS["UI"]["Loading"].bgColor[4]*loadingUI.fadeAnimPercent), true)
    imports.beautify.native.drawImage(loadingUI.loader.startX, loadingUI.loader.startY, FRAMEWORK_CONFIGS["UI"]["Loading"].loader.size, FRAMEWORK_CONFIGS["UI"]["Loading"].loader.size, loadingUI.loader.bgTexture, loadingUI.loader.rotationValue, 0, 0, imports.tocolor(FRAMEWORK_CONFIGS["UI"]["Loading"].loader.bgColor[1], FRAMEWORK_CONFIGS["UI"]["Loading"].loader.bgColor[2], FRAMEWORK_CONFIGS["UI"]["Loading"].loader.bgColor[3], FRAMEWORK_CONFIGS["UI"]["Loading"].loader.bgColor[4]*loadingUI.fadeAnimPercent), true)
    imports.beautify.native.drawText(((cProgress < 100) and loadingUI.hint.text.."\n"..cProgress.."%") or loadingUI.hint.text, loadingUI.hint.paddingX, loadingUI.loader.startY + FRAMEWORK_CONFIGS["UI"]["Loading"].loader.size + loadingUI.hint.paddingY, CLIENT_MTA_RESOLUTION[1] - loadingUI.hint.paddingX, CLIENT_MTA_RESOLUTION[2] - loadingUI.hint.paddingY, imports.tocolor(FRAMEWORK_CONFIGS["UI"]["Loading"].hints.fontColor[1], FRAMEWORK_CONFIGS["UI"]["Loading"].hints.fontColor[2], FRAMEWORK_CONFIGS["UI"]["Loading"].hints.fontColor[3], FRAMEWORK_CONFIGS["UI"]["Loading"].hints.fontColor[4]*loadingUI.fadeAnimPercent), 1, loadingUI.hint.font.instance, "center", "top", true, true, true)
end


--------------------------------------
--[[ Client: On Toggle Loading UI ]]--
--------------------------------------

imports.addEvent("Client:onToggleLoadingUI", true)
imports.addEventHandler("Client:onToggleLoadingUI", root, function(state, hint)
    if state then
        if (state and (loadingUI.animStatus == "forward")) then return false end
        loadingUI.animStatus = "forward"
        loadingUI.hint.text = (hint and hint[(CPlayer.CLanguage)]) or (FRAMEWORK_CONFIGS["UI"]["Loading"].hints[(imports.math.random(#FRAMEWORK_CONFIGS["UI"]["Loading"].hints))][(CPlayer.CLanguage)]) or loadingUI.hint.text
    else
        if ((loadingUI.animStatus == "backward") or (loadingUI.animStatus == "reverse_backward")) then return false end
        loadingUI.animStatus = "reverse_backward"
    end
    loadingUI.tickCounter = CLIENT_CURRENT_TICK
    loadingUI.loader.tickCounter = CLIENT_CURRENT_TICK
    if state and not loadingUI.isVisible then
        imports.beautify.render.create(loadingUI.renderUI)
    end
end)