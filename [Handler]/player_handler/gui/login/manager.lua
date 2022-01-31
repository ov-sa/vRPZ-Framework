----------------------------------------------------------------
--[[ Resource: Player Handler
     Script: gui: loginScreen: manager.lua
     Server: ᴏᴠ | Halo:Combat
     Author: OvileAmriam
     Developer: -
     DOC: 11/06/2021 (OvileAmriam)
     Desc: Login Screen Manager ]]--
----------------------------------------------------------------


-------------------
--[[ Variables ]]--
-------------------

local customizerPhaseID = false
for i, j in ipairs(loginUICache.optionUI) do
    if j.optionType == "characters" then
        customizerPhaseID = i
        break
    end
end


--------------------------------------------
--[[ Event: On Client Load Character ID ]]--
--------------------------------------------

addEvent("onClientLoadCharacterID", true)
addEventHandler("onClientLoadCharacterID", root, function(character, characterID)

    if not loginUICache.clientCharacters[character] then return false end

    loginUICache.clientCharacters[character]._id = characterID
    triggerEvent("onDisplayNotification", localPlayer, "You've successfully saved the character.", {80, 80, 255, 255}, "loginUI")

end)


------------------------------------------------------------------
--[[ Functions: Loads/Updates/Manages Login Preview Character ]]--
------------------------------------------------------------------

function loadLoginPreviewCharacter(loadDefault, isToBeCreated)

    if not loadDefault then
        if not loginUICache.clientCharacters[loginUICache._selectedCharacter] then
            if #loginUICache.clientCharacters > 0 then
                loginUICache.selectedCharacter = 1
                loginUICache._selectedCharacter = loginUICache.selectedCharacter
            else
                loadDefault = true
            end
        end
    end

    if loadDefault then
        loginUICache.phaseUI[customizerPhaseID].placeDataValue = 1
        for i, j in ipairs(loginUICache.phaseUI[customizerPhaseID].editboxes) do
            j.placeDataValue = ""
        end
        for i, j in ipairs(loginUICache.phaseUI[customizerPhaseID].sliders) do
            j.percent = 100
        end
        if isToBeCreated then
            local __characterData = {
                isUnverified = true
            }
            table.insert(loginUICache.clientCharacters, __characterData)
            loginUICache._selectedCharacter = #loginUICache.clientCharacters
            loginUICache._unsavedCharacters[loginUICache._selectedCharacter] = true
        end
    else
        local characterIndex = false
        local characterType = loginUICache.clientCharacters[loginUICache._selectedCharacter]["type"]
        local characterColor = loginUICache.clientCharacters[loginUICache._selectedCharacter]["color"] or {255, 255, 255}
        for i, j in ipairs(loginUICache.phaseUI[customizerPhaseID].placeDataTable) do
            if characterType == j then
                characterIndex = i
                break
            end
        end
        loginUICache.phaseUI[customizerPhaseID].placeDataValue = characterIndex or 1
        for i, j in ipairs(loginUICache.phaseUI[customizerPhaseID].editboxes) do
            j.placeDataValue = loginUICache.clientCharacters[loginUICache._selectedCharacter][j.type] or ""
        end
        for i, j in ipairs(loginUICache.phaseUI[customizerPhaseID].sliders) do
            if j.type == "color_r" then
                j.percent = (characterColor[1]/255)*100
            elseif j.type == "color_g" then
                j.percent = (characterColor[2]/255)*100
            elseif j.type == "color_b" then
                j.percent = (characterColor[3]/255)*100
            end
        end
    end
    updateLoginPreviewCharacter()
    return true

end

function updateLoginPreviewCharacter()

    if not loginUICache.character or not isElement(loginUICache.character) then return false end

    local selectedCharacterType = false
    if loginUICache.phaseUI[customizerPhaseID].placeDataTable[(loginUICache.phaseUI[customizerPhaseID].placeDataValue)] then
        selectedCharacterType = loginUICache.phaseUI[customizerPhaseID].placeDataTable[(loginUICache.phaseUI[customizerPhaseID].placeDataValue)]
    end
    if not selectedCharacterType then return false end

    local characterSyncData = {
        type = selectedCharacterType,
        color = {255, 255, 255}
    }
    for i, j in ipairs(loginUICache.phaseUI[customizerPhaseID].sliders) do
        if j.type == "color_r" then
            characterSyncData.color[1] = math.floor((j.percent/100)*255)
        elseif j.type == "color_g" then
            characterSyncData.color[2] = math.floor((j.percent/100)*255)
        elseif j.type == "color_b" then
            characterSyncData.color[3] = math.floor((j.percent/100)*255)
        end
    end
    triggerEvent("onSyncPedCharacter", localPlayer, loginUICache.character, characterSyncData)
    loginUICache.character:setAlpha(255)
    return true

