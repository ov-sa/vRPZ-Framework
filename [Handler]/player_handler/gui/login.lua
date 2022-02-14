----------------------------------------------------------------
--[[ Resource: Player Handler
     Script: gui: login.lua
     Author: vStudio
     Developer(s): Mario, Tron, Aviril
     DOC: 31/01/2022
     Desc: Login UI Handler ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local imports = {
    pairs = pairs,
    ipairs = ipairs, --TODO: REMOVE...
    tonumber = tonumber,
    tostring = tostring,
    tocolor = tocolor,
    unpackColor = unpackColor,
    isElement = isElement,
    destroyElement = destroyElement,
    setElementPosition = setElementPosition,
    setElementDimension = setElementDimension,
    addEvent = addEvent,
    addEventHandler = addEventHandler,
    triggerEvent = triggerEvent,
    triggerServerEvent = triggerServerEvent,
    isTimer = isTimer,
    setTimer = setTimer,
    killTimer = killTimer,
    interpolateBetween = interpolateBetween,
    getInterpolationProgress = getInterpolationProgress,
    fadeCamera = fadeCamera,
    showChat = showChat,
    showCursor = showCursor,
    table = table,
    math = math,
    string = string,
    beautify = beautify
}


-------------------
--[[ Variables ]]--
-------------------

local manageCharacter, toggleUI = nil, nil
local loginUI = {
    cache = {
        keys = {},
        timers = {}
    },
    bgTexture = imports.beautify.native.createTexture(FRAMEWORK_CONFIGS["UI"]["Login"].bgPath, "dxt5", true, "clamp"),
    phases = {
        [1] = {
            bgTexture = imports.beautify.native.createTexture(FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].play.bgPath, "dxt5", true, "clamp"),
            optionsUI = {
                startX = CLIENT_MTA_RESOLUTION[1]*0.5, startY = -15, paddingY = 10,
                font = FRAMEWORK_FONTS[2], fontColor = imports.tocolor(imports.unpackColor(FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].play.fontColor)),
                {identifier = "play", exec = function() manageCharacter("play") end},
                {identifier = "characters", exec = function() imports.triggerEvent("Client:onSetLoginUIPhase", localPlayer, 2) end},
                {identifier = "credits", exec = function() imports.triggerEvent("Client:onSetLoginUIPhase", localPlayer, 3) end}
            }
        },
        [2] = {
            startX = 5, startY = 5,
            width = FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].characters.width, height = FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].characters.height,
            titlebar = {
                paddingY = 2,
                height = FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].characters.titlebar.height,
                font = FRAMEWORK_FONTS[3], fontColor = imports.tocolor(imports.unpackColor(FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].characters.titlebar.fontColor)),
                bgColor = imports.tocolor(imports.unpackColor(FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].characters.titlebar.bgColor)),
                shadowColor = imports.tocolor(imports.unpackColor(FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].characters.titlebar.shadowColor)),
            },
            categories = {
                paddingX = 20, paddingY = 5,
                height = FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].characters.categories.height,
                font = FRAMEWORK_FONTS[4], fontColor = imports.tocolor(imports.unpackColor(FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].characters.categories.fontColor)),
                bgColor = imports.tocolor(imports.unpackColor(FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].characters.categories.bgColor)),
                {
                    height = 185,
                    identifier = "Identity",
                    contents = {
                        tone = {
                            isSlider = true,
                            startY = 30, paddingY = -10,
                            height = 30,
                            identifier = "tone"
                        },
                        gender = {
                            isSelector = true,
                            startY = 90,
                            height = 30,
                            identifier = "gender"
                        },
                        faction = {
                            isSelector = true,
                            startY = 150,
                            height = 30,
                            identifier = "faction"
                        }
                    }
                },
                {
                    height = 65,
                    identifier = "Facial",
                    contents = {
                        hair = {
                            isSelector = true, isClothing = true,
                            startY = 30,
                            height = 30,
                            identifier = "hair",
                            content = {
                                "None",
                                "Casual"
                            }
                        }
                    }
                },
                {
                    isSoloSelector = true, isClothing = true,
                    height = 50,
                    identifier = "Upper",
                    content = {
                        "T-Shirt (Red)",
                        "Hoody (Blue)"
                    }
                },
                {
                    isSoloSelector = true, isClothing = true,
                    height = 50,
                    identifier = "Lower",
                    content = {
                        "Pant (Red)",
                        "Trouser (Blue)"
                    }
                },
                {
                    isSoloSelector = true, isClothing = true,
                    height = 50,
                    identifier = "Shoes",
                    content = {
                        "Sneakers (Red)",
                        "Boots (Blue)"
                    }
                }
            }
        },
        [3] = {
            startX = 0, startY = 15,
            width = 0, height = -15,
            font = FRAMEWORK_FONTS[5], fontColor = imports.tocolor(unpackColor(FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].credits.fontColor)),
            scrollAnimTickCounter = CLIENT_CURRENT_TICK,
            scrollDelayDuration = FRAMEWORK_CONFIGS["UI"]["Loading"].fadeOutDuration + FRAMEWORK_CONFIGS["UI"]["Loading"].fadeDelayDuration - 1000,
            scrollDuration = FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].credits.scrollDuration,
            navigator = {
                startX = -15, startY = 15,
                width = 0, height = 25,
                font = FRAMEWORK_FONTS[1], fontColor = {200, 200, 200, 255},
                hoverStatus = "backward",
                hoverAnimTick = CLIENT_CURRENT_TICK,
                hoverDuration = 1500,
                exec = function() imports.triggerEvent("Client:onSetLoginUIPhase", localPlayer, 1) end
            }
        }
    }
}

