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
            path = ":beautify_library/files/assets/fonts/teko_medium.rw",
            alt = {
                ["RU"] = {":beautify_library/files/assets/fonts/ttlakes_demibold.rw", 0.5}
            }
        } 
    },

    ["Beautify"] = {
        ["beautify_card"] = {
            color = {0, 0, 0, 0}
        },
    
        ["beautify_selector"] = {
            fontPaddingY = 0,
            font = {"files/assets/fonts/teko_medium.rw", 16, "beautify_library"},
            color = {100, 100, 100, 255},
            fontColor = {200, 200, 200, 255},
            hoverColor = {200, 200, 200, 255}
        }
    }

}