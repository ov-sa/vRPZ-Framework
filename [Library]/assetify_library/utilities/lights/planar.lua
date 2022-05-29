----------------------------------------------------------------
--[[ Resource: Assetify Library
     Script: utilities: lights: planar.lua
     Author: vStudio
     Developer(s): Aviril, Tron
     DOC: 19/10/2021
     Desc: Planar Light Utilities ]]--
----------------------------------------------------------------

--TODO: WIP...
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
    engineApplyShaderToWorldTexture = engineApplyShaderToWorldTexture,
    engineRemoveShaderFromWorldTexture = engineRemoveShaderFromWorldTexture
}


-----------------------
--[[ Class: Shader ]]--
-----------------------

light.planar = {
    cache = {
        validModels = {
            {index = "planar_1x1", texName = "assetify_light_plane"}
        }
    },
    buffer = {}
}
for i = 1, #light.planar.validModels, 1 do
    local j = light.planar.validModels[i]
    local modelID = imports.engineRequestModel("object")
    local modelPath = "utilities/rw/"..j.index.."/"
    j.modelID = modelID
    imports.engineImportTXD(imports.engineLoadTXD(modelPath.."dict.rw"), modelID)
    imports.engineReplaceModel(imports.engineLoadDFF(modelPath.."buffer.rw"), modelID, true)
    imports.engineReplaceCOL(imports.engineLoadCOL(modelPath.."collision.rw"), modelID)
    light.planar.validModels[i] = nil
    light.planar.validModels[(j.index)] = j
    light.planar.validModels[(j.index)].index = nil
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
        if not element or not imports.isElement(element) or not light.planar.buffer.element[element] then return false end
        if v then
            light.planar.buffer.element[element]:destroy()
        end
        light.planar.buffer.element[element] = nil
        return true
    end

    function light.planar:load(element, shaderCategory, shaderName, textureName, shaderTextures, shaderInputs, rwCache, shaderMaps, encryptKey, shaderPriority, shaderDistance)
        if not self or (self == light.planar) then return false end
        local isExternalResource = sourceResource and (sourceResource ~= resource)
        if not shaderCategory or not shaderName or (isExternalResource and light.planar.cache.remoteBlacklist[shaderName]) or (not light.planar.preLoaded[shaderName] and not light.planar.rwCache[shaderName]) or not textureName or not shaderTextures or not shaderInputs or not rwCache or not shaderMaps then return false end
        element = ((element and imports.isElement(element)) and element) or false
        shaderPriority = imports.tonumber(shaderPriority) or light.planar.cache.shaderPriority
        shaderDistance = imports.tonumber(shaderDistance) or light.planar.cache.shaderDistance
        self.isPreLoaded = (light.planar.preLoaded[shaderName] and true) or false
        self.cLight = (self.isPreLoaded and light.planar.preLoaded[shaderName])
        if not self.cLight then
            self.cLight = imports.dxCreateShader(light.planar.rwCache[shaderName](shaderMaps), shaderPriority, shaderDistance, false, "all")
            renderer:setServerTick(_, self.cLight, syncer.librarySerial)
        end
        light.planar.buffer[(self.cLight)] = true
        if not self.isPreLoaded then rwCache.light.planar[textureName] = self.cLight end
        for i, j in imports.pairs(shaderTextures) do
            if j and imports.isElement(rwCache.texture[j]) then
                imports.dxSetShaderValue(self.cLight, i, rwCache.texture[j])
            end
        end
        for i, j in imports.pairs(shaderInputs) do
            imports.dxSetShaderValue(self.cLight, i, j)
        end
        self.shaderData = {
            element = element,
            shaderCategory = shaderCategory,
            shaderName = shaderName,
            textureName = textureName,
            shaderTextures = shaderTextures,
            shaderInputs = shaderInputs,
            shaderPriority = shaderPriority,
            shaderDistance = shaderDistance
        }
        light.planar.buffer.element[(self.shaderData.element)] = light.planar.buffer.element[(self.shaderData.element)] or {}
        local bufferCache = light.planar.buffer.element[(self.shaderData.element)]
        bufferCache[shaderCategory] = bufferCache[shaderCategory] or {}
        bufferCache[shaderCategory][textureName] = self
        imports.engineApplyShaderToWorldTexture(self.cLight, textureName, element or nil)
        return true
    end

    function light.planar:unload()
        if not self or (self == light.planar) or self.isUnloading then return false end
        self.isUnloading = true
        if not self.preLoaded then
            if self.cLight and imports.isElement(self.cLight) then
                light.planar.buffer[(self.cLight)] = nil
                imports.destroyElement(self.cLight)
            end
        else
            imports.engineRemoveShaderFromWorldTexture(self.cLight, self.shaderData.textureName, self.shaderData.element)
        end
        if self.shaderData.element then
            light.planar.buffer.element[(self.shaderData.element)][(self.shaderData.shaderCategory)][(self.shaderData.textureName)] = nil
        end
        self = nil
        return true
    end
end