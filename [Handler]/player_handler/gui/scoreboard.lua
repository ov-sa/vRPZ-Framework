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
    showChat = showChat,
    showCursor = showCursor,
    math = math,
    beautify = beautify
}


-------------------
--[[ Variables ]]--
-------------------

local scoreboardUI = {
    startX = 0, startY = 25,
    width = 1285, height = 500,
    animStatus = "backward",
    banner = {
        title = {
            paddingX = 10,
            serverTitle = "#C81E1E↪ D A Y Z  #C8C8C8E P I C",
            font = fonts[38],
        },
        height = 35,
        bannerPrefix = "O N L I N E    P L A Y E R S | ",
        font = fonts[39],
        fontColor = {175, 175, 175, 255},
        bgColor = {0, 0, 0, 253},
        dividerSize = 2,
        dividerColor = {200, 30, 30, 255}
    },
    dataColumns = {
        dividerSize = 2,
        dividerColor = {100, 100, 100, 35},
        title = {
            height = 25,
            paddingY = 4.5,
            font = fonts[36],
            fontColor = {175, 175, 175, 235},
            bgColor = {100, 100, 100, 35},
            embedLineSize = 10,
            embedLineColor = {100, 100, 100, 35},
            embedLinePath = DxTexture("files/images/scoreboard/border.png", "argb", true, "clamp")
        },
        data = {
            dividerSize = 1,
            dividerPadding = 30,
            dividerColor = {100, 100, 100, 2},
            height = 35,
            font = fonts[37],
            fontColor = {175, 175, 175, 230}
        },
        {
            title = "S.No",
            dataType = "serial_number",
            width = 50,
            fontColor = {0, 255, 0, 230}
        },
        {
            title = "R+",
            dataType = "reputation_+",
            isReputationIconColumn = true,
            width = 50,
            dataText = "+",
            font = fonts[38],
            fontColor = {255, 200, 0, 230},
            fadeAnimDuration = 2500,
            __rowAnimData = {}
        },
        {
            title = "Name",
            dataType = "name",
            width = 200
        },
        {
            title = "Level",
            dataType = "level",
            width = 100
        },
        {
            title = "Rank",
            dataType = "rank",
            width = 100
        },
        {
            title = "Reputation",
            dataType = "reputation",
            width = 90
        },
        {
            title = "Faction",
            dataType = "faction",
            width = 125
        },
        {
            title = "Group",
            dataType = "group",
            width = 125
        },
        {
            title = "Murders",
            dataType = "murders",
            width = 100
        },
        {
            title = "Kills",
            dataType = "kills",
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
scoreboardUI.startY = scoreboardUI.startY + ((CLIENT_MTA_RESOLUTION[2] - scoreboardUI.height)*0.5)


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

scoreboardUI.renderUI = function()
    outputChatBox("RENDERING SCOREBOARD UI..")
end


-------------------------------
--[[ Functions: UI Helpers ]]--
-------------------------------

function isScoreboardUIVisible() return scoreboardUI.state end


------------------------------
--[[ Function: Toggles UI ]]--
------------------------------

scoreboardUI.toggleUI = function()
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
    imports.showChat(false, true)
    imports.showCursor(state, true)
    return true
end
