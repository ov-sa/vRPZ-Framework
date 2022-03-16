----------------------------------------------------------------
--[[ Resource: Player Handler
     Script: modules: player: shared: index.lua
     Author: vStudio
     Developer(s): Mario, Tron, Aviril
     DOC: 31/01/2022
     Desc: Player Module ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local imports = {
    isElement = isElement,
    getElementType = getElementType,
    getElementData = getElementData
}


----------------
--[[ Module ]]--
----------------

CPlayer = {
    CChannel = {},
    CAttachments = {},

    isInitialized = function(player)
        if (not player or not imports.isElement(player) or (imports.getElementType(player) ~= "player")) then return false end
        return imports.getElementData(player, "Player:Initialized") or false
    end,

    setChannel = function(player, channelIndex)
        channelIndex = imports.tonumber(channelIndex)
        if not CPlayer.isInitialized(player) or not channelIndex or not FRAMEWORK_CONFIGS["Game"]["Chatbox"]["Chats"][channelIndex] then return false end
        CPlayer.CChannel[player] = channelIndex
        return true 
    end,

    getChannel = function(player)
        if not CPlayer.isInitialized(player) then return false end
        return CPlayer.CChannel[player] or false
    end
}