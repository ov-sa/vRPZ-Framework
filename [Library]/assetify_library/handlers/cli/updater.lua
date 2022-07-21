----------------------------------------------------------------
--[[ Resource: Assetify Library
     Script: handlers: cli: updater.lua
     Author: vStudio
     Developer(s): Aviril, Tron, Mario, Аниса
     DOC: 19/10/2021
     Desc: CLI: Updater Utilities ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local cli = cli:import()
local imports = {
    collectgarbage = collectgarbage,
    fetchRemote = fetchRemote,
    restartResource = restartResource,
    getResourceFromName = getResourceFromName,
    outputDebugString = outputDebugString
}


----------------------
--[[ CLI: Helpers ]]--
----------------------

--TODO: WIP...
local updateResources = {
    updateTags = {"file", "script"},
    fetchSource = function(base, version, ...) return (base and version and string.format(base, version, ...)) or false end,
    {
        resourceName = syncer.libraryName,
        resourceSource = "https://raw.githubusercontent.com/ov-sa/Assetify-Library/%s/[Library]/",
        resourceBackup = {
            ["settings/shared.lua"] = true,
            ["settings/server.lua"] = true
        }
    }
}
for i = 1, #updateResources, 1 do
    local j = updateResources[i]
    j.resourcePointer = ":"..j.resourceName.."/"
end

updateResources.onUpdateCB = function(isCompleted)
    if isCompleted then
        print("Library update successfully completed")
        syncer.libraryVersion = updateResources.updateCache.libraryVersion
    end
    print("Finished library update")
    updateResources.updateCache = nil
    cli.public.isLibraryBeingUpdated = nil
    imports.collectgarbage()
end


-----------------------
--[[ CLI: Handlers ]]--
-----------------------

function cli.private:update(resourcePointer, responsePointer, isUpdationStatus)
    if isUpdationStatus ~= nil then
        imports.outputDebugString("[Assetify] | "..((isUpdationStatus and "Auto-updation successfully completed; Rebooting!") or "Auto-updation failed due to connectivity issues; Try again later..."), 3)
        if isUpdationStatus then
            print("YA")
            --local __resource = imports.getResourceFromName(resourcePointer.resourceName)
            --if __resource then imports.restartResource(__resource) end
        end
        updateResources.onUpdateCB(isUpdationStatus)
        return true
    end
    if not responsePointer then
        updateResources.updateThread = thread:create(function()
            for i = 1, #updateResources, 1 do
                --TODO: ...WIP
                local resourcePointer = updateResources[i]
                local resourceMeta = updateResources.updateCache.libraryVersionSource..(resourcePointer.resourceName).."/meta.xml"
                imports.fetchRemote(resourceMeta, function(response, status)
                    if not response or not status or (status ~= 0) then
                        return cli.private:update(resourcePointer, _, false)
                    end
                    for i = 1, #updateResources.updateTags, 1 do
                        for j in string.gmatch(response, "<".. updateResources.updateTags[i].." src=\"(.-)\"(.-)/>") do
                            if #string.gsub(j, "%s", "") > 0 then
                                if not updateResources.updateCache.isBackwardCompatible or not resourcePointer.resourceBackup or not resourcePointer.resourceBackup[j] then
                                    --cli.private:update(resourcePointer, {updateResources.updateCache.libraryVersionSource..(resourcePointer.resourceName).."/"..j, j})
                                    updateResources.updateThread:pause()
                                end
                            end
                        end
                    end
                    --cli.private:update(resourcePointer, {resourceMeta, "meta.xml", response})
                    --cli.private:update(resourcePointer, _, true)
                end)
            end
        end)
        updateResources.updateThread:resume()
    else
        local isBackupToBeCreated = (resourcePointer.resourceBackup and resourcePointer.resourceBackup[(responsePointer[2])] and true) or false
        responsePointer[2] = resourcePointer.resourcePointer..responsePointer[2]
        if isBackupToBeCreated then imports.outputDebugString("[Assetify] | Backed up <"..responsePointer[2].."> due to compatibility breaking changes; Kindly update it accordingly!", 3) end
        if responsePointer[3] then
            --if isBackupToBeCreated then file:write(responsePointer[2]..".backup", file:read(responsePointer[2])) end
            --file:write(responsePointer[2], responsePointer[3])
            --updateResources.updateThread:resume()
        else
            imports.fetchRemote(responsePointer[1], function(response, status)
                --TODO: INSTEAD OF DESTROYING HANDLE IN THIS SOME HANDLER
                if not response or not status or (status ~= 0) then
                    cli.private:update(resourcePointer, _, false)
                    return updateResources.updateThread:destroy()
                end
                if isBackupToBeCreated then file:write(responsePointer[2]..".backup", file:read(responsePointer[2])) end
                --file:write(responsePointer[2], response)
                --updateResources.updateThread:resume()
            end)
        end
    end
    return true
end

function cli.public:update(isAction)
    if cli.public.isLibraryBeingUpdated then return imports.outputDebugString("[Assetify] | An update request is already being processed; Kindly have patience...", 3) end
    cli.public.isLibraryBeingUpdated = true
    if isAction then imports.outputDebugString("[Assetify] | Fetching latest version; Hold up...", 3) end
    imports.fetchRemote(syncer.librarySource, function(response, status)
        if not response or not status or (status ~= 0) then return updateResources.onUpdateCB() end
        response = table.decode(response)
        if not response or not response.tag_name then return updateResources.onUpdateCB() end
        if syncer.libraryVersion == response.tag_name then
            if isAction then imports.outputDebugString("[Assetify] | Already upto date - "..response.tag_name, 3) end
            return updateResources.onUpdateCB()
        end
        local isToBeUpdated, isAutoUpdate = (isAction and true) or settings.library.autoUpdate, (not isAction and settings.library.autoUpdate) or false
        imports.outputDebugString("[Assetify] | "..((isToBeUpdated and not isAutoUpdate and "Updating to latest version") or (isToBeUpdated and isAutoUpdate and "Auto-updating to latest version") or "Latest version available").." - "..response.tag_name, 3)
        if not isToBeUpdated then return updateResources.onUpdateCB() end
        updateResources.updateCache = {
            isAutoUpdate = isAutoUpdate,
            libraryVersion = response.tag_name,
            libraryVersionSource = updateResources.fetchSource(updateResources[1].resourceSource, response.tag_name),
            isBackwardCompatible = string.match(syncer.libraryVersion, "(%d+)%.") ~= string.match(response.tag_name, "(%d+)%.")
        }
        cli.private:update()
    end)
    return true
end