----------------------------------------------------------------
--[[ Resource: Assetify Library
     Script: utilities: shaders: loader.lua
     Server: -
     Author: OvileAmriam
     Developer(s): Aviril, Tron
     DOC: 19/10/2021 (OvileAmriam)
     Desc: Shader Loader ]]--
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
    engineApplyShaderToWorldTexture = engineApplyShaderToWorldTexture
}


-----------------------
--[[ Class: Shader ]]--
-----------------------

shader = {
    rwCache = {},
    preLoaded = {
        ["Assetify_TextureClearer"] = imports.dxCreateShader(shader.rwCache["Assetify_TextureClearer"], 1000, 0, false, "all")
    }
}
shader.__index = shader

function shader:create(...)
    local cShader = imports.setmetatable({}, {__index = self})
    if not cShader:load(...) then
        cShader = nil
        return false
    end
    return cShader
end

function shader:destroy(...)
    if not self or (self == shader) then return false end
    return self:unload(...)
end

function shader:load(shaderName, textureName, textureElement, shaderPriority, shaderDistance)
    if not self or (self == shader) then return false end
    if not shaderName or not shader.rwCache[shaderName] or not textureName or not textureElement or not imports.isElement(textureElement) then return false end
    self.isPreLoaded = (shader.preLoaded[shaderName] and true) or false
    self.cShader = (self.isPreLoaded and shader.preLoaded[shaderName]) or imports.dxCreateShader(shader.rwCache[shaderName], imports.tonumber(shaderPriority) or 10000, imports.tonumber(shaderDistance) or 0, false, "all")
    self.shaderData = {
        shaderName = shaderName,
        textureName = textureName,
        textureElement = textureElement,
        shaderPriority = shaderPriority,
        shaderDistance = shaderDistance
    }
    imports.engineApplyShaderToWorldTexture(self.cShader, textureName, textureElement)
    return true
end

function shader:unload()
    if not self or (self == shader) then return false end
    if not self.preLoaded then
        if imports.isElement(self.cShader) then
            imports.destroyElement(self.cShader)
        end
    else
        imports.engineRemoveShaderFromWorldTexture(self.cShader, self.shaderData.textureName, self.shaderData.textureElement)
    end
    self = nil
    return true
end