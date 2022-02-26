----------------------------------------------------------------
--[[ Resource: Player Handler
     Script: utilities: server.lua
     Author: vStudio
     Developer(s): Mario, Tron, Aviril
     DOC: 31/01/2022
     Desc: Server Sided Utilities ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

loadstring(exports.dbify_library:fetchImports())()
local imports = {
    type = type,
    isElement = isElement,
    createElement = createElement,
    getElementType = getElementType,
    getElementsByType = getElementsByType,
    getTickCount = getTickCount,
    addEventHandler = addEventHandler,
    cancelEvent = cancelEvent,
    triggerEvent = triggerEvent,
    triggerClientEvent = triggerClientEvent,
    getElementPosition = getElementPosition,
    getPlayerSerial = getPlayerSerial,
    getPlayerName = getPlayerName,
    setElementData = setElementData,
    setTimer = setTimer,
    outputChatBox = outputChatBox,
    setFPSLimit = setFPSLimit,
    setFarClipDistance = setFarClipDistance,
    setFogDistance = setFogDistance,
    setAircraftMaxHeight = setAircraftMaxHeight,
    setJetpackMaxHeight = setJetpackMaxHeight,
    setMinuteDuration = setMinuteDuration,
    setGameType = setGameType,
    setMapName = setMapName,
    math = math
}


---------------------------------------
--[[ Function: Overrides Show Chat ]]--
---------------------------------------

function showChat(player, bool, isForced)
    if (not player or not imports.isElement(player) or (imports.getElementType(player) ~= "player")) then return false end
    imports.triggerClientEvent(player, "Player:onToggleChat", player, bool, isForced)
    return true
end


---------------------------------------
--[[ Event: On Resource Start/Stop ]]--
---------------------------------------

imports.addEventHandler("onResourceStart", resource, function()
    imports.setTimer(function(tickSyncer)
        if tickSyncer and imports.isElement(tickSyncer) then
            imports.setElementData(tickSyncer, "Server:TickSyncer", imports.getTickCount())
        end
    end, FRAMEWORK_CONFIGS.Game["Sync_Rate"], 0, imports.createElement("Server:TickSyncer"))
    --[[
    for i, j in pairs(availableWeaponSlots) do
        for k, v in pairs(j.slots) do
            if v.properties then
                for m, n in pairs(v.properties) do
                    setWeaponProperty(k, "poor", m, n)
                    setWeaponProperty(k, "std", m, n)
                    setWeaponProperty(k, "pro", m, n)
                end
            end  
        end
        for k, v in imports.ipairs(inventoryDatas[i]) do
            if v.magSize then
                setWeaponProperty(v.weaponID, "poor", "maximum_clip_ammo", 1000)
                setWeaponProperty(v.weaponID, "std", "maximum_clip_ammo", 1000)
                setWeaponProperty(v.weaponID, "pro", "maximum_clip_ammo", 1000)
            end
        end
    end
    ]]--
    imports.setFPSLimit(FRAMEWORK_CONFIGS.Game["FPS_Limit"])
    imports.setFarClipDistance(FRAMEWORK_CONFIGS.Game["Draw_Distance_Limit"][2])
    imports.setFogDistance(FRAMEWORK_CONFIGS.Game["Fog_Distance_Limit"][2])
    imports.setAircraftMaxHeight(FRAMEWORK_CONFIGS.Game["Aircraft_Max_Height"])
    imports.setJetpackMaxHeight(FRAMEWORK_CONFIGS.Game["Jetpack_Max_Height"])
    imports.setMinuteDuration(FRAMEWORK_CONFIGS.Game["Minute_Duration"])
    imports.setGameType(FRAMEWORK_CONFIGS.Game["Game_imports.type"])
    imports.setMapName(FRAMEWORK_CONFIGS.Game["Game_Map"])

    imports.addEventHandler("onPlayerCommand", root, function(command)
        local disabledCMDs = FRAMEWORK_CONFIGS.Game["Disabled_CMDS"]
        for i = 1, #disabledCMDs, 1 do
            local j = FRAMEWORK_CONFIGS.Game["Disabled_CMDS"][i]
            if j == command then
                imports.cancelEvent()
                if command == "logout" then
                    if CPlayer.isInitialized(source) then
                        local cooldownETA, prevResumeTick = false, getResumeTick(source)
                        if prevResumeTick then
                            local elapsedDuration = imports.getTickCount() - prevResumeTick
                            cooldownETA = ((elapsedDuration < FRAMEWORK_CONFIGS["Game"]["Logout_CoolDown_Duration"]) and (FRAMEWORK_CONFIGS["Game"]["Logout_CoolDown_Duration"] - elapsedDuration)) or false
                        end
                        if cooldownETA then
                            imports.triggerClientEvent(source, "Client:onNotification", source, "Please wait "..imports.math.ceil(cooldownETA/1000).."s before logging out!", FRAMEWORK_CONFIGS["UI"]["Notification"].presets.error)
                        else
                            CCharacter.saveProgress(source)
                            imports.triggerClientEvent(source, "Client:onToggleLoadingUI", source, true)
                            imports.triggerEvent("Player:onToggleLoginUI", source)
                            imports.outputChatBox("#FFFFFF- #5050FF"..imports.getPlayerName(source).."#FFFFFF left. #5050FF[Reason: Logout]", root, 255, 255, 255, true)    
                        end
                    end
                end
                break
            end
        end
    end)
end)

imports.addEventHandler("onResourceStop", resource, function()
    local serverPlayers = imports.getElementsByType("player")
    for i = 1, #serverPlayers, 1 do
        local j = serverPlayers[i]
        CCharacter.saveProgress(j)
    end
end)