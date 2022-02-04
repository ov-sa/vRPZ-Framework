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
    getElementType = getElementType
}


----------------------
--[[ Player Class ]]--
----------------------

CPlayer = {
    CAttachments = {},

    isInitialized = function(player)
        if (not player or not imports.isElement(player) or (imports.getElementType(player) ~= "player")) then return false end
        return player:getData("Player:Initialized") or false
    end
}