----------------------------------------------------------------
--[[ Resource: Assetify Library
     Script: utilities: syncer.lua
     Author: vStudio
     Developer(s): Aviril, Tron
     DOC: 19/10/2021
     Desc: Syncer Utilities ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local imports = {
    type = type,
    pairs = pairs,
    md5 = md5,
    tostring = tostring,
    isElement = isElement,
    getRealTime = getRealTime,
    getThisResource = getThisResource,
    getResourceName = getResourceName,
    getResourceInfo = getResourceInfo,
    getElementsByType = getElementsByType,
    setElementModel = setElementModel,
    collectgarbage = collectgarbage,
    outputDebugString = outputDebugString,
    addEvent = addEvent,
    addEventHandler = addEventHandler,
    getResourceRootElement = getResourceRootElement,
    fetchRemote = fetchRemote,
    triggerClientEvent = triggerClientEvent,
    triggerLatentClientEvent = triggerLatentClientEvent,
    loadAsset = loadAsset,
    file = file,
    json = json
}


-----------------------
--[[ Class: Syncer ]]--
-----------------------

syncer = {
    libraryResource = imports.getThisResource(),
    isLibraryLoaded = false,
    isModuleLoaded = false,
    libraryBandwidth = 0,
    syncedGlobalDatas = {},
    syncedElementDatas = {},
    syncedElements = {},
    syncedLights = {}
}
syncer.libraryName = imports.getResourceName(syncer.libraryResource)
syncer.librarySource = "https://api.github.com/repos/ov-sa/Assetify-Library/releases/latest"
syncer.librarySerial = imports.md5(imports.getResourceName(syncer.libraryResource)..":"..imports.tostring(syncer.libraryResource)..":"..imports.json.encode(imports.getRealTime()))
syncer.__index = syncer

network:create("onAssetifyLoad")
network:create("onAssetifyUnLoad")
network:create("onAssetifyModuleLoad")
syncer.execOnLoad = function(execFunc)
    local execWrapper = nil
    execWrapper = function()
        execFunc()
        network:destroy("onAssetifyLoad")
    end
    network:fetch("onAssetifyLoad"):on(execWrapper)
    return true
end
syncer.execOnModuleLoad = function(execFunc)
    local execWrapper = nil
    execWrapper = function()
        execFunc()
        network:destroy("onAssetifyModuleLoad")
    end
    network:fetch("onAssetifyModuleLoad"):on(execWrapper)
    return true
end
syncer.execOnLoad(function() syncer.isLibraryLoaded = true end)
syncer.execOnModuleLoad(function() syncer.isModuleLoaded = true end)

if localPlayer then
    syncer.scheduledAssets = {}
    availableAssetPacks = {}
    network:create("onAssetLoad")
    network:create("onAssetUnLoad")

    function syncer:syncElementModel(...)
        return network:emit("Assetify:onRecieveSyncedElement", false, ...)
    end

    function syncer:syncBoneAttachment(...)
        return network:emit("Assetify:onRecieveBoneAttachment", false, ...)
    end

    function syncer:syncBoneDetachment(...)
        return network:emit("Assetify:onRecieveBoneDetachment", false, ...)
    end

    function syncer:syncBoneRefreshment(...)
        return network:emit("Assetify:onRecieveBoneRefreshment", false, ...)
    end

    function syncer:syncClearBoneAttachment(...)
        return network:emit("Assetify:onRecieveClearBoneAttachment", false, ...)
    end

    network:fetch("onAssetifyLoad"):on(function()
        network:emit("Assetify:onRequestSyncedPool", true, false, localPlayer)
    end)

    network:create("Assetify:onRecieveBandwidth"):on(function(libraryBandwidth)
        syncer.libraryBandwidth = libraryBandwidth
    end)

    network:create("Assetify:onRecieveHash"):on(function(assetType, assetName, hashes)
        if not syncer.scheduledAssets[assetType] then syncer.scheduledAssets[assetType] = {} end
        syncer.scheduledAssets[assetType][assetName] = syncer.scheduledAssets[assetType][assetName] or {
            assetSize = 0
        }
        thread:create(function(cThread)
            local fetchFiles = {}
            for i, j in imports.pairs(hashes) do
                local fileData = imports.file.read(i)
                if not fileData or (imports.md5(fileData) ~= j) then
                    fetchFiles[i] = true
                else
                    syncer.scheduledAssets[assetType][assetName].assetSize = syncer.scheduledAssets[assetType][assetName].assetSize + availableAssetPacks[assetType].rwDatas[assetName].assetSize.file[i]
                    syncer.__libraryBandwidth = (syncer.__libraryBandwidth or 0) + availableAssetPacks[assetType].rwDatas[assetName].assetSize.file[i]
                end
                fileData = nil
                thread:pause()
            end
            network:emit("Assetify:onRecieveHash", true, true, localPlayer, assetType, assetName, fetchFiles)
            imports.collectgarbage()
        end):resume({
            executions = downloadSettings.buildRate,
            frames = 1
        })
    end)

    network:create("Assetify:onRecieveData"):on(function(assetType, baseIndex, subIndexes, indexData)
        if not availableAssetPacks[assetType] then availableAssetPacks[assetType] = {} end
        if not subIndexes then
            availableAssetPacks[assetType][baseIndex] = indexData
        else
            if not availableAssetPacks[assetType][baseIndex] then availableAssetPacks[assetType][baseIndex] = {} end
            local totalIndexes = #subIndexes
            local indexPointer = availableAssetPacks[assetType][baseIndex]
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

    network:create("Assetify:onRecieveContent"):on(function(assetType, assetName, contentPath, ...)
        if assetType and assetName then
            syncer.scheduledAssets[assetType][assetName].assetSize = syncer.scheduledAssets[assetType][assetName].assetSize + availableAssetPacks[assetType].rwDatas[assetName].assetSize.file[contentPath]
            syncer.__libraryBandwidth = (syncer.__libraryBandwidth or 0) + availableAssetPacks[assetType].rwDatas[assetName].assetSize.file[contentPath]
        end
        imports.file.write(contentPath, ...)
        imports.collectgarbage()
    end)

    network:create("Assetify:onRecieveState"):on(function(assetType, assetName)
        local isTypeVoid = true
        syncer.scheduledAssets[assetType][assetName] = nil
        for i, j in imports.pairs(syncer.scheduledAssets[assetType]) do
            if j then
                isTypeVoid = false
                break
            end
        end
        if isTypeVoid then
            local isSyncDone = true
            syncer.scheduledAssets[assetType] = nil
            for i, j in imports.pairs(syncer.scheduledAssets) do
                if j then
                    isSyncDone = false
                    break
                end
            end
            if isSyncDone then
                if assetType == "module" then
                    network:emit("Assetify:onRequestAssets", true, false, localPlayer)
                    thread:create(function(cThread)
                        if availableAssetPacks["module"].autoLoad and availableAssetPacks["module"].rwDatas then
                            for i, j in imports.pairs(availableAssetPacks["module"].rwDatas) do
                                if j then
                                    imports.loadAsset("module", i)
                                end
                                thread:pause()
                            end
                        end
                        network:emit("onAssetifyModuleLoad", false)
                    end):resume({
                        executions = downloadSettings.buildRate,
                        frames = 1
                    })
                else
                    syncer.scheduledAssets = nil
                    thread:create(function(cThread)
                        for i, j in imports.pairs(availableAssetPacks) do
                            if i ~= "module" then
                                if j.autoLoad and j.rwDatas then
                                    for k, v in imports.pairs(j.rwDatas) do
                                        if v then
                                            imports.loadAsset(i, k)
                                        end
                                        thread:pause()
                                    end
                                end
                            end
                        end
                        network:emit("onAssetifyLoad", false)
                    end):resume({
                        executions = downloadSettings.buildRate,
                        frames = 1
                    })
                end
            end
        end
    end)

    network:create("Assetify:onRecieveSyncedGlobalData"):on(function(data, value)
        syncer.syncedGlobalDatas[data] = value
    end)

    network:create("Assetify:onRecieveSyncedElementData"):on(function(element, data, value)
        if not element or not imports.isElement(element) then return false end
        syncer.syncedElementDatas[element] = syncer.syncedElementDatas[element] or {}
        syncer.syncedElementDatas[element][data] = value
    end)

    network:create("Assetify:onRecieveSyncedElement"):on(function(element, assetType, assetName, assetClump, clumpMaps)
        if not element or not imports.isElement(element) then return false end
        local modelID = manager:getID(assetType, assetName, assetClump)
        if modelID then
            syncer.syncedElements[element] = {type = assetType, name = assetName, clump = assetClump, clumpMaps = clumpMaps}
            shader:clearElementBuffer(element, "clump")
            if clumpMaps then
                local cAsset = manager:getData(assetType, assetName)
                if cAsset and cAsset.manifestData.shaderMaps and cAsset.manifestData.shaderMaps.clump then
                    for i, j in imports.pairs(clumpMaps) do
                        if cAsset.manifestData.shaderMaps.clump[i] and cAsset.manifestData.shaderMaps.clump[i][j] then
                            shader:create(element, "clump", "Assetify_TextureClumper", i, {clumpTex = cAsset.manifestData.shaderMaps.clump[i][j].clump, clumpTex_bump = cAsset.manifestData.shaderMaps.clump[i][j].bump}, {}, cAsset.unSynced.rwCache.map, cAsset.manifestData.shaderMaps.clump[i][j], cAsset.manifestData.encryptKey)
                        end
                    end
                end
            end
            imports.setElementModel(element, modelID)
        end
    end)

    network:create("Assetify:onRecieveBoneAttachment"):on(function(...)
        bone:create(...)
    end)

    network:create("Assetify:onRecieveBoneDetachment"):on(function(element)
        if not element or not imports.isElement(element) or not bone.buffer.element[element] then return false end
        bone.buffer.element[element]:destroy()
    end)

    network:create("Assetify:onRecieveBoneRefreshment"):on(function(element, ...)
        if not element or not imports.isElement(element) or not bone.buffer.element[element] then return false end
        bone.buffer.element[element]:refresh(...)
    end)

    network:create("Assetify:onRecieveClearBoneAttachment"):on(function(element, ...)
        if not element or not imports.isElement(element) or not bone.buffer.element[element] then return false end
        bone.buffer.element[element]:clearElementBuffer(...)
    end)

    imports.addEventHandler("onClientElementDimensionChange", localPlayer, function(dimension) streamer:update(dimension) end)
    imports.addEventHandler("onClientElementInteriorChange", localPlayer, function(interior) streamer:update(_, interior) end)
else
    syncer.libraryVersion = imports.getResourceInfo(resource, "version")
    syncer.libraryVersion = (syncer.libraryVersion and "v."..syncer.libraryVersion) or syncer.libraryVersion
    syncer.loadedClients = {}
    syncer.scheduledClients = {}
    syncer.syncedBoneAttachments = {}

    function syncer:syncHash(player, ...)
        return imports.triggerLatentClientEvent(player, "Assetify:onRecieveHash", downloadSettings.speed, false, player, ...)
    end

    function syncer:syncData(player, ...)
        return imports.triggerLatentClientEvent(player, "Assetify:onRecieveData", downloadSettings.speed, false, player, ...)
    end

    function syncer:syncContent(player, ...)
        return imports.triggerLatentClientEvent(player, "Assetify:onRecieveContent", downloadSettings.speed, false, player, ...)
    end

    function syncer:syncState(player, ...)
        return imports.triggerLatentClientEvent(player, "Assetify:onRecieveState", downloadSettings.speed, false, player, ...)
    end

    function syncer:syncGlobalData(data, value, targetPlayer)
        if not element or not imports.isElement(element) then return false end
        if not targetPlayer then
            thread:create(function(cThread)
                for i, j in imports.pairs(syncer.loadedClients) do
                    syncer:syncGlobalData(data, value, i)
                    thread:pause()
                end
            end):resume({
                executions = downloadSettings.syncRate,
                frames = 1
            })
        else
            network:emit("Assetify:onRecieveSyncedGlobalData", true, false, data, value)
        end
        return true
    end

    function syncer:syncElementData(element, data, value, targetPlayer)
        if not targetPlayer then
            if not element or not imports.isElement(element) then return false end
            thread:create(function(cThread)
                for i, j in imports.pairs(syncer.loadedClients) do
                    syncer:syncElementData(element, data, value, i)
                    thread:pause()
                end
            end):resume({
                executions = downloadSettings.syncRate,
                frames = 1
            })
        else
            network:emit("Assetify:onRecieveSyncedElementData", true, false, element, data, value)
        end
        return true
    end

    function syncer:syncElementModel(element, assetType, assetName, assetClump, clumpMaps, targetPlayer)
        if not targetPlayer then
            if not element or not imports.isElement(element) then return false end
            local cAsset = manager:getData(assetType, assetName)
            if not cAsset or (cAsset.manifestData.assetClumps and (not assetClump or not cAsset.manifestData.assetClumps[assetClump])) then return false end
            syncer.syncedElements[element] = {type = assetType, name = assetName, clump = assetClump, clumpMaps = clumpMaps}
            thread:create(function(cThread)
                for i, j in imports.pairs(syncer.loadedClients) do
                    syncer:syncElementModel(element, assetType, assetName, assetClump, clumpMaps, i)
                    thread:pause()
                end
            end):resume({
                executions = downloadSettings.syncRate,
                frames = 1
            })
        else
            imports.triggerClientEvent(targetPlayer, "Assetify:onRecieveSyncedElement", targetPlayer, element, assetType, assetName, assetClump, clumpMaps)
        end
        return true
    end

    function syncer:syncBoneAttachment(element, parent, boneData, targetPlayer)
        if not targetPlayer then
            if not element or not imports.isElement(element) or not parent or not imports.isElement(parent) or not boneData then return false end
            syncer.syncedBoneAttachments[element] = {parent = parent, boneData = boneData}
            thread:create(function(cThread)
                for i, j in imports.pairs(syncer.loadedClients) do
                    syncer:syncBoneAttachment(element, parent, boneData, j)
                    thread:pause()
                end
            end):resume({
                executions = downloadSettings.syncRate,
                frames = 1
            })
        else
            imports.triggerClientEvent(targetPlayer, "Assetify:onRecieveBoneAttachment", targetPlayer, element, parent, boneData)
        end
        return true
    end

    function syncer:syncBoneDetachment(element, targetPlayer)
        if not targetPlayer then
            if not element or not imports.isElement(element) or not syncer.syncedBoneAttachments[element] then return false end
            syncer.syncedBoneAttachments[element] = nil
            thread:create(function(cThread)
                for i, j in imports.pairs(syncer.loadedClients) do
                    syncer:syncBoneDetachment(element, j)
                    thread:pause()
                end
            end):resume({
                executions = downloadSettings.syncRate,
                frames = 1
            })
        else
            imports.triggerClientEvent(targetPlayer, "Assetify:onRecieveBoneDetachment", targetPlayer, element)
        end
        return true
    end

    function syncer:syncBoneRefreshment(element, boneData, targetPlayer)
        if not targetPlayer then
            if not element or not imports.isElement(element) or not boneData or not syncer.syncedBoneAttachments[element] then return false end
            syncer.syncedBoneAttachments[element].boneData = boneData
            thread:create(function(cThread)
                for i, j in imports.pairs(syncer.loadedClients) do
                    syncer:syncBoneRefreshment(element, boneData, j)
                    thread:pause()
                end
            end):resume({
                executions = downloadSettings.syncRate,
                frames = 1
            })
        else
            imports.triggerClientEvent(targetPlayer, "Assetify:onRecieveBoneRefreshment", targetPlayer, element, boneData)
        end
        return true
    end

    function syncer:syncClearBoneAttachment(element, targetPlayer)
        if not targetPlayer then
            if not element or not imports.isElement(element) then return false end
            if syncer.syncedBoneAttachments[element] then
                syncer.syncedBoneAttachments[element] = nil                                
            end
            for i, j in imports.pairs(syncer.syncedBoneAttachments) do
                if j and (j.parent == element) then
                    syncer.syncedBoneAttachments[i] = nil
                end
            end
            thread:create(function(cThread)
                for i, j in imports.pairs(syncer.loadedClients) do
                    syncer:syncClearBoneAttachment(element, j)
                    thread:pause()
                end
            end):resume({
                executions = downloadSettings.syncRate,
                frames = 1
            })
        else
            imports.triggerClientEvent(targetPlayer, "Assetify:onRecieveClearBoneAttachment", targetPlayer, element)
        end
        return true
    end

    function syncer:syncPack(player, assetDatas, syncModules)
        if not assetDatas then
            thread:create(function(cThread)
                if syncModules then
                    local isModuleVoid = true
                    imports.triggerClientEvent(player, "Assetify:onRecieveBandwidth", player, syncer.libraryBandwidth)
                    if availableAssetPacks["module"] and availableAssetPacks["module"].assetPack then
                        for i, j in imports.pairs(availableAssetPacks["module"].assetPack) do
                            if i ~= "rwDatas" then
                                syncer:syncData(player, "module", i, nil, j)
                            else
                                for k, v in imports.pairs(j) do
                                    isModuleVoid = false
                                    syncer:syncData(player, "module", "rwDatas", {k, "assetSize"}, v.synced.assetSize)
                                    syncer:syncHash(player, "module", k, v.unSynced.fileHash)
                                    thread:pause()
                                end
                            end
                            thread:pause()
                        end
                    end
                    if isModuleVoid then
                        network:emit("onAssetifyModuleLoad", true, false)
                        network:emit("Assetify:onRequestAssets", false, player)
                    end
                else
                    local isLibraryVoid = true
                    for i, j in imports.pairs(availableAssetPacks) do
                        if i ~= "module" then
                            if j.assetPack then
                                for k, v in imports.pairs(j.assetPack) do
                                    if k ~= "rwDatas" then
                                        syncer:syncData(player, i, k, nil, v)
                                    else
                                        for m, n in imports.pairs(v) do
                                            isLibraryVoid = false
                                            syncer:syncData(player, i, "rwDatas", {m, "assetSize"}, n.synced.assetSize)
                                            syncer:syncHash(player, i, m, n.unSynced.fileHash)
                                            thread:pause()
                                        end
                                    end
                                    thread:pause()
                                end
                            end
                        end
                    end
                    if isLibraryVoid then imports.triggerClientEvent(player, "onAssetifyLoad", resourceRoot) end
                end
            end):resume({
                executions = downloadSettings.syncRate,
                frames = 1
            })
        else
            thread:create(function(cThread)
                local cAsset = availableAssetPacks[(assetDatas.type)].assetPack.rwDatas[(assetDatas.name)]
                for i, j in imports.pairs(cAsset.synced) do
                    if i ~= "assetSize" then
                        syncer:syncData(player, assetDatas.type, "rwDatas", {assetDatas.name, i}, j)
                    end
                    thread:pause()
                end
                for i, j in imports.pairs(assetDatas.hashes) do
                    syncer:syncContent(player, assetDatas.type, assetDatas.name, i, cAsset.unSynced.fileData[i])
                    thread:pause()
                end
                syncer:syncState(player, assetDatas.type, assetDatas.name)
            end):resume({
                executions = downloadSettings.syncRate,
                frames = 1
            })
        end
        return true
    end

    network:create("Assetify:onRecieveHash"):on(function(source, assetType, assetName, hashes)
        syncer:syncPack(source, {
            type = assetType,
            name = assetName,
            hashes = hashes
        })
    end)

    network:create("Assetify:onRequestAssets"):on(function(source)
        syncer:syncPack(source)
    end)

    network:create("Assetify:onRequestSyncedPool"):on(function(source)
        local __source = source
        thread:create(function(cThread)
            local source = __source
            for i, j in imports.pairs(syncer.syncedGlobalDatas) do
                syncer:syncGlobalData(i, j, source)
                thread:pause()
            end
            for i, j in imports.pairs(syncer.syncedElementDatas) do
                for k, v in pairs(j) do
                    syncer:syncElementData(i, k, v, source)
                    thread:pause()
                end
                thread:pause()
            end
            for i, j in imports.pairs(syncer.syncedElements) do
                if j then
                    syncer:syncElementModel(i, j.type, j.name, j.clump, j.clumpMaps, source)
                end
                thread:pause()
            end
            for i, j in imports.pairs(syncer.syncedBoneAttachments) do
                if j then
                    syncer:syncBoneAttachment(i, j.parent, j.boneData, source)
                end
                thread:pause()
            end
        end):resume({
            executions = downloadSettings.syncRate,
            frames = 1
        })
    end)

    imports.addEventHandler("onPlayerResourceStart", root, function(resourceElement)
        if imports.getResourceRootElement(resourceElement) == resourceRoot then
            if syncer.isLibraryLoaded then
                syncer.loadedClients[source] = true
                syncer:syncPack(source, _, true)
            else
                syncer.scheduledClients[source] = true
            end
        end
    end)

    imports.fetchRemote(syncer.librarySource, function(response, status)
        if not response or not status or (status ~= 0) then return false end
        response = imports.json.decode(response)
        if response and response.tag_name and (syncer.libraryVersion ~= response.tag_name) then
            imports.outputDebugString("[Assetify]: Latest version available - "..response.tag_name, 3)
        end
    end)
    imports.addEventHandler("onElementModelChange", root, function()
        syncer.syncedElements[source] = nil
    end)
    imports.addEventHandler("onElementDestroy", root, function()
        syncer.syncedElements[source] = nil
        syncer.syncedElementDatas[source] = nil
    end)
    imports.addEventHandler("onPlayerQuit", root, function()
        syncer.loadedClients[source] = nil
        syncer.scheduledClients[source] = nil
        syncer.syncedElements[source] = nil
        syncer:syncClearBoneAttachment(source)
        for i, j in imports.pairs(syncer.syncedBoneAttachments) do
            if j and (j.parent == source) then
                syncer:syncClearBoneAttachment(i)
            end
        end
    end)
end