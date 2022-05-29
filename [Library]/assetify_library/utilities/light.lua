----------------------------------------------------------------
--[[ Resource: Assetify Library
     Script: utilities: light.lua
     Author: vStudio
     Developer(s): Aviril, Tron
     DOC: 19/10/2021
     Desc: Light Utilities ]]--
----------------------------------------------------------------

--TODO: WIP...

-----------------
--[[ Imports ]]--
-----------------

local imports = {}


----------------------
--[[ Class: Light ]]--
----------------------

light = {
    cache = {}
}

if localPlayer then
    light.buffer = {}

    function light:create(...)
        local cShader = imports.setmetatable({}, {__index = self})
        if not cShader:load(...) then
            cShader = nil
            return false
        end
        return cShader
    end

    function light:createTex(shaderMaps, rwCache, encryptKey)
        if not shaderMaps or not rwCache then return false end
        rwCache.light = {}
        rwCache.texture = {}
        for i, j in imports.pairs(shaderMaps) do
            if i == "clump" then
                for k, v in imports.pairs(j) do
                    for m = 1, #v, 1 do
                        local n = v[m]
                        if n.clump then
                            rwCache.texture[(n.clump)] = light:loadTex(n.clump, encryptKey)
                        end
                        if n.bump then
                            rwCache.texture[(n.bump)] = light:loadTex(n.bump, encryptKey)
                        end
                    end
                end
            elseif i == "control" then
                for k, v in imports.pairs(j) do
                    for m = 1, #v, 1 do
                        local n = v[m]
                        if n.control then
                            rwCache.texture[(n.control)] = light:loadTex(n.control, encryptKey)
                        end
                        if n.bump then
                            rwCache.texture[(n.bump)] = light:loadTex(n.bump, encryptKey)
                        end
                        for x = 1, #light.cache.validChannels, 1 do
                            local y = n[(light.cache.validChannels[x].index)]
                            if y and y.map then
                                rwCache.texture[(y.map)] = light:loadTex(y.map, encryptKey)
                                if y.bump then
                                    rwCache.texture[(y.bump)] = light:loadTex(y.bump, encryptKey)
                                end
                            end
                        end
                    end
                end
            end
        end
        return true
    end

    function light:destroy(...)
        if not self or (self == light) then return false end
        return self:unload(...)
    end

    function light:clearAssetBuffer(rwCache)
        if not rwCache then return false end
        if rwCache.light then
            for i, j in imports.pairs(rwCache.light) do
                if j and imports.isElement(j) then
                    imports.destroyElement(j)
                end
            end
        end
        if rwCache.texture then
            for i, j in imports.pairs(rwCache.texture) do
                if j and imports.isElement(j) then
                    imports.destroyElement(j)
                end
            end
        end
        return true
    end

    function light:clearElementBuffer(element, shaderCategory)
        if not element or not imports.isElement(element) or not light.buffer.element[element] or (shaderCategory and not light.buffer.element[element][shaderCategory]) then return false end
        if not shaderCategory then
            for i, j in imports.pairs(light.buffer.element[element]) do
                for k, v in imports.pairs(j) do
                    if v and imports.isElement(v) then
                        v:destroy()
                    end
                end
            end
            light.buffer.element[element] = nil
        else
            for i, j in imports.pairs(light.buffer.element[element][shaderCategory]) do
                if j then
                    j:destroy()
                end
            end
            light.buffer.element[element][shaderCategory] = nil
        end
        return true
    end

    function light:loadTex(texturePath, encryptKey)
        if texturePath then
            if encryptKey then
                local cTexturePath = texturePath..".tmp"
                if imports.file.write(cTexturePath, imports.decodeString("tea", imports.file.read(texturePath), {key = encryptKey})) then
                    local cTexture = imports.dxCreateTexture(cTexturePath, "dxt5", true)
                    imports.file.delete(cTexturePath)
                    return cTexture
                end
            else
                return imports.dxCreateTexture(texturePath, "dxt5", true)
            end
        end
        return false
    end

    function light:load(element, shaderCategory, shaderName, textureName, shaderTextures, shaderInputs, rwCache, shaderMaps, encryptKey, shaderPriority, shaderDistance)
        if not self or (self == light) then return false end
        local isExternalResource = sourceResource and (sourceResource ~= resource)
        if not shaderCategory or not shaderName or (isExternalResource and light.cache.remoteBlacklist[shaderName]) or (not light.preLoaded[shaderName] and not light.rwCache[shaderName]) or not textureName or not shaderTextures or not shaderInputs or not rwCache or not shaderMaps then return false end
        element = ((element and imports.isElement(element)) and element) or false
        shaderPriority = imports.tonumber(shaderPriority) or light.cache.shaderPriority
        shaderDistance = imports.tonumber(shaderDistance) or light.cache.shaderDistance
        self.isPreLoaded = (light.preLoaded[shaderName] and true) or false
        self.cShader = (self.isPreLoaded and light.preLoaded[shaderName])
        if not self.cShader then
            self.cShader = imports.dxCreateShader(light.rwCache[shaderName](shaderMaps), shaderPriority, shaderDistance, false, "all")
            renderer:setServerTick(_, self.cShader, syncer.librarySerial)
        end
        light.buffer.light[(self.cShader)] = true
        if not self.isPreLoaded then rwCache.light[textureName] = self.cShader end
        for i, j in imports.pairs(shaderTextures) do
            if j and imports.isElement(rwCache.texture[j]) then
                imports.dxSetShaderValue(self.cShader, i, rwCache.texture[j])
            end
        end
        for i, j in imports.pairs(shaderInputs) do
            imports.dxSetShaderValue(self.cShader, i, j)
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
        light.buffer.element[(self.shaderData.element)] = light.buffer.element[(self.shaderData.element)] or {}
        local bufferCache = light.buffer.element[(self.shaderData.element)]
        bufferCache[shaderCategory] = bufferCache[shaderCategory] or {}
        bufferCache[shaderCategory][textureName] = self
        imports.engineApplyShaderToWorldTexture(self.cShader, textureName, element or nil)
        return true
    end

    function light:unload()
        if not self or (self == light) or self.isUnloading then return false end
        self.isUnloading = true
        if not self.preLoaded then
            if self.cShader and imports.isElement(self.cShader) then
                light.buffer.light[(self.cShader)] = nil
                imports.destroyElement(self.cShader)
            end
        else
            imports.engineRemoveShaderFromWorldTexture(self.cShader, self.shaderData.textureName, self.shaderData.element)
        end
        if self.shaderData.element then
            light.buffer.element[(self.shaderData.element)][(self.shaderData.shaderCategory)][(self.shaderData.textureName)] = nil
        end
        self = nil
        return true
    end
end