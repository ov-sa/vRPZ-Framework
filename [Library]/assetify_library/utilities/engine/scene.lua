----------------------------------------------------------------
--[[ Resource: Assetify Library
     Script: utilities: engine: scene.lua
     Author: vStudio
     Developer(s): Aviril, Tron, Mario, Аниса
     DOC: 19/10/2021
     Desc: Scene Utilities ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local imports = {
    isElement = isElement,
    attachElements = attachElements,
    destroyElement = destroyElement,
    createObject = createObject,
    setElementAlpha = setElementAlpha,
    setElementDoubleSided = setElementDoubleSided,
    setElementDimension = setElementDimension,
    setElementInterior = setElementInterior
}


----------------------
--[[ Class: Scene ]]--
----------------------

local scene = class:create("scene")

function scene.public:create(...)
    local cScene = self:createInstance()
    if cScene and not cScene:load(...) then
        cScene:destroyInstance()
        return false
    end
    return cScene
end

function scene.public:destroy(...)
    if not scene.public:isInstance(self) then return false end
    return self:unload(...)
end

function scene.public:load(cAsset, sceneManifest, sceneData)
    if not scene.public:isInstance(self) then return false end
    if not cAsset or not sceneManifest or not sceneData or not cAsset.synced then return false end
    local posX, posY, posZ, rotX, rotY, rotZ = sceneData.position.x + ((sceneManifest.sceneOffset and sceneManifest.sceneOffset.x) or 0), sceneData.position.y + ((sceneManifest.sceneOffset and sceneManifest.sceneOffset.y) or 0), sceneData.position.z + ((sceneManifest.sceneOffset and sceneManifest.sceneOffset.z) or 0), sceneData.rotation.x, sceneData.rotation.y, sceneData.rotation.z
    self.cStreamerInstance = imports.createObject(cAsset.synced.modelID, posX, posY, posZ, rotX, rotY, rotZ, (sceneManifest.enableLODs and cAsset.synced.collisionID and true) or false)
    imports.setElementDoubleSided(self.cStreamerInstance, true)
    if cAsset.synced.collisionID then
        self.cCollisionInstance = imports.createObject(cAsset.synced.collisionID, posX, posY, posZ, rotX, rotY, rotZ)
        imports.setElementAlpha(self.cCollisionInstance, 0)
        imports.setElementDimension(self.cCollisionInstance, sceneManifest.sceneDimension)
        imports.setElementInterior(self.cCollisionInstance, sceneManifest.sceneInterior)
        if sceneManifest.enableLODs then
            self.cModelInstance = imports.createObject(cAsset.synced.collisionID, posX, posY, posZ, rotX, rotY, rotZ, true)
            imports.attachElements(self.cModelInstance, self.cCollisionInstance)
            imports.setElementAlpha(self.cModelInstance, 0)
            imports.setElementDimension(self.cModelInstance, sceneManifest.sceneDimension)
            imports.setElementInterior(self.cModelInstance, sceneManifest.sceneInterior)
            self.cStreamer = streamer:create(self.cStreamerInstance, "scene", {self.cCollisionInstance, self.cModelInstance})
        else
            self.cModelInstance = self.cStreamerInstance
            self.cStreamer = streamer:create(self.cStreamerInstance, "scene", {self.cCollisionInstance})
        end
    end
    cAsset.cScene = self
    return true
end

function scene.public:unload()
    if not scene.public:isInstance(self) then return false end
    if self.cStreamer then self.cStreamer:destroy() end
    imports.destroyElement(self.cStreamerInstance)
    imports.destroyElement(self.cModelInstance)
    imports.destroyElement(self.cCollisionInstance)
    self:destroyInstance()
    return true
end