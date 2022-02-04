----------------------------------------------------------------
--[[ Resource: Player Handler
     Script: handlers: player: shared: index.lua
     Author: vStudio
     Developer(s): Mario, Tron
     DOC: 31/01/2022
     Desc: Player Handler ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local imports = {
    isElement = isElement,
    getElementPosition = getElementPosition,
    getElementRotation = getElementRotation
}


----------------------
--[[ Player Class ]]--
----------------------

CPlayer = {
    isInitialized = isPlayerInitialized,

    getLocation = function(player)
        if not CPlayer.isInitialized(player) then return false end
        return {
            position = {imports.getElementPosition(player)},
            rotation = {imports.getElementRotation(player)}
        }
    end
}