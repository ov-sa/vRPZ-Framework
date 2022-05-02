-----------------
--[[ Imports ]]--
-----------------

local imports = {
    pairs = pairs,
    addEvent = addEvent,
    addEventHandler = addEventHandler,
    triggerClientEvent = triggerClientEvent
}


-----------------
--[[ Exports ]]--
-----------------

function fetchPlayer(...) return CPlayer.fetch(...) end
function setPlayerData(...) return CPlayer.setData(...) end
function getPlayerData(...) return CPlayer.getData(...) end
function getPlayerSerial(...) return CPlayer.getSerial(...) end
function getPlayerFromSerial(...) return CPlayer.getPlayer(...) end
function setPlayerChannel(...) return CPlayer.setChannel(...) end
function setPlayerParty(...) return CPlayer.setParty(...) end


----------------
--[[ Events ]]--
----------------

imports.addEvent("Player:onLogin", false)
imports.addEventHandler("Player:onLogin", root, function()
    if CPlayer.CLogged[source] then return false end
    for i, j in imports.pairs(CPlayer.CLogged) do
        imports.triggerClientEvent(i, "Player:onLogin", source)
    end
    CPlayer.CLogged[source] = true
    for i, j in imports.pairs(CPlayer.CLogged) do
        imports.triggerClientEvent(source, "Player:onLogin", i)
    end
end)

imports.addEvent("Player:onLogout", false)
imports.addEventHandler("Player:onLogout", root, function()
    if not CPlayer.CLogged[source] then return false end
    for i, j in imports.pairs(CPlayer.CLogged) do
        imports.triggerClientEvent(i, "Player:onLogout", source)
    end
    CPlayer.CLogged[source] = nil
end)