for i = 1, #loginUI.phases[1].optionsUI, 1 do
    local j = loginUI.phases[1].optionsUI[i]
    j.startY = loginUI.phases[1].optionsUI.startY + CLIENT_MTA_RESOLUTION[2] - (FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].play.height*(#loginUI.phases[1].optionsUI - (i - 1))) - (loginUI.phases[1].optionsUI.paddingY*(#loginUI.phases[1].optionsUI - i))
    j.hoverStatus = "backward"
    j.hoverAnimTick = CLIENT_CURRENT_TICK
end
loginUI.phases[2].updateUILang = function()
    for i = 1, #loginUI.phases[2].categories, 1 do
        local j = loginUI.phases[2].categories[i]
        j.title = imports.string.upper(imports.string.spaceChars(FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].characters.categories[(j.identifier)]["Titles"][FRAMEWORK_LANGUAGE]))
        if j.contents then
            for k, v in imports.pairs(j.contents) do
                v.title = imports.string.upper(imports.string.spaceChars(FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].characters.categories[(j.identifier)][(v.identifier)]["Titles"][FRAMEWORK_LANGUAGE]))
                if not v.isClothing then
                    if v.isSelector then
                        v.contentIndex, v.content = {}, {}
                        print(j.identifier.." : "..v.identifier)
                        for k, v in imports.pairs(FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].characters.categories[(j.identifier)][(v.identifier)]["Datas"]) do
                            imports.table.insert(v.contentIndex, k)
                            imports.table.insert(v.content, imports.string.upper(imports.string.spaceChars(v[FRAMEWORK_LANGUAGE])))
                        end
                    end
                end
            end
        end
    end
end
loginUI.phases[2].toggleUI = function(state)
    if state then
        if loginUI.phases[2].element or imports.isElement(loginUI.phases[2].element) then return false end
        loginUI.phases[2].updateUILang()
        local panel_offsetY = loginUI.phases[2].titlebar.height + loginUI.phases[2].titlebar.paddingY
        loginUI.phases[2].element = imports.beautify.card.create(loginUI.phases[2].startX, loginUI.phases[2].startY, loginUI.phases[2].width, loginUI.phases[2].height, nil, false)
        imports.beautify.setUIVisible(loginUI.phases[2].element, true)
        for i = 1, #loginUI.phases[2].categories, 1 do
            local j = loginUI.phases[2].categories[i]
            j.offsetY = (loginUI.phases[2].categories[(i - 1)] and (loginUI.phases[2].categories[(i - 1)].offsetY + loginUI.phases[2].categories.height + loginUI.phases[2].categories[(i - 1)].height + loginUI.phases[2].categories.paddingY)) or panel_offsetY
            if j.contents then
                for k, v in imports.pairs(j.contents) do
                    if v.isSlider then
                        v.element = imports.beautify.slider.create(loginUI.phases[2].categories.paddingX, j.offsetY + loginUI.phases[2].categories.height + v.startY + v.paddingY, loginUI.phases[2].width - (loginUI.phases[2].categories.paddingX*2), v.height, "horizontal", loginUI.phases[2].element, false)
                        imports.beautify.setUIVisible(v.element, true)
                    elseif v.isSelector then
                        v.element = imports.beautify.selector.create(loginUI.phases[2].categories.paddingX, j.offsetY + loginUI.phases[2].categories.height + v.startY, loginUI.phases[2].width - (loginUI.phases[2].categories.paddingX*2), v.height, "horizontal", loginUI.phases[2].element, false)
                        imports.beautify.selector.setDataList(v.element, v.content)
                        imports.beautify.setUIVisible(v.element, true)
                    end
                end
            elseif j.isSoloSelector then
                j.element = imports.beautify.selector.create(loginUI.phases[2].categories.paddingX, j.offsetY + loginUI.phases[2].categories.height, loginUI.phases[2].width - (loginUI.phases[2].categories.paddingX*2), j.height, "horizontal", loginUI.phases[2].element, false)
                --[[
                for k = 1, #j.content, 1 do
                    local v = j.content[k]
                    j.content[k] = imports.string.upper(imports.string.spaceChars(v))
                end
                ]]--
                imports.beautify.selector.setDataList(j.element, j.content)
                imports.beautify.setUIVisible(j.element, true)
            end
        end
        imports.beautify.render.create(function()
            imports.beautify.native.drawRectangle(0, 0, loginUI.phases[2].width, loginUI.phases[2].titlebar.height, loginUI.phases[2].titlebar.bgColor)
            imports.beautify.native.drawText(imports.string.upper(imports.string.spaceChars(FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].characters.titlebar["Titles"][FRAMEWORK_LANGUAGE])), 0, 0, loginUI.phases[2].width, loginUI.phases[2].titlebar.height, loginUI.phases[2].titlebar.fontColor, 1, loginUI.phases[2].titlebar.font, "center", "center", true, false, false)
            imports.beautify.native.drawRectangle(0, loginUI.phases[2].titlebar.height, loginUI.phases[2].width, loginUI.phases[2].titlebar.paddingY, loginUI.phases[2].titlebar.shadowColor)
            for i = 1, #loginUI.phases[2].categories, 1 do
                local j = loginUI.phases[2].categories[i]
                local category_offsetY = j.offsetY + loginUI.phases[2].categories.height
                imports.beautify.native.drawRectangle(0, j.offsetY, loginUI.phases[2].width, loginUI.phases[2].categories.height, loginUI.phases[2].titlebar.bgColor)
                imports.beautify.native.drawText(j.title, 0, j.offsetY, loginUI.phases[2].width, category_offsetY, loginUI.phases[2].categories.fontColor, 1, loginUI.phases[2].categories.font, "center", "center", true, false, false)
                imports.beautify.native.drawRectangle(0, category_offsetY, loginUI.phases[2].width, j.height, loginUI.phases[2].categories.bgColor)
                if j.contents then
                    for k, v in imports.pairs(j.contents) do
                        local title_height = loginUI.phases[2].categories.height
                        local title_offsetY = category_offsetY + v.startY - title_height
                        imports.beautify.native.drawRectangle(0, title_offsetY, loginUI.phases[2].width, title_height, loginUI.phases[2].titlebar.bgColor)
                        imports.beautify.native.drawText(v.title, 0, title_offsetY, loginUI.phases[2].width, title_offsetY + title_height, loginUI.phases[2].titlebar.fontColor, 1, loginUI.phases[2].categories.font, "center", "center", true, false, false)
                    end
                end
            end
        end, {
            elementReference = loginUI.phases[2].element,
            renderType = "preViewRTRender"
        })
    else
        if not loginUI.phases[2].element or not imports.isElement(loginUI.phases[2].element) then return false end
        imports.destroyElement(loginUI.phases[2].element)
    end
    return true
