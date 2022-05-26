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
    dxCreateRenderTarget = dxCreateRenderTarget,
    dxSetRenderTarget = dxSetRenderTarget,
    dxSetShaderValue = dxSetShaderValue,
    engineApplyShaderToWorldTexture = engineApplyShaderToWorldTexture,
    engineRemoveShaderFromWorldTexture = engineRemoveShaderFromWorldTexture
}


-------------------------
--[[ Class: Renderer ]]--
-------------------------

renderer = {
    state = false,
    resolution = {imports.guiGetScreenSize()},
    buffer = {}
}
renderer.resolution[1], renderer.resolution[2] = renderer.resolution[1]*rendererSettings.resolution, renderer.resolution[2]*rendererSettings.resolution
renderer.__index = renderer

renderer.render = function()
    imports.dxSetRenderTarget(renderer.buffer.diffuse, true)
    imports.dxSetRenderTarget(renderer.buffer.emissive, true)
    imports.dxSetRenderTarget()
    dxDrawImage(0, 0, 1366*0.25, 768*0.25, renderer.buffer.diffuse)
    dxDrawImage(0, (768*0.25) + 15, 1366*0.25, 768*0.25, renderer.buffer.emissive)
    return true
end

function renderer:toggle(state)
    state = (state and true) or false
    if renderer.state == state then return false end
    renderer.state = state
    if renderer.state then
        for i, j in imports.pairs(shader.cache.validLayers) do
            renderer.buffer[(j.index)] = imports.dxCreateRenderTarget(renderer.resolution[1], renderer.resolution[2], j.alpha)
        end
        shader:syncTexExporter(renderer.state)
        imports.engineApplyShaderToWorldTexture(shader.preLoaded["Assetify_TextureExporter"], "*")
        imports.addEventHandler("onClientPreRender", root, renderer.render)
    else
        shader:syncTexExporter(renderer.state)
        imports.engineRemoveShaderFromWorldTexture(shader.preLoaded["Assetify_TextureExporter"], "*")
        for i, j in imports.pairs(renderer.buffer) do
            if j and imports.isElement(j) then
                imports.destroyElement(j)
                renderer.buffer[i] = nil
            end
        end
    end
    return true
end

function renderer:setAmbienceColor(r, g, b, a)
    if not renderer.state then return false end
    rendererSettings.ambienceColor[1], rendererSettings.ambienceColor[2], rendererSettings.ambienceColor[3], rendererSettings.ambienceColor[4] = imports.tonumber(r) or 0, imports.tonumber(g) or 0, imports.tonumber(b) or 0, imports.tonumber(a) or 255
    for i, j in imports.pairs(shader.buffer.shader) do
        imports.dxSetShaderValue(i, "ambienceColor", rendererSettings.ambienceColor[1]/255, rendererSettings.ambienceColor[2]/255, rendererSettings.ambienceColor[3]/255, rendererSettings.ambienceColor[4]/255)
    end
    return true
end

function renderer:getAmbienceColor()
    if not renderer.state then return false end
    return rendererSettings.ambienceColor[1], rendererSettings.ambienceColor[2], rendererSettings.ambienceColor[3], rendererSettings.ambienceColor[4]
end