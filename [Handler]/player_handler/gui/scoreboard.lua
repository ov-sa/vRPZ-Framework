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
    tocolor = tocolor,
    unpackColor = unpackColor,
    isElement = isElement,
    destroyElement = destroyElement,
    getPlayerName = getPlayerName,
    interpolateBetween = interpolateBetween,
    getInterpolationProgress = getInterpolationProgress,
    bindKey = bindKey,
    isMouseScrolled = isMouseScrolled,
    showChat = showChat,
    showCursor = showCursor,
    string = string,
    table = table,
    math = math,
    beautify = beautify
}


CGame.execOnModuleLoad(function()
    -------------------
    --[[ Variables ]]--
    -------------------

    local scoreboardUI = {
        cache = {keys = {scroll = {}}},
        margin = 10,
        animStatus = "backward",
        bgColor = imports.tocolor(imports.unpackColor(FRAMEWORK_CONFIGS["UI"]["Scoreboard"].bgColor)),
        banner = {
            font = CGame.createFont(1, 18, true), counterFont = CGame.createFont(1, 16, true), fontColor = imports.tocolor(imports.unpackColor(FRAMEWORK_CONFIGS["UI"]["Scoreboard"].banner.fontColor)),
            bgColor = imports.tocolor(imports.unpackColor(FRAMEWORK_CONFIGS["UI"]["Scoreboard"].banner.bgColor)), dividerColor = imports.tocolor(imports.unpackColor(FRAMEWORK_CONFIGS["UI"]["Scoreboard"].banner.dividerColor))
        },
        columns = {
            font = CGame.createFont(1, 17), fontColor = imports.tocolor(imports.unpackColor(FRAMEWORK_CONFIGS["UI"]["Scoreboard"].columns.fontColor)),
            bgColor = imports.tocolor(imports.unpackColor(FRAMEWORK_CONFIGS["UI"]["Scoreboard"].columns.bgColor)), dividerColor = imports.tocolor(imports.unpackColor(FRAMEWORK_CONFIGS["UI"]["Scoreboard"].columns.dividerColor)),
            data = {
                font = CGame.createFont(1, 17, true), fontColor = imports.tocolor(imports.unpackColor(FRAMEWORK_CONFIGS["UI"]["Scoreboard"].columns.data.fontColor)),
                bgColor = imports.tocolor(imports.unpackColor(FRAMEWORK_CONFIGS["UI"]["Scoreboard"].columns.data.bgColor))
            }
        },
        scroller = {
            percent = 0, animPercent = 0,
            bgColor = imports.tocolor(imports.unpackColor(FRAMEWORK_CONFIGS["UI"]["Scoreboard"].scroller.bgColor)), thumbColor = imports.tocolor(imports.unpackColor(FRAMEWORK_CONFIGS["UI"]["Scoreboard"].scroller.thumbColor))
        }
    }

    scoreboardUI.startX = ((CLIENT_MTA_RESOLUTION[1] - FRAMEWORK_CONFIGS["UI"]["Scoreboard"].width)*0.5)
    scoreboardUI.startY = FRAMEWORK_CONFIGS["UI"]["Scoreboard"].marginY + ((CLIENT_MTA_RESOLUTION[2] - (FRAMEWORK_CONFIGS["UI"]["Scoreboard"].banner.height + FRAMEWORK_CONFIGS["UI"]["Scoreboard"].height))*0.5)
    scoreboardUI.createBGTexture = function(isRefresh)
        if CLIENT_MTA_MINIMIZED then return false end
        if isRefresh then
            if scoreboardUI.bgTexture and imports.isElement(scoreboardUI.bgTexture) then
                imports.destroyElement(scoreboardUI.bgTexture)
                scoreboardUI.bgTexture = nil
            end
            if scoreboardUI.columnTexture and imports.isElement(scoreboardUI.columnTexture) then
                imports.destroyElement(scoreboardUI.columnTexture)
                scoreboardUI.columnTexture = nil
            end
        end
        scoreboardUI.bgRT = imports.beautify.native.createRenderTarget(FRAMEWORK_CONFIGS["UI"]["Scoreboard"].width, FRAMEWORK_CONFIGS["UI"]["Scoreboard"].banner.height + FRAMEWORK_CONFIGS["UI"]["Scoreboard"].height, true)
        imports.beautify.native.setRenderTarget(scoreboardUI.bgRT, true)
        imports.beautify.native.drawRectangle(0, 0, FRAMEWORK_CONFIGS["UI"]["Scoreboard"].width, FRAMEWORK_CONFIGS["UI"]["Scoreboard"].banner.height, scoreboardUI.banner.bgColor, false)
        imports.beautify.native.drawRectangle(0, FRAMEWORK_CONFIGS["UI"]["Scoreboard"].banner.height, FRAMEWORK_CONFIGS["UI"]["Scoreboard"].width, FRAMEWORK_CONFIGS["UI"]["Scoreboard"].height, scoreboardUI.bgColor, false)
        imports.beautify.native.drawRectangle(0, FRAMEWORK_CONFIGS["UI"]["Scoreboard"].banner.height, FRAMEWORK_CONFIGS["UI"]["Scoreboard"].width, FRAMEWORK_CONFIGS["UI"]["Scoreboard"].columns.height, scoreboardUI.columns.bgColor, false)
        imports.beautify.native.drawRectangle(0, FRAMEWORK_CONFIGS["UI"]["Scoreboard"].banner.height + FRAMEWORK_CONFIGS["UI"]["Scoreboard"].columns.height, FRAMEWORK_CONFIGS["UI"]["Scoreboard"].width, FRAMEWORK_CONFIGS["UI"]["Scoreboard"].banner.dividerSize, scoreboardUI.banner.dividerColor, false)        
        imports.beautify.native.setRenderTarget()
        local rtPixels = imports.beautify.native.getTexturePixels(scoreboardUI.bgRT)
        if rtPixels then
            scoreboardUI.bgTexture = imports.beautify.native.createTexture(rtPixels, "dxt5", false, "clamp")
            imports.destroyElement(scoreboardUI.bgRT)
            scoreboardUI.bgRT = nil
        end
        scoreboardUI.bgRT = imports.beautify.native.createRenderTarget(FRAMEWORK_CONFIGS["UI"]["Scoreboard"].width, FRAMEWORK_CONFIGS["UI"]["Scoreboard"].height - FRAMEWORK_CONFIGS["UI"]["Scoreboard"].columns.height, true)
        imports.beautify.native.setRenderTarget(scoreboardUI.bgRT, true)
        for i = 1, #FRAMEWORK_CONFIGS["UI"]["Scoreboard"].columns, 1 do
            local j = FRAMEWORK_CONFIGS["UI"]["Scoreboard"].columns[i]
            j.startX = (FRAMEWORK_CONFIGS["UI"]["Scoreboard"].columns[(i - 1)] and FRAMEWORK_CONFIGS["UI"]["Scoreboard"].columns[(i - 1)].endX) or FRAMEWORK_CONFIGS["UI"]["Scoreboard"].columns.dividerSize
            j.endX = j.startX + j.width + FRAMEWORK_CONFIGS["UI"]["Scoreboard"].columns.dividerSize
            imports.beautify.native.drawRectangle(j.endX - FRAMEWORK_CONFIGS["UI"]["Scoreboard"].columns.dividerSize, scoreboardUI.margin*0.5, FRAMEWORK_CONFIGS["UI"]["Scoreboard"].columns.dividerSize, FRAMEWORK_CONFIGS["UI"]["Scoreboard"].height - FRAMEWORK_CONFIGS["UI"]["Scoreboard"].columns.height - scoreboardUI.margin, scoreboardUI.columns.dividerColor, false)
        end
        imports.beautify.native.setRenderTarget()
        local rtPixels = imports.beautify.native.getTexturePixels(scoreboardUI.bgRT)
        if rtPixels then
            scoreboardUI.columnTexture = imports.beautify.native.createTexture(rtPixels, "dxt5", false, "clamp")
            imports.destroyElement(scoreboardUI.bgRT)
            scoreboardUI.bgRT = nil
        end
    end


    ------------------------------
    --[[ Function: Renders UI ]]--
    ------------------------------

    --[[
    local serverPlayers = CPlayer.CLogged
    for i = 1, 30, 1 do
        table.insert(serverPlayers, {
            name = "Aviril",
            level = 50,
            rank = "Eternal",
            reputation = 75,
            party = 1,
            group = "Heroes",
            kd = 2.5,
            survival_time = "01:00:00",
            ping = 20
        })
    end
`   ]]

    scoreboardUI.renderUI = function(renderData)
        if not scoreboardUI.state or not CPlayer.isInitialized(localPlayer) then return false end

        if renderData.renderType == "input" then
            scoreboardUI.cache.keys.scroll.state, scoreboardUI.cache.keys.scroll.streak  = imports.isMouseScrolled()
        elseif renderData.renderType == "render" then
            if not scoreboardUI.bgTexture then scoreboardUI.createBGTexture() end
            --TODO: FETCH SERVER PLAYERS LAYER..
            local serverPlayers = {}
            for i, j in imports.pairs(CPlayer.CLogged) do
                imports.table.insert(serverPlayers, {
                    name = getPlayerName(i)
                })
            end
            local startX, startY = scoreboardUI.startX, scoreboardUI.startY
            local view_height = FRAMEWORK_CONFIGS["UI"]["Scoreboard"].height - FRAMEWORK_CONFIGS["UI"]["Scoreboard"].columns.height
            local row_height = FRAMEWORK_CONFIGS["UI"]["Scoreboard"].columns.height + (scoreboardUI.margin*0.5)
            local view_overflowHeight =  imports.math.max(0, (scoreboardUI.margin*0.5) + (row_height*#serverPlayers) - view_height)
            local offsetY = view_overflowHeight*scoreboardUI.scroller.animPercent*0.01
            local row_startIndex = imports.math.floor(offsetY/row_height) + 1
            local row_endIndex = imports.math.min(#serverPlayers, row_startIndex + imports.math.ceil(view_height/row_height))
            imports.beautify.native.drawImage(startX, startY, FRAMEWORK_CONFIGS["UI"]["Scoreboard"].width, FRAMEWORK_CONFIGS["UI"]["Scoreboard"].banner.height + FRAMEWORK_CONFIGS["UI"]["Scoreboard"].height, scoreboardUI.bgTexture, 0, 0, 0, -1, false)    
            imports.beautify.native.drawText(FRAMEWORK_CONFIGS["UI"]["Scoreboard"].banner.title, startX + scoreboardUI.margin, startY, startX + FRAMEWORK_CONFIGS["UI"]["Scoreboard"].width - scoreboardUI.margin, startY + FRAMEWORK_CONFIGS["UI"]["Scoreboard"].banner.height, scoreboardUI.banner.fontColor, 1, scoreboardUI.banner.font.instance, "left", "center", true, false, false, true)
            imports.beautify.native.drawText(imports.string.spaceChars((#serverPlayers).."/"..FRAMEWORK_CONFIGS["Game"]["Player_Limit"]), startX + scoreboardUI.margin, startY, startX + FRAMEWORK_CONFIGS["UI"]["Scoreboard"].width - scoreboardUI.margin, startY + FRAMEWORK_CONFIGS["UI"]["Scoreboard"].banner.height, scoreboardUI.banner.fontColor, 1, scoreboardUI.banner.counterFont.instance, "right", "center", true, false, false)
            startY = startY + FRAMEWORK_CONFIGS["UI"]["Scoreboard"].banner.height
            imports.beautify.native.setRenderTarget(scoreboardUI.viewRT, true)
            for i = row_startIndex, row_endIndex, 1 do
                local j = serverPlayers[i]
                local column_startY = (scoreboardUI.margin*0.5) + (row_height*(i - 1)) - offsetY
                for k = 1, #FRAMEWORK_CONFIGS["UI"]["Scoreboard"].columns, 1 do
                    local v = FRAMEWORK_CONFIGS["UI"]["Scoreboard"].columns[k]
                    local column_startX = v.startX
                    imports.beautify.native.drawRectangle(column_startX, column_startY, v.width, FRAMEWORK_CONFIGS["UI"]["Scoreboard"].columns.height, scoreboardUI.columns.data.bgColor, false)
                    imports.beautify.native.drawText(((v.dataType == "serial_number") and i) or j[(v.dataType)] or "-", column_startX, column_startY, column_startX + v.width, column_startY + FRAMEWORK_CONFIGS["UI"]["Scoreboard"].columns.height, scoreboardUI.columns.data.fontColor, 1, scoreboardUI.columns.data.font.instance, "center", "center", true, false, false)
                end
            end
            imports.beautify.native.setRenderTarget()
            for i = 1, #FRAMEWORK_CONFIGS["UI"]["Scoreboard"].columns, 1 do
                local j = FRAMEWORK_CONFIGS["UI"]["Scoreboard"].columns[i]
                imports.beautify.native.drawText(j.title[(CPlayer.CLanguage)], startX + j.startX, startY, startX + j.endX, startY + FRAMEWORK_CONFIGS["UI"]["Scoreboard"].columns.height, scoreboardUI.columns.fontColor, 1, scoreboardUI.columns.font.instance, "center", "center", true, false, false)
            end
            imports.beautify.native.drawImage(startX, startY + FRAMEWORK_CONFIGS["UI"]["Scoreboard"].columns.height, FRAMEWORK_CONFIGS["UI"]["Scoreboard"].width, view_height, scoreboardUI.viewRT, 0, 0, 0, -1, false)
            imports.beautify.native.drawImage(startX, startY + FRAMEWORK_CONFIGS["UI"]["Scoreboard"].columns.height, FRAMEWORK_CONFIGS["UI"]["Scoreboard"].width, view_height, scoreboardUI.columnTexture, 0, 0, 0, -1, false)
            if view_overflowHeight > 0 then
                if not scoreboardUI.scroller.isPositioned then
                    scoreboardUI.scroller.startX, scoreboardUI.scroller.startY = FRAMEWORK_CONFIGS["UI"]["Scoreboard"].width - FRAMEWORK_CONFIGS["UI"]["Scoreboard"].scroller.width, FRAMEWORK_CONFIGS["UI"]["Scoreboard"].columns.height
                    scoreboardUI.scroller.height = view_height
                    scoreboardUI.scroller.isPositioned = true
                end
                if imports.math.round(scoreboardUI.scroller.animPercent, 2) ~= imports.math.round(scoreboardUI.scroller.percent, 2) then
                    scoreboardUI.scroller.animPercent = imports.interpolateBetween(scoreboardUI.scroller.animPercent, 0, 0, scoreboardUI.scroller.percent, 0, 0, 0.5, "InQuad")
                end
                imports.beautify.native.drawRectangle(startX + scoreboardUI.scroller.startX, startY + scoreboardUI.scroller.startY, FRAMEWORK_CONFIGS["UI"]["Scoreboard"].scroller.width, scoreboardUI.scroller.height, scoreboardUI.scroller.bgColor, false)
                imports.beautify.native.drawRectangle(startX + scoreboardUI.scroller.startX, startY + scoreboardUI.scroller.startY + ((scoreboardUI.scroller.height - FRAMEWORK_CONFIGS["UI"]["Scoreboard"].scroller.thumbHeight)*scoreboardUI.scroller.animPercent*0.01), FRAMEWORK_CONFIGS["UI"]["Scoreboard"].scroller.width, FRAMEWORK_CONFIGS["UI"]["Scoreboard"].scroller.thumbHeight, scoreboardUI.scroller.thumbColor, false)
                if scoreboardUI.cache.keys.scroll.state then
                    --TODO: CHEK IF THE VIEW RT IS HOVERED
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
        if (((state ~= true) and (state ~= false)) or (state == scoreboardUI.state)) then return false end

        if state then
            imports.beautify.render.create(scoreboardUI.renderUI)
            imports.beautify.render.create(scoreboardUI.renderUI, {renderType = "input"})
            scoreboardUI.viewRT = imports.beautify.native.createRenderTarget(FRAMEWORK_CONFIGS["UI"]["Scoreboard"].width, FRAMEWORK_CONFIGS["UI"]["Scoreboard"].height - FRAMEWORK_CONFIGS["UI"]["Scoreboard"].columns.height, true)
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
    imports.bindKey(FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Toggle_Key"], "down", function() scoreboardUI.toggleUI(not scoreboardUI.state) end)
end)