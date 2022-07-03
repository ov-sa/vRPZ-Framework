----------------------------------------------------------------
--[[ Resource: Assetify Library
     Script: utilities: syncer.lua
     Author: vStudio
     Developer(s): Aviril, Tron, Mario, Аниса
     DOC: 19/10/2021
     Desc: Syncer Utilities ]]--
----------------------------------------------------------------


--TODO: UPDATE
-----------------
--[[ Imports ]]--
-----------------

local imports = {
    type = type,
    pairs = pairs,
    md5 = md5,
    tonumber = tonumber,
    tostring = tostring,
    isElement = isElement,
    getElementType = getElementType,
    getRealTime = getRealTime,
    getThisResource = getThisResource,
    getResourceName = getResourceName,
    getResourceInfo = getResourceInfo,
    getElementsByType = getElementsByType,
    setElementModel = setElementModel,
    getElementRotation = getElementRotation,
    collectgarbage = collectgarbage,
    outputDebugString = outputDebugString,
    addEventHandler = addEventHandler,
    getResourceRootElement = getResourceRootElement,
    fetchRemote = fetchRemote,
    loadAsset = loadAsset,
    json = json
}


-----------------------
--[[ Class: Syncer ]]--
-----------------------

local syncer = class:create("syncer", {
    libraryResource = imports.getThisResource(),
    isLibraryLoaded = false,
    isModuleLoaded = false,
    libraryBandwidth = 0,
    syncedGlobalDatas = {},
    syncedEntityDatas = {},
    syncedElements = {},
    syncedAssetDummies = {},
    syncedBoneAttachments = {},
    syncedLights = {}
})
syncer.public.libraryName = imports.getResourceName(syncer.public.libraryResource)
syncer.public.librarySource = "https://api.github.com/repos/ov-sa/Assetify-Library/releases/latest"
syncer.public.librarySerial = imports.md5(syncer.public.libraryName..":"..imports.tostring(syncer.public.libraryResource)..":"..imports.json.encode(imports.getRealTime()))
function syncer.public:import() return syncer end

network:create("Assetify:onLoad")
network:create("Assetify:onUnload")
network:create("Assetify:onModuleLoad")
network:create("Assetify:onGlobalDataChange")
network:create("Assetify:onEntityDataChange")
syncer.private.execOnLoad = function(execFunc)
    local execWrapper = nil
    execWrapper = function()
        execFunc()
        network:fetch("Assetify:onLoad"):off(execWrapper)
    end
    network:fetch("Assetify:onLoad"):on(execWrapper)
    return true
end
syncer.private.execOnModuleLoad = function(execFunc)
    local execWrapper = nil
    execWrapper = function()
        execFunc()
        network:fetch("Assetify:onModuleLoad"):off(execWrapper)
    end
    network:fetch("Assetify:onModuleLoad"):on(execWrapper)
    return true
end
syncer.private.execOnLoad(function() syncer.public.isLibraryLoaded = true end)
syncer.private.execOnModuleLoad(function() syncer.public.isModuleLoaded = true end)

