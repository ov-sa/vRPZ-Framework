----------------------------------------------------------------
--[[ Resource: Config Loader
     Script: configs: templates: index.lua
     Author: vStudio
     Developer(s): Mario, Tron, Aviril
     DOC: 31/01/2022
     Desc: Templates Configns ]]--
----------------------------------------------------------------


------------------
--[[ Configns ]]--
------------------

configVars["Templates"] = {

    ["Fonts"] = {
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
    },

    ["Beautify"] = {
        ["beautify_card"] = {
            color = {0, 0, 0, 0}
        },
    
        ["beautify_selector"] = {
            fontPaddingY = 0,
            font = {1, 16},
            color = {100, 100, 100, 255},
            fontColor = {200, 200, 200, 255},
            hoverColor = {200, 200, 200, 255}
        }
    }

}