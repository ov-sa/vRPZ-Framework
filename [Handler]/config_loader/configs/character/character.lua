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
        ["Models"] = 
        ["Tone"] = {},
        ["Gender"] = {
            {assetName = "vRPZ_Male", ["EN"] = "Male", ["TR"] = "Erkek"},
            {assetName = "vRPZ_Female", ["EN"] = "Female", ["TR"] = "Dişi"}
        },
        ["Faction"] = {
            {["EN"] = "Military", ["TR"] = "Askeri"},
            {["EN"] = "Criminal", ["TR"] = "Adli"}
        }
    },

    ["Clothing"] = {
        ["Facial"] = {
            hair = {
                {["EN"] = "None", ["TR"] = "Hiçbiri"},
                {["EN"] = "Casual", ["TR"] = "Gündelik"}
            }
        },
        ["Upper"] = {},
        ["Lower"] = {},
        ["Shoes"] = {}
    }

}