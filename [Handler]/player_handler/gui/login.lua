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
    tocolor = tocolor,
    unpackColor = unpackColor,
    isElement = isElement,
    createPed = createPed,
    destroyElement = destroyElement,
    setElementFrozen = setElementFrozen,
    setElementPosition = setElementPosition,
    setElementDimension = setElementDimension,
    addEvent = addEvent,
    addEventHandler = addEventHandler,
    removeEventHandler = removeEventHandler,
    triggerEvent = triggerEvent,
    triggerServerEvent = triggerServerEvent,
    isTimer = isTimer,
    setTimer = setTimer,
    killTimer = killTimer,
    isMouseOnPosition = isMouseOnPosition,
    interpolateBetween = interpolateBetween,
    getInterpolationProgress = getInterpolationProgress,
    fadeCamera = fadeCamera,
    showChat = showChat,
    showCursor = showCursor,
    table = table,
    math = math,
    string = string,
    beautify = beautify,
    assetify = assetify
}


-------------------
--[[ Variables ]]--
-------------------

local loginUI = nil
loginUI = {
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
                embedLineColor = imports.tocolor(imports.unpackColor(FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].play.embedLineColor)),
                {identifier = "play", exec = function() loginUI.phases[2].manageCharacter("play") end},
                {identifier = "characters", exec = function() imports.triggerEvent("Client:onSetLoginUIPhase", localPlayer, 2) end},
                {identifier = "credits", exec = function() imports.triggerEvent("Client:onSetLoginUIPhase", localPlayer, 3) end}
            }
        },
        [2] = {
            startX = 0, startY = 0,
            width = FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].characters.width, height = FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].characters.height,
            titlebar = {
                paddingY = 2,
                height = FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].characters.titlebar.height,
                font = FRAMEWORK_FONTS[3], fontColor = imports.tocolor(imports.unpackColor(FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].characters.titlebar.fontColor)),
                bgColor = imports.tocolor(imports.unpackColor(FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].characters.titlebar.bgColor)),
                shadowColor = imports.tocolor(imports.unpackColor(FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].characters.titlebar.shadowColor)),
            },
            options = {
                startX = 5, startY = 5,
                paddingX = 5, paddingY = 5,
                size = FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].characters.options.size, iconSize = FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].characters.options.iconSize,
                iconColor = FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].characters.options.iconColor,
                bgColor = imports.tocolor(imports.unpackColor(FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].characters.options.bgColor)),
                {iconTexture = imports.beautify.assets["images"]["arrow/left.rw"], tooltip = FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].characters.options.tooltips.previous, exec = function() loginUI.phases[2].manageCharacter("previous") end},
                {iconTexture = imports.beautify.assets["images"]["arrow/right.rw"], tooltip = FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].characters.options.tooltips.next, exec = function() loginUI.phases[2].manageCharacter("next") end},
                {iconTexture = imports.beautify.assets["images"]["canvas/pick.rw"], tooltip = FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].characters.options.tooltips.pick, exec = function() loginUI.phases[2].manageCharacter("pick") end},
                {iconTexture = imports.beautify.assets["images"]["canvas/plus.rw"], tooltip = FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].characters.options.tooltips.create, exec = function() loginUI.phases[2].manageCharacter("create") end},
                {iconTexture = imports.beautify.assets["images"]["canvas/minus.rw"], tooltip = FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].characters.options.tooltips.delete, exec = function() loginUI.phases[2].manageCharacter("delete") end},
                {iconTexture = imports.beautify.assets["images"]["canvas/save.rw"], tooltip = FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].characters.options.tooltips.save, exec = function() loginUI.phases[2].manageCharacter("save") end},
                {iconTexture = imports.beautify.assets["images"]["canvas/back.rw"], tooltip = FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].characters.options.tooltips.back, exec = function() imports.triggerEvent("Client:onSetLoginUIPhase", localPlayer, 1) end}
            },
            categories = {
                paddingX = 20, paddingY = 5,
                height = FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].characters.categories.height,
                font = FRAMEWORK_FONTS[4], fontColor = imports.tocolor(imports.unpackColor(FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].characters.categories.fontColor)),
                bgColor = imports.tocolor(imports.unpackColor(FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].characters.categories.bgColor)),
                {
                    identifier = "Identity",
                    height = 120,
                    contents = {
                        tone = {
                            identifier = "tone",
                            isSlider = true,
                            startY = 30, paddingY = -8,
                            height = 30
                        },
                        gender = {
                            identifier = "gender",
                            isSelector = true,
                            startY = 90,
                            height = 30
                        }
                    }
                },
                {
                    identifier = "Facial",
                    height = 60,
                    contents = {
                        hair = {
                            identifier = "hair",
                            isSelector = true, isClothing = true,
                            startY = 30,
                            height = 30
                        }
                    }
                },
                {
                    identifier = "Upper",
                    isSelector = true, isClothing = true,
                    height = 40
                },
                {
                    identifier = "Lower",
                    isSelector = true, isClothing = true,
                    height = 40
                },
                {
                    identifier = "Shoes",
                    isSelector = true, isClothing = true,
                    height = 40
                }
            }
        },
        [3] = {
            startX = 0, startY = 15,
            width = 0, height = -15,
            font = FRAMEWORK_FONTS[5], fontColor = imports.tocolor(imports.unpackColor(FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].credits.fontColor)),
            scrollAnimTickCounter = CLIENT_CURRENT_TICK,
            scrollDelayDuration = FRAMEWORK_CONFIGS["UI"]["Loading"].fadeOutDuration + FRAMEWORK_CONFIGS["UI"]["Loading"].fadeDelayDuration - 1000,
            navigator = {
                startX = -5, startY = 5,
                width = 0, height = 25,
                font = FRAMEWORK_FONTS[3], fontColor = {200, 200, 200, 255},
                hoverStatus = "backward",
                hoverAnimTick = CLIENT_CURRENT_TICK,
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
loginUI.phases[2].options.startX = loginUI.phases[2].startX + loginUI.phases[2].width + loginUI.phases[2].options.startX + loginUI.phases[2].options.paddingX
loginUI.phases[2].options.iconX = loginUI.phases[2].options.startX + ((loginUI.phases[2].options.size - loginUI.phases[2].options.iconSize)*0.5)
for i = 1, #loginUI.phases[2].options, 1 do
    local j = loginUI.phases[2].options[i]
    j.startY = loginUI.phases[2].startY + loginUI.phases[2].options.startY + ((loginUI.phases[2].options.size + loginUI.phases[2].options.paddingY)*(i - 1))
    j.iconY = j.startY + ((loginUI.phases[2].options.size - loginUI.phases[2].options.iconSize)*0.5)
    j.hoverStatus = "backward"
    j.tooltipStatus = "backward"
    j.hoverAnimTick = CLIENT_CURRENT_TICK
end
loginUI.phases[2].updateUILang = function(gender)
    for i = 1, #loginUI.phases[2].options, 1 do
        local j = loginUI.phases[2].options[i]
        --TODO: THIS MUST UPDATE DYNNAMICALLY WHEN PLAYER CHANGES LANGUAGE..
        j.tooltip = {text = j.tooltip, width = imports.beautify.native.getTextWidth(text, 1, FRAMEWORK_FONTS[8]) + 20}
    end
    for i = 1, #loginUI.phases[2].categories, 1 do
        local j = loginUI.phases[2].categories[i]
        j.title = imports.string.upper(imports.string.spaceChars(FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].characters.categories[(j.identifier)]["Titles"][FRAMEWORK_LANGUAGE]))
        if j.contents then
            for k, v in imports.pairs(j.contents) do
                v.title = imports.string.upper(imports.string.spaceChars(FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].characters.categories[(j.identifier)][(v.identifier)]["Titles"][FRAMEWORK_LANGUAGE]))
                if v.isSelector then
                    v.contentIndex, v.content = {}, {}
                    for m, n in imports.pairs((v.isClothing and FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].characters.categories[(j.identifier)][(v.identifier)]["Datas"][gender]) or FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].characters.categories[(j.identifier)][(v.identifier)]["Datas"]) do
                        imports.table.insert(v.contentIndex, m)
                        imports.table.insert(v.content, imports.string.upper(imports.string.spaceChars(n[FRAMEWORK_LANGUAGE])))
                    end
                end
            end
        elseif j.isSelector then
            j.contentIndex, j.content = {}, {}
            for k, v in imports.pairs(FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].characters.categories[(j.identifier)]["Datas"][gender]) do
                imports.table.insert(j.contentIndex, k)
                imports.table.insert(j.content, imports.string.upper(imports.string.spaceChars(v[FRAMEWORK_LANGUAGE])))
            end
        end
    end
