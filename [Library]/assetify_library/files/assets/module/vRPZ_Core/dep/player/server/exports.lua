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
    {"fetchPlayer", "CPlayer", "fetch"},
    {"setPlayerData", "CPlayer", "setData"},
    {"getPlayerData", "CPlayer", "getData"},
    {"getPlayerSerial", "CPlayer", "getSerial"},
    {"getPlayerFromSerial", "CPlayer", "getPlayer"},
    {"setPlayerChannel", "CPlayer", "setChannel"},
    {"setPlayerParty", "CPlayer", "setParty"}
})


----------------
--[[ Events ]]--
----------------

imports.addEvent("Player:onLogin", false)
imports.addEvent("Player:onLogout", false)