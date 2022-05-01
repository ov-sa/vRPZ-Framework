----------------------------------------------------------------
--[[ Resource: Player Handler
     Script: modules: game: shared: exports.lua
     Author: vStudio
     Developer(s): Mario, Tron, Aviril, Аниса
     DOC: 31/01/2022
     Desc: Game Module ]]--
----------------------------------------------------------------


-----------------
--[[ Exports ]]--
-----------------

function execOnLoad(...) return CGame.execOnLoad(...) end
function execOnModuleLoad(...) return CGame.execOnModuleLoad(...) end
function getServerTick(...) return CGame.getServerTick(...) end
function getNativeWeather(...) return CGame.getNativeWeather(...) end
function getTime(...) return CGame.getTime(...) end
function formatMS(...) return CGame.formatMS(...) end
function getLevelEXP(...) return CGame.getLevelEXP(...) end
function getLevelRank(...) return CGame.getLevelRank(...) end
function generateSpawn(...) return CGame.generateSpawn(...) end