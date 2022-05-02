-----------------
--[[ Imports ]]--
-----------------

local imports = {
    isElement = isElement,
    getElementType = getElementType
}


----------------
--[[ Module ]]--
----------------

CPlayer = {
    CLogged = {},
    CParty = {},
    CChannel = {},
    CAttachments = {},

    isInitialized = function(player)
        if (not player or not imports.isElement(player) or (imports.getElementType(player) ~= "player")) then return false end
        return CPlayer.CLogged[player] or false
    end,

    getLogged = function()
        return CPlayer.CLogged
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