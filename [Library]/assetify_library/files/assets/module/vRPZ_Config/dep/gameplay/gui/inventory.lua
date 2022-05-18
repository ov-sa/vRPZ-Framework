------------------
--[[ Configns ]]--
------------------

FRAMEWORK_CONFIGS["UI"]["Inventory"] = {
    toggleKey = "j",
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
    scroller = {
        width = 5,
        thumbHeight = 100,
        bgColor = {0, 0, 0, 255},
        thumbColor = {175, 175, 175, 255}
    },

    inventory = {
        ["Title"] = {
            ["EN"] = "%s's Inventory", 
            ["TR"] = "%s'nun Envanteri",
            ["RU"] = "Инвентарь %s", 
            ["BR"] = "Inventário do(a) %s",
            ["NL"] = "%s's inventaris"
        },
        rows = 12, columns = 10,
        slotSize = 45, dividerSize = 1,
        bgColor = {0, 0, 0, 245}, slotColor = {255, 255, 255}, slotNameFontColor = {175, 175, 175, 255}, dividerColor = {35, 35, 35},
        slotAvailableColor = {0, 255, 0}, slotUnavailableColor = {255, 0, 0},
        animDuration = 150
    }
}