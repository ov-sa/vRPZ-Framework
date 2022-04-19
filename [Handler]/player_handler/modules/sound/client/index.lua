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
    type = type,
    tonumber = tonumber,
    setTimer = setTimer,
    getSoundLength = getSoundLength,
    math = math
}


----------------
--[[ Module ]]--
----------------

CSound = {
    CBuffer = {},
    CAmbience = {}
}

CSound.playAmbience = function(ambienceType, index, skipLoop)
    if not FRAMEWORK_CONFIGS["Templates"]["Ambiences"][ambienceType] then return false end
    local ambienceCategory = false
    if not index or (imports.type(FRAMEWORK_CONFIGS["Templates"]["Ambiences"][ambienceType].category) == "table") then
        CSound.CBuffer[ambienceType] = CSound.CBuffer[ambienceType] or {}
        CSound.CBuffer[ambienceType].categoryIndex = (CSound.CBuffer[ambienceType].categoryIndex or 0) + 1
        CSound.CBuffer[ambienceType].categoryIndex = (FRAMEWORK_CONFIGS["Templates"]["Ambiences"][ambienceType].category[(CSound.CBuffer[ambienceType].categoryIndex)] and CSound.CBuffer[ambienceType].categoryIndex) or 1
        ambienceCategory = FRAMEWORK_CONFIGS["Templates"]["Ambiences"][ambienceType].category[(CSound.CBuffer[ambienceType].categoryIndex)]
        index = imports.math.random(#CSound.CAmbience[ambienceCategory])
    end
    local cSound = CGame.playSound(FRAMEWORK_CONFIGS["Templates"]["Ambiences"][ambienceType].assetName, ambienceCategory, index)
    if not cSound then return false end
    local soundDuration = imports.getSoundLength(cSound) or 0
    if not skipLoop and FRAMEWORK_CONFIGS["Templates"]["Ambiences"][ambienceType].loopInterval then
        imports.setTimer(function()
            CSound.playAmbience(ambienceType)
        end, (soundDuration*1000) + FRAMEWORK_CONFIGS["Templates"]["Ambiences"][ambienceType].loopInterval, 1)
    end
    return true 
end

