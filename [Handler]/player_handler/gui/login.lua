----------------------------------------------------------------
--[[ Resource: Player Handler
     Script: gui: login.lua
     Author: vStudio
     Developer(s): Mario, Tron, Aviril, Аниса
     DOC: 31/01/2022
     Desc: Login UI Handler ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local imports = {
    type = type,
    pairs = pairs,
    tocolor = tocolor,
    unpackColor = unpackColor,
    isElement = isElement,
    createPed = createPed,
    destroyElement = destroyElement,
    setElementFrozen = setElementFrozen,
    setElementPosition = setElementPosition,
    setElementDimension = setElementDimension,
    addEventHandler = addEventHandler,
    isMouseClicked = isMouseClicked,
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
--[[ Namespace ]]--
-------------------

local loginUI = assetify.namespace:create("loginUI")
CGame.execOnModuleLoad(function()
loginUI.private.cache = {keys = {}, timers = {}}
loginUI.private.bgTexture = imports.assetify.getAssetDep("module", "vRPZ_HUD", "texture", "login:background")
loginUI.private.phases = {
    [1] = {
        bgTexture = imports.assetify.getAssetDep("module", "vRPZ_HUD", "texture", "login:lobby"),
        optionsUI = {
            startX = CLIENT_MTA_RESOLUTION[1]*0.5, startY = -15, paddingY = 10,
            font = CGame.createFont(1, 30), fontColor = imports.tocolor(imports.unpackColor(FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].play.fontColor)),
            embedLineColor = imports.tocolor(imports.unpackColor(FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].play.embedLineColor)),
            {identifier = "play", exec = function() loginUI.private.phases[2].manageCharacter("play") end},
            {identifier = "characters", exec = function() imports.assetify.network:emit("Client:onSetLoginUIPhase", false, 2) end},
            {identifier = "credits", exec = function() imports.assetify.network:emit("Client:onSetLoginUIPhase", false, 3) end}
        }
    },
    [2] = {
        startX = 0, startY = 0,
        width = FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].characters.width, height = FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].characters.height,
        titlebar = {
            paddingY = 2,
            height = FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].characters.titlebar.height,
            font = CGame.createFont(1, 19), fontColor = imports.tocolor(imports.unpackColor(FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].characters.titlebar.fontColor)),
            iconColor = imports.tocolor(imports.unpackColor(FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].characters.titlebar.iconColor)), bgColor = imports.tocolor(imports.unpackColor(FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].characters.titlebar.bgColor)),
            shadowColor = imports.tocolor(imports.unpackColor(FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].characters.titlebar.shadowColor)),
        },
        options = {
            startX = 5, startY = 5,
            paddingX = 5, paddingY = 5,
            size = FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].characters.options.size, iconSize = FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].characters.options.iconSize,
            tooltipFont = CGame.createFont(1, 15), tooltipFontColor = imports.tocolor(imports.unpackColor(FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].characters.options.iconColor)),
            iconColor = FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].characters.options.iconColor,
            bgColor = imports.tocolor(imports.unpackColor(FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].characters.options.bgColor)),
            {iconTexture = imports.beautify.assets["images"]["arrow/left.rw"], tooltip = {identifier = FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].characters.options.tooltips.previous}, exec = function() loginUI.private.phases[2].manageCharacter("previous") end},
            {iconTexture = imports.beautify.assets["images"]["arrow/right.rw"], tooltip = {identifier = FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].characters.options.tooltips.next}, exec = function() loginUI.private.phases[2].manageCharacter("next") end},
            {iconTexture = imports.beautify.assets["images"]["canvas/pick.rw"], tooltip = {identifier = FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].characters.options.tooltips.pick}, exec = function() loginUI.private.phases[2].manageCharacter("pick") end},
            {iconTexture = imports.beautify.assets["images"]["canvas/plus.rw"], tooltip = {identifier = FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].characters.options.tooltips.create}, exec = function() loginUI.private.phases[2].manageCharacter("create") end},
            {iconTexture = imports.beautify.assets["images"]["canvas/minus.rw"], tooltip = {identifier = FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].characters.options.tooltips.delete}, exec = function() loginUI.private.phases[2].manageCharacter("delete") end},
            {iconTexture = imports.beautify.assets["images"]["canvas/save.rw"], tooltip = {identifier = FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].characters.options.tooltips.save}, exec = function() loginUI.private.phases[2].manageCharacter("save") end},
            {iconTexture = imports.beautify.assets["images"]["canvas/back.rw"], tooltip = {identifier = FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].characters.options.tooltips.back}, exec = function() imports.assetify.network:emit("Client:onSetLoginUIPhase", false, 1) end}
        },
        categories = {
            paddingX = 20, paddingY = 5,
            height = FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].characters.categories.height,
            font = CGame.createFont(1, 16), fontColor = imports.tocolor(imports.unpackColor(FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].characters.categories.fontColor)),
            bgColor = imports.tocolor(imports.unpackColor(FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].characters.categories.bgColor)),
            {
                identifier = "Identity",
                height = 120,
                contents = {
                    tone = {
                        identifier = "tone",
                        isSlider = true,
                        startY = 30, paddingY = -8, height = 30,
                        iconTexture = imports.beautify.assets["images"]["canvas/color.rw"]
                    },
                    gender = {
                        identifier = "gender",
                        isSelector = true,
                        startY = 90, height = 30,
                        iconTexture = imports.beautify.assets["images"]["canvas/gender.rw"]
                    }
                }
            },
            {
                identifier = "Facial",
                height = 120,
                contents = {
                    hair = {
                        identifier = "hair",
                        isSelector = true, isClothing = true,
                        startY = 30, height = 30,
                        iconTexture = imports.beautify.assets["images"]["canvas/hair.rw"]
                    },
                    face = {
                        identifier = "face",
                        isSelector = true, isClothing = true,
                        startY = 90, height = 30,
                        iconTexture = imports.beautify.assets["images"]["canvas/face.rw"]
                    }
                }
            },
            {
                identifier = "Clothing",
                height = 180,
                contents = {
                    upper = {
                        identifier = "Upper",
                        isSelector = true, isClothing = true,
                        startY = 30, height = 30,
                        iconTexture = imports.beautify.assets["images"]["canvas/tshirt.rw"]
                    },
                    lower = {
                        identifier = "Lower",
                        isSelector = true, isClothing = true,
                        startY = 90, height = 30,
                        iconTexture = imports.beautify.assets["images"]["canvas/trouser.rw"]
                    },
                    shoes = {
                        identifier = "Shoes",
                        isSelector = true, isClothing = true,
                        startY = 150, height = 30,
                        iconTexture = imports.beautify.assets["images"]["canvas/shoes.rw"]
                    }
                }
            }
        }
    },
    [3] = {
        startX = 0, startY = 15,
        width = 0, height = -15,
        font = CGame.createFont(1, 28), fontColor = imports.tocolor(imports.unpackColor(FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].credits.fontColor)),
        scrollAnimTickCounter = CLIENT_CURRENT_TICK,
        scrollDelayDuration = FRAMEWORK_CONFIGS["UI"]["Loading"].fadeOutDuration + FRAMEWORK_CONFIGS["UI"]["Loading"].fadeDelayDuration - 1000,
        navigator = {
            startX = -5, startY = 5,
            width = 0, height = 25,
            font = CGame.createFont(1, 19), fontColor = {200, 200, 200, 255},
            hoverStatus = "backward",
            hoverAnimTick = CLIENT_CURRENT_TICK,
            exec = function() imports.assetify.network:emit("Client:onSetLoginUIPhase", false, 1) end
        }
    }
}
for i = 1, #loginUI.private.phases[1].optionsUI, 1 do
    local j = loginUI.private.phases[1].optionsUI[i]
    j.startY = loginUI.private.phases[1].optionsUI.startY + CLIENT_MTA_RESOLUTION[2] - (FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].play.height*(#loginUI.private.phases[1].optionsUI - (i - 1))) - (loginUI.private.phases[1].optionsUI.paddingY*(#loginUI.private.phases[1].optionsUI - i))
    j.hoverStatus = "backward"
    j.hoverAnimTick = CLIENT_CURRENT_TICK
end
loginUI.private.phases[2].options.startX = loginUI.private.phases[2].startX + loginUI.private.phases[2].width + loginUI.private.phases[2].options.startX + loginUI.private.phases[2].options.paddingX
loginUI.private.phases[2].options.iconX = loginUI.private.phases[2].options.startX + ((loginUI.private.phases[2].options.size - loginUI.private.phases[2].options.iconSize)*0.5)
for i = 1, #loginUI.private.phases[2].options, 1 do
    local j = loginUI.private.phases[2].options[i]
    j.startY = loginUI.private.phases[2].startY + loginUI.private.phases[2].options.startY + ((loginUI.private.phases[2].options.size + loginUI.private.phases[2].options.paddingY)*(i - 1))
    j.iconY = j.startY + ((loginUI.private.phases[2].options.size - loginUI.private.phases[2].options.iconSize)*0.5)
    j.hoverStatus = "backward"
    j.tooltip.hoverStatus = "backward"
    j.hoverAnimTick = CLIENT_CURRENT_TICK
end
loginUI.private.phases[3].contentText = ""
for i = 1, #FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].credits.contributors do
    local j = FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].credits.contributors[i]
    loginUI.private.phases[3].contentText = ((i == 1) and j) or loginUI.private.phases[3].contentText.."\n\n"..j
