----------------------------------------------------------------
--[[ Resource: Player Handler
     Script: modules: player: client: index.lua
     Author: vStudio
     Developer(s): Mario, Tron, Aviril
     DOC: 31/01/2022
     Desc: Player Module ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local imports = {
    tonumber = tonumber,
    triggerEvent = triggerEvent
}


----------------
--[[ Module ]]--
----------------

CPlayer.CLanguage = FRAMEWORK_CONFIGS["Game"]["Game_Languages"].default
CPlayer.CChannel = nil
CPlayer.CParty = nil

CPlayer.setLanguage = function(language)
    if not language or not FRAMEWORK_CONFIGS["Game"]["Game_Languages"][language] then return false end
    imports.triggerEvent("Client:onUpdateLanguage", localPlayer, language)
    CPlayer.CLanguage = language
    return true 
end

CPlayer.getLanguage = function()
    return CPlayer.CLanguage or FRAMEWORK_CONFIGS["Game"]["Game_Languages"].default
end

CPlayer.setChannel = function(channelIndex)
    channelIndex = imports.tonumber(channelIndex)
    if not CPlayer.isInitialized(localPlayer) or not channelIndex or not FRAMEWORK_CONFIGS["Game"]["Chatbox"]["Chats"][channelIndex] then return false end
    CPlayer.CChannel = channelIndex
    return true 
end

CPlayer.setParty = function(partyData)
    if not CPlayer.isInitialized(localPlayer) then return false end
    CPlayer.CParty = partyData
    return true
end