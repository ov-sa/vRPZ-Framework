----------------------------------------------------------------
--[[ Resource: Assetify Library
     Script: handlers: cli: updater.lua
     Author: vStudio
     Developer(s): Aviril, Tron, Mario, Аниса
     DOC: 19/10/2021
     Desc: CLI Update Handler ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local cli = cli:import()
local syncer = syncer:import()
local imports = {
    fetchRemote = fetchRemote,
    restartResource = restartResource,
    getResourceFromName = getResourceFromName,
    outputDebugString = outputDebugString
}


--TODO: WIP...
syncer.private.libraryResources = {
    updateTags = {"file", "script"},
    {
        resourceName = syncer.public.libraryName,
        resourceBackup = {
            ["settings/shared.lua"] = true,
            ["settings/server.lua"] = true
        }
    },
    --TODO: Integrate Later
    --[[
    {
        resourceName = "assetify_mapper"
    }
    ]]
}
for i = 1, #syncer.private.libraryResources, 1 do
    local j = syncer.private.libraryResources[i]
    j.resourcePointer = ":"..j.resourceName.."/"
end
syncer.private.libraryVersion = imports.getResourceInfo(resource, "version")
syncer.private.libraryVersion = (syncer.private.libraryVersion and "v."..syncer.private.libraryVersion) or "N/A"
syncer.private.libraryVersionSource = "https://raw.githubusercontent.com/ov-sa/Assetify-Library/"..syncer.private.libraryVersion.."/[Library]/"


local updateCache, onUpdateCB = nil, function(isSuccess)
    if isSuccess then
        syncer.private.libraryVersion = updateCache.libraryVersion
        syncer.private.libraryVersionSource = updateCache.libraryVersionSource
    end
    updateCache = nil
    cli.private.isBeingUpdated = nil
end


----------------------
--[[ CLI: Updater ]]--
----------------------

function cli.private:update(resourceREF, isBackwardsCompatible, resourceThread, responsePointer, isUpdationStatus)
    if isUpdationStatus ~= nil then
        imports.outputDebugString("[Assetify] | "..((isUpdationStatus and "Auto-updation successfully completed; Rebooting!") or "Auto-updation failed due to connectivity issues; Try again later..."), 3)
        if isUpdationStatus then
            local __resource = imports.getResourceFromName(resourceREF.resourceName)
            if __resource then imports.restartResource(__resource) end
        end
        onUpdateCB(isUpdationStatus)
        return true
    end
    if not responsePointer then
        --TODO: ...WIP
        for i = 1, #syncer.private.libraryResources, 1 do
            local j = syncer.private.libraryResources[i]

        end
        local resourceMeta = updateCache.libraryVersionSource..(resourceREF.resourceName).."/meta.xml"
        imports.fetchRemote(resourceMeta, function(response, status)
            if not response or not status or (status ~= 0) then return cli.private:update(resourceREF, isBackwardsCompatible, _, _, false) end
            thread:create(function(self)
                for i = 1, #syncer.private.libraryResources.updateTags, 1 do
                    for j in string.gmatch(response, "<".. syncer.private.libraryResources.updateTags[i].." src=\"(.-)\"(.-)/>") do
                        if #string.gsub(j, "%s", "") > 0 then
                            if not isBackwardsCompatible or not resourceREF.resourceBackup or not resourceREF.resourceBackup[j] then
                                cli.private:update(resourceREF, isBackwardsCompatible, self, {updateCache.libraryVersionSource..(resourceREF.resourceName).."/"..j, j})
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
    if cli.private.isBeingUpdated then return imports.outputDebugString("[Assetify] | An update request is already being processed; Kindly have patience...", 3) end
    cli.private.isBeingUpdated = true
    if isAction then imports.outputDebugString("[Assetify] | Fetching latest version; Hold up...", 3) end
    imports.fetchRemote(syncer.public.librarySource, function(response, status)
        if not response or not status or (status ~= 0) then return onUpdateCB() end
        response = table.decode(response)
        if not response or not response.tag_name then return onUpdateCB() end
        if syncer.private.libraryVersion == response.tag_name then
            if isAction then imports.outputDebugString("[Assetify] | Already upto date - "..response.tag_name, 3) end
            return onUpdateCB()
        end
        local isToBeUpdated, isAutoUpdate = (isAction and true) or settings.library.autoUpdate, (not isAction and settings.library.autoUpdate) or false
        imports.outputDebugString("[Assetify] | "..((isToBeUpdated and not isAutoUpdate and "Updating to latest version") or (isToBeUpdated and isAutoUpdate and "Auto-updating to latest version") or "Latest version available").." - "..response.tag_name, 3)
        if isToBeUpdated then
            updateCache = {
                isAutoUpdate = isAutoUpdate,
                libraryVersion = response.tag_name,
                libraryVersionSource = string.gsub(syncer.private.libraryVersionSource, syncer.private.libraryVersion, response.tag_name, 1),
                isBackwardsCompatible = string.match(syncer.private.libraryVersion, "(%d+)%.") ~= string.match(response.tag_name, "(%d+)%.")
            }
            cli.private:update()
        else
            onUpdateCB()
        end
    end)
    return true
end