------------------
--[[ Configns ]]--
------------------

FRAMEWORK_CONFIGS["UI"]["Scoreboard"] = {
    toggleKey = "tab",
    marginY = 25,
    width = 1282, height = 525,
    bgColor = {0, 0, 0, 250},
    scroller = {
        width = 2,
        thumbHeight = 245,
        bgColor = {0, 0, 0, 255},
        thumbColor = {175, 175, 175, 255}
    },

    ["Banner"] = {
        title = "#C81E1E↪  v R P Z   #C8C8C8F R A M E W O R K",
        height = 35, dividerSize = 1,
        fontColor = {175, 175, 175, 255}, dividerColor = {0, 0, 0, 200}, bgColor = {0, 0, 0, 255}
    },

    ["Columns"] = {
        height = 25, dividerSize = 2,
        fontColor = {0, 0, 0, 255}, bgColor = {100, 100, 100, 255}, dividerColor = {15, 15, 15, 200},
        data = {
            fontColor = {100, 100, 100, 255}, hoverFontColor = {0, 0, 0, 255},
            bgColor = {10, 10, 10, 255}, hoverBGColor = {85, 85, 85, 255},
            hoverDuration = 2500
        },
        {
            ["Title"] = {
                ["EN"] = "ID", 
                ["TR"] = "ID", 
                ["RU"] = "ID",
                ["BR"] = "ID",
            },
            dataType = "serial_number",
            width = 60
        },
        {
            ["Title"] = {
                ["EN"] = "Name", 
                ["TR"] = "İsim", 
                ["RU"] = "Имя",
                ["BR"] = "Nome",
            },
            dataType = "name",
            width = 240
        },
        {
            ["Title"] = {
                ["EN"] = "Level", 
                ["TR"] = "Seviye", 
                ["RU"] = "Уровень",
                ["BR"] = "Nível",
            },
            dataType = "level",
            width = 100
        },
        {
            ["Title"] = {
                ["EN"] = "Rank", 
                ["TR"] = "Rank", 
                ["RU"] = "Ранг",
                ["BR"] = "Rank",
            },
            dataType = "rank",
            width = 135
        },
        {
            ["Title"] = {
                ["EN"] = "Reputation", 
                ["TR"] = "İtibar", 
                ["RU"] = "Репутация",
                ["BR"] = "Reputação",
            },
            dataType = "reputation",
            width = 125
        },
        {
            ["Title"] = {
                ["EN"] = "Faction", 
                ["TR"] = "Hizip", 
                ["RU"] = "Фракция",
                ["BR"] = "Facção",
            },
            dataType = "faction",
            width = 155
        },
        {
            ["Title"] = {
                ["EN"] = "Group", 
                ["TR"] = "Grup", 
                ["RU"] = "Группа",
                ["BR"] = "Grupo",
            },
            dataType = "group",
            width = 125
        },
        {
            ["Title"] = {
                ["EN"] = "K:D", 
                ["TR"] = "K:D", 
                ["RU"] = "У:С",
                ["BR"] = "K:D",
            },
            dataType = "kd",
            width = 100
        },
        {
            ["Title"] = {
                ["EN"] = "Survival", 
                ["TR"] = "Hayatta Kalma", 
                ["RU"] = "Прожито Времени",
                ["BR"] = "Tempo de sobrevivência",
            },
            dataType = "survival_time",
            width = 140
        },
        {
            ["Title"] = {
                ["EN"] = "Ping", 
                ["TR"] = "Ping", 
                ["RU"] = "Пинг",
                ["BR"] = "Ping",
            },
            dataType = "ping",
            width = 80
        }
    }
}
