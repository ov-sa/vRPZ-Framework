----------------------------------------------------------------
--[[ Resource: Config Loader
     Script: configs: gameplay: gui: login.lua
     Author: vStudio
     Developer(s): Tron
     DOC: 31/01/2022
     Desc: Login UI Toggler ]]--
----------------------------------------------------------------


------------------------------------------
--[[ Functions: Sets Login UI's Phase ]]--
------------------------------------------

function setLoginUIPhase(phaseID)

    phaseID = tonumber(phaseID)
    if not phaseID or not loginUICache.optionUI[phaseID] or (phaseID ~= 1 and not loginUICache.phaseUI[phaseID]) or (loginUICache.phaseUI.currentPhase and loginUICache.phaseUI.currentPhase == phaseID) then return false end

    if loginUICache.phaseUI.currentPhase ~= 1 then
        loginUICache.phaseUI.animStatus = "backward"
        if phaseID ~= 1 then
            loginUICache.phaseUI.scheduledPhase = phaseID
        end
    else
        loginUICache.phaseUI.animStatus = "forward"
        loginUICache.phaseUI.currentPhase = phaseID
        loginUICache.phaseUI.scheduledPhase = nil
    end
    loginUICache.phaseUI.animTickCounter = getTickCount()
    local unverifiedCharacters = {}
    if #loginUICache.clientCharacters > 1 then
        for i, j in ipairs(loginUICache.clientCharacters) do
            if j.isUnverified then
                table.insert(unverifiedCharacters, i)
            end
        end
        for i, j in ipairs(loginUICache.clientCharacters) do
            if j.isUnverified then
                table.remove(loginUICache.clientCharacters, i)
                loginUICache._unsavedCharacters[i] = nil
            end
        end
        for i, j in ipairs(unverifiedCharacters) do
            if loginUICache.selectedCharacter == j then
                loginUICache.selectedCharacter = 0
                loginUICache._selectedCharacter = false
                break
            else
                if loginUICache._selectedCharacter == j then
                    loginUICache._selectedCharacter = false
                end
            end
        end
        loadLoginPreviewCharacter()
    end
    setLoginUIEnabled(true)
    return true

end
addEvent("Player-Handler:onSetLoginPhase", true)
addEventHandler("Player-Handler:onSetLoginPhase", root, setLoginUIPhase)


----------------------------------------------
--[[ Function: Enables/Disables Login GUI ]]--
----------------------------------------------

function setLoginUIEnabled(state, forcedState)
    
    if forcedState ~= nil then
        loginUICache.isForcedDisabled = not forcedState
        loginUICache.isEnabled = forcedState
    else
        loginUICache.isEnabled = state
    end
    return true

end
addEvent("onClientLoginUIEnable", true)
addEventHandler("onClientLoginUIEnable", root, setLoginUIEnabled)


---------------------------------------------
--[[ Functions: Shows/Hides Login Screen ]]--
---------------------------------------------

function showLoginScreen()

    if loginUICache.state then return false end

    loginUICache.state = true
    loginUICache.cinemationData = FRAMEWORK_CONFIGS["UI"]["Login"].cinemationPoints[math.random(#FRAMEWORK_CONFIGS["UI"]["Login"].cinemationPoints)]
    loginUICache.character = Ped(0, loginUICache.cinemationData.characterPoint.x, loginUICache.cinemationData.characterPoint.y, loginUICache.cinemationData.characterPoint.z + 0.01, loginUICache.cinemationData.characterPoint.rotation)
    loginUICache.character:setDimension(FRAMEWORK_CONFIGS["UI"]["Login"].lobbyDimension)
    loginUICache.character:setAlpha(0)
    if #loginUICache.clientCharacters <= 0 then
        --loadLoginPreviewCharacter(true, true)
    else
        --loadLoginPreviewCharacter()
    end
    setLoginUIPhase(1)
    exports.cinecam_handler:startCinemation(loginUICache.cinemationData.cinemationPoint, true, true, loginUICache.cinemationData.cinemationFOV, true, true, true, false)
    triggerEvent("onLoginSoundStart", localPlayer, true)
    beautify.render.create(renderLoginScreen)
    showChat(false)
    showCursor(true)
    return true

end

function hideLoginScreen()

    if not loginUICache.state then return false end

    beautify.render.remove(renderLoginScreen)
    exports.cinecam_handler:stopCinemation()
    triggerEvent("onLoginSoundStop", localPlayer)
    loginUICache.character:destroy()
    loginUICache.phaseUI.currentPhase = 1
    loginUICache.phaseUI.______isGameResuming = false
    loginUICache.phaseUI.animStatus = "backward"
    loginUICache.cinemationData = false
    loginUICache.character = false
    loginUICache.selectedCharacter = 0
    loginUICache._selectedCharacter = false
    loginUICache.clientCharacters = {}
    loginUICache.state = false
    showChat(true)
    showCursor(false)
    return true

end

addEvent("onPlayerShowLoginScreen", true)
addEventHandler("onPlayerShowLoginScreen", root, function(character, characters)

    loginUICache.selectedCharacter = character
    loginUICache._selectedCharacter = loginUICache.selectedCharacter
    loginUICache.clientCharacters = characters
    loginUICache._unsavedCharacters = {}
    exports.asset_loader:loadMap(FRAMEWORK_CONFIGS["UI"]["Login"].lobbyMap, FRAMEWORK_CONFIGS["UI"]["Login"].lobbyDimension)
    localPlayer:setPosition(FRAMEWORK_CONFIGS["UI"]["Login"].lobbyPosition.x, FRAMEWORK_CONFIGS["UI"]["Login"].lobbyPosition.y, FRAMEWORK_CONFIGS["UI"]["Login"].lobbyPosition.z)
    localPlayer:setDimension(FRAMEWORK_CONFIGS["UI"]["Login"].lobbyDimension)
    toggleControl("fire", true)
    localPlayer:setData("Character:Reloading", nil)
    setLoginUIEnabled(true, true)
    Timer(function()
        showLoginScreen()
        Camera.fade(true)
        triggerEvent("onPlayerHideLoadingScreen", localPlayer)
    end, 10000, 1)

end)


-----------------------------------------
--[[ Event: On Client Resource Start ]]--
-----------------------------------------

addEventHandler("onClientResourceStart", resource, function()

    showLoginScreen() --TODO: REMOVE LATER
    --Camera.fade(false)
    --triggerEvent("onPlayerShowLoadingScreen", localPlayer)
    --triggerServerEvent("onPlayerRequestShowLoginScreen", localPlayer)
    setPedTargetingMarkerEnabled(false)
    setPlayerHudComponentVisible("all", false)
    toggleControl("action", false)
    toggleControl("radar", false)

end)