end
loginUI.phases[2].fetchSelection = function()
    local tone = imports.beautify.slider.getPercent(loginUI.phases[2].categories[1].contents.tone.element)
    local gender = loginUI.phases[2].categories[1].contents.gender.contentIndex[(imports.beautify.selector.getSelection(loginUI.phases[2].categories[1].contents.gender.element))]
    local hair = loginUI.phases[2].categories[2].contents.hair.contentIndex[(imports.beautify.selector.getSelection(loginUI.phases[2].categories[2].contents.hair.element))]
    local upper = loginUI.phases[2].categories[3].contentIndex[(imports.beautify.selector.getSelection(loginUI.phases[2].categories[3].element))]
    local lower = loginUI.phases[2].categories[4].contentIndex[(imports.beautify.selector.getSelection(loginUI.phases[2].categories[4].element))]
    local shoes = loginUI.phases[2].categories[5].contentIndex[(imports.beautify.selector.getSelection(loginUI.phases[2].categories[5].element))]
    return {
        tone = tone,
        gender = gender,
        hair = hair,
        upper = upper,
        lower = lower,
        shoes = shoes
    }
end
loginUI.phases[2].updateCharacter = function()
    local characterClothing = {CCharacter.generateClothing((loginUI.phases[2].fetchSelection()))}
    imports.assetify.setElementAsset(loginUI.phases[2].character, characterClothing[1], characterClothing[2], characterClothing[3])
