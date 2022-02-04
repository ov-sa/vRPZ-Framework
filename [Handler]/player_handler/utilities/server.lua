----------------------------------------------------------------
--[[ Resource: Player Handler
     Script: utilities: server.lua
     Author: vStudio
     Developer(s): Mario, Tron
     DOC: 31/01/2022
     Desc: Server Sided Utilities ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

loadstring(exports.dbify_library:fetchImports())()
local imports = {
    type = type,
    ipairs = ipairs,
    isElement = isElement,
    createElement = createElement,
    getElementType = getElementType,
    getElementsByType = getElementsByType,
    getElementPosition = getElementPosition,
    getTickCount = getTickCount,
    addEventHandler = addEventHandler,
    triggerEvent = triggerEvent,
    triggerClientEvent = triggerClientEvent,
    getPlayerSerial = getPlayerSerial,
    setTimer = setTimer,
    setPlayerBlurLevel = setPlayerBlurLevel,
    outputChatBox = outputChatBox,
    setFPSLimit = setFPSLimit,
    setFarClipDistance = setFarClipDistance,
    setFogDistance = setFogDistance,
    setAircraftMaxHeight = setAircraftMaxHeight,
    setJetpackMaxHeight = setJetpackMaxHeight,
    setMinuteDuration = setMinuteDuration,
    setGameType = setGameType,
    setMapName = setMapName,
    getPlayerFromName = getPlayerFromName,
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


------------------------------------------------
--[[ Function: Retrieves Player From Serial ]]--
------------------------------------------------

function getPlayerFromSerial(serial)
    if (not serial or (imports.type(serial) ~= "string")) then return false end
    for i, j in imports.ipairs(imports.getElementsByType("player")) do
        if imports.getPlayerSerial(j) == serial then
            return j
        end
    end
    return false
end


---------------------------------------------
--[[ Function: Retrieves Void Guest Nick ]]--
---------------------------------------------

function getVoidGuestNick()
    local voidNick = nil
    repeat
        voidNick = "Guest_"..imports.math.random(1, 10000)
    until(imports.getPlayerFromName(voidNick))
    return voidNick
end


---------------------------------------
--[[ Event: On Resource Start/Stop ]]--
---------------------------------------

imports.addEventHandler("onResourceStart", resource, function()
    imports.setTimer(function(tickSyncer)
        if tickSyncer and imports.isElement(tickSyncer) then
            tickSyncer:setData("Server:TickSyncer", imports.getTickCount())
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
    for i, j in imports.ipairs(imports.getElementsByType("player")) do
        if isPlayerInitialized(j) then
            imports.setPlayerBlurLevel(0)
        end
    end

    imports.addEventHandler("onPlayerCommand", root, function(command)
        for i, j in imports.ipairs(FRAMEWORK_CONFIGS.Game["Disabled_CMDS"]) do
            if j == command then
                cancelEvent()
                if command == "logout" then
                    if isPlayerInitialized(source) then
                        local isPlayerOnLogoutCoolDown = false
                        local playerLoginTick = getPlayerLoginTick(source)
                        if playerLoginTick then
                            local elapsedDuration = imports.getTickCount() - playerLoginTick
                            if elapsedDuration < serverLogoutCoolDownDuration then
                                isPlayerOnLogoutCoolDown = serverLogoutCoolDownDuration - elapsedDuration
                            end
                        end
                        if isPlayerOnLogoutCoolDown then
                            imports.triggerClientEvent(source, "Client:onNotification", source, "Please wait "..math.ceil(isPlayerOnLogoutCoolDown/1000).."s before logging out!", {255, 35, 35, 255})
                        else
                            local posVector = imports.getElementPosition(source)
                            local characterID = source:getData("Character:ID")
                            local characterIdentity = getCharacterData(characterID, "identity")
                            savePlayerProgress(source)
                            imports.triggerEvent("Player:onRequestShowLoginScreen", source)
                            imports.outputChatBox("#FFFFFF- #5050FF"..characterIdentity.name.."#FFFFFF left. #5050FF[Reason: Logout]", root, 255, 255, 255, true)    
                        end
                    end
                end
                break
            end
        end
    end)
end)

imports.addEventHandler("onResourceStop", resource, function()
    for i, j in imports.ipairs(imports.getElementsByType("player")) do
        savePlayerProgress(j)
    end
end)