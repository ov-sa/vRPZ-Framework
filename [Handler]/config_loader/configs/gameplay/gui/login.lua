----------------------------------------------------------------
--[[ Resource: Config Loader
     Script: configs: gameplay: gui: login.lua
     Author: vStudio
     Developer(s): Tron
     DOC: 31/01/2022
     Desc: Login UI Configns ]]--
----------------------------------------------------------------


------------------
--[[ Configns ]]--
------------------

configVars["UI"]["Login"] = {

    weather = 9,
    time = {12, 0},
    dimension = 100,
    clientPoint = {x = 0, y = 0, z = 0},
    cinemationPoints = {
        {
            cinemationFOV = 50,
            characterPoint = {x = 1381.38232421875, y = -1088.770141601562, z = 26.8180450439453, rotation = 85},
            cinemationPoint = {
                cameraStart = {x = 1377.195434570312, y = -1088.299682617188, z = 27.16420021057129},
                cameraStartLook = {x = 1378.178100585938, y = -1088.125244140625, z = 27.22710647583008},
                cameraEnd = {x = 1377.145874023438, y = -1087.547729492188, z = 27.14230003356934},
                cameraEndLook = {x = 1378.142700195312, y = -1087.588134765625, z = 27.21147575378418},
                cinemationDuration = 7000
            }
        }
    }

}