end
loginUI.phases[2].loadCharacter = function(loadDefault)
    if not loadDefault then
        if not loginUI.characters[(loginUI.previewCharacter)] then
            if #loginUI.characters > 0 then
                loginUI.character = 1
                loginUI.previewCharacter = loginUI.character
            else
                loadDefault = true
            end
        end
        if not loadDefault and not loginUI.characters[(loginUI.previewCharacter)].identity then loadDefault = true end
    end
    if loadDefault then
        for i = 1, #loginUI.phases[2].categories, 1 do
            local j = loginUI.phases[2].categories[i]
            if j.contents then
                for k, v in imports.pairs(j.contents) do
                    if v.slider then
                        imports.beautify.slider.setPercent(v.element, 0)
                    elseif v.isSelector then
                        imports.beautify.selector.setSelection(v.element, 1)
                    end
                end
            elseif j.isSelector then
                imports.beautify.selector.setSelection(j.element, 1)
            end
        end
        loginUI.phases[2].updateUILang(FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].characters.categories["Identity"].gender.default)
    else
        for i = 1, #loginUI.phases[2].categories[1].contents.gender.contentIndex, 1 do
            local j = loginUI.phases[2].categories[1].contents.gender.contentIndex[i]
            if j == (loginUI.characters[(loginUI.previewCharacter)].identity.gender or FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].characters.categories["Identity"].gender.default) then
                imports.beautify.selector.setSelection(loginUI.phases[2].categories[3].element, i)
                break
            end
        end
        imports.beautify.slider.getPercent(loginUI.phases[2].categories[1].contents.tone.element, loginUI.characters[(loginUI.previewCharacter)].identity.tone or 0)
        imports.beautify.selector.setSelection(loginUI.phases[2].categories[2].contents.hair.element, loginUI.characters[(loginUI.previewCharacter)].identity.hair or 1)
        imports.beautify.selector.setSelection(loginUI.phases[2].categories[3].element, loginUI.characters[(loginUI.previewCharacter)].identity.upper or 1)
        imports.beautify.selector.setSelection(loginUI.phases[2].categories[4].element, loginUI.characters[(loginUI.previewCharacter)].identity.lower or 1)
        imports.beautify.selector.setSelection(loginUI.phases[2].categories[5].element, loginUI.characters[(loginUI.previewCharacter)].identity.shoes or 1)
    end
    loginUI.phases[2].updateCharacter()
    return true
