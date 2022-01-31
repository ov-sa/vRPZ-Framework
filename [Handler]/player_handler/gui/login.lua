----------------------------------------------------------------
--[[ Resource: Player Handler
     Script: gui: login.lua
     Author: vStudio
     Developer(s): Mario, Tron
     DOC: 31/01/2022
     Desc: Login UI Handler ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local imports = {
    ipairs = ipairs,
    isElement = isElement,
    addEvent = addEvent,
    addEventHandler = addEventHandler,
    triggerEvent = triggerEvent,
    setTimer = setTimer,
    dxCreateTexture = dxCreateTexture,
    dxSetRenderTarget = dxSetRenderTarget,
    dxDrawRectangle = dxDrawRectangle,
    dxDrawImage = dxDrawImage,
}


-------------------
--[[ Variables ]]--
-------------------

local prevLMBClickState = false
local prevPhaseTimer = false
local prevEnablerTimer = false
local createdTextures = {}
local inputTickCounter = CLIENT_CURRENT_TICK
local prevInputKey = false
local prevInputKeyStreak = 0
local _currentKeyCheck = true
local _currentPressedKey = false
setLoginUIPhase = nil
local manageCharacter, toggleUI = nil, nil
loginUI = {
    state = false,
    phase = false,
    isEnabled = false,
    isForcedDisabled = false,
    cinemationData = false,
    character = false,
    selectedCharacter = 0,
    clientCharacters = {},
    isPremium = false,
    phases = {
        [1] = {
            bgColor = {255, 255, 255, 255},
            bgPath = imports.dxCreateTexture("files/images/login/login/background.png", "argb", true, "clamp"),
            optionsui = {
                startX = CLIENT_MTA_RESOLUTION[1]*0.5,
                startY = -15,
                width = 0,
                height = 37,
                paddingY = 12,
                font = FRAMEWORK_FONTS[1],
                outlineWeight = 0.5,
                embedLineSize = 2,
                fontColor = {175, 175, 175, 100},
                hoverfontColor = {170, 35, 35, 255},
                embedLineColor = {170, 35, 35, 255},
                hoverAnimDuration = 2500,
                {
                    title = "P L A Y",
                    hoverStatus = "backward",
                    hoverAnimTickCounter = CLIENT_CURRENT_TICK,
                    execFunc = function() manageCharacter("play") end
                },
                {
                    title = "C H A R A C T E R",
                    hoverStatus = "backward",
                    hoverAnimTickCounter = CLIENT_CURRENT_TICK,
                    execFunc = function() setLoginUIPhase(2) end
                },
                {
                    title = "C R E D I T S",
                    hoverStatus = "backward",
                    hoverAnimTickCounter = CLIENT_CURRENT_TICK,
                    execFunc = function() setLoginUIPhase(3) end
                }
            }
        },
        [2] = {
            customizerui = {
                startX = 20,
                startY = -15,
                width = 325,
                height = 0,
                bgColor = {0, 0, 0, 240},
                titleBar = {
                    text = "C H A R A C T E R",
                    height = 30,
                    font = FRAMEWORK_FONTS[4],
                    dividerSize = 2,
                    outlineWeight = 0.25,
                    fontColor = {170, 35, 35, 255},
                    dividerColor = {0, 0, 0, 75},
                    bgColor = {0, 0, 0, 255},
                    leftCurvedEdgePath = imports.dxCreateTexture("files/images/hud/curved_square/top_left.png", "argb", true, "clamp"),
                    rightCurvedEdgePath = imports.dxCreateTexture("files/images/hud/curved_square/top_right.png", "argb", true, "clamp")
                },
                option = {
                    paddingY = 6,
                    height = 27,
                    font = FRAMEWORK_FONTS[5],
                    dividerSize = 2,
                    placeDataFontColor = {170, 35, 35, 255},
                    placeDataValueFontColor = {175, 175, 175, 255},
                    dividerColor = {0, 0, 0, 250},
                    bgColor = {7, 7, 7, 253},
                    arrowBGColor = {175, 175, 175, 100},
                    arrowHoveredBGColor = {255, 80, 80, 255},
                    arrowBGPath = beautify.assets["images"]["arrow/left.rw"],
                    arrowAnimDuration = 5000,
                    editbox = {
                        startX = 5,
                        startY = 5,
                        width = -10,
                        height = -10,
                        focussedEditbox = 0,
                        inputDelayDuration = 500,
                        embedLineSize = 1,
                        embedLineColor = {175, 175, 175, 100},
                        focussedEmbedLineColor = {170, 35, 35, 255},
                        hoverAnimDuration = 5000,
                        cursor = {
                            posNum = 0,
                            paddingX = 6,
                            paddingY = -1,
                            width = 2,
                            bgColor = {255, 80, 80, 255}
                        }
                    },
                    {
                        placeHolder = "FULL NAME",
                        placeDataValue = "",
                        isEditBox = true,
                        optionType = "name",
                        inputSettings = {
                            capsAllowed = true,
                            shiftAllowed = false,
                            rangeLimit = {1, 20},
                            validKeys = {"a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "space"}
                        }
                    },
                    {
                        placeHolder = "AGE",
                        placeDataValue = "",
                        isEditBox = true,
                        optionType = "age",
                        inputSettings = {
                            capsAllowed = false,
                            shiftAllowed = false,
                            rangeLimit = {1, 2},
                            validKeys = {"0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "num_0", "num_1", "num_2", "num_3", "num_4", "num_5", "num_6", "num_7", "num_8", "num_9"}
                        }
                    },
                    {
                        placeHolder = "GENDER",
                        placeDataValue = 1,
                        placeDataTable = {},
                        isEditBox = false,
                        optionType = "gender"
                    },
                    {
                        placeHolder = "RACE",
                        clothingCategoryIndex = "Race",
                        placeDataValue = 1,
                        placeDataTable = {},
                        isEditBox = false,
                        optionType = "race"
                    },
                    {
                        placeHolder = "HAIR",
                        clothingCategoryIndex = "Hair",
                        placeDataValue = 1,
                        placeDataTable = {},
                        isEditBox = false,
                        optionType = "hair"
                    },
                    {
                        placeHolder = "HAIR COLOR",
                        clothingCategoryIndex = "Hair_Color",
                        placeDataValue = 1,
                        placeDataTable = {},
                        isEditBox = false,
                        optionType = "hair_color"
                    },
                    {
                        placeHolder = "SHIRT",
                        clothingCategoryIndex = "Shirt",
                        placeDataValue = 1,
                        placeDataTable = {},
                        isEditBox = false,
                        optionType = "shirt"
                    },
                    {
                        placeHolder = "TROUSER",
                        clothingCategoryIndex = "Trouser",
                        placeDataValue = 1,
                        placeDataTable = {},
                        isEditBox = false,
                        optionType = "trouser"
                    },
                    {
                        placeHolder = "SHOES",
                        clothingCategoryIndex = "Shoes",
                        placeDataValue = 1,
                        placeDataTable = {},
                        isEditBox = false,
                        optionType = "shoes"
                    },
                    {
                        placeHolder = "SPAWN",
                        placeDataValue = 1,
                        placeDataTable = {},
                        isEditBox = false,
                        optionType = "spawn"
                    }
                },
                switcher = {
                    startX = -7,
                    startY = 0,
                    width = 30,
                    height = 30,
                    paddingX = 7,
                    paddingY = 7,
                    bgPath = imports.dxCreateTexture("files/images/hud/curved_square/square.png", "argb", true, "clamp"),
                    font = FRAMEWORK_FONTS[6],
                    outlineWeight = 0.1,
                    fontColor = {255, 80, 80, 255},
                    bgColor = {0, 0, 0, 255},
                    hoverfontColor = {0, 0, 0, 255},
                    hoverBGColor = {255, 80, 80, 255},
                    hoverAnimDuration = 2500,
                    {
                        title = "❮",
                        execFunc = function() manageCharacter("switch_prev") end
                    },
                    {
                        title = "❯",
                        execFunc = function() manageCharacter("switch_next") end
                    },
                    {
                        title = "X",
                        execFunc = function() manageCharacter("delete") end
                    },
                    {
                        title = "✎",
                        execFunc = function() manageCharacter("create") end
                    }
                },
                button = {
                    startX = 0,
                    startY = 5,
                    width = 103,
                    height = 30,
                    paddingX = 7,
                    paddingY = 0,
                    font = FRAMEWORK_FONTS[7],
                    outlineWeight = 0.25,
                    fontColor = {170, 35, 35, 235},
                    bgColor = {0, 0, 0, 235},
                    hoverfontColor = {175, 175, 175, 255},
                    hoverBGColor = {0, 0, 0, 255},
                    hoverAnimDuration = 2500,
                    leftCurvedEdgePath = imports.dxCreateTexture("files/images/hud/curved_square/left.png", "argb", true, "clamp"),
                    rightCurvedEdgePath = imports.dxCreateTexture("files/images/hud/curved_square/right.png", "argb", true, "clamp"),
                    {
                        title = "B A C K",
                        execFunc = function() setLoginUIPhase(1) end
                    },
                    {
                        title = "S A V E",
                        execFunc = function() manageCharacter("save") end
                    },
                    {
                        title = "P I C K",
                        execFunc = function() manageCharacter("pick") end
                    }
                }
            }
        },
        [3] = {
            bgColor = {255, 255, 255, 255},
            bgPath = imports.dxCreateTexture("files/images/login/credits/background.png", "argb", true, "clamp"),
            back_navigator = {
                title = "B A C K",
                startX = -15,
                startY = -20,
                width = 20,
                height = 0.25,
                font = FRAMEWORK_FONTS[2],
                outlineWeight = 0.75,
                fontColor = {0, 0, 0, 255},
                bgColor = {175, 175, 175, 255},
                leftEdgePath = imports.dxCreateTexture("files/images/hud/right_triangle/default.png", "argb", true, "clamp"),
                rightEdgePath = imports.dxCreateTexture("files/images/hud/right_triangle/flipped_inverted.png", "argb", true, "clamp"),
                hoverStatus = "backward",
                hoverAnimTickCounter = CLIENT_CURRENT_TICK,
                hoverAnimDuration = 1500,
                execFunc = function() setLoginUIPhase(1) end
            },
            view = {
                startX = 0,
                startY = 15,
                width = 0,
                height = -15,
                paddingX = 25,
                content = "",
                contentHeight = 100,
                font = FRAMEWORK_FONTS[3],
                outlineWeight = 2,
                fontColor = {100, 100, 100, 255},
                outlineColor = {0, 0, 0, 255},
                scrollAnimTickCounter = CLIENT_CURRENT_TICK,
                scrollDelayDuration = 1000,
                --scrollDelayDuration = loadingScreenCache.animFadeOutDuration + loadingScreenCache.animFadeDelayDuration - 1000,
                scrollAnimDuration = 5000,
            }
        }
    }
}

for i, j in imports.ipairs(loginUI.phases[1].optionsui) do
    j.width = dxGetTextWidth(j.title, 1, loginUI.phases[1].optionsui.font) + 5
    j.startX = loginUI.phases[1].optionsui.startX - (j.width/2)
    j.startY = loginUI.phases[1].optionsui.startY + CLIENT_MTA_RESOLUTION[2] - (loginUI.phases[1].optionsui.height*(#loginUI.phases[1].optionsui - (i - 1))) - (loginUI.phases[1].optionsui.paddingY*(#loginUI.phases[1].optionsui - i))
end
loginUI.phases[2].customizerui.height = loginUI.phases[2].customizerui.height + (#loginUI.phases[2].customizerui.option*(loginUI.phases[2].customizerui.option.height + loginUI.phases[2].customizerui.option.dividerSize))
loginUI.phases[2].customizerui.startY = CLIENT_MTA_RESOLUTION[2] + loginUI.phases[2].customizerui.startY - loginUI.phases[2].customizerui.titleBar.height - loginUI.phases[2].customizerui.height - (loginUI.phases[2].customizerui.switcher.startY + loginUI.phases[2].customizerui.switcher.paddingY + loginUI.phases[2].customizerui.button.height)
loginUI.phases[2].customizerui.switcher.startX = loginUI.phases[2].customizerui.switcher.startX + (loginUI.phases[2].customizerui.width - (#loginUI.phases[2].customizerui.switcher*loginUI.phases[2].customizerui.switcher.width) - math.max(0, (#loginUI.phases[2].customizerui.button - 1)*loginUI.phases[2].customizerui.switcher.paddingX))
loginUI.phases[2].customizerui.switcher.startY = loginUI.phases[2].customizerui.switcher.startY - loginUI.phases[2].customizerui.switcher.height - loginUI.phases[2].customizerui.switcher.paddingY
loginUI.phases[2].customizerui.button.startX = loginUI.phases[2].customizerui.button.startX + (loginUI.phases[2].customizerui.width - (#loginUI.phases[2].customizerui.button*loginUI.phases[2].customizerui.button.width) - math.max(0, (#loginUI.phases[2].customizerui.button - 1)*loginUI.phases[2].customizerui.button.paddingX))/2
loginUI.phases[2].customizerui.button.startY = loginUI.phases[2].customizerui.button.startY + loginUI.phases[2].customizerui.button.paddingY
loginUI.phases[3].back_navigator.height = loginUI.phases[3].back_navigator.height + dxGetFontHeight(1, loginUI.phases[3].back_navigator.font)
--[[
for i, j in imports.ipairs(serverCredits) do
    loginUI.phases[3].view.content = ((i == 1) and tostring(j)) or loginUI.phases[3].view.content.."\n\n"..tostring(j)
end
]]--
loginUI.phases[3].view.width, loginUI.phases[3].view.height = loginUI.phases[3].view.width + (CLIENT_MTA_RESOLUTION[1] - loginUI.phases[3].view.startX), loginUI.phases[3].view.height + (CLIENT_MTA_RESOLUTION[2] - loginUI.phases[3].view.startY)
loginUI.phases[3].view.contentWidth, loginUI.phases[3].view.contentHeight = dxGetTextSize(loginUI.phases[3].view.content, loginUI.phases[3].view.width, 1, loginUI.phases[3].view.font, false)
loginUI.phases[3].view.scrollAnimDuration = math.max(1, math.ceil((loginUI.phases[3].view.contentHeight + loginUI.phases[3].view.height)/loginUI.phases[3].view.height))*loginUI.phases[3].view.scrollAnimDuration
loginUI.phases[3].view.renderTarget = DxRenderTarget(loginUI.phases[3].view.width, loginUI.phases[3].view.height, true)
--[[
for i, j in imports.ipairs(playerClothes["Gender"]) do
    table.insert(loginUI.phases[2].customizerui.option[3].placeDataTable, j.modelType)
end
for i, j in pairs(playerSpawnPoints) do
    table.insert(loginUI.phases[2].customizerui.option[10].placeDataTable, i)
end
]]--


------------------------------------------------------------------
--[[ Functions: Loads/Updates/Manages Login Preview Character ]]--
------------------------------------------------------------------

local function loadLoginPreviewCharacter(loadDefault)

    if not loadDefault and not loginUI.clientCharacters[loginUI._selectedCharacter] then
        if #loginUI.clientCharacters > 0 then
            loginUI.selectedCharacter = 1
            loginUI._selectedCharacter = loginUI.selectedCharacter
        else
            loadDefault = true
        end
    end

    if loadDefault then
        for i, j in imports.ipairs(loginUI.phases[2].customizerui.option) do
            if j.isEditBox then
                j.placeDataValue = ""
            else
                j.placeDataValue = 1
            end
        end
    else
        for i, j in imports.ipairs(loginUI.phases[2].customizerui.option) do
            if j.isEditBox then
                j.placeDataValue = loginUI.clientCharacters[loginUI._selectedCharacter][j.optionType] or ""
            else
                local matchedDataIndex = false
                if j.optionType == "gender" or j.clothingCategoryIndex then
                    matchedDataIndex = loginUI.clientCharacters[loginUI._selectedCharacter][j.optionType]
                else
                    for k, v in imports.ipairs(j.placeDataTable) do
                        if loginUI.clientCharacters[loginUI._selectedCharacter][j.optionType] == v then
                            matchedDataIndex = k
                            break
                        end
                    end
                end
                j.placeDataValue = matchedDataIndex or 1
            end
        end
    end
    updateLoginPreviewCharacter()
    return true

end

function updateLoginPreviewCharacter()

    if not loginUI.character or not imports.isElement(loginUI.character) then return false end

    local disabledTextures = {}
    local selectedGender, selectedClothing = playerClothes["Gender"][(loginUI.phases[2].customizerui.option[3].placeDataValue)], {}
    loginUI.character:setModel(selectedGender.modelSkin)
    selectedClothing["gender"] = loginUI.phases[2].customizerui.option[3].placeDataValue
    for i, j in imports.ipairs(loginUI.phases[2].customizerui.option) do
        if not j.isEditBox and j.clothingCategoryIndex then
            if j.clothingCategoryIndex == "Race" then
                j.placeDataTable = playerClothes[selectedGender.modelType][j.clothingCategoryIndex]
            else
                if j.clothingCategoryIndex ~= "Hair" and j.clothingCategoryIndex ~= "Hair_Color" then
                    if loginUI.clientCharacters[loginUI._selectedCharacter] and loginUI.clientCharacters[loginUI._selectedCharacter].__isPreLoaded then
                        j.placeDataTable = playerClothes[selectedGender.modelType][j.clothingCategoryIndex]
                    else
                        local generatedDataTable = {}
                        for k, v in imports.ipairs(playerClothes[selectedGender.modelType][j.clothingCategoryIndex]) do
                            if v.isAvailableForCharacterCreation then
                                local copiedTable = table.copy(v, true)
                                copiedTable.isAvailableForCharacterCreation = nil
                                copiedTable.__dataIndex = k
                                table.insert(generatedDataTable, copiedTable)
                            end
                        end
                        j.placeDataTable = generatedDataTable
                    end
                end
            end
            if j.clothingCategoryIndex == "Race" then
                loginUI.phases[2].customizerui.option[5].placeDataTable = (j.placeDataTable[j.placeDataValue] and j.placeDataTable[j.placeDataValue]["Hair"]) or {}
                loginUI.phases[2].customizerui.option[6].placeDataTable = (j.placeDataTable[j.placeDataValue] and j.placeDataTable[j.placeDataValue]["Hair_Color"]) or {}
            end
            if not j.placeDataTable[j.placeDataValue] then j.placeDataValue = 1 end
            if j.placeDataTable[j.placeDataValue] then
                selectedClothing[j.optionType] = j.placeDataTable[j.placeDataValue].__dataIndex or j.placeDataValue
            end
        end
    end
    imports.triggerEvent("onSyncPedClothes", root, loginUI.character, selectedClothing)
    return true

end

manageCharacter = function(manageType)

    if not manageType then return false end

    if manageType == "create" then
        setLoginUIEnabled(true)
        local characterLimit = playerCharacterLimit
        if loginUI.isPremium then characterLimit = playerPremiumCharacterLimit end
        if #loginUI.clientCharacters >= characterLimit then
            imports.triggerEvent("Player:onNotification", localPlayer, "Unfortunately, you have reached the character creation limit!", {255, 80, 80, 255})
            return false
        end
        local characterData = {
            isUnverified = true
        }
        table.insert(loginUI.clientCharacters, characterData)
        loginUI._selectedCharacter = #loginUI.clientCharacters
        loginUI._unsavedCharacters[loginUI._selectedCharacter] = true
        loadLoginPreviewCharacter(true)
        imports.triggerEvent("Player:onNotification", localPlayer, "You've successfully created a character!", {80, 255, 80, 255})
    elseif manageType == "delete" then
        setLoginUIEnabled(true)
        if #loginUI.clientCharacters <= 0 then
            imports.triggerEvent("Player:onNotification", localPlayer, "Unfortunately, you don't have enough characters to delete!", {255, 80, 80, 255})
            return false
        end
        if not loginUI.clientCharacters[loginUI._selectedCharacter] then
            imports.triggerEvent("Player:onNotification", localPlayer, "You must select a character inorder to delete!", {255, 80, 80, 255})
            return false
        end
        if not loginUI.clientCharacters[loginUI._selectedCharacter].isUnverified or loginUI._charactersUnderProcess[loginUI._selectedCharacter] then
            if not loginUI.clientCharacters[loginUI._selectedCharacter]._id or loginUI._charactersUnderProcess[loginUI._selectedCharacter] then
                imports.triggerEvent("Player:onNotification", localPlayer, "You must wait until the character processing is done!", {255, 80, 80, 255})
                return false
            else
                triggerServerEvent("onClientCharacterDelete", localPlayer, loginUI.clientCharacters[loginUI._selectedCharacter]._id)
            end
        end
        table.remove(loginUI.clientCharacters, loginUI._selectedCharacter)
        loginUI._unsavedCharacters[loginUI._selectedCharacter] = nil
        loginUI._selectedCharacter = math.max(0, loginUI._selectedCharacter - 1)
        loadLoginPreviewCharacter()
        imports.triggerEvent("Player:onNotification", localPlayer, "You've successfully deleted the character!", {80, 255, 80, 255})
    elseif (manageType == "switch_prev") or (manageType == "switch_next") then
        setLoginUIEnabled(true)
        if #loginUI.clientCharacters <= 1 then
            imports.triggerEvent("Player:onNotification", localPlayer, "Unfortunately, you don't have enough characters to switch!", {255, 80, 80, 255})
            return false
        end
        if manageType == "switch_prev" then
            if loginUI._selectedCharacter > 1 then
                loginUI._selectedCharacter = loginUI._selectedCharacter - 1
                loadLoginPreviewCharacter()
            end
        elseif manageType == "switch_next" then
            if loginUI._selectedCharacter < #loginUI.clientCharacters then
                loginUI._selectedCharacter = loginUI._selectedCharacter + 1
                loadLoginPreviewCharacter()
            end
        end
    elseif manageType == "pick" then
        setLoginUIEnabled(true)
        if (loginUI._selectedCharacter ~= 0) and (loginUI.selectedCharacter == loginUI._selectedCharacter) then
            imports.triggerEvent("Player:onNotification", localPlayer, "You've already picked the specified character!", {255, 80, 80, 255})
            return false
        end
        if (not loginUI.clientCharacters[loginUI._selectedCharacter]) or loginUI.clientCharacters[loginUI._selectedCharacter].isUnverified then
            imports.triggerEvent("Player:onNotification", localPlayer, "You must save the character inorder to pick!", {255, 80, 80, 255})
            return false
        end
        loginUI.selectedCharacter = loginUI._selectedCharacter
        imports.triggerEvent("Player:onNotification", localPlayer, "You've successfully picked the character!", {80, 255, 80, 255})
    elseif manageType == "save" then
        if #loginUI.clientCharacters > 0 and not loginUI.clientCharacters[loginUI._selectedCharacter].isUnverified then
            setLoginUIEnabled(true)
            imports.triggerEvent("Player:onNotification", localPlayer, "Your character is already saved!", {255, 80, 80, 255})
            return false
        end
        local clientNameCounter = 0
        local clientAgeCounter = tonumber(loginUI.phases[2].customizerui.option[2].placeDataValue) or 0
        for _ in string.gmatch(loginUI.phases[2].customizerui.option[1].placeDataValue, "(%w+)%s*") do clientNameCounter = clientNameCounter + 1 end
        if clientNameCounter < FRAMEWORK_CONFIGS["UI"]["Login"].minimumCharacterNameWordCount then
            setLoginUIEnabled(true)
            imports.triggerEvent("Player:onNotification", localPlayer, "Please enter your full name!", {255, 80, 80, 255})
            return false
        end
        if clientAgeCounter < FRAMEWORK_CONFIGS["UI"]["Login"].minimumCharacterAge then
            setLoginUIEnabled(true)
            imports.triggerEvent("Player:onNotification", localPlayer, "Please enter a valid age! ["..FRAMEWORK_CONFIGS["UI"]["Login"].minimumCharacterAge.."+]", {255, 80, 80, 255})
            return false
        end
        setLoginUIEnabled(false, false)
        imports.triggerEvent("Player:onNotification", localPlayer, "◴ Saving..", {175, 175, 175, 255})
        local characterData = {}
        for i, j in imports.ipairs(loginUI.phases[2].customizerui.option) do
            if j.isEditBox then
                characterData[j.optionType] = j.placeDataValue
            else
                if j.optionType == "gender" or j.clothingCategoryIndex then
                    if j.placeDataTable[j.placeDataValue] then
                        characterData[j.optionType] = j.placeDataTable[j.placeDataValue].__dataIndex or j.placeDataValue
                    end
                else
                    characterData[j.optionType] = j.placeDataTable[j.placeDataValue]
                end
            end
        end
        local selectedCharacter = loginUI.selectedCharacter
        local charactersPendingToBeSaved = {}
        local charactersToBeSaved = table.copy(loginUI.clientCharacters, true)
        for i, j in imports.ipairs(charactersToBeSaved) do
            if j.isUnverified then
                charactersToBeSaved[i] = nil
            end
        end
        if #loginUI.clientCharacters <= 0 then
            selectedCharacter = 1
            loginUI._selectedCharacter = selectedCharacter
        end
        charactersPendingToBeSaved[loginUI._selectedCharacter] = true
        charactersToBeSaved[loginUI._selectedCharacter] = characterData
        loginUI._charactersUnderProcess[loginUI._selectedCharacter] = true
        triggerServerEvent("onClientCharacterSave", localPlayer, selectedCharacter, charactersToBeSaved, charactersPendingToBeSaved)
    elseif manageType == "play" then
        if #loginUI.clientCharacters <= 0 then
            setLoginUIEnabled(true)
            imports.triggerEvent("Player:onNotification", localPlayer, "You must create a character to play!", {255, 80, 80, 255})
            return false
        else
            if not loginUI.clientCharacters[loginUI.selectedCharacter] then
                setLoginUIEnabled(true)
                imports.triggerEvent("Player:onNotification", localPlayer, "You must pick a character to play!", {255, 80, 80, 255})
                return false
            end
        end
        setLoginUIEnabled(false, false)
        imports.triggerEvent("Player:onNotification", localPlayer, "◴ Processing..", {175, 175, 175, 255})
        imports.triggerEvent("Player:onHideLoadingUI", localPlayer)
        imports.setTimer(function()
            toggleUI(false)
        end, loadingScreenCache.animFadeInDuration + 250, 1)
        imports.setTimer(function(selectedCharacter, clientCharacters)
            triggerServerEvent("onPlayerResumeGame", localPlayer, selectedCharacter, clientCharacters)
        end, loadingScreenCache.animFadeInDuration + loadingScreenCache.animFadeOutDuration + loadingScreenCache.animFadeDelayDuration, 1, loginUI.selectedCharacter, loginUI.clientCharacters)
    end
    return true

end


--------------------------------------------------
--[[ Function: Retrieves Login Screen's State ]]--
--------------------------------------------------

function isLoginScreenVisible()

    return loginUI.state

end


-----------------------------------------------
--[[ Functions: Gets/Sets Login GUI's Phase ]]--
-----------------------------------------------

function getLoginUIPhase()

    return loginUI.phase

end

setLoginUIPhase = function(phaseID)

    phaseID = tonumber(phaseID)
    if not phaseID or not loginUI.phases[1].optionsui[phaseID] or (loginUI.phase and loginUI.phase == phaseID) then return false end
    if prevPhaseTimer and prevPhaseTimer:isValid() then prevPhaseTimer:destroy(); prevPhaseTimer = false end
    if prevEnablerTimer and prevEnablerTimer:isValid() then prevEnablerTimer:destroy(); prevEnablerTimer = false end

    imports.triggerEvent("Player:onHideLoadingUI", localPlayer)
    prevPhaseTimer = imports.setTimer(function()
        if phaseID == 1 then
            exports.cinecam_handler:startCinemation(loginUI.cinemationData.cinemationPoint, true, true, loginUI.cinemationData.cinemationFOV, true, true, true, false)
        elseif phaseID == 2 then
            if loginUI.character and imports.isElement(loginUI.character) then loginUI.character:destroy(); loginUI.character = false end
            exports.cinecam_handler:startCinemation(loginUI.cinemationData.characterCinemationPoint, true, true, loginUI.cinemationData.characterCinemationFOV, true, true, true, false)
            loginUI.character = Ped(0, loginUI.cinemationData.characterPoint.x, loginUI.cinemationData.characterPoint.y, loginUI.cinemationData.characterPoint.z, loginUI.cinemationData.characterPoint.rotation)
            loginUI.character:setDimension(FRAMEWORK_CONFIGS["UI"]["Login"].lobbyDimension)
            loginUI.character:setFrozen(true)
            loadLoginPreviewCharacter()
        else
            exports.cinecam_handler:stopCinemation()
            if phaseID == 3 then
                loginUI.phases[3].view.scrollAnimTickCounter = CLIENT_CURRENT_TICK
            end
        end
        loginUI.phase = phaseID
        local unverifiedCharacters = {}
        for i, j in imports.ipairs(loginUI.clientCharacters) do
            if j.isUnverified then
                table.insert(unverifiedCharacters, i)
            end
        end
        for i, j in imports.ipairs(loginUI.clientCharacters) do
            if j.isUnverified then
                table.remove(loginUI.clientCharacters, i)
                loginUI._unsavedCharacters[i] = nil
            end
        end
        for i, j in imports.ipairs(unverifiedCharacters) do
            if loginUI.selectedCharacter == j then
                loginUI.selectedCharacter = 0
                loginUI._selectedCharacter = 0
                break
            else
                if loginUI._selectedCharacter == j then
                    loginUI._selectedCharacter = 0
                end
            end
        end
        imports.triggerEvent("Player:onShowLoadingUI", localPlayer)
        prevPhaseTimer = false
    end, loadingScreenCache.animFadeInDuration + 250, 1)
    prevEnablerTimer = imports.setTimer(function()
        setLoginUIEnabled(true)
        prevEnablerTimer = false
    end, loadingScreenCache.animFadeOutDuration + loadingScreenCache.animFadeDelayDuration - (loadingScreenCache.animFadeInDuration + 250), 1)
    return true

end
imports.addEvent("onClientSetLoginUIPhase", true)
imports.addEventHandler("onClientSetLoginUIPhase", root, setLoginUIPhase)


----------------------------------------------
--[[ Function: Enables/Disables Login GUI ]]--
----------------------------------------------

function setLoginUIEnabled(state, forcedState)

    if prevEnablerTimer and prevEnablerTimer:isValid() then prevEnablerTimer:destroy(); prevEnablerTimer = false end
    
    if forcedState ~= nil then
        loginUI.isForcedDisabled = not forcedState
        loginUI.isEnabled = forcedState
    else
        loginUI.isEnabled = state
    end
    return true

end
imports.addEvent("onClientLoginUIEnable", true)
imports.addEventHandler("onClientLoginUIEnable", root, setLoginUIEnabled)


-------------------------------------------------------
--[[ Event: On Client Recieve Character Save State ]]--
-------------------------------------------------------

imports.addEvent("onClientRecieveCharacterSaveState", true)
imports.addEventHandler("onClientRecieveCharacterSaveState", root, function(state, errorMessage, character)

    if state then
        imports.triggerEvent("Player:onNotification", localPlayer, "You've successfully saved the character!", {80, 255, 80, 255})
    else
        if errorMessage then
            if character then
                loginUI._charactersUnderProcess[character] = nil
            end
            imports.triggerEvent("Player:onNotification", localPlayer, errorMessage, {255, 80, 80, 255})
        end
    end
    setLoginUIEnabled(true, true)

end)


--------------------------------------------
--[[ Event: On Client Load Character ID ]]--
--------------------------------------------

imports.addEvent("onClientLoadCharacterID", true)
imports.addEventHandler("onClientLoadCharacterID", root, function(character, characterID, characterData)

    character = tonumber(character); characterID = tonumber(characterID);
    if not character or not characterID or not characterData then return false end

    loginUI._unsavedCharacters[character] = nil
    loginUI._charactersUnderProcess[character] = nil
    loginUI.clientCharacters[character] = characterData
    loginUI.clientCharacters[character]._id = characterID

end)


-----------------------------------------
--[[ Events: On Client Character/Key ]]--
-----------------------------------------

imports.addEventHandler("onClientCharacter", root, function(character)

    if GuiElement.isMTAWindowActive() or not isLoginScreenVisible() or getLoginUIPhase() ~= 2 or not loginUI.isEnabled or loginUI.isForcedDisabled then return false end

    if _currentKeyCheck then
        _currentKeyCheck = false
        if character == " " then
            character = "space"
        end
        _currentPressedKey = character
    end

end)

imports.addEventHandler("onClientKey", root, function(button, press)

    if GuiElement.isMTAWindowActive() or not isLoginScreenVisible() or getLoginUIPhase() ~= 2 or not loginUI.isEnabled or loginUI.isForcedDisabled then return false end

    if (button == "lshift" or button == "rshift") then
        _currentPressedKey = false
    else
        if not press then
            if button == "tab" then
                if loginUI.phases[2].customizerui.option.editbox.focussedEditbox > 0 then
                    local nextEditboxIndex = false
                    local editboxIndex = {}
                    local currentEditbox = false
                    for i, j in imports.ipairs(loginUI.phases[2].customizerui.option) do
                        if j.isEditBox then
                            table.insert(editboxIndex, i)
                            if loginUI.phases[2].customizerui.option.editbox.focussedEditbox == i then
                                currentEditbox = #editboxIndex
                            end
                        end
                    end
                    if (getKeyState("lshift") or getKeyState("rshift")) then
                        if not editboxIndex[currentEditbox - 1] then
                            loginUI.phases[2].customizerui.option.editbox.focussedEditbox = editboxIndex[#editboxIndex]
                        else
                            loginUI.phases[2].customizerui.option.editbox.focussedEditbox = editboxIndex[currentEditbox - 1]
                        end
                    else
                        if not editboxIndex[currentEditbox + 1] then
                            loginUI.phases[2].customizerui.option.editbox.focussedEditbox = 1
                        else
                            loginUI.phases[2].customizerui.option.editbox.focussedEditbox = editboxIndex[currentEditbox + 1]
                        end
                    end
                    loginUI.phases[2].customizerui.option.editbox.cursor.posNum = string.len(loginUI.phases[2].customizerui.option[loginUI.phases[2].customizerui.option.editbox.focussedEditbox].placeDataValue)
                end
            elseif button == "home" then
                if loginUI.phases[2].customizerui.option.editbox.focussedEditbox > 0 then
                    loginUI.phases[2].customizerui.option.editbox.cursor.posNum = 0
                end
            elseif button == "end" then
                if loginUI.phases[2].customizerui.option.editbox.focussedEditbox > 0 then
                    loginUI.phases[2].customizerui.option.editbox.cursor.posNum = string.len(loginUI.phases[2].customizerui.option[loginUI.phases[2].customizerui.option.editbox.focussedEditbox].placeDataValue)
                end
            elseif string.find(button, "arrow") then
                if loginUI.phases[2].customizerui.option.editbox.focussedEditbox > 0 then
                    local fieldLength = string.len(loginUI.phases[2].customizerui.option[loginUI.phases[2].customizerui.option.editbox.focussedEditbox].placeDataValue)
                    if button == "arrow_l" then
                        if loginUI.phases[2].customizerui.option.editbox.cursor.posNum - 1 < 0 then
                            loginUI.phases[2].customizerui.option.editbox.cursor.posNum = fieldLength
                        else
                            loginUI.phases[2].customizerui.option.editbox.cursor.posNum = loginUI.phases[2].customizerui.option.editbox.cursor.posNum - 1
                        end
                    elseif button == "arrow_r" then
                        if loginUI.phases[2].customizerui.option.editbox.cursor.posNum + 1 > fieldLength then
                            loginUI.phases[2].customizerui.option.editbox.cursor.posNum = 0
                        else
                            loginUI.phases[2].customizerui.option.editbox.cursor.posNum = loginUI.phases[2].customizerui.option.editbox.cursor.posNum + 1
                        end
                    end
                end
            elseif (getKeyState("lshift") or getKeyState("rshift")) then
                _currentPressedKey = false
            end
        end
    end

end)


----------------------------------------
--[[ Function: Renders Login Screen ]]--
----------------------------------------

local function renderUI()

    if not loginUI.state or isPlayerInitialized(localPlayer) then return false end
    --local currentLoginPhase = getLoginUIPhase()
    --if not currentLoginPhase then return false end

    local isLMBClicked = false
    if not GuiElement.isMTAWindowActive() and loginUI.isEnabled and not loginUI.isForcedDisabled then
        if not prevLMBClickState then
            if getKeyState("mouse1") then
                isLMBClicked = true
                prevLMBClickState = true
            end
        else
            if not getKeyState("mouse1") then
                prevLMBClickState = false
            end
        end
    end

    if currentLoginPhase == 2 then
        setWeather(FRAMEWORK_CONFIGS["UI"]["Login"].characterScreenWeather)
        setTime(FRAMEWORK_CONFIGS["UI"]["Login"].characterScreenTime[1], FRAMEWORK_CONFIGS["UI"]["Login"].characterScreenTime[2])
    else
        setWeather(FRAMEWORK_CONFIGS["UI"]["Login"].weather)
        setTime(FRAMEWORK_CONFIGS["UI"]["Login"].time[1], FRAMEWORK_CONFIGS["UI"]["Login"].time[2])
    end
    local currentRatio = (CLIENT_MTA_RESOLUTION[1]/CLIENT_MTA_RESOLUTION[2])/(1366/768)
    local background_width, background_height = CLIENT_MTA_RESOLUTION[1], CLIENT_MTA_RESOLUTION[2]*currentRatio
    local background_offsetX, background_offsetY = 0, -(background_height - CLIENT_MTA_RESOLUTION[2])/2
    if background_offsetY > 0 then
        background_width, background_height = CLIENT_MTA_RESOLUTION[1]/currentRatio, CLIENT_MTA_RESOLUTION[2]
        background_offsetX, background_offsetY = -(background_width - CLIENT_MTA_RESOLUTION[1])/2, 0
    end

    if currentLoginPhase == 1 then
        --Draws Options UI
        imports.dxDrawImage(background_offsetX, background_offsetY, background_width, background_height, loginUI.phases[1].bgPath, 0, 0, 0, tocolor(unpack(loginUI.phases[1].bgColor)), false)
        for i, j in imports.ipairs(loginUI.phases[1].optionsui) do
            local options_offsetX, options_offsetY = j.startX, j.startY
            local option_width, option_height = j.width, loginUI.phases[1].optionsui.height
            local isOptionHovered = isMouseOnPosition(options_offsetX, options_offsetY, option_width, option_height)
            if isOptionHovered then
                if isLMBClicked then
                    setLoginUIEnabled(false)
                    imports.setTimer(function()
                        j.execFunc()
                    end, 1, 1)
                end
                if j.hoverStatus ~= "forward" then
                    j.hoverStatus = "forward"
                    j.hoverAnimTickCounter = CLIENT_CURRENT_TICK
                end
            else
                if j.hoverStatus ~= "backward" then
                    j.hoverStatus = "backward"
                    j.hoverAnimTickCounter = CLIENT_CURRENT_TICK
                end
            end
            if not j.animAlphaPercent then j.animAlphaPercent = 0 end
            if j.hoverStatus == "forward" then
                j.animAlphaPercent = interpolateBetween(j.animAlphaPercent, 0, 0, 1, 0, 0, getInterpolationProgress(j.hoverAnimTickCounter, loginUI.phases[1].optionsui.hoverAnimDuration), "Linear")
            else
                j.animAlphaPercent = interpolateBetween(j.animAlphaPercent, 0, 0, 0, 0, 0, getInterpolationProgress(j.hoverAnimTickCounter, loginUI.phases[1].optionsui.hoverAnimDuration), "Linear")
            end
            dxDrawBorderedText(loginUI.phases[1].optionsui.outlineWeight, loginUI.phases[1].optionsui.fontColor, j.title, options_offsetX, options_offsetY, options_offsetX + option_width, options_offsetY + option_height, tocolor(unpack(loginUI.phases[1].optionsui.fontColor)), 1, loginUI.phases[1].optionsui.font, "center", "center", true, false, false)
            dxDrawBorderedText(loginUI.phases[1].optionsui.outlineWeight, {loginUI.phases[1].optionsui.hoverfontColor[1], loginUI.phases[1].optionsui.hoverfontColor[2], loginUI.phases[1].optionsui.hoverfontColor[3], loginUI.phases[1].optionsui.hoverfontColor[4]*j.animAlphaPercent}, j.title, options_offsetX, options_offsetY, options_offsetX + option_width, options_offsetY + option_height, tocolor(loginUI.phases[1].optionsui.hoverfontColor[1], loginUI.phases[1].optionsui.hoverfontColor[2], loginUI.phases[1].optionsui.hoverfontColor[3], loginUI.phases[1].optionsui.hoverfontColor[4]*j.animAlphaPercent), 1, loginUI.phases[1].optionsui.font, "center", "center", true, false, false)
            imports.dxDrawRectangle(options_offsetX, options_offsetY + option_height, option_width*j.animAlphaPercent, loginUI.phases[1].optionsui.embedLineSize, tocolor(unpack(loginUI.phases[1].optionsui.embedLineColor)), false)
        end
    elseif currentLoginPhase == 2 then
        --Draws Character UI
        local customizer_offsetX, customizer_offsetY = loginUI.phases[2].customizerui.startX, loginUI.phases[2].customizerui.startY
        imports.dxDrawRectangle(customizer_offsetX + loginUI.phases[2].customizerui.titleBar.height, customizer_offsetY, loginUI.phases[2].customizerui.width - (loginUI.phases[2].customizerui.titleBar.height*2), loginUI.phases[2].customizerui.titleBar.height, tocolor(unpack(loginUI.phases[2].customizerui.titleBar.bgColor)), false)
        imports.dxDrawImage(customizer_offsetX, customizer_offsetY, loginUI.phases[2].customizerui.titleBar.height, loginUI.phases[2].customizerui.titleBar.height, loginUI.phases[2].customizerui.titleBar.leftCurvedEdgePath, 0, 0, 0, tocolor(unpack(loginUI.phases[2].customizerui.titleBar.bgColor)), false)
        imports.dxDrawImage(customizer_offsetX + loginUI.phases[2].customizerui.width - loginUI.phases[2].customizerui.titleBar.height, customizer_offsetY, loginUI.phases[2].customizerui.titleBar.height, loginUI.phases[2].customizerui.titleBar.height, loginUI.phases[2].customizerui.titleBar.rightCurvedEdgePath, 0, 0, 0, tocolor(unpack(loginUI.phases[2].customizerui.titleBar.bgColor)), false)
        dxDrawBorderedText(loginUI.phases[2].customizerui.titleBar.outlineWeight, loginUI.phases[2].customizerui.titleBar.fontColor, loginUI.phases[2].customizerui.titleBar.text, customizer_offsetX, customizer_offsetY, customizer_offsetX + loginUI.phases[2].customizerui.width, customizer_offsetY + loginUI.phases[2].customizerui.titleBar.height, tocolor(unpack(loginUI.phases[2].customizerui.titleBar.fontColor)), 1, loginUI.phases[2].customizerui.titleBar.font, "center", "center", true, false, false)
        customizer_offsetY = customizer_offsetY + loginUI.phases[2].customizerui.titleBar.height
        local isOptionEditBoxClicked = false
        for i, j in imports.ipairs(loginUI.phases[2].customizerui.option) do
            local option_offsetX, option_offsetY = customizer_offsetX, customizer_offsetY
            local option_width, option_height = loginUI.phases[2].customizerui.width, loginUI.phases[2].customizerui.option.height
            if not j.isEditBox then
                local isLeftArrowHovered = isMouseOnPosition(option_offsetX + loginUI.phases[2].customizerui.option.paddingY, option_offsetY + (loginUI.phases[2].customizerui.option.paddingY/2), option_height - loginUI.phases[2].customizerui.option.paddingY, option_height - loginUI.phases[2].customizerui.option.paddingY) and (#loginUI.clientCharacters <= 0 or loginUI.clientCharacters[loginUI._selectedCharacter].isUnverified)
                local isRightArrowHovered = isMouseOnPosition(option_offsetX + option_width - option_height, option_offsetY + (loginUI.phases[2].customizerui.option.paddingY/2), option_height - loginUI.phases[2].customizerui.option.paddingY, option_height - loginUI.phases[2].customizerui.option.paddingY) and (#loginUI.clientCharacters <= 0 or loginUI.clientCharacters[loginUI._selectedCharacter].isUnverified)
                if not j.leftArrowAnimStatus then j.leftArrowAnimStatus = "backward" end
                if not j.leftArrowAnimTickCounter then j.leftArrowAnimTickCounter = CLIENT_CURRENT_TICK end
                if not j.rightArrowAnimStatus then j.rightArrowAnimStatus = "backward" end
                if not j.rightArrowAnimTickCounter then j.rightArrowAnimTickCounter = CLIENT_CURRENT_TICK end
                if isLeftArrowHovered then
                    if j.leftArrowAnimStatus ~= "forward" then
                        j.leftArrowAnimStatus = "forward"
                        j.leftArrowAnimTickCounter = CLIENT_CURRENT_TICK
                    end
                    if isLMBClicked then
                        if j.placeDataValue > 1 then
                            j.placeDataValue = j.placeDataValue - 1
                            updateLoginPreviewCharacter()
                        end
                    end
                else
                    if j.leftArrowAnimStatus ~= "backward" then
                        j.leftArrowAnimStatus = "backward"
                        j.leftArrowAnimTickCounter = CLIENT_CURRENT_TICK
                    end
                end
                if isRightArrowHovered then
                    if j.rightArrowAnimStatus ~= "forward" then
                        j.rightArrowAnimStatus = "forward"
                        j.rightArrowAnimTickCounter = CLIENT_CURRENT_TICK
                    end
                    if isLMBClicked then
                        if j.placeDataValue < #j.placeDataTable then
                            j.placeDataValue = j.placeDataValue + 1
                            updateLoginPreviewCharacter()
                        end
                    end
                else
                    if j.rightArrowAnimStatus ~= "backward" then
                        j.rightArrowAnimStatus = "backward"
                        j.rightArrowAnimTickCounter = CLIENT_CURRENT_TICK
                    end
                end
                if not j.leftArrowAnimAlphaPercent then j.leftArrowAnimAlphaPercent = 0 end
                if not j.rightArrowAnimAlphaPercent then j.rightArrowAnimAlphaPercent = 0 end
                if j.leftArrowAnimStatus == "forward" then
                    j.leftArrowAnimAlphaPercent = interpolateBetween(j.leftArrowAnimAlphaPercent, 0, 0, 1, 0, 0, getInterpolationProgress(j.leftArrowAnimTickCounter, loginUI.phases[2].customizerui.option.arrowAnimDuration), "Linear")
                elseif j.leftArrowAnimStatus == "backward" then
                    j.leftArrowAnimAlphaPercent = interpolateBetween(j.leftArrowAnimAlphaPercent, 0, 0, 0, 0, 0, getInterpolationProgress(j.leftArrowAnimTickCounter, loginUI.phases[2].customizerui.option.arrowAnimDuration), "Linear")
                end
                if j.rightArrowAnimStatus == "forward" then
                    j.rightArrowAnimAlphaPercent = interpolateBetween(j.rightArrowAnimAlphaPercent, 0, 0, 1, 0, 0, getInterpolationProgress(j.rightArrowAnimTickCounter, loginUI.phases[2].customizerui.option.arrowAnimDuration), "Linear")
                elseif j.rightArrowAnimStatus == "backward" then
                    j.rightArrowAnimAlphaPercent = interpolateBetween(j.rightArrowAnimAlphaPercent, 0, 0, 0, 0, 0, getInterpolationProgress(j.rightArrowAnimTickCounter, loginUI.phases[2].customizerui.option.arrowAnimDuration), "Linear")
                end
            else
                local isEditboxHovered = isMouseOnPosition(option_offsetX, option_offsetY, option_width, option_height) and (#loginUI.clientCharacters <= 0 or loginUI.clientCharacters[loginUI._selectedCharacter].isUnverified)
                if not j.hoverAnimStatus then j.hoverAnimStatus = "backward" end
                if not j.hoverAnimTickCounter then j.hoverAnimTickCounter = CLIENT_CURRENT_TICK end
                if #loginUI.clientCharacters > 0 and not loginUI.clientCharacters[loginUI._selectedCharacter].isUnverified then loginUI.phases[2].customizerui.option.editbox.focussedEditbox = 0 end
                if isEditboxHovered then
                    if isLMBClicked then
                        if (loginUI.phases[2].customizerui.option.editbox.focussedEditbox ~= i) then
                            loginUI.phases[2].customizerui.option.editbox.focussedEditbox = i
                            loginUI.phases[2].customizerui.option.editbox.cursor.posNum = string.len(j.placeDataValue)
                        end
                        isOptionEditBoxClicked = true
                    end
                    if j.hoverAnimStatus ~= "forward" then
                        j.hoverAnimStatus = "forward"
                        j.hoverAnimTickCounter = CLIENT_CURRENT_TICK
                    end
                else
                    if loginUI.phases[2].customizerui.option.editbox.focussedEditbox == i then
                        if j.hoverAnimStatus ~= "forward" then
                            j.hoverAnimStatus = "forward"
                            j.hoverAnimTickCounter = CLIENT_CURRENT_TICK
                        end
                    else
                        if j.hoverAnimStatus ~= "backward" then
                            j.hoverAnimStatus = "backward"
                            j.hoverAnimTickCounter = CLIENT_CURRENT_TICK
                        end
                    end
                end
                if not j.embedLineAlphaPercent then j.embedLineAlphaPercent = 0 end
                if j.hoverAnimStatus == "forward" then
                    j.embedLineAlphaPercent = interpolateBetween(j.embedLineAlphaPercent, 0, 0, 1, 0, 0, getInterpolationProgress(j.hoverAnimTickCounter, loginUI.phases[2].customizerui.option.editbox.hoverAnimDuration), "Linear")
                elseif j.hoverAnimStatus == "backward" then
                    j.embedLineAlphaPercent = interpolateBetween(j.embedLineAlphaPercent, 0, 0, 0, 0, 0, getInterpolationProgress(j.hoverAnimTickCounter, loginUI.phases[2].customizerui.option.editbox.hoverAnimDuration), "Linear")
                end
            end
            imports.dxDrawRectangle(option_offsetX, option_offsetY, option_width, option_height, tocolor(unpack(loginUI.phases[2].customizerui.option.bgColor)), false)
            customizer_offsetY = customizer_offsetY + option_height + loginUI.phases[2].customizerui.option.dividerSize
            imports.dxDrawRectangle(option_offsetX, customizer_offsetY - loginUI.phases[2].customizerui.option.dividerSize, option_width, loginUI.phases[2].customizerui.option.dividerSize, tocolor(unpack(loginUI.phases[2].customizerui.option.dividerColor)), false)
            if not j.isEditBox then
                local option_slotWidth, option_slotHeight = (option_width - (option_height*2) - (loginUI.phases[2].customizerui.option.paddingY*2))/2, option_height - loginUI.phases[2].customizerui.option.paddingY
                local option_slotOffsetY = option_offsetY + (loginUI.phases[2].customizerui.option.paddingY/2)
                local option_left_slotOffsetX = option_offsetX + option_height + (loginUI.phases[2].customizerui.option.paddingY/2)
                local option_right_slotOffsetX = option_left_slotOffsetX + option_slotWidth + (loginUI.phases[2].customizerui.option.paddingY)
                local option_fieldText = j.placeDataValue
                if j.placeDataValue and j.placeDataTable then option_fieldText = j.placeDataTable[j.placeDataValue] or option_fieldText end
                if j.placeDataTable[j.placeDataValue] and j.clothingCategoryIndex then option_fieldText = j.placeDataTable[j.placeDataValue].clothingName or j.placeDataValue end
                imports.dxDrawImage(option_offsetX + loginUI.phases[2].customizerui.option.paddingY, option_offsetY + (loginUI.phases[2].customizerui.option.paddingY/2), option_height - loginUI.phases[2].customizerui.option.paddingY, option_height - loginUI.phases[2].customizerui.option.paddingY, loginUI.phases[2].customizerui.option.arrowBGPath, 0, 0, 0, tocolor(loginUI.phases[2].customizerui.option.arrowBGColor[1], loginUI.phases[2].customizerui.option.arrowBGColor[2], loginUI.phases[2].customizerui.option.arrowBGColor[3], loginUI.phases[2].customizerui.option.arrowBGColor[4]), false)
                imports.dxDrawImage(option_offsetX + loginUI.phases[2].customizerui.option.paddingY, option_offsetY + (loginUI.phases[2].customizerui.option.paddingY/2), option_height - loginUI.phases[2].customizerui.option.paddingY, option_height - loginUI.phases[2].customizerui.option.paddingY, loginUI.phases[2].customizerui.option.arrowBGPath, 0, 0, 0, tocolor(loginUI.phases[2].customizerui.option.arrowHoveredBGColor[1], loginUI.phases[2].customizerui.option.arrowHoveredBGColor[2], loginUI.phases[2].customizerui.option.arrowHoveredBGColor[3], loginUI.phases[2].customizerui.option.arrowHoveredBGColor[4]*j.leftArrowAnimAlphaPercent), false)
                imports.dxDrawImage(option_offsetX + option_width - option_height, option_offsetY + (loginUI.phases[2].customizerui.option.paddingY/2), option_height - loginUI.phases[2].customizerui.option.paddingY, option_height - loginUI.phases[2].customizerui.option.paddingY, loginUI.phases[2].customizerui.option.arrowBGPath, 180, 0, 0, tocolor(loginUI.phases[2].customizerui.option.arrowBGColor[1], loginUI.phases[2].customizerui.option.arrowBGColor[2], loginUI.phases[2].customizerui.option.arrowBGColor[3], loginUI.phases[2].customizerui.option.arrowBGColor[4]), false)
                imports.dxDrawImage(option_offsetX + option_width - option_height, option_offsetY + (loginUI.phases[2].customizerui.option.paddingY/2), option_height - loginUI.phases[2].customizerui.option.paddingY, option_height - loginUI.phases[2].customizerui.option.paddingY, loginUI.phases[2].customizerui.option.arrowBGPath, 180, 0, 0, tocolor(loginUI.phases[2].customizerui.option.arrowHoveredBGColor[1], loginUI.phases[2].customizerui.option.arrowHoveredBGColor[2], loginUI.phases[2].customizerui.option.arrowHoveredBGColor[3], loginUI.phases[2].customizerui.option.arrowHoveredBGColor[4]*j.rightArrowAnimAlphaPercent), false)
                dxDrawText(j.placeHolder..":", option_left_slotOffsetX, option_slotOffsetY, option_left_slotOffsetX + option_slotWidth, option_slotOffsetY + option_slotHeight, tocolor(unpack(loginUI.phases[2].customizerui.option.placeDataFontColor)), 1, loginUI.phases[2].customizerui.option.font, "right", "center", true, false, false)
                dxDrawText(option_fieldText, option_right_slotOffsetX, option_slotOffsetY, option_right_slotOffsetX + option_slotWidth, option_slotOffsetY + option_slotHeight, tocolor(unpack(loginUI.phases[2].customizerui.option.placeDataValueFontColor)), 1, loginUI.phases[2].customizerui.option.font, "left", "center", true, false, false)
            else
                local option_slotWidth, option_slotHeight = option_width - (option_height*2) - (loginUI.phases[2].customizerui.option.paddingY*2) + loginUI.phases[2].customizerui.option.editbox.width, option_height - loginUI.phases[2].customizerui.option.paddingY + loginUI.phases[2].customizerui.option.editbox.height
                local option_slotOffsetX, option_slotOffsetY = option_offsetX + option_height + loginUI.phases[2].customizerui.option.paddingY + loginUI.phases[2].customizerui.option.editbox.startX, option_offsetY + (loginUI.phases[2].customizerui.option.paddingY/2) + loginUI.phases[2].customizerui.option.editbox.startY
                local fieldText = j.placeDataValue
                local fieldLength = string.len(fieldText)
                if j.censored then
                    local censored = ""
                    for k=1, fieldLength, 1 do
                        censored = censored.."*"
                    end
                    fieldText = censored
                end
                if (loginUI.phases[2].customizerui.option.editbox.focussedEditbox ~= i) then
                    dxDrawText((string.len(j.placeDataValue) <= 0 and j.placeHolder) or fieldText, option_slotOffsetX, option_slotOffsetY, option_slotOffsetX + option_slotWidth, option_slotOffsetY + option_slotHeight, (string.len(j.placeDataValue) <= 0 and tocolor(unpack(loginUI.phases[2].customizerui.option.placeDataFontColor))) or tocolor(unpack(loginUI.phases[2].customizerui.option.placeDataValueFontColor)), 1, loginUI.phases[2].customizerui.option.font, "center", "center", true, false, false)
                else
                    local horizontalShift = 0
                    local fieldWidth = dxGetTextWidth(fieldText, 1, loginUI.phases[2].customizerui.option.font)
                    local fieldX_offset = option_slotOffsetX + ((option_slotWidth + fieldWidth)/2) - fieldWidth
                    if fieldWidth >= option_slotWidth then
                        fieldX_offset = option_slotOffsetX + option_slotWidth - fieldWidth
                    end
                    local firstString = string.sub(fieldText, 1, loginUI.phases[2].customizerui.option.editbox.cursor.posNum)
                    local secondString = string.sub(fieldText, loginUI.phases[2].customizerui.option.editbox.cursor.posNum + 1, fieldLength)
                    local cursor_equivalentPadding = ""
                    local cursorX_offset = fieldX_offset + dxGetTextWidth(firstString, 1, loginUI.phases[2].customizerui.option.font)
                    local cursorX_startBounding = option_slotOffsetX
                    local cursorX_endBounding = cursorX_startBounding + option_slotWidth
                    while dxGetTextWidth(cursor_equivalentPadding, 1, loginUI.phases[2].customizerui.option.font) < loginUI.phases[2].customizerui.option.editbox.cursor.paddingX do
                        cursor_equivalentPadding = cursor_equivalentPadding.." "
                    end
                    if cursorX_offset < cursorX_startBounding then cursorX_offset = cursorX_startBounding end
                    if cursorX_offset > cursorX_endBounding then cursorX_offset = cursorX_endBounding end
                    if fieldWidth >= option_slotWidth then
                        if loginUI.phases[2].customizerui.option.editbox.cursor.posNum == fieldLength then
                            dxDrawText(firstString, option_slotOffsetX, option_slotOffsetY, option_slotOffsetX + option_slotWidth, option_slotOffsetY + option_slotHeight, tocolor(unpack(loginUI.phases[2].customizerui.option.placeDataValueFontColor)), 1, loginUI.phases[2].customizerui.option.font, "right", "center", true, false, false)
                            imports.dxDrawRectangle(cursorX_offset + (loginUI.phases[2].customizerui.option.editbox.cursor.paddingX/3), option_slotOffsetY + loginUI.phases[2].customizerui.option.editbox.cursor.paddingY, loginUI.phases[2].customizerui.option.editbox.cursor.width, option_slotHeight - (loginUI.phases[2].customizerui.option.editbox.cursor.paddingY*2), tocolor(unpack(loginUI.phases[2].customizerui.option.editbox.cursor.bgColor)), false)
                        else
                            local equivalentSpace = ""
                            local secondStringLength = string.len(secondString)
                            local secondStringWidth = dxGetTextWidth(secondString, 1, loginUI.phases[2].customizerui.option.font)
                            local generatedText = firstString..cursor_equivalentPadding..secondString
                            if secondStringWidth > option_slotWidth then
                                horizontalShift = secondStringWidth - option_slotWidth + (option_slotWidth/3)
                            end
                            if horizontalShift > 0 then
                                local extraCharacters = 1
                                while dxGetTextWidth(string.sub(secondString, 1, extraCharacters), 1, loginUI.phases[2].customizerui.option.font) <= horizontalShift do
                                    extraCharacters = extraCharacters + 1
                                end
                                local _firstString = string.sub(secondString, 1, secondStringLength - extraCharacters)
                                local _secondString = string.sub(secondString, secondStringLength - extraCharacters + 1, secondStringLength)
                                while dxGetTextWidth(equivalentSpace, 1, loginUI.phases[2].customizerui.option.font) < dxGetTextWidth(_secondString, 1, loginUI.phases[2].customizerui.option.font) do
                                    equivalentSpace = equivalentSpace.." "
                                end
                                generatedText = firstString..cursor_equivalentPadding.._firstString..equivalentSpace
                                fieldWidth = dxGetTextWidth(generatedText, 1, loginUI.phases[2].customizerui.option.font)
                                fieldX_offset = option_slotOffsetX + option_slotWidth - fieldWidth + dxGetTextWidth(equivalentSpace, 1, loginUI.phases[2].customizerui.option.font)
                                cursorX_offset = fieldX_offset + dxGetTextWidth(firstString, 1, loginUI.phases[2].customizerui.option.font) + loginUI.phases[2].customizerui.option.editbox.cursor.paddingX
                            end
                            dxDrawText(generatedText, option_slotOffsetX, option_slotOffsetY, option_slotOffsetX + option_slotWidth, option_slotOffsetY + option_slotHeight, tocolor(unpack(loginUI.phases[2].customizerui.option.placeDataValueFontColor)), 1, loginUI.phases[2].customizerui.option.font, "right", "center", true, false, false)
                            imports.dxDrawRectangle(cursorX_offset - (loginUI.phases[2].customizerui.option.editbox.cursor.paddingX/2), option_slotOffsetY + loginUI.phases[2].customizerui.option.editbox.cursor.paddingY, loginUI.phases[2].customizerui.option.editbox.cursor.width, option_slotHeight - (loginUI.phases[2].customizerui.option.editbox.cursor.paddingY*2), tocolor(unpack(loginUI.phases[2].customizerui.option.editbox.cursor.bgColor)), false)
                        end
                    else
                        if loginUI.phases[2].customizerui.option.editbox.cursor.posNum == fieldLength then
                            dxDrawText(firstString, option_slotOffsetX, option_slotOffsetY, option_slotOffsetX + option_slotWidth, option_slotOffsetY + option_slotHeight, tocolor(unpack(loginUI.phases[2].customizerui.option.placeDataValueFontColor)), 1, loginUI.phases[2].customizerui.option.font, "center", "center", true, false, false)
                            imports.dxDrawRectangle(cursorX_offset + (loginUI.phases[2].customizerui.option.editbox.cursor.paddingX/3), option_slotOffsetY + loginUI.phases[2].customizerui.option.editbox.cursor.paddingY, loginUI.phases[2].customizerui.option.editbox.cursor.width, option_slotHeight - (loginUI.phases[2].customizerui.option.editbox.cursor.paddingY*2), tocolor(unpack(loginUI.phases[2].customizerui.option.editbox.cursor.bgColor)), false)
                        else
                            dxDrawText(firstString..cursor_equivalentPadding..secondString, option_slotOffsetX, option_slotOffsetY, option_slotOffsetX + option_slotWidth, option_slotOffsetY + option_slotHeight, tocolor(unpack(loginUI.phases[2].customizerui.option.placeDataValueFontColor)), 1, loginUI.phases[2].customizerui.option.font, "center", "center", true, false, false)
                            imports.dxDrawRectangle(cursorX_offset, option_slotOffsetY + loginUI.phases[2].customizerui.option.editbox.cursor.paddingY, loginUI.phases[2].customizerui.option.editbox.cursor.width, option_slotHeight - (loginUI.phases[2].customizerui.option.editbox.cursor.paddingY*2), tocolor(unpack(loginUI.phases[2].customizerui.option.editbox.cursor.bgColor)), false)
                        end
                    end
                    if isOptionEditBoxClicked then
                        local clickedX = getAbsoluteCursorPosition()
                        local _inputCursorX = 0
                        for i=1, fieldLength, 1 do
                            local _fieldX = fieldX_offset + dxGetTextWidth(string.sub(fieldText, 1, i), 1, loginUI.phases[2].customizerui.option.font) - (loginUI.phases[2].customizerui.option.editbox.cursor.width*2)
                            if horizontalShift > 0 then
                                _fieldX = fieldX_offset + dxGetTextWidth(string.sub(fieldText, 1, i), 1, loginUI.phases[2].customizerui.option.font) + loginUI.phases[2].customizerui.option.editbox.cursor.width
                            end
                            if clickedX >= _fieldX then
                                _inputCursorX = i
                            else
                                break
                            end
                        end
                        loginUI.phases[2].customizerui.option.editbox.cursor.posNum = _inputCursorX
                    end
                    if not GuiElement.isMTAWindowActive() and loginUI.isEnabled and not loginUI.isForcedDisabled then
                        local currentPressedKey = false
                        if getKeyState("backspace") then
                            currentPressedKey = "backspace"
                        elseif getKeyState("delete") then
                            currentPressedKey = "delete"
                        else
                            if _currentPressedKey and j.inputSettings then
                                if j.inputSettings.validKeys then
                                    if getKeyState("lshift") or getKeyState("rshift") then
                                        local customKey, isKeyValid = _currentPressedKey, false
                                        if j.inputSettings.shiftAllowed then
                                            for k, v in imports.ipairs(j.inputSettings.validKeys) do
                                                if v == customKey then
                                                    isKeyValid = true
                                                    break
                                                end
                                            end
                                            if isKeyValid then currentPressedKey = customKey end
                                        else
                                            customKey = false
                                            for k, v in imports.ipairs(j.inputSettings.validKeys) do
                                                if getKeyState(v) then
                                                    customKey = v:gsub("num_", "")
                                                    customKey = customKey:gsub("space", "")
                                                    break
                                                end
                                            end
                                        end
                                        if not isKeyValid and customKey and j.inputSettings.capsAllowed then
                                            for k, v in imports.ipairs(j.inputSettings.validKeys) do
                                                if v == customKey then
                                                    isKeyValid = true
                                                    break
                                                end
                                            end
                                            if isKeyValid then currentPressedKey = string.upper(customKey) end
                                        end
                                    else
                                        for k, v in imports.ipairs(j.inputSettings.validKeys) do
                                            if getKeyState(v) then
                                                currentPressedKey = v:gsub("num_", "")
                                                break
                                            end
                                        end
                                    end
                                    if currentPressedKey and (string.lower(_currentPressedKey) == string.lower(currentPressedKey)) then
                                        if j.inputSettings.capsAllowed then
                                            if string.upper(currentPressedKey) == _currentPressedKey then
                                                currentPressedKey = _currentPressedKey
                                            end
                                        end
                                    else
                                        currentPressedKey = false
                                    end
                                end
                            end
                        end
                        if not currentPressedKey then
                            prevInputKey = false
                            prevInputKeyStreak = 0
                        else
                            local isOnDelay = false
                            if prevInputKey and prevInputKey == currentPressedKey then
                                if prevInputKeyStreak < 1 and (loginUI.phases[2].customizerui.option.editbox.inputDelayDuration - CLIENT_CURRENT_TICK + inputTickCounter) >= 0 then
                                    isOnDelay = true
                                else
                                    prevInputKeyStreak = prevInputKeyStreak + 1
                                end
                            else
                                prevInputKeyStreak = 0
                            end
                            if not isOnDelay then
                                local _firstString = string.sub(j.placeDataValue, 1, loginUI.phases[2].customizerui.option.editbox.cursor.posNum)
                                local _secondString = string.sub(j.placeDataValue, loginUI.phases[2].customizerui.option.editbox.cursor.posNum + 1, string.len(j.placeDataValue))
                                if currentPressedKey == "backspace" then
                                    j.placeDataValue = string.sub(_firstString, 1, string.len(_firstString) - 1).._secondString
                                    loginUI.phases[2].customizerui.option.editbox.cursor.posNum = loginUI.phases[2].customizerui.option.editbox.cursor.posNum - 1
                                    if loginUI.phases[2].customizerui.option.editbox.cursor.posNum < 0 then loginUI.phases[2].customizerui.option.editbox.cursor.posNum = 0 end
                                elseif currentPressedKey == "delete" then
                                    j.placeDataValue = _firstString..string.sub(_secondString, 2, string.len(_secondString))
                                else
                                    if j.inputSettings and j.inputSettings.rangeLimit and (string.len(j.placeDataValue) < j.inputSettings.rangeLimit[2]) then
                                        j.placeDataValue = _firstString..currentPressedKey:gsub("space", " ").._secondString
                                        loginUI.phases[2].customizerui.option.editbox.cursor.posNum = loginUI.phases[2].customizerui.option.editbox.cursor.posNum + 1
                                        local _fieldLength = string.len(j.placeDataValue)
                                        if loginUI.phases[2].customizerui.option.editbox.cursor.posNum > _fieldLength then loginUI.phases[2].customizerui.option.editbox.cursor.posNum = _fieldLength end
                                    end
                                end
                                inputTickCounter = CLIENT_CURRENT_TICK
                                prevInputKey = currentPressedKey
                            end
                        end
                    end
                end
                imports.dxDrawRectangle(option_slotOffsetX - loginUI.phases[2].customizerui.option.editbox.embedLineSize, option_slotOffsetY + option_slotHeight + (loginUI.phases[2].customizerui.option.paddingY/2), option_slotWidth + (loginUI.phases[2].customizerui.option.editbox.embedLineSize*2), loginUI.phases[2].customizerui.option.editbox.embedLineSize, tocolor(unpack(loginUI.phases[2].customizerui.option.editbox.embedLineColor)), false)
                imports.dxDrawRectangle(option_slotOffsetX - loginUI.phases[2].customizerui.option.editbox.embedLineSize, option_slotOffsetY + option_slotHeight + (loginUI.phases[2].customizerui.option.paddingY/2), option_slotWidth + (loginUI.phases[2].customizerui.option.editbox.embedLineSize*2), loginUI.phases[2].customizerui.option.editbox.embedLineSize, tocolor(loginUI.phases[2].customizerui.option.editbox.focussedEmbedLineColor[1], loginUI.phases[2].customizerui.option.editbox.focussedEmbedLineColor[2], loginUI.phases[2].customizerui.option.editbox.focussedEmbedLineColor[3], loginUI.phases[2].customizerui.option.editbox.focussedEmbedLineColor[4]*j.embedLineAlphaPercent), false)
            end
        end
        if isLMBClicked and (not isOptionEditBoxClicked) then loginUI.phases[2].customizerui.option.editbox.focussedEditbox = 0; loginUI.phases[2].customizerui.option.editbox.cursor.posNum = 0; end
        imports.dxDrawRectangle(customizer_offsetX, loginUI.phases[2].customizerui.startY + loginUI.phases[2].customizerui.titleBar.height, loginUI.phases[2].customizerui.width, loginUI.phases[2].customizerui.titleBar.dividerSize, tocolor(unpack(loginUI.phases[2].customizerui.titleBar.dividerColor)), false)
        local switcher_offsetX, switcher_offsetY = customizer_offsetX + loginUI.phases[2].customizerui.switcher.startX, loginUI.phases[2].customizerui.startY + loginUI.phases[2].customizerui.switcher.startY
        local switcher_width, switcher_height = loginUI.phases[2].customizerui.switcher.width, loginUI.phases[2].customizerui.switcher.height
        for i, j in imports.ipairs(loginUI.phases[2].customizerui.switcher) do
            local isSwitcherHovered = isMouseOnPosition(switcher_offsetX, switcher_offsetY, switcher_width, switcher_height)
            if not j.hoverAnimStatus then j.hoverAnimStatus = "backward" end
            if not j.hoverAnimTickCounter then j.hoverAnimTickCounter = CLIENT_CURRENT_TICK end
            if isSwitcherHovered then
                if isLMBClicked then
                    setLoginUIEnabled(false)
                    imports.setTimer(function()
                        j.execFunc()
                    end, 1, 1)
                end
                if j.hoverAnimStatus ~= "forward" then
                    j.hoverAnimStatus = "forward"
                    j.hoverAnimTickCounter = CLIENT_CURRENT_TICK
                end
            else
                if j.hoverAnimStatus ~= "backward" then
                    j.hoverAnimStatus = "backward"
                    j.hoverAnimTickCounter = CLIENT_CURRENT_TICK
                end
            end
            if not j.hoverAnimAlphaPercent then j.hoverAnimAlphaPercent = 0 end
            if j.hoverAnimStatus == "forward" then
                j.hoverAnimAlphaPercent = interpolateBetween(j.hoverAnimAlphaPercent, 0, 0, 1, 0, 0, getInterpolationProgress(j.hoverAnimTickCounter, loginUI.phases[2].customizerui.switcher.hoverAnimDuration), "Linear")
            elseif j.hoverAnimStatus == "backward" then
                j.hoverAnimAlphaPercent = interpolateBetween(j.hoverAnimAlphaPercent, 0, 0, 0, 0, 0, getInterpolationProgress(j.hoverAnimTickCounter, loginUI.phases[2].customizerui.switcher.hoverAnimDuration), "Linear")
            end
            imports.dxDrawImage(switcher_offsetX, switcher_offsetY, switcher_width, switcher_height, loginUI.phases[2].customizerui.switcher.bgPath, 0, 0, 0, tocolor(unpack(loginUI.phases[2].customizerui.switcher.bgColor)), false)
            imports.dxDrawImage(switcher_offsetX, switcher_offsetY, switcher_width, switcher_height, loginUI.phases[2].customizerui.switcher.bgPath, 0, 0, 0, tocolor(loginUI.phases[2].customizerui.switcher.hoverBGColor[1], loginUI.phases[2].customizerui.switcher.hoverBGColor[2], loginUI.phases[2].customizerui.switcher.hoverBGColor[3], loginUI.phases[2].customizerui.switcher.hoverBGColor[4]*j.hoverAnimAlphaPercent), false)
            dxDrawBorderedText(loginUI.phases[2].customizerui.switcher.outlineWeight, loginUI.phases[2].customizerui.switcher.fontColor, j.title, switcher_offsetX, switcher_offsetY, switcher_offsetX + switcher_width, switcher_offsetY + switcher_height, tocolor(unpack(loginUI.phases[2].customizerui.switcher.fontColor)), 1, loginUI.phases[2].customizerui.switcher.font, "center", "center", true, false, false)
            dxDrawBorderedText(loginUI.phases[2].customizerui.switcher.outlineWeight, {loginUI.phases[2].customizerui.switcher.hoverfontColor[1], loginUI.phases[2].customizerui.switcher.hoverfontColor[2], loginUI.phases[2].customizerui.switcher.hoverfontColor[3], loginUI.phases[2].customizerui.switcher.hoverfontColor[4]*j.hoverAnimAlphaPercent}, j.title, switcher_offsetX, switcher_offsetY, switcher_offsetX + switcher_width, switcher_offsetY + switcher_height, tocolor(loginUI.phases[2].customizerui.switcher.hoverfontColor[1], loginUI.phases[2].customizerui.switcher.hoverfontColor[2], loginUI.phases[2].customizerui.switcher.hoverfontColor[3], loginUI.phases[2].customizerui.switcher.hoverfontColor[4]*j.hoverAnimAlphaPercent), 1, loginUI.phases[2].customizerui.switcher.font, "center", "center", true, false, false)
            switcher_offsetX = switcher_offsetX + switcher_width + loginUI.phases[2].customizerui.switcher.paddingX
        end
        local button_offsetX, button_offsetY = customizer_offsetX + loginUI.phases[2].customizerui.button.startX, customizer_offsetY + loginUI.phases[2].customizerui.button.startY
        local button_width, button_height = loginUI.phases[2].customizerui.button.width, loginUI.phases[2].customizerui.button.height
        for i, j in imports.ipairs(loginUI.phases[2].customizerui.button) do
            local isButtonHovered = isMouseOnPosition(button_offsetX, button_offsetY, button_width, button_height)
            if not j.hoverAnimStatus then j.hoverAnimStatus = "backward" end
            if not j.hoverAnimTickCounter then j.hoverAnimTickCounter = CLIENT_CURRENT_TICK end
            if isButtonHovered then
                if isLMBClicked then
                    setLoginUIEnabled(false)
                    imports.setTimer(function()
                        j.execFunc()
                    end, 1, 1)
                end
                if j.hoverAnimStatus ~= "forward" then
                    j.hoverAnimStatus = "forward"
                    j.hoverAnimTickCounter = CLIENT_CURRENT_TICK
                end
            else
                if j.hoverAnimStatus ~= "backward" then
                    j.hoverAnimStatus = "backward"
                    j.hoverAnimTickCounter = CLIENT_CURRENT_TICK
                end
            end
            if not j.hoverAnimAlphaPercent then j.hoverAnimAlphaPercent = 0 end
            if j.hoverAnimStatus == "forward" then
                j.hoverAnimAlphaPercent = interpolateBetween(j.hoverAnimAlphaPercent, 0, 0, 1, 0, 0, getInterpolationProgress(j.hoverAnimTickCounter, loginUI.phases[2].customizerui.button.hoverAnimDuration), "Linear")
            elseif j.hoverAnimStatus == "backward" then
                j.hoverAnimAlphaPercent = interpolateBetween(j.hoverAnimAlphaPercent, 0, 0, 0, 0, 0, getInterpolationProgress(j.hoverAnimTickCounter, loginUI.phases[2].customizerui.button.hoverAnimDuration), "Linear")
            end
            imports.dxDrawRectangle(button_offsetX + button_height, button_offsetY, button_width - (button_height*2), button_height, tocolor(unpack(loginUI.phases[2].customizerui.button.bgColor)), false)
            imports.dxDrawImage(button_offsetX, button_offsetY, button_height, button_height, loginUI.phases[2].customizerui.button.leftCurvedEdgePath, 0, 0, 0, tocolor(unpack(loginUI.phases[2].customizerui.button.bgColor)), false)
            imports.dxDrawImage(button_offsetX + button_width - button_height, button_offsetY, button_height, button_height, loginUI.phases[2].customizerui.button.rightCurvedEdgePath, 0, 0, 0, tocolor(unpack(loginUI.phases[2].customizerui.button.bgColor)), false)
            imports.dxDrawRectangle(button_offsetX + button_height, button_offsetY, button_width - (button_height*2), button_height, tocolor(loginUI.phases[2].customizerui.button.hoverBGColor[1], loginUI.phases[2].customizerui.button.hoverBGColor[2], loginUI.phases[2].customizerui.button.hoverBGColor[3], loginUI.phases[2].customizerui.button.hoverBGColor[4]*j.hoverAnimAlphaPercent), false)
            imports.dxDrawImage(button_offsetX, button_offsetY, button_height, button_height, loginUI.phases[2].customizerui.button.leftCurvedEdgePath, 0, 0, 0, tocolor(loginUI.phases[2].customizerui.button.hoverBGColor[1], loginUI.phases[2].customizerui.button.hoverBGColor[2], loginUI.phases[2].customizerui.button.hoverBGColor[3], loginUI.phases[2].customizerui.button.hoverBGColor[4]*j.hoverAnimAlphaPercent), false)
            imports.dxDrawImage(button_offsetX + button_width - button_height, button_offsetY, button_height, button_height, loginUI.phases[2].customizerui.button.rightCurvedEdgePath, 0, 0, 0, tocolor(loginUI.phases[2].customizerui.button.hoverBGColor[1], loginUI.phases[2].customizerui.button.hoverBGColor[2], loginUI.phases[2].customizerui.button.hoverBGColor[3], loginUI.phases[2].customizerui.button.hoverBGColor[4]*j.hoverAnimAlphaPercent), false)
            dxDrawBorderedText(loginUI.phases[2].customizerui.button.outlineWeight, loginUI.phases[2].customizerui.button.fontColor, j.title, button_offsetX, button_offsetY, button_offsetX + button_width, button_offsetY + button_height, tocolor(unpack(loginUI.phases[2].customizerui.button.fontColor)), 1, loginUI.phases[2].customizerui.button.font, "center", "center", true, false, false)
            dxDrawBorderedText(loginUI.phases[2].customizerui.button.outlineWeight, {loginUI.phases[2].customizerui.button.hoverfontColor[1], loginUI.phases[2].customizerui.button.hoverfontColor[2], loginUI.phases[2].customizerui.button.hoverfontColor[3], loginUI.phases[2].customizerui.button.hoverfontColor[4]*j.hoverAnimAlphaPercent}, j.title, button_offsetX, button_offsetY, button_offsetX + button_width, button_offsetY + button_height, tocolor(loginUI.phases[2].customizerui.button.hoverfontColor[1], loginUI.phases[2].customizerui.button.hoverfontColor[2], loginUI.phases[2].customizerui.button.hoverfontColor[3], loginUI.phases[2].customizerui.button.hoverfontColor[4]*j.hoverAnimAlphaPercent), 1, loginUI.phases[2].customizerui.button.font, "center", "center", true, false, false)
            button_offsetX = button_offsetX + button_width + loginUI.phases[2].customizerui.button.paddingX
        end
        _currentKeyCheck = true
    elseif currentLoginPhase == 3 then
        --Draws Credits UI
        imports.dxDrawImage(background_offsetX, background_offsetY, background_width, background_height, loginUI.phases[3].bgPath, 0, 0, 0, tocolor(unpack(loginUI.phases[3].bgColor)), false)
        local view_offsetX, view_offsetY = loginUI.phases[3].view.startX, loginUI.phases[3].view.startY
        local view_width, view_height = loginUI.phases[3].view.width, loginUI.phases[3].view.height
        imports.dxSetRenderTarget(loginUI.phases[3].view.renderTarget, true)
        local credits_offsetY = -loginUI.phases[3].view.contentHeight - (view_height/2)
        if (CLIENT_CURRENT_TICK - loginUI.phases[3].view.scrollAnimTickCounter) >= loginUI.phases[3].view.scrollDelayDuration then
            credits_offsetY = interpolateBetween(credits_offsetY, 0, 0, view_height*1.5, 0, 0, getInterpolationProgress(loginUI.phases[3].view.scrollAnimTickCounter + loginUI.phases[3].view.scrollDelayDuration, loginUI.phases[3].view.scrollAnimDuration), "Linear")
            if math.round(credits_offsetY, 2) == math.round(view_height*1.5) and loginUI.isEnabled then
                setLoginUIEnabled(false)
                setLoginUIPhase(1)
            end
        end
        dxDrawBorderedText(loginUI.phases[3].view.outlineWeight, loginUI.phases[3].view.outlineColor, loginUI.phases[3].view.content, loginUI.phases[3].view.paddingX, credits_offsetY, view_width, credits_offsetY + loginUI.phases[3].view.contentHeight, tocolor(unpack(loginUI.phases[3].view.fontColor)), 1, loginUI.phases[3].view.font, "left", "center", true, false, false, false, true)
        imports.dxSetRenderTarget()
        imports.dxDrawImage(view_offsetX, view_offsetY, view_width, view_height, loginUI.phases[3].view.renderTarget, 0, 0, 0, tocolor(255, 255, 255, 255), false)
        local back_navigator_width, back_navigator_height = loginUI.phases[3].back_navigator.width + dxGetTextWidth(loginUI.phases[3].back_navigator.title, 1, loginUI.phases[3].back_navigator.font), loginUI.phases[3].back_navigator.height
        back_navigator_width = back_navigator_width + (back_navigator_height*2)
        local back_navigator_offsetX, back_navigator_offsetY = loginUI.phases[3].back_navigator.startX + (CLIENT_MTA_RESOLUTION[1] - back_navigator_width), loginUI.phases[3].back_navigator.startY + (CLIENT_MTA_RESOLUTION[2] - back_navigator_height)
        local isBackNavigatorHovered = isMouseOnPosition(back_navigator_offsetX, back_navigator_offsetY, back_navigator_width, back_navigator_height)
        if isBackNavigatorHovered then
            if isLMBClicked then
                setLoginUIEnabled(false)
                imports.setTimer(function()
                    loginUI.phases[3].back_navigator.execFunc()
                end, 1, 1)
            end
            if loginUI.phases[3].back_navigator.hoverStatus ~= "forward" then
                loginUI.phases[3].back_navigator.hoverStatus = "forward"
                loginUI.phases[3].back_navigator.hoverAnimTickCounter = CLIENT_CURRENT_TICK
            end
        else
            if loginUI.phases[3].back_navigator.hoverStatus ~= "backward" then
                loginUI.phases[3].back_navigator.hoverStatus = "backward"
                loginUI.phases[3].back_navigator.hoverAnimTickCounter = CLIENT_CURRENT_TICK
            end
        end
        if not loginUI.phases[3].back_navigator.animAlphaPercent then loginUI.phases[3].back_navigator.animAlphaPercent = 0.75 end
        if loginUI.phases[3].back_navigator.hoverStatus == "forward" then
            loginUI.phases[3].back_navigator.animAlphaPercent = interpolateBetween(loginUI.phases[3].back_navigator.animAlphaPercent, 0, 0, 1, 0, 0, getInterpolationProgress(loginUI.phases[3].back_navigator.hoverAnimTickCounter, loginUI.phases[1].optionsui.hoverAnimDuration), "Linear")
        else
            loginUI.phases[3].back_navigator.animAlphaPercent = interpolateBetween(loginUI.phases[3].back_navigator.animAlphaPercent, 0, 0, 0.75, 0, 0, getInterpolationProgress(loginUI.phases[3].back_navigator.hoverAnimTickCounter, loginUI.phases[1].optionsui.hoverAnimDuration), "Linear")
        end
        imports.dxDrawRectangle(back_navigator_offsetX + back_navigator_height, back_navigator_offsetY, back_navigator_width - (back_navigator_height*2), back_navigator_height, tocolor(loginUI.phases[3].back_navigator.bgColor[1], loginUI.phases[3].back_navigator.bgColor[2], loginUI.phases[3].back_navigator.bgColor[3], loginUI.phases[3].back_navigator.bgColor[4]*loginUI.phases[3].back_navigator.animAlphaPercent), false)
        imports.dxDrawImage(back_navigator_offsetX, back_navigator_offsetY, back_navigator_height, back_navigator_height, loginUI.phases[3].back_navigator.leftEdgePath, 0, 0, 0, tocolor(loginUI.phases[3].back_navigator.bgColor[1], loginUI.phases[3].back_navigator.bgColor[2], loginUI.phases[3].back_navigator.bgColor[3], loginUI.phases[3].back_navigator.bgColor[4]*loginUI.phases[3].back_navigator.animAlphaPercent), false)
        imports.dxDrawImage(back_navigator_offsetX + back_navigator_width - back_navigator_height, back_navigator_offsetY, back_navigator_height, back_navigator_height, loginUI.phases[3].back_navigator.rightEdgePath, 0, 0, 0, tocolor(loginUI.phases[3].back_navigator.bgColor[1], loginUI.phases[3].back_navigator.bgColor[2], loginUI.phases[3].back_navigator.bgColor[3], loginUI.phases[3].back_navigator.bgColor[4]*loginUI.phases[3].back_navigator.animAlphaPercent), false)
        dxDrawBorderedText(loginUI.phases[3].back_navigator.outlineWeight, loginUI.phases[3].back_navigator.fontColor, loginUI.phases[3].back_navigator.title, back_navigator_offsetX, back_navigator_offsetY, back_navigator_offsetX + back_navigator_width, back_navigator_offsetY + back_navigator_height, tocolor(loginUI.phases[3].back_navigator.fontColor[1], loginUI.phases[3].back_navigator.fontColor[2], loginUI.phases[3].back_navigator.fontColor[3], loginUI.phases[3].back_navigator.fontColor[4]*loginUI.phases[3].back_navigator.animAlphaPercent), 1, loginUI.phases[3].back_navigator.font, "center", "center", true, false, false)
    end

end


------------------------------
--[[ Function: Toggles UI ]]--
------------------------------

toggleUI = function(state)

    if (((state ~= true) and (state ~= false)) or (state == loginUI.state)) then return false end

    if state then
        loginUI.state = true
        loginUI.cinemationData = FRAMEWORK_CONFIGS["UI"]["Login"].spawnLocations[math.random(#FRAMEWORK_CONFIGS["UI"]["Login"].spawnLocations)]
        setLoginUIPhase(1)
        imports.triggerEvent("onLoginSoundStart", localPlayer)
        beautify.render.create(renderUI)
    else
        beautify.render.remove(renderUI)
        exports.cinecam_handler:stopCinemation()
        if loginUI.character and imports.isElement(loginUI.character) then loginUI.character:destroy() end
        loginUI.phase = false
        loginUI.cinemationData = false
        loginUI.character = false
        loginUI.selectedCharacter = 0
        loginUI._selectedCharacter = false
        loginUI.clientCharacters = {}
        loginUI.isPremium = false
        loginUI.state = false
    end
    showChat(not state)
    showCursor(state)
    return true

end


----------------------------------------
--[[ Event: On Client Show Login UI ]]--
----------------------------------------

imports.addEvent("Player:onClientShowLoadingUI", true)
imports.addEventHandler("Player:onClientShowLoadingUI", root, function(character, characters, isPremium)

    for i, j in imports.ipairs(characters) do
        j.__isPreLoaded = true
    end
    loginUI.selectedCharacter = character
    loginUI._selectedCharacter = loginUI.selectedCharacter
    loginUI.clientCharacters = characters
    loginUI._unsavedCharacters = {}
    loginUI._charactersUnderProcess = {}
    loginUI.isPremium = isPremium
    localPlayer:setPosition(FRAMEWORK_CONFIGS["UI"]["Login"].lobbyPosition.x, FRAMEWORK_CONFIGS["UI"]["Login"].lobbyPosition.y, FRAMEWORK_CONFIGS["UI"]["Login"].lobbyPosition.z)
    localPlayer:setDimension(FRAMEWORK_CONFIGS["UI"]["Login"].lobbyDimension)

    setLoginUIEnabled(true, true)
    imports.setTimer(function()
        toggleUI(true)
        fadeCamera(true)
        imports.triggerEvent("Player:onShowLoadingUI", localPlayer)
    end, 10000, 1)

end)


-----------------------------------------
--[[ Event: On Client Resource Start ]]--
-----------------------------------------

imports.addEventHandler("onClientResourceStart", resource, function()

    --[[
    if not isPlayerInitialized(localPlayer) then
        fadeCamera(false)
        toggleControl("fire", true)
        toggleControl("action", false)
        imports.triggerEvent("Player:onHideLoadingUI", localPlayer, true)
        triggerServerEvent("onPlayerRequestShowLoginScreen", localPlayer)
    else
        fadeCamera(true)
    end]]

    toggleUI(true) --TODO: REMOVE LATER
    setPedTargetingMarkerEnabled(false)
    setPlayerHudComponentVisible("all", false)
    setPlayerHudComponentVisible("crosshair", true)
    setTrafficLightState("disabled")
    toggleControl("radar", false)

end)