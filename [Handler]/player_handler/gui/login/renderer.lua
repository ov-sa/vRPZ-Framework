----------------------------------------------------------------
--[[ Resource: Player Handler
     Script: gui: loginScreen: renderer.lua
     Server: ᴏᴠ | Halo:Combat
     Author: OvileAmriam
     Developer: -
     DOC: 11/06/2021 (OvileAmriam)
     Desc: Login Screen Renderer ]]--
----------------------------------------------------------------


-------------------
--[[ Variables ]]--
-------------------

local prevLMBClickState = false
local inputTickCounter = CLIENT_CURRENT_TICK
local prevInputKey = false
local prevInputKeyStreak = 0
local _currentKeyCheck = true
local _currentPressedKey = false


-----------------------------------------
--[[ Events: On Client Character/Key ]]--
-----------------------------------------

--[[
addEventHandler("onClientCharacter", root, function(character)

    if GuiElement.isMTAWindowActive() or not loginUICache.state or not loginUICache.isEnabled or loginUICache.isForcedDisabled then return false end
    local currentLoginPhase = getLoginUIPhase()
    if loginUICache.optionUI[currentLoginPhase].optionType ~= "characters" or loginUICache.phaseUI[currentLoginPhase].editboxes.focussedEditbox <= 0 then return false end

    if _currentKeyCheck then
        _currentKeyCheck = false
        if character == " " then
            character = "space"
        end
        _currentPressedKey = character
    end

end)

addEventHandler("onClientKey", root, function(button, press)

    if GuiElement.isMTAWindowActive() or not loginUICache.state or not loginUICache.isEnabled or loginUICache.isForcedDisabled then return false end
    local currentLoginPhase = getLoginUIPhase()
    if loginUICache.optionUI[currentLoginPhase].optionType ~= "characters" or loginUICache.phaseUI[currentLoginPhase].editboxes.focussedEditbox <= 0 then return false end

    if not press then
        if button == "tab" then
            if #loginUICache.phaseUI[currentLoginPhase].editboxes > 0 then
                if loginUICache.phaseUI[currentLoginPhase].editboxes.focussedEditbox > 0 then
                    if not loginUICache.phaseUI[currentLoginPhase].editboxes[loginUICache.phaseUI[currentLoginPhase].editboxes.focussedEditbox + 1] then
                        loginUICache.phaseUI[currentLoginPhase].editboxes.focussedEditbox = 1
                    else
                        loginUICache.phaseUI[currentLoginPhase].editboxes.focussedEditbox = loginUICache.phaseUI[currentLoginPhase].editboxes[loginUICache.phaseUI[currentLoginPhase].editboxes.focussedEditbox + 1]
                    end
                end
            end
        end
    end

end)
]]

----------------------------------------
--[[ Function: Renders Login Screen ]]--
----------------------------------------

