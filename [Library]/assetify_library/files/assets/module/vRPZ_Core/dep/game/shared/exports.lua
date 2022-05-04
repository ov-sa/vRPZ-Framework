-----------------
--[[ Exports ]]--
-----------------

CGame.createExports({
    {"execOnLoad", "CGame", "execOnLoad"},
    {"execOnModuleLoad", "CGame", "execOnModuleLoad"},
    {"getServerTick", "CGame", "getServerTick"},
    {"getNativeWeather", "CGame", "getNativeWeather"},
    {"getTime", "CGame", "getTime"},
    {"formatMS", "CGame", "formatMS"},
    {"getLevelEXP", "CGame", "getLevelEXP"},
    {"getLevelRank", "CGame", "getLevelRank"},
    {"generateSpawn", "CGame", "generateSpawn"}
})


-----------------------------------
--[[ Function: Fetches Imports ]]--
-----------------------------------

fetchImports = function()
    return CGame.CExports
end