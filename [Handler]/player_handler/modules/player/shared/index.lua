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
    getPlayerFromName = getPlayerFromName,
    math = math
}


----------------
--[[ Module ]]--
----------------

CPlayer = {
    CAttachments = {},

    isInitialized = function(player)
        if (not player or not imports.isElement(player) or (imports.getElementType(player) ~= "player")) then return false end
        return player:getData("Player:Initialized") or false
    end,

    generateNick = function()
        local guestNick = nil
        repeat
            guestNick = "Guest_"..imports.math.random(1, 10000)
        until(imports.getPlayerFromName(guestNick))
        return guestNick
    end
}