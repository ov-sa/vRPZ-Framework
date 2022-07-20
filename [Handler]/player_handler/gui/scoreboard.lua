----------------------------------------------------------------
--[[ Resource: Player Handler
     Script: gui: scoreboard.lua
     Author: vStudio
     Developer(s): Mario, Tron, Aviril, Аниса
     DOC: 31/01/2022
     Desc: Scoreboard UI Handler ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local imports = {
    pairs = pairs,
    tocolor = tocolor,
    unpackColor = unpackColor,
    isElement = isElement,
    destroyElement = destroyElement,
    getPlayerPing = getPlayerPing,
    interpolateBetween = interpolateBetween,
    getInterpolationProgress = getInterpolationProgress,
    bindKey = bindKey,
    isMouseScrolled = isMouseScrolled,
    isMouseOnPosition = isMouseOnPosition,
    showChat = showChat,
    showCursor = showCursor,
    string = string,
    math = math,
    beautify = beautify
}


-------------------
--[[ Namespace ]]--
-------------------

local scoreboardUI = assetify.namespace:create("scoreboardUI")
CGame.execOnModuleLoad(function()
scoreboardUI.private.cache = {keys = {scroll = {}}}
scoreboardUI.private.buffer = {}
scoreboardUI.private.margin = 10
scoreboardUI.private.animStatus = "backward"
scoreboardUI.private.bgColor = imports.tocolor(imports.unpackColor(FRAMEWORK_CONFIGS["UI"]["Scoreboard"].bgColor))
scoreboardUI.private.banner = {
    font = CGame.createFont(1, 18, true), counterFont = CGame.createFont(1, 16, true), fontColor = imports.tocolor(imports.unpackColor(FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Banner"].fontColor)),
    bgColor = imports.tocolor(imports.unpackColor(FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Banner"].bgColor)), dividerColor = imports.tocolor(imports.unpackColor(FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Banner"].dividerColor))
}
scoreboardUI.private.columns = {
    font = CGame.createFont(1, 17), fontColor = imports.tocolor(imports.unpackColor(FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Columns"].fontColor)),
    bgColor = imports.tocolor(imports.unpackColor(FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Columns"].bgColor)), dividerColor = imports.tocolor(imports.unpackColor(FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Columns"].dividerColor)),
    data = {
        font = CGame.createFont(1, 17, true), fontColor = imports.tocolor(imports.unpackColor(FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Columns"].data.fontColor)),
        bgColor = imports.tocolor(imports.unpackColor(FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Columns"].data.bgColor))
    }
}
scoreboardUI.private.scroller = {
    percent = 0, animPercent = 0,
    bgColor = imports.tocolor(imports.unpackColor(FRAMEWORK_CONFIGS["UI"]["Scoreboard"].scroller.bgColor)), thumbColor = imports.tocolor(imports.unpackColor(FRAMEWORK_CONFIGS["UI"]["Scoreboard"].scroller.thumbColor))
}
scoreboardUI.private.startX = ((CLIENT_MTA_RESOLUTION[1] - FRAMEWORK_CONFIGS["UI"]["Scoreboard"].width)*0.5)
scoreboardUI.private.startY = FRAMEWORK_CONFIGS["UI"]["Scoreboard"].marginY + ((CLIENT_MTA_RESOLUTION[2] - (FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Banner"].height + FRAMEWORK_CONFIGS["UI"]["Scoreboard"].height))*0.5)

scoreboardUI.private.createBGTexture = function()
    if CLIENT_MTA_MINIMIZED then return false end
    scoreboardUI.private.bgRT = imports.beautify.native.createRenderTarget(FRAMEWORK_CONFIGS["UI"]["Scoreboard"].width, FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Banner"].height + FRAMEWORK_CONFIGS["UI"]["Scoreboard"].height, true)
    imports.beautify.native.setRenderTarget(scoreboardUI.private.bgRT, true)
    imports.beautify.native.drawRectangle(0, 0, FRAMEWORK_CONFIGS["UI"]["Scoreboard"].width, FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Banner"].height, scoreboardUI.private.banner.bgColor, false)
    imports.beautify.native.drawRectangle(0, FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Banner"].height, FRAMEWORK_CONFIGS["UI"]["Scoreboard"].width, FRAMEWORK_CONFIGS["UI"]["Scoreboard"].height, scoreboardUI.private.bgColor, false)
    imports.beautify.native.drawRectangle(0, FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Banner"].height, FRAMEWORK_CONFIGS["UI"]["Scoreboard"].width, FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Columns"].height, scoreboardUI.private.columns.bgColor, false)
    imports.beautify.native.drawRectangle(0, FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Banner"].height + FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Columns"].height, FRAMEWORK_CONFIGS["UI"]["Scoreboard"].width, FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Banner"].dividerSize, scoreboardUI.private.banner.dividerColor, false)        
    imports.beautify.native.setRenderTarget()
    local rtPixels = imports.beautify.native.getTexturePixels(scoreboardUI.private.bgRT)
    if rtPixels then
        scoreboardUI.private.bgTexture = imports.beautify.native.createTexture(rtPixels, "dxt5", false, "clamp")
        imports.destroyElement(scoreboardUI.private.bgRT)
        scoreboardUI.private.bgRT = nil
    end
    scoreboardUI.private.columnRT = imports.beautify.native.createRenderTarget(FRAMEWORK_CONFIGS["UI"]["Scoreboard"].width, FRAMEWORK_CONFIGS["UI"]["Scoreboard"].height - FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Columns"].height, true)
    scoreboardUI.private.rowRT = imports.beautify.native.createRenderTarget(FRAMEWORK_CONFIGS["UI"]["Scoreboard"].width, FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Columns"].height, true)
    imports.beautify.native.setRenderTarget(scoreboardUI.private.columnRT, true)
    for i = 1, #FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Columns"], 1 do
        local j = FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Columns"][i]
        j.startX = (FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Columns"][(i - 1)] and FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Columns"][(i - 1)].endX) or FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Columns"].dividerSize
        j.endX = j.startX + j.width + FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Columns"].dividerSize
        imports.beautify.native.drawRectangle(j.endX - FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Columns"].dividerSize, scoreboardUI.private.margin*0.5, FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Columns"].dividerSize, FRAMEWORK_CONFIGS["UI"]["Scoreboard"].height - FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Columns"].height - scoreboardUI.private.margin, scoreboardUI.private.columns.dividerColor, false)
    end
    imports.beautify.native.setRenderTarget(scoreboardUI.private.rowRT, true)
    for i = 1, #FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Columns"], 1 do
        local j = FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Columns"][i]
        imports.beautify.native.drawRectangle(j.startX, 0, j.width, FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Columns"].height, -1, false)
    end
    imports.beautify.native.setRenderTarget()
    local rtPixels = imports.beautify.native.getTexturePixels(scoreboardUI.private.columnRT)
    if rtPixels then
        scoreboardUI.private.columnTexture = imports.beautify.native.createTexture(rtPixels, "dxt5", false, "clamp")
        imports.destroyElement(scoreboardUI.private.columnRT)
        scoreboardUI.private.columnRT = nil
    end
    local rtPixels = imports.beautify.native.getTexturePixels(scoreboardUI.private.rowRT)
    if rtPixels then
        scoreboardUI.private.rowTexture = imports.beautify.native.createTexture(rtPixels, "dxt5", false, "clamp")
        imports.destroyElement(scoreboardUI.private.rowRT)
        scoreboardUI.private.rowRT = nil
    end
    return true
end

scoreboardUI.private.updateBuffer = function()
    local bufferCount = 0
    for i, j in imports.pairs(CPlayer.CLogged) do
        bufferCount = bufferCount + 1
        scoreboardUI.private.buffer[bufferCount] = scoreboardUI.private.buffer[bufferCount] or {}
        scoreboardUI.private.buffer[bufferCount].name = CPlayer.getName(i)
        scoreboardUI.private.buffer[bufferCount].level = CCharacter.getLevel(i)
        scoreboardUI.private.buffer[bufferCount].reputation = CCharacter.getReputation(i)
        scoreboardUI.private.buffer[bufferCount].faction = CCharacter.getFaction(i)
        scoreboardUI.private.buffer[bufferCount].group = CCharacter.getGroup(i)
        scoreboardUI.private.buffer[bufferCount].kd = CCharacter.getKD(i)
        scoreboardUI.private.buffer[bufferCount].ping = imports.getPlayerPing(i)
        local _, rank = CCharacter.getRank(i)
        scoreboardUI.private.buffer[bufferCount].rank = (rank and rank.name) or rank
        scoreboardUI.private.buffer[bufferCount].reputation = (scoreboardUI.private.buffer[bufferCount].reputation and imports.math.round(scoreboardUI.private.buffer[bufferCount].reputation, 2)) or scoreboardUI.private.buffer[bufferCount].reputation
        scoreboardUI.private.buffer[bufferCount].kd = (scoreboardUI.private.buffer[bufferCount].kd and imports.math.round(scoreboardUI.private.buffer[bufferCount].kd, 2)) or scoreboardUI.private.buffer[bufferCount].kd
        scoreboardUI.private.buffer[bufferCount].survival_time = CCharacter.getSurvivalTime(i)
        scoreboardUI.private.buffer[bufferCount].survival_time = (scoreboardUI.private.buffer[bufferCount].survival_time and CGame.formatMS(scoreboardUI.private.buffer[bufferCount].survival_time)) or scoreboardUI.private.buffer[bufferCount].survival_time
    end
    return bufferCount
end


------------------------------
--[[ Function: Renders UI ]]--
------------------------------

scoreboardUI.private.renderUI = function(renderData)
    if not scoreboardUI.private.state or not CPlayer.isInitialized(localPlayer) then return false end

    if renderData.renderType == "input" then
        scoreboardUI.private.cache.keys.scroll.state, scoreboardUI.private.cache.keys.scroll.streak = imports.isMouseScrolled()
    elseif renderData.renderType == "render" then
        if not scoreboardUI.private.bgTexture then scoreboardUI.private.createBGTexture() end
        local isScoreboardHovered = false
        local bufferCount = scoreboardUI.private.updateBuffer()
        local startX, startY = scoreboardUI.private.startX, scoreboardUI.private.startY
        local view_height = FRAMEWORK_CONFIGS["UI"]["Scoreboard"].height - FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Columns"].height
        local row_height = FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Columns"].height + (scoreboardUI.private.margin*0.5)
        local view_overflowHeight = imports.math.max(0, (scoreboardUI.private.margin*0.5) + (row_height*bufferCount) - view_height)
        local offsetY = view_overflowHeight*scoreboardUI.private.scroller.animPercent*0.01
        local row_startIndex = imports.math.floor(offsetY/row_height) + 1
        local row_endIndex = imports.math.min(bufferCount, row_startIndex + imports.math.ceil(view_height/row_height))
        imports.beautify.native.drawImage(startX, startY, FRAMEWORK_CONFIGS["UI"]["Scoreboard"].width, FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Banner"].height + FRAMEWORK_CONFIGS["UI"]["Scoreboard"].height, scoreboardUI.private.bgTexture, 0, 0, 0, -1, false)    
        imports.beautify.native.drawText(FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Banner"].title, startX + scoreboardUI.private.margin, startY, startX + FRAMEWORK_CONFIGS["UI"]["Scoreboard"].width - scoreboardUI.private.margin, startY + FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Banner"].height, scoreboardUI.private.banner.fontColor, 1, scoreboardUI.private.banner.font.instance, "left", "center", true, false, false, true)
        imports.beautify.native.drawText(imports.string.kern((bufferCount).."/"..FRAMEWORK_CONFIGS["Game"]["Player_Limit"]), startX + scoreboardUI.private.margin, startY, startX + FRAMEWORK_CONFIGS["UI"]["Scoreboard"].width - scoreboardUI.private.margin, startY + FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Banner"].height, scoreboardUI.private.banner.fontColor, 1, scoreboardUI.private.banner.counterFont.instance, "right", "center", true, false, false)
        startY = startY + FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Banner"].height
        imports.beautify.native.setRenderTarget(scoreboardUI.private.viewRT, true)
        for i = row_startIndex, row_endIndex, 1 do
            local j = scoreboardUI.private.buffer[i]
            local column_startY = (scoreboardUI.private.margin*0.5) + (row_height*(i - 1)) - offsetY
            local isRowHovered = imports.isMouseOnPosition(startX, startY + FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Columns"].height + column_startY, FRAMEWORK_CONFIGS["UI"]["Scoreboard"].width, FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Columns"].height)
            if isRowHovered then
                if j.hoverStatus ~= "forward" then
                    j.hoverStatus = "forward"
                    j.hoverAnimTick = CLIENT_CURRENT_TICK
                end
                isScoreboardHovered = true
            else
                if j.hoverStatus ~= "backward" then
                    j.hoverStatus = "backward"
                    j.hoverAnimTick = CLIENT_CURRENT_TICK
                end
            end
            j.animAlphaPercent = j.animAlphaPercent or 0
            local isAnimationVisible, isAnimationFullyRendered = false, false
            if j.hoverStatus == "forward" then
                isAnimationVisible = true
                if j.animAlphaPercent < 1 then
                    j.animAlphaPercent = imports.interpolateBetween(j.animAlphaPercent, 0, 0, 1, 0, 0, imports.getInterpolationProgress(j.hoverAnimTick, FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Columns"].data.hoverDuration), "Linear")
                else
                    isAnimationFullyRendered = true
                end
            else
                if j.animAlphaPercent > 0 then
                    isAnimationVisible = true
                    j.animAlphaPercent = imports.interpolateBetween(j.animAlphaPercent, 0, 0, 0, 0, 0, imports.getInterpolationProgress(j.hoverAnimTick, FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Columns"].data.hoverDuration), "Linear")
                end
            end
            if not isAnimationFullyRendered then
                imports.beautify.native.drawImage(0, column_startY, FRAMEWORK_CONFIGS["UI"]["Scoreboard"].width, FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Columns"].height, scoreboardUI.private.rowTexture, 0, 0, 0, scoreboardUI.private.columns.data.bgColor, false)
            end
            if isAnimationVisible then
                imports.beautify.native.drawImage(0, column_startY, FRAMEWORK_CONFIGS["UI"]["Scoreboard"].width, FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Columns"].height, scoreboardUI.private.rowTexture, 0, 0, 0, imports.tocolor(FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Columns"].data.hoverBGColor[1], FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Columns"].data.hoverBGColor[2], FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Columns"].data.hoverBGColor[3], FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Columns"].data.hoverBGColor[4]*j.animAlphaPercent), false)
            end
            for k = 1, #FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Columns"], 1 do
                local v = FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Columns"][k]
                if not isAnimationFullyRendered then
                    imports.beautify.native.drawText(((v.dataType == "serial_number") and i) or j[(v.dataType)] or "-", v.startX, column_startY, v.startX + v.width, column_startY + FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Columns"].height, scoreboardUI.private.columns.data.fontColor, 1, scoreboardUI.private.columns.data.font.instance, "center", "center", true, false, false)
                end
                if isAnimationVisible then
                    imports.beautify.native.drawText(((v.dataType == "serial_number") and i) or j[(v.dataType)] or "-", v.startX, column_startY, v.startX + v.width, column_startY + FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Columns"].height, imports.tocolor(FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Columns"].data.hoverFontColor[1], FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Columns"].data.hoverFontColor[2], FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Columns"].data.hoverFontColor[3], FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Columns"].data.hoverFontColor[4]*j.animAlphaPercent), 1, scoreboardUI.private.columns.data.font.instance, "center", "center", true, false, false)
                end
            end
        end
        imports.beautify.native.setRenderTarget()
        for i = 1, #FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Columns"], 1 do
            local j = FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Columns"][i]
            imports.beautify.native.drawText(j["Title"][(CPlayer.CLanguage)], startX + j.startX, startY, startX + j.endX, startY + FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Columns"].height, scoreboardUI.private.columns.fontColor, 1, scoreboardUI.private.columns.font.instance, "center", "center", true, false, false)
        end
        imports.beautify.native.drawImage(startX, startY + FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Columns"].height, FRAMEWORK_CONFIGS["UI"]["Scoreboard"].width, view_height, scoreboardUI.private.viewRT, 0, 0, 0, -1, false)
        imports.beautify.native.drawImage(startX, startY + FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Columns"].height, FRAMEWORK_CONFIGS["UI"]["Scoreboard"].width, view_height, scoreboardUI.private.columnTexture, 0, 0, 0, -1, false)
        if view_overflowHeight > 0 then
            if not scoreboardUI.private.scroller.isPositioned then
                scoreboardUI.private.scroller.startX, scoreboardUI.private.scroller.startY = FRAMEWORK_CONFIGS["UI"]["Scoreboard"].width - FRAMEWORK_CONFIGS["UI"]["Scoreboard"].scroller.width, FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Columns"].height
                scoreboardUI.private.scroller.height = view_height
                scoreboardUI.private.scroller.isPositioned = true
            end
            if imports.math.round(scoreboardUI.private.scroller.animPercent, 2) ~= imports.math.round(scoreboardUI.private.scroller.percent, 2) then
                scoreboardUI.private.scroller.animPercent = imports.interpolateBetween(scoreboardUI.private.scroller.animPercent, 0, 0, scoreboardUI.private.scroller.percent, 0, 0, 0.5, "InQuad")
            end
            imports.beautify.native.drawRectangle(startX + scoreboardUI.private.scroller.startX, startY + scoreboardUI.private.scroller.startY, FRAMEWORK_CONFIGS["UI"]["Scoreboard"].scroller.width, scoreboardUI.private.scroller.height, scoreboardUI.private.scroller.bgColor, false)
            imports.beautify.native.drawRectangle(startX + scoreboardUI.private.scroller.startX, startY + scoreboardUI.private.scroller.startY + ((scoreboardUI.private.scroller.height - FRAMEWORK_CONFIGS["UI"]["Scoreboard"].scroller.thumbHeight)*scoreboardUI.private.scroller.animPercent*0.01), FRAMEWORK_CONFIGS["UI"]["Scoreboard"].scroller.width, FRAMEWORK_CONFIGS["UI"]["Scoreboard"].scroller.thumbHeight, scoreboardUI.private.scroller.thumbColor, false)
            isScoreboardHovered = isScoreboardHovered or imports.isMouseOnPosition(startX, startY + FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Columns"].height, FRAMEWORK_CONFIGS["UI"]["Scoreboard"].width, view_height)
            if scoreboardUI.private.cache.keys.scroll.state and isScoreboardHovered then
                local scrollPercent = imports.math.max(1, 100/(view_overflowHeight/row_height))
                scoreboardUI.private.scroller.percent = imports.math.max(0, imports.math.min(scoreboardUI.private.scroller.percent + (scrollPercent*imports.math.max(1, scoreboardUI.private.cache.keys.scroll.streak)*(((scoreboardUI.private.cache.keys.scroll.state == "down") and 1) or -1)), 100))
                scoreboardUI.private.cache.keys.scroll.state = false
            end
        end
    end
end


-------------------------------
--[[ Functions: UI Helpers ]]--
-------------------------------

function scoreboardUI.public:isVisible() return scoreboardUI.private.state end


------------------------------
--[[ Function: Toggles UI ]]--
------------------------------

scoreboardUI.private.toggleUI = function(state)
    if not CPlayer.isInitialized(localPlayer) then return false end
    if (((state ~= true) and (state ~= false)) or (state == scoreboardUI.private.state)) or (state and (not CPlayer.isInitialized(localPlayer) or CGame.isUIVisible())) then return false end

    if state then
        imports.beautify.render.create(scoreboardUI.private.renderUI)
        imports.beautify.render.create(scoreboardUI.private.renderUI, {renderType = "input"})
        scoreboardUI.private.viewRT = imports.beautify.native.createRenderTarget(FRAMEWORK_CONFIGS["UI"]["Scoreboard"].width, FRAMEWORK_CONFIGS["UI"]["Scoreboard"].height - FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Columns"].height, true)
    else
        imports.beautify.render.remove(scoreboardUI.private.renderUI)
        imports.beautify.render.remove(scoreboardUI.private.renderUI, {renderType = "input"})
        if scoreboardUI.private.viewRT and imports.isElement(scoreboardUI.private.viewRT) then
            imports.destroyElement(scoreboardUI.private.viewRT)
            scoreboardUI.private.viewRT = nil
        end
    end
    scoreboardUI.private.state = state
    imports.showChat(not state)
    imports.showCursor(state)
    return true
end
imports.bindKey(FRAMEWORK_CONFIGS["UI"]["Scoreboard"].toggleKey, "down", function() scoreboardUI.private.toggleUI(not scoreboardUI.private.state) end)
end)