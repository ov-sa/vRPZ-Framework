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
    restartResource = restartResource,
    getElementType = getElementType,
    getResourceFromName = getResourceFromName,
    outputDebugString = outputDebugString,
    addCommandHandler = addCommandHandler
}


-------------
--[[ CLI ]]--
-------------

local cli = class:create("cli")
function cli.public:import() return cli end
cli.private.validActions = {
    ["update"] = true
}


function cli.private:update(resourceREF, isBackwardsCompatible, resourceThread, responsePointer, isUpdationStatus)
    if isUpdationStatus ~= nil then
        imports.outputDebugString("[Assetify] | "..((isUpdationStatus and "Auto-updation successfully completed; Rebooting!") or "Auto-updation failed due to connectivity issues; Try again later..."), 3)
        if isUpdationStatus then
            local __resource = imports.getResourceFromName(resourceREF.resourceName)
            if __resource then imports.restartResource(__resource) end
        end
        syncer.private.onLibraryUpdateCB(isUpdationStatus)
        return true
    end
    if not responsePointer then
        --TODO: ...WIP
        for i = 1, #syncer.private.libraryResources, 1 do
            local j = syncer.private.libraryResources[i]

        end
        local resourceMeta = syncer.private.libraryUpdateCache.libraryVersionSource..(resourceREF.resourceName).."/meta.xml"
        imports.fetchRemote(resourceMeta, function(response, status)
            if not response or not status or (status ~= 0) then return cli.private:update(resourceREF, isBackwardsCompatible, _, _, false) end
            thread:create(function(self)
                for i = 1, #syncer.private.libraryResources.updateTags, 1 do
                    for j in string.gmatch(response, "<".. syncer.private.libraryResources.updateTags[i].." src=\"(.-)\"(.-)/>") do
                        if #string.gsub(j, "%s", "") > 0 then
                            if not isBackwardsCompatible or not resourceREF.resourceBackup or not resourceREF.resourceBackup[j] then
                                cli.private:update(resourceREF, isBackwardsCompatible, self, {syncer.private.libraryUpdateCache.libraryVersionSource..(resourceREF.resourceName).."/"..j, j})
                                self:pause()
                            end
                        end
                    end
                end
                cli.private:update(resourceREF, isBackwardsCompatible, self, {resourceMeta, "meta.xml", response})
                cli.private:update(resourceREF, isBackwardsCompatible, _, _, true)
            end):resume()
        end)
    else
        local isBackupToBeCreated = (resourceREF.resourceBackup and resourceREF.resourceBackup[(responsePointer[2])] and true) or false
        responsePointer[2] = resourceREF.resourcePointer..responsePointer[2]
        if isBackupToBeCreated then imports.outputDebugString("[Assetify] | Backed up <"..responsePointer[2].."> due to compatibility breaking changes; Kindly update it accordingly!", 3) end
        if responsePointer[3] then
            if isBackupToBeCreated then file:write(responsePointer[2]..".backup", file:read(responsePointer[2])) end
            file:write(responsePointer[2], responsePointer[3])
            resourceThread:resume()
        else
            imports.fetchRemote(responsePointer[1], function(response, status)
                if not response or not status or (status ~= 0) then cli.private:update(resourceREF, isBackwardsCompatible, _, _, false); return resourceThread:destroy() end
                if isBackupToBeCreated then file:write(responsePointer[2]..".backup", file:read(responsePointer[2])) end
                file:write(responsePointer[2], response)
                resourceThread:resume()
            end)
        end
    end
    return true
end

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
                isAutoUpdate = isAutoUpdate,
                libraryVersion = response.tag_name,
                libraryVersionSource = string.gsub(syncer.private.libraryVersionSource, syncer.private.libraryVersion, response.tag_name, 1),
                isBackwardsCompatible = string.match(syncer.private.libraryVersion, "(%d+)%.") ~= string.match(response.tag_name, "(%d+)%.")
            }
            cli.private:update()
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