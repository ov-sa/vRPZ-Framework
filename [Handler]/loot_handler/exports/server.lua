----------------------------------------------------------------
--[[ Resource: Loot Handler
     Script: exports: server.lua
     Server: -
     Author: vStudio
     Developer(s): Tron
     DOC: 15/03/2022
     Desc: Server Sided Exports ]]--
----------------------------------------------------------------


-------------------------
--[[ Functions: APIs ]]--
-------------------------

function refreshLootType(...)
    return loot:refresh(...)
end

function refreshLoot(element)
    if not element or not imports.isElement(element) or not loot.buffer.element[element] then return false end
    return loot.buffer.element[element]:refresh()
end