end
loginUI.private.phases[3].width, loginUI.private.phases[3].height = loginUI.private.phases[3].width + (CLIENT_MTA_RESOLUTION[1] - loginUI.private.phases[3].startX), loginUI.private.phases[3].height + (CLIENT_MTA_RESOLUTION[2] - loginUI.private.phases[3].startY)
loginUI.private.phases[3].contentWidth, loginUI.private.phases[3].contentHeight = imports.beautify.native.getTextSize(loginUI.private.phases[3].contentText, loginUI.private.phases[3].width, 1, loginUI.private.phases[3].font.instance, false)
loginUI.private.phases[3].scrollDuration = imports.math.max(1, imports.math.ceil((loginUI.private.phases[3].contentHeight + loginUI.private.phases[3].height)/loginUI.private.phases[3].height))*FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].credits.scrollDuration

loginUI.private.phases[1].updateUILang = function()
    for i = 1, #loginUI.private.phases[1].optionsUI, 1 do
        local j = loginUI.private.phases[1].optionsUI[i]
        j.title = imports.string.upper(imports.string.kern(FRAMEWORK_CONFIGS["UI"]["Login"]["Options"][(j.identifier)]["Title"][(CPlayer.CLanguage)], "  "))
        j.width = imports.beautify.native.getTextWidth(j.title, 1, loginUI.private.phases[1].optionsUI.font.instance) + 5
    end
    return true
end

loginUI.private.phases[2].updateUILang = function(gender)
    gender = gender or FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].characters.categories["Identity"].gender.default
    loginUI.private.phases[2].titlebar.title = imports.string.upper(imports.string.kern(FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].characters.titlebar["Title"][(CPlayer.CLanguage)]))
    for i = 1, #loginUI.private.phases[2].options, 1 do
        local j = loginUI.private.phases[2].options[i]
        j.tooltip.text = imports.string.upper(imports.string.kern(j.tooltip.identifier[(CPlayer.CLanguage)]))
        j.tooltip.width = imports.beautify.native.getTextWidth(j.tooltip.text, 1, loginUI.private.phases[2].options.tooltipFont.instance) + loginUI.private.phases[2].options.size
    end
    for i = 1, #loginUI.private.phases[2].categories, 1 do
        local j = loginUI.private.phases[2].categories[i]
        local panel_offsetY = loginUI.private.phases[2].titlebar.height + loginUI.private.phases[2].titlebar.paddingY
        j.title = imports.string.upper(imports.string.kern(FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].characters.categories[(j.identifier)]["Title"][(CPlayer.CLanguage)]))
        j.offsetY = (loginUI.private.phases[2].categories[(i - 1)] and (loginUI.private.phases[2].categories[(i - 1)].offsetY + loginUI.private.phases[2].categories.height + loginUI.private.phases[2].categories[(i - 1)].height + loginUI.private.phases[2].categories.paddingY)) or panel_offsetY
        if j.contents then
            for k, v in imports.pairs(j.contents) do
                v.title = imports.string.upper(imports.string.kern(FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].characters.categories[(j.identifier)][(v.identifier)]["Title"][(CPlayer.CLanguage)]))
                v.iconX, v.iconY = ((loginUI.private.phases[2].width - imports.beautify.native.getTextWidth(v.title, 1, loginUI.private.phases[2].categories.font.instance))*0.5) - FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].characters.titlebar.iconSize - 7, (loginUI.private.phases[2].categories.height - FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].characters.titlebar.iconSize)*0.5
                if v.isSlider then
                    if not v.element or not imports.isElement(v.element) then
                        v.element = imports.beautify.slider.create(loginUI.private.phases[2].categories.paddingX, j.offsetY + loginUI.private.phases[2].categories.height + v.startY + v.paddingY, loginUI.private.phases[2].width - (loginUI.private.phases[2].categories.paddingX*2), v.height, "horizontal", loginUI.private.phases[2].element, false)
                        imports.beautify.setUIVisible(v.element, true)
                        imports.addEventHandler("onClientUISliderAltered", v.element, function() loginUI.private.phases[2].updateCharacter() end)
                    end
                elseif v.isSelector then
                    v.contentIndex, v.content = {}, {}
                    if not v.element or not imports.isElement(v.element) then
                        v.element = imports.beautify.selector.create(loginUI.private.phases[2].categories.paddingX, j.offsetY + loginUI.private.phases[2].categories.height + v.startY, loginUI.private.phases[2].width - (loginUI.private.phases[2].categories.paddingX*2), v.height, "horizontal", loginUI.private.phases[2].element, false)
                        imports.beautify.setUIVisible(v.element, true)
                        imports.addEventHandler("onClientUISelectionAltered", v.element, function() loginUI.private.phases[2].updateCharacter() end)
                    end
                    for m, n in imports.pairs((v.isClothing and FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].characters.categories[(j.identifier)][(v.identifier)]["Datas"][gender]) or FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].characters.categories[(j.identifier)][(v.identifier)]["Datas"]) do
                        imports.table.insert(v.contentIndex, m)
                        imports.table.insert(v.content, imports.string.upper(imports.string.kern(n[(CPlayer.CLanguage)])))
                    end
                    imports.beautify.selector.setDataList(v.element, v.content)
                end
            end
        elseif j.isSelector then
            j.contentIndex, j.content = {}, {}
            if not j.element or not imports.isElement(j.element) then
                j.element = imports.beautify.selector.create(loginUI.private.phases[2].categories.paddingX, j.offsetY + loginUI.private.phases[2].categories.height, loginUI.private.phases[2].width - (loginUI.private.phases[2].categories.paddingX*2), j.height, "horizontal", loginUI.private.phases[2].element, false)
                imports.beautify.setUIVisible(j.element, true)
                imports.addEventHandler("onClientUISelectionAltered", j.element, function() loginUI.private.phases[2].updateCharacter() end)
            end
            for k, v in imports.pairs(FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].characters.categories[(j.identifier)]["Datas"][gender]) do
                imports.table.insert(j.contentIndex, k)
                imports.table.insert(j.content, imports.string.upper(imports.string.kern(v[(CPlayer.CLanguage)])))
            end
            imports.beautify.selector.setDataList(j.element, j.content)
        end
    end
    return true
