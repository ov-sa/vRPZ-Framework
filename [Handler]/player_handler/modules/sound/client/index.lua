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
    tonumber = tonumber,
    setTimer = setTimer,
    getSoundLength = getSoundLength,
    math = math
}


----------------
--[[ Module ]]--
----------------

CSound = {
    CBuffer = {}
}

CSound.playAmbience = function(category, index, interval)
    interval = imports.tonumber(interval)
    if not category then return false end
    if not index then
        index = imports.math.random(CATEGORYTABLEHERE)
    end
    local cSound = CGame.playSound(category, index)
    if not cSound then return false end
    local soundDuration = imports.getSoundLength(cSound) or 0
    if interval then
        imports.setTimer(function()
            CSound.playAmbience(category, _, interval)
        end, (soundDuration*1000) + interval, 1)
    end
    return true 
end

CSound.playAmbience("short", _, 30000)
