----------------------------------------------------------------
--[[ Resource: Config Loader
     Script: configs: templates: ambiences.lua
     Author: vStudio
     Developer(s): Mario, Tron, Aviril
     DOC: 31/01/2022
     Desc: Ambiences Templates Configns ]]--
----------------------------------------------------------------


------------------
--[[ Configns ]]--
------------------

configVars["Templates"]["Ambiences"] = {

    ["Short"] = {
        assetName = "vRPZ_Ambience",
        category = "short",
        volume = 1,
        loopInterval = 20000
    },

    ["Long"] = {
        assetName = "vRPZ_Ambience",
        category = {"medium", "long"},
        loopInterval = 0
    }

}