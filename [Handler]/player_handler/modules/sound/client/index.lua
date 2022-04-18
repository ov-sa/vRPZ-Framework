----------------------------------------------------------------
--[[ Resource: Player Handler
     Script: modules: sound: client: index.lua
     Author: vStudio
     Developer(s): Mario, Tron, Aviril, Аниса
     DOC: 31/01/2022
     Desc: Sound Module ]]--
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

CSound = {
    CBuffer = {}
}

CSound.playAmbience = function(category, index, cooldown)
    cooldown = imports.tonumber(cooldown) or 0
    if not category or not index or not cooldown then return false end
    --[[
    if not language or not FRAMEWORK_CONFIGS["Game"]["Game_Languages"][language] or (CPlayer.CLanguage == language) then return false end
    imports.triggerEvent("Client:onUpdateLanguage", localPlayer, CPlayer.CLanguage, language)
    CPlayer.CLanguage = language
    ]]
    return true 
end