end

loginUI.private.phases[3].updateUILang = function()
    loginUI.private.phases[3].navigator.__width = loginUI.private.phases[3].navigator.width + imports.beautify.native.getTextWidth(FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].credits.navigator["Title"][(CPlayer.CLanguage)], 1, loginUI.private.phases[3].navigator.font.instance)
    return true
end

loginUI.private.updateUILang = function()
    loginUI.private.phases[1].updateUILang()
    if loginUI.private.phases[2].element and imports.isElement(loginUI.private.phases[2].element) then
        local characterData = loginUI.private.phases[2].fetchSelection()
        loginUI.private.phases[2].updateUILang(characterData.gender)
    end
    loginUI.private.phases[3].updateUILang()
    return true
end
imports.assetify.network:fetch("Client:onUpdateLanguage"):on(loginUI.private.updateUILang)

loginUI.private.phases[2].fetchSelection = function()
    local tone = imports.beautify.slider.getPercent(loginUI.private.phases[2].categories[1].contents.tone.element)
    local gender = loginUI.private.phases[2].categories[1].contents.gender.contentIndex[(imports.beautify.selector.getSelection(loginUI.private.phases[2].categories[1].contents.gender.element))]
    local hair = loginUI.private.phases[2].categories[2].contents.hair.contentIndex[(imports.beautify.selector.getSelection(loginUI.private.phases[2].categories[2].contents.hair.element))]
    local face = loginUI.private.phases[2].categories[2].contents.face.contentIndex[(imports.beautify.selector.getSelection(loginUI.private.phases[2].categories[2].contents.face.element))]
    local upper = loginUI.private.phases[2].categories[3].contents.upper.contentIndex[(imports.beautify.selector.getSelection(loginUI.private.phases[2].categories[3].contents.upper.element))]
    local lower = loginUI.private.phases[2].categories[3].contents.lower.contentIndex[(imports.beautify.selector.getSelection(loginUI.private.phases[2].categories[3].contents.lower.element))]
    local shoes = loginUI.private.phases[2].categories[3].contents.shoes.contentIndex[(imports.beautify.selector.getSelection(loginUI.private.phases[2].categories[3].contents.shoes.element))]
    return {
        tone = tone,
        gender = gender,
        hair = hair,
        face = face,
        upper = upper,
        lower = lower,
        shoes = shoes
    }
end

loginUI.private.phases[2].updateCharacter = function()
    local characterClothing = {CCharacter.generateClothing((loginUI.private.phases[2].fetchSelection()))}
    imports.assetify.setElementAsset(loginUI.private.phases[2].character, "character", characterClothing[1], characterClothing[2], characterClothing[3])
    return true
end

loginUI.private.phases[2].loadCharacter = function(loadDefault)
    if not loadDefault then
        if not loginUI.private.characters[(loginUI.private.previewCharacter)] then
            if #loginUI.private.characters > 0 then
                loginUI.private.character = 1
                loginUI.private.previewCharacter = loginUI.private.character
            else
                loadDefault = true
            end
        end
        if not loadDefault and not loginUI.private.characters[(loginUI.private.previewCharacter)].identity then loadDefault = true end
    end
    if loadDefault then
        for i = 1, #loginUI.private.phases[2].categories, 1 do
            local j = loginUI.private.phases[2].categories[i]
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
        loginUI.private.phases[2].updateUILang()
    else
        for i = 1, #loginUI.private.phases[2].categories[1].contents.gender.contentIndex, 1 do
            local j = loginUI.private.phases[2].categories[1].contents.gender.contentIndex[i]
            if j == (loginUI.private.characters[(loginUI.private.previewCharacter)].identity.gender or FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].characters.categories["Identity"].gender.default) then
                imports.beautify.selector.setSelection(loginUI.private.phases[2].categories[1].contents.gender.element, i)
                loginUI.private.phases[2].updateUILang(j)
                break
            end
        end
        imports.beautify.slider.getPercent(loginUI.private.phases[2].categories[1].contents.tone.element, loginUI.private.characters[(loginUI.private.previewCharacter)].identity.tone or 0)
        imports.beautify.selector.setSelection(loginUI.private.phases[2].categories[2].contents.hair.element, loginUI.private.characters[(loginUI.private.previewCharacter)].identity.hair or 1)
        imports.beautify.selector.setSelection(loginUI.private.phases[2].categories[2].contents.face.element, loginUI.private.characters[(loginUI.private.previewCharacter)].identity.face or 1)
        imports.beautify.selector.setSelection(loginUI.private.phases[2].categories[3].contents.upper.element, loginUI.private.characters[(loginUI.private.previewCharacter)].identity.upper or 1)
        imports.beautify.selector.setSelection(loginUI.private.phases[2].categories[3].contents.lower.element, loginUI.private.characters[(loginUI.private.previewCharacter)].identity.lower or 1)
        imports.beautify.selector.setSelection(loginUI.private.phases[2].categories[3].contents.shoes.element, loginUI.private.characters[(loginUI.private.previewCharacter)].identity.shoes or 1)
    end
    loginUI.private.phases[2].updateCharacter()
    return true
