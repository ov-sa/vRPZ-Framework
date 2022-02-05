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

function setPlayerData(...) return CPlayer.setData(...) end
function getPlayerData(...) return CPlayer.getData(...) end
function getPlayerSerial(...) return CPlayer.getSerial(...) end
function getPlayerFromSerial(...) return CPlayer.getPlayer(...) end