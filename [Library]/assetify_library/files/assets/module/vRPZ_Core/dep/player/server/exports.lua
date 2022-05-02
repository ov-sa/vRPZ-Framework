-----------------
--[[ Imports ]]--
-----------------

local imports = {
    addEvent = addEvent
}


-----------------
--[[ Exports ]]--
-----------------

function fetchPlayer(...) return CPlayer.fetch(...) end
function setPlayerData(...) return CPlayer.setData(...) end
function getPlayerData(...) return CPlayer.getData(...) end
function getPlayerSerial(...) return CPlayer.getSerial(...) end
function getPlayerFromSerial(...) return CPlayer.getPlayer(...) end
function setPlayerChannel(...) return CPlayer.setChannel(...) end
function setPlayerParty(...) return CPlayer.setParty(...) end


----------------
--[[ Events ]]--
----------------

imports.addEvent("Player:onLogin", false)
imports.addEvent("Player:onLogout", false)