end

loginUI.private.phases[2].manageCharacter = function(action)
    if not action then return false end
    if action == "create" then
        local errorMessage = false
        local characterLimit = (loginUI.private.isVIP and FRAMEWORK_CONFIGS["Game"]["Character_Limit"].vip) or FRAMEWORK_CONFIGS["Game"]["Character_Limit"].default
        if #loginUI.private.characters >= characterLimit then errorMessage = FRAMEWORK_CONFIGS["UI"]["Login"]["Notifications"][3][(CPlayer.CLanguage)] end
        imports.assetify.network:emit("Client:onEnableLoginUI", false, true)
        if errorMessage then
            imports.assetify.network:emit("Client:onNotification", false, errorMessage, FRAMEWORK_CONFIGS["UI"]["Notification"].presets.error)
            return false
        else
            imports.table.insert(loginUI.private.characters, {})
            loginUI.private.previewCharacter = #loginUI.private.characters
            loginUI.private.phases[2].loadCharacter(true)
            imports.assetify.network:emit("Client:onNotification", false, FRAMEWORK_CONFIGS["UI"]["Login"]["Notifications"][4][(CPlayer.CLanguage)], FRAMEWORK_CONFIGS["UI"]["Notification"].presets.success)
        end
    elseif action == "delete" then
        local errorMessage = false
        if #loginUI.private.characters <= 0 then errorMessage = FRAMEWORK_CONFIGS["UI"]["Login"]["Notifications"][5][(CPlayer.CLanguage)] end
        imports.assetify.network:emit("Client:onEnableLoginUI", false, true)
        if errorMessage then
            imports.assetify.network:emit("Client:onNotification", false, errorMessage, FRAMEWORK_CONFIGS["UI"]["Notification"].presets.error)
            return false
        else
            if loginUI.private.characters[(loginUI.private.previewCharacter)].id then imports.assetify.network:emit("Player:onDeleteCharacter", true, false, localPlayer, loginUI.private.characters[(loginUI.private.previewCharacter)].id) end
            imports.table.remove(loginUI.private.characters, loginUI.private.previewCharacter)
            loginUI.private.previewCharacter = imports.math.max(0, loginUI.private.previewCharacter - 1)
            loginUI.private.phases[2].loadCharacter()
            imports.assetify.network:emit("Client:onNotification", false, FRAMEWORK_CONFIGS["UI"]["Login"]["Notifications"][6][(CPlayer.CLanguage)], FRAMEWORK_CONFIGS["UI"]["Notification"].presets.success)
        end
    elseif (action == "previous") or (action == "next") then
        imports.assetify.network:emit("Client:onEnableLoginUI", false, true)
        if loginUI.private.characters[(loginUI.private.previewCharacter)] and not loginUI.private.characters[(loginUI.private.previewCharacter)].id then
            imports.assetify.network:emit("Client:onNotification", false, FRAMEWORK_CONFIGS["UI"]["Login"]["Notifications"][11][(CPlayer.CLanguage)], FRAMEWORK_CONFIGS["UI"]["Notification"].presets.error)
            return false
        else
            if action == "previous" then
                if loginUI.private.previewCharacter > 1 then
                    loginUI.private.previewCharacter = loginUI.private.previewCharacter - 1
                    loginUI.private.phases[2].loadCharacter()
                end
            elseif action == "next" then
                if loginUI.private.previewCharacter < #loginUI.private.characters then
                    loginUI.private.previewCharacter = loginUI.private.previewCharacter + 1
                    loginUI.private.phases[2].loadCharacter()
                end
            end
        end
    elseif action == "pick" then
        local errorMessage = false
        if (not loginUI.private.characters[(loginUI.private.previewCharacter)]) or not loginUI.private.characters[(loginUI.private.previewCharacter)].id then errorMessage = FRAMEWORK_CONFIGS["UI"]["Login"]["Notifications"][7][(CPlayer.CLanguage)] end
        imports.assetify.network:emit("Client:onEnableLoginUI", false, true)
        if errorMessage then
            imports.assetify.network:emit("Client:onNotification", false, errorMessage, FRAMEWORK_CONFIGS["UI"]["Notification"].presets.error)
            return false
        else
            loginUI.private.character = loginUI.private.previewCharacter
            imports.assetify.network:emit("Client:onNotification", false, FRAMEWORK_CONFIGS["UI"]["Login"]["Notifications"][8][(CPlayer.CLanguage)], FRAMEWORK_CONFIGS["UI"]["Notification"].presets.success)
        end
    elseif action == "save" then
        if (#loginUI.private.characters > 0) and loginUI.private.characters[(loginUI.private.previewCharacter)].id then
            imports.assetify.network:emit("Client:onEnableLoginUI", false, true)
            return false
        else
            imports.assetify.network:emit("Client:onEnableLoginUI", false, false, true)
            local characterData = loginUI.private.phases[2].fetchSelection()
            if #loginUI.private.characters <= 0 then loginUI.private.previewCharacter = 1 end
            loginUI.private.processCharacters[(loginUI.private.previewCharacter)] = true
            loginUI.private.characters[(loginUI.private.previewCharacter)] = loginUI.private.characters[(loginUI.private.previewCharacter)] or {}
            loginUI.private.characters[(loginUI.private.previewCharacter)].identity = characterData
            imports.assetify.network:emit("Player:onSaveCharacter", true, false, localPlayer, loginUI.private.previewCharacter, loginUI.private.characters)
        end
    elseif action == "play" then
        local errorMessage = false
        if #loginUI.private.characters <= 0 then errorMessage = FRAMEWORK_CONFIGS["UI"]["Login"]["Notifications"][1][(CPlayer.CLanguage)] end
        if not loginUI.private.characters[loginUI.private.character] then errorMessage = FRAMEWORK_CONFIGS["UI"]["Login"]["Notifications"][2][(CPlayer.CLanguage)] end
        if errorMessage then
            imports.assetify.network:emit("Client:onEnableLoginUI", false, true)
            imports.assetify.network:emit("Client:onNotification", false, errorMessage, FRAMEWORK_CONFIGS["UI"]["Notification"].presets.error)
            return false
        else
            imports.assetify.network:emit("Client:onEnableLoginUI", false, false, true)
            imports.assetify.network:emit("Client:onToggleLoadingUI", false, true)
            imports.assetify.timer:create(function(character, characters)
                imports.assetify.network:emit("Player:onResume", true, false, localPlayer, character, characters)
            end, FRAMEWORK_CONFIGS["UI"]["Loading"].fadeInDuration + FRAMEWORK_CONFIGS["UI"]["Loading"].fadeOutDuration + FRAMEWORK_CONFIGS["UI"]["Loading"].fadeDelayDuration, 1, loginUI.private.character, loginUI.private.characters)
            imports.assetify.timer:create(function()
                loginUI.private.toggleUI(false)
            end, FRAMEWORK_CONFIGS["UI"]["Loading"].fadeInDuration + 250, 1)
        end
    end
    return true
end

loginUI.private.phases[2].toggleUI = function(state)
    if state then
        if loginUI.private.phases[2].element and imports.isElement(loginUI.private.phases[2].element) then return false end
        loginUI.private.phases[2].element = imports.beautify.card.create(loginUI.private.phases[2].startX, loginUI.private.phases[2].startY, loginUI.private.phases[2].width, loginUI.private.phases[2].height, nil, false)
        loginUI.private.phases[2].updateUILang()
        imports.beautify.setUIVisible(loginUI.private.phases[2].element, true)
        imports.beautify.render.create(function()
            imports.beautify.native.drawRectangle(0, 0, loginUI.private.phases[2].width, loginUI.private.phases[2].titlebar.height, loginUI.private.phases[2].titlebar.bgColor, false)
            imports.beautify.native.drawText(loginUI.private.phases[2].titlebar.title, 0, 0, loginUI.private.phases[2].width, loginUI.private.phases[2].titlebar.height, loginUI.private.phases[2].titlebar.fontColor, 1, loginUI.private.phases[2].titlebar.font.instance, "center", "center", true, false, false)
            imports.beautify.native.drawRectangle(0, loginUI.private.phases[2].titlebar.height, loginUI.private.phases[2].width, loginUI.private.phases[2].titlebar.paddingY, loginUI.private.phases[2].titlebar.shadowColor, false)
            for i = 1, #loginUI.private.phases[2].categories, 1 do
                local j = loginUI.private.phases[2].categories[i]
                local category_offsetY = j.offsetY + loginUI.private.phases[2].categories.height
                imports.beautify.native.drawRectangle(0, j.offsetY, loginUI.private.phases[2].width, loginUI.private.phases[2].categories.height, loginUI.private.phases[2].titlebar.bgColor, false)
                imports.beautify.native.drawText(j.title, 0, j.offsetY, loginUI.private.phases[2].width, category_offsetY, loginUI.private.phases[2].categories.fontColor, 1, loginUI.private.phases[2].categories.font.instance, "center", "center", true, false, false)
                imports.beautify.native.drawRectangle(0, category_offsetY, loginUI.private.phases[2].width, j.height, loginUI.private.phases[2].categories.bgColor, false)
                if j.contents then
                    for k, v in imports.pairs(j.contents) do
                        local title_offsetY = category_offsetY + v.startY - loginUI.private.phases[2].categories.height
                        imports.beautify.native.drawRectangle(0, title_offsetY, loginUI.private.phases[2].width, loginUI.private.phases[2].categories.height, loginUI.private.phases[2].titlebar.bgColor, false)
                        imports.beautify.native.drawText(v.title, 0, title_offsetY, loginUI.private.phases[2].width, title_offsetY + loginUI.private.phases[2].categories.height, loginUI.private.phases[2].titlebar.fontColor, 1, loginUI.private.phases[2].categories.font.instance, "center", "center", true, false, false)
                        imports.beautify.native.drawImage(v.iconX, title_offsetY + v.iconY, FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].characters.titlebar.iconSize, FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].characters.titlebar.iconSize, v.iconTexture, 0, 0, 0, loginUI.private.phases[2].titlebar.iconColor, false)
                    end
                end
            end
        end, {
            elementReference = loginUI.private.phases[2].element,
            renderType = "preViewRTRender"
        })
    else
        if not loginUI.private.phases[2].element or not imports.isElement(loginUI.private.phases[2].element) then return false end
        imports.destroyElement(loginUI.private.phases[2].element)
        loginUI.private.phases[2].element = nil
    end
    return true