end
loginUI.phases[3].contentText = ""
for i = 1, #FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].credits.contributors do
    local j = FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].credits.contributors[i]
    loginUI.phases[3].contentText = ((i == 1) and j) or loginUI.phases[3].contentText.."\n\n"..j
end
loginUI.phases[3].width, loginUI.phases[3].height = loginUI.phases[3].width + (CLIENT_MTA_RESOLUTION[1] - loginUI.phases[3].startX), loginUI.phases[3].height + (CLIENT_MTA_RESOLUTION[2] - loginUI.phases[3].startY)
loginUI.phases[3].contentWidth, loginUI.phases[3].contentHeight = imports.beautify.native.getTextSize (loginUI.phases[3].contentText, loginUI.phases[3].width, 1, loginUI.phases[3].font, false)
loginUI.phases[3].scrollDuration = imports.math.max(1, imports.math.ceil((loginUI.phases[3].contentHeight + loginUI.phases[3].height)/loginUI.phases[3].height))*loginUI.phases[3].scrollDuration


------------------------------------------------------------------
--[[ Functions: Loads/Updates/Manages Login Preview Character ]]--
------------------------------------------------------------------

local function loadLoginPreviewCharacter(loadDefault)

    if not loadDefault and not loginUI.characters[loginUI._selectedCharacter] then
        if #loginUI.characters > 0 then
            loginUI.character = 1
            loginUI._selectedCharacter = loginUI.character
        else
            loadDefault = true
        end
    end

    if loadDefault then
        --[[
        for i, j in imports.ipairs(loginUI.phases[2].loginUI.phases[2].option) do
            if j.isEditBox then
                j.placeDataValue = ""
            else
                j.placeDataValue = 1
            end
        end
        ]]
    else
        --[[
        for i, j in imports.ipairs(loginUI.phases[2].loginUI.phases[2].option) do
            if j.isEditBox then
                j.placeDataValue = loginUI.characters[loginUI._selectedCharacter][j.optionType] or ""
            else
                local matchedDataIndex = false
                if j.optionType == "gender" or j.clothingCategoryIndex then
                    matchedDataIndex = loginUI.characters[loginUI._selectedCharacter][j.optionType]
                else
                    for k, v in imports.ipairs(j.placeDataTable) do
                        if loginUI.characters[loginUI._selectedCharacter][j.optionType] == v then
                            matchedDataIndex = k
                            break
                        end
                    end
                end
                j.placeDataValue = matchedDataIndex or 1
            end
        end
        ]]
    end
    updateLoginPreviewCharacter()
    return true

end

function updateLoginPreviewCharacter()

    if not loginUI.character or not imports.isElement(loginUI.character) then return false end

    local disabledTextures = {}
    local selectedGender, selectedClothing = playerClothes["Gender"][(loginUI.phases[2].loginUI.phases[2].option[3].placeDataValue)], {}
    loginUI.character:setModel(selectedGender.modelSkin)
    selectedClothing["gender"] = loginUI.phases[2].loginUI.phases[2].option[3].placeDataValue
    for i, j in imports.ipairs(loginUI.phases[2].loginUI.phases[2].option) do
        if not j.isEditBox and j.clothingCategoryIndex then
            if j.clothingCategoryIndex == "Race" then
                j.placeDataTable = playerClothes[selectedGender.modelType][j.clothingCategoryIndex]
            else
                if j.clothingCategoryIndex ~= "Hair" and j.clothingCategoryIndex ~= "Hair_Color" then
                    if loginUI.characters[loginUI._selectedCharacter] and loginUI.characters[loginUI._selectedCharacter].__isPreLoaded then
                        j.placeDataTable = playerClothes[selectedGender.modelType][j.clothingCategoryIndex]
                    else
                        local generatedDataTable = {}
                        for k, v in imports.ipairs(playerClothes[selectedGender.modelType][j.clothingCategoryIndex]) do
                            if v.isAvailableForCharacterCreation then
                                local copiedTable = imports.table.copy(v, true)
                                copiedimports.table.isAvailableForCharacterCreation = nil
                                copiedimports.table.__dataIndex = k
                                imports.table.insert(generatedDataTable, copiedTable)
                            end
                        end
                        j.placeDataTable = generatedDataTable
                    end
                end
            end
            if j.clothingCategoryIndex == "Race" then
                loginUI.phases[2].loginUI.phases[2].option[5].placeDataTable = (j.placeDataTable[j.placeDataValue] and j.placeDataTable[j.placeDataValue]["Hair"]) or {}
                loginUI.phases[2].loginUI.phases[2].option[6].placeDataTable = (j.placeDataTable[j.placeDataValue] and j.placeDataTable[j.placeDataValue]["Hair_Color"]) or {}
            end
            if not j.placeDataTable[j.placeDataValue] then j.placeDataValue = 1 end
            if j.placeDataTable[j.placeDataValue] then
                selectedClothing[j.optionType] = j.placeDataTable[j.placeDataValue].__dataIndex or j.placeDataValue
            end
        end
    end
    imports.triggerEvent("Player:onSyncPedClothes", root, loginUI.character, selectedClothing)
    return true

