----------------------------------------------------------------
--[[ Resource: Player Handler
     Script: modules: loot: shared: index.lua
     Author: vStudio
     Developer(s): Mario, Tron, Aviril
     DOC: 31/01/2022
     Desc: Loot Module ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local imports = {
    isElement = isElement,
    getElementData = getElementData
}


----------------------
--[[ Module: Loot ]]--
----------------------

CLoot = {
    fetchType = function(parent)
        if not parent or not imports.isElement(parent) then return false end
        return imports.getElementData(parent, "Loot:Type") or false
    end,

    fetchName = function(parent)
        if not CLoot.fetchLootType(parent) then return false end
        return imports.getElementData(parent, "Loot:Name") or "??"
    end,

    isLocked = function(parent)
        if not CLoot.fetchLootType(parent) then return false end
        return (imports.getElementData(parent, "Loot:Locked") and true) or false
    end
}