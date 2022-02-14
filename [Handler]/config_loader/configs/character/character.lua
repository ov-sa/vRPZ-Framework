----------------------------------------------------------------
--[[ Resource: Config Loader
     Script: configs: character: character.lua
     Author: vStudio
     Developer(s): Tron
     DOC: 31/01/2022
     Desc: Character Configns ]]--
----------------------------------------------------------------


------------------
--[[ Configns ]]--
------------------

configVars["Character"] = {

    ["Datas"] = {
        "blood",
        "armor",
        "thirst",
        "hunger"
    },

    ["Identity"] = {
        gender = {
            {
                ["EN"] = "Male",
                ["TR"] = "Erkek"
            },
            {
                ["EN"] = "Female",
                ["TR"] = "Dişi"
            }
        },

        faction = {
            {
                ["EN"] = "Military",
                ["TR"] = "Askeri"
            },
            {
                ["EN"] = "Criminal",
                ["TR"] = "Adli"
            }
        }
    },

    ["Clothing"] = {
        ["Male"] = {
            assetName = "vRPZ_Male"
        },

        ["Female"] = {
            assetName = "vRPZ_Female"
        }
    }

}