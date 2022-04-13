----------------------------------------------------------------
--[[ Resource: Player Handler
     Script: modules: player: client: exports.lua
     Author: vStudio
     Developer(s): Mario, Tron, Aviril, Аниса
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


-----------------
--[[ Exports ]]--
-----------------

function setPlayerLanguage(...) return CPlayer.setLanguage(...) end
function getPlayerLanguage(...) return CPlayer.getLanguage(...) end
function getPlayerParty(...) return CPlayer.getParty(...) end


----------------
--[[ Events ]]--
----------------

imports.addEvent("Client:onUpdateChannel", true)
imports.addEventHandler("Client:onUpdateChannel", root, function(...) CPlayer.setChannel(...) end)

imports.addEvent("Client:onUpdateParty", true)
imports.addEventHandler("Client:onUpdateParty", root, function(...) CPlayer.setParty(...) end)
