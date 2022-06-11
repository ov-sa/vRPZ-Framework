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
    "setLanguage",
    "getLanguage",
    "getChannel"
})


----------------
--[[ Events ]]--
----------------

imports.network:create("Player:onLogin"):on(function(source) CPlayer.CLogged[source] = true end)
imports.network:create("Player:onLogout"):on(function(source) CPlayer.CLogged[source] = nil end)
imports.network:create("Client:onUpdateChannel"):on(CPlayer.setChannel)
imports.network:create("Client:onUpdateParty"):on(CPlayer.setParty)