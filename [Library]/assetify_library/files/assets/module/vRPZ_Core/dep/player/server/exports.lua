-----------------
--[[ Imports ]]--
-----------------

local imports = {
    addEvent = addEvent
}


-----------------
--[[ Exports ]]--
-----------------

CGame.exportModule("CPlayer", {
    "fetch",
    "setData",
    "getData",
    "getSerial",
    "getPlayer",
    "getInventoryID",
    "setChannel",
    "setParty"
})


----------------
--[[ Events ]]--
----------------

imports.addEvent("Player:onLogin", false)
imports.addEvent("Player:onLogout", false)