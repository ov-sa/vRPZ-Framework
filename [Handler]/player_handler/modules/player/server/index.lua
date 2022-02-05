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
    isElement = isElement,
    getElementType = getElementType,
    getElementsByType = getElementsByType,
    getPlayerSerial = getPlayerSerial,
}


----------------
--[[ Module ]]--
----------------

CPlayer.setData = dbify.serial.setData
CPlayer.getData = dbify.serial.getData

CPlayer.getSerial = function(player)
    if (not player or not imports.isElement(player) or (imports.getElementType(player) ~= "player")) then return false end
    return imports.getPlayerSerial(player)
end

CPlayer.getPlayer = function(serial)
    if not serial then return false end
    local players = imports.getElementsByType("player")
    for i = 1, #players, 1 do
        local j = players[i]
        if CPlayer.isInitialized(j) then
            if CPlayer.getSerial(j) == serial then
                return j
            end
        end
    end
    return false
end