end

function manageLoginPreviewCharacter(manageType)

    if not manageType then return false end

    if manageType == "create" then
        setLoginUIEnabled(true)
        local clientCharacterLimit = serverCharacterLimit.default
        if #loginUICache.clientCharacters >= clientCharacterLimit then
            triggerEvent("onDisplayNotification", localPlayer, "You have exceeded your character limit! ["..clientCharacterLimit.."]", {255, 35, 35, 255}, "loginUI")
            return false
        end
        if loadLoginPreviewCharacter(true, true) then
            triggerEvent("onDisplayNotification", localPlayer, "You've successfully created a character.", {80, 80, 255, 255}, "loginUI")
        end
    elseif manageType == "delete" then
        setLoginUIEnabled(true)
        if #loginUICache.clientCharacters <= 1 then
            if #loginUICache.clientCharacters <= 0 then
                loadLoginPreviewCharacter(true, true)
            end
            triggerEvent("onDisplayNotification", localPlayer, "You don't have enough characters to delete!", {255, 35, 35, 255}, "loginUI")
            return false
        end
        if not loginUICache.clientCharacters[loginUICache._selectedCharacter].isUnverified then
            if not loginUICache.clientCharacters[loginUICache._selectedCharacter]._id then
                triggerEvent("onDisplayNotification", localPlayer, "You must wait until the character processing is done.", {255, 35, 35, 255}, "loginUI")
                return false
            else
                triggerServerEvent("onClientCharacterDelete", localPlayer, loginUICache.clientCharacters[loginUICache._selectedCharacter]._id)
            end
        end
        table.remove(loginUICache.clientCharacters, loginUICache._selectedCharacter)
        loginUICache._unsavedCharacters[loginUICache._selectedCharacter] = nil
        loginUICache._selectedCharacter = math.max(0, loginUICache._selectedCharacter - 1)
        loadLoginPreviewCharacter()
        triggerEvent("onDisplayNotification", localPlayer, "You've successfully deleted the character.", {80, 80, 255, 255}, "loginUI")
    elseif manageType == "update_skin" then
        updateLoginPreviewCharacter()
    elseif (manageType == "switch_prev_skin") or (manageType == "switch_next_skin") then
        setLoginUIEnabled(true)
        if manageType == "switch_prev_skin" then
            if loginUICache.phaseUI[customizerPhaseID].placeDataTable[(loginUICache.phaseUI[customizerPhaseID].placeDataValue - 1)] then
                loginUICache.phaseUI[customizerPhaseID].placeDataValue = loginUICache.phaseUI[customizerPhaseID].placeDataValue - 1
                updateLoginPreviewCharacter()
            end
        elseif manageType == "switch_next_skin" then
            if loginUICache.phaseUI[customizerPhaseID].placeDataTable[(loginUICache.phaseUI[customizerPhaseID].placeDataValue + 1)] then
                loginUICache.phaseUI[customizerPhaseID].placeDataValue = loginUICache.phaseUI[customizerPhaseID].placeDataValue + 1
                updateLoginPreviewCharacter()
            end
        end
    elseif (manageType == "switch_prev") or (manageType == "switch_next") then
        setLoginUIEnabled(true)
        if manageType == "switch_prev" then
            if loginUICache._selectedCharacter > 1 then
                loginUICache._selectedCharacter = loginUICache._selectedCharacter - 1
                loadLoginPreviewCharacter()
            end
        elseif manageType == "switch_next" then
            if loginUICache._selectedCharacter < #loginUICache.clientCharacters then
                loginUICache._selectedCharacter = loginUICache._selectedCharacter + 1
                loadLoginPreviewCharacter()
            end
        end
    elseif manageType == "pick" then
        setLoginUIEnabled(true)
        if (loginUICache._selectedCharacter ~= 0) and (loginUICache.selectedCharacter == loginUICache._selectedCharacter) then
            triggerEvent("onDisplayNotification", localPlayer, "You've already picked the specified character.", {255, 35, 35, 255}, "loginUI")
            return false
        end
        if (not loginUICache.clientCharacters[loginUICache._selectedCharacter]) or loginUICache.clientCharacters[loginUICache._selectedCharacter].isUnverified then
            triggerEvent("onDisplayNotification", localPlayer, "You must save the character inorder to pick!", {255, 35, 35, 255}, "loginUI")
            return false
        end
        loginUICache.selectedCharacter = loginUICache._selectedCharacter
        triggerEvent("onDisplayNotification", localPlayer, "You've successfully picked the character.", {80, 80, 255, 255}, "loginUI")
    elseif manageType == "save" then
        local selectedCharacterType = false
        if loginUICache.phaseUI[customizerPhaseID].placeDataTable[(loginUICache.phaseUI[customizerPhaseID].placeDataValue)] then
            selectedCharacterType = loginUICache.phaseUI[customizerPhaseID].placeDataTable[(loginUICache.phaseUI[customizerPhaseID].placeDataValue)]
        end
        if (not selectedCharacterType) or (#loginUICache.clientCharacters <= 0) or (#loginUICache.clientCharacters > 0 and not loginUICache.clientCharacters[loginUICache._selectedCharacter].isUnverified) then
            setLoginUIEnabled(true)
            return false
        end
        setLoginUIEnabled(false, false)
        triggerEvent("onDisplayNotification", localPlayer, "Saving Character...", {175, 175, 175, 255}, "loginUI")
        local characterSyncData = {
            type = selectedCharacterType,
            color = {255, 255, 255}
        }
        for i, j in ipairs(loginUICache.phaseUI[customizerPhaseID].editboxes) do
            characterSyncData[j.type] = j.placeDataValue
        end
        for i, j in ipairs(loginUICache.phaseUI[customizerPhaseID].sliders) do
            if j.type == "color_r" then
                characterSyncData.color[1] = math.floor((j.percent/100)*255)
            elseif j.type == "color_g" then
                characterSyncData.color[2] = math.floor((j.percent/100)*255)
            elseif j.type == "color_b" then
                characterSyncData.color[3] = math.floor((j.percent/100)*255)
            end
        end
        loginUICache.clientCharacters[loginUICache._selectedCharacter] = characterSyncData
        local charactersPendingToBeSaved = {}
        local charactersToBeSaved = table.copy(loginUICache.clientCharacters, true)
        for i, j in ipairs(charactersToBeSaved) do
            if j.isUnverified then
                charactersToBeSaved[i] = nil
                if loginUICache._unsavedCharacters[i] then
                    charactersPendingToBeSaved[i] = true
                end
            end
        end
        triggerServerEvent("onClientCharacterSave", localPlayer, loginUICache.selectedCharacter, charactersToBeSaved, loginUICache._unsavedCharacters)
        loginUICache._unsavedCharacters = charactersPendingToBeSaved
    elseif manageType == "play" then
        local currentLoginPhase = loginUICache.phaseUI.currentPhase
        if not currentLoginPhase then
            setLoginUIEnabled(true)
            return false
        end
        if currentLoginPhase ~= 1 then
            loginUICache.phaseUI.______isGameResuming = true
            setLoginUIPhase(1)
        else
            if #loginUICache.clientCharacters <= 0 then
                setLoginUIEnabled(true)
                triggerEvent("onDisplayNotification", localPlayer, "You must create a character inorder to play!", {255, 35, 35, 255}, "loginUI")
                return false
            else
                if not loginUICache.clientCharacters[loginUICache.selectedCharacter] then
                    setLoginUIEnabled(true)
                    triggerEvent("onDisplayNotification", localPlayer, "You must pick a character inorder to play!", {255, 35, 35, 255}, "loginUI")
                    return false
                end
            end
            setLoginUIEnabled(false, false)
            triggerEvent("onDisplayNotification", localPlayer, "Signing In...", {175, 175, 175, 255}, "loginUI")
            triggerEvent("onPlayerShowLoadingScreen", localPlayer)
            Timer(function()
                hideLoginScreen()
            end, loadingScreenCache.animFadeInDuration + 250, 1)
            Timer(function(selectedCharacter, clientCharacters)
                triggerServerEvent("onPlayerResumeGame", localPlayer, selectedCharacter, clientCharacters)
            end, loadingScreenCache.animFadeInDuration + loadingScreenCache.animFadeOutDuration + loadingScreenCache.animFadeDelayDuration, 1, loginUICache.selectedCharacter, loginUICache.clientCharacters)
        end
    end
    return true

end