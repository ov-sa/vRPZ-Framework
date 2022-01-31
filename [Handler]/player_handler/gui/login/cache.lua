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

local screenX, screenY = CLIENT_MTA_RESOLUTION[1]/1366, CLIENT_MTA_RESOLUTION[2]/768
loginUICache = {
    state = false,
    isEnabled = false,
    isForcedDisabled = false,
    cinemationData = false,
    character = false,
    selectedCharacter = 0,
    clientCharacters = {},
    serverBanner = {
        startX = 10,
        startY = 5,
        leftEdgePath = DxTexture("files/images/hud/right_triangle/default.png", "argb", true, "clamp"),
        rightEdgePath = DxTexture("files/images/hud/right_triangle/flipped_inverted.png", "argb", true, "clamp"),
        serverLogo = {
            startX = 0,
            startY = 0,
            width = 60,
            height = 60,
            bgColor = {255, 255, 255, 255},
            bgPath = DxTexture("files/images/logo/ov.png", "argb", true, "clamp")
        },
        serverTitle = {
            startX = 5,
            startY = 6,
            text = "C R E A T E D  W I T H  ❤️  b y  O V  N E T W O R K",
            font = fonts[2],
            outlineWeight = 2,
            fontColor = {230, 30, 30, 255},
            outlineColor = {0, 0, 0, 255}
        },
        serverName = {
            startX = 5,
            startY = 3,
            paddingY = 0,
            text = "SERVER NAME....",
            font = fonts[3],
            fontColor = {200, 200, 200, 255},
            bgColor = {0, 0, 0, 255}
        }
    },
    optionUI = {
        startX = 15,
        startY = 70,
        width = 275,
        height = 0,
        slotHeight = 32,
        slotPaddingX = 20,
        slotPaddingY = 17,
        font = fonts[5],
        borderSize = 3,
        hoverAnimDuration = 2000,
        fontColor = {158, 252, 145, 255},
        hoverBGColor = {0, 0, 0, 240},
        bgColor = {0, 0, 0, 150},
        {
            placeholder = "P L A Y",
            hoverStatus = "backward",
            hoverAnimTickCounter = getTickCount(),
            funcString = "manageLoginPreviewCharacter(\"play\")",
            fontColor = {255, 255, 255, 255}
        },
        {
            placeholder = "C H A R A C T E R S",
            optionType = "characters",
            nudgeOptionY = 110,
            hoverStatus = "backward",
            hoverAnimTickCounter = getTickCount(),
            funcString = "setLoginUIPhase(2)"
        },
        {
            placeholder = "S O C I A L S",
            optionType = "socials",
            hoverStatus = "backward",
            hoverAnimTickCounter = getTickCount(),
            funcString = "setLoginUIPhase(3)",
        },
        {
            placeholder = "C R E D I T S",
            optionType = "credits",
            hoverStatus = "backward",
            hoverAnimTickCounter = getTickCount(),
            funcString = "setLoginUIPhase(4)",
            fontColor = {215, 215, 150, 255}
        }
    },
    --[[
    phaseUI = {
        currentPhase = 1,
        ______isGameResuming = false,
        startX = -15,
        startY = 40,
        paddingX = 7,
        paddingY = 0,
        font = fonts[6],
        borderSize = 22,
        embedLineSize = 2,
        animStatus = "backward",
        animTickCounter = getTickCount(),
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
                font = fonts[10],
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
                font = fonts[11],
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
        [3] = {
            width = 965,
            height = 275,
            discordLinks = {
                startY = 20,
                paddingX = 35, 
                width = 385,
                height = 145,
                iconSize = 100,
                font = fonts[8],
                fontScale = 0.4,
                outlineWeight = 3,
                fontColor = {200, 200, 200, 255},
                outlineColor = {0, 0, 0, 200},
                {
                    placeholder = "DISCORD.GG/sVCnxPW",
                    bgColor = {255, 255, 255, 255},
                    bgPath = DxTexture("files/images/logo/ov.png", "argb", true, "clamp")
                },
                {
                    placeholder = "DISCORD.GG/ryc47wDEKb",
                    bgColor = {255, 255, 255, 255},
                    bgPath = DxTexture("files/images/logo/logo.png", "argb", true, "clamp")
                }
            },
            socialLinks = {
                startY = 0,
                startY = 42,
                paddingX = 25,
                dataPaddingX = 7,
                dataPaddingY = 3,
                width = 270,
                height = 33,
                font = fonts[9],
                fontScale = 0.25,
                fontColor = {100, 100, 100, 255},
                bgColor = {0, 0, 0, 255},
                {
                    placeholder = "COMING SOON",
                    bgColor = {255, 255, 255, 255},
                    bgPath = DxTexture("files/images/logo/website.png", "argb", true, "clamp")
                },
                {
                    placeholder = "COMING SOON",
                    bgColor = {255, 255, 255, 255},
                    bgPath = DxTexture("files/images/logo/twitch.png", "argb", true, "clamp")
                },
                {
                    placeholder = "COMING SOON",
                    bgColor = {255, 255, 255, 255},
                    bgPath = DxTexture("files/images/logo/youtube.png", "argb", true, "clamp")
                }
            }
        },
        [4] = {
            dataValue = lobbyDatas.devCredits,
            width = 245,
            height = 250,
            dataHeight = 0,
            paddingX = -35,
            font = fonts[7],
            fontScale = 0.5,
            fontColor = {200, 200, 200, 255},
            scrollDuration = 5000,
            scrollDelayDuration = 1250,
            scrollTickCounter = getTickCount()
        }
    }
    ]]--
}

