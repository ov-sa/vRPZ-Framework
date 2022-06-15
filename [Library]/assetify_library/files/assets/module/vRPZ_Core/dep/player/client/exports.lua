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
    "setLanguage",
    "getLanguage",
    "getChannel"
})


----------------
--[[ Events ]]--
----------------

imports.assetify.network:create("Player:onLogin"):on(function(source) CPlayer.CLogged[source] = true end)
imports.assetify.network:create("Player:onLogout"):on(function(source) CPlayer.CLogged[source] = nil end)
imports.assetify.network:create("Client:onUpdateChannel"):on(CPlayer.setChannel)
imports.assetify.network:create("Client:onUpdateParty"):on(CPlayer.setParty)