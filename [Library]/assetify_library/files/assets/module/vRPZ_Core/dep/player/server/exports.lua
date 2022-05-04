-----------------
--[[ Imports ]]--
-----------------

local imports = {
    addEvent = addEvent
}


-----------------
--[[ Exports ]]--
-----------------

CGame.createExports({
    {exportName = "fetchPlayer", moduleName = "CPlayer", moduleMethod = "fetch"},
    {exportName = "setPlayerData", moduleName = "CPlayer", moduleMethod = "setData"},
    {exportName = "getPlayerData", moduleName = "CPlayer", moduleMethod = "getData"},
    {exportName = "getPlayerSerial", moduleName = "CPlayer", moduleMethod = "getSerial"},
    {exportName = "getPlayerFromSerial", moduleName = "CPlayer", moduleMethod = "getPlayer"},
    {exportName = "setPlayerChannel", moduleName = "CPlayer", moduleMethod = "setChannel"},
    {exportName = "setPlayerParty", moduleName = "CPlayer", moduleMethod = "setParty"}
})


----------------
--[[ Events ]]--
----------------

imports.addEvent("Player:onLogin", false)
imports.addEvent("Player:onLogout", false)