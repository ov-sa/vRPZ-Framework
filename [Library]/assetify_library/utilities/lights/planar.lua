----------------------------------------------------------------
--[[ Resource: Assetify Library
     Script: utilities: lights: planar.lua
     Author: vStudio
     Developer(s): Aviril, Tron
     DOC: 19/10/2021
     Desc: Planar Light Utilities ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local imports = {
    pairs = pairs,
    tonumber = tonumber,
    isElement = isElement,
    destroyElement = destroyElement,
    setmetatable = setmetatable,
    dxCreateShader = dxCreateShader,
    dxSetShaderValue = dxSetShaderValue,
    engineRequestModel = engineRequestModel,
    engineLoadTXD = engineLoadTXD,
    engineLoadDFF = engineLoadDFF,
    engineLoadCOL = engineLoadCOL,
    engineImportTXD = engineImportTXD,
    engineReplaceModel = engineReplaceModel,
    engineReplaceCOL = engineReplaceCOL,
    engineApplyShaderToWorldTexture = engineApplyShaderToWorldTexture
}


-----------------------
--[[ Class: Shader ]]--
-----------------------

light.planar = {
    cache = {
        validTypes = {
            {index = "planar_1x1", textureName = "assetify_light_plane"}
        }
    },
    buffer = {}
}
for i = 1, #light.planar.validTypes, 1 do
    local j = light.planar.validTypes[i]
    local modelID = imports.engineRequestModel("object")
    local modelPath = "utilities/rw/"..j.index.."/"
    j.modelID = modelID
    imports.engineImportTXD(imports.engineLoadTXD(modelPath.."dict.rw"), modelID)
    imports.engineReplaceModel(imports.engineLoadDFF(modelPath.."buffer.rw"), modelID, true)
    imports.engineReplaceCOL(imports.engineLoadCOL(modelPath.."collision.rw"), modelID)
    light.planar.validTypes[i] = nil
    light.planar.validTypes[(j.index)] = j
    light.planar.validTypes[(j.index)].index = nil
end
light.planar.__index = light.planar

if localPlayer then
    function light.planar:create(...)
        local cLight = imports.setmetatable({}, {__index = self})
        if not cLight:load(...) then
            cLight = nil
            return false
        end
        return cLight
    end

    function light.planar:destroy(...)
        if not self or (self == light.planar) then return false end
        return self:unload(...)
    end

    function light.planar:clearElementBuffer(element)
        if not element or not imports.isElement(element) or not light.planar.buffer[element] then return false end
        light.planar.buffer[element]:destroy()
        return true
    end

    function light.planar:load(lightType, lightData, shaderInputs)
        if not self or (self == light.planar) then return false end
        if not lightType or not lightCache then return false end
        local lightCache = light.planar.validTypes[lightType]
        if not lightCache then return false end
        lightData.position, lightData.rotation = lightData.position or {}, lightData.rotation or {}
        lightData.position.x, lightData.position.y, lightData.position.z = imports.tonumber(lightData.position.x) or 0, imports.tonumber(lightData.position.y) or 0, imports.tonumber(lightData.position.z) or 0
        lightData.rotation.x, lightData.rotation.y, lightData.rotation.z = imports.tonumber(lightData.rotation.x) or 0, imports.tonumber(lightData.rotation.y) or 0, imports.tonumber(lightData.rotation.z) or 0
        self.cModelInstance = imports.createObject(lightCache.modelID, lightData.position.x, lightData.position.y, lightData.position.z, lightData.rotation.x, lightData.rotation.y, lightData.rotation.z)
        self.syncRate = imports.tonumber(lightData.syncRate)
        imports.setElementDoubleSided(self.cModelInstance, true)
        imports.setElementDimension(self.cModelInstance, imports.tonumber(lightData.dimension) or 0)
        imports.setElementInterior(self.cModelInstance, imports.tonumber(lightData.interior) or 0)
        if lightCache.collisionID then
            self.cCollisionInstance = imports.createObject(lightCache.collisionID, lightData.position.x, lightData.position.y, lightData.position.z, lightData.rotation.x, lightData.rotation.y, lightData.rotation.z)
            imports.setElementAlpha(self.cCollisionInstance, 0)
            self.cStreamer = streamer:create(self.cModelInstance, "light", {self.cCollisionInstance}, self.syncRate)
        end
        self.cLight = self.cModelInstance
        self.cShader = imports.dxCreateShader(light.planar.rwCache["Assetify_LightPlanar"](), shader.cache.shaderPriority, shader.cache.shaderDistance, false, "all")
        --TODO: MAKE A RENDERER HELPER THAT SETS MNUTE DURATION VSOURCE AND SERVER TICK WITHIN IT
        renderer:setServerTick(_, self.cShader, syncer.librarySerial)
        shader.buffer.shader[cShader] = "light"
        self.lightType = lightType
        for i, j in imports.pairs(shaderInputs) do
            imports.dxSetShaderValue(self.cLight, i, j)
        end
        self.lightData = lightData
        self.lightData.shaderInputs = shaderInputs
        imports.engineApplyShaderToWorldTexture(self.cShader, lightCache.textureName, self.cLight)
        return true
    end

    function light.planar:unload()
        if not self or (self == light.planar) or self.isUnloading then return false end
        self.isUnloading = true
        if self.cStreamer then
            self.cStreamer:destroy()
        end
        if self.cModelInstance and imports.isElement(self.cModelInstance) then
            light.planar.buffer[(self.cModelInstance)] = nil
            imports.destroyElement(self.cModelInstance)
        end
        if self.cCollisionInstance and imports.isElement(self.cCollisionInstance) then
            imports.destroyElement(self.cCollisionInstance)
        end
        if self.cShader and imports.isElement(self.cShader) then
            shader.buffer.shader[(self.cShader)] = nil
            imports.destroyElement(self.cShader)
        end
        self = nil
        return true
    end
end