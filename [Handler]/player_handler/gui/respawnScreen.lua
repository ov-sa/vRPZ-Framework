----------------------------------------------------------------
--[[ Resource: Player Handler
     Script: gui: respawnScreen.lua
     Server: -
     Author: OvileAmriam
     Developer: -
     DOC: 18/11/2020 (OvileAmriam)
     Desc: Respawn Screen UI ]]--
----------------------------------------------------------------


-------------------
--[[ Variables ]]--
-------------------

local respawnScreenCache = {
    state = false,
    mode = false,
    flashInterval = 2000,
    flashTerminationDuration = 10000,
    flashColor = {0, 0, 0, 255},
    vignetteTexture = DxTexture("files/images/hud/vignette.png", "argb", true, "clamp")
}


-------------------------------------------------
--[[ Functions: Hides/Renders Respawn Screen ]]--
-------------------------------------------------

local renderRespawnScreen = nil
local function hideRespawnScreen()

    if not respawnScreenCache.state then return false end

    removeEventHandler("onClientRender", root, renderRespawnScreen)
    respawnScreenCache.mode = false
    respawnScreenCache.state = false
    return true

end

renderRespawnScreen = function()

    if not respawnScreenCache.state or not respawnScreenCache.mode or not isPlayerInitialized(localPlayer) then
        hideRespawnScreen()
        return false
    end

    if respawnScreenCache.mode.type == "generate_client_spawn" then
        local elapsedDuration = getTickCount() - respawnScreenCache.mode.tickCounter
        if elapsedDuration >= (loadingScreenCache.animFadeInDuration + loadingScreenCache.animFadeDelayDuration) then
            local clientPosVector = localPlayer:getPosition()
            local characterSpawn = localPlayer:getData("Character:spawn") 
            if not characterSpawn or not playerSpawnPoints[characterSpawn] then
                characterSpawn = "East"
            end
            for i = 1, 360 do
                local generatedSpawnPoint = {}
                generatedSpawnPoint.x, generatedSpawnPoint.y = getPointFromDistanceRotation(respawnScreenCache.mode.wastedPoint.x, respawnScreenCache.mode.wastedPoint.y, i + 275, i)
                localPlayer:setPosition(generatedSpawnPoint.x, generatedSpawnPoint.y, respawnScreenCache.mode.wastedPoint.z)
                generatedSpawnPoint.z = getGroundPosition(generatedSpawnPoint.x, generatedSpawnPoint.y, respawnScreenCache.mode.wastedPoint.z + 2.5)
                if generatedSpawnPoint.x and generatedSpawnPoint.y and generatedSpawnPoint.z and generatedSpawnPoint.z ~= 0 then
                    triggerServerEvent("onPlayerRespawn", localPlayer, generatedSpawnPoint)
                    hideRespawnScreen()
                    return false
                end
            end
            local availableSpawnPoints = playerSpawnPoints[characterSpawn]
            local generatedSpawnPoint = availableSpawnPoints[math.random(1, #availableSpawnPoints)]
            triggerServerEvent("onPlayerRespawn", localPlayer, generatedSpawnPoint)
            hideRespawnScreen()
            return false
        end
    elseif respawnScreenCache.mode.type == "respawn_client" then
        local flashAnimAlphaPercent = false
        local elapsedDuration = getTickCount() - respawnScreenCache.mode.tickCounter
        if elapsedDuration >= respawnScreenCache.flashTerminationDuration then
            flashAnimAlphaPercent = interpolateBetween(respawnScreenCache.mode.animAlphaPercent, 0, 0, 0, 0, 0, getInterpolationProgress(respawnScreenCache.mode.tickCounter + respawnScreenCache.flashTerminationDuration, respawnScreenCache.flashTerminationDuration/2), "OutBack")
            if math.round(flashAnimAlphaPercent, 2) == 0 then
                Timer(function()
                    hideRespawnScreen()
                end, 1, 1)
            end
        else
            respawnScreenCache.mode.animAlphaPercent = interpolateBetween(0.65, 0, 0, 0.98, 0, 0, getInterpolationProgress(respawnScreenCache.mode.tickCounter, respawnScreenCache.flashInterval), "CosineCurve")
            flashAnimAlphaPercent = respawnScreenCache.mode.animAlphaPercent
        end
        dxDrawImage(0, 0, sX, sY, respawnScreenCache.vignetteTexture, 0, 0, 0, tocolor(respawnScreenCache.flashColor[1], respawnScreenCache.flashColor[2], respawnScreenCache.flashColor[3], respawnScreenCache.flashColor[4]*flashAnimAlphaPercent), false)
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

    if respawnScreenCache.state then hideRespawnScreen() end
    outputChatBox("- You were found by a survivor and dragged to safety, Good Luck...", 255, 80, 80)
    respawnScreenCache.mode = {
        type = "generate_client_spawn",
        tickCounter = getTickCount(),
        wastedPoint = localPlayer:getPosition()
    }
    respawnScreenCache.state = true
    addEventHandler("onClientRender", root, renderRespawnScreen)

end)


----------------------------------
--[[ Event: On Client Respawn ]]--
----------------------------------

addEvent("onClientRespawn", true)
addEventHandler("onClientRespawn", root, function()

    if not isPlayerInitialized(localPlayer) then return false end

    if respawnScreenCache.state then hideRespawnScreen() end
    respawnScreenCache.mode = {
        type = "respawn_client",
        tickCounter = getTickCount(),
        animAlphaPercent = 0
    }
    respawnScreenCache.state = true
    addEventHandler("onClientRender", root, renderRespawnScreen)

end)
