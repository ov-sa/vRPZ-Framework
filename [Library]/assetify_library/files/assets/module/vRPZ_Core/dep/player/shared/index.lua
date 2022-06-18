-----------------
--[[ Imports ]]--
-----------------

local imports = {
    tonumber = tonumber,
    isElement = isElement,
    getElementType = getElementType,
    getPlayerName = getPlayerName
}


----------------
--[[ Module ]]--
----------------

CPlayer = {
    CLogged = {},
    CParty = {},
    CAttachments = {},

    isInitialized = function(player)
        if not player or not imports.isElement(player) or (imports.getElementType(player) ~= "player") then return false end
        return CPlayer.CLogged[player] or false
    end,

    getLogged = function()
        return CPlayer.CLogged
    end,

    getName = function(player)
        if not CPlayer.isInitialized(player) then return false end
        return imports.getPlayerName(player)
    end,

    getCharacterID = function(player)
        if not CPlayer.isInitialized(player) then return false end
        return imports.tonumber(CGame.getEntityData(player, "Character:ID")) or false
    end,

    getParty = function(player)
        --TODO: WRONG CLIENT AND SERVER STORING ORDER DONT MATCH + MAKE ALL PARTY FUNCTIONS SHARED
        if not CPlayer.isInitialized(player) then return false end
        return CPlayer.CParty[player] or false
    end
}