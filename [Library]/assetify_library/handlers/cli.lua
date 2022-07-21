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
    if syncer.private.isLibraryBeingUpdated then return imports.outputDebugString("[Assetify] | An update request is already being processed; Kindly have patience...", 3) end
    syncer.private.isLibraryBeingUpdated, syncer.private.onLibraryUpdateCB = true, syncer.private.onLibraryUpdateCB or function(isSuccess)
        if isSuccess then
            syncer.private.libraryVersion = syncer.private.libraryUpdateCache.libraryVersion
            syncer.private.libraryVersionSource = syncer.private.libraryUpdateCache.libraryVersionSource
        end
        syncer.private.libraryUpdateCache = nil
        syncer.private.isLibraryBeingUpdated = nil
    end
    if isAction then imports.outputDebugString("[Assetify] | Fetching latest version; Hold up...", 3) end
    imports.fetchRemote(syncer.public.librarySource, function(response, status)
        if not response or not status or (status ~= 0) then return syncer.private.onLibraryUpdateCB() end
        response = table.decode(response)
        if not response or not response.tag_name then return syncer.private.onLibraryUpdateCB() end
        if syncer.private.libraryVersion == response.tag_name then
            if isAction then imports.outputDebugString("[Assetify] | Already upto date - "..response.tag_name, 3) end
            return syncer.private.onLibraryUpdateCB()
        end
        local isToBeUpdated, isAutoUpdate = (isAction and true) or settings.library.autoUpdate, (not isAction and settings.library.autoUpdate) or false
        imports.outputDebugString("[Assetify] | "..((isToBeUpdated and not isAutoUpdate and "Updating to latest version") or (isToBeUpdated and isAutoUpdate and "Auto-updating to latest version") or "Latest version available").." - "..response.tag_name, 3)
        if isToBeUpdated then
            syncer.private.libraryUpdateCache = {
                libraryVersion = response.tag_name,
                libraryVersionSource = string.gsub(syncer.private.libraryVersionSource, syncer.private.libraryVersion, response.tag_name, 1),
                isBackwardsCompatible = string.match(syncer.private.libraryVersion, "(%d+)%.") ~= string.match(response.tag_name, "(%d+)%.")
            }
            syncer.private:updateLibrary()
        else
            syncer.private.onLibraryUpdateCB()
        end
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