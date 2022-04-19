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

CSound.playAmbience = function(ambienceType, index)
    if not configVars["Templates"]["Ambiences"][ambienceType] then return false end
    if not index then
        index = imports.math.random(CATEGORYTABLEHERE)
    end
    local cSound = CGame.playSound(configVars["Templates"]["Ambiences"][ambienceType].assetName, ambienceType, index)
    if not cSound then return false end
    local soundDuration = imports.getSoundLength(cSound) or 0
    if configVars["Templates"]["Ambiences"][ambienceType].loopInterval then
        imports.setTimer(function()
            CSound.playAmbience(ambienceType, _, configVars["Templates"]["Ambiences"][ambienceType].loopInterval)
        end, (soundDuration*1000) + configVars["Templates"]["Ambiences"][ambienceType].loopInterval, 1)
    end
    return true 
end

CSound.playAmbience(configVars["Templates"]["Ambiences"]["Short_Ambience"].assetName, _, configVars["Templates"]["Ambiences"]["Short_Ambience"].loopInterval)
