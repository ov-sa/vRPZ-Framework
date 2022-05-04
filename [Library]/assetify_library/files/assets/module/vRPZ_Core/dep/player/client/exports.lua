-----------------
--[[ Imports ]]--
-----------------

local imports = {
    addEvent = addEvent,
    addEventHandler = addEventHandler
}


-----------------
--[[ Exports ]]--
-----------------

CGame.createExports({
    {exportName = "setPlayerLanguage", moduleName = "CPlayer", moduleMethod = "setLanguage"},
    {exportName = "getPlayerLanguage", moduleName = "CPlayer", moduleMethod = "getLanguage"},
    {exportName = "getPlayerParty", moduleName = "CPlayer", moduleMethod = "getParty"}
})


----------------
--[[ Events ]]--
----------------

imports.addEvent("Player:onLogin", true)
imports.addEventHandler("Player:onLogin", root, function() CPlayer.CLogged[source] = true end)

imports.addEvent("Player:onLogout", true)
imports.addEventHandler("Player:onLogout", root, function() CPlayer.CLogged[source] = nil end)

imports.addEvent("Client:onUpdateChannel", true)
imports.addEventHandler("Client:onUpdateChannel", root, function(...) CPlayer.setChannel(...) end)

imports.addEvent("Client:onUpdateParty", true)
imports.addEventHandler("Client:onUpdateParty", root, function(...) CPlayer.setParty(...) end)
