----------------------------------------------------------------
--[[ Resource: Player Handler
     Script: gui: loginScreen: cache.lua
     Author: OvileAmriam
     Developer: -
     DOC: 11/06/2021 (OvileAmriam)
     Desc: Login Screen Cache ]]--
----------------------------------------------------------------


-------------------
--[[ Variables ]]--
-------------------

loginUICache = {
    state = false,
    isEnabled = false,
    isForcedDisabled = false,
    cinemationData = false,
    character = false,
    selectedCharacter = 0,
    clientCharacters = {},

    serverBanner = {
        startX = 5,
        startY = 5,
        minWidth = 300,
        leftEdgePath = beautify.assets["images"]["right_triangle/default.rw"],
        rightEdgePath = beautify.assets["images"]["right_triangle/flipped_inverted.rw"],
        serverName = {
            paddingY = -2,
            text = "vRP FRAMEWORK",
            font = FRAMEWORK_FONTS[1],
            fontColor = tocolor(255, 30, 30, 255),
            bgColor = tocolor(0, 0, 0, 255)
        }
    },

    optionUI = {
        startY = 15,
        width = 400,
        height = 0,
        paddingY = 5,
        font = FRAMEWORK_FONTS[1],
        borderSize = 3,
        hoverAnimDuration = 2000,
        fontColor = {255, 255, 255, 255},
        bgColor = tocolor(0, 0, 0, 255),
        leftEdgePath = beautify.assets["images"]["curved_square/regular/left.rw"],
        rightEdgePath = beautify.assets["images"]["curved_square/regular/right.rw"],
        {
            placeholder = "P L A Y",
            hoverStatus = "backward",
            hoverAnimTickCounter = CLIENT_CURRENT_TICK,
            funcString = "manageLoginPreviewCharacter(\"play\")"
        },
        {
            placeholder = "C H A R A C T E R S",
            optionType = "characters",
            nudgeOptionY = 110,
            hoverStatus = "backward",
            hoverAnimTickCounter = CLIENT_CURRENT_TICK,
            funcString = "setLoginUIPhase(2)"
        }
    },

    --TODO:WIP
    phaseUI = {
        currentPhase = 1,
        ______isGameResuming = false,
        startX = -15,
        startY = 40,
        paddingX = 7,
        paddingY = 0,
        font = FRAMEWORK_FONTS[6],
        borderSize = 22,
        embedLineSize = 2,
        animStatus = "backward",
        animTickCounter = CLIENT_CURRENT_TICK,
        animDuration = 1500,
        animOpenerDelay = 250,
        borderColor = {0, 0, 0, 255},
        bgColor = {0, 0, 0, 185},
        embedLineColor = {10, 10, 10, 100},
        leftEdgePath = DxTexture("files/images/hud/right_triangle/default.png", "argb", true, "clamp"),
        rightEdgePath = DxTexture("files/images/hud/right_triangle/flipped_inverted.png", "argb", true, "clamp"),
        [2] = {
            placeDataTable = {},
            placeDataValue = 1,
            dividers = {
                height = 2,
                {
                    startX = 10,
                    startY = 67,
                    width = 265,
                    bgColor = {158, 252, 145, 255}
                },
                {
                    startX = 10,
                    startY = 256,
                    width = 265,
                    bgColor = {200, 200, 200, 150},
                }
            },
            buttons = {
                font = FRAMEWORK_FONTS[10],
                hoverAnimDuration = 1250,
                {
                    placeholder = "C R E A T E",
                    startX = 185,
                    startY = 35,
                    width = 90,
                    height = 27,
                    paddingX = 2,
                    paddingY = 2,
                    fontColor = {158, 252, 145, 255},
                    bgColor = {0, 0, 0, 255},
                    funcString = "manageLoginPreviewCharacter(\"create\")"
                },
                {
                    placeholder = "D E L E T E",
                    startX = 88,
                    startY = 35,
                    width = 90,
                    height = 27,
                    paddingX = 2,
                    paddingY = 2,
                    fontColor = {158, 252, 145, 255},
                    bgColor = {0, 0, 0, 255},
                    funcString = "manageLoginPreviewCharacter(\"delete\")"
                },
                {
                    placeholder = ">>>>>>>",
                    disableOnSavedCharacter = true,
                    startX = 10,
                    startY = 206,
                    width = 130,
                    height = 20,
                    paddingX = 2,
                    paddingY = 0,
                    minBGHoverValue = 0.5,
                    fontColor = {0, 0, 0, 255},
                    bgColor = {200, 200, 200, 255},
                    funcString = "manageLoginPreviewCharacter(\"switch_next_skin\")"
                },
                {
                    placeholder = "<<<<<<<",
                    disableOnSavedCharacter = true,
                    startX = 145,
                    startY = 206,
                    width = 130,
                    height = 20,
                    paddingX = 2,
                    paddingY = 0,
                    minBGHoverValue = 0.5,
                    fontColor = {0, 0, 0, 255},
                    bgColor = {200, 200, 200, 255},
                    funcString = "manageLoginPreviewCharacter(\"switch_prev_skin\")"
                },
                {
                    placeholder = "S A V E",
                    disableOnSavedCharacter = true,
                    startX = 10,
                    startY = 231,
                    width = 130,
                    height = 20,
                    paddingX = 2,
                    paddingY = 0,
                    minBGHoverValue = 0.5,
                    fontColor = {0, 0, 0, 255},
                    bgColor = {200, 200, 200, 255},
                    funcString = "manageLoginPreviewCharacter(\"save\")"
                },
                {
                    placeholder = "S E L E C T",
                    startX = 145,
                    startY = 231,
                    width = 130,
                    height = 20,
                    paddingX = 2,
                    paddingY = 0,
                    minBGHoverValue = 0.5,
                    fontColor = {0, 0, 0, 255},
                    bgColor = {200, 200, 200, 255},
                    funcString = "manageLoginPreviewCharacter(\"pick\")"
                },
                {
                    placeholder = "N E X T",
                    startX = 10,
                    startY = 261,
                    width = 130,
                    height = 20,
                    paddingX = 2,
                    paddingY = 0,
                    minBGHoverValue = 0.5,
                    fontColor = {0, 0, 0, 255},
                    bgColor = {200, 200, 200, 255},
                    funcString = "manageLoginPreviewCharacter(\"switch_next\")"
                },
                {
                    placeholder = "P R E V I O U S",
                    startX = 145,
                    startY = 261,
                    width = 130,
                    height = 20,
                    paddingX = 2,
                    paddingY = 0,
                    minBGHoverValue = 0.5,
                    fontColor = {0, 0, 0, 255},
                    bgColor = {200, 200, 200, 255},
                    funcString = "manageLoginPreviewCharacter(\"switch_prev\")"
                }
            },
            editboxes = {
                font = FRAMEWORK_FONTS[11],
                focussedEditbox = 0,
                embedLineSize = 2,
                cursorSize = 2,
                cursorPaddingX = 2,
                cursorPaddingY = 4,
                embedLinePaddingX = 7,
                embedLinePaddingY = 4,
                hoverAnimDuration = 1250,
                inputDelayDuration = 500,
                {
                    placeholder = "E N T E R  N I C K N A M E",
                    placeDataValue = "",
                    type = "nick",
                    disableOnSavedCharacter = true,
                    startX = 10,
                    startY = 80,
                    width = 265,
                    height = 25,
                    paddingY = 4,
                    placeholderFontColor = {200, 200, 200, 75},
                    fontColor = {200, 200, 200, 150},
                    cursorColor = {200, 200, 200, 255},
                    embedLineColor = {200, 200, 200, 150},
                    bgColor = {0, 0, 0, 255},
                    inputSettings = {
                        capsAllowed = true,
                        rangeLimit = {1, 60},
                        validKeys = {"a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0"}
                    }
                }
            },
            sliders = {
                focussedSlider = 0,
                barSize = 1,
                barSliderSize = 9,
                barPaddingX = 10,
                highlighterSize = 12,
                highlighterPaddingX = 10,
                hoverAnimDuration = 1250,
                {
                    type = "color_r",
                    disableOnSavedCharacter = true,
                    startX = 10,
                    startY = 110,
                    width = 265,
                    height = 25,
                    percent = 0,
                    minPercent = 10,
                    barColor = {200, 200, 200, 150},
                    highlighterColor = {230, 50, 50, 150},
                    sliderBarColor = {200, 200, 200, 255},
                    bgColor = {0, 0, 0, 255}
                },
                {
                    type = "color_g",
                    disableOnSavedCharacter = true,
                    startX = 10,
                    startY = 140,
                    width = 265,
                    height = 25,
                    percent = 0,
                    minPercent = 10,
                    barColor = {200, 200, 200, 150},
                    highlighterColor = {50, 230, 50, 150},
                    sliderBarColor = {200, 200, 200, 255},
                    bgColor = {0, 0, 0, 255}
                },
                {
                    type = "color_b",
                    disableOnSavedCharacter = true,
                    startX = 10,
                    startY = 170,
                    width = 265,
                    height = 25,
                    percent = 0,
                    minPercent = 10,
                    barColor = {200, 200, 200, 150},
                    highlighterColor = {50, 50, 230, 150},
                    sliderBarColor = {200, 200, 200, 255},
                    bgColor = {0, 0, 0, 255}
                }
            }
        },
    }
}

