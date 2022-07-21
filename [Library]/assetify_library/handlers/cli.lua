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

function cli.public:update(isAction)
    if syncer.private.isLibraryBeingUpdated then return imports.outputDebugString("[Assetify] | An update is already in progress; Kindly have patience...", 3) end
    syncer.private.isLibraryBeingUpdated = true
    if isAction then imports.outputDebugString("[Assetify] | Fetching latest version; Hold up...", 3) end
    imports.fetchRemote(syncer.public.librarySource, function(response, status)
        if not response or not status or (status ~= 0) then return false end
        response = table.decode(response)
        if not response or not response.tag_name then return false end
        if syncer.private.libraryVersion == response.tag_name then
            if isAction then imports.outputDebugString("[Assetify] | Already upto date - "..response.tag_name, 3) end
            syncer.private.isLibraryBeingUpdated = false
            return false
        end
        syncer.private.libraryVersionSource = string.gsub(syncer.private.libraryVersionSource, syncer.private.libraryVersion, response.tag_name, 1)
        local isToBeUpdated, isAutoUpdate = (isAction and true) or settings.library.autoUpdate, (not isAction and settings.library.autoUpdate) or false
        imports.outputDebugString("[Assetify] | "..((isToBeUpdated and not isAutoUpdate and "Updating to latest version") or (isToBeUpdated and isAutoUpdate and "Auto-updating to latest version") or "Latest version available").." - "..response.tag_name, 3)
        if isToBeUpdated then syncer.private:updateLibrary(string.match(syncer.private.libraryVersion, "(%d+)%.") ~= string.match(response.tag_name, "(%d+)%.")) end
    end)
    return true
end


---------------------
--[[ API Syncers ]]--
---------------------

imports.addCommandHandler("assetify", function(isConsole, _, isAction, ...)
    if not isConsole or (imports.getElementType(isConsole) ~= "console") then return false end
    if not isAction or not cli.private.validActions[isAction] then return false end
    cli.public[isAction](_, true, ...)
end)