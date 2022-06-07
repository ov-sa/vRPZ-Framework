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
    "getLevelEXP",
    "getLevelRank",
    "generateSpawn"
})


-----------------------------------
--[[ Function: Fetches Imports ]]--
-----------------------------------

fetchImports = function()
    return CGame.CExports
end