end
loginUI.phases[2].manageCharacter = function(action)
    if not action then return false end
    if action == "create" then
        local errorMessage = false
        local characterLimit = (loginUI.isVIP and FRAMEWORK_CONFIGS["Game"]["Character_Limit"].vip) or FRAMEWORK_CONFIGS["Game"]["Character_Limit"].default
        if #loginUI.characters >= characterLimit then errorMessage = FRAMEWORK_CONFIGS["UI"]["Login"]["Notifications"][3][FRAMEWORK_LANGUAGE] end
        imports.triggerEvent("Client:onEnableLoginUI", localPlayer, true)
        if errorMessage then
            imports.triggerEvent("Client:onNotification", localPlayer, errorMessage, FRAMEWORK_CONFIGS["UI"]["Notification"].presets.error)
            return false
        else
            imports.table.insert(loginUI.characters, {})
            loginUI.previewCharacter = #loginUI.characters
            loginUI.phases[2].loadCharacter(true)
            imports.triggerEvent("Client:onNotification", localPlayer, FRAMEWORK_CONFIGS["UI"]["Login"]["Notifications"][4][FRAMEWORK_LANGUAGE], FRAMEWORK_CONFIGS["UI"]["Notification"].presets.success)
        end
    elseif action == "delete" then
        local errorMessage = false
        if #loginUI.characters <= 0 then errorMessage = FRAMEWORK_CONFIGS["UI"]["Login"]["Notifications"][5][FRAMEWORK_LANGUAGE] end
        imports.triggerEvent("Client:onEnableLoginUI", localPlayer, true)
        if errorMessage then
            imports.triggerEvent("Client:onNotification", localPlayer, errorMessage, FRAMEWORK_CONFIGS["UI"]["Notification"].presets.error)
            return false
        else
            if loginUI.characters[(loginUI.previewCharacter)].id then imports.triggerServerEvent("Player:onDeleteCharacter", localPlayer, loginUI.characters[(loginUI.previewCharacter)].id) end
            imports.table.remove(loginUI.characters, loginUI.previewCharacter)
            loginUI.previewCharacter = imports.math.max(0, loginUI.previewCharacter - 1)
            loginUI.phases[2].loadCharacter()
            imports.triggerEvent("Client:onNotification", localPlayer, FRAMEWORK_CONFIGS["UI"]["Login"]["Notifications"][6][FRAMEWORK_LANGUAGE], FRAMEWORK_CONFIGS["UI"]["Notification"].presets.success)
        end
    elseif (action == "previous") or (action == "next") then
        imports.triggerEvent("Client:onEnableLoginUI", localPlayer, true)
        if loginUI.characters[(loginUI.previewCharacter)] and not loginUI.characters[(loginUI.previewCharacter)].id then
            imports.triggerEvent("Client:onNotification", localPlayer, FRAMEWORK_CONFIGS["UI"]["Login"]["Notifications"][11][FRAMEWORK_LANGUAGE], FRAMEWORK_CONFIGS["UI"]["Notification"].presets.error)
            return false
        else
            if action == "previous" then
                if loginUI.previewCharacter > 1 then
                    loginUI.previewCharacter = loginUI.previewCharacter - 1
                    loginUI.phases[2].loadCharacter()
                end
            elseif action == "next" then
                if loginUI.previewCharacter < #loginUI.characters then
                    loginUI.previewCharacter = loginUI.previewCharacter + 1
                    loginUI.phases[2].loadCharacter()
                end
            end
        end
    elseif action == "pick" then
        local errorMessage = false
        if (not loginUI.characters[(loginUI.previewCharacter)]) or not loginUI.characters[(loginUI.previewCharacter)].id then errorMessage = FRAMEWORK_CONFIGS["UI"]["Login"]["Notifications"][7][FRAMEWORK_LANGUAGE] end
        imports.triggerEvent("Client:onEnableLoginUI", localPlayer, true)
        if errorMessage then
            imports.triggerEvent("Client:onNotification", localPlayer, errorMessage, FRAMEWORK_CONFIGS["UI"]["Notification"].presets.error)
            return false
        else
            loginUI.character = loginUI.previewCharacter
            imports.triggerEvent("Client:onNotification", localPlayer, FRAMEWORK_CONFIGS["UI"]["Login"]["Notifications"][8][FRAMEWORK_LANGUAGE], FRAMEWORK_CONFIGS["UI"]["Notification"].presets.success)
        end
    elseif action == "save" then
        if (#loginUI.characters > 0) and loginUI.characters[(loginUI.previewCharacter)].id then
            imports.triggerEvent("Client:onEnableLoginUI", localPlayer, true)
            return false
        else
            imports.triggerEvent("Client:onEnableLoginUI", localPlayer, false, true)
            local characterData = loginUI.phases[2].fetchSelection()
            if #loginUI.characters <= 0 then loginUI.previewCharacter = 1 end
            loginUI.processCharacters[(loginUI.previewCharacter)] = true
            loginUI.characters[(loginUI.previewCharacter)] = loginUI.characters[(loginUI.previewCharacter)] or {}
            loginUI.characters[(loginUI.previewCharacter)].identity = characterData
            imports.triggerServerEvent("Player:onSaveCharacter", localPlayer, loginUI.previewCharacter, loginUI.characters)
        end
    elseif action == "play" then
        local errorMessage = false
        if #loginUI.characters <= 0 then errorMessage = FRAMEWORK_CONFIGS["UI"]["Login"]["Notifications"][1][FRAMEWORK_LANGUAGE] end
        if not loginUI.characters[loginUI.character] then errorMessage = FRAMEWORK_CONFIGS["UI"]["Login"]["Notifications"][2][FRAMEWORK_LANGUAGE] end
        if errorMessage then
            imports.triggerEvent("Client:onEnableLoginUI", localPlayer, true)
            imports.triggerEvent("Client:onNotification", localPlayer, errorMessage, FRAMEWORK_CONFIGS["UI"]["Notification"].presets.error)
            return false
        else
            imports.triggerEvent("Client:onEnableLoginUI", localPlayer, false, true)
            imports.triggerEvent("Client:onToggleLoadingUI", localPlayer, true)
            imports.setTimer(function(character, characters)
                imports.triggerServerEvent("Player:onResume", localPlayer, character, characters)
            end, FRAMEWORK_CONFIGS["UI"]["Loading"].fadeInDuration + FRAMEWORK_CONFIGS["UI"]["Loading"].fadeOutDuration + FRAMEWORK_CONFIGS["UI"]["Loading"].fadeDelayDuration, 1, loginUI.character, loginUI.characters)
            imports.setTimer(function()
                loginUI.toggleUI(false)
            end, FRAMEWORK_CONFIGS["UI"]["Loading"].fadeInDuration + 250, 1)
        end
    end
    return true
end
loginUI.phases[2].toggleUI = function(state)
    if state then
        if loginUI.phases[2].element and imports.isElement(loginUI.phases[2].element) then return false end
        loginUI.phases[2].updateUILang(FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].characters.categories["Identity"].gender.default)
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
                        imports.addEventHandler("onClientUISliderAltered", v.element, function() loginUI.phases[2].updateCharacter() end)
                    elseif v.isSelector then
                        v.element = imports.beautify.selector.create(loginUI.phases[2].categories.paddingX, j.offsetY + loginUI.phases[2].categories.height + v.startY, loginUI.phases[2].width - (loginUI.phases[2].categories.paddingX*2), v.height, "horizontal", loginUI.phases[2].element, false)
                        imports.beautify.selector.setDataList(v.element, v.content)
                        imports.beautify.setUIVisible(v.element, true)
                        imports.addEventHandler("onClientUISelectionAltered", v.element, function() loginUI.phases[2].updateCharacter() end)
                    end
                end
            elseif j.isSelector then
                j.element = imports.beautify.selector.create(loginUI.phases[2].categories.paddingX, j.offsetY + loginUI.phases[2].categories.height, loginUI.phases[2].width - (loginUI.phases[2].categories.paddingX*2), j.height, "horizontal", loginUI.phases[2].element, false)
                imports.beautify.selector.setDataList(j.element, j.content)
                imports.beautify.setUIVisible(j.element, true)
                imports.addEventHandler("onClientUISelectionAltered", j.element, function() loginUI.phases[2].updateCharacter() end)
            end
        end
        imports.beautify.render.create(function()
            imports.beautify.native.drawRectangle(0, 0, loginUI.phases[2].width, loginUI.phases[2].titlebar.height, loginUI.phases[2].titlebar.bgColor, false)
            imports.beautify.native.drawText(imports.string.upper(imports.string.spaceChars(FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].characters.titlebar["Titles"][FRAMEWORK_LANGUAGE])), 0, 0, loginUI.phases[2].width, loginUI.phases[2].titlebar.height, loginUI.phases[2].titlebar.fontColor, 1, loginUI.phases[2].titlebar.font, "center", "center", true, false, false)
            imports.beautify.native.drawRectangle(0, loginUI.phases[2].titlebar.height, loginUI.phases[2].width, loginUI.phases[2].titlebar.paddingY, loginUI.phases[2].titlebar.shadowColor, false)
            for i = 1, #loginUI.phases[2].categories, 1 do
                local j = loginUI.phases[2].categories[i]
                local category_offsetY = j.offsetY + loginUI.phases[2].categories.height
                imports.beautify.native.drawRectangle(0, j.offsetY, loginUI.phases[2].width, loginUI.phases[2].categories.height, loginUI.phases[2].titlebar.bgColor, false)
                imports.beautify.native.drawText(j.title, 0, j.offsetY, loginUI.phases[2].width, category_offsetY, loginUI.phases[2].categories.fontColor, 1, loginUI.phases[2].categories.font, "center", "center", true, false, false)
                imports.beautify.native.drawRectangle(0, category_offsetY, loginUI.phases[2].width, j.height, loginUI.phases[2].categories.bgColor, false)
                if j.contents then
                    for k, v in imports.pairs(j.contents) do
                        local title_height = loginUI.phases[2].categories.height
                        local title_offsetY = category_offsetY + v.startY - title_height
                        imports.beautify.native.drawRectangle(0, title_offsetY, loginUI.phases[2].width, title_height, loginUI.phases[2].titlebar.bgColor, false)
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
        loginUI.phases[2].element = nil
    end
    return true
