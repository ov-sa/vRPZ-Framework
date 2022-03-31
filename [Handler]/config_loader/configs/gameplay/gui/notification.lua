----------------------------------------------------------------
--[[ Resource: Config Loader
     Script: configs: gameplay: gui: notification.lua
     Author: vStudio
     Developer(s): Mario, Tron, Aviril
     DOC: 31/01/2022
     Desc: Notification UI Configns ]]--
----------------------------------------------------------------


------------------
--[[ Configns ]]--
------------------

configVars["UI"]["Notification"] = {

    height = 15,
    slideInDuration = 1000,
    slideOutDuration = 1000,
    slideTopDuration = 1000,
    slideDelayDuration = 2500,
    fontColor = {175, 175, 175, 255},
    presets = {
        success = {80, 255, 80, 255},
        error = {255, 80, 80, 255}
    }

}