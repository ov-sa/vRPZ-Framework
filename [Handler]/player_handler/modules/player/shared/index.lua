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
    CParty = {},
    CChannel = {},
    CAttachments = {},

    isInitialized = function(player)
        if (not player or not imports.isElement(player) or (imports.getElementType(player) ~= "player")) then return false end
        return imports.getElementData(player, "Player:Initialized") or false
    end,

    getChannel = function(player)
        if not CPlayer.isInitialized(player) then return false end
        return CPlayer.CChannel[player] or false
    end,

    getParty = function(player)
        if not CPlayer.isInitialized(player) then return false end
        return CPlayer.CParty[player] or false
    end
}