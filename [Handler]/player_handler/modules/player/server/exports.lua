----------------------------------------------------------------
--[[ Resource: Player Handler
     Script: modules: player: server: exports.lua
     Author: vStudio
     Developer(s): Mario, Tron, Aviril
     DOC: 31/01/2022
     Desc: Player Module ]]--
----------------------------------------------------------------


-----------------
--[[ Exports ]]--
-----------------

function getPlayerSerial(...) return CPlayer.getSerial(...) end
function getPlayerFromSerial(...) return CPlayer.getPlayer(...) end