function renderLoginScreen()

    if not loginUICache.state or isPlayerInitialized(localPlayer) then return false end
    --local currentLoginPhase = getLoginUIPhase()
    --if not currentLoginPhase then return false end

    --[[
    local isLMBClicked, isLMBOnHold = false, false
    local isPhaseAnimating = (CLIENT_CURRENT_TICK - loginUICache.phaseUI.animTickCounter) < loginUICache.phaseUI.animDuration
    if not GuiElement.isMTAWindowActive() and not isPhaseAnimating and loginUICache.isEnabled and not loginUICache.isForcedDisabled then
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
        isLMBOnHold = getKeyState("mouse1")
    end
    ]]--

    dxDrawRectangle(loginUICache.serverBanner.startX + loginUICache.serverBanner.serverName.height, loginUICache.serverBanner.startY, loginUICache.serverBanner.serverName.width - (loginUICache.serverBanner.serverName.height*2), loginUICache.serverBanner.serverName.height, loginUICache.serverBanner.serverName.bgColor, false)
    dxDrawImage(loginUICache.serverBanner.startX, loginUICache.serverBanner.startY, loginUICache.serverBanner.serverName.height, loginUICache.serverBanner.serverName.height, loginUICache.serverBanner.leftEdgePath, 0, 0, 0, loginUICache.serverBanner.serverName.bgColor, false)
    dxDrawImage(loginUICache.serverBanner.startX + loginUICache.serverBanner.serverName.width - loginUICache.serverBanner.serverName.height, loginUICache.serverBanner.startY, loginUICache.serverBanner.serverName.height, loginUICache.serverBanner.serverName.height, loginUICache.serverBanner.rightEdgePath, 0, 0, 0, loginUICache.serverBanner.serverName.bgColor, false)
    dxDrawText(loginUICache.serverBanner.serverName.text, loginUICache.serverBanner.startX, loginUICache.serverBanner.startY, loginUICache.serverBanner.startX + loginUICache.serverBanner.serverName.width, loginUICache.serverBanner.startY + loginUICache.serverBanner.serverName.height, loginUICache.serverBanner.serverName.fontColor, 1, loginUICache.serverBanner.serverName.font, "center", "center", true, false, false)
    
    local option_offsetY = 0
    --[[
    if loginUICache.phaseUI[currentLoginPhase] then
        dxSetRenderTarget()
        if loginUICache.optionUI[currentLoginPhase].optionType ~= "characters" then
            local phase_wrapper_width, phase_wrapper_height = loginUICache.phaseUI[currentLoginPhase].width, loginUICache.phaseUI[currentLoginPhase].height
            local phase_wrapper_startX, phase_wrapper_startY = loginUICache.phaseUI.startX + sX - phase_wrapper_width, loginUICache.phaseUI.startY + (loginUICache.serverBanner.startY + loginUICache.serverBanner.serverLogo.height) + ((sY - (loginUICache.serverBanner.startY + loginUICache.serverBanner.serverLogo.height) - phase_wrapper_height)/2)
            local phase_wrapper_animPercent, phase_wrapper_border_animPercent, phase_wrapper_content_animPercent = 1, 1, 1
            if loginUICache.phaseUI.animStatus == "forward" then
                if (CLIENT_CURRENT_TICK - loginUICache.phaseUI.animTickCounter) >= loginUICache.phaseUI.animOpenerDelay then
                    phase_wrapper_animPercent = interpolateBetween(0, 0, 0, 1, 0, 0, getInterpolationProgress(loginUICache.phaseUI.animTickCounter + loginUICache.phaseUI.animOpenerDelay, loginUICache.phaseUI.animDuration - loginUICache.phaseUI.animOpenerDelay), "OutBack")
                    phase_wrapper_content_animPercent = interpolateBetween(0, 0, 0, 1, 0, 0, getInterpolationProgress(loginUICache.phaseUI.animTickCounter + loginUICache.phaseUI.animOpenerDelay, (loginUICache.phaseUI.animDuration - loginUICache.phaseUI.animOpenerDelay)*2), "OutQuad")
                else
                    phase_wrapper_animPercent = 0
                    phase_wrapper_content_animPercent = 0
                end
                phase_wrapper_border_animPercent = interpolateBetween(0, 0, 0, 1, 0, 0, getInterpolationProgress(loginUICache.phaseUI.animTickCounter, loginUICache.phaseUI.animOpenerDelay), "OutQuad")
            else
                phase_wrapper_animPercent = interpolateBetween(1, 0, 0, 0, 0, 0, getInterpolationProgress(loginUICache.phaseUI.animTickCounter, loginUICache.phaseUI.animDuration - loginUICache.phaseUI.animOpenerDelay), "InBack")
                phase_wrapper_content_animPercent = interpolateBetween(1, 0, 0, 0, 0, 0, getInterpolationProgress(loginUICache.phaseUI.animTickCounter, (loginUICache.phaseUI.animDuration - loginUICache.phaseUI.animOpenerDelay)/2), "OutQuad")
                if (CLIENT_CURRENT_TICK - loginUICache.phaseUI.animTickCounter) >= (loginUICache.phaseUI.animDuration - loginUICache.phaseUI.animOpenerDelay) then
                    phase_wrapper_border_animPercent = interpolateBetween(1, 0, 0, 0, 0, 0, getInterpolationProgress(loginUICache.phaseUI.animTickCounter + (loginUICache.phaseUI.animDuration - loginUICache.phaseUI.animOpenerDelay), loginUICache.phaseUI.animOpenerDelay), "OutQuad")    
                end
                if math.round(phase_wrapper_border_animPercent, 2) <= 0 then
                    loginUICache.phaseUI.currentPhase = 1
                    if loginUICache.phaseUI.scheduledPhase then
                        local __scheduledPhase = loginUICache.phaseUI.scheduledPhase
                        loginUICache.phaseUI.scheduledPhase = nil
                        setLoginUIPhase(__scheduledPhase)
                    end
                end
            end
            phase_wrapper_height = phase_wrapper_height*phase_wrapper_animPercent
            phase_wrapper_startY = phase_wrapper_startY + (phase_wrapper_height*(1 - phase_wrapper_animPercent)*0.5)
            local phase_wrapper_borderSize, phase_wrapper_borderColor = loginUICache.phaseUI.borderSize, tocolor(loginUICache.phaseUI.borderColor[1], loginUICache.phaseUI.borderColor[2], loginUICache.phaseUI.borderColor[3], loginUICache.phaseUI.borderColor[4]*phase_wrapper_border_animPercent)
            local phase_wrapper_embedLineSize, phase_wrapper_embedLineColor = loginUICache.phaseUI.embedLineSize, tocolor(loginUICache.phaseUI.embedLineColor[1], loginUICache.phaseUI.embedLineColor[2], loginUICache.phaseUI.embedLineColor[3], loginUICache.phaseUI.embedLineColor[4]*phase_wrapper_border_animPercent)
            dxDrawRectangle(phase_wrapper_startX, phase_wrapper_startY, phase_wrapper_width, phase_wrapper_height, tocolor(unpack(loginUICache.phaseUI.bgColor)), false)
            dxSetRenderTarget(loginUICache.phaseUI[currentLoginPhase].renderTarget, true)
            if phase_wrapper_content_animPercent > 0 then
                if loginUICache.optionUI[currentLoginPhase].optionType == "socials" then
                    for i, j in ipairs(loginUICache.phaseUI[currentLoginPhase].discordLinks) do
                        local discord_startX, discord_startY = j.startX, loginUICache.phaseUI[currentLoginPhase].discordLinks.startY
                        local discord_width, discord_height = loginUICache.phaseUI[currentLoginPhase].discordLinks.width, loginUICache.phaseUI[currentLoginPhase].discordLinks.height
                        local discord_iconSize = loginUICache.phaseUI[currentLoginPhase].discordLinks.iconSize
                        local discord_icon_startX, discord_icon_startY = discord_startX + ((discord_width - discord_iconSize)/2), discord_startY
                        dxDrawImage(discord_icon_startX, discord_icon_startY, discord_iconSize, discord_iconSize, j.bgPath, 0, 0, 0, tocolor(unpack(j.bgColor)), false)
                        dxDrawBorderedText(loginUICache.phaseUI[currentLoginPhase].discordLinks.outlineWeight, loginUICache.phaseUI[currentLoginPhase].discordLinks.outlineColor, j.placeholder, discord_startX, discord_startY + discord_iconSize, discord_startX + discord_width, discord_startY + discord_height, tocolor(unpack(loginUICache.phaseUI[currentLoginPhase].discordLinks.fontColor)), loginUICache.phaseUI[currentLoginPhase].discordLinks.fontScale, loginUICache.phaseUI[currentLoginPhase].discordLinks.font, "center", "bottom", true, false, false)
                    end
                    for i, j in ipairs(loginUICache.phaseUI[currentLoginPhase].socialLinks) do
                        local social_startX, social_startY = j.startX, loginUICache.phaseUI[currentLoginPhase].socialLinks.startY
                        local social_width, social_height = loginUICache.phaseUI[currentLoginPhase].socialLinks.width, loginUICache.phaseUI[currentLoginPhase].socialLinks.height
                        local social_icon_startX, social_icon_startY = social_startX, social_startY
                        dxDrawRoundedRectangle(social_icon_startX, social_icon_startY, social_width, social_height, tocolor(unpack(loginUICache.phaseUI[currentLoginPhase].socialLinks.bgColor)), false, true)
                        dxDrawImage(social_icon_startX, social_icon_startY, social_height, social_height, j.bgPath, 0, 0, 0, tocolor(unpack(j.bgColor)), false)
                        dxDrawText(j.placeholder, social_startX + social_height + loginUICache.phaseUI[currentLoginPhase].socialLinks.dataPaddingX, social_startY + loginUICache.phaseUI[currentLoginPhase].socialLinks.dataPaddingY, social_startX + social_width, social_startY + social_height, tocolor(unpack(loginUICache.phaseUI[currentLoginPhase].socialLinks.fontColor)), loginUICache.phaseUI[currentLoginPhase].socialLinks.fontScale, loginUICache.phaseUI[currentLoginPhase].socialLinks.font, "left", "center", true, false, false)
                    end
                elseif loginUICache.optionUI[currentLoginPhase].optionType == "credits" then
                    local credits_offsetY = -loginUICache.phaseUI[currentLoginPhase].dataHeight
                    if (CLIENT_CURRENT_TICK - loginUICache.phaseUI[currentLoginPhase].scrollTickCounter) >= (loginUICache.phaseUI.animDuration + loginUICache.phaseUI[currentLoginPhase].scrollDelayDuration) then
                        credits_offsetY = interpolateBetween(-loginUICache.phaseUI[currentLoginPhase].dataHeight, 0, 0, loginUICache.phaseUI[currentLoginPhase].height*1.5, 0, 0, getInterpolationProgress(loginUICache.phaseUI[currentLoginPhase].scrollTickCounter + loginUICache.phaseUI.animDuration + loginUICache.phaseUI[currentLoginPhase].scrollDelayDuration, loginUICache.phaseUI[currentLoginPhase].scrollDuration), "Linear")
                        if (math.round(credits_offsetY, 2) >= math.round(loginUICache.phaseUI[currentLoginPhase].height*1.25)) and (loginUICache.phaseUI.animStatus ~= "backward") then
                            setLoginUIEnabled(false)
                            setLoginUIPhase(1)
                        end
                    end
                    dxDrawText(loginUICache.phaseUI[currentLoginPhase].dataValue, 0, credits_offsetY, loginUICache.phaseUI[currentLoginPhase].width + loginUICache.phaseUI[currentLoginPhase].paddingX, loginUICache.phaseUI[currentLoginPhase].height, tocolor(unpack(loginUICache.phaseUI[currentLoginPhase].fontColor)), loginUICache.phaseUI[currentLoginPhase].fontScale, loginUICache.phaseUI[currentLoginPhase].font, "center", "top", true, true, false)
                end
            end
            dxSetRenderTarget()
            dxDrawImage(phase_wrapper_startX, phase_wrapper_startY, phase_wrapper_width, phase_wrapper_height, loginUICache.phaseUI[currentLoginPhase].renderTarget, 0, 0, 0, tocolor(255, 255, 255, 255*phase_wrapper_content_animPercent), false)
            dxDrawRectangle(phase_wrapper_startX + phase_wrapper_borderSize, phase_wrapper_startY - phase_wrapper_borderSize, phase_wrapper_width - phase_wrapper_borderSize, phase_wrapper_borderSize, phase_wrapper_borderColor, false)
            dxDrawImage(phase_wrapper_startX, phase_wrapper_startY - phase_wrapper_borderSize, phase_wrapper_borderSize, phase_wrapper_borderSize, loginUICache.phaseUI.leftEdgePath, 0, 0, 0, phase_wrapper_borderColor, false)
            dxDrawRectangle(phase_wrapper_startX, phase_wrapper_startY + phase_wrapper_embedLineSize, phase_wrapper_width, phase_wrapper_embedLineSize, phase_wrapper_embedLineColor, false)
            dxDrawRectangle(phase_wrapper_startX, phase_wrapper_startY + phase_wrapper_height, phase_wrapper_width - phase_wrapper_borderSize, phase_wrapper_borderSize, phase_wrapper_borderColor, false)
            dxDrawImage(phase_wrapper_startX + phase_wrapper_width - phase_wrapper_borderSize, phase_wrapper_startY + phase_wrapper_height, phase_wrapper_borderSize, phase_wrapper_borderSize, loginUICache.phaseUI.rightEdgePath, 0, 0, 0, phase_wrapper_borderColor, false)
            dxDrawRectangle(phase_wrapper_startX, phase_wrapper_startY + phase_wrapper_height - (phase_wrapper_embedLineSize*2), phase_wrapper_width, phase_wrapper_embedLineSize, phase_wrapper_embedLineColor, false)
            dxDrawText("➤   "..loginUICache.optionUI[currentLoginPhase].placeholder, phase_wrapper_startX + phase_wrapper_borderSize + loginUICache.phaseUI.paddingX, phase_wrapper_startY - phase_wrapper_borderSize + loginUICache.phaseUI.paddingY, phase_wrapper_startX + phase_wrapper_width, phase_wrapper_startY, tocolor(unpack((loginUICache.optionUI[currentLoginPhase].fontColor and {loginUICache.optionUI[currentLoginPhase].fontColor[1], loginUICache.optionUI[currentLoginPhase].fontColor[2], loginUICache.optionUI[currentLoginPhase].fontColor[3], loginUICache.optionUI[currentLoginPhase].fontColor[4]*phase_wrapper_border_animPercent}) or {loginUICache.optionUI.fontColor[1], loginUICache.optionUI.fontColor[2], loginUICache.optionUI.fontColor[3], loginUICache.optionUI.fontColor[4]*phase_wrapper_border_animPercent})), 1, loginUICache.phaseUI.font, "left", "center", true, false, false)    
        else
            local phase_wrapper_animPercent, phase_wrapper_content_animPercent = 1, 1
            if loginUICache.phaseUI.animStatus == "forward" then
                phase_wrapper_animPercent = interpolateBetween(0, 0, 0, 1, 0, 0, getInterpolationProgress(loginUICache.phaseUI.animTickCounter, loginUICache.phaseUI.animDuration/2), "OutBack")
                phase_wrapper_content_animPercent = interpolateBetween(0, 0, 0, 1, 0, 0, getInterpolationProgress(loginUICache.phaseUI.animTickCounter, loginUICache.phaseUI.animDuration/2), "OutQuad")
            else
                phase_wrapper_animPercent = interpolateBetween(1, 0, 0, 0, 0, 0, getInterpolationProgress(loginUICache.phaseUI.animTickCounter, loginUICache.phaseUI.animDuration/2), "InBack")
                phase_wrapper_content_animPercent = interpolateBetween(1, 0, 0, 0, 0, 0, getInterpolationProgress(loginUICache.phaseUI.animTickCounter, loginUICache.phaseUI.animDuration/2), "OutQuad")
                if math.round(phase_wrapper_content_animPercent, 2) <= 0 then
                    loginUICache.phaseUI.currentPhase = 1
                    if loginUICache.phaseUI.scheduledPhase then
                        local __scheduledPhase = loginUICache.phaseUI.scheduledPhase
                        loginUICache.phaseUI.scheduledPhase = nil
                        setLoginUIPhase(__scheduledPhase)
                    end
                end
            end
            option_offsetY = phase_wrapper_animPercent*loginUICache.optionUI[currentLoginPhase].nudgeOptionY
            local isSavedCharacterSelected = not loginUICache.clientCharacters[loginUICache._selectedCharacter].isUnverified
            if phase_wrapper_content_animPercent > 0 then
                local option_wrapper_startX, option_wrapper_startY = loginUICache.optionUI.startX, loginUICache.optionUI.startY - option_offsetY
                local option_wrapper_width, option_wrapper_height = loginUICache.optionUI.width, loginUICache.optionUI.height + (loginUICache.optionUI.height*0.25*(1 - phase_wrapper_animPercent))
                for i, j in ipairs(loginUICache.phaseUI[currentLoginPhase].dividers) do
                    local divider_startX, divider_startY = option_wrapper_startX + j.startX, option_wrapper_startY + option_wrapper_height + j.startY
                    local divider_width, divider_height = j.width, loginUICache.phaseUI[currentLoginPhase].dividers.height
                    dxDrawRectangle(divider_startX, divider_startY, divider_width, divider_height, tocolor(j.bgColor[1], j.bgColor[2], j.bgColor[3], j.bgColor[4]*phase_wrapper_content_animPercent), false)
                end
                for i, j in ipairs(loginUICache.phaseUI[currentLoginPhase].buttons) do
                    local isUIToBeEnabled = true
                    if j.disableOnSavedCharacter and isSavedCharacterSelected then isUIToBeEnabled = false end
                    local button_startX, button_startY = option_wrapper_startX + j.startX, option_wrapper_startY + option_wrapper_height + j.startY
                    local button_width, button_height = j.width, j.height
                    local isButtonHovered = isMouseOnPosition(button_startX, button_startY, button_width, button_height) and isUIToBeEnabled
                    if not j.hoverAnimPercent then
                        j.hoverAnimPercent = 0.25
                        j.hoverStatus = "backward"
                        j.hoverAnimTickCounter = CLIENT_CURRENT_TICK
                    end
                    if isButtonHovered then
                        if isLMBClicked then
                            setLoginUIEnabled(false)
                            loadstring(j.funcString)()
                        end
                        if j.hoverStatus ~= "forward" then
                            --Sound.playFrontEnd(550)
                            j.hoverStatus = "forward"
                            j.hoverAnimTickCounter = CLIENT_CURRENT_TICK
                        end
                    else
                        if j.hoverStatus ~= "backward" then
                            j.hoverStatus = "backward"
                            j.hoverAnimTickCounter = CLIENT_CURRENT_TICK
                        end
                    end
                    if j.hoverStatus == "forward" then
                        j.hoverAnimPercent = interpolateBetween(j.hoverAnimPercent, 0, 0, 1, 0, 0, getInterpolationProgress(j.hoverAnimTickCounter, loginUICache.phaseUI[currentLoginPhase].buttons.hoverAnimDuration), "InQuad")
                    else
                        j.hoverAnimPercent = interpolateBetween(j.hoverAnimPercent, 0, 0, 0.25, 0, 0, getInterpolationProgress(j.hoverAnimTickCounter, loginUICache.phaseUI[currentLoginPhase].buttons.hoverAnimDuration), "InQuad")
                    end
                    dxDrawRoundedRectangle(button_startX, button_startY, button_width, button_height, tocolor(j.bgColor[1], j.bgColor[2], j.bgColor[3], j.bgColor[4]*math.max(j.minBGHoverValue or 0.8, j.hoverAnimPercent)*phase_wrapper_content_animPercent), false, true)
                    dxDrawText(j.placeholder, button_startX + j.paddingX, button_startY + j.paddingY, button_startX + button_width, button_startY + button_height, tocolor(j.fontColor[1], j.fontColor[2], j.fontColor[3], j.fontColor[4]*math.max(0.5, j.hoverAnimPercent)*phase_wrapper_content_animPercent), 1, loginUICache.phaseUI[currentLoginPhase].buttons.font, "center", "center", true, false, false)
                end
                local isEditboxClicked = false
                for i, j in ipairs(loginUICache.phaseUI[currentLoginPhase].editboxes) do
                    local isUIToBeEnabled = true
                    if j.disableOnSavedCharacter and isSavedCharacterSelected then isUIToBeEnabled = false end
                    local editbox_startX, editbox_startY = option_wrapper_startX + j.startX, option_wrapper_startY + option_wrapper_height + j.startY
                    local editbox_width, editbox_height = j.width, j.height
                    local editbox_embedLineSize = loginUICache.phaseUI[currentLoginPhase].editboxes.embedLineSize
                    local editbox_embedLinePaddingX, editbox_embedLinePaddingY = loginUICache.phaseUI[currentLoginPhase].editboxes.embedLinePaddingX, loginUICache.phaseUI[currentLoginPhase].editboxes.embedLinePaddingY
                    local editbox_fieldText = j.placeDataValue
                    local editbox_textLength = string.len(editbox_fieldText)
                    local editbox_textWidth = dxGetTextWidth(editbox_fieldText, 1, loginUICache.phaseUI[currentLoginPhase].editboxes.font)
                    local isEditboxHovered = isMouseOnPosition(editbox_startX, editbox_startY, editbox_width, editbox_height) and isUIToBeEnabled
                    if not j.hoverAnimPercent then
                        j.hoverAnimPercent = 0.35
                        j.hoverStatus = "backward"
                        j.hoverAnimTickCounter = CLIENT_CURRENT_TICK
                    end
                    if isEditboxHovered or (loginUICache.phaseUI[currentLoginPhase].editboxes.focussedEditbox == i) then
                        if isEditboxHovered and isLMBClicked then
                            if loginUICache.phaseUI[currentLoginPhase].editboxes.focussedEditbox ~= i then
                                loginUICache.phaseUI[currentLoginPhase].editboxes.focussedEditbox = i
                            end
                            isEditboxClicked = true
                        end
                        if j.hoverStatus ~= "forward" then
                            --Sound.playFrontEnd(550)
                            j.hoverStatus = "forward"
                            j.hoverAnimTickCounter = CLIENT_CURRENT_TICK
                        end
                    else
                        if j.hoverStatus ~= "backward" then
                            j.hoverStatus = "backward"
                            j.hoverAnimTickCounter = CLIENT_CURRENT_TICK
                        end
                    end
                    if loginUICache.phaseUI[currentLoginPhase].editboxes.focussedEditbox == i then
                        if not isUIToBeEnabled then
                            loginUICache.phaseUI[currentLoginPhase].editboxes.focussedEditbox = 0
                        end
                    end
                    if j.hoverStatus == "forward" then
                        j.hoverAnimPercent = interpolateBetween(j.hoverAnimPercent, 0, 0, 1, 0, 0, getInterpolationProgress(j.hoverAnimTickCounter, loginUICache.phaseUI[currentLoginPhase].editboxes.hoverAnimDuration), "InQuad")
                    else
                        j.hoverAnimPercent = interpolateBetween(j.hoverAnimPercent, 0, 0, 0.35, 0, 0, getInterpolationProgress(j.hoverAnimTickCounter, loginUICache.phaseUI[currentLoginPhase].editboxes.hoverAnimDuration), "InQuad")
                    end
                    local isPlaceHolderToBeShown = string.len(j.placeDataValue) <= 0
                    local editbox_textAlignmentX = "center"
                    if loginUICache.phaseUI[currentLoginPhase].editboxes.focussedEditbox == i then
                        editbox_textAlignmentX = ((editbox_textWidth > (editbox_width - (editbox_embedLinePaddingX*2))) and "right") or editbox_textAlignmentX
                    end
                    dxDrawRoundedRectangle(editbox_startX, editbox_startY, editbox_width, editbox_height, tocolor(j.bgColor[1], j.bgColor[2], j.bgColor[3], j.bgColor[4]*math.max(0.8, j.hoverAnimPercent)*phase_wrapper_content_animPercent), false, true)
                    dxDrawRectangle(editbox_startX + editbox_embedLinePaddingX, editbox_startY + editbox_height - editbox_embedLinePaddingY, editbox_width - (editbox_embedLinePaddingX*2), editbox_embedLineSize, tocolor(j.embedLineColor[1], j.embedLineColor[2], j.embedLineColor[3], j.embedLineColor[4]*j.hoverAnimPercent*phase_wrapper_content_animPercent), false)
                    dxDrawText((isPlaceHolderToBeShown and (loginUICache.phaseUI[currentLoginPhase].editboxes.focussedEditbox ~= i) and j.placeholder) or editbox_fieldText, editbox_startX + editbox_embedLinePaddingX, editbox_startY, editbox_startX + editbox_width - editbox_embedLinePaddingX, editbox_startY + editbox_height - editbox_embedLinePaddingY + j.paddingY, (isPlaceHolderToBeShown and tocolor(j.placeholderFontColor[1], j.placeholderFontColor[2], j.placeholderFontColor[3], j.placeholderFontColor[4]*j.hoverAnimPercent*phase_wrapper_content_animPercent)) or tocolor(j.fontColor[1], j.fontColor[2], j.fontColor[3], j.fontColor[4]*j.hoverAnimPercent*phase_wrapper_content_animPercent), 1, loginUICache.phaseUI[currentLoginPhase].editboxes.font, editbox_textAlignmentX, "bottom", true, false, false)
                    if loginUICache.phaseUI[currentLoginPhase].editboxes.focussedEditbox == i then
                        local editbox_cursorSize = loginUICache.phaseUI[currentLoginPhase].editboxes.cursorSize
                        local editbox_cursorPaddingX, editbox_cursorPaddingY = loginUICache.phaseUI[currentLoginPhase].editboxes.cursorPaddingX, loginUICache.phaseUI[currentLoginPhase].editboxes.cursorPaddingY
                        local editbox_offsetX = false
                        if editbox_textAlignmentX == "center" then
                            editbox_offsetX = editbox_startX + editbox_embedLinePaddingX + (((editbox_width - (editbox_embedLinePaddingX*2)) + editbox_textWidth)/2)
                        elseif editbox_textAlignmentX == "right" then
                            editbox_offsetX = editbox_startX + (editbox_width - editbox_embedLinePaddingX)
                        end
                        if editbox_offsetX then
                            dxDrawRectangle(editbox_offsetX + editbox_cursorPaddingX, editbox_startY + editbox_cursorPaddingY, editbox_cursorSize, editbox_height - editbox_embedLinePaddingY - (editbox_cursorPaddingY*2), tocolor(j.cursorColor[1], j.cursorColor[2], j.cursorColor[3], j.cursorColor[4]*j.hoverAnimPercent*phase_wrapper_content_animPercent), false)
                        end
                        if not GuiElement.isMTAWindowActive() and loginUICache.isEnabled and not loginUICache.isForcedDisabled then
                            local currentPressedKey = false
                            if getKeyState("backspace") then
                                currentPressedKey = "backspace"
                            else
                                if _currentPressedKey and j.inputSettings then
                                    if j.inputSettings.validKeys then
                                        for k, v in ipairs(j.inputSettings.validKeys) do
                                            if getKeyState(v) then
                                                currentPressedKey = v:gsub("num_", "")
                                                break
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
                                    if prevInputKeyStreak < 1 and (loginUICache.phaseUI[currentLoginPhase].editboxes.inputDelayDuration - CLIENT_CURRENT_TICK + inputTickCounter) >= 0 then
                                        isOnDelay = true
                                    else
                                        prevInputKeyStreak = prevInputKeyStreak + 1
                                    end
                                else
                                    prevInputKeyStreak = 0
                                end
                                if not isOnDelay then
                                    if currentPressedKey == "backspace" then
                                        j.placeDataValue = string.sub(editbox_fieldText, 1, editbox_textLength - 1)
                                    else
                                        if j.inputSettings and j.inputSettings.rangeLimit and (editbox_textLength < j.inputSettings.rangeLimit[2]) then
                                            j.placeDataValue = editbox_fieldText..currentPressedKey:gsub("space", " ")
                                        end
                                    end
                                    inputTickCounter = CLIENT_CURRENT_TICK
                                    prevInputKey = currentPressedKey
                                end
                            end
                        end
                    end
                end
                _currentKeyCheck = true
                if isLMBClicked and not isEditboxClicked then
                    loginUICache.phaseUI[currentLoginPhase].editboxes.focussedEditbox = 0
                end
                for i, j in ipairs(loginUICache.phaseUI[currentLoginPhase].sliders) do
                    local isUIToBeEnabled = true
                    if j.disableOnSavedCharacter and isSavedCharacterSelected then isUIToBeEnabled = false end
                    local slider_startX, slider_startY = option_wrapper_startX + j.startX, option_wrapper_startY + option_wrapper_height + j.startY
                    local slider_width, slider_height = j.width, j.height
                    local slider_highlighterSize = loginUICache.phaseUI[currentLoginPhase].sliders.highlighterSize
                    local slider_highlighterPaddingX, slider_barPaddingX = loginUICache.phaseUI[currentLoginPhase].sliders.highlighterPaddingX, loginUICache.phaseUI[currentLoginPhase].sliders.barPaddingX
                    local slider_highlighterX, slider_highlighterY = slider_startX + slider_highlighterPaddingX, slider_startY + ((slider_height - slider_highlighterSize)/2)
                    local slider_barWidth, slider_barHeight = slider_width - slider_highlighterSize - (slider_highlighterPaddingX*2) - slider_barPaddingX, loginUICache.phaseUI[currentLoginPhase].sliders.barSize
                    local slider_barX, slider_barY = slider_startX + slider_highlighterSize + (slider_highlighterPaddingX*2), slider_startY + ((slider_height - slider_barHeight)/2)
                    local slider_barSliderSize = loginUICache.phaseUI[currentLoginPhase].sliders.barSliderSize
                    local slider_barSlider_startX, slider_barSlider_startY = slider_barX + ((slider_barWidth*(j.percent/100)) - (slider_barSliderSize/2)), slider_barY - (slider_barSliderSize/2)
                    local isSliderHovered = isMouseOnPosition(slider_startX, slider_startY, slider_width, slider_height) and isUIToBeEnabled
                    if not j.hoverAnimPercent then
                        j.hoverAnimPercent = 0.35
                        j.hoverStatus = "backward"
                        j.hoverAnimTickCounter = CLIENT_CURRENT_TICK
                    end
                    if isSliderHovered or (loginUICache.phaseUI[currentLoginPhase].sliders.focussedSlider == i) then
                        if isSliderHovered then
                            local isBarSliderHovered = isMouseOnPosition(slider_barSlider_startX, slider_barSlider_startY, slider_barSliderSize, slider_barSliderSize)                            
                            if loginUICache.phaseUI[currentLoginPhase].sliders.focussedSlider ~= i then
                                if isBarSliderHovered and isLMBClicked then
                                    loginUICache.phaseUI[currentLoginPhase].sliders.focussedSlider = i
                                end
                            end
                            if j.hoverStatus ~= "forward" then
                                --Sound.playFrontEnd(550)
                                j.hoverStatus = "forward"
                                j.hoverAnimTickCounter = CLIENT_CURRENT_TICK
                            end
                        end
                    else
                        if j.hoverStatus ~= "backward" then
                            j.hoverStatus = "backward"
                            j.hoverAnimTickCounter = CLIENT_CURRENT_TICK
                        end
                    end
                    if loginUICache.phaseUI[currentLoginPhase].sliders.focussedSlider == i then
                        if isUIToBeEnabled then
                            if isLMBOnHold then
                                j.percent = math.floor(math.min(100, math.max(j.minPercent, math.floor(((getAbsoluteCursorPosition() - slider_barX + (slider_barSliderSize/2))/slider_barWidth)*100))))
                                manageLoginPreviewCharacter("update_skin")
                            else
                                loginUICache.phaseUI[currentLoginPhase].sliders.focussedSlider = 0
                            end
                        else
                            loginUICache.phaseUI[currentLoginPhase].sliders.focussedSlider = 0
                        end
                    end
                    if j.hoverStatus == "forward" then
                        j.hoverAnimPercent = interpolateBetween(j.hoverAnimPercent, 0, 0, 1, 0, 0, getInterpolationProgress(j.hoverAnimTickCounter, loginUICache.phaseUI[currentLoginPhase].sliders.hoverAnimDuration), "InQuad")
                    else
                        j.hoverAnimPercent = interpolateBetween(j.hoverAnimPercent, 0, 0, 0.35, 0, 0, getInterpolationProgress(j.hoverAnimTickCounter, loginUICache.phaseUI[currentLoginPhase].sliders.hoverAnimDuration), "InQuad")
                    end
                    dxDrawRoundedRectangle(slider_startX, slider_startY, slider_width, slider_height, tocolor(j.bgColor[1], j.bgColor[2], j.bgColor[3], j.bgColor[4]*math.max(0.8, j.hoverAnimPercent)*phase_wrapper_content_animPercent), false, true)
                    dxDrawRoundedRectangle(slider_highlighterX, slider_highlighterY, slider_highlighterSize, slider_highlighterSize, tocolor(j.highlighterColor[1], j.highlighterColor[2], j.highlighterColor[3], j.highlighterColor[4]*j.hoverAnimPercent*phase_wrapper_content_animPercent), false, true)
                    dxDrawRectangle(slider_barX, slider_barY, slider_barWidth, slider_barHeight, tocolor(j.barColor[1], j.barColor[2], j.barColor[3], j.barColor[4]*j.hoverAnimPercent*phase_wrapper_content_animPercent), false)
                    dxDrawRectangle(slider_barSlider_startX, slider_barSlider_startY, slider_barSliderSize, slider_barSliderSize, tocolor(j.sliderBarColor[1], j.sliderBarColor[2], j.sliderBarColor[3], j.sliderBarColor[4]*j.hoverAnimPercent*phase_wrapper_content_animPercent), false)
                end
            end
        end
    elseif currentLoginPhase == 1 then
        if loginUICache.phaseUI.______isGameResuming then
            setLoginUIEnabled(false)
            loadstring(loginUICache.optionUI[currentLoginPhase].funcString)()
        end
    end
    ]]--

    for i, j in ipairs(loginUICache.optionUI) do
        local option_startX, option_startY = loginUICache.optionUI.startX, loginUICache.optionUI.startY - option_offsetY + (math.max(0, i - 1)*(loginUICache.optionUI.slotHeight + loginUICache.optionUI.paddingY))
        local options_width, options_height = loginUICache.optionUI.width, loginUICache.optionUI.slotHeight
        local isOptionSelected = ((currentLoginPhase ~= 1) and (currentLoginPhase == i))
        local isOptionHovered = isMouseOnPosition(option_startX, option_startY, options_width, options_height)
        if not j.hoverAnimPercent then
            j.hoverAnimPercent = 0
            j.hoverStatus = "backward"
            j.hoverAnimTickCounter = CLIENT_CURRENT_TICK
        end
        if isOptionHovered or isOptionSelected then
            if isLMBClicked and isOptionHovered then
                setLoginUIEnabled(false)
                if not isOptionSelected then
                    Timer(function()
                        --loadstring(j.funcString)()
                    end, 1, 1)
                else
                    if currentLoginPhase ~= 1 then
                        Timer(function()
                            --setLoginUIPhase(1)
                        end, 1, 1)
                    end
                end
            end
            if j.hoverStatus ~= "forward" then
                --Sound.playFrontEnd(550)
                j.hoverStatus = "forward"
                j.hoverAnimTickCounter = CLIENT_CURRENT_TICK
            end
        else
            if j.hoverStatus ~= "backward" then
                j.hoverStatus = "backward"
                j.hoverAnimTickCounter = CLIENT_CURRENT_TICK
            end
        end
        if j.hoverStatus == "forward" then
            j.hoverAnimPercent = interpolateBetween(j.hoverAnimPercent, 0, 0, 1, 0, 0, getInterpolationProgress(j.hoverAnimTickCounter, loginUICache.optionUI.hoverAnimDuration), "InQuad")
        else
            j.hoverAnimPercent = interpolateBetween(j.hoverAnimPercent, 0, 0, 0, 0, 0, getInterpolationProgress(j.hoverAnimTickCounter, loginUICache.optionUI.hoverAnimDuration), "InQuad")
        end
        local option_color = (j.fontColor and tocolor(j.fontColor[1], j.fontColor[2], j.fontColor[3], j.fontColor[4]*math.max(0.1, j.hoverAnimPercent))) or tocolor(loginUICache.optionUI.fontColor[1], loginUICache.optionUI.fontColor[2], loginUICache.optionUI.fontColor[3], loginUICache.optionUI.fontColor[4]*math.max(0.1, j.hoverAnimPercent))
        dxDrawImage(option_startX, option_startY, options_height, options_height, loginUICache.optionUI.leftEdgePath, 0, 0, 0, loginUICache.optionUI.bgColor, false)
        dxDrawImage(option_startX + options_width - options_height, option_startY, options_height, options_height, loginUICache.optionUI.rightEdgePath, 0, 0, 0, loginUICache.optionUI.bgColor, false)
        dxDrawRectangle(option_startX + options_height, option_startY, options_width - (options_height*2), options_height, loginUICache.optionUI.bgColor, false)
        dxDrawText(j.placeholder, option_startX + options_height, option_startY, option_startX + options_width - (options_height*2), option_startY + options_height, option_color, 1, loginUICache.optionUI.font, "center", "center", true, false, false)
    end

end