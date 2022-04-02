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
    startX = 0, startY = 25,
    width = 1282, height = 525,
    animStatus = "backward",
    bgColor = imports.tocolor(0, 0, 0, 250),
    banner = {
        title = "#C81E1E↪  v R P Z   #C8C8C8F R A M E W O R K",
        height = 35,
        dividerSize = 1, dividerColor = imports.tocolor(0, 0, 0, 75),
        font = CGame.createFont(":beautify_library/files/assets/fonts/teko_medium.rw", 18), counterFont = CGame.createFont(":beautify_library/files/assets/fonts/teko_medium.rw", 16), fontColor = tocolor(175, 175, 175, 255),
        bgColor = imports.tocolor(0, 0, 0, 255)
    },
    columns = {
        height = 25,
        dividerSize = 2, dividerColor = imports.tocolor(15, 15, 15, 75),
        font = CGame.createFont(":beautify_library/files/assets/fonts/teko_medium.rw", 17), fontColor = tocolor(0, 0, 0, 255),
        bgColor = imports.tocolor(100, 100, 100, 255),
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
    }
}

scoreboardUI.startX = scoreboardUI.startX + ((CLIENT_MTA_RESOLUTION[1] - scoreboardUI.width)*0.5)
scoreboardUI.startY = scoreboardUI.startY + ((CLIENT_MTA_RESOLUTION[2] - (scoreboardUI.height + scoreboardUI.banner.height))*0.5)


--[[
scoreboardCache = {
    animTickCounter = getTickCount(),
    animDuration = 500,
    animPercent = 1,
    prevAnimPercent = 1,
    padding = 5,
    bgColor = {0, 0, 0, 253},
    curvedEdges = {
        curveSize = 35,
        top_left = DxTexture("files/images/hud/curved_square/top_left.png", "argb", true, "clamp"),
        top_right = DxTexture("files/images/hud/curved_square/top_right.png", "argb", true, "clamp"),
        bottom_left = DxTexture("files/images/hud/curved_square/bottom_left.png", "argb", true, "clamp"),
        bottom_right = DxTexture("files/images/hud/curved_square/bottom_right.png", "argb", true, "clamp")
    },
    renderTarget = false,
    scroller = {
        percent = 0,
        width = 5,
        paddingY = 10,
        barHeight = 60,
        bgColor = {5, 5, 5, 200},
        barColor = {175, 175, 175, 255}
    }
}
]]--


------------------------------
--[[ Function: Renders UI ]]--
------------------------------

scoreboardUI.renderUI = function(renderData)
    --if not scoreboardUI.state or not CPlayer.isInitialized(localPlayer) then return false end
    if renderData.renderType == "input" then
        scoreboardUI.cache.keys.scroll.state, scoreboardUI.cache.keys.scroll.streak  = imports.isMouseScrolled()
    elseif renderData.renderType == "render" then
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
            }
        }
    
        local startX, startY = scoreboardUI.startX, scoreboardUI.startY + scoreboardUI.banner.height
        local banner_startX, banner_startY = startX, startY - scoreboardUI.banner.height
        imports.beautify.native.drawRectangle(banner_startX, banner_startY, scoreboardUI.width, scoreboardUI.banner.height, scoreboardUI.banner.bgColor, false)
        imports.beautify.native.drawRectangle(startX, startY, scoreboardUI.width, scoreboardUI.height, scoreboardUI.bgColor, false)
        imports.beautify.native.drawRectangle(banner_startX, startY, scoreboardUI.width, scoreboardUI.columns.height, scoreboardUI.columns.bgColor, false)
        imports.beautify.native.drawRectangle(banner_startX, startY, scoreboardUI.width, scoreboardUI.banner.dividerSize, scoreboardUI.banner.dividerColor, false)
        for i = 1, #scoreboardUI.columns, 1 do
            local j = scoreboardUI.columns[i]
            j.startX = (scoreboardUI.columns[(i - 1)] and scoreboardUI.columns[(i - 1)].endX) or scoreboardUI.columns.dividerSize
            j.endX = j.startX + j.width + scoreboardUI.columns.dividerSize
            imports.beautify.native.drawRectangle(startX + j.endX - scoreboardUI.columns.dividerSize, startY + scoreboardUI.columns.height + (scoreboardUI.margin*0.5), scoreboardUI.columns.dividerSize, scoreboardUI.height - scoreboardUI.columns.height - scoreboardUI.margin, scoreboardUI.columns.dividerColor, false)
        end

        
        imports.beautify.native.drawText(scoreboardUI.banner.title, banner_startX + scoreboardUI.margin, banner_startY, banner_startX + scoreboardUI.width - scoreboardUI.margin, banner_startY + scoreboardUI.banner.height, scoreboardUI.banner.fontColor, 1, scoreboardUI.banner.font, "left", "center", true, false, false, true)
        imports.beautify.native.drawText(imports.string.spaceChars((#serverPlayers).."/20"), banner_startX + scoreboardUI.margin, banner_startY, banner_startX + scoreboardUI.width - scoreboardUI.margin, banner_startY + scoreboardUI.banner.height, scoreboardUI.banner.fontColor, 1, scoreboardUI.banner.counterFont, "right", "center", true, false, false)
        for i = 1, #scoreboardUI.columns, 1 do
            local j = scoreboardUI.columns[i]
            imports.beautify.native.drawText(j.title, startX + j.startX, startY, startX + j.endX, startY + scoreboardUI.columns.height, scoreboardUI.columns.fontColor, 1, scoreboardUI.columns.font, "center", "center", true, false, false)
        end
        for i = 1, #serverPlayers, 1 do
            local j = serverPlayers[i]
            local column_startY = startY + scoreboardUI.columns.height + (scoreboardUI.margin*0.5) + ((scoreboardUI.columns.height + (scoreboardUI.margin*0.5))*(i - 1))
            for k = 1, #scoreboardUI.columns, 1 do
                local v = scoreboardUI.columns[k]
                local column_startX = startX + v.startX
                imports.beautify.native.drawRectangle(column_startX, column_startY, v.width, scoreboardUI.columns.height, scoreboardUI.columns.data.bgColor, false)
                imports.beautify.native.drawText(((v.dataType == "serial_number") and i) or j[(v.dataType)] or "-", column_startX, column_startY, column_startX + v.width, column_startY + scoreboardUI.columns.height, scoreboardUI.columns.data.fontColor, 1, scoreboardUI.columns.data.font, "center", "center", true, false, false)
            end
        end
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
        scoreboardUI.state = true
        imports.beautify.render.create(scoreboardUI.renderUI)
        imports.beautify.render.create(scoreboardUI.renderUI, {renderType = "input"})
    else
        imports.beautify.render.remove(scoreboardUI.renderUI)
        imports.beautify.render.remove(scoreboardUI.renderUI, {renderType = "input"})
        scoreboardUI.state = false
    end
    --TODO: REMOVE FORCE MODE LATER..
    imports.showChat(not state, true)
    imports.showCursor(state, true)
    return true
end

imports.bindKey("z", "down", function() scoreboardUI.toggleUI(not scoreboardUI.state) end)