end
loginUI.phases[3].contentText = ""
for i = 1, #FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].credits.contributors do
    local j = FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].credits.contributors[i]
    loginUI.phases[3].contentText = ((i == 1) and j) or loginUI.phases[3].contentText.."\n\n"..j
end
loginUI.phases[3].width, loginUI.phases[3].height = loginUI.phases[3].width + (CLIENT_MTA_RESOLUTION[1] - loginUI.phases[3].startX), loginUI.phases[3].height + (CLIENT_MTA_RESOLUTION[2] - loginUI.phases[3].startY)
loginUI.phases[3].contentWidth, loginUI.phases[3].contentHeight = imports.beautify.native.getTextSize(loginUI.phases[3].contentText, loginUI.phases[3].width, 1, loginUI.phases[3].font, false)
loginUI.phases[3].scrollDuration = imports.math.max(1, imports.math.ceil((loginUI.phases[3].contentHeight + loginUI.phases[3].height)/loginUI.phases[3].height))*FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].credits.scrollDuration


------------------------------
--[[ Function: UI Helpers ]]--
------------------------------

function isLoginUIVisible() return loginUI.state end

imports.addEvent("Client:onSetLoginUIPhase", true)
imports.addEventHandler("Client:onSetLoginUIPhase", root, function(phaseID)
    if not phaseID or not loginUI.phases[1].optionsUI[phaseID] or (loginUI.phase and loginUI.phase == phaseID) then return false end
    for i, j in imports.pairs(loginUI.cache.timers) do
        if j and imports.isTimer(j) then
            imports.killTimer(j)
            loginUI.cache.timers[i] = nil
        end
    end
    imports.triggerEvent("Client:onToggleLoadingUI", localPlayer, true)
    loginUI.cache.timers.phaseChanger = imports.setTimer(function()
        for i = 1, #loginUI.characters, 1 do
            local j = loginUI.characters[i]
            if not j.id then
                imports.table.remove(loginUI.characters, i)
            end
        end
        loginUI.phases[2].toggleUI(false)
        if phaseID == 1 then
            exports.cinecam_handler:startCinemation(loginUI.cinemationData.cinemationPoint, true, true, loginUI.cinemationData.cinemationFOV, true, true, true, false)
        elseif phaseID == 2 then
            if loginUI.phases[2].character and imports.isElement(loginUI.phases[2].character) then imports.destroyElement(loginUI.phases[2].character); loginUI.phases[2].character = nil end
            exports.cinecam_handler:startCinemation(loginUI.cinemationData.characterCinemationPoint, true, true, loginUI.cinemationData.characterCinemationFOV, true, true, true, false)
            loginUI.phases[2].character = imports.createPed(0, loginUI.cinemationData.characterPoint.x, loginUI.cinemationData.characterPoint.y, loginUI.cinemationData.characterPoint.z, loginUI.cinemationData.characterPoint.rotation)
            imports.setElementDimension(loginUI.phases[2].character, FRAMEWORK_CONFIGS["UI"]["Login"].dimension)
            imports.setElementFrozen(loginUI.phases[2].character, true)
            loginUI.phases[2].toggleUI(true)
            loginUI.phases[2].loadCharacter()
        else
            exports.cinecam_handler:stopCinemation()
            if phaseID == 3 then
                loginUI.phases[3].scrollAnimTickCounter = CLIENT_CURRENT_TICK
            end
        end
        loginUI.phase = phaseID
        imports.triggerEvent("Client:onToggleLoadingUI", localPlayer, false)
        loginUI.cache.timers.phaseChanger = false
    end, FRAMEWORK_CONFIGS["UI"]["Loading"].fadeInDuration + 250, 1)
    loginUI.cache.timers.uiEnabler = imports.setTimer(function()
        imports.triggerEvent("Client:onEnableLoginUI", localPlayer, true)
        loginUI.cache.timers.uiEnabler = false
    end, FRAMEWORK_CONFIGS["UI"]["Loading"].fadeOutDuration + FRAMEWORK_CONFIGS["UI"]["Loading"].fadeDelayDuration - (FRAMEWORK_CONFIGS["UI"]["Loading"].fadeInDuration + 250), 1)
end)

