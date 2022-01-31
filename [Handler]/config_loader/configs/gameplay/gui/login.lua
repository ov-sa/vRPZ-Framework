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

    weather = 7,
    time = {1, 0},
    dimension = 100,
    clientPoint = {x = 0, y = 0, z = 0},
    cinemationPoints = {
        {
            cinemationFOV = 85,
            characterPoint = {x = 1381.38232421875, y = -1088.770141601562, z = 27.4180450439453, rotation = 94},
            cinemationPoint = {
                cameraStart = {1377.195434570312, -1088.299682617188, 27.76420021057129},
                cameraStartLook = {1378.178100585938, -1088.125244140625, 27.82710647583008, 0},
                cameraEnd = {1377.145874023438, -1087.547729492188, 27.74230003356934},
                cameraEndLook = {1378.142700195312, -1087.588134765625, 27.81147575378418},
                cinemationDuration = 7000
            }
        }
    }

}