end


-------------------------------
--[[ Functions: UI Helpers ]]--
-------------------------------

function loginUI.public:isVisible() return loginUI.private.state end

imports.assetify.network:create("Client:onSetLoginUIPhase"):on(function(phaseID)
    if not phaseID or not loginUI.private.phases[1].optionsUI[phaseID] or (loginUI.private.phase and loginUI.private.phase == phaseID) then return false end
    for i, j in imports.pairs(loginUI.private.cache.timers) do
        if j then j:destroy() end
        loginUI.private.cache.timers[i] = nil
    end
    imports.assetify.network:emit("Client:onToggleLoadingUI", false, true)
    loginUI.private.cache.timers.phaseChanger = imports.assetify.timer:create(function()
        for i = 1, #loginUI.private.characters, 1 do
            local j = loginUI.private.characters[i]
            if not j.id then
                imports.table.remove(loginUI.private.characters, i)
            end
        end
        loginUI.private.phases[2].toggleUI(false)
        if phaseID == 1 then
            exports.cinecam_handler:startCinemation(loginUI.private.cinemationData.cinemationPoint, true, true, loginUI.private.cinemationData.cinemationFOV, true, true, true, false)
        elseif phaseID == 2 then
            if loginUI.private.phases[2].character and imports.isElement(loginUI.private.phases[2].character) then imports.destroyElement(loginUI.private.phases[2].character); loginUI.private.phases[2].character = nil end
            exports.cinecam_handler:startCinemation(loginUI.private.cinemationData.characterCinemationPoint, true, true, loginUI.private.cinemationData.characterCinemationFOV, true, true, true, false)
            loginUI.private.phases[2].character = imports.createPed(0, loginUI.private.cinemationData.characterPoint.x, loginUI.private.cinemationData.characterPoint.y, loginUI.private.cinemationData.characterPoint.z, loginUI.private.cinemationData.characterPoint.rotation)
            imports.setElementDimension(loginUI.private.phases[2].character, FRAMEWORK_CONFIGS["UI"]["Login"].dimension)
            imports.setElementFrozen(loginUI.private.phases[2].character, true)
            CGame.loadAnim(loginUI.private.phases[2].character, "Character")
            loginUI.private.phases[2].toggleUI(true)
            loginUI.private.phases[2].loadCharacter()
        else
            exports.cinecam_handler:stopCinemation()
            if phaseID == 3 then
                loginUI.private.phases[3].scrollAnimTickCounter = CLIENT_CURRENT_TICK
            end
        end
        loginUI.private.phase = phaseID
        imports.assetify.network:emit("Client:onToggleLoadingUI", false, false)
        loginUI.private.cache.timers.phaseChanger = false
    end, FRAMEWORK_CONFIGS["UI"]["Loading"].fadeInDuration + 250, 1)
    loginUI.private.cache.timers.uiEnabler = imports.assetify.timer:create(function()
        imports.assetify.network:emit("Client:onEnableLoginUI", false, true)
        loginUI.private.cache.timers.uiEnabler = false
    end, FRAMEWORK_CONFIGS["UI"]["Loading"].fadeOutDuration + FRAMEWORK_CONFIGS["UI"]["Loading"].fadeDelayDuration - (FRAMEWORK_CONFIGS["UI"]["Loading"].fadeInDuration + 250), 1)
end)

