----------------------------------------------------------------
--[[ Resource: Player Handler
     Script: modules: game: shared: exports.lua
     Author: vStudio
     Developer(s): Mario, Tron, Aviril
     DOC: 31/01/2022
     Desc: Game Module ]]--
----------------------------------------------------------------


-----------------
--[[ Exports ]]--
-----------------

function getServerTick(...) return CGame.getServerTick(...) end
function getTime(...) return CGame.getTime(...) end
function formatMS(...) return CGame.formatMS(...) end