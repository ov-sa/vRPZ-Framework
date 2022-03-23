----------------------------------------------------------------
--[[ Resource: Player Handler
     Script: modules: inventory: server: index.lua
     Author: vStudio
     Developer(s): Mario, Tron, Aviril
     DOC: 31/01/2022
     Desc: Inventory Module ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local imports = {
    tonumber = tonumber,
    isElement = isElement,
    getElementType = getElementType,
    getElementData = getElementData,
    math = math
}


---------------------------
--[[ Module: Inventory ]]--
---------------------------

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

CInventory.fetchParentMaxSlots = function(parent)
    if not parent or not imports.isElement(parent) then return false end
    if imports.getElementType(parent) == "player" then
        if not CPlayer.isInitialized(parent) then return false end
        return imports.math.max(0, (playerInventorySlots[parent] and imports.tonumber(playerInventorySlots[parent].maxSlots)) or 0)
    end
    return imports.tonumber(imports.getElementData(parent, "Inventory:MaxSlots")) or 0
end

CInventory.ensureItems(CInventory.CItems)