imports.assetify.network:create("Client:onEnableLoginUI"):on(function(state, isForced)
    if loginUI.private.cache.timers.uiEnabler then
        loginUI.private.cache.timers.uiEnabler:destroy()
        loginUI.private.cache.timers.uiEnabler = nil
    end
    if isForced then loginUI.private.isForcedDisabled = not state end
    loginUI.private.isEnabled = state
end)

imports.assetify.network:create("Client:onSaveCharacter"):on(function(state, character, characterData)
    if state then
        loginUI.private.characters[character] = characterData
        imports.assetify.network:emit("Client:onNotification", false, FRAMEWORK_CONFIGS["UI"]["Login"]["Notifications"][9][(CPlayer.CLanguage)], FRAMEWORK_CONFIGS["UI"]["Notification"].presets.success)
    else
        imports.assetify.network:emit("Client:onNotification", false, FRAMEWORK_CONFIGS["UI"]["Login"]["Notifications"][10][(CPlayer.CLanguage)], FRAMEWORK_CONFIGS["UI"]["Notification"].presets.error)
    end
    loginUI.private.processCharacters[character] = nil
    imports.assetify.network:emit("Client:onEnableLoginUI", false, true, true)
end)


------------------------------
--[[ Function: Renders UI ]]--
------------------------------

