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
    dxCreateShader = dxCreateShader
}


-------------------
--[[ Variables ]]--
-------------------

CShaders = {}, {
    ["Assetify_TextureClearer"] = imports.dxCreateShader(CShaders["Assetify_TextureClearer"], 1000, 0, false, "all"),
    ["Assetify_TextureChanger"] = {}
}


-----------------------
--[[ Class: Shader ]]--
-----------------------

shader = {}
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

function shader:load(shaderName, element, priority, distance)
    if not self or (self == shader) then return false end
    if not shaderName or not CShaders[shaderName] or not element or not imports.isElement(element) then return false end
    self.cShader = imports.dxCreateShader(CShaders[shaderName], imports.tonumber(priority) or 10000, imports.tonumber(distance) or 0, false, "all")
    return true
end

function shader:unload()
    if not self or (self == shader) then return false end
    if imports.isElement(self.cShader) then
        imports.destroyElement(self.cShader)
    end
    self = nil
    return true
end