-----------------
--[[ Imports ]]--
-----------------

local imports = {
    isElement = isElement
}


----------------------
--[[ Module: Loot ]]--
----------------------

CLoot = {
    fetchType = function(parent)
        if not parent or not imports.isElement(parent) then return false end
        return CGame.getEntityData(parent, "Loot:Type") or false
    end,

    fetchName = function(parent)
        if not CLoot.fetchType(parent) then return false end
        return CGame.getEntityData(parent, "Loot:Name") or "??"
    end,

    isLocked = function(parent)
        if not CLoot.fetchType(parent) then return false end
        return (CGame.getEntityData(parent, "Loot:Locked") and true) or false
    end
}