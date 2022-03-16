----------------------------------------------------------------
--[[ Resource: Player Handler
     Script: modules: player: shared: exports.lua
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


-----------------
--[[ Exports ]]--
-----------------

function isPlayerInitialized(...) return CPlayer.isInitialized(...) end
function getPlayerChannel(...) return CPlayer.getChannel(...) end


----------------
--[[ Events ]]--
----------------

if localPlayer then
    imports.addEvent("Client:onUpdateChannel", true)
    imports.addEventHandler("Client:onUpdateChannel", root, function(...) CPlayer.setChannel(localPlayer, ...) end)
end