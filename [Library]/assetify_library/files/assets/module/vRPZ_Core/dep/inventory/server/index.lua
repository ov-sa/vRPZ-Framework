-----------------
--[[ Imports ]]--
-----------------

local imports = {
    pairs = pairs,
    string = string
}


---------------------------
--[[ Module: Inventory ]]--
---------------------------

CInventory.fetch = function(inventoryID, ...)
    dbify.inventory.fetchAll({
        {dbify.inventory.connection.keyColumn, inventoryID}
    }, ...)
    return true
end
CInventory.ensureItems = dbify.inventory.ensureItems
CInventory.create = dbify.inventory.create
CInventory.delete = dbify.inventory.delete
CInventory.setData = dbify.inventory.setData
CInventory.getData = dbify.inventory.getData
CInventory.addItem = dbify.inventory.item.add
CInventory.removeItem = dbify.inventory.item.remove
CInventory.setItemProperty = dbify.inventory.item.setProperty
CInventory.getItemProperty = dbify.inventory.item.getProperty
CInventory.setItemData = dbify.inventory.item.setData
CInventory.getItemData = dbify.inventory.item.getData

local __CItems = {}
for i, j in imports.pairs(CInventory.CItems) do
    __CItems[(imports.string.lower(i))] = true
end
CInventory.ensureItems(__CItems)
__CItems = nil