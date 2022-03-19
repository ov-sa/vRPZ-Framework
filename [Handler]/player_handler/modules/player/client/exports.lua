----------------------------------------------------------------
--[[ Resource: Player Handler
     Script: modules: player: client: exports.lua
     Author: vStudio
     Developer(s): Mario, Tron, Aviril
     DOC: 31/01/2022
     Desc: Player Module ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local imports = {
    addEvent = addEvent,
    addEventHandler = addEventHandler
}


----------------
--[[ Events ]]--
----------------

imports.addEvent("Client:onUpdateChannel", true)
imports.addEventHandler("Client:onUpdateChannel", root, function(...) CPlayer.setChannel(...) end)