loginUICache.serverBanner.serverTitle.width, loginUICache.serverBanner.serverTitle.height = dxGetTextSize(loginUICache.serverBanner.serverTitle.text, dxGetTextWidth(loginUICache.serverBanner.serverTitle.text, 1, loginUICache.serverBanner.serverTitle.font), 1, loginUICache.serverBanner.serverTitle.font)
loginUICache.serverBanner.serverTitle.width = loginUICache.serverBanner.serverTitle.width + loginUICache.serverBanner.serverTitle.startX
loginUICache.serverBanner.serverTitle.startX = loginUICache.serverBanner.serverTitle.startX + loginUICache.serverBanner.serverLogo.startX + loginUICache.serverBanner.serverLogo.width
loginUICache.serverBanner.serverName.width, loginUICache.serverBanner.serverName.height = dxGetTextSize(loginUICache.serverBanner.serverName.text, dxGetTextWidth(loginUICache.serverBanner.serverName.text, 1, loginUICache.serverBanner.serverName.font), 1, loginUICache.serverBanner.serverName.font)
loginUICache.serverBanner.serverName.width = math.max(loginUICache.serverBanner.serverTitle.width, loginUICache.serverBanner.serverName.width + loginUICache.serverBanner.serverName.startX)
loginUICache.serverBanner.serverName.height = loginUICache.serverBanner.serverName.height + loginUICache.serverBanner.serverName.paddingY
loginUICache.serverBanner.serverName.startX = loginUICache.serverBanner.serverName.startX + loginUICache.serverBanner.serverLogo.startX + loginUICache.serverBanner.serverLogo.width
loginUICache.serverBanner.serverName.startY = loginUICache.serverBanner.serverName.startY + loginUICache.serverBanner.serverTitle.startY + loginUICache.serverBanner.serverTitle.height
for i, j in ipairs(loginUICache.optionUI) do
    loginUICache.optionUI.height = loginUICache.optionUI.height + loginUICache.optionUI.slotHeight + loginUICache.optionUI.slotPaddingY
    if loginUICache.phaseUI[i] then
        if j.optionType == "characters" then
            for k, v in pairs(serverCharacters) do
                table.insert(loginUICache.phaseUI[i].placeDataTable, k)
            end 
        else
            loginUICache.phaseUI[i].renderTarget = DxRenderTarget(loginUICache.phaseUI[i].width, loginUICache.phaseUI[i].height, true)
            if j.optionType == "socials" then
                local socials_discord_dataWidth, socials_social_dataWidth = (loginUICache.phaseUI[i].discordLinks.width*#loginUICache.phaseUI[i].discordLinks) + (loginUICache.phaseUI[i].discordLinks.paddingX*math.max(0, #loginUICache.phaseUI[i].discordLinks - 1)), (loginUICache.phaseUI[i].socialLinks.width*#loginUICache.phaseUI[i].socialLinks) + (loginUICache.phaseUI[i].socialLinks.paddingX*math.max(0, #loginUICache.phaseUI[i].socialLinks - 1))
                local socials_discord_startX, socials_social_startX = (loginUICache.phaseUI[i].width - socials_discord_dataWidth)/2, (loginUICache.phaseUI[i].width - socials_social_dataWidth)/2
                for k, v in ipairs(loginUICache.phaseUI[i].discordLinks) do
                    v.startX = socials_discord_startX + ((loginUICache.phaseUI[i].discordLinks.width + loginUICache.phaseUI[i].discordLinks.paddingX)*math.max(0, k - 1))
                end
                loginUICache.phaseUI[i].socialLinks.startY = loginUICache.phaseUI[i].socialLinks.startY + loginUICache.phaseUI[i].discordLinks.startY + loginUICache.phaseUI[i].discordLinks.height
                for k, v in ipairs(loginUICache.phaseUI[i].socialLinks) do
                    v.startX = socials_social_startX + ((loginUICache.phaseUI[i].socialLinks.width + loginUICache.phaseUI[i].socialLinks.paddingX)*math.max(0, k - 1))
                end
            elseif j.optionType == "credits" then
                local _, credits_dataHeight = dxGetTextSize(loginUICache.phaseUI[i].dataValue, loginUICache.phaseUI[i].width, loginUICache.phaseUI[i].fontScale, loginUICache.phaseUI[i].font)
                loginUICache.phaseUI[i].dataHeight = credits_dataHeight
                loginUICache.phaseUI[i].scrollDuration = math.max(1, math.ceil((credits_dataHeight + loginUICache.phaseUI[i].height)/loginUICache.phaseUI[i].height))*loginUICache.phaseUI[i].scrollDuration
            end
        end
    end
end
loginUICache.optionUI.height = math.max(0, loginUICache.optionUI.height - loginUICache.optionUI.slotPaddingY)
loginUICache.optionUI.startY = loginUICache.optionUI.startY + (loginUICache.serverBanner.startY + loginUICache.serverBanner.serverLogo.height) + ((sY - (loginUICache.serverBanner.startY + loginUICache.serverBanner.serverLogo.height) - loginUICache.optionUI.height)/2)