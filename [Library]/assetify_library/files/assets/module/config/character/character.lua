------------------
--[[ Configns ]]--
------------------

FRAMEWORK_CONFIGS["Character"] = {

    ["Datas"] = {
        "blood",
        "hunger",
        "thirst",
        "money",
        "level",
        "experience",
        "reputation"
    },

    ["Identity"] = {
        ["Tone"] = {},
        ["Gender"] = {
            ["Male"] = {assetName = "vRPZ_Male", ["EN"] = "Male", ["TR"] = "Erkek", ["RU"] = "Мужской", ["BR"] = "Masculino"},
            --["Female"] = {assetName = "vRPZ_Female", ["EN"] = "Female", ["TR"] = "Dişi", ["RU"] = "женский", ["BR"] = "Mulher"}
        }
    },

    ["Clothing"] = {
        ["Facial"] = {
            ["Hair"] = {
                ["Male"] = {
                    {["EN"] = "None", clumpName = "H0", clumpTexture = false, ["TR"] = "Hiçbiri", ["RU"] = "нет", ["BR"] = "Nenhum"},
                    {["EN"] = "Generic", clumpName = "H1", clumpTexture = {"cj_hair_1", 1}, ["TR"] = "Genel", ["RU"] = "Общий", ["BR"] = "Genérico"},
                    {["EN"] = "Survivor", clumpName = "H2", clumpTexture = {"cj_hair_2", 1}, ["TR"] = "Hayatta kalan", ["RU"] = "Выживший", ["BR"] = "Sobrevivente"}
                }
            },

            ["Face"] = {
                ["Male"] = {
                    {["EN"] = "Generic", clumpName = false, clumpTexture = {"cj_skn_fce", 1}, ["TR"] = "Genel", ["RU"] = "Общий", ["BR"] = "Genérico"},
                    {["EN"] = "Survivor", clumpName = false, clumpTexture = {"cj_skn_fce", 2}, ["TR"] = "Hayatta kalan", ["RU"] = "Выживший", ["BR"] = "Sobrevivente"}
                }
            }
        },
    
        ["Upper"] = {
            ["Male"] = {
                {clumpName = "H1", clumpTexture = {"cj_hdy_1", 1}, ["EN"] = "Hoody (Camo#1)", ["TR"] = "Kapüşonlu (Camo#1)", ["RU"] = "Толстовка (Camo#1)", ["BR"] = "Moletom (Camo#1)"},
                {clumpName = "H1", clumpTexture = {"cj_hdy_1", 2}, ["EN"] = "Hoody (Camo#2)", ["TR"] = "Kapüşonlu (Camo#2)", ["RU"] = "Толстовка (Camo#2)", ["BR"] = "Moletom (Camo#2)"},
                {clumpName = "H1", clumpTexture = {"cj_hdy_1", 3}, ["EN"] = "Hoody (Camo#3)", ["TR"] = "Kapüşonlu (Camo#3)", ["RU"] = "Толстовка (Camo#3)", ["BR"] = "Moletom (Camo#3)"},
                {clumpName = "H1", clumpTexture = {"cj_hdy_1", 4}, ["EN"] = "Hoody (Camo#4)", ["TR"] = "Kapüşonlu (Camo#4)", ["RU"] = "Толстовка (Camo#4)", ["BR"] = "Moletom (Camo#4)"},
                {clumpName = "H1", clumpTexture = {"cj_hdy_1", 5}, ["EN"] = "Hoody (Camo#5)", ["TR"] = "Kapüşonlu (Camo#5)", ["RU"] = "Толстовка (Camo#5)", ["BR"] = "Moletom (Camo#5)"},
                {clumpName = "H1", clumpTexture = {"cj_hdy_1", 6}, ["EN"] = "Hoody (Camo#6)", ["TR"] = "Kapüşonlu (Camo#6)", ["RU"] = "Толстовка (Camo#6)", ["BR"] = "Moletom (Camo#6)"},
                {clumpName = "H1", clumpTexture = {"cj_hdy_1", 7}, ["EN"] = "Hoody (Camo#7)", ["TR"] = "Kapüşonlu (Camo#7)", ["RU"] = "Толстовка (Camo#7)", ["BR"] = "Moletom (Camo#7)"},
                {clumpName = "H1", clumpTexture = {"cj_hdy_1", 8}, ["EN"] = "Hoody (Camo#8)", ["TR"] = "Kapüşonlu (Camo#1)", ["RU"] = "Толстовка (Camo#8)", ["BR"] = "Moletom (Camo#8)"}
            },
            ["Female"] = {}
        },

        ["Lower"] = {
            ["Male"] = {
                {clumpName = "P1", clumpTexture = {"cj_pnt_1", 1}, ["EN"] = "Pant (Camo#1)", ["TR"] = "Pantolon (Camo#1)", ["RU"] = "Брюки (Camo#1)", ["BR"] = "Calça (Camo#1)"},
                {clumpName = "P1", clumpTexture = {"cj_pnt_1", 2}, ["EN"] = "Pant (Camo#2)", ["TR"] = "Pantolon (Camo#2)", ["RU"] = "Брюки (Camo#2)", ["BR"] = "Calça (Camo#2)"},
                {clumpName = "P1", clumpTexture = {"cj_pnt_1", 3}, ["EN"] = "Pant (Camo#3)", ["TR"] = "Pantolon (Camo#3)", ["RU"] = "Брюки (Camo#3)", ["BR"] = "Calça (Camo#3)"},
                {clumpName = "P1", clumpTexture = {"cj_pnt_1", 4}, ["EN"] = "Pant (Camo#4)", ["TR"] = "Pantolon (Camo#4)", ["RU"] = "Брюки (Camo#4)", ["BR"] = "Calça (Camo#4)"},
                {clumpName = "P1", clumpTexture = {"cj_pnt_1", 5}, ["EN"] = "Pant (Camo#5)", ["TR"] = "Pantolon (Camo#5)", ["RU"] = "Брюки (Camo#5)", ["BR"] = "Calça (Camo#5)"},
                {clumpName = "P1", clumpTexture = {"cj_pnt_1", 6}, ["EN"] = "Pant (Camo#6)", ["TR"] = "Pantolon (Camo#6)", ["RU"] = "Брюки (Camo#6)", ["BR"] = "Calça (Camo#6)"},
                {clumpName = "P1", clumpTexture = {"cj_pnt_1", 7}, ["EN"] = "Pant (Camo#7)", ["TR"] = "Pantolon (Camo#7)", ["RU"] = "Брюки (Camo#7)", ["BR"] = "Calça (Camo#7)"},
                {clumpName = "P1", clumpTexture = {"cj_pnt_1", 8}, ["EN"] = "Pant (Camo#8)", ["TR"] = "Pantolon (Camo#8)", ["RU"] = "Брюки (Camo#8)", ["BR"] = "Calça (Camo#8)"},
                {clumpName = "T1", clumpTexture = {"cj_trsr_1", 1}, ["EN"] = "Trouser (Green)", ["TR"] = "Pantolon (Yeşil)", ["RU"] = "Брюки (зеленые)", ["BR"] = "Bermuda (Verde)"}
            },
            ["Female"] = {}
        },

        ["Shoes"] = {
            ["Male"] = {
                {clumpName = "", clumpTexture = {"cj_shoe_1", 1}, ["EN"] = "Sneakers (Black)", ["TR"] = "Spor Ayakkabı (Siyah)", ["RU"] = "Кроссовки (черные)", ["BR"] = "Tênis (Preto)"},
                {clumpName = "", clumpTexture = {"cj_shoe_1", 2}, ["EN"] = "Sneakers (Red)", ["TR"] = "Spor Ayakkabı (Kırmızı)", ["RU"] = "Кроссовки (красные)", ["BR"] = "Tênis (Vermelho)"}
            },
            ["Female"] = {}
        }
    }

}