loginUI.private.renderUI = function(renderData)
    if not loginUI.private.state or CPlayer.isInitialized(localPlayer) then return false end
    if not loginUI.private.phase then return false end

    if renderData.renderType == "input" then
        loginUI.private.cache.keys.mouse = imports.isMouseClicked()
        local weatherData = FRAMEWORK_CONFIGS["UI"]["Login"].weathers[(loginUI.private.phase)] or FRAMEWORK_CONFIGS["UI"]["Login"].weathers[1]
        imports.assetify.network:emit("Client:onSyncWeather", false, weatherData.weather, weatherData.time)
    elseif renderData.renderType == "render" then
        local isUIEnabled = loginUI.private.isEnabled and not loginUI.private.isForcedDisabled
        local isLMBClicked = (loginUI.private.cache.keys.mouse == "mouse1") and isUIEnabled
        local currentRatio = (CLIENT_MTA_RESOLUTION[1]/CLIENT_MTA_RESOLUTION[2])/(1366/768)
        local background_width, background_height = CLIENT_MTA_RESOLUTION[1], CLIENT_MTA_RESOLUTION[2]*currentRatio
        local background_offsetX, background_offsetY = 0, -(background_height - CLIENT_MTA_RESOLUTION[2])*0.5
        if background_offsetY > 0 then
            background_width, background_height = CLIENT_MTA_RESOLUTION[1]/currentRatio, CLIENT_MTA_RESOLUTION[2]
            background_offsetX, background_offsetY = -(background_width - CLIENT_MTA_RESOLUTION[1])*0.5, 0
        end
        if loginUI.private.phase == 1 then
            imports.beautify.native.drawImage(background_offsetX, background_offsetY, background_width, background_height, loginUI.private.phases[loginUI.private.phase].bgTexture, 0, 0, 0, -1, false)
            for i = 1, #loginUI.private.phases[1].optionsUI, 1 do
                local j = loginUI.private.phases[1].optionsUI[i]
                local option_width, option_height = j.width, FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].play.height
                local options_offsetX, options_offsetY = loginUI.private.phases[1].optionsUI.startX - (option_width*0.5), j.startY
                local isOptionHovered = imports.isMouseOnPosition(options_offsetX, options_offsetY, option_width, option_height) and isUIEnabled
                if isOptionHovered then
                    if isLMBClicked then
                        imports.assetify.network:emit("Client:onEnableLoginUI", false, false)
                        imports.assetify.timer:create(function() j.exec() end, 1, 1)
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
                local isAnimationVisible, isAnimationFullyRendered = false, false
                if j.hoverStatus == "forward" then
                    isAnimationVisible = true
                    if j.animAlphaPercent < 1 then
                        j.animAlphaPercent = imports.interpolateBetween(j.animAlphaPercent, 0, 0, 1, 0, 0, imports.getInterpolationProgress(j.hoverAnimTick, FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].play.hoverDuration), "Linear")
                    else
                        isAnimationFullyRendered = true
                    end
                else
                    if j.animAlphaPercent > 0 then
                        isAnimationVisible = true
                        j.animAlphaPercent = imports.interpolateBetween(j.animAlphaPercent, 0, 0, 0, 0, 0, imports.getInterpolationProgress(j.hoverAnimTick, FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].play.hoverDuration), "Linear")
                    end
                end
                if not isAnimationFullyRendered then
                    imports.beautify.native.drawText(j.title, options_offsetX, options_offsetY, options_offsetX + option_width, options_offsetY + option_height, loginUI.private.phases[1].optionsUI.fontColor, 1, loginUI.private.phases[1].optionsUI.font.instance, "center", "center", true, false, false)
                end
                if isAnimationVisible then
                    imports.beautify.native.drawText(j.title, options_offsetX, options_offsetY, options_offsetX + option_width, options_offsetY + option_height, imports.tocolor(FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].play.hoverFontColor[1], FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].play.hoverFontColor[2], FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].play.hoverFontColor[3], FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].play.hoverFontColor[4]*j.animAlphaPercent), 1, loginUI.private.phases[1].optionsUI.font.instance, "center", "center", true, false, false)
                    imports.beautify.native.drawRectangle(options_offsetX + ((option_width - (option_width*j.animAlphaPercent))*0.5), options_offsetY + option_height, option_width*j.animAlphaPercent, FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].play.embedLineSize, loginUI.private.phases[1].optionsUI.embedLineColor, false)
                end
            end
        elseif loginUI.private.phase == 2 then
            imports.beautify.setUIDisabled(loginUI.private.phases[2].element, not isUIEnabled or (loginUI.private.characters[(loginUI.private.previewCharacter)] and loginUI.private.characters[(loginUI.private.previewCharacter)].id and true) or false)
            for i = 1, #loginUI.private.phases[2].options, 1 do
                local j = loginUI.private.phases[2].options[i]
                local isOptionHovered = imports.isMouseOnPosition(loginUI.private.phases[2].options.startX, j.startY, loginUI.private.phases[2].options.size, loginUI.private.phases[2].options.size) and isUIEnabled
                local isToolTipVisible = false
                if isOptionHovered then
                    if isLMBClicked then
                        imports.assetify.network:emit("Client:onEnableLoginUI", false, false)
                        imports.assetify.timer:create(function() j.exec() end, 1, 1)
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
                j.animAlphaPercent = j.animAlphaPercent or 0.35
                j.tooltip.animPercent = j.tooltip.animPercent or 0
                if j.hoverStatus == "forward" then
                    isToolTipVisible = true
                    if j.animAlphaPercent < 1 then
                        j.animAlphaPercent = imports.interpolateBetween(j.animAlphaPercent, 0, 0, 1, 0, 0, imports.getInterpolationProgress(j.hoverAnimTick, FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].characters.options.hoverDuration), "Linear")
                    end
                    if j.tooltip.animPercent < 1 then
                        j.tooltip.animPercent = imports.interpolateBetween(j.tooltip.animPercent, 0, 0, 1, 0, 0, imports.getInterpolationProgress(j.hoverAnimTick, FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].characters.options.hoverDuration*0.5), "Linear")
                    end
                else
                    if j.animAlphaPercent > 0.35 then
                        j.animAlphaPercent = imports.interpolateBetween(j.animAlphaPercent, 0, 0, 0.35, 0, 0, imports.getInterpolationProgress(j.hoverAnimTick, FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].characters.options.hoverDuration), "Linear")
                    end
                    if j.tooltip.animPercent > 0 then
                        isToolTipVisible = true
                        j.tooltip.animPercent = imports.interpolateBetween(j.tooltip.animPercent, 0, 0, 0, 0, 0, imports.getInterpolationProgress(j.hoverAnimTick, FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].characters.options.hoverDuration*0.5), "Linear")
                    end
                end
                local tooltip_width = (isToolTipVisible and (j.tooltip.animPercent*j.tooltip.width)) or 0
                imports.beautify.native.drawRectangle(loginUI.private.phases[2].options.startX, j.startY, loginUI.private.phases[2].options.size + tooltip_width, loginUI.private.phases[2].options.size, loginUI.private.phases[2].options.bgColor, false)
                imports.beautify.native.drawImage(loginUI.private.phases[2].options.iconX, j.iconY, loginUI.private.phases[2].options.iconSize, loginUI.private.phases[2].options.iconSize, j.iconTexture, 0, 0, 0, imports.tocolor(loginUI.private.phases[2].options.iconColor[1], loginUI.private.phases[2].options.iconColor[2], loginUI.private.phases[2].options.iconColor[3], loginUI.private.phases[2].options.iconColor[4]*j.animAlphaPercent), false)
                if isToolTipVisible then
                    local tooltip_offsetX = loginUI.private.phases[2].options.startX + loginUI.private.phases[2].options.size
                    imports.beautify.native.drawText(j.tooltip.text, tooltip_offsetX, j.startY, tooltip_offsetX + tooltip_width, j.startY + loginUI.private.phases[2].options.size, loginUI.private.phases[2].options.tooltipFontColor, 1, loginUI.private.phases[2].options.tooltipFont.instance, "center", "center", true)
                end
            end
        elseif loginUI.private.phase == 3 then
            imports.beautify.native.drawImage(background_offsetX, background_offsetY, background_width, background_height, loginUI.private.bgTexture, 0, 0, 0, -1, false)
            local view_offsetX, view_offsetY = loginUI.private.phases[3].startX, loginUI.private.phases[3].startY
            local view_width, view_height = loginUI.private.phases[3].width, loginUI.private.phases[3].height
            local credits_offsetY = -loginUI.private.phases[3].contentHeight - (view_height*0.5)
            if (CLIENT_CURRENT_TICK - loginUI.private.phases[3].scrollAnimTickCounter) >= loginUI.private.phases[3].scrollDelayDuration then
                credits_offsetY = view_offsetY + imports.interpolateBetween(credits_offsetY, 0, 0, view_height*1.5, 0, 0, imports.getInterpolationProgress(loginUI.private.phases[3].scrollAnimTickCounter + loginUI.private.phases[3].scrollDelayDuration, loginUI.private.phases[3].scrollDuration), "Linear")
                if (imports.math.round(credits_offsetY, 2) >= imports.math.round(view_height*1.5)) and loginUI.private.isEnabled then
                    imports.assetify.network:emit("Client:onEnableLoginUI", false, false)
                    imports.assetify.network:emit("Client:onSetLoginUIPhase", false, 1)
                end
            end
            imports.beautify.native.drawText(loginUI.private.phases[3].contentText, view_offsetX, credits_offsetY, view_offsetX + view_width, credits_offsetY + loginUI.private.phases[3].contentHeight, loginUI.private.phases[3].fontColor, 1, loginUI.private.phases[3].font.instance, "center", "center", true, false, false, false, true)
            local navigator_width, navigator_height = loginUI.private.phases[3].navigator.__width, loginUI.private.phases[3].navigator.height
            local navigator_offsetX, navigator_offsetY = loginUI.private.phases[3].navigator.startX + (CLIENT_MTA_RESOLUTION[1] - navigator_width), loginUI.private.phases[3].navigator.startY
            local isNavigatorHovered = imports.isMouseOnPosition(navigator_offsetX, navigator_offsetY, navigator_width, navigator_height) and isUIEnabled
            if isNavigatorHovered then
                if isLMBClicked then
                    imports.assetify.network:emit("Client:onEnableLoginUI", false, false)
                    imports.assetify.timer:create(function() loginUI.private.phases[3].navigator.exec() end, 1, 1)
                end
                if loginUI.private.phases[3].navigator.hoverStatus ~= "forward" then
                    loginUI.private.phases[3].navigator.hoverStatus = "forward"
                    loginUI.private.phases[3].navigator.hoverAnimTick = CLIENT_CURRENT_TICK
                end
            else
                if loginUI.private.phases[3].navigator.hoverStatus ~= "backward" then
                    loginUI.private.phases[3].navigator.hoverStatus = "backward"
                    loginUI.private.phases[3].navigator.hoverAnimTick = CLIENT_CURRENT_TICK
                end
            end
            loginUI.private.phases[3].navigator.animAlphaPercent = loginUI.private.phases[3].navigator.animAlphaPercent or 0.25
            if loginUI.private.phases[3].navigator.hoverStatus == "forward" then
                if loginUI.private.phases[3].navigator.animAlphaPercent < 1 then
                    loginUI.private.phases[3].navigator.animAlphaPercent = imports.interpolateBetween(loginUI.private.phases[3].navigator.animAlphaPercent, 0, 0, 1, 0, 0, imports.getInterpolationProgress(loginUI.private.phases[3].navigator.hoverAnimTick, FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].credits.navigator.hoverDuration), "Linear")
                end
            else
                if loginUI.private.phases[3].navigator.animAlphaPercent > 0.25 then
                    loginUI.private.phases[3].navigator.animAlphaPercent = imports.interpolateBetween(loginUI.private.phases[3].navigator.animAlphaPercent, 0, 0, 0.25, 0, 0, imports.getInterpolationProgress(loginUI.private.phases[3].navigator.hoverAnimTick, FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].credits.navigator.hoverDuration), "Linear")
                end
            end
            imports.beautify.native.drawText(FRAMEWORK_CONFIGS["UI"]["Login"]["Options"].credits.navigator["Title"][(CPlayer.CLanguage)], navigator_offsetX, navigator_offsetY, navigator_offsetX + navigator_width, navigator_offsetY + navigator_height, imports.tocolor(loginUI.private.phases[3].navigator.fontColor[1], loginUI.private.phases[3].navigator.fontColor[2], loginUI.private.phases[3].navigator.fontColor[3], loginUI.private.phases[3].navigator.fontColor[4]*loginUI.private.phases[3].navigator.animAlphaPercent), 1, loginUI.private.phases[3].navigator.font.instance, "center", "center", true, false, false)
        end
    end
