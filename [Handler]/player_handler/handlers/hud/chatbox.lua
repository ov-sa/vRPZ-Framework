----------------------------------------------------------------
--[[ Resource: Player Handler
     Script: handlers: hud: chatbox.lua
     Author: vStudio
     Developer(s): Mario, Tron, Aviril
     DOC: 31/01/2022
     Desc: Chatbox HUD Handler ]]--
----------------------------------------------------------------


--TODO: ... WIP..

local imports = {
    pairs = pairs,
    isElement = isElement
}


-------------------
--[[ Variables ]]--
-------------------

local antiSpamCache = {}
local antiSpamMessageLimit = 5
local antiSpamMessageWarnLimit = 3
local antiSpamMuteDuration = 5*60*1000
local antiSpamCoolDownDuration = 5*1000


------------------------------------------------
--[[ Function: Verifies Player's Spam State ]]--
------------------------------------------------

local function isPlayerSpamming(player)

    if not player or not isElement(player) or player:getType() ~= "player" or not exports.player_handler:isPlayerInitialized(player) or player:isMuted() then return false end

    if not antiSpamCache[player] then
        antiSpamCache[player] = {tickCounter = getTickCount(), messageCount = 1, muteTimer = nil}
    else
        if antiSpamCache[player].muteTimer and antiSpamCache[player].muteTimer:isValid() then antiSpamCache[player].muteTimer:destroy() end
        if (getTickCount() - antiSpamCache[player].tickCounter) >= antiSpamCoolDownDuration then
            antiSpamCache[player] = {tickCounter = getTickCount(), messageCount = 1, muteTimer = nil}
        else
            if antiSpamCache[player].messageCount >= antiSpamMessageLimit then
                player:setMuted(true)
                local playerName = player:getName()
                for i, j in ipairs(Element.getAllByType("player")) do
                    if exports.player_handler:isPlayerInitialized(j) then
                        outputChatBox("#FFFFFF- #FF0000"..playerName.."#FFFFFF has beed muted! #FF0000[Reason: Spamming]", j, 255, 255, 255, true)
                        outputServerLog(playerName.." has beed muted! [Reason: Spamming]")
                    end
                end
                antiSpamCache[player].muteTimer = Timer(function(player)
                    if player and isElement(player) then
                        player:setMuted(false)
                        local playerName = player:getName()
                        for i, j in ipairs(Element.getAllByType("player")) do
                            if exports.player_handler:isPlayerInitialized(j) then
                                outputChatBox("#FFFFFF- #FF0000"..playerName.."#FFFFFF has beed unmuted!", j, 255, 255, 255, true)
                                outputServerLog(playerName.." has beed unmuted!")
                            end
                        end
                    end
                end, antiSpamMuteDuration, 1)
                return true
            else
                antiSpamCache[player].messageCount = antiSpamCache[player].messageCount + 1
                if antiSpamCache[player].messageCount == antiSpamMessageWarnLimit then
                    outputChatBox("- Kindly refrain from spamming!", player, 255, 0, 0)
                end
            end
        end
    end
    return false

end


-------------------------------
--[[ Event: On Player Chat ]]--
-------------------------------

addEventHandler("onPlayerChat", root, function(message, messageType)

    cancelEvent()
    if not exports.player_handler:isPlayerInitialized(source) or exports.player_handler:getPlayerHealth(source) <= 0 or exports.player_handler:isPlayerKnocked(source) then return false end
    if messageType ~= 0 then return false end
    if not isValidMessage(message) then return false end
    isPlayerSpamming(source)
    if source:isMuted() then
        outputChatBox("- You are muted!", source, 255, 0, 0)
        return false
    end

    message = removeWhiteSpace(message)
    local chatType = "Local"
    local playerName = source:getName()
    local r, g, b = source:getNametagColor()
    for i, j in ipairs(getPlayersWithinRange(source, serverLocalChatRange)) do
        outputChatBox("#FFFFFF[#00FF00"..chatType.."#FFFFFF] ˧ "..RGBToHex(r, g, b)..playerName..": "..RGBToHex(149, 255, 149)..message, j, 255, 255, 255, true)
    end
    outputServerLog("["..chatType.."] "..playerName..": "..message)

end)


------------------------------
--[[ Command: Global Cbat ]]--
------------------------------

addCommandHandler(globalChatCMD, function(player, cmd, ...)

    if not exports.player_handler:isPlayerInitialized(player) or exports.player_handler:getPlayerHealth(player) <= 0 or exports.player_handler:isPlayerKnocked(player) then return false end
	if not ... then return false end
    local message = table.concat({...}, " ")
    if not isValidMessage(message) then return false end
    isPlayerSpamming(player)
    if player:isMuted() then
        outputChatBox("- You are muted!", player, 255, 0, 0)
        return false
    end

    message = removeWhiteSpace(message)
    local chatType = "Global"
    local playerName = player:getName()
	local r, g, b = player:getNametagColor()
    for i, j in ipairs(Element.getAllByType("player")) do
        if exports.player_handler:isPlayerInitialized(j) then
            outputChatBox("#FFFFFF[#FFC800"..chatType.."#FFFFFF] ˧ "..RGBToHex(r, g, b)..playerName..": "..RGBToHex(255, 149, 79)..message, j, 255, 255, 255, true)
        end
    end
    outputServerLog("["..chatType.."] "..playerName..": "..message)

end, false, false)


-----------------------------
--[[ Command: Group Cbat ]]--
-----------------------------

addCommandHandler(groupChatCMD, function(player, cmd, ...)

    if not exports.player_handler:isPlayerInitialized(player) or exports.player_handler:getPlayerHealth(player) <= 0 or exports.player_handler:isPlayerKnocked(player) then return false end
	if not ... then return false end
    local message = table.concat({...}, " ")
    if not isValidMessage(message) then return false end
    isPlayerSpamming(player)
    if player:isMuted() then
        outputChatBox("- You are muted!", player, 255, 0, 0)
        return false
    end
    local playerGroupData = getPlayerGroupData(player)
    if not playerGroupData or not createdGroups[playerGroupData.group] then
        outputChatBox("- You don't belong to any group!", player, 255, 0, 0)
        return false
    end

    message = removeWhiteSpace(message)
    local chatType = "Group"
    local playerName = player:getName()
	local r, g, b = player:getNametagColor()
    for i, j in pairs(createdGroups[playerGroupData.group].members) do
        if j.player and isElement(j.player) and j.player:getType() == "player" then
            outputChatBox("#FFFFFF[#FF7F27"..chatType.."#FFFFFF] ˧ "..RGBToHex(r, g, b)..playerName..": "..RGBToHex(255, 149, 79)..message, j.player, 255, 255, 255, true)
        end
    end
    outputServerLog("["..chatType.."] "..playerName..": "..message)

end, false, false)