imports.addEvent("Client:onEnableLoginUI", true)
imports.addEventHandler("Client:onEnableLoginUI", root, function(state, isForced)
    if loginUI.cache.timers.uiEnabler and imports.isTimer(loginUI.cache.timers.uiEnabler) then
        imports.killTimer(loginUI.cache.timers.uiEnabler)
        loginUI.cache.timers.uiEnabler = nil
    end
    if isForced then loginUI.isForcedDisabled = not state end
    loginUI.isEnabled = state
end)

imports.addEvent("Client:onSaveCharacter", true)
imports.addEventHandler("Client:onSaveCharacter", root, function(state, character, characterData)
    if state then
        loginUI.characters[character] = characterData
        imports.triggerEvent("Client:onNotification", localPlayer, FRAMEWORK_CONFIGS["UI"]["Login"]["Notifications"][9][FRAMEWORK_LANGUAGE], FRAMEWORK_CONFIGS["UI"]["Notification"].presets.success)
    else
        imports.triggerEvent("Client:onNotification", localPlayer, FRAMEWORK_CONFIGS["UI"]["Login"]["Notifications"][10][FRAMEWORK_LANGUAGE], FRAMEWORK_CONFIGS["UI"]["Notification"].presets.error)
    end
    loginUI.processCharacters[character] = nil
    imports.triggerEvent("Client:onEnableLoginUI", localPlayer, true, true)
end)


------------------------------
--[[ Function: Renders UI ]]--
------------------------------

