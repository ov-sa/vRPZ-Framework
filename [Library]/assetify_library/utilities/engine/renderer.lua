----------------------------------------------------------------
--[[ Resource: Assetify Library
     Script: utilities: engine: renderer.lua
     Author: vStudio
     Developer(s): Aviril, Tron, Mario, Аниса
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
    getTickCount = getTickCount,
    destroyElement = destroyElement,
    guiGetScreenSize = guiGetScreenSize,
    addEventHandler = addEventHandler,
    removeEventHandler = removeEventHandler,
    dxCreateScreenSource = dxCreateScreenSource,
    dxCreateRenderTarget = dxCreateRenderTarget,
    dxUpdateScreenSource = dxUpdateScreenSource
}


-------------------------
--[[ Class: Renderer ]]--
-------------------------

local renderer = class:create("renderer", {
    isVirtualRendering = false,
    isTimeSynced = false,
    serverTick = 60*60*12,
    minuteDuration = 60
})

if localPlayer then
    renderer.public.resolution = {imports.guiGetScreenSize()}
    renderer.public.resolution[1], renderer.public.resolution[2] = renderer.public.resolution[1]*settings.renderer.resolution, renderer.public.resolution[2]*settings.renderer.resolution

    renderer.public.render = function()
        imports.dxUpdateScreenSource(renderer.virtualSource)
        return true
    end

    function renderer.public:syncShader(syncShader)
        if not syncShader then return false end
        renderer.public:setVirtualRendering(_, _, syncShader, syncer.librarySerial)
        renderer.public:setTimeSync(_, syncShader, syncer.librarySerial)
        renderer.public:setServerTick(_, syncShader, syncer.librarySerial)
        renderer.public:setMinuteDuration(_, syncShader, syncer.librarySerial)
        return true
    end

    function renderer.public:setVirtualRendering(state, rtModes, syncShader, isInternal)
        if not syncShader then
            state = (state and true) or false
            rtModes = (rtModes and (imports.type(rtModes) == "table") and rtModes) or false
            if renderer.isVirtualRendering == state then return false end
            renderer.isVirtualRendering = state
            if renderer.isVirtualRendering then
                renderer.virtualSource = imports.dxCreateScreenSource(renderer.public.resolution[1], renderer.public.resolution[2])
                renderer.virtualRTs = renderer.virtualRTs or {}
                if rtModes.diffuse then
                    renderer.virtualRTs.diffuse = imports.dxCreateRenderTarget(renderer.public.resolution[1], renderer.public.resolution[2], true)
                    if rtModes.emissive then
                        renderer.virtualRTs.emissive = imports.dxCreateRenderTarget(renderer.public.resolution[1], renderer.public.resolution[2], false)
                    end
                end
                imports.addEventHandler("onClientHUDRender", root, renderer.public.render)
            else
                imports.removeEventHandler("onClientHUDRender", root, renderer.public.render)
                imports.destroyElement(renderer.virtualSource)
                renderer.virtualSource = nil
                for i, j in imports.pairs(renderer.virtualRTs) do
                    imports.destroyElement(j)
                    renderer.virtualRTs[i] = nil
                end
            end
            for i, j in imports.pairs(shader.buffer.shader) do
                renderer.public:setVirtualRendering(_, _, i, syncer.librarySerial)
            end
        else
            local isExternalResource = sourceResource and (sourceResource ~= syncer.libraryResource)
            if (not isInternal or (isInternal ~= syncer.librarySerial)) and isExternalResource then
                return false
            end
            local vSource0, vSource1, vSource2 = (renderer.isVirtualRendering and renderer.virtualSource) or false, (renderer.isVirtualRendering and renderer.virtualRTs.diffuse) or false, (renderer.isVirtualRendering and renderer.virtualRTs.emissive) or false
            syncShader:setValue("vResolution", (renderer.isVirtualRendering and renderer.public.resolution) or false)
            syncShader:setValue("vRenderingEnabled", (renderer.isVirtualRendering and true) or false)
            syncShader:setValue("vSource0", vSource0)
            syncShader:setValue("vSource1", vSource1)
            syncShader:setValue("vSource1Enabled", (vSource1 and true) or false)
            syncShader:setValue("vSource2", vSource2)
            syncShader:setValue("vSource2Enabled", (vSource2 and true) or false)
        end
        return true
    end

    function renderer.public:setTimeSync(state, syncShader, isInternal)
        if not syncShader then
            state = (state and true) or false
            if renderer.isTimeSynced == state then return false end
            renderer.isTimeSynced = state
            if not renderer.isTimeSynced then
                renderer.public:setServerTick(((renderer.serverTick or 0)*1000) + (imports.getTickCount() - (renderer.__serverTick or 0)))
            end
            for i, j in imports.pairs(shader.buffer.shader) do
                renderer.public:setTimeSync(_, i, syncer.librarySerial)
            end
        else
            local isExternalResource = sourceResource and (sourceResource ~= syncer.libraryResource)
            if (not isInternal or (isInternal ~= syncer.librarySerial)) and isExternalResource then
                return false
            end
            syncShader:setValue("gTimeSync", renderer.isTimeSynced)
        end
        return true
    end

    function renderer.public:setServerTick(serverTick, syncShader, isInternal)
        if not syncShader then
            renderer.serverTick = (imports.tonumber(serverTick) or 0)*0.001
            renderer.__serverTick = imports.getTickCount()
            for i, j in imports.pairs(shader.buffer.shader) do
                renderer.public:setServerTick(_, i, syncer.librarySerial)
            end
        else
            local isExternalResource = sourceResource and (sourceResource ~= syncer.libraryResource)
            if (not isInternal or (isInternal ~= syncer.librarySerial)) and isExternalResource then
                return false
            end
            syncShader:setValue("gServerTick", renderer.serverTick)
        end
        return true
    end

    function renderer.public:setMinuteDuration(minuteDuration, syncShader, isInternal)
        if not syncShader then
            renderer.minuteDuration = (imports.tonumber(minuteDuration) or 0)*0.001
            for i, j in imports.pairs(shader.buffer.shader) do
                renderer.public:setMinuteDuration(_, i, syncer.librarySerial)
            end
        else
            local isExternalResource = sourceResource and (sourceResource ~= syncer.libraryResource)
            if (not isInternal or (isInternal ~= syncer.librarySerial)) and isExternalResource then
                return false
            end
            syncShader:setValue("gMinuteDuration", renderer.minuteDuration)
        end
        return true
    end
end