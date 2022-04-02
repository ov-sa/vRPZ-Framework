----------------------------------------------------------------
--[[ Resource: Player Handler
     Script: gui: scoreboard.lua
     Author: vStudio
     Developer(s): Mario, Tron, Aviril
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
    interpolateBetween = interpolateBetween,
    getInterpolationProgress = getInterpolationProgress,
    bindKey = bindKey,
    isMouseScrolled = isMouseScrolled,
    showChat = showChat,
    showCursor = showCursor,
    string = string,
    math = math,
    beautify = beautify
}


-------------------
--[[ Variables ]]--
-------------------

local scoreboardUI = {
    cache = {keys = {scroll = {}}},
    margin = 10,
    animStatus = "backward",
    bgColor = imports.tocolor(imports.unpackColor(FRAMEWORK_CONFIGS["UI"]["Scoreboard"].bgColor)),
    banner = {
        font = CGame.createFont(":beautify_library/files/assets/fonts/teko_medium.rw", 18), counterFont = CGame.createFont(":beautify_library/files/assets/fonts/teko_medium.rw", 16), fontColor = imports.tocolor(imports.unpackColor(FRAMEWORK_CONFIGS["UI"]["Scoreboard"].banner.fontColor)),
        bgColor = imports.tocolor(imports.unpackColor(FRAMEWORK_CONFIGS["UI"]["Scoreboard"].banner.bgColor)), dividerColor = imports.tocolor(imports.unpackColor(FRAMEWORK_CONFIGS["UI"]["Scoreboard"].banner.dividerColor))
    },
    columns = {
        height = 25,
        dividerSize = 2,
        font = CGame.createFont(":beautify_library/files/assets/fonts/teko_medium.rw", 17), fontColor = tocolor(0, 0, 0, 255),
        bgColor = imports.tocolor(100, 100, 100, 255), dividerColor = imports.tocolor(15, 15, 15, 200)
        data = {
            font = CGame.createFont(":beautify_library/files/assets/fonts/teko_medium.rw", 17), fontColor = tocolor(100, 100, 100, 255),
            bgColor = imports.tocolor(10, 10, 10, 255)
        },
        {
            title = "S.No",
            dataType = "serial_number",
            width = 75
        },
        {
            title = "Name",
            dataType = "name",
            width = 250
        },
        {
            title = "Level",
            dataType = "level",
            width = 125
        },
        {
            title = "Rank",
            dataType = "rank",
            width = 125
        },
        {
            title = "Reputation",
            dataType = "reputation",
            width = 125
        },
        {
            title = "Party",
            dataType = "party",
            width = 125
        },
        {
            title = "Group",
            dataType = "group",
            width = 150
        },
        {
            title = "K:D",
            dataType = "kd",
            width = 100
        },
        {
            title = "Survival Time",
            dataType = "survival_time",
            width = 125
        },
        {
            title = "Ping",
            dataType = "ping",
            width = 60
        }
    },
    --[[
    scroller = {
        percent = 0,
        width = 5,
        paddingY = 10,
        barHeight = 60,
        bgColor = {5, 5, 5, 200},
        barColor = {175, 175, 175, 255}
    }
    ]]
}

scoreboardUI.startX = ((CLIENT_MTA_RESOLUTION[1] - FRAMEWORK_CONFIGS["UI"]["Scoreboard"].width)*0.5)
scoreboardUI.startY = FRAMEWORK_CONFIGS["UI"]["Scoreboard"].marginY + ((CLIENT_MTA_RESOLUTION[2] - (FRAMEWORK_CONFIGS["UI"]["Scoreboard"].banner.height + fRAMEWORK_CONFIGS["UI"]["Scoreboard"].height))*0.5)
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
    scoreboardUI.bgRT = imports.beautify.native.createRenderTarget(FRAMEWORK_CONFIGS["UI"]["Scoreboard"].width, FRAMEWORK_CONFIGS["UI"]["Scoreboard"].banner.height + fRAMEWORK_CONFIGS["UI"]["Scoreboard"].height, true)
    imports.beautify.native.setRenderTarget(scoreboardUI.bgRT, true)
    imports.beautify.native.drawRectangle(0, 0, FRAMEWORK_CONFIGS["UI"]["Scoreboard"].width, FRAMEWORK_CONFIGS["UI"]["Scoreboard"].banner.height, scoreboardUI.banner.bgColor, false)
    imports.beautify.native.drawRectangle(0, FRAMEWORK_CONFIGS["UI"]["Scoreboard"].banner.height, FRAMEWORK_CONFIGS["UI"]["Scoreboard"].width, fRAMEWORK_CONFIGS["UI"]["Scoreboard"].height, scoreboardUI.bgColor, false)
    imports.beautify.native.drawRectangle(0, FRAMEWORK_CONFIGS["UI"]["Scoreboard"].banner.height, FRAMEWORK_CONFIGS["UI"]["Scoreboard"].width, scoreboardUI.columns.height, scoreboardUI.columns.bgColor, false)
    imports.beautify.native.drawRectangle(0, FRAMEWORK_CONFIGS["UI"]["Scoreboard"].banner.height + scoreboardUI.columns.height, FRAMEWORK_CONFIGS["UI"]["Scoreboard"].width, FRAMEWORK_CONFIGS["UI"]["Scoreboard"].banner.dividerSize, scoreboardUI.banner.dividerColor, false)        
    imports.beautify.native.setRenderTarget()
    local rtPixels = imports.beautify.native.getTexturePixels(scoreboardUI.bgRT)
    if rtPixels then
        scoreboardUI.bgTexture = imports.beautify.native.createTexture(rtPixels, "dxt5", false, "clamp")
        imports.destroyElement(scoreboardUI.bgRT)
        scoreboardUI.bgRT = nil
    end
    scoreboardUI.bgRT = imports.beautify.native.createRenderTarget(FRAMEWORK_CONFIGS["UI"]["Scoreboard"].width, fRAMEWORK_CONFIGS["UI"]["Scoreboard"].height - scoreboardUI.columns.height, true)
    imports.beautify.native.setRenderTarget(scoreboardUI.bgRT, true)
    for i = 1, #scoreboardUI.columns, 1 do
        local j = scoreboardUI.columns[i]
        j.startX = (scoreboardUI.columns[(i - 1)] and scoreboardUI.columns[(i - 1)].endX) or scoreboardUI.columns.dividerSize
        j.endX = j.startX + j.width + scoreboardUI.columns.dividerSize
        imports.beautify.native.drawRectangle(j.endX - scoreboardUI.columns.dividerSize, scoreboardUI.margin*0.5, scoreboardUI.columns.dividerSize, fRAMEWORK_CONFIGS["UI"]["Scoreboard"].height - scoreboardUI.columns.height - scoreboardUI.margin, scoreboardUI.columns.dividerColor, false)
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

scoreboardUI.renderUI = function(renderData)
    --if not scoreboardUI.state or not CPlayer.isInitialized(localPlayer) then return false end
    if renderData.renderType == "input" then
        scoreboardUI.cache.keys.scroll.state, scoreboardUI.cache.keys.scroll.streak  = imports.isMouseScrolled()
    elseif renderData.renderType == "render" then
        if not scoreboardUI.bgTexture then scoreboardUI.createBGTexture() end
        local serverPlayers = {
            {
                name = "Aviril",
                level = 50,
                rank = "Eternal",
                reputation = 75,
                party = 1,
                group = "Heroes",
                kd = 2.5,
                survival_time = "01:00:00",
                ping = 20
            },
            {
                name = "Tron",
                level = 20,
                rank = "Mythic",
                reputation = 75,
                party = 1,
                group = "Heroes",
                kd = 1.5,
                survival_time = "0:21:23",
                ping = 75
            },
            {
                name = "Maria",
                level = 60,
                rank = "Legend",
                reputation = 75,
                party = 1,
                group = "Heroes",
                kd = 1,
                survival_time = "0:10:16",
                ping = 65
            },
            {
                name = "Maria",
                level = 60,
                rank = "Legend",
                reputation = 75,
                party = 1,
                group = "Heroes",
                kd = 1,
                survival_time = "0:10:16",
                ping = 65
            },
            {
                name = "Maria",
                level = 60,
                rank = "Legend",
                reputation = 75,
                party = 1,
                group = "Heroes",
                kd = 1,
                survival_time = "0:10:16",
                ping = 65
            },
            {
                name = "Maria",
                level = 60,
                rank = "Legend",
                reputation = 75,
                party = 1,
                group = "Heroes",
                kd = 1,
                survival_time = "0:10:16",
                ping = 65
            },
            {
                name = "Maria",
                level = 60,
                rank = "Legend",
                reputation = 75,
                party = 1,
                group = "Heroes",
                kd = 1,
                survival_time = "0:10:16",
                ping = 65
            },
            {
                name = "Maria",
                level = 60,
                rank = "Legend",
                reputation = 75,
                party = 1,
                group = "Heroes",
                kd = 1,
                survival_time = "0:10:16",
                ping = 65
            },
            {
                name = "Maria",
                level = 60,
                rank = "Legend",
                reputation = 75,
                party = 1,
                group = "Heroes",
                kd = 1,
                survival_time = "0:10:16",
                ping = 65
            },
            {
                name = "Maria",
                level = 60,
                rank = "Legend",
                reputation = 75,
                party = 1,
                group = "Heroes",
                kd = 1,
                survival_time = "0:10:16",
                ping = 65
            },
            {
                name = "Maria",
                level = 60,
                rank = "Legend",
                reputation = 75,
                party = 1,
                group = "Heroes",
                kd = 1,
                survival_time = "0:10:16",
                ping = 65
            },
            {
                name = "Maria",
                level = 60,
                rank = "Legend",
                reputation = 75,
                party = 1,
                group = "Heroes",
                kd = 1,
                survival_time = "0:10:16",
                ping = 65
            },
            {
                name = "Maria",
                level = 60,
                rank = "Legend",
                reputation = 75,
                party = 1,
                group = "Heroes",
                kd = 1,
                survival_time = "0:10:16",
                ping = 65
            },
            {
                name = "Maria",
                level = 60,
                rank = "Legend",
                reputation = 75,
                party = 1,
                group = "Heroes",
                kd = 1,
                survival_time = "0:10:16",
                ping = 65
            },
            {
                name = "Maria",
                level = 60,
                rank = "Legend",
                reputation = 75,
                party = 1,
                group = "Heroes",
                kd = 1,
                survival_time = "0:10:16",
                ping = 65
            },
            {
                name = "Maria",
                level = 60,
                rank = "Legend",
                reputation = 75,
                party = 1,
                group = "Heroes",
                kd = 1,
                survival_time = "0:10:16",
                ping = 65
            },
            {
                name = "Maria",
                level = 60,
                rank = "Legend",
                reputation = 75,
                party = 1,
                group = "Heroes",
                kd = 1,
                survival_time = "0:10:16",
                ping = 65
            },
            {
                name = "Maria",
                level = 60,
                rank = "Legend",
                reputation = 75,
                party = 1,
                group = "Heroes",
                kd = 1,
                survival_time = "0:10:16",
                ping = 65
            },
            {
                name = "Maria",
                level = 60,
                rank = "Legend",
                reputation = 75,
                party = 1,
                group = "Heroes",
                kd = 1,
                survival_time = "0:10:16",
                ping = 65
            },
            {
                name = "Maria",
                level = 60,
                rank = "Legend",
                reputation = 75,
                party = 1,
                group = "Heroes",
                kd = 1,
                survival_time = "0:10:16",
                ping = 65
            },
        }
    
        local startX, startY = scoreboardUI.startX, scoreboardUI.startY
        imports.beautify.native.drawImage(startX, startY, FRAMEWORK_CONFIGS["UI"]["Scoreboard"].width, FRAMEWORK_CONFIGS["UI"]["Scoreboard"].banner.height + fRAMEWORK_CONFIGS["UI"]["Scoreboard"].height, scoreboardUI.bgTexture, 0, 0, 0, -1, false)    
        imports.beautify.native.drawText(FRAMEWORK_CONFIGS["UI"]["Scoreboard"].banner.title, startX + scoreboardUI.margin, startY, startX + FRAMEWORK_CONFIGS["UI"]["Scoreboard"].width - scoreboardUI.margin, startY + FRAMEWORK_CONFIGS["UI"]["Scoreboard"].banner.height, scoreboardUI.banner.fontColor, 1, scoreboardUI.banner.font, "left", "center", true, false, false, true)
        imports.beautify.native.drawText(imports.string.spaceChars((#serverPlayers).."/20"), startX + scoreboardUI.margin, startY, startX + FRAMEWORK_CONFIGS["UI"]["Scoreboard"].width - scoreboardUI.margin, startY + FRAMEWORK_CONFIGS["UI"]["Scoreboard"].banner.height, scoreboardUI.banner.fontColor, 1, scoreboardUI.banner.counterFont, "right", "center", true, false, false)
        startY = startY + FRAMEWORK_CONFIGS["UI"]["Scoreboard"].banner.height
        imports.beautify.native.setRenderTarget(scoreboardUI.viewRT, true)
        for i = 1, #serverPlayers, 1 do
            local j = serverPlayers[i]
            local column_startY = (scoreboardUI.margin*0.5) + ((scoreboardUI.columns.height + (scoreboardUI.margin*0.5))*(i - 1))
            for k = 1, #scoreboardUI.columns, 1 do
                local v = scoreboardUI.columns[k]
                local column_startX = v.startX
                imports.beautify.native.drawRectangle(column_startX, column_startY, v.width, scoreboardUI.columns.height, scoreboardUI.columns.data.bgColor, false)
                imports.beautify.native.drawText(((v.dataType == "serial_number") and i) or j[(v.dataType)] or "-", column_startX, column_startY, column_startX + v.width, column_startY + scoreboardUI.columns.height, scoreboardUI.columns.data.fontColor, 1, scoreboardUI.columns.data.font, "center", "center", true, false, false)
            end
        end
        imports.beautify.native.setRenderTarget()
        for i = 1, #scoreboardUI.columns, 1 do
            local j = scoreboardUI.columns[i]
            imports.beautify.native.drawText(j.title, startX + j.startX, startY, startX + j.endX, startY + scoreboardUI.columns.height, scoreboardUI.columns.fontColor, 1, scoreboardUI.columns.font, "center", "center", true, false, false)
        end
        imports.beautify.native.drawImage(startX, startY + scoreboardUI.columns.height, FRAMEWORK_CONFIGS["UI"]["Scoreboard"].width, fRAMEWORK_CONFIGS["UI"]["Scoreboard"].height - scoreboardUI.columns.height, scoreboardUI.viewRT, 0, 0, 0, -1, false)
        imports.beautify.native.drawImage(startX, startY + scoreboardUI.columns.height, FRAMEWORK_CONFIGS["UI"]["Scoreboard"].width, fRAMEWORK_CONFIGS["UI"]["Scoreboard"].height - scoreboardUI.columns.height, scoreboardUI.columnTexture, 0, 0, 0, -1, false)
        if scoreboardUI.cache.keys.scroll.state then
            --TODO: ..
            scoreboardUI.cache.keys.scroll.state = false
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
        scoreboardUI.viewRT = imports.beautify.native.createRenderTarget(FRAMEWORK_CONFIGS["UI"]["Scoreboard"].width, fRAMEWORK_CONFIGS["UI"]["Scoreboard"].height - scoreboardUI.columns.height, true)
    else
        imports.beautify.render.remove(scoreboardUI.renderUI)
        imports.beautify.render.remove(scoreboardUI.renderUI, {renderType = "input"})
        if scoreboardUI.viewRT and imports.isElement(scoreboardUI.viewRT) then
            imports.destroyElement(scoreboardUI.viewRT)
            scoreboardUI.viewRT = nil
        end
    end
    scoreboardUI.state = state
    --TODO: REMOVE FORCE MODE LATER..
    imports.showChat(not state, true)
    imports.showCursor(state, true)
    return true
end

imports.bindKey(FRAMEWORK_CONFIGS["UI"]["Scoreboard"]["Toggle_Key"], "down", function() scoreboardUI.toggleUI(not scoreboardUI.state) end)