----------------------------------------------------------------
--[[ Resource: Config Loader
     Script: configs: gameplay: loots.lua
     Author: vStudio
     Developer(s): Mario, Tron, Aviril
     DOC: 31/01/2022
     Desc: Loots Configns ]]--
----------------------------------------------------------------


------------------
--[[ Configns ]]--
------------------

configVars["Loots"] = {

    ["LootCategory"] = {
        name = "Loot Name",
        pack = "loot",
        lock = false,
        size = 2,
        items = {
            {item = "awm", amount = {0, 100}, ammo = {0, 100}},
            {item = "bandage", amount = {0, 100}}
        },
        {position = {x = 0, y = 0, z = 0}, rotation = {x = 0, y = 0, z = 0}},
        {position = {x = 0, y = 0, z = 0}, rotation = {x = 0, y = 0, z = 0}},
        {position = {x = 0, y = 0, z = 0}, rotation = {x = 0, y = 0, z = 0}}
    }

}