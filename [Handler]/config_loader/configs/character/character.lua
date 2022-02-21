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
                {clumpName = "TS1", clumpTexture = {"cj_tshrt_1", 1}, ["EN"] = "T-Shirt (VRPZ#1)", ["TR"] = "Tişört (VRPZ#1)"},
                {clumpName = "TS1", clumpTexture = {"cj_tshrt_1", 2}, ["EN"] = "T-Shirt (VRPZ#2)", ["TR"] = "Tişört (VRPZ#2)"},
                {clumpName = "TS1", clumpTexture = {"cj_tshrt_1", 3}, ["EN"] = "T-Shirt (VRPZ#3)", ["TR"] = "Tişört (VRPZ#3)"},
                {clumpName = "TS1", clumpTexture = {"cj_tshrt_1", 4}, ["EN"] = "T-Shirt (VRPZ#4)", ["TR"] = "Tişört (VRPZ#4)"},
                {clumpName = "TS1", clumpTexture = {"cj_tshrt_1", 5}, ["EN"] = "T-Shirt (VRPZ#5)", ["TR"] = "Tişört (VRPZ#5)"},
                {clumpName = "TS1", clumpTexture = {"cj_tshrt_1", 6}, ["EN"] = "T-Shirt (VRPZ#6)", ["TR"] = "Tişört (VRPZ#6)"},
                {clumpName = "TS1", clumpTexture = {"cj_tshrt_1", 7}, ["EN"] = "T-Shirt (Camo#1)", ["TR"] = "Tişört (Camo#1)"},
                {clumpName = "TS1", clumpTexture = {"cj_tshrt_1", 8}, ["EN"] = "T-Shirt (Camo#2)", ["TR"] = "Tişört (Camo#2)"},
                {clumpName = "TS1", clumpTexture = {"cj_tshrt_1", 9}, ["EN"] = "T-Shirt (ZM#1)", ["TR"] = "Tişört (ZM#1)"},
                {clumpName = "TS1", clumpTexture = {"cj_tshrt_1", 10}, ["EN"] = "T-Shirt (ZM#2)", ["TR"] = "Tişört (ZM#2)"},
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
                {clumpName = "P1", clumpTexture = {"cj_pnt_1", 1}, ["EN"] = "Jeans (Black)", ["TR"] = "Kot (Siyah)"},
                {clumpName = "P1", clumpTexture = {"cj_pnt_1", 2}, ["EN"] = "Jeans (Red)", ["TR"] = "Kot (Kırmızı)"},
                {clumpName = "P1", clumpTexture = {"cj_pnt_1", 3}, ["EN"] = "Jeans (Blue)", ["TR"] = "Kot (Mavi)"},
                {clumpName = "P1", clumpTexture = {"cj_pnt_1", 4}, ["EN"] = "Jeans (Purple)", ["TR"] = "Kot (Mor)"},
                {clumpName = "P1", clumpTexture = {"cj_pnt_1", 5}, ["EN"] = "Jeans (Green)", ["TR"] = "Kot (Yeşil)"},
                {clumpName = "P1", clumpTexture = {"cj_pnt_1", 5}, ["EN"] = "Pant (Camo#1)", ["TR"] = "Pantolon (Camo#1)"},
                {clumpName = "P1", clumpTexture = {"cj_pnt_1", 5}, ["EN"] = "Pant (Camo#2)", ["TR"] = "Pantolon (Camo#2)"},
                {clumpName = "P1", clumpTexture = {"cj_pnt_1", 5}, ["EN"] = "Pant (Camo#3)", ["TR"] = "Pantolon (Camo#3)"},
                {clumpName = "P1", clumpTexture = {"cj_pnt_1", 5}, ["EN"] = "Pant (Camo#4)", ["TR"] = "Pantolon (Camo#4)"},
                {clumpName = "P1", clumpTexture = {"cj_pnt_1", 5}, ["EN"] = "Pant (Camo#5)", ["TR"] = "Pantolon (Camo#5)"},
                {clumpName = "T1", clumpTexture = {"cj_trsr_1", 1}, ["EN"] = "Trouser (Green)", ["TR"] = "Pantolon (Yeşil)"}
            },
            ["Female"] = {
                {clumpName = "P1", clumpTexture = {"cj_pnt_1", 1}, ["EN"] = "Jeans (Red)", ["TR"] = "Kot (Kırmızı)"},
                {clumpName = "T1", clumpTexture = {"cj_trsr_1", 1}, ["EN"] = "Trouser (Green)", ["TR"] = "Pantolon (Yeşil)"}
            }
        },
        ["Shoes"] = {
            ["Male"] = {
                {clumpName = "", clumpTexture = {"cj_shoe_1", 1}, ["EN"] = "Sneakers (Black)", ["TR"] = "Spor Ayakkabı (Siyah)"},
                {clumpName = "", clumpTexture = {"cj_shoe_1", 2}, ["EN"] = "Sneakers (Red)", ["TR"] = "Spor Ayakkabı (Red)"}
            },
            ["Female"] = {
                {clumpName = "", clumpTexture = {"cj_shoe_1", 1}, ["EN"] = "Sneakers (Black)", ["TR"] = "Spor Ayakkabı (Siyah)"},
                {clumpName = "", clumpTexture = {"cj_shoe_1", 2}, ["EN"] = "Sneakers (Red)", ["TR"] = "Spor Ayakkabı (Red)"}
            }
        }
    }

}