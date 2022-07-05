----------------------------------------------------------------
--[[ Resource: Assetify Library
     Script: utilities: engine: dummy.lua
     Author: vStudio
     Developer(s): Aviril, Tron, Mario, Аниса
     DOC: 19/10/2021
     Desc: Dummy Utilities ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local syncer = syncer:import()
local imports = {
    pairs = pairs,
    tonumber = tonumber,
    isElement = isElement,
    getElementType = getElementType,
    destroyElement = destroyElement,
    createObject = createObject,
    createPed = createPed,
    createVehicle = createVehicle,
    setElementAlpha = setElementAlpha,
    setElementDoubleSided = setElementDoubleSided,
    setElementDimension = setElementDimension,
    setElementInterior = setElementInterior
}


----------------------
--[[ Class: Dummy ]]--
----------------------

local dummy = class:create("dummy", {
    buffer = {}
})

function dummy.private:fetchInstance(element)
    return (element and dummy.public.buffer[element]) or false
end

function dummy.private:validateOffset(instance, dummyData)
    if not dummy.public:isInstance(instance) then return false end
    dummyData.position, dummyData.rotation = dummyData.position or {}, dummyData.rotation or {}
    dummyData.position.x, dummyData.position.y, dummyData.position.z = imports.tonumber(dummyData.position.x) or 0, imports.tonumber(dummyData.position.y) or 0, imports.tonumber(dummyData.position.z) or 0
    dummyData.rotation.x, dummyData.rotation.y, dummyData.rotation.z = imports.tonumber(dummyData.rotation.x) or 0, imports.tonumber(dummyData.rotation.y) or 0, imports.tonumber(dummyData.rotation.z) or 0
    return true
end

function dummy.public:create(...)
    local cDummy = self:createInstance()
    if cDummy and not cDummy:load(...) then
        cDummy:destroyInstance()
        return false
    end
    return cDummy
end

function dummy.public:destroy(...)
    if not dummy.public:isInstance(self) then return false end
    return self:unload(...)
end

function dummy.public:clearElementBuffer(element)
    local cDummy = dummy.private:fetchInstance(element)
    if not cDummy then return false end
    cDummy:destroy()
    return true
end

if localPlayer then
    function dummy.public:load(assetType, assetName, assetClump, clumpMaps, dummyData, targetDummy, remoteSignature)
        if not dummy.public:isInstance(self) then return false end
        if not dummyData then return false end
        local cAsset, cData = manager:getData(assetType, assetName, syncer.librarySerial)
        if not cAsset or (cAsset.manifestData.assetClumps and (not assetClump or not cAsset.manifestData.assetClumps[assetClump])) then return false end
        if assetClump then cData = cAsset.unSynced.assetCache[assetClump].cAsset.synced end
        if not cAsset or not cData then return false end
        local dummyType = settings.assetPacks[assetType].assetType
        if not dummyType then return false end
        targetDummy = (remoteSignature and targetDummy) or false
        if not targetDummy then
            dummy.private:validateOffset(self, dummyData)
        end
        self.assetType, self.assetName = assetType, assetName
        self.syncRate = imports.tonumber(dummyData.syncRate)
        if dummyType == "object" then
            self.cModelInstance = targetDummy or imports.createObject(cData.modelID, dummyData.position.x, dummyData.position.y, dummyData.position.z, dummyData.rotation.x, dummyData.rotation.y, dummyData.rotation.z)
            if cData.collisionID then
                self.cCollisionInstance = imports.createObject(cData.collisionID, dummyData.position.x, dummyData.position.y, dummyData.position.z, dummyData.rotation.x, dummyData.rotation.y, dummyData.rotation.z)
            end
        elseif dummyType == "ped" then
            self.cModelInstance = targetDummy or imports.createPed(cData.modelID, dummyData.position.x, dummyData.position.y, dummyData.position.z, dummyData.rotation.z)
            if cData.collisionID then
                self.cCollisionInstance = imports.createPed(cData.collisionID, dummyData.position.x, dummyData.position.y, dummyData.position.z, dummyData.rotation.z)
            end
        elseif dummyType == "vehicle" then
            self.cModelInstance = targetDummy or imports.createVehicle(cData.modelID, dummyData.position.x, dummyData.position.y, dummyData.position.z, dummyData.rotation.x, dummyData.rotation.y, dummyData.rotation.z)
            if cData.collisionID then
                self.cCollisionInstance = imports.createVehicle(cData.collisionID, dummyData.position.x, dummyData.position.y, dummyData.position.z, dummyData.rotation.x, dummyData.rotation.y, dummyData.rotation.z)
            end
        end
        if not self.cModelInstance then return false end
        if self.cCollisionInstance then imports.setElementAlpha(self.cCollisionInstance, 0) end
        self.cHeartbeat = thread:createHeartbeat(function()
            if not targetDummy then
                return false
            else
                return not imports.isElement(targetDummy)
            end
        end, function()
            if dummyType == "object" then imports.setElementDoubleSided(self.cModelInstance, true) end
            network:emit("Assetify:onReceiveSyncedElement", false, self.cModelInstance, assetType, assetName, assetClump, clumpMaps, remoteSignature)
            if targetDummy then
                imports.setElementAlpha(self.cModelInstance, 255)
            else
                imports.setElementDimension(self.cModelInstance, imports.tonumber(dummyData.dimension) or 0)
                imports.setElementInterior(self.cModelInstance, imports.tonumber(dummyData.interior) or 0)
            end
            if self.cCollisionInstance then
                self.cStreamer = streamer:create(self.cModelInstance, "dummy", {self.cCollisionInstance}, self.syncRate)
            end
            self.cHeartbeat = nil
        end, settings.downloader.buildRate)
        self.cDummy = self.cCollisionInstance or self.cModelInstance
        dummy.public.buffer[(self.cDummy)] = self
        return true
    end

    function dummy.public:unload()
        if not dummy.public:isInstance(self) then return false end
        if self.cHeartbeat then self.cHeartbeat:destroy() end
        if self.cStreamer then self.cStreamer:destroy() end
        dummy.public.buffer[(self.cDummy)] = nil
        imports.destroyElement(self.cModelInstance)
        imports.destroyElement(self.cCollisionInstance)
        self:destroyInstance()
        return true
    end
else
    function dummy.public:create(assetType, assetName, assetClump, clumpMaps, dummyData)
        if not dummy.public:isInstance(self) then return false end
        if not dummyData then return false end
        local cAsset = manager:getData(assetType, assetName, syncer.librarySerial)
        if not cAsset or (cAsset.manifestData.assetClumps and (not assetClump or not cAsset.manifestData.assetClumps[assetClump])) then return false end
        if not cAsset then return false end
        local dummyType = settings.assetPacks[assetType].assetType
        if not dummyType then return false end
        targetDummy = (remoteSignature and targetDummy) or false
        local dummyType = settings.assetPacks[assetType].assetType
        if not dummyType then return false end
        dummy.private:validateOffset(self, dummyData)
        if dummyType == "object" then
            self.cModelInstance = imports.createObject(settings.assetPacks[assetType].assetBase, dummyData.position.x, dummyData.position.y, dummyData.position.z, dummyData.rotation.x, dummyData.rotation.y, dummyData.rotation.z)
        elseif dummyType == "ped" then
            self.cModelInstance = imports.createPed(settings.assetPacks[assetType].assetBase, dummyData.position.x, dummyData.position.y, dummyData.position.z, dummyData.rotation.z)
        elseif dummyType == "vehicle" then
            self.cModelInstance = imports.createVehicle(settings.assetPacks[assetType].assetBase, dummyData.position.x, dummyData.position.y, dummyData.position.z, dummyData.rotation.x, dummyData.rotation.y, dummyData.rotation.z)
        end
        if not self.cModelInstance then return false end
        imports.setElementAlpha(self.cModelInstance, 0)
        imports.setElementDimension(self.cModelInstance, imports.tonumber(dummyData.dimension) or 0)
        imports.setElementInterior(self.cModelInstance, imports.tonumber(dummyData.interior) or 0)
        return true
    end

    function dummy.public:unload()
        if not dummy.public:isInstance(self) then return false end
        dummy.public.buffer[(self.cDummy)] = nil
        imports.destroyElement(self.cModelInstance)
        self:destroyInstance()
        return true
    end

    --TODO: WIP..
    function syncer.public:syncAssetDummy(assetType, assetName, assetClump, clumpMaps, dummyData, targetPlayer, targetDummy, remoteSignature)    
        if targetPlayer then return network:emit("Assetify:Dummy:onCreation", true, false, targetPlayer, assetType, assetName, assetClump, clumpMaps, dummyData, targetDummy, remoteSignature) end
        --TODO:HERE SHOULD BE CLASS NOT OBJECT
        targetDummy = dummy:create(assetType, assetName, assetClump, clumpMaps, dummyData)
        if not targetDummy then return false end
        remoteSignature = imports.getElementType(targetDummy)
        syncer.public.syncedAssetDummies[targetDummy] = {type = assetType, name = assetName, clump = assetClump, clumpMaps = clumpMaps, dummyData = dummyData}
        thread:create(function(self)
            for i, j in imports.pairs(syncer.public.loadedClients) do
                syncer.public:syncAssetDummy(assetType, assetName, assetClump, clumpMaps, dummyData, i, targetDummy, remoteSignature)
                thread:pause()
            end
        end):resume({executions = settings.downloader.syncRate, frames = 1})
        return targetDummy
    end
end


---------------------
--[[ API Syncers ]]--
---------------------

function syncer.public:syncAssetDummy(length, ...) return dummy:create(table:unpack(table:pack(...), length or 5)) end
if localPlayer then
    network:create("Assetify:Dummy:onCreation"):on(function(...) syncer.public:syncAssetDummy(6, ...) end)
else
    network:fetch("Assetify:Downloader:onSyncPostPool", true):on(function(self, source)
        self:resume({executions = settings.downloader.syncRate, frames = 1})
        for i, j in imports.pairs(dummy.public.buffer) do
            if j and not j.isUnloading then network:emit("Assetify:Dummy:onCreation", true, false, source, self.assetType, self.assetName, self.assetClump, self.clumpMaps, self.dummyData, self.remoteSignature) end
            thread:pause()
        end
    end, true)
end
network:create("Assetify:onElementDestroy"):on(function(source)
    if not syncer.public.isLibraryBooted or not source then return false end
    dummy.public:clearElementBuffer(source)
end)