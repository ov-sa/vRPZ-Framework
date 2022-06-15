-----------------
--[[ Imports ]]--
-----------------

local imports = {
    assetify = assetify
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
    "getChannel",
    "setParty"
})


----------------
--[[ Events ]]--
----------------

imports.assetify.network:create("Player:onLogin")
imports.assetify.network:create("Player:onLogout")