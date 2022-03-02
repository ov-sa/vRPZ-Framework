----------------------------------------------------------------
--[[ Resource: Config Loader
     Script: configs: gameplay: spawns.lua
     Author: vStudio
     Developer(s): Mario, Tron, Aviril
     DOC: 31/01/2022
     Desc: Spawns Configns ]]--
----------------------------------------------------------------


------------------
--[[ Configns ]]--
------------------

configVars["Spawns"] = {

    ["Datas"] = {
        generic = {
            {name = "Character:hunger", amount = 100},
            {name = "Character:thirst", amount = 100},
            {name = "Character:armor", amount = 0},
            {name = "Character:blood", amount = nil}
        }
    },

    ["Hint"] = {
        ["EN"] = "You died. Respawning..",
        ["TR"] = "Öldün. yeniden doğuyorsun.."
    },

    {x = 15.84037590026855, y = 321.1308288574219, z = 93.66236114501953},
    {x = -42.70333099365234, y = -207.6439514160156, z = 3.4163818359375}

}