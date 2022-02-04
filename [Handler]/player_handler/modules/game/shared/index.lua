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
    getElementData = getElementData,
    getTime = getTime
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
    end,

    getTime = function()
        local time = {imports.getTime()}
        time[1] = ((time[1] < 10) and "0"..time[1]) or time[1]
        time[2] = ((time[2] < 10) and "0"..time[2]) or time[2] 
        return time[1], time[2]
    end
}