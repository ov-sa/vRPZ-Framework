-----------------
--[[ Exports ]]--
-----------------

CGame.createExports({
    {exportName = "execOnLoad", moduleName = "CGame", moduleMethod = "execOnLoad"},
    {exportName = "execOnModuleLoad", moduleName = "CGame", moduleMethod = "execOnModuleLoad"},
    {exportName = "getServerTick", moduleName = "CGame", moduleMethod = "getServerTick"},
    {exportName = "getNativeWeather", moduleName = "CGame", moduleMethod = "getNativeWeather"},
    {exportName = "getTime", moduleName = "CGame", moduleMethod = "getTime"},
    {exportName = "formatMS", moduleName = "CGame", moduleMethod = "formatMS"},
    {exportName = "getLevelEXP", moduleName = "CGame", moduleMethod = "getLevelEXP"},
    {exportName = "getLevelRank", moduleName = "CGame", moduleMethod = "getLevelRank"},
    {exportName = "generateSpawn", moduleName = "CGame", moduleMethod = "generateSpawn"}
})


-----------------------------------
--[[ Function: Fetches Imports ]]--
-----------------------------------

fetchImports = function()
    return CGame.CExports
end