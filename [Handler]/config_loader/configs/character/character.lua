----------------------------------------------------------------
--[[ Resource: Config Loader
     Script: configs: character: character.lua
     Author: vStudio
     Developer(s): Mario, Tron, Aviril
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
                {clumpName = "TS1", clumpTexture = {"cj_tshrt_1", 1}, ["EN"] = "T-Shirt (Red)", ["TR"] = "Tişört (Kırmızı)"},
                {clumpName = "H1", clumpTexture = {"cj_hdy_1", 1}, ["EN"] = "Hoody (Blue)", ["TR"] = "Kapüşonlu (Mavi)"}
            },
            ["Female"] = {
                {clumpName = "TS1", clumpTexture = {"cj_tshrt_1", 1}, ["EN"] = "T-Shirt (Red)", ["TR"] = "Tişört (Kırmızı)"},
                {clumpName = "H1", clumpTexture = {"cj_hdy_1", 1}, ["EN"] = "Hoody (Blue)", ["TR"] = "Kapüşonlu (Mavi)"}
            }
        },
        ["Lower"] = {
            ["Male"] = {
                {clumpName = "P1", clumpTexture = {"cj_pnt_1", 1}, ["EN"] = "Pant (Red)", ["TR"] = "Pantolon (Kırmızı)"},
                {clumpName = "T1", clumpTexture = {"cj_trsr_1", 1}, ["EN"] = "Trouser (Blue)", ["TR"] = "Pantolon (Mavi)"}
            },
            ["Female"] = {
                {clumpName = "P1", clumpTexture = {"cj_pnt_1", 1}, ["EN"] = "Pant (Red)", ["TR"] = "Pantolon (Kırmızı)"},
                {clumpName = "T1", clumpTexture = {"cj_trsr_1", 1}, ["EN"] = "Trouser (Blue)", ["TR"] = "Pantolon (Mavi)"}
            }
        },
        ["Shoes"] = {
            ["Male"] = {
                {clumpName = "", clumpTexture = {"wip", 1}, ["EN"] = "Sneakers (Red)", ["TR"] = "Spor Ayakkabı (Kırmızı)"}
            },
            ["Female"] = {
                {clumpName = "", clumpTexture = {"wip", 1}, ["EN"] = "Sneakers (Red)", ["TR"] = "Spor Ayakkabı (Kırmızı)"}
            }
        }
    }

}