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
        ["awm"] = {name = "AWM", weight = {horizontal = 3, vertical = 1}, itemObjectID = 2827, itemPickupDetails = {scale = 1, rotX = 90}, weaponID = 34, weaponDamage = 13000, weaponAmmo = "Sniper Ammo", magSize = 5, fireDelay = 1500}
    },

    ["Secondary"] = {},

    ["Tertiary"] = {},

    ["Helmet"] = {},

    ["Armor"] = {},

    ["Backpack"] = {}

}