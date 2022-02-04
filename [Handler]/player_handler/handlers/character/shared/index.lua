----------------------------------------------------------------
--[[ Resource: Player Handler
     Script: handlers: character: shared: index.lua
     Author: vStudio
     Developer(s): Mario, Tron
     DOC: 31/01/2022
     Desc: Character Handler ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local imports = {
    tonumber = tonumber
}


-------------------------
--[[ Character Class ]]--
-------------------------

CCharacter = {
    getHealth = function(player)
        if not CPlayer.isInitialized(player) then return false end
        return imports.tonumber(player:getData("Character:blood")) or 0
    end,

    getMaxHealth = function(player)
        if not CPlayer.isInitialized(player) then return false end
        return characterMaximumBlood --TODO: ..CAHNGE
    end,

    getFaction = function(player)
        if not CPlayer.isInitialized(player) then return false end
        return player:getData("Character:Faction") or false
    end,

    isKnocked = function(player)
        if not CPlayer.isInitialized(player) then return false end
        return player:getData("Character:Knocked") or false
    end,

    isReloading = function(player)
        if not CPlayer.isInitialized(player) then return false end
        return player:getData("Character:Reloading") or false
    end
}