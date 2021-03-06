-----------------
--[[ Imports ]]--
-----------------

local imports = {
    tonumber = tonumber,
    isElement = isElement,
    getElementType = getElementType,
    getPlayerName = getPlayerName,
    setPedWalkingStyle = setPedWalkingStyle,
    getPedWalkingStyle = getPedWalkingStyle
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

    setWalkingStyle = function(player, style)
        if not CPlayer.isInitialized(player) or not style then return false end
        return imports.setPedWalkingStyle(player, style)
    end,

    getWalkingStyle = function(player)
        if not CPlayer.isInitialized(player) then return false end
        return imports.getPedWalkingStyle(player)
    end,

    setRole = function(player, role)
        if not CPlayer.isInitialized(player) or not CGame.getRole(role) then return false end
        return CGame.setEntityData(player, "Player:role", role)
    end,

    getRole = function(player)
        if not CPlayer.isInitialized(player) then return false end
        local playerRole = CGame.getEntityData(player, "Player:role")
        return (playerRole and CGame.getRole(playerRole) and playerRole) or FRAMEWORK_CONFIGS["Templates"]["Roles"].default
    end,

    setVIPDuration = function(player, duration)
        duration = imports.tonumber(duration) or 0
        if not CPlayer.isInitialized(player) or (duration <= 0) then return false end
        return CGame.setEntityData(player, "Player:vip", duration)
    end,

    getVIPDuration = function(player)
        if not CPlayer.isInitialized(player) then return false end
        return imports.tonumber(CGame.getEntityData(player, "Player:vip")) or false
    end,

    getParty = function(player)
        --TODO: WRONG CLIENT AND SERVER STORING ORDER DONT MATCH + MAKE ALL PARTY FUNCTIONS SHARED
        if not CPlayer.isInitialized(player) then return false end
        return CPlayer.CParty[player] or false
    end
}