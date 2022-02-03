----------------------------------------------------------------
--[[ Resource: Player Handler
     Script: gui: respawner.lua
     Author: vStudio
     Developer(s): Mario, Tron
     DOC: 31/01/2022
     Desc: Respawner UI Handler ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local imports = {
    setTimer = setTimer,
    dxCreateTexture = dxCreateTexture
}


-------------------
--[[ Variables ]]--
-------------------

local respawnerUI = {
    state = false,
    mode = false,
    flashInterval = 2000,
    flashTerminationDuration = 10000,
    flashColor = {0, 0, 0, 255},
    vignetteTexture = imports.dxCreateTexture("files/images/hud/vignette.png", "argb", true, "clamp")
}


-------------------------------------------------
--[[ Functions: Hides/Renders Respawn Screen ]]--
-------------------------------------------------

local renderRespawnScreen = nil
local function hideRespawnScreen()

    if not respawnerUI.state then return false end

    beautify.render.remove(renderRespawnScreen)
    respawnerUI.mode = false
    respawnerUI.state = false
    return true

end

renderRespawnScreen = function()

    if not respawnerUI.state or not respawnerUI.mode or not isPlayerInitialized(localPlayer) then
        hideRespawnScreen()
        return false
    end

    if respawnerUI.mode.type == "generate_client_spawn" then
        local elapsedDuration = CLIENT_CURRENT_TICK - respawnerUI.mode.tickCounter
        if elapsedDuration >= (loadingUI.animFadeInDuration + loadingUI.animFadeDelayDuration) then
            local clientPosVector = localPlayer:getPosition()
            local characterSpawn = localPlayer:getData("Character:spawn") 
            if not characterSpawn or not playerSpawnPoints[characterSpawn] then
                characterSpawn = "East"
            end
            for i = 1, 360 do
                local generatedSpawnPoint = {}
                generatedSpawnPoint.x, generatedSpawnPoint.y = getPointFromDistanceRotation(respawnerUI.mode.wastedPoint.x, respawnerUI.mode.wastedPoint.y, i + 275, i)
                localPlayer:setPosition(generatedSpawnPoint.x, generatedSpawnPoint.y, respawnerUI.mode.wastedPoint.z)
                generatedSpawnPoint.z = getGroundPosition(generatedSpawnPoint.x, generatedSpawnPoint.y, respawnerUI.mode.wastedPoint.z + 2.5)
                if generatedSpawnPoint.x and generatedSpawnPoint.y and generatedSpawnPoint.z and generatedSpawnPoint.z ~= 0 then
                    triggerServerEvent("Player:onRespawn", localPlayer, generatedSpawnPoint)
                    hideRespawnScreen()
                    return false
                end
            end
            local availableSpawnPoints = playerSpawnPoints[characterSpawn]
            local generatedSpawnPoint = availableSpawnPoints[math.random(1, #availableSpawnPoints)]
            triggerServerEvent("Player:onRespawn", localPlayer, generatedSpawnPoint)
            hideRespawnScreen()
            return false
        end
    elseif respawnerUI.mode.type == "respawn_client" then
        local flashAnimAlphaPercent = false
        local elapsedDuration = CLIENT_CURRENT_TICK - respawnerUI.mode.tickCounter
        if elapsedDuration >= respawnerUI.flashTerminationDuration then
            flashAnimAlphaPercent = interpolateBetween(respawnerUI.mode.animAlphaPercent, 0, 0, 0, 0, 0, getInterpolationProgress(respawnerUI.mode.tickCounter + respawnerUI.flashTerminationDuration, respawnerUI.flashTerminationDuration/2), "OutBack")
            if math.round(flashAnimAlphaPercent, 2) == 0 then
                imports.setTimer(function()
                    hideRespawnScreen()
                end, 1, 1)
            end
        else
            respawnerUI.mode.animAlphaPercent = interpolateBetween(0.65, 0, 0, 0.98, 0, 0, getInterpolationProgress(respawnerUI.mode.tickCounter, respawnerUI.flashInterval), "CosineCurve")
            flashAnimAlphaPercent = respawnerUI.mode.animAlphaPercent
        end
        dxDrawImage(0, 0, sX, sY, respawnerUI.vignetteTexture, 0, 0, 0, tocolor(respawnerUI.flashColor[1], respawnerUI.flashColor[2], respawnerUI.flashColor[3], respawnerUI.flashColor[4]*flashAnimAlphaPercent), false)
    else
        hideRespawnScreen()
        return false
    end

end


-------------------------------------------------
--[[ Event: On Player Generate Respawn Point ]]--
-------------------------------------------------

addEvent("onPlayerGenerateRespawnPoint", true)
addEventHandler("onPlayerGenerateRespawnPoint", root, function()

    if not isPlayerInitialized(localPlayer) then return false end

    if respawnerUI.state then hideRespawnScreen() end
    outputChatBox("- You were found by a survivor and dragged to safety, Good Luck...", 255, 80, 80)
    respawnerUI.mode = {
        type = "generate_client_spawn",
        tickCounter = CLIENT_CURRENT_TICK,
        wastedPoint = localPlayer:getPosition()
    }
    respawnerUI.state = true
    beautify.render.create(renderRespawnScreen)

end)


----------------------------
--[[ Client: On Respawn ]]--
----------------------------

addEvent("Client:onRespawn", true)
addEventHandler("Client:onRespawn", root, function()
    if not isPlayerInitialized(localPlayer) then return false end

    if respawnerUI.state then hideRespawnScreen() end
    respawnerUI.mode = {
        type = "respawn_client",
        tickCounter = CLIENT_CURRENT_TICK,
        animAlphaPercent = 0
    }
    respawnerUI.state = true
    beautify.render.create(renderRespawnScreen)
end)