end

manageCharacter = function(manageType)

    if not manageType then return false end

    if manageType == "create" then
        imports.triggerEvent("Client:onEnableLoginUI", localPlayer, true)
        local characterLimit = playerCharacterLimit
        if loginUI.isPremium then characterLimit = playerPremiumCharacterLimit end
        if #loginUI.characters >= characterLimit then
            imports.triggerEvent("Client:onNotification", localPlayer, "Unfortunately, you have reached the character creation limit!", {255, 80, 80, 255})
            return false
        end
        local characterData = {
            isUnverified = true
        }
        imports.table.insert(loginUI.characters, characterData)
        loginUI._selectedCharacter = #loginUI.characters
        loginUI._unsavedCharacters[loginUI._selectedCharacter] = true
        loadLoginPreviewCharacter(true)
        imports.triggerEvent("Client:onNotification", localPlayer, "You've successfully created a character!", {80, 255, 80, 255})
    elseif manageType == "delete" then
        imports.triggerEvent("Client:onEnableLoginUI", localPlayer, true)
        if #loginUI.characters <= 0 then
            imports.triggerEvent("Client:onNotification", localPlayer, "Unfortunately, you don't have enough characters to delete!", {255, 80, 80, 255})
            return false
        end
        if not loginUI.characters[loginUI._selectedCharacter] then
            imports.triggerEvent("Client:onNotification", localPlayer, "You must select a character inorder to delete!", {255, 80, 80, 255})
            return false
        end
        if not loginUI.characters[loginUI._selectedCharacter].isUnverified or loginUI._charactersUnderProcess[loginUI._selectedCharacter] then
            if not loginUI.characters[loginUI._selectedCharacter]._id or loginUI._charactersUnderProcess[loginUI._selectedCharacter] then
                imports.triggerEvent("Client:onNotification", localPlayer, "You must wait until the character processing is done!", {255, 80, 80, 255})
                return false
            else
                imports.triggerServerEvent("Player:onDeleteCharacter", localPlayer, loginUI.characters[loginUI._selectedCharacter]._id)
            end
        end
        imports.table.remove(loginUI.characters, loginUI._selectedCharacter)
        loginUI._unsavedCharacters[loginUI._selectedCharacter] = nil
        loginUI._selectedCharacter = imports.math.max(0, loginUI._selectedCharacter - 1)
        loadLoginPreviewCharacter()
        imports.triggerEvent("Client:onNotification", localPlayer, "You've successfully deleted the character!", {80, 255, 80, 255})
    elseif (manageType == "switch_prev") or (manageType == "switch_next") then
        imports.triggerEvent("Client:onEnableLoginUI", localPlayer, true)
        if #loginUI.characters <= 1 then
            imports.triggerEvent("Client:onNotification", localPlayer, "Unfortunately, you don't have enough characters to switch!", {255, 80, 80, 255})
            return false
        end
        if manageType == "switch_prev" then
            if loginUI._selectedCharacter > 1 then
                loginUI._selectedCharacter = loginUI._selectedCharacter - 1
                loadLoginPreviewCharacter()
            end
        elseif manageType == "switch_next" then
            if loginUI._selectedCharacter < #loginUI.characters then
                loginUI._selectedCharacter = loginUI._selectedCharacter + 1
                loadLoginPreviewCharacter()
            end
        end
    elseif manageType == "pick" then
        imports.triggerEvent("Client:onEnableLoginUI", localPlayer, true)
        if (loginUI._selectedCharacter ~= 0) and (loginUI.character == loginUI._selectedCharacter) then
            imports.triggerEvent("Client:onNotification", localPlayer, "You've already picked the specified character!", {255, 80, 80, 255})
            return false
        end
        if (not loginUI.characters[loginUI._selectedCharacter]) or loginUI.characters[loginUI._selectedCharacter].isUnverified then
            imports.triggerEvent("Client:onNotification", localPlayer, "You must save the character inorder to pick!", {255, 80, 80, 255})
            return false
        end
        loginUI.character = loginUI._selectedCharacter
        imports.triggerEvent("Client:onNotification", localPlayer, "You've successfully picked the character!", {80, 255, 80, 255})
    elseif manageType == "save" then
        if #loginUI.characters > 0 and not loginUI.characters[loginUI._selectedCharacter].isUnverified then
            imports.triggerEvent("Client:onEnableLoginUI", localPlayer, true)
            imports.triggerEvent("Client:onNotification", localPlayer, "Your character is already saved!", {255, 80, 80, 255})
            return false
        end
        imports.triggerEvent("Client:onEnableLoginUI", localPlayer, false, true)
        imports.triggerEvent("Client:onNotification", localPlayer, "◴ Saving..", {175, 175, 175, 255})
        local characterData = {}
        for i, j in imports.ipairs(loginUI.phases[2].loginUI.phases[2].option) do
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
        local character = loginUI.character
        local charactersPendingToBeSaved = {}
        local charactersToBeSaved = imports.table.copy(loginUI.characters, true)
        for i, j in imports.ipairs(charactersToBeSaved) do
            if j.isUnverified then
                charactersToBeSaved[i] = nil
            end
        end
        if #loginUI.characters <= 0 then
            character = 1
            loginUI._selectedCharacter = character
        end
        charactersPendingToBeSaved[loginUI._selectedCharacter] = true
        charactersToBeSaved[loginUI._selectedCharacter] = characterData
        loginUI._charactersUnderProcess[loginUI._selectedCharacter] = true
        imports.triggerServerEvent("Player:onSaveCharacter", localPlayer, character, charactersToBeSaved, charactersPendingToBeSaved)
    elseif manageType == "play" then
        if #loginUI.characters <= 0 then
            imports.triggerEvent("Client:onEnableLoginUI", localPlayer, true)
            imports.triggerEvent("Client:onNotification", localPlayer, "You must create a character to play!", {255, 80, 80, 255})
            return false
        else
            if not loginUI.characters[loginUI.character] then
                imports.triggerEvent("Client:onEnableLoginUI", localPlayer, true)
                imports.triggerEvent("Client:onNotification", localPlayer, "You must pick a character to play!", {255, 80, 80, 255})
                return false
            end
        end
        imports.triggerEvent("Client:onEnableLoginUI", localPlayer, false, true)
        imports.triggerEvent("Client:onNotification", localPlayer, "◴ Processing..", {175, 175, 175, 255})
        imports.triggerEvent("Client:onToggleLoadingUI", localPlayer, true)
        imports.setTimer(function()
            toggleUI(false)
        end, FRAMEWORK_CONFIGS["UI"]["Loading"].fadeInDuration + 250, 1)
        imports.setTimer(function(character, characters)
            imports.triggerServerEvent("onPlayerResumeGame", localPlayer, character, characters)
        end, FRAMEWORK_CONFIGS["UI"]["Loading"].fadeInDuration + FRAMEWORK_CONFIGS["UI"]["Loading"].fadeOutDuration + FRAMEWORK_CONFIGS["UI"]["Loading"].fadeDelayDuration, 1, loginUI.character, loginUI.characters)
    end
    return true

