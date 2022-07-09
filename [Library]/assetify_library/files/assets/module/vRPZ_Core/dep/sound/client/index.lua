-----------------
--[[ Imports ]]--
-----------------

local imports = {
    type = type,
    tonumber = tonumber,
    getSoundLength = getSoundLength,
    math = math,
    assetify = assetify
}


----------------
--[[ Module ]]--
----------------

CSound = {
    CBuffer = {},
    CAmbience = {}
}

CSound.playAmbience = function(ambienceType, ambienceIndex, skipLoop)
    if not FRAMEWORK_CONFIGS["Templates"]["Ambiences"][ambienceType] then return false end
    CSound.CBuffer[ambienceType] = CSound.CBuffer[ambienceType] or {}
    local ambienceCategory = false
    if imports.type(FRAMEWORK_CONFIGS["Templates"]["Ambiences"][ambienceType].category) == "table" then
        CSound.CBuffer[ambienceType].categoryIndex = (CSound.CBuffer[ambienceType].categoryIndex or 0) + 1
        CSound.CBuffer[ambienceType].categoryIndex = (FRAMEWORK_CONFIGS["Templates"]["Ambiences"][ambienceType].category[(CSound.CBuffer[ambienceType].categoryIndex)] and CSound.CBuffer[ambienceType].categoryIndex) or 1
        ambienceCategory = FRAMEWORK_CONFIGS["Templates"]["Ambiences"][ambienceType].category[(CSound.CBuffer[ambienceType].categoryIndex)]
    else
        ambienceCategory = FRAMEWORK_CONFIGS["Templates"]["Ambiences"][ambienceType].category
    end
    ambienceIndex = ambienceIndex or imports.math:random(#CSound.CAmbience[ambienceCategory])
    CSound.CBuffer[ambienceType].soundInstance = CGame.playSound(FRAMEWORK_CONFIGS["Templates"]["Ambiences"][ambienceType].assetName, ambienceCategory, ambienceIndex, FRAMEWORK_CONFIGS["Templates"]["Ambiences"][ambienceType].volume, true)
    if not CSound.CBuffer[ambienceType].soundInstance then return false end
    local soundDuration = imports.getSoundLength(CSound.CBuffer[ambienceType].soundInstance) or 0
    if not skipLoop and FRAMEWORK_CONFIGS["Templates"]["Ambiences"][ambienceType].loopInterval and not CSound.CBuffer[ambienceType].intervalTimer then
        CSound.CBuffer[ambienceType].intervalTimer = imports.assetify.timer:create(function(ambienceType)
            CSound.CBuffer[ambienceType].soundInstance = nil
            CSound.CBuffer[ambienceType].intervalTimer = nil
            CSound.playAmbience(ambienceType)
        end, (soundDuration*1000) + FRAMEWORK_CONFIGS["Templates"]["Ambiences"][ambienceType].loopInterval, 1, ambienceType)
    end
    return true 
end

