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
        ["Tone"] = {},
        ["Gender"] = {
            ["Male"] = {assetName = "vRPZ_Male", ["EN"] = "Male", ["TR"] = "Erkek"},
            --["Female"] = {assetName = "vRPZ_Female", ["EN"] = "Female", ["TR"] = "Dişi"}
        },
        ["Faction"] = {
            ["Military"] = {["EN"] = "Military", ["TR"] = "Askeri"},
            ["Criminal"] = {["EN"] = "Criminal", ["TR"] = "Adli"}
        }
    },

    ["Clothing"] = {
        ["Facial"] = {
            ["Hair"] = {
                ["Male"] = {
                    {["EN"] = "None", ["TR"] = "Hiçbiri"},
                    {["EN"] = "Casual", ["TR"] = "Gündelik"}
                }
            }
        },
        ["Upper"] = {
            ["Male"] = {
                {["EN"] = "T-Shirt (Red)", ["TR"] = "Tişört (Kırmızı)"},
                {["EN"] = "Hoody (Blue)", ["TR"] = "Kapüşonlu (Mavi)"}
            },
            ["Female"] = {
                {["EN"] = "T-Shirt (Red)", ["TR"] = "Tişört (Kırmızı)"},
                {["EN"] = "Hoody (Blue)", ["TR"] = "Kapüşonlu (Mavi)"}
            }
        },
        ["Lower"] = {
            ["Male"] = {
                {["EN"] = "Pant (Red)", ["TR"] = "Pantolon (Kırmızı)"},
                {["EN"] = "Trouser (Blue)", ["TR"] = "Pantolon (Mavi)"}
            },
            ["Female"] = {
                {["EN"] = "Pant (Red)", ["TR"] = "Pantolon (Kırmızı)"},
                {["EN"] = "Trouser (Blue)", ["TR"] = "Pantolon (Mavi)"}
            }
        },
        ["Shoes"] = {
            ["Male"] = {
                {["EN"] = "Sneakers (Red)", ["TR"] = "Spor Ayakkabı (Kırmızı)"}
            },
            ["Female"] = {
                {["EN"] = "Sneakers (Red)", ["TR"] = "Spor Ayakkabı (Kırmızı)"}
            }
        }
    }

}