end


------------------------------
--[[ Function: UI Helpers ]]--
------------------------------

function isLoginUIVisible() return loginUI.state end
function getLoginUIPhase() return loginUI.phase end

imports.addEvent("Client:onSetLoginUIPhase", true)
imports.addEventHandler("Client:onSetLoginUIPhase", root, function(phaseID)
    phaseID = imports.tonumber(phaseID)
    if not phaseID or not loginUI.phases[1].optionsUI[phaseID] or (loginUI.phase and loginUI.phase == phaseID) then return false end

    for i, j in imports.pairs(loginUI.cache.timers) do
        if j and imports.isTimer(j) then
            imports.killTimer(j)
            loginUI.cache.timers[i] = nil
        end
    end
    imports.triggerEvent("Client:onToggleLoadingUI", localPlayer, true)
    loginUI.cache.timers.phaseChanger = imports.setTimer(function()
        if phaseID == 1 then
            exports.cinecam_handler:startCinemation(loginUI.cinemationData.cinemationPoint, true, true, loginUI.cinemationData.cinemationFOV, true, true, true, false)
        elseif phaseID == 2 then
            loginUI.phases[2].toggleUI(true)
            --[[
            if loginUI.character and imports.isElement(loginUI.character) then loginUI.character:destroy(); loginUI.character = false end
            exports.cinecam_handler:startCinemation(loginUI.cinemationData.characterCinemationPoint, true, true, loginUI.cinemationData.characterCinemationFOV, true, true, true, false)
            loginUI.character = Ped(0, loginUI.cinemationData.characterPoint.x, loginUI.cinemationData.characterPoint.y, loginUI.cinemationData.characterPoint.z, loginUI.cinemationData.characterPoint.rotation)
            loginUI.character:setDimension(FRAMEWORK_CONFIGS["UI"]["Login"].dimension)
            loginUI.character:setFrozen(true)
            loadLoginPreviewCharacter()
            ]]
        else
            exports.cinecam_handler:stopCinemation()
            if phaseID == 3 then
                loginUI.phases[3].scrollAnimTickCounter = CLIENT_CURRENT_TICK
            end
        end
        loginUI.phase = phaseID
        local unverifiedCharacters = {}
        for i, j in imports.ipairs(loginUI.characters) do
            if j.isUnverified then
                imports.table.insert(unverifiedCharacters, i)
            end
        end
        for i, j in imports.ipairs(loginUI.characters) do
            if j.isUnverified then
                imports.table.remove(loginUI.characters, i)
                loginUI._unsavedCharacters[i] = nil
            end
        end
        for i, j in imports.ipairs(unverifiedCharacters) do
            if loginUI.character == j then
                loginUI.character = 0
                loginUI._selectedCharacter = 0
                break
            else
                if loginUI._selectedCharacter == j then
                    loginUI._selectedCharacter = 0
                end
            end
        end
        imports.triggerEvent("Client:onToggleLoadingUI", localPlayer, false)
        loginUI.cache.timers.phaseChanger = false
    end, FRAMEWORK_CONFIGS["UI"]["Loading"].fadeInDuration + 250, 1)
    loginUI.cache.timers.uiEnabler = imports.setTimer(function()
        imports.triggerEvent("Client:onEnableLoginUI", localPlayer, true)
        loginUI.cache.timers.uiEnabler = false
    end, FRAMEWORK_CONFIGS["UI"]["Loading"].fadeOutDuration + FRAMEWORK_CONFIGS["UI"]["Loading"].fadeDelayDuration - (FRAMEWORK_CONFIGS["UI"]["Loading"].fadeInDuration + 250), 1)
    return true
end)

