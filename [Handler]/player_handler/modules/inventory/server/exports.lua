----------------------------------------------------------------
--[[ Resource: Player Handler
     Script: modules: inventory: server: exports.lua
     Author: vStudio
     Developer(s): Mario, Tron, Aviril
     DOC: 31/01/2022
     Desc: Inventory Module ]]--
----------------------------------------------------------------


-----------------
--[[ Exports ]]--
-----------------

function fetchInventory(...) return CInventory.fetch(...) end
function createInventory(...) return CInventory.create(...) end
function deleteInventory(...) return CInventory.delete(...) end
function setInventoryData(...) return CInventory.setData(...) end
function getInventoryData(...) return CInventory.getData(...) end
function addInventoryItem(...) return CInventory.addItem(...) end
function removeInventoryItem(...) return CInventory.removeItem(...) end
function setInventoryItemProperty(...) return CInventory.setItemProperty(...) end
function getInventoryItemProperty(...) return CInventory.getItemProperty(...) end
function setInventoryItemData(...) return CInventory.setItemData(...) end
function getInventoryItemData(...) return CInventory.getItemData(...) end









