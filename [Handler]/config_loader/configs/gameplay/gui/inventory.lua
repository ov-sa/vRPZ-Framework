----------------------------------------------------------------
--[[ Resource: Config Loader
     Script: configs: gameplay: gui: inventory.lua
     Author: vStudio
     Developer(s): Mario, Tron, Aviril
     DOC: 31/01/2022
     Desc: Inventory UI Configns ]]--
----------------------------------------------------------------


------------------
--[[ Configns ]]--
------------------

configVars["UI"]["Inventory"] = {

    titlebar = {
        height = 35,
        fontColor = {170, 35, 35, 255},
        bgColor = {0, 0, 0, 255},
        slot = {
            height = 20,
            fontColor = {0, 0, 0, 255},
            bgColor = {100, 100, 100, 255}
        }
    },

    inventory = {
        rows = 12,
        columns = 10,
        slotSize = 45,
        dividerSize = 1,
        dividerColor = {100, 100, 100, 50}
    }

}