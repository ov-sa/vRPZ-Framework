----------------------------------------------------------------
--[[ Resource: Player Handler
     Script: modules: inventory: shared: index.lua
     Author: vStudio
     Developer(s): Mario, Tron, Aviril
     DOC: 31/01/2022
     Desc: Inventory Module ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local imports = {
    pairs = pairs
}


----------------------
--[[ Player Class ]]--
----------------------

CInventory = {
    CItems = {}

    fetchItem = function(item)
        if not item or not CInventory.CItems[item] then return false end
        return CInventory.CItems[item]
    end,

    fetchItemName = function(item)
        local itemData = CInventory.fetchItem(item)
        return (itemData and itemData.name) or false
    end,

    fetchItemName = function(item)
        local itemData = CInventory.fetchItem(item)
        return (itemData and itemData.name) or false
    end,
}

for i, j in imports.pairs(FRAMEWORK_CONFIGS["Inventory"]["Items"]) do
    for k, v in imports.pairs(j) do
        CInventory.CItems[k] = i
    end
end