if localPlayer then
    settings.assetPacks = {}
    syncer.public.scheduledAssets = {}
    network:create("Assetify:onAssetLoad")
    network:create("Assetify:onAssetUnload")
    syncer.private.execOnLoad(function() network:emit("Assetify:onRequestPostSyncPool", true, false, localPlayer) end)
    function syncer.public:syncElementModel(...) return network:emit("Assetify:onRecieveSyncedElement", false, ...)end
    function syncer.public:syncAssetDummy(...) return dummy:create(...) end
    function syncer.public:syncGlobalData(...) return network:emit("Assetify:onRecieveSyncedGlobalData", false, ...) end
    function syncer.public:syncEntityData(element, data, value) return network:emit("Assetify:onRecieveSyncedEntityData", false, element, data, value) end
    function syncer.public:syncBoneAttachment(...) return bone:create(...) end
    function syncer.public:syncBoneDetachment(element, ...) if not element or not bone.buffer.element[element] then return false end; return bone.buffer.element[element]:destroy() end
    function syncer.public:syncBoneRefreshment(element, ...) if not element or not bone.buffer.element[element] then return false end; return bone.buffer.element[element]:refresh(...) end
    function syncer.public:syncClearBoneAttachment(...) return bone:clearElementBuffer(...) end

    network:create("Assetify:onRecieveBandwidth"):on(function(bandwidth) syncer.public.libraryBandwidth = bandwidth end)
    network:create("Assetify:onRecieveHash"):on(function(assetType, assetName, hashes)
        if not syncer.public.scheduledAssets[assetType] then syncer.public.scheduledAssets[assetType] = {} end
        syncer.public.scheduledAssets[assetType][assetName] = syncer.public.scheduledAssets[assetType][assetName] or {
            assetSize = 0
        }
        thread:create(function(self)
            local fetchFiles = {}
            for i, j in imports.pairs(hashes) do
                local fileData = file:read(i)
                if not fileData or (imports.md5(fileData) ~= j) then
                    fetchFiles[i] = true
                else
                    syncer.public.scheduledAssets[assetType][assetName].assetSize = syncer.public.scheduledAssets[assetType][assetName].assetSize + settings.assetPacks[assetType].rwDatas[assetName].assetSize.file[i]
                    syncer.public.__libraryBandwidth = (syncer.public.__libraryBandwidth or 0) + settings.assetPacks[assetType].rwDatas[assetName].assetSize.file[i]
                end
                fileData = nil
                thread:pause()
            end
            network:emit("Assetify:onRecieveHash", true, true, localPlayer, assetType, assetName, fetchFiles)
            imports.collectgarbage()
        end):resume({
            executions = settings.downloader.buildRate,
            frames = 1
        })
    end)

    network:create("Assetify:onRecieveData"):on(function(assetType, baseIndex, subIndexes, indexData)
        if not settings.assetPacks[assetType] then settings.assetPacks[assetType] = {} end
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

    network:create("Assetify:onRecieveContent"):on(function(assetType, assetName, contentPath, ...)
        if assetType and assetName then
            syncer.public.scheduledAssets[assetType][assetName].assetSize = syncer.public.scheduledAssets[assetType][assetName].assetSize + settings.assetPacks[assetType].rwDatas[assetName].assetSize.file[contentPath]
            syncer.public.__libraryBandwidth = (syncer.public.__libraryBandwidth or 0) + settings.assetPacks[assetType].rwDatas[assetName].assetSize.file[contentPath]
        end
        file:write(contentPath, ...)
        imports.collectgarbage()
    end)

    network:create("Assetify:onRecieveState"):on(function(assetType, assetName)
        local isTypeVoid = true
        syncer.public.scheduledAssets[assetType][assetName] = nil
        for i, j in imports.pairs(syncer.public.scheduledAssets[assetType]) do
            if j then
                isTypeVoid = false
                break
            end
        end
        if isTypeVoid then
            local isSyncDone = true
            syncer.public.scheduledAssets[assetType] = nil
            for i, j in imports.pairs(syncer.public.scheduledAssets) do
                if j then
                    isSyncDone = false
                    break
                end
            end
            if isSyncDone then
                if assetType == "module" then
                    network:emit("Assetify:onRequestSyncPack", true, false, localPlayer)
                    thread:create(function(self)
                        if settings.assetPacks["module"].autoLoad and settings.assetPacks["module"].rwDatas then
                            for i, j in imports.pairs(settings.assetPacks["module"].rwDatas) do
                                if j then
                                    imports.loadAsset("module", i)
                                end
                                thread:pause()
                            end
                        end
                        network:emit("Assetify:onModuleLoad", false)
                    end):resume({
                        executions = settings.downloader.buildRate,
                        frames = 1
                    })
                else
                    syncer.public.scheduledAssets = nil
                    thread:create(function(self)
                        for i, j in imports.pairs(settings.assetPacks) do
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
                        network:emit("Assetify:onLoad", false)
                    end):resume({
                        executions = settings.downloader.buildRate,
                        frames = 1
                    })
                end
            end
        end
    end)

    network:create("Assetify:onRecieveSyncedGlobalData"):on(function(data, value)
        if not data or (imports.type(data) ~= "string") then return false end
        local __value = syncer.public.syncedGlobalDatas[data]
        syncer.public.syncedGlobalDatas[data] = value
        network:emit("Assetify:onGlobalDataChange", false, data, __value, value)
    end)

    network:create("Assetify:onRecieveSyncedEntityData"):on(function(element, data, value, remoteSignature)
        if not element or (not remoteSignature and not imports.isElement(element)) or not data or (imports.type(data) ~= "string") then return false end
        syncer.public.syncedEntityDatas[element] = syncer.public.syncedEntityDatas[element] or {}
        local __value = syncer.public.syncedEntityDatas[element][data]
        syncer.public.syncedEntityDatas[element][data] = value
        network:emit("Assetify:onEntityDataChange", false, element, data, __value, value)
    end)

    network:create("Assetify:onRecieveSyncedElement"):on(function(element, assetType, assetName, assetClump, clumpMaps, remoteSignature)
        if not element or (not remoteSignature and not imports.isElement(element)) then return false end
        local modelID = manager:getID(assetType, assetName, assetClump)
        if modelID then
            syncer.public.syncedElements[element] = {type = assetType, name = assetName, clump = assetClump, clumpMaps = clumpMaps}
            thread:createHeartbeat(function()
                return not imports.isElement(element)
            end, function()
                if clumpMaps then
                    shader:clearElementBuffer(element, "clump")
                    local cAsset = manager:getData(assetType, assetName, syncer.public.librarySerial)
                    if cAsset and cAsset.manifestData.shaderMaps and cAsset.manifestData.shaderMaps.clump then
                        for i, j in imports.pairs(clumpMaps) do
                            if cAsset.manifestData.shaderMaps.clump[i] and cAsset.manifestData.shaderMaps.clump[i][j] then
                                shader:create(element, "clump", "Assetify_TextureClumper", i, {clumpTex = cAsset.manifestData.shaderMaps.clump[i][j].clump, clumpTex_bump = cAsset.manifestData.shaderMaps.clump[i][j].bump}, {}, cAsset.unSynced.rwCache.map, cAsset.manifestData.shaderMaps.clump[i][j], cAsset.manifestData.encryptKey)
                            end
                        end
                    end
                end
                imports.setElementModel(element, modelID)
            end, settings.downloader.buildRate)
        end
    end)

    network:create("Assetify:onRecieveAssetDummy"):on(function(...) syncer.public:syncAssetDummy(...) end)
    network:create("Assetify:onRecieveBoneAttachment"):on(function(...) syncer.public:syncBoneAttachment(...) end)
    network:create("Assetify:onRecieveBoneDetachment"):on(function(...) syncer.public:syncBoneDetachment(...) end)
    network:create("Assetify:onRecieveBoneRefreshment"):on(function(...) syncer.public:syncBoneRefreshment(...) end)
    network:create("Assetify:onRecieveClearBoneAttachment"):on(function(...) syncer.public:syncClearBoneAttachment(...) end)
    imports.addEventHandler("onClientElementDimensionChange", localPlayer, function(dimension) streamer:update(dimension) end)
    imports.addEventHandler("onClientElementInteriorChange", localPlayer, function(interior) streamer:update(_, interior) end)
    network:create("Assetify:onElementDestroy"):on(function(source)
        if not source then return false end
        shader:clearElementBuffer(source)
        dummy:clearElementBuffer(source)
        bone:clearElementBuffer(source)
        manager:clearElementBuffer(source)
        syncer.public.syncedEntityDatas[source] = nil
        for i, j in imports.pairs(light) do
            if j and (imports.type(j) == "table") and j.clearElementBuffer then
                j:clearElementBuffer(source)
            end
        end
    end)
    imports.addEventHandler("onClientElementDestroy", root, function() network:emit("Assetify:onElementDestroy", false, source) end)
else
    syncer.public.libraryVersion = imports.getResourceInfo(resource, "version")
    syncer.public.libraryVersion = (syncer.public.libraryVersion and "v."..syncer.public.libraryVersion) or syncer.public.libraryVersion
    syncer.public.loadedClients, syncer.public.scheduledClients = {}, {}
    function syncer.public:syncHash(player, ...) return network:emit("Assetify:onRecieveHash", true, false, player, ...) end
    function syncer.public:syncData(player, ...) return network:emit("Assetify:onRecieveData", true, false, player, ...) end
    function syncer.public:syncContent(player, ...) return network:emit("Assetify:onRecieveContent", true, false, player, ...) end
    function syncer.public:syncState(player, ...) return network:emit("Assetify:onRecieveState", true, false, player, ...) end

    function syncer.public:syncGlobalData(data, value, isSync, targetPlayer)
        if not data or (imports.type(data) ~= "string") then return false end
        if not targetPlayer then
            local __value = syncer.public.syncedGlobalDatas[data]
            syncer.public.syncedGlobalDatas[data] = value
            network:emit("Assetify:onGlobalDataChange", false, data, __value, value)
            local execWrapper = nil
            execWrapper = function()
                for i, j in imports.pairs(syncer.public.loadedClients) do
                    syncer.public:syncGlobalData(data, value, isSync, i)
                    if not isSync then thread:pause() end
                end
                execWrapper = nil
            end
            if isSync then
                execWrapper()
            else
                thread:create(execWrapper):resume({
                    executions = settings.downloader.syncRate,
                    frames = 1
                })
            end
        else
            network:emit("Assetify:onRecieveSyncedGlobalData", true, false, targetPlayer, data, value)
        end
        return true
    end

    function syncer.public:syncEntityData(element, data, value, isSync, targetPlayer, remoteSignature)
        if not targetPlayer then
            if not element or not imports.isElement(element) or not data or (imports.type(data) ~= "string") then return false end
            remoteSignature = imports.getElementType(element)
            syncer.public.syncedEntityDatas[element] = syncer.public.syncedEntityDatas[element] or {}
            local __value = syncer.public.syncedEntityDatas[element][data]
            syncer.public.syncedEntityDatas[element][data] = value
            network:emit("Assetify:onEntityDataChange", false, element, data, __value, value)
            local execWrapper = nil
            execWrapper = function()
                for i, j in imports.pairs(syncer.public.loadedClients) do
                    syncer.public:syncEntityData(element, data, value, isSync, i, remoteSignature)
                    if not isSync then thread:pause() end
                end
                execWrapper = nil
            end
            if isSync then
                execWrapper()
            else
                thread:create(execWrapper):resume({
                    executions = settings.downloader.syncRate,
                    frames = 1
                })
            end
        else
            network:emit("Assetify:onRecieveSyncedEntityData", true, false, targetPlayer, element, data, value, remoteSignature)
        end
        return true
    end

    function syncer.public:syncElementModel(element, assetType, assetName, assetClump, clumpMaps, targetPlayer, remoteSignature)
        if not targetPlayer then
            if not element or not imports.isElement(element) then return false end
            local cAsset = manager:getData(assetType, assetName)
            if not cAsset or (cAsset.manifestData.assetClumps and (not assetClump or not cAsset.manifestData.assetClumps[assetClump])) then return false end
            remoteSignature = imports.getElementType(element)
            syncer.public.syncedElements[element] = {type = assetType, name = assetName, clump = assetClump, clumpMaps = clumpMaps}
            thread:create(function(self)
                for i, j in imports.pairs(syncer.public.loadedClients) do
                    syncer.public:syncElementModel(element, assetType, assetName, assetClump, clumpMaps, i, remoteSignature)
                    thread:pause()
                end
            end):resume({
                executions = settings.downloader.syncRate,
                frames = 1
            })
        else
            network:emit("Assetify:onRecieveSyncedElement", true, false, targetPlayer, element, assetType, assetName, assetClump, clumpMaps, remoteSignature)
        end
        return true
    end

    function syncer.public:syncAssetDummy(assetType, assetName, assetClump, clumpMaps, dummyData, targetPlayer, targetDummy, remoteSignature)    
        if not targetPlayer then
            targetDummy = dummy:create(assetType, assetName, assetClump, clumpMaps, dummyData)
            if not targetDummy then return false end
            remoteSignature = imports.getElementType(targetDummy)
            syncer.public.syncedAssetDummies[targetDummy] = {type = assetType, name = assetName, clump = assetClump, clumpMaps = clumpMaps, dummyData = dummyData}
            thread:create(function(self)
                for i, j in imports.pairs(syncer.public.loadedClients) do
                    syncer.public:syncAssetDummy(assetType, assetName, assetClump, clumpMaps, dummyData, i, targetDummy, remoteSignature)
                    thread:pause()
                end
            end):resume({
                executions = settings.downloader.syncRate,
                frames = 1
            })
            return targetDummy
        else
            network:emit("Assetify:onRecieveAssetDummy", true, false, targetPlayer, assetType, assetName, assetClump, clumpMaps, dummyData, targetDummy, remoteSignature)
        end
        return true
    end

    function syncer.public:syncBoneAttachment(element, parent, boneData, targetPlayer, remoteSignature)
        if not targetPlayer then
            if not element or not imports.isElement(element) or not parent or not imports.isElement(parent) or not boneData then return false end
            remoteSignature = {
                parentType = imports.getElementType(parent),
                elementType = imports.getElementType(element),
                elementRotation = {imports.getElementRotation(element, "ZYX")}
            }
            syncer.public.syncedBoneAttachments[element] = {parent = parent, boneData = boneData}
            thread:create(function(self)
                for i, j in imports.pairs(syncer.public.loadedClients) do
                    syncer.public:syncBoneAttachment(element, parent, boneData, i, remoteSignature)
                    thread:pause()
                end
            end):resume({
                executions = settings.downloader.syncRate,
                frames = 1
            })
        else
            network:emit("Assetify:onRecieveBoneAttachment", true, false, targetPlayer, element, parent, boneData, remoteSignature)
        end
        return true
    end

    function syncer.public:syncBoneDetachment(element, targetPlayer)
        if not targetPlayer then
            if not element or not imports.isElement(element) or not syncer.public.syncedBoneAttachments[element] then return false end
            syncer.public.syncedBoneAttachments[element] = nil
            thread:create(function(self)
                for i, j in imports.pairs(syncer.public.loadedClients) do
                    syncer.public:syncBoneDetachment(element, i)
                    thread:pause()
                end
            end):resume({
                executions = settings.downloader.syncRate,
                frames = 1
            })
        else
            network:emit("Assetify:onRecieveBoneDetachment", true, false, targetPlayer, element)
        end
        return true
    end

    function syncer.public:syncBoneRefreshment(element, boneData, targetPlayer, remoteSignature)
        if not targetPlayer then
            if not element or not imports.isElement(element) or not boneData or not syncer.public.syncedBoneAttachments[element] then return false end
            remoteSignature = {
                elementType = imports.getElementType(element),
                elementRotation = {imports.getElementRotation(element, "ZYX")}
            }
            syncer.public.syncedBoneAttachments[element].boneData = boneData
            thread:create(function(self)
                for i, j in imports.pairs(syncer.public.loadedClients) do
                    syncer.public:syncBoneRefreshment(element, boneData, i, remoteSignature)
                    thread:pause()
                end
            end):resume({
                executions = settings.downloader.syncRate,
                frames = 1
            })
        else
            network:emit("Assetify:onRecieveBoneRefreshment", true, false, targetPlayer, element, boneData, remoteSignature)
        end
        return true
    end

    function syncer.public:syncClearBoneAttachment(element, targetPlayer)
        if not targetPlayer then
            if not element or not imports.isElement(element) then return false end
            if syncer.public.syncedBoneAttachments[element] then
                syncer.public.syncedBoneAttachments[element] = nil                                
            end
            for i, j in imports.pairs(syncer.public.syncedBoneAttachments) do
                if j and (j.parent == element) then
                    syncer.public.syncedBoneAttachments[i] = nil
                end
            end
            thread:create(function(self)
                for i, j in imports.pairs(syncer.public.loadedClients) do
                    syncer.public:syncClearBoneAttachment(element, i)
                    thread:pause()
                end
            end):resume({
                executions = settings.downloader.syncRate,
                frames = 1
            })
        else
            network:emit("Assetify:onRecieveClearBoneAttachment", true, false, targetPlayer, element)
        end
        return true
    end

    function syncer.public:syncPack(player, assetDatas, syncModules)
        if not assetDatas then
            thread:create(function(self)
                local isLibraryVoid = true
                for i, j in imports.pairs(settings.assetPacks) do
                    if i ~= "module" then
                        if j.assetPack then
                            for k, v in imports.pairs(j.assetPack) do
                                if k ~= "rwDatas" then
                                    if syncModules then
                                        syncer.public:syncData(player, i, k, false, v)
                                    end
                                else
                                    for m, n in imports.pairs(v) do
                                        isLibraryVoid = false
                                        if syncModules then
                                            syncer.public:syncData(player, i, "rwDatas", {m, "assetSize"}, n.synced.assetSize)
                                        else
                                            syncer.public:syncHash(player, i, m, n.unSynced.fileHash)
                                        end
                                        thread:pause()
                                    end
                                end
                                thread:pause()
                            end
                        end
                    end
                end
                if syncModules then
                    local isModuleVoid = true
                    network:emit("Assetify:onRecieveBandwidth", true, false, player, syncer.public.libraryBandwidth)
                    self:await(network:emitCallback(self, "Assetify:onRequestPreSyncPool", false, player))
                    if settings.assetPacks["module"] and settings.assetPacks["module"].assetPack then
                        for i, j in imports.pairs(settings.assetPacks["module"].assetPack) do
                            if i ~= "rwDatas" then
                                syncer.public:syncData(player, "module", i, false, j)
                            else
                                for k, v in imports.pairs(j) do
                                    isModuleVoid = false
                                    syncer.public:syncData(player, "module", "rwDatas", {k, "assetSize"}, v.synced.assetSize)
                                    syncer.public:syncHash(player, "module", k, v.unSynced.fileHash)
                                    thread:pause()
                                end
                            end
                            thread:pause()
                        end
                    end
                    if isModuleVoid then
                        network:emit("Assetify:onModuleLoad", true, false, player)
                        network:emit("Assetify:onRequestSyncPack", false, player)
                    end
                else
                    if isLibraryVoid then network:emit("Assetify:onLoad", true, false, player) end
                end
            end):resume({
                executions = settings.downloader.syncRate,
                frames = 1
            })
        else
            thread:create(function(self)
                local cAsset = settings.assetPacks[(assetDatas.type)].assetPack.rwDatas[(assetDatas.name)]
                for i, j in imports.pairs(cAsset.synced) do
                    if i ~= "assetSize" then
                        syncer.public:syncData(player, assetDatas.type, "rwDatas", {assetDatas.name, i}, j)
                    end
                    thread:pause()
                end
                for i, j in imports.pairs(assetDatas.hashes) do
                    syncer.public:syncContent(player, assetDatas.type, assetDatas.name, i, cAsset.unSynced.fileData[i])
                    thread:pause()
                end
                syncer.public:syncState(player, assetDatas.type, assetDatas.name)
            end):resume({
                executions = settings.downloader.syncRate,
                frames = 1
            })
        end
        return true
    end

    network:create("Assetify:onRecieveHash"):on(function(source, assetType, assetName, hashes)
        syncer.public:syncPack(source, {
            type = assetType,
            name = assetName,
            hashes = hashes
        })
    end)

    network:create("Assetify:onRequestSyncPack"):on(function(source)
        syncer.public:syncPack(source)
    end)

    network:create("Assetify:onRequestPreSyncPool", true):on(function(__self, source)
        local __source = source
        thread:create(function(self)
            local source = __source
            for i, j in imports.pairs(syncer.public.syncedGlobalDatas) do
                syncer.public:syncGlobalData(i, j, false, source)
                thread:pause()
            end
            for i, j in imports.pairs(syncer.public.syncedEntityDatas) do
                for k, v in imports.pairs(j) do
                    syncer.public:syncEntityData(i, k, v, false, source)
                    thread:pause()
                end
                thread:pause()
            end
            __self:resume()
        end):resume({
            executions = settings.downloader.syncRate,
            frames = 1
        })
        __self:pause()
        return true
    end, true)

    network:create("Assetify:onRequestPostSyncPool"):on(function(source)
        local __source = source
        thread:create(function(self)
            local source = __source
            for i, j in imports.pairs(syncer.public.syncedElements) do
                if j then
                    syncer.public:syncElementModel(i, j.type, j.name, j.clump, j.clumpMaps, source)
                end
                thread:pause()
            end
            for i, j in imports.pairs(syncer.public.syncedAssetDummies) do
                if j then
                    syncer.public:syncAssetDummy(j.type, j.name, j.clump, j.clumpMaps, j.dummyData, i, source)
                end
                thread:pause()
            end
            for i, j in imports.pairs(syncer.public.syncedBoneAttachments) do
                if j then
                    syncer.public:syncBoneAttachment(i, j.parent, j.boneData, source)
                end
                thread:pause()
            end
        end):resume({
            executions = settings.downloader.syncRate,
            frames = 1
        })
    end)

    imports.fetchRemote(syncer.public.librarySource, function(response, status)
        if not response or not status or (status ~= 0) then return false end
        response = imports.json.decode(response)
        if response and response.tag_name and (syncer.public.libraryVersion ~= response.tag_name) then
            imports.outputDebugString("[Assetify]: Latest version available - "..response.tag_name, 3)
        end
    end)
    imports.addEventHandler("onPlayerResourceStart", root, function(resourceElement)
        if imports.getResourceRootElement(resourceElement) == resourceRoot then
            if syncer.public.isLibraryLoaded then
                syncer.public.loadedClients[source] = true
                syncer.public:syncPack(source, _, true)
            else
                syncer.public.scheduledClients[source] = true
            end
        end
    end)
    imports.addEventHandler("onElementModelChange", root, function()
        syncer.public.syncedElements[source] = nil
    end)
    imports.addEventHandler("onElementDestroy", root, function()
        local __source = source
        thread:create(function(self)
            local source = __source
            if syncer.public.syncedEntityDatas[source] ~= nil then
                timer:create(function(source)
                    syncer.public.syncedEntityDatas[source] = nil
                end, settings.syncer.persistenceDuration, 1, source)
            end
            syncer.public.syncedElements[source] = nil
            syncer.public.syncedAssetDummies[source] = nil
            syncer.public.syncedLights[source] = nil
            syncer.public:syncClearBoneAttachment(source)
            for i, j in imports.pairs(syncer.public.loadedClients) do
                network:emit("Assetify:onElementDestroy", true, false, i, source)
                thread:pause()
            end
        end):resume({
            executions = settings.downloader.syncRate,
            frames = 1
        })
    end)
    imports.addEventHandler("onPlayerQuit", root, function()
        syncer.public.loadedClients[source] = nil
        syncer.public.scheduledClients[source] = nil
    end)
end
