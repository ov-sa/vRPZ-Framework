----------------------------------------------------------------
--[[ Resource: Assetify Library
     Script: utilities: renderer.lua
     Author: vStudio
     Developer(s): Aviril, Tron
     DOC: 19/10/2021
     Desc: Renderer Utilities ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local imports = {
    type = type,
    pairs = pairs,
    tonumber = tonumber,
    isElement = isElement,
    destroyElement = destroyElement,
    guiGetScreenSize = guiGetScreenSize,
    addEventHandler = addEventHandler,
    removeEventHandler = removeEventHandler,
    dxCreateScreenSource = dxCreateScreenSource,
    dxUpdateScreenSource = dxUpdateScreenSource,
    dxSetShaderValue = dxSetShaderValue
}


-------------------------
--[[ Class: Renderer ]]--
-------------------------

renderer = {
    state = false,
    resolution = {imports.guiGetScreenSize()},
    cache = {
        serverTick = 1
    }
}
renderer.resolution[1], renderer.resolution[2] = renderer.resolution[1]*rendererSettings.resolution, renderer.resolution[2]*rendererSettings.resolution
renderer.__index = renderer

renderer.render = function()
    imports.dxUpdateScreenSource(renderer.source)
    return true
end

function renderer:toggle(state)
    state = (state and true) or false
    if renderer.state == state then return false end
    renderer.state = state
    shader:syncTexExporter(renderer.state)
    if renderer.state then
        renderer.source = imports.dxCreateScreenSource(renderer.resolution[1], renderer.resolution[2])
        imports.addEventHandler("onClientHUDRender", root, renderer.render)
    else
        imports.removeEventHandler("onClientHUDRender", root, renderer.render)
        if renderer.source and imports.isElement(renderer.source) then
            imports.destroyElement(renderer.source)
        end
        renderer.source = nil
    end
    return true
end

function renderer:setWeatherTick(serverTick, syncShader, isInternal)
    if not syncShader then
        renderer.cache.serverTick = imports.tonumber(serverTick) or 0
        for i, j in imports.pairs(shader.buffer.shader) do
            renderer:setWeatherTick(serverTick, i, syncer.librarySerial)
        end
    else
        local isExternalResource = sourceResource and (sourceResource ~= resource)
        if (not isInternal or (isInternal ~= syncer.librarySerial)) and isExternalResource then
            return false
        end
        imports.dxSetShaderValue(syncShader, "serverTick", renderer.cache.serverTick)
    end
    return true
end

function renderer:getWeatherTick()
    return renderer.cache.serverTick
end