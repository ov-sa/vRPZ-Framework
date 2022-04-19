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
    if not FRAMEWORK_CONFIGS["Templates"]["Ambiences"][ambienceType] then return false end
    if not index then
        index = imports.math.random(CATEGORYTABLEHERE)
    end
    local cSound = CGame.playSound(FRAMEWORK_CONFIGS["Templates"]["Ambiences"][ambienceType].assetName, ambienceType, index)
    if not cSound then return false end
    local soundDuration = imports.getSoundLength(cSound) or 0
    if FRAMEWORK_CONFIGS["Templates"]["Ambiences"][ambienceType].loopInterval then
        imports.setTimer(function()
            CSound.playAmbience(ambienceType)
        end, (soundDuration*1000) + FRAMEWORK_CONFIGS["Templates"]["Ambiences"][ambienceType].loopInterval, 1)
    end
    return true 
end

CSound.playAmbience(FRAMEWORK_CONFIGS["Templates"]["Ambiences"]["Short_Ambience"].assetName, _, FRAMEWORK_CONFIGS["Templates"]["Ambiences"]["Short_Ambience"].loopInterval)
