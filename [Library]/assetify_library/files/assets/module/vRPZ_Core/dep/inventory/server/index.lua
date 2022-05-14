-----------------
--[[ Imports ]]--
-----------------

local imports = {
    pairs = pairs,
    string = string,
    assetify = assetify,
    dbify = dbify
}


---------------------------
--[[ Module: Inventory ]]--
---------------------------

CInventory.fetch = function(inventoryID, ...)
    imports.dbify.inventory.fetchAll({
        {imports.dbify.inventory.connection.keyColumn, inventoryID}
    }, ...)
    return true
end
CInventory.ensureItems = imports.dbify.inventory.ensureItems
CInventory.create = imports.dbify.inventory.create
CInventory.delete = imports.dbify.inventory.delete
CInventory.setData = imports.dbify.inventory.setData
CInventory.getData = imports.dbify.inventory.getData
CInventory.addItem = imports.dbify.inventory.item.add
CInventory.removeItem = imports.dbify.inventory.item.remove
CInventory.setItemProperty = imports.dbify.inventory.item.setProperty
CInventory.getItemProperty = imports.dbify.inventory.item.getProperty
CInventory.setItemData = imports.dbify.inventory.item.setData
CInventory.getItemData = imports.dbify.inventory.item.getData

imports.assetify.execOnLoad(function()
    local CItems = {}
    for i, j in imports.pairs(CInventory.CItems) do
        CItems[(imports.string.lower(i))] = true
    end
    CInventory.ensureItems(CItems)
end)