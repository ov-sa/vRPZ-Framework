----------------------------------------------------------------
--[[ Resource: Player Handler
     Script: modules: player: shared: exports.lua
     Author: vStudio
     Developer(s): Mario, Tron, Aviril
     DOC: 31/01/2022
     Desc: Player Module ]]--
----------------------------------------------------------------


-----------------
--[[ Exports ]]--
-----------------

function isPlayerInitialized(...) return CPlayer.isInitialized(...) end
function getPlayerChannel(...) return CPlayer.getChannel(...) end
--TODO:  ADD EVENT TO RECIEVE SYNC FOR CHANNEL