loginUI.renderUI = function(renderData)
    if not loginUI.state or CPlayer.isInitialized(localPlayer) then return false end
    if not loginUI.phase then return false end

    if renderData.renderType == "input" then
        loginUI.cache.keys.mouse = isMouseClicked()
        local weatherData = FRAMEWORK_CONFIGS["UI"]["Login"].weathers[(loginUI.phase)] or FRAMEWORK_CONFIGS["UI"]["Login"].weathers[1]
        imports.triggerEvent("Player:onSyncWeather", localPlayer, weatherData.weather, weatherData.time)
    elseif renderData.renderType == "render" then
        local isUIEnabled = (loginUI.isEnabled and not loginUI.isForcedDisabled)
        local isLMBClicked = (loginUI.cache.keys.mouse == "mouse1") and isUIEnabled
        local currentRatio = (CLIENT_MTA_RESOLUTION[1]/CLIENT_MTA_RESOLUTION[2])/(1366/768)
        local background_width, background_height = CLIENT_MTA_RESOLUTION[1], CLIENT_MTA_RESOLUTION[2]*currentRatio
        local background_offsetX, background_offsetY = 0, -(background_height - CLIENT_MTA_RESOLUTION[2])*0.5
        if background_offsetY > 0 then
            background_width, background_height = CLIENT_MTA_RESOLUTION[1]/currentRatio, CLIENT_MTA_RESOLUTION[2]
            background_offsetX, background_offsetY = -(background_width - CLIENT_MTA_RESOLUTION[1])*0.5, 0
        end
        if loginUI.phase == 1 then
            imports.beautify.native.drawImage(background_offsetX, background_offsetY, background_width, background_height, loginUI.phases[loginUI.phase].bgTexture, 0, 0, 0, -1, false)
            for i = 1, #loginUI.phases[1].optionsUI, 1 do
                local j = loginUI.phases[1].optionsUI[i]
                local option_title = imports.string.upper(imports.string.spaceChars(FRAMEWORK_CONFIGS["UI"]["Login"]["Options"][(j.identifier)]["Titles"][FRAMEWORK_LANGUAGE], "  "))
                local option_width, option_height = imports.beautify.native.getTextWidth(option_title, 1, loginUI.phases[1].optionsUI.font) + 5, FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].play.height
                local options_offsetX, options_offsetY = loginUI.phases[1].optionsUI.startX - (option_width*0.5), j.startY
                local isOptionHovered = imports.isMouseOnPosition(options_offsetX, options_offsetY, option_width, option_height) and isUIEnabled
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
                imports.beautify.native.drawText(option_title, options_offsetX, options_offsetY, options_offsetX + option_width, options_offsetY + option_height, imports.tocolor(FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].play.hoverfontColor[1], FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].play.hoverfontColor[2], FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].play.hoverfontColor[3], FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].play.hoverfontColor[4]*j.animAlphaPercent), 1, loginUI.phases[1].optionsUI.font, "center", "center", true, false, false)
                imports.beautify.native.drawRectangle(options_offsetX + ((option_width - (option_width*j.animAlphaPercent))*0.5), options_offsetY + option_height, option_width*j.animAlphaPercent, FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].play.embedLineSize, loginUI.phases[1].optionsUI.embedLineColor, false)
            end
        elseif loginUI.phase == 2 then
            imports.beautify.setUIDisabled(loginUI.phases[2].element, not isUIEnabled or (loginUI.characters[(loginUI.previewCharacter)] and loginUI.characters[(loginUI.previewCharacter)].id and true) or false)
            for i = 1, #loginUI.phases[2].options, 1 do
                local j = loginUI.phases[2].options[i]
                local isOptionHovered = imports.isMouseOnPosition(loginUI.phases[2].options.startX, j.startY, loginUI.phases[2].options.size, loginUI.phases[2].options.size) and isUIEnabled
                if isOptionHovered then
                    if isLMBClicked then
                        imports.triggerEvent("Client:onEnableLoginUI", localPlayer, false)
                        imports.setTimer(function() j.exec() end, 1, 1)
                    end
                    if j.hoverStatus ~= "forward" then
                        j.hoverStatus = "forward"
                        j.tooltipStatus = "forward"
                        j.hoverAnimTick = CLIENT_CURRENT_TICK
                    end
                else
                    if j.hoverStatus ~= "backward" then
                        j.hoverStatus = "backward"
                        j.tooltipStatus = "backward"
                        j.hoverAnimTick = CLIENT_CURRENT_TICK
                    end
                end
                j.animAlphaPercent = j.animAlphaPercent or 0.35
                j.animTooltipPercent = j.animTooltipPercent or 0
                j.animAlphaPercent = ((j.hoverStatus == "forward") and imports.interpolateBetween(j.animAlphaPercent, 0, 0, 1, 0, 0, imports.getInterpolationProgress(j.hoverAnimTick, FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].characters.options.hoverDuration), "Linear")) or imports.interpolateBetween(j.animAlphaPercent, 0, 0, 0.35, 0, 0, imports.getInterpolationProgress(j.hoverAnimTick, FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].characters.options.hoverDuration), "Linear")
                --TODO: FLYFORKIN'S CONTIRBUTION UPDATE
                j.animTooltipPercent = ((j.tooltipStatus == "forward") and imports.interpolateBetween(j.animTooltipPercent, 0, 0, 1, 0, 0, imports.getInterpolationProgress(j.hoverAnimTick, FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].characters.options.hoverDuration), "Linear")) or imports.interpolateBetween(j.animTooltipPercent, 0, 0, 0, 0, 0, imports.getInterpolationProgress(j.hoverAnimTick, FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].characters.options.hoverDuration), "Linear")
                imports.beautify.native.drawRectangle(loginUI.phases[2].options.startX, j.startY, loginUI.phases[2].options.size, loginUI.phases[2].options.size, loginUI.phases[2].options.bgColor, false)
                imports.beautify.native.drawImage(loginUI.phases[2].options.iconX, j.iconY, loginUI.phases[2].options.iconSize, loginUI.phases[2].options.iconSize, j.iconTexture, 0, 0, 0, imports.tocolor(loginUI.phases[2].options.iconColor[1], loginUI.phases[2].options.iconColor[2], loginUI.phases[2].options.iconColor[3], loginUI.phases[2].options.iconColor[4]*j.animAlphaPercent), false)
                if (j.animTooltipPercent > 0) then
                    imports.beautify.native.drawRectangle(loginUI.phases[2].options.startX + loginUI.phases[2].options.size + 5, j.startY, j.animTooltipPercent*j.tooltip.width, loginUI.phases[2].options.size, loginUI.phases[2].options.bgColor, false)
                    imports.beautify.native.drawText(j.tooltip.text, loginUI.phases[2].options.startX + loginUI.phases[2].options.size + 5, j.startY, loginUI.phases[2].options.startX + loginUI.phases[2].options.size + 5 + j.animTooltipPercent, j.startY + loginUI.phases[2].options.size, -1, 1, FRAMEWORK_FONTS[8], "center", "center", true)
                end
            end
        elseif loginUI.phase == 3 then
            imports.beautify.native.drawImage(background_offsetX, background_offsetY, background_width, background_height, loginUI.bgTexture, 0, 0, 0, -1, false)
            local view_offsetX, view_offsetY = loginUI.phases[3].startX, loginUI.phases[3].startY
            local view_width, view_height = loginUI.phases[3].width, loginUI.phases[3].height
            local credits_offsetY = -loginUI.phases[3].contentHeight - (view_height*0.5)
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
            local isNavigatorHovered = imports.isMouseOnPosition(navigator_offsetX, navigator_offsetY, navigator_width, navigator_height) and isUIEnabled
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
            loginUI.phases[3].navigator.animAlphaPercent = ((loginUI.phases[3].navigator.hoverStatus == "forward") and imports.interpolateBetween(loginUI.phases[3].navigator.animAlphaPercent, 0, 0, 1, 0, 0, imports.getInterpolationProgress(loginUI.phases[3].navigator.hoverAnimTick, FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].credits.navigator.hoverDuration), "Linear")) or imports.interpolateBetween(loginUI.phases[3].navigator.animAlphaPercent, 0, 0, 0.25, 0, 0, imports.getInterpolationProgress(loginUI.phases[3].navigator.hoverAnimTick, FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].credits.navigator.hoverDuration), "Linear")
            imports.beautify.native.drawText(navigator_title, navigator_offsetX, navigator_offsetY, navigator_offsetX + navigator_width, navigator_offsetY + navigator_height, imports.tocolor(loginUI.phases[3].navigator.fontColor[1], loginUI.phases[3].navigator.fontColor[2], loginUI.phases[3].navigator.fontColor[3], loginUI.phases[3].navigator.fontColor[4]*loginUI.phases[3].navigator.animAlphaPercent), 1, loginUI.phases[3].navigator.font, "center", "center", true, false, false)
        end
    end
