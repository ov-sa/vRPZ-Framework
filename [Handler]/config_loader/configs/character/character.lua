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
                {clumpName = "TS1", clumpTexture = {"cj_tshrt_1", 1}, ["EN"] = "T-Shirt (LS)", ["TR"] = "Tişört (LS)"},
                {clumpName = "TS1", clumpTexture = {"cj_tshrt_1", 2}, ["EN"] = "T-Shirt (U)", ["TR"] = "Tişört (U)"},
                {clumpName = "H1", clumpTexture = {"cj_hdy_1", 1}, ["EN"] = "Hoody (Green)", ["TR"] = "Kapüşonlu (Yeşil)"}
            },
            ["Female"] = {
                {clumpName = "TS1", clumpTexture = {"cj_tshrt_1", 1}, ["EN"] = "T-Shirt (LS)", ["TR"] = "Tişört (LS)"},
                {clumpName = "TS1", clumpTexture = {"cj_tshrt_1", 2}, ["EN"] = "T-Shirt (LS)", ["TR"] = "Tişört (LS)"},
                {clumpName = "H1", clumpTexture = {"cj_hdy_1", 1}, ["EN"] = "Hoody (Green)", ["TR"] = "Kapüşonlu (Yeşil)"}
            }
        },
        ["Lower"] = {
            ["Male"] = {
                {clumpName = "P1", clumpTexture = {"cj_pnt_1", 1}, ["EN"] = "Jeans (Red)", ["TR"] = "Kot (Kırmızı)"},
                {clumpName = "T1", clumpTexture = {"cj_trsr_1", 1}, ["EN"] = "Trouser (Green)", ["TR"] = "Pantolon (Yeşil)"}
            },
            ["Female"] = {
                {clumpName = "P1", clumpTexture = {"cj_pnt_1", 1}, ["EN"] = "Jeans (Red)", ["TR"] = "Kot (Kırmızı)"},
                {clumpName = "T1", clumpTexture = {"cj_trsr_1", 1}, ["EN"] = "Trouser (Green)", ["TR"] = "Pantolon (Yeşil)"}
            }
        },
        ["Shoes"] = {
            ["Male"] = {
                {clumpName = "", clumpTexture = {"cj_shoe_1", 1}, ["EN"] = "Sneakers (Black)", ["TR"] = "Spor Ayakkabı (Siyah)"}
            },
            ["Female"] = {
                {clumpName = "", clumpTexture = {"cj_shoe_1", 1}, ["EN"] = "Sneakers (Black)", ["TR"] = "Spor Ayakkabı (Siyah)"}
            }
        }
    }

}