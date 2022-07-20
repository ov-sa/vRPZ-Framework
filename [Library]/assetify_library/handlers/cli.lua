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
    getElementType = getElementType,
    addCommandHandler = addCommandHandler
}


-------------
--[[ CLI ]]--
-------------

local cli = class:create("cli")
cli.private.validActions = {
    ["update"] = true
}

function cli.public:update(...)
    print("EXECUTED UPDATA ACTION")
end


---------------------
--[[ API Syncers ]]--
---------------------

imports.addCommandHandler("assetify", function(isConsole, _, action, ...)
    if isConsole and (imports.getElementType(isConsole) == "console") and action and cli.private.validActions[action] then
        cli.public[action](_, ...)
    end
end)