end


------------------------------------
--[[ Client: On Toggle Login UI ]]--
------------------------------------

loginUI.private.toggleUI = function(state, args)
    if (((state ~= true) and (state ~= false)) or (state == loginUI.private.state)) then return false end

    if state then
        loginUI.private.updateUILang()
        local cAsset = imports.assetify.getAsset("sound", FRAMEWORK_CONFIGS["UI"]["Login"].lobbySound.asset)
        if cAsset then
            loginUI.private.lobbySound = CGame.playSound(FRAMEWORK_CONFIGS["UI"]["Login"].lobbySound.asset, FRAMEWORK_CONFIGS["UI"]["Login"].lobbySound.category, imports.math.random(#cAsset.manifestData.assetSounds[(FRAMEWORK_CONFIGS["UI"]["Login"].lobbySound.category)]), _, true, true)
        end
        loginUI.private.cinemationData = FRAMEWORK_CONFIGS["UI"]["Login"].spawnLocations[imports.math.random(#FRAMEWORK_CONFIGS["UI"]["Login"].spawnLocations)]
        imports.assetify.network:emit("Client:onSetLoginUIPhase", false, 1)
        imports.beautify.render.create(loginUI.private.renderUI)
        imports.beautify.render.create(loginUI.private.renderUI, {renderType = "input"})
        imports.assetify.network:emit("Sound:onToggleLogin", false, state, {
            shuffleMusic = (args and args.shuffleMusic and true) or false
        })
    else
        imports.beautify.render.remove(loginUI.private.renderUI)
        imports.beautify.render.remove(loginUI.private.renderUI, {renderType = "input"})
        exports.cinecam_handler:stopCinemation()
        if loginUI.private.phases[2].character and imports.isElement(loginUI.private.phases[2].character) then imports.destroyElement(loginUI.private.phases[2].character); loginUI.private.phases[2].character = nil end
        for i, j in imports.pairs(loginUI.private.cache.keys) do
            j = false
        end
        for i, j in imports.pairs(loginUI.private.cache.timers) do
            if j then j:destroy() end
            loginUI.private.cache.timers[i] = nil
        end
        for i, j in imports.pairs(FRAMEWORK_CONFIGS["Templates"]["Ambiences"]) do
            CSound.playAmbience(i)
        end
        imports.destroyElement(loginUI.private.lobbySound)
        loginUI.private.phase = false
        loginUI.private.lobbySound = nil
        loginUI.private.cinemationData = false
        loginUI.private.character = 0
        loginUI.private.previewCharacter = false
        loginUI.private.characters = {}
        loginUI.private.isVIP = false
    end
    loginUI.private.state = (state and true) or false
    imports.showChat(false, true)
    imports.showCursor(state, true)
    return true
end

imports.assetify.network:create("Client:onToggleLoginUI"):on(function(state, args)
    if state then
        loginUI.private.character = args.character
        loginUI.private.previewCharacter = loginUI.private.character
        loginUI.private.characters, loginUI.private.processCharacters = args.characters, {}
        loginUI.private.vip = args.vip
        imports.setElementPosition(localPlayer, FRAMEWORK_CONFIGS["UI"]["Login"].clientPoint.x, FRAMEWORK_CONFIGS["UI"]["Login"].clientPoint.y, FRAMEWORK_CONFIGS["UI"]["Login"].clientPoint.z)
        imports.setElementDimension(localPlayer, FRAMEWORK_CONFIGS["UI"]["Login"].dimension)
        imports.assetify.network:emit("Client:onEnableLoginUI", false, true, true)
        imports.assetify.network:emit("Client:onToggleLoadingUI", false, true)
        imports.assetify.timer:create(function()
            loginUI.private.toggleUI(state, args)
            imports.fadeCamera(true)
            imports.assetify.network:emit("Client:onToggleLoadingUI", false, false)
        end, FRAMEWORK_CONFIGS["UI"]["Login"].fadeDelay, 1)
    else
        loginUI.private.toggleUI(state, args)
    end
end)

imports.fadeCamera(false)
imports.assetify.network:emit("Client:onToggleLoadingUI", false, true)
CGame.execOnLoad(function()
    imports.assetify.renderer.setVirtualRendering(true, {diffuse = true, emissive = true})
    imports.assetify.renderer.setTimeSync(true)
    imports.assetify.renderer.setServerTick(60*60*1000*12 + CGame.getServerTick())
    imports.assetify.renderer.setMinuteDuration(FRAMEWORK_CONFIGS["Game"]["Minute_Duration"])
    for i, j in imports.pairs(FRAMEWORK_CONFIGS["Templates"]["Ambiences"]) do
        local cAsset = imports.assetify.getAsset("sound", j.assetName)
        if imports.type(j.category) == "table" then
            for k = 1, #j.category, 1 do
                local v = j.category[k]
                CSound.CAmbience[v] = cAsset.manifestData.assetSounds[v]
            end
        else
            CSound.CAmbience[(j.category)] = cAsset.manifestData.assetSounds[(j.category)]
        end
    end
    imports.assetify.network:emit("Player:onToggleLoginUI", true, false, localPlayer)
end)
end)
