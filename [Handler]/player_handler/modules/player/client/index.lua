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
    tonumber = tonumber
}


----------------
--[[ Module ]]--
----------------

CPlayer = {
    setChannel = function(player, channelIndex)
        channelIndex = imports.tonumber(channelIndex)
        if not CPlayer.isInitialized(player) or not channelIndex or not FRAMEWORK_CONFIGS["Game"]["Chatbox"]["Chats"][channelIndex] then return false end
        CPlayer.CChannel[player] = channelIndex
        return true 
    end
}