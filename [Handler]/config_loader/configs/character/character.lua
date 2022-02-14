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
        tone = {
            ["Titles"] = {
                ["EN"] = "Skin Tone",
                ["TR"] = "Cilt tonu"
            }
        },

        gender = {
            ["Titles"] = {
                ["EN"] = "Gender",
                ["TR"] = "Cinsiyet"
            },

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
            ["Titles"] = {
                ["EN"] = "Faction",
                ["TR"] = "Hizip"
            },

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
        {
            assetName = "vRPZ_Male",
            hair = {
                {
                    ["EN"] = "None",
                    ["TR"] = "Hiçbiri"
                },
                {
                    ["EN"] = "Casual",
                    ["TR"] = "Gündelik"
                }
            }
        },

        {
            assetName = "vRPZ_Female"
        }
    }

}