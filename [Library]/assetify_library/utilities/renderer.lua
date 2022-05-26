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
    isElement = isElement,
    destroyElement = destroyElement,
    guiGetScreenSize = guiGetScreenSize,
    addEventHandler = addEventHandler,
    engineRemoveShaderFromWorldTexture = engineRemoveShaderFromWorldTexture
}


-------------------------
--[[ Class: Renderer ]]--
-------------------------

renderer = {
    state = false,
    resolution = {imports.guiGetScreenSize()}
    layers = {
        diffuse = false,
        emissive = false
    }
}
renderer.resolution[1], renderer.resolution[2] = renderer.resolution[1]*rendererSettings.resolution, renderer.resolution[2]*rendererSettings.resolution
renderer.__index = renderer

renderer.render = function()
    --TODO: ...
end

function renderer:toggle(state)
    state = (state and true) or false
    if renderer.state == state then return false end
    renderer.state = state
    if renderer.state then
        for i, j in imports.pairs(renderer.layers) do
            renderer.layers[i] = imports.dxCreateRenderTarget(renderer.resolution[1], renderer.resolution[2], true)
        end
        imports.addEventHandler("onClientHUDRender", root, renderer.render)
    else
        imports.engineRemoveShaderFromWorldTexture(shader.preLoaded["Assetify_TextureExporter"], "*")
        for i, j in imports.pairs(renderer.layers) do
            if j and imports.isElement(j) then
                imports.destroyElement(j)
                renderer.layers[i] = false
            end
        end
    end
end
