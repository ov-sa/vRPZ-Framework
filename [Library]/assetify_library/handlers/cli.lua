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

local syncer = syncer:import()
local imports = {
    fetchRemote = fetchRemote,
    getElementType = getElementType,
    outputDebugString = outputDebugString,
    addCommandHandler = addCommandHandler
}


-------------
--[[ CLI ]]--
-------------

local cli = class:create("cli")
cli.private.validActions = {
    ["update"] = true
}

function cli.public:update(isBoot, isAutoUpdate, isBackwardsCompatible)
    if isBoot then
        imports.fetchRemote(syncer.public.librarySource, function(response, status)
            if not response or not status or (status ~= 0) then return false end
            response = table.decode(response)
            if response and response.tag_name and (syncer.private.libraryVersion ~= response.tag_name) then
                syncer.private.libraryVersionSource = string.gsub(syncer.private.libraryVersionSource, syncer.private.libraryVersion, response.tag_name, 1)
                imports.outputDebugString("[Assetify] | "..((settings.library.autoUpdate and "Auto-updating to latest version") or "Latest version available").." - "..response.tag_name, 3)
                if settings.library.autoUpdate then  cli.public:update(_, true, string.match(syncer.private.libraryVersion, "(%d+)%.") == string.match(response.tag_name, "(%d+)%.")) end
            end
        end)
    else
        imports.outputDebugString("[Assetify] | "..((isAutoUpdate and "Auto-updating to latest version") or "Latest version available").." - "..response.tag_name, 3)
        for i = 1, #syncer.private.libraryResources, 1 do
            local j = syncer.private.libraryResources[i]
            syncer.private:updateLibrary(j, isBackwardsCompatible)
        end
    end
    return true
end


---------------------
--[[ API Syncers ]]--
---------------------

imports.addCommandHandler("assetify", function(isConsole, _, isAction, ...)
    if not isConsole or (imports.getElementType(isConsole) ~= "console") then return false end
    if not isAction or not cli.private.validActions[isAction] then return false end
    cli.public[isAction](_, ...)
end)