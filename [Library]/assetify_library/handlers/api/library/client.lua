----------------------------------------------------------------
--[[ Resource: Assetify Library
     Script: handlers. api: library: client.lua
     Author: vStudio
     Developer(s): Aviril, Tron, Mario, Аниса
     DOC: 19/10/2021
     Desc: Library APIs ]]--
----------------------------------------------------------------


-----------------------
--[[ APIs: Library ]]--
-----------------------

function manager.API.Library:getAssetID(...)
    return manager:getAssetID(...)
end

function manager.API.Library:isAssetLoaded(...)
    return manager:isAssetLoaded(...)
end

function manager.API.Library:loadAsset(...)
    return manager:loadAsset(...)
end

function manager.API.Library:unloadAsset(...)
    return manager:unloadAsset(...)
end

function manager.API.Library:createShader(...)
    local cShader = shader:create(...)
    return cShader.cShader
end

function manager.API.Library:isRendererVirtualRendering()
    return renderer.isVirtualRendering
end

function manager.API.Library:setRendererVirtualRendering(...)
    return renderer:setVirtualRendering(...)
end

function manager.API.Library:getRendererVirtualSource()
    return (renderer.isVirtualRendering and renderer.virtualSource) or false
end

function manager.API.Library:getRendererVirtualRTs()
    return (renderer.isVirtualRendering and renderer.virtualRTs) or false
end

function manager.API.Library:setRendererTimeSync(...)
    return renderer:setTimeSync(...)
end

function manager.API.Library:setRendererServerTick(...)
    return renderer:setServerTick(...)
end

function manager.API.Library:setRendererMinuteDuration(...)
    return renderer:setMinuteDuration(...)
end


--TODO: WIP..
function createPlanarLight(...) local cLight = light.planar:create(...); return (cLight and cLight.cLight) or false end
function setPlanarLightResolution(cLight, ...) if not light.planar.buffer[cLight] then return false end; return light.planar.buffer[cLight]:setResolution(...) end
function setPlanarLightTexture(cLight, ...) if not light.planar.buffer[cLight] then return false end; return light.planar.buffer[cLight]:setTexture(...) end
function setPlanarLightColor(cLight, ...) if not light.planar.buffer[cLight] then return false end; return light.planar.buffer[cLight]:setColor(...) end