----------------------------------------------------------------
--[[ Resource: Player Handler
     Script: modules: inventory: server: index.lua
     Author: vStudio
     Developer(s): Mario, Tron, Aviril
     DOC: 31/01/2022
     Desc: Inventory Module ]]--
----------------------------------------------------------------


-------------------------
--[[ Inventory Class ]]--
-------------------------

CInventory.fetch = function(inventoryID, ...)
    dbify.character.fetchAll({
        {dbify.inventory.__connection__.keyColumn, inventoryID}
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



