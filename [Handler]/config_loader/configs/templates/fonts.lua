----------------------------------------------------------------
--[[ Resource: Config Loader
     Script: configs: templates: fonts.lua
     Author: vStudio
     Developer(s): Mario, Tron, Aviril
     DOC: 31/01/2022
     Desc: Font Templates Configns ]]--
----------------------------------------------------------------


------------------
--[[ Configns ]]--
------------------


configVars["Templates"]["Fonts"] = {

    {
        resource = "beautify_library",
        path = "files/assets/fonts/teko_medium.rw",
        alt = {
            ["RU"] = {"files/assets/fonts/ttlakes_demibold.rw", 0.93, "beautify_library"}
        }
    },

    {
        resource = "beautify_library",
        path = "files/assets/fonts/signika_semibold.rw",
        alt = {
            ["RU"] = {"files/assets/fonts/ttlakes_demibold.rw", 1.5, "beautify_library"}
        }
    }

}