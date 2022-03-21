----------------------------------------------------------------
--[[ Resource: Config Loader
     Script: configs: inventory: items.lua
     Author: vStudio
     Developer(s): Mario, Tron, Aviril
     DOC: 31/01/2022
     Desc: Inventory Items Configns ]]--
----------------------------------------------------------------


------------------
--[[ Configns ]]--
------------------

configVars["Inventory"]["Items"] = {

    ["Primary"] = {
        ["awm"] = {name = "AWM", weight = {rows = 2, columns = 6}, itemObjectID = 2827, itemPickupDetails = {scale = 1, rotX = 90}, weapon = {id = 34, ammo = "sniper_ammo", mag = 5, damage = 13000, fireDelay = 1500}},
        ["colt_model_733"] = {name = "Colt Model 733", weight = {rows = 2, columns = 6}, itemObjectID = 2827, itemPickupDetails = {scale = 1, rotX = 90}, weapon = {id = 34, ammo = "sniper_ammo", mag = 5, damage = 13000, fireDelay = 1500}},
        ["double_barreled_shotgun"] = {name = "Double Barreled Shotgun", weight = {rows = 2, columns = 6}, itemObjectID = 2827, itemPickupDetails = {scale = 1, rotX = 90}, weapon = {id = 34, ammo = "sniper_ammo", mag = 5, damage = 13000, fireDelay = 1500}},
        ["fn_fal_g"] = {name = "FN FAL G", weight = {rows = 2, columns = 6}, itemObjectID = 2827, itemPickupDetails = {scale = 1, rotX = 90}, weapon = {id = 34, ammo = "sniper_ammo", mag = 5, damage = 13000, fireDelay = 1500}},
    },

    ["Secondary"] = {},

    ["Tertiary"] = {},

    ["Helmet"] = {},

    ["Armor"] = {},

    ["Backpack"] = {}

}