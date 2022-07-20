----------------------------------------------------------------
--[[ Resource: Assetify Library
     Script: handlers: cli.lua
     Author: vStudio
     Developer(s): Aviril, Tron, Mario, Аниса
     DOC: 19/10/2021
     Desc: CLI Handler ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local imports = {
    type = type,
    addCommandHandler = addCommandHandler
}


-------------
--[[ CLI ]]--
-------------

imports.addCommandHandler("assetify", function(player)
    print("executed assetify command")
    print(tostring(player))
end)