loginUICache.serverBanner.serverName.width, loginUICache.serverBanner.serverName.height = dxGetTextSize(loginUICache.serverBanner.serverName.text, dxGetTextWidth(loginUICache.serverBanner.serverName.text, 1, loginUICache.serverBanner.serverName.font), 1, loginUICache.serverBanner.serverName.font)
loginUICache.serverBanner.serverName.width =  math.max(loginUICache.serverBanner.minWidth, loginUICache.serverBanner.serverName.width)
loginUICache.serverBanner.serverName.height = loginUICache.serverBanner.serverName.height + loginUICache.serverBanner.serverName.paddingY
loginUICache.optionUI.slotHeight = dxGetFontHeight(1, loginUICache.optionUI.font)
for i, j in ipairs(loginUICache.optionUI) do
    loginUICache.optionUI.height = loginUICache.optionUI.height + loginUICache.optionUI.slotHeight + loginUICache.optionUI.paddingY
    if loginUICache.phaseUI[i] then
        if j.optionType == "characters" then
            --[[
            for k, v in pairs(serverCharacters) do
                table.insert(loginUICache.phaseUI[i].placeDataTable, k)
            end
            ]]--
        end
    end
end
loginUICache.optionUI.width = loginUICache.serverBanner.serverName.width
loginUICache.optionUI.height = math.max(0, loginUICache.optionUI.height - loginUICache.optionUI.paddingY)
loginUICache.optionUI.startX = loginUICache.serverBanner.startX
loginUICache.optionUI.startY = loginUICache.serverBanner.startY + loginUICache.serverBanner.serverName.height + loginUICache.optionUI.startY