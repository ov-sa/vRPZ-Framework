----------------------------------------------------------------
--[[ Resource: Assetify Library
     Script: handlers: bundler: shared.lua
     Author: vStudio
     Developer(s): Aviril, Tron, Mario, Аниса
     DOC: 19/10/2021
     Desc: Bundler: Shared Utilities ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local bundler = bundler:import()
local imports = {
    type = type,
    pairs = pairs
}


-----------------
--[[ Bundler ]]--
-----------------

bundler.private:createBuffer("imports", _, [[
    if not assetify then
        assetify = {}
        ]]..bundler.public:createModule("namespace")..[[
        ]]..bundler.public:createUtils()..[[
        assetify.imports = {
            resourceName = "]]..syncer.libraryName..[[",
            type = type,
            pairs = pairs,
            call = call,
            pcall = pcall,
            assert = assert,
            setmetatable = setmetatable,
            outputDebugString = outputDebugString,
            loadstring = loadstring,
            getResourceFromName = getResourceFromName,
            table = table,
            string = string
        }
    end
]])

bundler.private:createBuffer("core", "__core", [[
    assetify.__core = {}
    assetify.imports.setmetatable(assetify, {__index = assetify.__core})

    ]]..bundler.private:createExports({
        client = {
            {exportIndex = "assetify.__core.getDownloadProgress", exportName = "getDownloadProgress"},
            {exportIndex = "assetify.__core.isAssetLoaded", exportName = "isAssetLoaded"},
            {exportIndex = "assetify.__core.getAssetID", exportName = "getAssetID"},
            {exportIndex = "assetify.__core.loadAsset", exportName = "loadAsset"},
            {exportIndex = "assetify.__core.unloadAsset", exportName = "unloadAsset"},
            {exportIndex = "assetify.__core.loadAnim", exportName = "loadAnim"},
            {exportIndex = "assetify.__core.unloadAnim", exportName = "unloadAnim"},
            {exportIndex = "assetify.__core.createShader", exportName = "createShader"},
            {exportIndex = "assetify.__core.clearWorld", exportName = "clearWorld"},
            {exportIndex = "assetify.__core.restoreWorld", exportName = "restoreWorld"},
            {exportIndex = "assetify.__core.clearModel", exportName = "clearModel"},
            {exportIndex = "assetify.__core.restoreModel", exportName = "restoreModel"},
            {exportIndex = "assetify.__core.playSound", exportName = "playSoundAsset"},
            {exportIndex = "assetify.__core.playSound3D", exportName = "playSoundAsset3D"}
        }
    })..[[
    assetify.__core.isBooted = function()
        return assetify.imports.call(assetify.imports.getResourceFromName(assetify.imports.resourceName), "isLibraryBooted")
    end

    assetify.__core.isLoaded = function()
        return assetify.imports.call(assetify.imports.getResourceFromName(assetify.imports.resourceName), "isLibraryLoaded")
    end
    
    assetify.__core.isModuleLoaded = function()
        return assetify.imports.call(assetify.imports.getResourceFromName(assetify.imports.resourceName), "isModuleLoaded")
    end
    
    assetify.__core.getAssets = function(...)
        return assetify.imports.call(assetify.imports.getResourceFromName(assetify.imports.resourceName), "getLibraryAssets", ...)
    end
    
    assetify.__core.getAsset = function(...)
        return assetify.imports.call(assetify.imports.getResourceFromName(assetify.imports.resourceName), "getAssetData", ...)
    end
    
    assetify.__core.getAssetDep = function(...)
        return assetify.imports.call(assetify.imports.getResourceFromName(assetify.imports.resourceName), "getAssetDep", ...)
    end
    
    assetify.__core.loadModule = function(assetName, moduleTypes)
        local cAsset = assetify.getAsset("module", assetName)
        if not cAsset or not moduleTypes or (#moduleTypes <= 0) then return false end
        if not cAsset.manifestData.assetDeps or not cAsset.manifestData.assetDeps.script then return false end
        for i = 1, #moduleTypes, 1 do
            local j = moduleTypes[i]
            if cAsset.manifestData.assetDeps.script[j] then
                for k = 1, #cAsset.manifestData.assetDeps.script[j], 1 do
                    local rwData = assetify.getAssetDep("module", assetName, "script", j, k)
                    local status, error = assetify.imports.pcall(assetify.imports.loadstring(rwData))
                    if not status then
                        assetify.imports.outputDebugString("[Module: "..assetName.."] | Importing Failed: "..cAsset.manifestData.assetDeps.script[j][k].." ("..j..")")
                        assetify.imports.assert(assetify.imports.loadstring(rwData))
                        assetify.imports.outputDebugString(error)
                    end
                end
            end
        end
        return true
    end
    
    assetify.__core.setElementAsset = function(...)
        return assetify.imports.call(assetify.imports.getResourceFromName(assetify.imports.resourceName), "setElementAsset", ...)
    end
    
    assetify.__core.getElementAssetInfo = function(...)
        return assetify.imports.call(assetify.imports.getResourceFromName(assetify.imports.resourceName), "getElementAssetInfo", ...)
    end
    
    assetify.__core.createDummy = function(...)
        return assetify.imports.call(assetify.imports.getResourceFromName(assetify.imports.resourceName), "createAssetDummy", ...)
    end
]])

bundler.private:createBuffer("scheduler", _, [[
    ]]..bundler.public:createModule("network")..[[
    assetify.scheduler = {
        buffer = {
            pending = {execOnBoot = {}, execOnLoad = {}, execOnModuleLoad = {}}
        },
        execOnBoot = function(exec)
            if not exec or (assetify.imports.type(exec) ~= "function") then return false end
            local isBooted = assetify.isBooted()
            if isBooted then exec()
            else assetify.imports.table.insert(assetify.scheduler.buffer.pending.execOnBoot, exec) end
            return true
        end,

        execOnLoad = function(exec)
            if not exec or (assetify.imports.type(exec) ~= "function") then return false end
            local isLoaded = assetify.isLoaded()
            if isLoaded then exec()
            else assetify.imports.table.insert(assetify.scheduler.buffer.pending.execOnLoad, exec) end
            return true
        end,

        execOnModuleLoad = function(exec)
            if not exec or (assetify.imports.type(exec) ~= "function") then return false end
            local isModuleLoaded = assetify.isModuleLoaded()
            if isModuleLoaded then exec()
            else assetify.imports.table.insert(assetify.scheduler.buffer.pending.execOnModuleLoad, exec) end
            return true
        end,

        boot = function()
            for i, j in assetify.imports.pairs(assetify.scheduler.buffer.schedule) do
                if #j > 0 then
                    for k = 1, #j, 1 do
                        assetify.scheduler[i](j[k])
                    end
                    assetify.scheduler.buffer.schedule[i] = {}
                end
            end
            return true
        end
    }
    assetify.scheduler.buffer.schedule = assetify.imports.table.clone(assetify.scheduler.buffer.pending, true)
    local bootExec = function(type)
        if not assetify.scheduler.buffer.pending[type] then return false end
        if #assetify.scheduler.buffer.pending[type] > 0 then
            for i = 1, #assetify.scheduler.buffer.pending[type], 1 do
                assetify.scheduler.buffer.pending[type][i]()
            end
            assetify.scheduler.buffer.pending[type] = {}
        end
        return true
    end
    local scheduleExec = function(type, exec)
        if not assetify.scheduler.buffer.schedule[type] then return false end
        if not exec or (assetify.imports.type(exec) ~= "function") then return false end
        assetify.imports.table.insert(assetify.scheduler.buffer.schedule[type], exec)
        return true
    end  
    for i, j in assetify.imports.pairs(assetify.scheduler.buffer.schedule) do
        assetify.scheduler[(assetify.imports.string.gsub(i, "exec", "execSchedule", 1))] = function(...) return scheduleExec(i, ...) end
    end
    assetify.network:fetch("Assetify:onBoot", true):on(function() bootExec("execOnBoot") end, {subscriptionLimit = 1})
    assetify.network:fetch("Assetify:onLoad", true):on(function() bootExec("execOnLoad") end, {subscriptionLimit = 1})
    assetify.network:fetch("Assetify:onModuleLoad", true):on(function() bootExec("execOnModuleLoad") end, {subscriptionLimit = 1})
]])

bundler.private:createBuffer("renderer", _, [[
    assetify.renderer = {}
    ]]..bundler.private:createExports({
        client = {
            {exportIndex = "assetify.renderer.isVirtualRendering", exportName = "isRendererVirtualRendering"},
            {exportIndex = "assetify.renderer.setVirtualRendering", exportName = "setRendererVirtualRendering"},
            {exportIndex = "assetify.renderer.getVirtualSource", exportName = "getRendererVirtualSource"},
            {exportIndex = "assetify.renderer.getVirtualRTs", exportName = "getRendererVirtualRTs"},
            {exportIndex = "assetify.renderer.setTimeSync", exportName = "setRendererTimeSync"},
            {exportIndex = "assetify.renderer.setServerTick", exportName = "setRendererServerTick"},
            {exportIndex = "assetify.renderer.setMinuteDuration", exportName = "setRendererMinuteDuration"}
        }
    })..[[
]])

bundler.private:createBuffer("syncer", _, [[
    assetify.syncer = {}
    ]]..bundler.private:createExports({
        shared = {
            {exportIndex = "assetify.syncer.setGlobalData", exportName = "setGlobalData"},
            {exportIndex = "assetify.syncer.getGlobalData", exportName = "getGlobalData"},
            {exportIndex = "assetify.syncer.setEntityData", exportName = "setEntityData"},
            {exportIndex = "assetify.syncer.getEntityData", exportName = "getEntityData"}
        }
    })..[[
]])

bundler.private:createBuffer("attacher", _, [[
    assetify.attacher = {}
    ]]..bundler.private:createExports({
        shared = {
            {exportIndex = "assetify.attacher.setAttachment", exportName = "setAttachment"},
            {exportIndex = "assetify.attacher.setDetachment", exportName = "setDetachment"},
            {exportIndex = "assetify.attacher.clearAttachment", exportName = "clearAttachment"},
            {exportIndex = "assetify.attacher.setBoneAttach", exportName = "setBoneAttachment"},
            {exportIndex = "assetify.attacher.setBoneDetach", exportName = "setBoneDetachment"},
            {exportIndex = "assetify.attacher.setBoneRefresh", exportName = "setBoneRefreshment"},
            {exportIndex = "assetify.attacher.clearBoneAttach", exportName = "clearBoneAttachment"}
        }
    })..[[
]])


bundler.private:createBuffer("lights", "light", [[
    assetify.light = {
        planar = {}
    }
    ]]..bundler.private:createExports({
        client = {
            {exportIndex = "assetify.light.planar.create", exportName = "createPlanarLight"},
            {exportIndex = "assetify.light.planar.setResolution", exportName = "setPlanarLightResolution"},
            {exportIndex = "assetify.light.planar.setTexture", exportName = "setPlanarLightTexture"},
            {exportIndex = "assetify.light.planar.setColor", exportName = "setPlanarLightColor"}
        }
    })..[[
]])