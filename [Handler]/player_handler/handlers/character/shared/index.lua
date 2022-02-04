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
    tonumber = tonumber,
    ipairs = ipairs,
    getElementsByType
}


-------------------------
--[[ Character Class ]]--
-------------------------

CCharacter = {
    getPlayer = function(characterID)
        characterID = imports.tonumber(characterID)
        if not characterID then return false end
        for i, j in imports.ipairs(imports.getElementsByType("player")) do
            if CPlayer.isInitialized(j) then
                local _characterID = j:getData("Character:ID")
                if _characterID == characterID then
                    return j
                end
            end
        end
        return false
    end,

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