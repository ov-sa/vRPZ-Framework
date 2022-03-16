----------------------------------------------------------------
--[[ Resource: Player Handler
     Script: handlers: hud: chatbox.lua
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
    getPlayersWithinRange = getElementsWithinRange,
    getPlayerName = getPlayerName,
    getPlayerNametagColor = getPlayerNametagColor,
    isPlayerMuted = isPlayerMuted,
    outputChatBox = outputChatBox,
    outputServerLog = outputServerLog
}


-------------------
--[[ Utilities ]]--
-------------------

imports.addEventHandler("onPlayerChat", root, function(message, messageType)
    imports.cancelEvent()
    if not CPlayer.isInitialized(source) or not isValidMessage(message) or (messageType ~= 0) then return false end
    local channelIndex = CPlayer.getChannel(source)
    if not channelIndex then return false end
    local channelData = FRAMEWORK_CONFIGS["Game"]["Chatbox"]["Chats"][channelIndex]
    if not channelData then return false end
    if imports.isPlayerMuted(source) then
        imports.outputChatBox("- You are muted!", source, 255, 0, 0)
        return false
    end

    local playerName = imports.getPlayerName(source)
	local playerTagColor = RGBToHex(imports.getPlayerNametagColor(source))
    local playerList = false
    if channelIndex == 1 then
        playerList = imports.getElementsByType("player")
    elseif channelIndex == 2 then
        local playerLocation = CCharacter.getLocation(source)
        playerList = imports.getElementsWithinRange(playerLocation.position[1], playerLocation.position[2], playerLocation.position[3], "player", FRAMEWORK_CONFIGS["Game"]["Chatbox"]["Proximity_Range"])
    end
    if playerList then
        for i = 1, #playerList, 1 do
            local j = playerList[i]
            if CPlayer.isInitialized(j) then
                imports.outputChatBox("#FFFFFF["..(channelData.tagColor)..(channelData.name).."#FFFFFF] ˧ "..playerTagColor..playerName..": "..(channelData.messageColor)..message, j, 255, 255, 255, true)
            end
        end
    end
    imports.outputServerLog("["..(channelData.name).."] "..playerName..": "..message)
end)

imports.bindKey(FRAMEWORK_CONFIGS["Game"]["Chatbox"]["Channel_ShuffleKey"], "down", function(player)
    if CPlayer.isInitialized(player) then return false end
    CPlayer.setChannel(source, FRAMEWORK_CONFIGS["Game"]["Chatbox"]["Chats"][(CPlayer.getChannel(source) + 1)] or 1)
end)