----------------------------------------------------------------
--[[ Resource: Player Handler
     Script: handlers: channel.lua
     Author: vStudio
     Developer(s): Mario, Tron, Aviril
     DOC: 31/01/2022
     Desc: Channel Handler ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local imports = {
    cancelEvent = cancelEvent,
    addEventHandler = addEventHandler,
    getElementsByType = getElementsByType,
    getElementsWithinRange = getElementsWithinRange,
    getPlayerName = getPlayerName,
    getPlayerNametagColor = getPlayerNametagColor,
    isPlayerMuted = isPlayerMuted,
    outputChatBox = outputChatBox,
    outputServerLog = outputServerLog,
    rgbToHex = rgbToHex
}


-------------------------------
--[[ Event: On Player Chat ]]--
-------------------------------

imports.addEventHandler("onPlayerChat", root, function(message, messageType)
    imports.cancelEvent()
    if not CPlayer.isInitialized(source) or (messageType ~= 0) then return false end
    local channelIndex = CPlayer.getChannel(source)
    if not channelIndex then return false end
    local channelData = FRAMEWORK_CONFIGS["Game"]["Chatbox"]["Chats"][channelIndex]
    if not channelData then return false end
    if imports.isPlayerMuted(source) then
        imports.outputChatBox("- You are muted!", source, 255, 0, 0)
        return false
    end

    local syncPlayers = false
    local playerName, playerTagColor = imports.getPlayerName(source), imports.rgbToHex(imports.getPlayerNametagColor(source))
    if channelIndex == 1 then
        local playerLocation = CCharacter.getLocation(source)
        syncPlayers = imports.getElementsWithinRange(playerLocation.position[1], playerLocation.position[2], playerLocation.position[3], FRAMEWORK_CONFIGS["Game"]["Chatbox"]["Proximity_Range"], "player")
    elseif channelIndex == 2 then
        syncPlayers = imports.getElementsByType("player")
    else
        syncPlayers = imports.getElementsByType("player")
    end
    if syncPlayers then
        for i = 1, #syncPlayers, 1 do
            local j = syncPlayers[i]
            if CPlayer.isInitialized(j) then
                imports.outputChatBox("#FFFFFF["..(channelData.tagColor)..(channelData.name).."#FFFFFF] ˧ "..playerTagColor..playerName..": "..(channelData.messageColor)..message, j, 255, 255, 255, true)
            end
        end
    end
    imports.outputServerLog("["..(channelData.name).."] "..playerName..": "..message)
end)


---------------------------------------------
--[[ Function: Shuffles Player's Channel ]]--
---------------------------------------------

function shufflePlayerChannel(player)
    if not CPlayer.isInitialized(player) then return false end
    local channelIndex = CPlayer.getChannel(player) + 1
    channelIndex = (FRAMEWORK_CONFIGS["Game"]["Chatbox"]["Chats"][channelIndex] and channelIndex) or 1
    if CPlayer.setChannel(player, channelIndex) then
        imports.outputChatBox("━ Channel "..FRAMEWORK_CONFIGS["Game"]["Chatbox"]["Chats"][channelIndex].name, player, 200, 200, 200)
        return true
    end
    return false
end