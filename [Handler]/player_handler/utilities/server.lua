----------------------------------------------------------------
--[[ Resource: Player Handler
     Script: utilities: server.lua
     Author: vStudio
     Developer(s): Tron
     DOC: 31/01/2022
     Desc: Server Sided Utilities ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local imports = {
    triggerEvent = triggerEvent,
    triggerClientEvent = triggerClientEvent
}


---------------------------------------
--[[ Function: Overrides Show Chat ]]--
---------------------------------------

function showChat(player, bool, isForced)

    if not player or not isElement(player) or player:getType() ~= "player" then return false end

    imports.triggerClientEvent(player, "Player-Handler:onToggleChat", player, bool, isForced)
    return true

end


------------------------------------------------
--[[ Function: Retrieves Player From Serial ]]--
------------------------------------------------

function getPlayerFromSerial(serial)

    if not serial or type(serial) ~= "string" then return false end

    for i, j in ipairs(Element.getAllByType("player")) do
        if j:getSerial() == serial then
            return j
        end
    end
    return false

end


---------------------------------------------
--[[ Function: Retrieves Void Guest Nick ]]--
---------------------------------------------

function getVoidGuestNick()

    local voidNick = "Guest_"..math.random(1, 10000)
    while Player(voidNick) do
        voidNick = "Guest_"..math.random(1, 10000)
    end
    return voidNick

end


----------------------------------
--[[ Event: On Resource Start ]]--
----------------------------------

addEventHandler("onResourceStart", resource, function()

    local serverTickSyncer = Element("Server:TickSyncer")
    Timer(function(serverTickSyncer)
        if serverTickSyncer and isElement(serverTickSyncer) then
            serverTickSyncer:setData("Server:TickSyncer", 0) --TODO: ...
        end
    end, 50, 0, serverTickSyncer)

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
        for k, v in ipairs(inventoryDatas[i]) do
            if v.magSize then
                setWeaponProperty(v.weaponID, "poor", "maximum_clip_ammo", 1000)
                setWeaponProperty(v.weaponID, "std", "maximum_clip_ammo", 1000)
                setWeaponProperty(v.weaponID, "pro", "maximum_clip_ammo", 1000)
            end
        end
    end
    ]]--

    setFPSLimit(serverFPSLimit)
    setFarClipDistance(serverDrawDistanceLimit)
    setFogDistance(serverFogDistanceLimit)
    setGameType(serverGameType)
    setMapName(serverMapName)
    setAircraftMaxHeight(serverAircraftMaxHeight)
    setJetpackMaxHeight(serverJetpackMaxHeight)
    setMinuteDuration(serverMinuteDuration)
    for i, j in ipairs(Element.getAllByType("player")) do
        if isPlayerInitialized(j) then
            j:setBlurLevel(0)
        end
    end

end)


----------------------------------
--[[ Event: On Player Command ]]--
----------------------------------

addEventHandler("onPlayerCommand", root, function(cmd)

    for i, j in ipairs(serverDisabledCMDs) do
        if j == cmd then
            cancelEvent()
            if cmd == "logout" then
                if isPlayerInitialized(source) then
                    local isPlayerOnLogoutCoolDown = false
                    local playerLoginTick = getPlayerLoginTick(source)
                    if playerLoginTick then
                        --TODO: ...
                        --local elapsedDuration = imports.getTickCount() - playerLoginTick
                        if elapsedDuration < serverLogoutCoolDownDuration then
                            isPlayerOnLogoutCoolDown = serverLogoutCoolDownDuration - elapsedDuration
                        end
                    end
                    if isPlayerOnLogoutCoolDown then
                        imports.triggerClientEvent(source, "Player-Handler:onDisplayNotification", source, "Please wait "..math.ceil(isPlayerOnLogoutCoolDown/1000).."s before logging out!", {255, 35, 35, 255})
                    else
                        local posVector = source:getPosition()
                        local characterID = source:getData("Character:ID")
                        local characterIdentity = getCharacterData(characterID, "identity")
                        savePlayerProgress(source)
                        imports.triggerEvent("Player-Handler:onRequestShowLoginScreen", source)
                        outputChatBox("#FFFFFF- #5050FF"..characterIdentity.name.."#FFFFFF left. #5050FF[Reason: Logout]", root, 255, 255, 255, true)    
                    end
                end
            end
            break
        end
    end

end)