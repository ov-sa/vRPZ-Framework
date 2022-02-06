----------------------------------------------------------------
--[[ Resource: Player Handler
     Script: modules: inventory: shared: exports.lua
     Author: vStudio
     Developer(s): Mario, Tron, Aviril
     DOC: 31/01/2022
     Desc: Inventory Module ]]--
----------------------------------------------------------------


-----------------
--[[ Exports ]]--
-----------------

function fetchInventoryItem(...) return CInventory.fetchItem(...) end
function fetchInventoryItemSlot(...) return CInventory.fetchItemSlot(...) end
function fetchInventoryItemName(...) return CInventory.fetchItemName(...) end
function fetchInventoryItemWeight(...) return CInventory.fetchItemWeight(...) end
function fetchInventoryItemObjectID(...) return CInventory.fetchItemObjectID(...) end
function fetchInventoryWeaponSlot(...) return CInventory.fetchWeaponSlot(...) end
function fetchInventoryWeaponSlotID(...) return CInventory.fetchWeaponSlotID(...) end
function fetchInventoryWeaponID(...) return CInventory.fetchWeaponID(...) end
function fetchInventoryWeaponAmmo(...) return CInventory.fetchWeaponAmmo(...) end
function fetchInventoryWeaponMag(...) return CInventory.fetchWeaponMag(...) end
function fetchInventorySlot(...) return CInventory.fetchSlot(...) end