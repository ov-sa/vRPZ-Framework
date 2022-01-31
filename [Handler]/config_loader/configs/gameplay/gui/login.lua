----------------------------------------------------------------
--[[ Resource: Config Loader
     Script: configs: gameplay: gui: login.lua
     Author: vStudio
     Developer(s): Tron
     DOC: 25/01/2022
     Desc: Login UI Configns ]]--
----------------------------------------------------------------


------------------
--[[ Configns ]]--
------------------

configVars["UI"]["Login"] = {

    weather = 7,
    time = {1, 0},
    dimension = 100,
    clientPoint = {x = 0, y = 0, z = 0},
    cinemationPoints = {
        {
            cinemationFOV = 85,
            characterPoint = {x = -189.73196, y = 284.94327, z = 12.07813, rotation = 140},
            cinemationPoint = {
                cameraStart = {x = -189.7790069580078, y = 282.8688049316406, z = 11.50769996643066},
                cameraStartLook = {x = -189.8280944824219, y = 283.7382507324219, z = 11.99930191040039},
                cameraEnd = {x = -190.1195068359375, y = 282.7926025390625, z = 11.54810047149658},
                cameraEndLook = {x = -189.8391723632813, y = 283.6601867675781, z = 11.95884799957275},
                cinemationDuration = 7000
            }
        }
    }

}