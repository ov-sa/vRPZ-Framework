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


CGame.execOnModuleLoad(function()
    -------------------
    --[[ Variables ]]--
    -------------------

    local scoreboardUI = {
        cache = {keys = {scroll = {}}},
        buffer = {},
        margin = 10,
        animStatus = "backward",
        bgColor = imports.tocolor(imports.unpackColor(FRAMEWORK_CONFIGS["UI"]["Scoreboard"].bgColor)),
        banner = {
            font = CGame.createFont(1, 18, true), counterFont = CGame.createFont(1, 16, true), fontColor = imports.tocolor(imports.unpackColor(FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Banner"].fontColor)),
            bgColor = imports.tocolor(imports.unpackColor(FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Banner"].bgColor)), dividerColor = imports.tocolor(imports.unpackColor(FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Banner"].dividerColor))
        },
        columns = {
            font = CGame.createFont(1, 17), fontColor = imports.tocolor(imports.unpackColor(FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Columns"].fontColor)),
            bgColor = imports.tocolor(imports.unpackColor(FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Columns"].bgColor)), dividerColor = imports.tocolor(imports.unpackColor(FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Columns"].dividerColor)),
            data = {
                font = CGame.createFont(1, 17, true), fontColor = imports.tocolor(imports.unpackColor(FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Columns"].data.fontColor)),
                bgColor = imports.tocolor(imports.unpackColor(FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Columns"].data.bgColor))
            }
        },
        scroller = {
            percent = 0, animPercent = 0,
            bgColor = imports.tocolor(imports.unpackColor(FRAMEWORK_CONFIGS["UI"]["Scoreboard"].scroller.bgColor)), thumbColor = imports.tocolor(imports.unpackColor(FRAMEWORK_CONFIGS["UI"]["Scoreboard"].scroller.thumbColor))
        }
    }

    scoreboardUI.startX = ((CLIENT_MTA_RESOLUTION[1] - FRAMEWORK_CONFIGS["UI"]["Scoreboard"].width)*0.5)
    scoreboardUI.startY = FRAMEWORK_CONFIGS["UI"]["Scoreboard"].marginY + ((CLIENT_MTA_RESOLUTION[2] - (FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Banner"].height + FRAMEWORK_CONFIGS["UI"]["Scoreboard"].height))*0.5)
    
    scoreboardUI.createBGTexture = function()
        if CLIENT_MTA_MINIMIZED then return false end
        scoreboardUI.bgRT = imports.beautify.native.createRenderTarget(FRAMEWORK_CONFIGS["UI"]["Scoreboard"].width, FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Banner"].height + FRAMEWORK_CONFIGS["UI"]["Scoreboard"].height, true)
        imports.beautify.native.setRenderTarget(scoreboardUI.bgRT, true)
        imports.beautify.native.drawRectangle(0, 0, FRAMEWORK_CONFIGS["UI"]["Scoreboard"].width, FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Banner"].height, scoreboardUI.banner.bgColor, false)
        imports.beautify.native.drawRectangle(0, FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Banner"].height, FRAMEWORK_CONFIGS["UI"]["Scoreboard"].width, FRAMEWORK_CONFIGS["UI"]["Scoreboard"].height, scoreboardUI.bgColor, false)
        imports.beautify.native.drawRectangle(0, FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Banner"].height, FRAMEWORK_CONFIGS["UI"]["Scoreboard"].width, FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Columns"].height, scoreboardUI.columns.bgColor, false)
        imports.beautify.native.drawRectangle(0, FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Banner"].height + FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Columns"].height, FRAMEWORK_CONFIGS["UI"]["Scoreboard"].width, FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Banner"].dividerSize, scoreboardUI.banner.dividerColor, false)        
        imports.beautify.native.setRenderTarget()
        local rtPixels = imports.beautify.native.getTexturePixels(scoreboardUI.bgRT)
        if rtPixels then
            scoreboardUI.bgTexture = imports.beautify.native.createTexture(rtPixels, "dxt5", false, "clamp")
            imports.destroyElement(scoreboardUI.bgRT)
            scoreboardUI.bgRT = nil
        end
        scoreboardUI.columnRT = imports.beautify.native.createRenderTarget(FRAMEWORK_CONFIGS["UI"]["Scoreboard"].width, FRAMEWORK_CONFIGS["UI"]["Scoreboard"].height - FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Columns"].height, true)
        scoreboardUI.rowRT = imports.beautify.native.createRenderTarget(FRAMEWORK_CONFIGS["UI"]["Scoreboard"].width, FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Columns"].height, true)
        imports.beautify.native.setRenderTarget(scoreboardUI.columnRT, true)
        for i = 1, #FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Columns"], 1 do
            local j = FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Columns"][i]
            j.startX = (FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Columns"][(i - 1)] and FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Columns"][(i - 1)].endX) or FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Columns"].dividerSize
            j.endX = j.startX + j.width + FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Columns"].dividerSize
            imports.beautify.native.drawRectangle(j.endX - FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Columns"].dividerSize, scoreboardUI.margin*0.5, FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Columns"].dividerSize, FRAMEWORK_CONFIGS["UI"]["Scoreboard"].height - FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Columns"].height - scoreboardUI.margin, scoreboardUI.columns.dividerColor, false)
        end
        imports.beautify.native.setRenderTarget(scoreboardUI.rowRT, true)
        for i = 1, #FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Columns"], 1 do
            local j = FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Columns"][i]
            imports.beautify.native.drawRectangle(j.startX, 0, j.width, FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Columns"].height, -1, false)
        end
        imports.beautify.native.setRenderTarget()
        local rtPixels = imports.beautify.native.getTexturePixels(scoreboardUI.columnRT)
        if rtPixels then
            scoreboardUI.columnTexture = imports.beautify.native.createTexture(rtPixels, "dxt5", false, "clamp")
            imports.destroyElement(scoreboardUI.columnRT)
            scoreboardUI.columnRT = nil
        end
        local rtPixels = imports.beautify.native.getTexturePixels(scoreboardUI.rowRT)
        if rtPixels then
            scoreboardUI.rowTexture = imports.beautify.native.createTexture(rtPixels, "dxt5", false, "clamp")
            imports.destroyElement(scoreboardUI.rowRT)
            scoreboardUI.rowRT = nil
        end
        return true
    end

    scoreboardUI.updateBuffer = function()
        local bufferCount = 0
        for i, j in imports.pairs(CPlayer.CLogged) do
            bufferCount = bufferCount + 1
            scoreboardUI.buffer[bufferCount] = scoreboardUI.buffer[bufferCount] or {}
            scoreboardUI.buffer[bufferCount].name = CPlayer.getName(i)
            scoreboardUI.buffer[bufferCount].level = CCharacter.getLevel(i)
            scoreboardUI.buffer[bufferCount].reputation = CCharacter.getReputation(i)
            scoreboardUI.buffer[bufferCount].faction = CCharacter.getFaction(i)
            scoreboardUI.buffer[bufferCount].group = CCharacter.getGroup(i)
            scoreboardUI.buffer[bufferCount].kd = CCharacter.getKD(i)
            scoreboardUI.buffer[bufferCount].ping = imports.getPlayerPing(i)
            local _, rank = CCharacter.getRank(i)
            scoreboardUI.buffer[bufferCount].rank = (rank and rank.name) or rank
            scoreboardUI.buffer[bufferCount].reputation = (scoreboardUI.buffer[bufferCount].reputation and imports.math.round(scoreboardUI.buffer[bufferCount].reputation, 2)) or scoreboardUI.buffer[bufferCount].reputation
            scoreboardUI.buffer[bufferCount].kd = (scoreboardUI.buffer[bufferCount].kd and imports.math.round(scoreboardUI.buffer[bufferCount].kd, 2)) or scoreboardUI.buffer[bufferCount].kd
            scoreboardUI.buffer[bufferCount].survival_time = CCharacter.getSurvivalTime(i)
            scoreboardUI.buffer[bufferCount].survival_time = (scoreboardUI.buffer[bufferCount].survival_time and CGame.formatMS(scoreboardUI.buffer[bufferCount].survival_time)) or scoreboardUI.buffer[bufferCount].survival_time
        end
        return bufferCount
    end
    

    ------------------------------
    --[[ Function: Renders UI ]]--
    ------------------------------

    scoreboardUI.renderUI = function(renderData)
        if not scoreboardUI.state or not CPlayer.isInitialized(localPlayer) then return false end

        if renderData.renderType == "input" then
            scoreboardUI.cache.keys.scroll.state, scoreboardUI.cache.keys.scroll.streak = imports.isMouseScrolled()
        elseif renderData.renderType == "render" then
            if not scoreboardUI.bgTexture then scoreboardUI.createBGTexture() end
            local isScoreboardHovered = false
            local bufferCount = scoreboardUI.updateBuffer()
            local startX, startY = scoreboardUI.startX, scoreboardUI.startY
            local view_height = FRAMEWORK_CONFIGS["UI"]["Scoreboard"].height - FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Columns"].height
            local row_height = FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Columns"].height + (scoreboardUI.margin*0.5)
            local view_overflowHeight = imports.math.max(0, (scoreboardUI.margin*0.5) + (row_height*bufferCount) - view_height)
            local offsetY = view_overflowHeight*scoreboardUI.scroller.animPercent*0.01
            local row_startIndex = imports.math.floor(offsetY/row_height) + 1
            local row_endIndex = imports.math.min(bufferCount, row_startIndex + imports.math.ceil(view_height/row_height))
            imports.beautify.native.drawImage(startX, startY, FRAMEWORK_CONFIGS["UI"]["Scoreboard"].width, FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Banner"].height + FRAMEWORK_CONFIGS["UI"]["Scoreboard"].height, scoreboardUI.bgTexture, 0, 0, 0, -1, false)    
            imports.beautify.native.drawText(FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Banner"].title, startX + scoreboardUI.margin, startY, startX + FRAMEWORK_CONFIGS["UI"]["Scoreboard"].width - scoreboardUI.margin, startY + FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Banner"].height, scoreboardUI.banner.fontColor, 1, scoreboardUI.banner.font.instance, "left", "center", true, false, false, true)
            imports.beautify.native.drawText(imports.string:kern((bufferCount).."/"..FRAMEWORK_CONFIGS["Game"]["Player_Limit"]), startX + scoreboardUI.margin, startY, startX + FRAMEWORK_CONFIGS["UI"]["Scoreboard"].width - scoreboardUI.margin, startY + FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Banner"].height, scoreboardUI.banner.fontColor, 1, scoreboardUI.banner.counterFont.instance, "right", "center", true, false, false)
            startY = startY + FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Banner"].height
            imports.beautify.native.setRenderTarget(scoreboardUI.viewRT, true)
            for i = row_startIndex, row_endIndex, 1 do
                local j = scoreboardUI.buffer[i]
                local column_startY = (scoreboardUI.margin*0.5) + (row_height*(i - 1)) - offsetY
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
                    imports.beautify.native.drawImage(0, column_startY, FRAMEWORK_CONFIGS["UI"]["Scoreboard"].width, FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Columns"].height, scoreboardUI.rowTexture, 0, 0, 0, scoreboardUI.columns.data.bgColor, false)
                end
                if isAnimationVisible then
                    imports.beautify.native.drawImage(0, column_startY, FRAMEWORK_CONFIGS["UI"]["Scoreboard"].width, FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Columns"].height, scoreboardUI.rowTexture, 0, 0, 0, imports.tocolor(FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Columns"].data.hoverBGColor[1], FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Columns"].data.hoverBGColor[2], FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Columns"].data.hoverBGColor[3], FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Columns"].data.hoverBGColor[4]*j.animAlphaPercent), false)
                end
                for k = 1, #FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Columns"], 1 do
                    local v = FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Columns"][k]
                    if not isAnimationFullyRendered then
                        imports.beautify.native.drawText(((v.dataType == "serial_number") and i) or j[(v.dataType)] or "-", v.startX, column_startY, v.startX + v.width, column_startY + FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Columns"].height, scoreboardUI.columns.data.fontColor, 1, scoreboardUI.columns.data.font.instance, "center", "center", true, false, false)
                    end
                    if isAnimationVisible then
                        imports.beautify.native.drawText(((v.dataType == "serial_number") and i) or j[(v.dataType)] or "-", v.startX, column_startY, v.startX + v.width, column_startY + FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Columns"].height, imports.tocolor(FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Columns"].data.hoverFontColor[1], FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Columns"].data.hoverFontColor[2], FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Columns"].data.hoverFontColor[3], FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Columns"].data.hoverFontColor[4]*j.animAlphaPercent), 1, scoreboardUI.columns.data.font.instance, "center", "center", true, false, false)
                    end
                end
            end
            imports.beautify.native.setRenderTarget()
            for i = 1, #FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Columns"], 1 do
                local j = FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Columns"][i]
                imports.beautify.native.drawText(j["Title"][(CPlayer.CLanguage)], startX + j.startX, startY, startX + j.endX, startY + FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Columns"].height, scoreboardUI.columns.fontColor, 1, scoreboardUI.columns.font.instance, "center", "center", true, false, false)
            end
            imports.beautify.native.drawImage(startX, startY + FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Columns"].height, FRAMEWORK_CONFIGS["UI"]["Scoreboard"].width, view_height, scoreboardUI.viewRT, 0, 0, 0, -1, false)
            imports.beautify.native.drawImage(startX, startY + FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Columns"].height, FRAMEWORK_CONFIGS["UI"]["Scoreboard"].width, view_height, scoreboardUI.columnTexture, 0, 0, 0, -1, false)
            if view_overflowHeight > 0 then
                if not scoreboardUI.scroller.isPositioned then
                    scoreboardUI.scroller.startX, scoreboardUI.scroller.startY = FRAMEWORK_CONFIGS["UI"]["Scoreboard"].width - FRAMEWORK_CONFIGS["UI"]["Scoreboard"].scroller.width, FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Columns"].height
                    scoreboardUI.scroller.height = view_height
                    scoreboardUI.scroller.isPositioned = true
                end
                if imports.math.round(scoreboardUI.scroller.animPercent, 2) ~= imports.math.round(scoreboardUI.scroller.percent, 2) then
                    scoreboardUI.scroller.animPercent = imports.interpolateBetween(scoreboardUI.scroller.animPercent, 0, 0, scoreboardUI.scroller.percent, 0, 0, 0.5, "InQuad")
                end
                imports.beautify.native.drawRectangle(startX + scoreboardUI.scroller.startX, startY + scoreboardUI.scroller.startY, FRAMEWORK_CONFIGS["UI"]["Scoreboard"].scroller.width, scoreboardUI.scroller.height, scoreboardUI.scroller.bgColor, false)
                imports.beautify.native.drawRectangle(startX + scoreboardUI.scroller.startX, startY + scoreboardUI.scroller.startY + ((scoreboardUI.scroller.height - FRAMEWORK_CONFIGS["UI"]["Scoreboard"].scroller.thumbHeight)*scoreboardUI.scroller.animPercent*0.01), FRAMEWORK_CONFIGS["UI"]["Scoreboard"].scroller.width, FRAMEWORK_CONFIGS["UI"]["Scoreboard"].scroller.thumbHeight, scoreboardUI.scroller.thumbColor, false)
                isScoreboardHovered = isScoreboardHovered or imports.isMouseOnPosition(startX, startY + FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Columns"].height, FRAMEWORK_CONFIGS["UI"]["Scoreboard"].width, view_height)
                if scoreboardUI.cache.keys.scroll.state and isScoreboardHovered then
                    local scrollPercent = imports.math.max(1, 100/(view_overflowHeight/row_height))
                    scoreboardUI.scroller.percent = imports.math.max(0, imports.math.min(scoreboardUI.scroller.percent + (scrollPercent*imports.math.max(1, scoreboardUI.cache.keys.scroll.streak)*(((scoreboardUI.cache.keys.scroll.state == "down") and 1) or -1)), 100))
                    scoreboardUI.cache.keys.scroll.state = false
                end
            end
        end
    end


    -------------------------------
    --[[ Functions: UI Helpers ]]--
    -------------------------------

    function isScoreboardUIVisible() return scoreboardUI.state end


    ------------------------------
    --[[ Function: Toggles UI ]]--
    ------------------------------

    scoreboardUI.toggleUI = function(state)
        if not CPlayer.isInitialized(localPlayer) then return false end
        if (((state ~= true) and (state ~= false)) or (state == scoreboardUI.state)) or (state and (not CPlayer.isInitialized(localPlayer) or CGame.isUIVisible())) then return false end

        if state then
            imports.beautify.render.create(scoreboardUI.renderUI)
            imports.beautify.render.create(scoreboardUI.renderUI, {renderType = "input"})
            scoreboardUI.viewRT = imports.beautify.native.createRenderTarget(FRAMEWORK_CONFIGS["UI"]["Scoreboard"].width, FRAMEWORK_CONFIGS["UI"]["Scoreboard"].height - FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Columns"].height, true)
        else
            imports.beautify.render.remove(scoreboardUI.renderUI)
            imports.beautify.render.remove(scoreboardUI.renderUI, {renderType = "input"})
            if scoreboardUI.viewRT and imports.isElement(scoreboardUI.viewRT) then
                imports.destroyElement(scoreboardUI.viewRT)
                scoreboardUI.viewRT = nil
            end
        end
        scoreboardUI.state = state
        imports.showChat(not state)
        imports.showCursor(state)
        return true
    end
    imports.bindKey(FRAMEWORK_CONFIGS["UI"]["Scoreboard"].toggleKey, "down", function() scoreboardUI.toggleUI(not scoreboardUI.state) end)
end)