imports.addEvent("Client:onEnableLoginUI", true)
imports.addEventHandler("Client:onEnableLoginUI", root, function(state, isForced)
    if loginUI.cache.timers.uiEnabler and imports.isTimer(loginUI.cache.timers.uiEnabler) then
        imports.killTimer(loginUI.cache.timers.uiEnabler)
        loginUI.cache.timers.uiEnabler = nil
    end
    if isForced then
        loginUI.isForcedDisabled = not state
    else
        loginUI.isEnabled = state
    end
    loginUI.isEnabled = state
    return true
end)

imports.addEvent("Client:onSaveCharacter", true)
imports.addEventHandler("Client:onSaveCharacter", root, function(state, errorMessage, character)
    if state then
        imports.triggerEvent("Client:onNotification", localPlayer, "You've successfully saved the character!", {80, 255, 80, 255})
    else
        if errorMessage then
            if character then loginUI._charactersUnderProcess[character] = nil end
            imports.triggerEvent("Client:onNotification", localPlayer, errorMessage, {255, 80, 80, 255})
        end
    end
    imports.triggerEvent("Client:onEnableLoginUI", localPlayer, true, true)
end)

imports.addEvent("Client:onLoadCharacterID", true)
imports.addEventHandler("Client:onLoadCharacterID", root, function(character, characterID, characterData)
    character = imports.tonumber(character); characterID = imports.tonumber(characterID);
    if not character or not characterID or not characterData then return false end

    loginUI._unsavedCharacters[character] = nil
    loginUI._charactersUnderProcess[character] = nil
    loginUI.characters[character] = characterData
    loginUI.characters[character]._id = characterID
end)


------------------------------
--[[ Function: Renders UI ]]--
------------------------------

