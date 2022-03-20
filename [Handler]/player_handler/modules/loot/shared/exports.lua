----------------------------------------------------------------
--[[ Resource: Player Handler
     Script: modules: loot: shared: exports.lua
     Author: vStudio
     Developer(s): Mario, Tron, Aviril
     DOC: 31/01/2022
     Desc: Loot Module ]]--
----------------------------------------------------------------


-----------------
--[[ Exports ]]--
-----------------

function fetchLootType(...) return CInventory.fetchType(...) end
function fetchLootName(...) return CInventory.fetchName(...) end
function isLootLocked(...) return CInventory.isLocked(...) end