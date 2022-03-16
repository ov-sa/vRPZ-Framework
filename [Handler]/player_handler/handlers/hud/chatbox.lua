----------------------------------------------------------------
--[[ Resource: Player Handler
     Script: handlers: hud: chatbox.lua
     Author: vStudio
     Developer(s): Mario, Tron, Aviril
     DOC: 31/01/2022
     Desc: Chatbox HUD Handler ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local imports = {
    cancelEvent = cancelEvent,
    addEventHandler = addEventHandler,
    getElementsByType = getElementsByType,
    getPlayerName = getPlayerName,
    getPlayerNametagColor = getPlayerNametagColor,
    isPlayerMuted = isPlayerMuted,
    outputChatBox = outputChatBox,
    outputServerLog = outputServerLog
}


-------------------
--[[ Variables ]]--
-------------------

imports.addEventHandler("onPlayerChat", root, function(message, messageType)
    imports.cancelEvent()
    if not CPlayer.isInitialized(source) or not isValidMessage(message) or (messageType ~= 0) then return false end
    if not isPlayerAllowedToChat(source) return false end
    if imports.isPlayerMuted(source) then
        imports.outputChatBox("- You are muted!", source, 255, 0, 0)
        return false
    end

    local channel = CPlayer.CChannel[source]
    local channelColor = "#FFC800"
    local playerName = imports.getPlayerName(source)
	local r, g, b = imports.getPlayerNametagColor(source)
    if channel == 1 then
        local playerList = imports.getElementsByType("player")
        for i = 1, #playerList, 1 do
            local j = playerList[i]
            if CPlayer.isInitialized(j) then
                imports.outputChatBox("#FFFFFF["..channelColor..channel.."#FFFFFF] ˧ "..RGBToHex(r, g, b)..playerName..": "..RGBToHex(255, 149, 79)..message, j, 255, 255, 255, true)
            end
        end
    elseif channel == 2 then
        local playerList = imports.getPlayersWithinRange(source, FRAMEWORK_CONFIGS["Game"]["Chatbox"]["Proximity_Range"])
        for i = 1, #playerList, 1 do
            local j = playerList[i]
            if CPlayer.isInitialized(j) then
                imports.outputChatBox("#FFFFFF["..channelColor..chatType.."#FFFFFF] ˧ "..RGBToHex(r, g, b)..playerName..": "..RGBToHex(149, 255, 149)..message, j, 255, 255, 255, true)
            end
        end
    end
    imports.outputServerLog("["..channel.."] "..playerName..": "..message)
end)

imports.bindKey(FRAMEWORK_CONFIGS["Game"]["Chatbox"]["Channel_ShuffleKey"], "down", function(player)
    if CPlayer.isInitialized(player) then return false end
    CPlayer.CChannel[source] = (CPlayer.CChannel[source] or (FRAMEWORK_CONFIGS["Game"]["Chatbox"]["Default_Channel"] - 1)) + 1
    CPlayer.CChannel[source] = (FRAMEWORK_CONFIGS["Game"]["Chatbox"]["Chats"][(CPlayer.CChannel[source])] and CPlayer.CChannel[source]) or 1
end)