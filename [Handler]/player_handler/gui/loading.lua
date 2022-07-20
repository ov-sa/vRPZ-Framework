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
    interpolateBetween = interpolateBetween,
    getInterpolationProgress = getInterpolationProgress,
    math = math,
    beautify = beautify,
    assetify = assetify
}


-------------------
--[[ Namespace ]]--
-------------------

local loadingUI = assetify.namespace:create("loadingUI")
CGame.execOnModuleLoad(function()
loadingUI.private.animStatus = "backward"
loadingUI.private.fadeAnimPercent = 0
loadingUI.private.tickCounter = CLIENT_CURRENT_TICK
loadingUI.private.loader = {
    startX = 0, startY = (CLIENT_MTA_RESOLUTION[2]/768)*-15,
    tickCounter = CLIENT_CURRENT_TICK,
    bgTexture = imports.assetify.getAssetDep("module", "vRPZ_HUD", "texture", "loader:icon")
}
loadingUI.private.hint = {
    paddingX = 5, paddingY = 15,
    text = "",
    font = CGame.createFont(1, 23)
}
loadingUI.private.loader.startX = loadingUI.private.loader.startX + ((CLIENT_MTA_RESOLUTION[1] - FRAMEWORK_CONFIGS["UI"]["Loading"].loader.size)*0.5)
loadingUI.private.loader.startY = loadingUI.private.loader.startY + ((CLIENT_MTA_RESOLUTION[2] - FRAMEWORK_CONFIGS["UI"]["Loading"].loader.size)*0.5)


------------------------------
--[[ Function: Renders UI ]]--
------------------------------

loadingUI.private.renderUI = function()
    local isVisible = false
    if ((loadingUI.private.animStatus == "forward") or (loadingUI.private.animStatus == "reverse_backward")) then
        isVisible = true
        if loadingUI.private.fadeAnimPercent < 1 then
            loadingUI.private.fadeAnimPercent = imports.interpolateBetween(loadingUI.private.fadeAnimPercent, 0, 0, 1, 0, 0, imports.getInterpolationProgress(loadingUI.private.tickCounter, FRAMEWORK_CONFIGS["UI"]["Loading"].fadeInDuration), "Linear")
        end
        if (loadingUI.private.animStatus == "reverse_backward") and (imports.math.round(loadingUI.private.fadeAnimPercent, 2) == 1) then
            if ((CLIENT_CURRENT_TICK - loadingUI.private.tickCounter) >= (FRAMEWORK_CONFIGS["UI"]["Loading"].fadeInDuration + FRAMEWORK_CONFIGS["UI"]["Loading"].fadeDelayDuration)) then
                loadingUI.private.animStatus = "backward"
                loadingUI.private.tickCounter = CLIENT_CURRENT_TICK
            end
        end
    elseif loadingUI.private.animStatus == "backward" then
        if loadingUI.private.fadeAnimPercent > 0 then
            isVisible = true
            loadingUI.private.fadeAnimPercent = imports.interpolateBetween(loadingUI.private.fadeAnimPercent, 0, 0, 0, 0, 0, imports.getInterpolationProgress(loadingUI.private.tickCounter, FRAMEWORK_CONFIGS["UI"]["Loading"].fadeOutDuration), "Linear")
        end
    end

    loadingUI.private.isVisible = isVisible
    if not loadingUI.private.isVisible then
        return imports.beautify.render.remove(loadingUI.private.renderUI)
    end
    loadingUI.private.loader.rotationValue = imports.interpolateBetween(0, 0, 0, 360, 0, 0, imports.getInterpolationProgress(loadingUI.private.loader.tickCounter, FRAMEWORK_CONFIGS["UI"]["Loading"].loader.animDuration), "Linear")
    if imports.math.round(loadingUI.private.loader.rotationValue, 2) == 360 then
        loadingUI.private.loader.tickCounter = CLIENT_CURRENT_TICK
    end
    local cDownloaded, _, cProgress, cETA = imports.assetify.getDownloadProgress()
    cProgress = imports.math.floor(cProgress)
    local hintText = loadingUI.private.hint.text
    if cProgress < 100 then
        hintText = hintText.."\n"..cProgress.."%"
        hintText = hintText.."\n"..((cETA and CGame.formatMS(cETA)) or "")
    end
    imports.beautify.native.drawRectangle(0, 0, CLIENT_MTA_RESOLUTION[1], CLIENT_MTA_RESOLUTION[2], imports.tocolor(FRAMEWORK_CONFIGS["UI"]["Loading"].bgColor[1], FRAMEWORK_CONFIGS["UI"]["Loading"].bgColor[2], FRAMEWORK_CONFIGS["UI"]["Loading"].bgColor[3], FRAMEWORK_CONFIGS["UI"]["Loading"].bgColor[4]*loadingUI.private.fadeAnimPercent), true)
    imports.beautify.native.drawImage(loadingUI.private.loader.startX, loadingUI.private.loader.startY, FRAMEWORK_CONFIGS["UI"]["Loading"].loader.size, FRAMEWORK_CONFIGS["UI"]["Loading"].loader.size, loadingUI.private.loader.bgTexture, loadingUI.private.loader.rotationValue, 0, 0, imports.tocolor(FRAMEWORK_CONFIGS["UI"]["Loading"].loader.bgColor[1], FRAMEWORK_CONFIGS["UI"]["Loading"].loader.bgColor[2], FRAMEWORK_CONFIGS["UI"]["Loading"].loader.bgColor[3], FRAMEWORK_CONFIGS["UI"]["Loading"].loader.bgColor[4]*loadingUI.private.fadeAnimPercent), true)
    imports.beautify.native.drawText(hintText, loadingUI.private.hint.paddingX, loadingUI.private.loader.startY + FRAMEWORK_CONFIGS["UI"]["Loading"].loader.size + loadingUI.private.hint.paddingY, CLIENT_MTA_RESOLUTION[1] - loadingUI.private.hint.paddingX, CLIENT_MTA_RESOLUTION[2] - loadingUI.private.hint.paddingY, imports.tocolor(FRAMEWORK_CONFIGS["UI"]["Loading"].hints.fontColor[1], FRAMEWORK_CONFIGS["UI"]["Loading"].hints.fontColor[2], FRAMEWORK_CONFIGS["UI"]["Loading"].hints.fontColor[3], FRAMEWORK_CONFIGS["UI"]["Loading"].hints.fontColor[4]*loadingUI.private.fadeAnimPercent), 1, loadingUI.private.hint.font.instance, "center", "top", true, true, true)
end


--------------------------------------
--[[ Client: On Toggle Loading UI ]]--
--------------------------------------

imports.assetify.network:create("Client:onToggleLoadingUI"):on(function(state, hint)
    if state then
        if (state and (loadingUI.private.animStatus == "forward")) then return false end
        loadingUI.private.animStatus = "forward"
        loadingUI.private.hint.text = (hint and hint[(CPlayer.CLanguage)]) or (FRAMEWORK_CONFIGS["UI"]["Loading"].hints[(imports.math.random(#FRAMEWORK_CONFIGS["UI"]["Loading"].hints))][(CPlayer.CLanguage)]) or loadingUI.private.hint.text
    else
        if ((loadingUI.private.animStatus == "backward") or (loadingUI.private.animStatus == "reverse_backward")) then return false end
        loadingUI.private.animStatus = "reverse_backward"
    end
    loadingUI.private.tickCounter = CLIENT_CURRENT_TICK
    loadingUI.private.loader.tickCounter = CLIENT_CURRENT_TICK
    if state and not loadingUI.private.isVisible then
        imports.beautify.render.create(loadingUI.private.renderUI)
    end
end)
end)