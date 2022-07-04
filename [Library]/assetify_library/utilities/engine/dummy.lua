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

if localPlayer then
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
        if not element or not dummy.public.buffer[element] then return false end
        dummy.public.buffer[element]:destroy()
        return true
    end

    function dummy.public:load(assetType, assetName, assetClump, clumpMaps, dummyData, targetDummy, remoteSignature)
        if not dummy.public:isInstance(self) then return false end
        if not dummyData then return false end
        targetDummy = (remoteSignature and targetDummy) or false
        local cAsset, cData = manager:getData(assetType, assetName, syncer.librarySerial)
        if not cAsset or (cAsset.manifestData.assetClumps and (not assetClump or not cAsset.manifestData.assetClumps[assetClump])) then return false end
        if assetClump then cData = cAsset.unSynced.assetCache[assetClump].cAsset.synced end
        if not cAsset or not cData then return false end
        local dummyType = settings.assetPacks[assetType].assetType
        if not dummyType then return false end
        if not targetDummy then
            dummyData.position, dummyData.rotation = dummyData.position or {}, dummyData.rotation or {}
            dummyData.position.x, dummyData.position.y, dummyData.position.z = imports.tonumber(dummyData.position.x) or 0, imports.tonumber(dummyData.position.y) or 0, imports.tonumber(dummyData.position.z) or 0
            dummyData.rotation.x, dummyData.rotation.y, dummyData.rotation.z = imports.tonumber(dummyData.rotation.x) or 0, imports.tonumber(dummyData.rotation.y) or 0, imports.tonumber(dummyData.rotation.z) or 0
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
            network:emit("Assetify:onRecieveSyncedElement", false, self.cModelInstance, assetType, assetName, assetClump, clumpMaps, remoteSignature)
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
        if not dummy.public:isInstance(self) or self.isUnloading then return false end
        self.isUnloading = true
        if self.cHeartbeat then
            self.cHeartbeat:destroy()
        end
        if self.cStreamer then
            self.cStreamer:destroy()
        end
        dummy.public.buffer[(self.cDummy)] = nil
        if self.cModelInstance and imports.isElement(self.cModelInstance) then
            imports.destroyElement(self.cModelInstance)
        end
        if self.cCollisionInstance and imports.isElement(self.cCollisionInstance) then
            imports.destroyElement(self.cCollisionInstance)
        end
        self:destroyInstance()
        return true
    end

    --->>> API Syncers <<<---
    function syncer.public:syncAssetDummy(...) return dummy:create(...) end
    network:create("Assetify:onRecieveAssetDummy"):on(function(...) syncer.public:syncAssetDummy(...) end)
else
    function dummy.public:create(assetType, assetName, assetClump, clumpMaps, dummyData)
        if not dummyData then return false end
        local cAsset = manager:getData(assetType, assetName)
        if not cAsset or (cAsset.manifestData.assetClumps and (not assetClump or not cAsset.manifestData.assetClumps[assetClump])) then return false end
        local dummyType = settings.assetPacks[assetType].assetType
        if not dummyType then return false end
        local cDummy = false
        dummyData.position, dummyData.rotation = dummyData.position or {}, dummyData.rotation or {}
        dummyData.position.x, dummyData.position.y, dummyData.position.z = imports.tonumber(dummyData.position.x) or 0, imports.tonumber(dummyData.position.y) or 0, imports.tonumber(dummyData.position.z) or 0
        dummyData.rotation.x, dummyData.rotation.y, dummyData.rotation.z = imports.tonumber(dummyData.rotation.x) or 0, imports.tonumber(dummyData.rotation.y) or 0, imports.tonumber(dummyData.rotation.z) or 0
        if dummyType == "object" then
            cDummy = imports.createObject(settings.assetPacks[assetType].assetBase, dummyData.position.x, dummyData.position.y, dummyData.position.z, dummyData.rotation.x, dummyData.rotation.y, dummyData.rotation.z)
        elseif dummyType == "ped" then
            cDummy = imports.createPed(settings.assetPacks[assetType].assetBase, dummyData.position.x, dummyData.position.y, dummyData.position.z, dummyData.rotation.z)
        elseif dummyType == "vehicle" then
            cDummy = imports.createVehicle(settings.assetPacks[assetType].assetBase, dummyData.position.x, dummyData.position.y, dummyData.position.z, dummyData.rotation.x, dummyData.rotation.y, dummyData.rotation.z)
        end
        if not cDummy then return false end
        imports.setElementAlpha(cDummy, 0)
        imports.setElementDimension(cDummy, imports.tonumber(dummyData.dimension) or 0)
        imports.setElementInterior(cDummy, imports.tonumber(dummyData.interior) or 0)
        return cDummy
    end

    --->>> API Syncers <<<---
    syncer.public.syncedAssetDummies = {}
    function syncer.public:syncAssetDummy(assetType, assetName, assetClump, clumpMaps, dummyData, targetPlayer, targetDummy, remoteSignature)    
        if targetPlayer then return network:emit("Assetify:onRecieveAssetDummy", true, false, targetPlayer, assetType, assetName, assetClump, clumpMaps, dummyData, targetDummy, remoteSignature) end
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