local function renderUI(renderData)
    if not loginUI.state or CPlayer.isInitialized(localPlayer) then return false end
    if not loginUI.phase then return false end

    if renderData.renderType == "input" then
        loginUI.cache.keys.mouse = isMouseClicked()
        imports.triggerEvent("Player:onSyncWeather", localPlayer, FRAMEWORK_CONFIGS["UI"]["Login"].weather, FRAMEWORK_CONFIGS["UI"]["Login"].time)
    elseif renderData.renderType == "render" then
        local isLMBClicked = loginUI.cache.keys.mouse == "mouse1"
        local currentRatio = (CLIENT_MTA_RESOLUTION[1]/CLIENT_MTA_RESOLUTION[2])/(1366/768)
        local background_width, background_height = CLIENT_MTA_RESOLUTION[1], CLIENT_MTA_RESOLUTION[2]*currentRatio
        local background_offsetX, background_offsetY = 0, -(background_height - CLIENT_MTA_RESOLUTION[2])/2
        if background_offsetY > 0 then
            background_width, background_height = CLIENT_MTA_RESOLUTION[1]/currentRatio, CLIENT_MTA_RESOLUTION[2]
            background_offsetX, background_offsetY = -(background_width - CLIENT_MTA_RESOLUTION[1])/2, 0
        end

        if loginUI.phase == 1 then
            --Draws Options UI
            imports.beautify.native.drawImage(background_offsetX, background_offsetY, background_width, background_height, loginUI.phases[loginUI.phase].bgTexture, 0, 0, 0, -1, false)
            for i, j in imports.ipairs(loginUI.phases[1].optionsUI) do
                local option_title = imports.string.upper(imports.string.spaceChars(FRAMEWORK_CONFIGS["UI"]["Login"]["Options"][(j.identifier)]["Titles"][FRAMEWORK_LANGUAGE], "  "))
                local option_width, option_height = imports.beautify.native.getTextWidth(option_title, 1, loginUI.phases[1].optionsUI.font) + 5, FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].play.height
                local options_offsetX, options_offsetY = loginUI.phases[1].optionsUI.startX - (option_width*0.5), j.startY
                local isOptionHovered = isMouseOnPosition(options_offsetX, options_offsetY, option_width, option_height)
                if isOptionHovered then
                    if isLMBClicked then
                        imports.triggerEvent("Client:onEnableLoginUI", localPlayer, false)
                        imports.setTimer(function() j.exec() end, 1, 1)
                    end
                    if j.hoverStatus ~= "forward" then
                        j.hoverStatus = "forward"
                        j.hoverAnimTick = CLIENT_CURRENT_TICK
                    end
                else
                    if j.hoverStatus ~= "backward" then
                        j.hoverStatus = "backward"
                        j.hoverAnimTick = CLIENT_CURRENT_TICK
                    end
                end
                j.animAlphaPercent = j.animAlphaPercent or 0
                j.animAlphaPercent = ((j.hoverStatus == "forward") and imports.interpolateBetween(j.animAlphaPercent, 0, 0, 1, 0, 0, imports.getInterpolationProgress(j.hoverAnimTick, FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].play.hoverDuration), "Linear")) or imports.interpolateBetween(j.animAlphaPercent, 0, 0, 0, 0, 0, imports.getInterpolationProgress(j.hoverAnimTick, FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].play.hoverDuration), "Linear")
                imports.beautify.native.drawText(option_title, options_offsetX, options_offsetY, options_offsetX + option_width, options_offsetY + option_height, loginUI.phases[1].optionsUI.fontColor, 1, loginUI.phases[1].optionsUI.font, "center", "center", true, false, false)
                imports.beautify.native.drawText(option_title, options_offsetX, options_offsetY, options_offsetX + option_width, options_offsetY + option_height, tocolor(FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].play.hoverfontColor[1], FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].play.hoverfontColor[2], FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].play.hoverfontColor[3], FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].play.hoverfontColor[4]*j.animAlphaPercent), 1, loginUI.phases[1].optionsUI.font, "center", "center", true, false, false)
                imports.beautify.native.drawRectangle(options_offsetX + ((option_width - (option_width*j.animAlphaPercent))*0.5), options_offsetY + option_height, option_width*j.animAlphaPercent, FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].play.embedLineSize, tocolor(unpackColor(FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].play.embedLineColor)), false)
            end
        elseif loginUI.phase == 2 then
            --Draws Character UI
            
        elseif loginUI.phase == 3 then
            --Draws Credits UI
            imports.beautify.native.drawImage(background_offsetX, background_offsetY, background_width, background_height, loginUI.bgTexture, 0, 0, 0, tocolor(unpackColor(loginUI.phases[3].bgColor)), false)
            local view_offsetX, view_offsetY = loginUI.phases[3].startX, loginUI.phases[3].startY
            local view_width, view_height = loginUI.phases[3].width, loginUI.phases[3].height
            local credits_offsetY = -loginUI.phases[3].contentHeight - (view_height/2)
            if (CLIENT_CURRENT_TICK - loginUI.phases[3].scrollAnimTickCounter) >= loginUI.phases[3].scrollDelayDuration then
                credits_offsetY = view_offsetY + imports.interpolateBetween(credits_offsetY, 0, 0, view_height*1.5, 0, 0, imports.getInterpolationProgress(loginUI.phases[3].scrollAnimTickCounter + loginUI.phases[3].scrollDelayDuration, loginUI.phases[3].scrollDuration), "Linear")
                if (imports.math.round(credits_offsetY, 2) >= imports.math.round(view_height*1.5)) and loginUI.isEnabled then
                    imports.triggerEvent("Client:onEnableLoginUI", localPlayer, false)
                    imports.triggerEvent("Client:onSetLoginUIPhase", localPlayer, 1)
                end
            end
            imports.beautify.native.drawText(loginUI.phases[3].contentText, view_offsetX, credits_offsetY, view_offsetX + view_width, credits_offsetY + loginUI.phases[3].contentHeight, loginUI.phases[3].fontColor, 1, loginUI.phases[3].font, "center", "center", true, false, false, false, true)
            local navigator_title = FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].credits.navigator["Titles"][FRAMEWORK_LANGUAGE]
            local navigator_width, navigator_height = loginUI.phases[3].navigator.width + imports.beautify.native.getTextWidth(navigator_title, 1, loginUI.phases[3].navigator.font), loginUI.phases[3].navigator.height
            local navigator_offsetX, navigator_offsetY = loginUI.phases[3].navigator.startX + (CLIENT_MTA_RESOLUTION[1] - navigator_width), loginUI.phases[3].navigator.startY
            local isNavigatorHovered = isMouseOnPosition(navigator_offsetX, navigator_offsetY, navigator_width, navigator_height)
            if isNavigatorHovered then
                if isLMBClicked then
                    imports.triggerEvent("Client:onEnableLoginUI", localPlayer, false)
                    imports.setTimer(function() loginUI.phases[3].navigator.exec() end, 1, 1)
                end
                if loginUI.phases[3].navigator.hoverStatus ~= "forward" then
                    loginUI.phases[3].navigator.hoverStatus = "forward"
                    loginUI.phases[3].navigator.hoverAnimTick = CLIENT_CURRENT_TICK
                end
            else
                if loginUI.phases[3].navigator.hoverStatus ~= "backward" then
                    loginUI.phases[3].navigator.hoverStatus = "backward"
                    loginUI.phases[3].navigator.hoverAnimTick = CLIENT_CURRENT_TICK
                end
            end
            loginUI.phases[3].navigator.animAlphaPercent = loginUI.phases[3].navigator.animAlphaPercent or 0.25
            loginUI.phases[3].navigator.animAlphaPercent = ((loginUI.phases[3].navigator.hoverStatus == "forward") and imports.interpolateBetween(loginUI.phases[3].navigator.animAlphaPercent, 0, 0, 1, 0, 0, imports.getInterpolationProgress(loginUI.phases[3].navigator.hoverAnimTick, FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].play.hoverDuration), "Linear")) or imports.interpolateBetween(loginUI.phases[3].navigator.animAlphaPercent, 0, 0, 0.25, 0, 0, imports.getInterpolationProgress(loginUI.phases[3].navigator.hoverAnimTick, FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].play.hoverDuration), "Linear")
            imports.beautify.native.drawText(navigator_title, navigator_offsetX, navigator_offsetY, navigator_offsetX + navigator_width, navigator_offsetY + navigator_height, tocolor(loginUI.phases[3].navigator.fontColor[1], loginUI.phases[3].navigator.fontColor[2], loginUI.phases[3].navigator.fontColor[3], loginUI.phases[3].navigator.fontColor[4]*loginUI.phases[3].navigator.animAlphaPercent), 1, loginUI.phases[3].navigator.font, "center", "center", true, false, false)
        end
    end

