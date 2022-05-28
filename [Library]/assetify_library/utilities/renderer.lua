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
    resolution = {imports.guiGetScreenSize()}
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

function renderer:setAmbienceColor(r, g, b, a)
    rendererSettings.ambienceColor[1], rendererSettings.ambienceColor[2], rendererSettings.ambienceColor[3], rendererSettings.ambienceColor[4] = imports.tonumber(r) or 0, imports.tonumber(g) or 0, imports.tonumber(b) or 0, imports.tonumber(a) or 255
    for i, j in imports.pairs(shader.buffer.shader) do
        imports.dxSetShaderValue(i, "ambienceColor", rendererSettings.ambienceColor[1]/255, rendererSettings.ambienceColor[2]/255, rendererSettings.ambienceColor[3]/255, rendererSettings.ambienceColor[4]/255)
    end
    return true
end

function renderer:getAmbienceColor()
    return rendererSettings.ambienceColor[1], rendererSettings.ambienceColor[2], rendererSettings.ambienceColor[3], rendererSettings.ambienceColor[4]
end