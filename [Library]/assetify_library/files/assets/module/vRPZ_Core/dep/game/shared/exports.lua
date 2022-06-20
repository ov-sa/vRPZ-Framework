-----------------
--[[ Exports ]]--
-----------------

CGame.exportModule("CGame", {
    "execOnLoad",
    "execOnModuleLoad",
    "getServerTick",
    "getNativeWeather",
    "getTime",
    "formatMS",
    "getRole",
    "getLevelEXP",
    "getLevelRank",
    "generateSpawn"
})


----------------------------------
--[[ Function: Imports Module ]]--
----------------------------------

import = function()
    return CGame.CExports
end