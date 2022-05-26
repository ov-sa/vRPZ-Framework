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
    tocolor = tocolor,
    isElement = isElement,
    destroyElement = destroyElement,
    guiGetScreenSize = guiGetScreenSize,
    addEventHandler = addEventHandler,
    engineRemoveShaderFromWorldTexture = engineRemoveShaderFromWorldTexture,
    dxDrawRectangle = dxDrawRectangle
}


-------------------------
--[[ Class: Renderer ]]--
-------------------------

renderer = {
    state = false,
    cache = {
        renderFrame = 0,
        resolution = {imports.guiGetScreenSize()}
    },
    shaders = {},
    layers = {
        color = false,
        emissive = false
    }
}
renderer.cache.resolution[1], renderer.cache.resolution[2] = renderer.cache.resolution[1]*rendererSettings.resolution, renderer.cache.resolution[2]*rendererSettings.resolution
renderer.__index = renderer

renderer.render = function()
    renderer.cache.renderFrame = ((renderer.cache.renderFrame == #renderer.layers.index) and 1) or (renderer.cache.renderFrame + 1)
    local currentLayer = renderer.layers.index[(renderer.cache.renderFrame)]
    for i, j in imports.pairs(renderer.shaders) do
        imports.engineRemoveShaderFromWorldTexture(j, "*")
    end
    if currentLayer == "diffuse" then
        imports.dxUpdateScreenSource(renderer.layers.diffuse)
    end
    imports.dxDrawRectangle(0, 0, renderer.cache.resolution[1], renderer.cache.resolution[2], renderer.cache.ambience)
end

function renderer:toggle(state)
    state = (state and true) or false
    if renderer.state == state then return false end
    renderer.state = state
    if renderer.state then
        for i, j in imports.pairs(renderer.layers) do
            renderer.layers[i] = imports.dxCreateRenderTarget(renderer.cache.resolution[1], renderer.cache.resolution[2], true)
        end
        imports.addEventHandler("onClientHUDRender", root, renderer.render)
    else
        for i, j in imports.pairs(renderer.layers) do
            if j and imports.isElement(j) then
                imports.destroyElement(j)
                renderer.layers[i] = false
            end
        end
    end
end
