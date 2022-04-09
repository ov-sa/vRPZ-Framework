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
        "hunger",
        "thirst"
    },

    ["Identity"] = {
        ["Tone"] = {},
        ["Gender"] = {
            ["Male"] = {assetName = "vRPZ_Male", ["EN"] = "Male", ["TR"] = "Erkek", ["RU"] = "Мужской"},
            --["Female"] = {assetName = "vRPZ_Female", ["EN"] = "Female", ["TR"] = "Dişi", ["RU"] = "женский"}
        }
    },

    ["Clothing"] = {
        ["Facial"] = {
            ["Hair"] = {
                ["Male"] = {
                    {["EN"] = "None", ["TR"] = "Hiçbiri", ["RU"] = "отсутствует"},
                    {["EN"] = "Casual", ["TR"] = "Gündelik", ["RU"] = "Повседневная"}
                }
            }
        },
    
        ["Upper"] = {
            ["Male"] = {
                {clumpName = "TS1", clumpTexture = {"cj_tshrt_1", 1}, ["EN"] = "T-Shirt (White)", ["TR"] = "Tişört (Beyaz)", ["RU"] = "Футболка (белая)"},
                {clumpName = "TS1", clumpTexture = {"cj_tshrt_1", 2}, ["EN"] = "T-Shirt (Black)", ["TR"] = "Tişört (Siyah)", ["RU"] = "Футболка (черная)"},
                {clumpName = "H1", clumpTexture = {"cj_hdy_1", 1}, ["EN"] = "Hoody (Camo#1)", ["TR"] = "Kapüşonlu (Camo#1)", ["RU"] = "Толстовка (Camo№1)"},
                {clumpName = "H1", clumpTexture = {"cj_hdy_1", 2}, ["EN"] = "Hoody (Camo#2)", ["TR"] = "Kapüşonlu (Camo#2)", ["RU"] = "Толстовка (Camo№2)"},
                {clumpName = "H1", clumpTexture = {"cj_hdy_1", 3}, ["EN"] = "Hoody (Camo#3)", ["TR"] = "Kapüşonlu (Camo#3)", ["RU"] = "Толстовка (Camo№3)"},
                {clumpName = "H1", clumpTexture = {"cj_hdy_1", 4}, ["EN"] = "Hoody (Camo#4)", ["TR"] = "Kapüşonlu (Camo#4)", ["RU"] = "Толстовка (Camo№4)"},
                {clumpName = "H1", clumpTexture = {"cj_hdy_1", 5}, ["EN"] = "Hoody (Camo#5)", ["TR"] = "Kapüşonlu (Camo#5)", ["RU"] = "Толстовка (Camo№5)"},
                {clumpName = "H1", clumpTexture = {"cj_hdy_1", 6}, ["EN"] = "Hoody (Camo#6)", ["TR"] = "Kapüşonlu (Camo#6)", ["RU"] = "Толстовка (Camo№6)"},
                {clumpName = "H1", clumpTexture = {"cj_hdy_1", 7}, ["EN"] = "Hoody (Camo#7)", ["TR"] = "Kapüşonlu (Camo#7)", ["RU"] = "Толстовка (Camo№7)"},
                {clumpName = "H1", clumpTexture = {"cj_hdy_1", 8}, ["EN"] = "Hoody (Casual#1)", ["TR"] = "Kapüşonlu (Casual#1)", ["RU"] = "Толстовка (Casual#1)"}
            },
            ["Female"] = {}
        },

        ["Lower"] = {
            ["Male"] = {
                {clumpName = "P1", clumpTexture = {"cj_pnt_1", 1}, ["EN"] = "Pant (Camo#1)", ["TR"] = "Pantolon (Camo#1)", ["RU"] = "Брюки (Camo#1)"},
                {clumpName = "P1", clumpTexture = {"cj_pnt_1", 2}, ["EN"] = "Pant (Camo#2)", ["TR"] = "Pantolon (Camo#2)", ["RU"] = "Брюки (Camo#2)"},
                {clumpName = "P1", clumpTexture = {"cj_pnt_1", 3}, ["EN"] = "Pant (Camo#3)", ["TR"] = "Pantolon (Camo#3)", ["RU"] = "Брюки (Camo#3)"},
                {clumpName = "P1", clumpTexture = {"cj_pnt_1", 4}, ["EN"] = "Pant (Camo#4)", ["TR"] = "Pantolon (Camo#4)", ["RU"] = "Брюки (Camo#4)"},
                {clumpName = "P1", clumpTexture = {"cj_pnt_1", 5}, ["EN"] = "Pant (Camo#5)", ["TR"] = "Pantolon (Camo#5)", ["RU"] = "Брюки (Camo#5)"},
                {clumpName = "P1", clumpTexture = {"cj_pnt_1", 6}, ["EN"] = "Pant (Camo#6)", ["TR"] = "Pantolon (Camo#6)", ["RU"] = "Брюки (Camo#6)"},
                {clumpName = "P1", clumpTexture = {"cj_pnt_1", 7}, ["EN"] = "Pant (Camo#7)", ["TR"] = "Pantolon (Camo#7)", ["RU"] = "Брюки (Camo#7)"},
                {clumpName = "P1", clumpTexture = {"cj_pnt_1", 8}, ["EN"] = "Pant (Casual#1)", ["TR"] = "Pantolon (Casual#1)", ["RU"] = "Брюки (Casual#1)"},
                {clumpName = "T1", clumpTexture = {"cj_trsr_1", 1}, ["EN"] = "Trouser (Green)", ["TR"] = "Pantolon (Yeşil)", ["RU"] = "Брюки (зеленые)"}
            },
            ["Female"] = {}
        },

        ["Shoes"] = {
            ["Male"] = {
                {clumpName = "", clumpTexture = {"cj_shoe_1", 1}, ["EN"] = "Sneakers (Black)", ["TR"] = "Spor Ayakkabı (Siyah)", ["RU"] = "Кроссовки (черные)"},
                {clumpName = "", clumpTexture = {"cj_shoe_1", 2}, ["EN"] = "Sneakers (Red)", ["TR"] = "Spor Ayakkabı (Kırmızı)", ["RU"] = "Кроссовки (красные)"}
            },
            ["Female"] = {}
        }
    }

}