----------------------------------------------------------------
--[[ Resource: Player Handler
     Script: modules: player: server: index.lua
     Author: vStudio
     Developer(s): Mario, Tron, Aviril
     DOC: 31/01/2022
     Desc: Player Module ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local imports = {
    getElementsByType = getElementsByType,
    getPlayerSerial = getPlayerSerial,
}


----------------
--[[ Module ]]--
----------------

CPlayer.getPlayer = function(serial)
    if not serial then return false end
    local players = imports.getElementsByType("player")
    for i = 1, #players, 1 do
        local j = players[i]
        if CPlayer.isInitialized(j) then
            if imports.getPlayerSerial(j) == serial then
                return j
            end
        end
    end
    return false
end