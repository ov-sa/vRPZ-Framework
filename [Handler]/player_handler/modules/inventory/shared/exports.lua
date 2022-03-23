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
function fetchInventoryWeaponID(...) return CInventory.fetchWeaponID(...) end
function fetchInventoryWeaponAmmo(...) return CInventory.fetchWeaponAmmo(...) end
function fetchInventoryWeaponMag(...) return CInventory.fetchWeaponMag(...) end
function fetchInventorySlot(...) return CInventory.fetchSlot(...) end
function fetchInventoryItemCount(...) return CInventory.fetchItemCount(...) end
function fetchInventoryMaxSlotsMultiplier(...) return CInventory.fetchMaxSlotsMultiplier(...) end
function fetchInventoryParentMaxSlots(...) return CInventory.fetchParentMaxSlots(...) end
function fetchInventoryParentAssignedSlots(...) return CInventory.fetchParentAssignedSlots(...) end
function fetchInventoryParentUsedSlots(...) return CInventory.fetchParentUsedSlots(...) end