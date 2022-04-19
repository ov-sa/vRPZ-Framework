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
    
    assetName = "vRPZ_Ambience",

    ["Short_Ambience"] = {
        category = "short",
        loopInterval = 20000
    },

    ["Long_Ambience"] = {
        category = {"medium", "long"},
        loopInterval = 0
    }

}