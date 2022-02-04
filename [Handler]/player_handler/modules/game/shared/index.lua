----------------------------------------------------------------
--[[ Resource: Player Handler
     Script: modules: game: shared: index.lua
     Author: vStudio
     Developer(s): Mario, Tron, Aviril
     DOC: 31/01/2022
     Desc: Game Module ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local imports = {
    tonumber = tonumber,
    isElement = isElement,
    getElementsByType = getElementsByType,
    getElementData = getElementData
}


----------------------
--[[ Player Class ]]--
----------------------

CGame = {
    CTickSyncer = nil,

    getServerTick = function()
        local currentTick = 0
        if not CGame.CTickSyncer or not imports.isElement(CGame.CTickSyncer) then
            local tickSyncer = imports.getElementsByType("Server:TickSyncer", resourceRoot)
            CGame.CTickSyncer = tickSyncer[1]
        end
        if CGame.CTickSyncer and imports.isElement(CGame.CTickSyncer) then
            currentTick = imports.tonumber(imports.getElementData(CGame.CTickSyncer, "Server:TickSyncer")) or 0
        end
        return currentTick
    end
}