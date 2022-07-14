----------------------------------------------------------------
--[[ Resource: Assetify Library
     Script: utilities: engine: downloader.lua
     Author: vStudio
     Developer(s): Aviril, Tron, Mario, Аниса
     DOC: 19/10/2021
     Desc: Downloader Utilities ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local syncer = syncer:import()
local imports = {
    type = type,
    pairs = pairs,
    md5 = md5,
    collectgarbage = collectgarbage,
    getLatentEventHandles = getLatentEventHandles
}


---------------------------
--[[ Class: Downloader ]]--
---------------------------

if localPlayer then
    function syncer.private:getDownloadProgress(assetType, assetName)
        local cDownloaded, cBandwidth = nil, nil
        if assetType and assetName then
            if settings.assetPacks[assetType] and settings.assetPacks[assetType].rwDatas[assetName] then
                local cPointer = settings.assetPacks[assetType].rwDatas[assetName]
                cBandwidth = cPointer.bandwidthData.total
                cDownloaded = (cPointer.bandwidthData.isDownloaded and cBandwidth) or (cPointer.bandwidthData.status and cPointer.bandwidthData.status.total) or 0
            end
        else
            cBandwidth = syncer.libraryBandwidth
            cDownloaded = syncer.__libraryBandwidth or 0
        end
        if cDownloaded and cBandwidth then
            cDownloaded = math.min(cDownloaded, cBandwidth)
            return cDownloaded, cBandwidth, (cDownloaded/math.max(1, cBandwidth))*100
        end
        return false
    end
    syncer.private.execOnLoad(function() network:emit("Assetify:Downloader:onPostSyncPool", true, false, localPlayer) end)
    network:create("Assetify:Downloader:onSyncBandwidth"):on(function(bandwidth) syncer.public.libraryBandwidth = bandwidth end)

    network:create("Assetify:Downloader:onSyncProgress"):on(function(assetType, assetName, file, status)
        local _, _, cProgress = syncer.private:getDownloadProgress(assetType, assetName)
        if cProgress and (cProgress ~= 100) then
            local cPointer = settings.assetPacks[assetType].rwDatas[assetName]
            cPointer.bandwidthData.status = cPointer.bandwidthData.status or {total = 0, file = {}}
            cPointer.bandwidthData.status.file[file] = cPointer.bandwidthData.status.file[file] or {}
            local currentETA, currentSize = status.tickEnd, status.percentComplete*0.01*cPointer.bandwidthData.file[file]
            cPointer.bandwidthData.status.total = cPointer.bandwidthData.status.total + (currentSize - (cPointer.bandwidthData.status.file[file].size or 0))
            cPointer.bandwidthData.status.file[file].eta, cPointer.bandwidthData.status.file[file].size = currentETA, currentSize
        end
    end)

    network:create("Assetify:Downloader:onSyncHash"):on(function(assetType, assetName, hashes)
        syncer.private.scheduledAssets[assetType] = syncer.private.scheduledAssets[assetType] or {}
        syncer.private.scheduledAssets[assetType][assetName] = syncer.private.scheduledAssets[assetType][assetName] or {bandwidthData = 0}
        thread:create(function(self)
            local fetchFiles = {}
            for i, j in imports.pairs(hashes) do
                local fileData = file:read(i)
                if not fileData or (imports.md5(fileData) ~= j) then
                    fetchFiles[i] = true
                else
                    syncer.private.scheduledAssets[assetType][assetName].bandwidthData = syncer.private.scheduledAssets[assetType][assetName].bandwidthData + settings.assetPacks[assetType].rwDatas[assetName].bandwidthData.file[i]
                    syncer.public.__libraryBandwidth = (syncer.public.__libraryBandwidth or 0) + settings.assetPacks[assetType].rwDatas[assetName].bandwidthData.file[i]
                end
                fileData = nil
                thread:pause()
            end
            network:emit("Assetify:Downloader:onSyncHash", true, true, localPlayer, assetType, assetName, fetchFiles)
            imports.collectgarbage()
        end):resume({executions = settings.downloader.buildRate, frames = 1})
    end)

    network:create("Assetify:Downloader:onSyncData"):on(function(assetType, baseIndex, subIndexes, indexData)
        settings.assetPacks[assetType] = settings.assetPacks[assetType] or {}
        if not subIndexes then
            settings.assetPacks[assetType][baseIndex] = indexData
        else
            if not settings.assetPacks[assetType][baseIndex] then settings.assetPacks[assetType][baseIndex] = {} end
            local totalIndexes = #subIndexes
            local indexPointer = settings.assetPacks[assetType][baseIndex]
            if totalIndexes > 1 then
                for i = 1, totalIndexes - 1, 1 do
                    local indexReference = subIndexes[i]
                    if not indexPointer[indexReference] then indexPointer[indexReference] = {} end
                    indexPointer = indexPointer[indexReference]
                end
            end
            indexPointer[(subIndexes[totalIndexes])] = indexData
        end
    end)

    network:create("Assetify:Downloader:onSyncContent"):on(function(assetType, assetName, contentPath, ...)
        if assetType and assetName then
            syncer.private.scheduledAssets[assetType][assetName].bandwidthData = syncer.private.scheduledAssets[assetType][assetName].bandwidthData + settings.assetPacks[assetType].rwDatas[assetName].bandwidthData.file[contentPath]
            syncer.public.__libraryBandwidth = (syncer.public.__libraryBandwidth or 0) + settings.assetPacks[assetType].rwDatas[assetName].bandwidthData.file[contentPath]
        end
        file:write(contentPath, ...)
        imports.collectgarbage()
    end)

    network:create("Assetify:Downloader:onSyncState"):on(function(assetType, assetName)
        local isPackVoid = true
        local cPointer = settings.assetPacks[assetType].rwDatas[assetName]
        syncer.private.scheduledAssets[assetType][assetName] = nil
        cPointer.bandwidthData.isDownloaded, cPointer.bandwidthData.status = true, nil
        for i, j in imports.pairs(syncer.private.scheduledAssets[assetType]) do
            if j then
                isPackVoid = false
                break
            end
        end
        if isPackVoid then
            local isSyncDone = true
            syncer.private.scheduledAssets[assetType] = nil
            for i, j in imports.pairs(syncer.private.scheduledAssets) do
                if j then
                    isSyncDone = false
                    break
                end
            end
            if isSyncDone then
                if assetType == "module" then
                    network:emit("Assetify:Downloader:onSyncPack", true, false, localPlayer)
                    thread:create(function(self)
                        if settings.assetPacks["module"].autoLoad and settings.assetPacks["module"].rwDatas then
                            for i, j in imports.pairs(settings.assetPacks["module"].rwDatas) do
                                if j then manager:loadAsset("module", i) end
                                thread:pause()
                            end
                        end
                        network:emit("Assetify:onModuleLoad", false)
                    end):resume({executions = settings.downloader.buildRate, frames = 1})
                else
                    syncer.private.scheduledAssets = nil
                    thread:create(function(self)
                        for i, j in imports.pairs(settings.assetPacks) do
                            if i ~= "module" then
                                if j.autoLoad and j.rwDatas then
                                    for k, v in imports.pairs(j.rwDatas) do
                                        if v then manager:loadAsset(i, k) end
                                        thread:pause()
                                    end
                                end
                            end
                        end
                        network:emit("Assetify:onLoad", false)
                    end):resume({executions = settings.downloader.buildRate, frames = 1})
                end
            end
        end
    end)
else
    function syncer.private:syncHash(player, ...) return network:emit("Assetify:Downloader:onSyncHash", true, true, player, ...) end
    function syncer.private:syncData(player, ...) return network:emit("Assetify:Downloader:onSyncData", true, true, player, ...) end
    function syncer.private:syncContent(player, ...) return network:emit("Assetify:Downloader:onSyncContent", true, true, player, ...) end
    function syncer.private:syncState(player, ...) return network:emit("Assetify:Downloader:onSyncState", true, true, player, ...) end
    network:create("Assetify:Downloader:onSyncHash"):on(function(source, assetType, assetName, hashes) syncer.private:syncPack(source, {type = assetType, name = assetName, hashes = hashes}) end)
    network:create("Assetify:Downloader:onSyncPack"):on(function(source) syncer.private:syncPack(source) end)

    function syncer.private:syncPack(player, assetDatas, syncModules)
        if not assetDatas then
            thread:create(function(self)
                local isLibraryVoid = true
                --TODO: MAKE HELPER FUNCTION
                for i, j in imports.pairs(settings.assetPacks) do
                    if i ~= "module" and j.assetPack then
                        for k, v in imports.pairs(j.assetPack) do
                            if k ~= "rwDatas" then
                                if syncModules then
                                    syncer.private:syncData(player, i, k, false, v)
                                end
                            else
                                for m, n in imports.pairs(v) do
                                    isLibraryVoid = false
                                    if syncModules then
                                        syncer.private:syncData(player, i, "rwDatas", {m, "bandwidthData"}, n.synced.bandwidthData)
                                    else
                                        syncer.private:syncHash(player, i, m, n.unSynced.fileHash)
                                    end
                                    thread:pause()
                                end
                            end
                            thread:pause()
                        end
                    end
                end
                if syncModules then
                    local isModuleVoid = true
                    network:emit("Assetify:Downloader:onSyncBandwidth", true, true, player, syncer.public.libraryBandwidth)
                    self:await(network:emitCallback(self, "Assetify:onRequestPreSyncPool", false, player))
                    if settings.assetPacks["module"] and settings.assetPacks["module"].assetPack then
                        for i, j in imports.pairs(settings.assetPacks["module"].assetPack) do
                            if i ~= "rwDatas" then
                                syncer.private:syncData(player, "module", i, false, j)
                            else
                                for k, v in imports.pairs(j) do
                                    isModuleVoid = false
                                    syncer.private:syncData(player, "module", "rwDatas", {k, "bandwidthData"}, v.synced.bandwidthData)
                                    syncer.private:syncHash(player, "module", k, v.unSynced.fileHash)
                                    thread:pause()
                                end
                            end
                            thread:pause()
                        end
                    end
                    if isModuleVoid then
                        network:emit("Assetify:onModuleLoad", true, true, player)
                        network:emit("Assetify:Downloader:onSyncPack", false, player)
                    end
                else
                    if isLibraryVoid then network:emit("Assetify:onLoad", true, false, player) end
                end
            end):resume({executions = settings.downloader.syncRate, frames = 1})
        else
            thread:create(function(self)
                local cAsset = settings.assetPacks[(assetDatas.type)].assetPack.rwDatas[(assetDatas.name)]
                for i, j in imports.pairs(cAsset.synced) do
                    if i ~= "bandwidthData" then
                        syncer.private:syncData(player, assetDatas.type, "rwDatas", {assetDatas.name, i}, j)
                    end
                    thread:pause()
                end
                for i, j in imports.pairs(assetDatas.hashes) do
                    syncer.private:syncContent(player, assetDatas.type, assetDatas.name, i, cAsset.unSynced.fileData[i])
                    local cQueue = imports.getLatentEventHandles(player)
                    table.insert(syncer.public.libraryClients.loading[player].cQueue, {assetType = assetDatas.type, assetName = assetDatas.name, file = i, handler = cQueue[#cQueue]})
                    thread:pause()
                end
                syncer.private:syncState(player, assetDatas.type, assetDatas.name)
            end):resume({executions = settings.downloader.syncRate, frames = 1})
        end
        return true
    end
end