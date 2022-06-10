-----------------
--[[ Imports ]]--
-----------------

local imports = {
    network = network
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

imports.network:create("Player:onLogin")
imports.network:create("Player:onLogout")