end


------------------------------------
--[[ Client: On Toggle Login UI ]]--
------------------------------------

loginUI.toggleUI = function(state, args)
    if (((state ~= true) and (state ~= false)) or (state == loginUI.state)) then return false end

    if state then
        loginUI.state = true
        loginUI.cinemationData = FRAMEWORK_CONFIGS["UI"]["Login"].spawnLocations[imports.math.random(#FRAMEWORK_CONFIGS["UI"]["Login"].spawnLocations)]
        imports.triggerEvent("Client:onSetLoginUIPhase", localPlayer, 1)
        imports.beautify.render.create(loginUI.renderUI)
        imports.beautify.render.create(loginUI.renderUI, {renderType = "input"})
        imports.triggerEvent("Sound:onToggleLogin", localPlayer, state, {
            shuffleMusic = (args and args.shuffleMusic and true) or false
        })
    else
        imports.beautify.render.remove(loginUI.renderUI)
        imports.beautify.render.remove(loginUI.renderUI, {renderType = "input"})
        exports.cinecam_handler:stopCinemation()
        if loginUI.phases[2].character and imports.isElement(loginUI.phases[2].character) then imports.destroyElement(loginUI.phases[2].character); loginUI.phases[2].character = nil end
        for i, j in imports.pairs(loginUI.cache.keys) do
            j = false
        end
        for i, j in imports.pairs(loginUI.cache.timers) do
            if j and imports.isTimer(j) then
                imports.killTimer(j)
            end
            j = nil
        end
        loginUI.phase = false
        loginUI.cinemationData = false
        loginUI.character = 0
        loginUI.previewCharacter = false
        loginUI.characters = {}
        loginUI.isVIP = false
        loginUI.state = false
        imports.triggerEvent("Sound:onToggleLogin", localPlayer, state)
    end
    imports.showChat(false, true)
    imports.showCursor(state, true)
    return true
end

imports.addEvent("Client:onToggleLoginUI", true)
imports.addEventHandler("Client:onToggleLoginUI", root, function(state, args)
    if state then
        loginUI.character = args.character
        loginUI.previewCharacter = loginUI.character
        loginUI.characters, loginUI.processCharacters = args.characters, {}
        loginUI.vip = args.vip
        imports.setElementPosition(localPlayer, FRAMEWORK_CONFIGS["UI"]["Login"].clientPoint.x, FRAMEWORK_CONFIGS["UI"]["Login"].clientPoint.y, FRAMEWORK_CONFIGS["UI"]["Login"].clientPoint.z)
        imports.setElementDimension(localPlayer, FRAMEWORK_CONFIGS["UI"]["Login"].dimension)
        imports.triggerEvent("Client:onEnableLoginUI", localPlayer, true, true)
        imports.triggerEvent("Client:onToggleLoadingUI", localPlayer, true)
        imports.setTimer(function()
            loginUI.toggleUI(state, args)
            imports.fadeCamera(true)
            imports.triggerEvent("Client:onToggleLoadingUI", localPlayer, false)
        end, FRAMEWORK_CONFIGS["UI"]["Login"].fadeDelay, 1)
    else
        loginUI.toggleUI(state, args)
    end
end)


-----------------------------------------
--[[ Event: On Client Resource Start ]]--
-----------------------------------------

imports.addEventHandler("onClientResourceStart", resource, function()
    imports.fadeCamera(false)
    imports.triggerEvent("Client:onToggleLoadingUI", localPlayer, true)
    local booter = function() imports.triggerServerEvent("Player:onToggleLoginUI", localPlayer) end
    if imports.assetify.isLoaded() then
        booter()
    else
        local booterWrapper = nil
        booterWrapper = function()
            booter()
            imports.removeEventHandler("onAssetifyLoad", root, booterWrapper)
        end
        imports.addEventHandler("onAssetifyLoad", root, booterWrapper)
    end
end)