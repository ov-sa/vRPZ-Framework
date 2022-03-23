----------------------------------------------------------------
--[[ Resource: Player Handler
     Script: modules: inventory: client: exports.lua
     Author: vStudio
     Developer(s): Mario, Tron, Aviril
     DOC: 31/01/2022
     Desc: Inventory Module ]]--
----------------------------------------------------------------


-----------------
--[[ Exports ]]--
-----------------

function fetchInventorySlotDimensions(...) return CInventory.fetchSlotDimensions(...) end
function fetchInventoryParentMaxSlots(...) return CInventory.fetchParentMaxSlots(...) end