end


------------------------------
--[[ Function: Toggles UI ]]--
------------------------------

toggleUI = function(state, Args)
    if (((state ~= true) and (state ~= false)) or (state == loginUI.state)) then return false end

    if state then
        loginUI.state = true
        loginUI.cinemationData = FRAMEWORK_CONFIGS["UI"]["Login"].spawnLocations[imports.math.random(#FRAMEWORK_CONFIGS["UI"]["Login"].spawnLocations)]
        imports.triggerEvent("Client:onSetLoginUIPhase", localPlayer, 1)
        imports.beautify.render.create(renderUI)
        imports.beautify.render.create(renderUI, {renderType = "input"})
        imports.triggerEvent("Sound:onToggleLogin", localPlayer, state, {
            shuffleMusic = (Args and Args.shuffleMusic and true) or false
        })
    else
        imports.beautify.render.remove(renderUI)
        imports.beautify.render.remove(renderUI, {renderType = "input"})
        exports.cinecam_handler:stopCinemation()
        if loginUI.character and imports.isElement(loginUI.character) then loginUI.character:destroy() end
        for i, j in imports.pairs(loginUI.cache.keys) do
            j = false
        end
        for i, j in imports.pairs(loginUI.cache.timers) do
            if j and imports.isTimer(j) then
                imports.killTimer(j)
                j = nil
            end
            j = false
        end
        loginUI.phase = false
        loginUI.cinemationData = false
        loginUI.character = false
        loginUI.character = 0
        loginUI._selectedCharacter = false
        loginUI.characters = {}
        loginUI.isPremium = false
        loginUI.state = false
        imports.triggerEvent("Sound:onToggleLogin", localPlayer, state)
    end
    imports.showChat(not state)
    imports.showCursor(state)
    return true
end


------------------------------------
--[[ Client: On Toggle Login UI ]]--
------------------------------------

imports.addEvent("Client:onToggleLoginUI", true)
imports.addEventHandler("Client:onToggleLoginUI", root, function(state, Args)
    if state then
        for i, j in imports.pairs(Args.characters) do
            j.__isPreLoaded = true
        end
        loginUI.character = Args.character
        loginUI._selectedCharacter = loginUI.character
        loginUI.characters = Args.characters
        loginUI._unsavedCharacters = {}
        loginUI._charactersUnderProcess = {}
        loginUI.premium = Args.premium
        imports.setElementPosition(localPlayer, FRAMEWORK_CONFIGS["UI"]["Login"].clientPoint.x, FRAMEWORK_CONFIGS["UI"]["Login"].clientPoint.y, FRAMEWORK_CONFIGS["UI"]["Login"].clientPoint.z)
        imports.setElementDimension(localPlayer, FRAMEWORK_CONFIGS["UI"]["Login"].dimension)
        imports.triggerEvent("Client:onEnableLoginUI", localPlayer, true, true)
        imports.triggerEvent("Client:onToggleLoadingUI", localPlayer, true)
        imports.setTimer(function()
            toggleUI(state, Args)
            imports.fadeCamera(true)
            imports.triggerEvent("Client:onToggleLoadingUI", localPlayer, false)
        end, FRAMEWORK_CONFIGS["UI"]["Login"].fadeDelay, 1)
    else
        toggleUI(state, Args)
    end
end)


-----------------------------------------
--[[ Event: On Client Resource Start ]]--
-----------------------------------------

imports.addEventHandler("onClientResourceStart", resource, function()
    imports.fadeCamera(false)
    imports.triggerEvent("Client:onToggleLoadingUI", localPlayer, true)
    imports.triggerServerEvent("Player:onToggleLoginUI", localPlayer)
end)






--[[
    --TODO: OLD..
                switcher = {
                    startX = -7,
                    startY = 0,
                    width = 30,
                    height = 30,
                    paddingX = 7,
                    paddingY = 7,
                    bgTexture = imports.beautify.native.createTexture("files/images/hud/curved_square/square.png", "dxt5", true, "clamp"),
                    font = FRAMEWORK_FONTS[6],
                    outlineWeight = 0.1,
                    fontColor = {255, 80, 80, 255},
                    bgColor = {0, 0, 0, 255},
                    hoverfontColor = {0, 0, 0, 255},
                    hoverBGColor = {255, 80, 80, 255},
                    hoverDuration = 2500,
                    {
                        title = "❮",
                        exec = function() manageCharacter("switch_prev") end
                    },
                    {
                        title = "❯",
                        exec = function() manageCharacter("switch_next") end
                    },
                    {
                        title = "X",
                        exec = function() manageCharacter("delete") end
                    },
                    {
                        title = "✎",
                        exec = function() manageCharacter("create") end
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
                    hoverDuration = 2500,
                    --leftCurvedEdgePath = imports.beautify.native.createTexture("files/images/hud/curved_square/left.png", "dxt5", true, "clamp"),
                    --rightCurvedEdgePath = imports.beautify.native.createTexture("files/images/hud/curved_square/right.png", "dxt5", true, "clamp"),
                    {
                        title = "B A C K",
                        exec = function() imports.triggerEvent("Client:onSetLoginUIPhase", localPlayer, 1) end
                    },
                    {
                        title = "S A V E",
                        exec = function() manageCharacter("save") end
                    },
                    {
                        title = "P I C K",
                        exec = function() manageCharacter("pick") end
                    }
                }
            }
]]