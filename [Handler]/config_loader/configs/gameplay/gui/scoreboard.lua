----------------------------------------------------------------
--[[ Resource: Config Loader
     Script: configs: gameplay: gui: scoreboard.lua
     Author: vStudio
     Developer(s): Mario, Tron, Aviril
     DOC: 31/01/2022
     Desc: Scoreboard UI Configns ]]--
----------------------------------------------------------------


------------------
--[[ Configns ]]--
------------------

configVars["UI"]["Scoreboard"] = {

    ["Toggle_Key"] = "tab",

    marginY = 25,
    width = 1282, height = 525,
    bgColor = {0, 0, 0, 250},

    banner = {
        title = "#C81E1E↪  v R P Z   #C8C8C8F R A M E W O R K",
        height = 35, dividerSize = 1,
        fontColor = {175, 175, 175, 255}, dividerColor = {0, 0, 0, 200}, bgColor = {0, 0, 0, 255}
    },

    --[[
    titlebar = {
        height = 35,
        fontColor = {170, 35, 35, 255},
        bgColor = {0, 0, 0, 255},
        slot = {
            height = 20,
            fontColor = {0, 0, 0, 255},
            bgColor = {100, 100, 100, 255}
        }
    },
    ]]

    columns = {
        height = 25, dividerSize = 2,
    },

    scroller = {
        width = 5,
        thumbHeight = 100,
        bgColor = {0, 0, 0, 255},
        thumbColor = {175, 35, 35, 255}
    },

    --[[
    inventory = {
        animDuration = 950,
        rows = 12,
        columns = 10,
        slotSize = 45,
        dividerSize = 1,
        bgColor = {0, 0, 0, 245},
        slotColor = {255, 255, 255, 75},
        slotNameFontColor = {175, 175, 175, 255},
        dividerColor = {100, 100, 100, 50}
    }]]

}