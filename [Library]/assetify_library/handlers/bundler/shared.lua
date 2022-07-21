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
    if localPlayer then
        assetify.__core.getDownloadProgress = function(...)
            return assetify.imports.call(assetify.imports.getResourceFromName(assetify.imports.resourceName), "getDownloadProgress", ...)
        end
    
        assetify.__core.isAssetLoaded = function(...)
            return assetify.imports.call(assetify.imports.getResourceFromName(assetify.imports.resourceName), "isAssetLoaded", ...)
        end
    
        assetify.__core.getAssetID = function(...)
            return assetify.imports.call(assetify.imports.getResourceFromName(assetify.imports.resourceName), "getAssetID", ...)
        end

        assetify.__core.loadAsset = function(...)
            return assetify.imports.call(assetify.imports.getResourceFromName(assetify.imports.resourceName), "loadAsset", ...)
        end
    
        assetify.__core.unloadAsset = function(...)
            return assetify.imports.call(assetify.imports.getResourceFromName(assetify.imports.resourceName), "unloadAsset", ...)
        end
    
        assetify.__core.loadAnim = function(...)
            return assetify.imports.call(assetify.imports.getResourceFromName(assetify.imports.resourceName), "loadAnim", ...)
        end
    
        assetify.__core.unloadAnim = function(...)
            return assetify.imports.call(assetify.imports.getResourceFromName(assetify.imports.resourceName), "unloadAnim", ...)
        end
    
        assetify.__core.createShader = function(...)
            return assetify.imports.call(assetify.imports.getResourceFromName(assetify.imports.resourceName), "createShader", ...)
        end
    
        assetify.__core.clearWorld = function(...)
            return assetify.imports.call(assetify.imports.getResourceFromName(assetify.imports.resourceName), "clearWorld", ...)
        end
    
        assetify.__core.restoreWorld = function(...)
            return assetify.imports.call(assetify.imports.getResourceFromName(assetify.imports.resourceName), "restoreWorld", ...)
        end
    
        assetify.__core.clearModel = function(...)
            return assetify.imports.call(assetify.imports.getResourceFromName(assetify.imports.resourceName), "clearModel", ...)
        end
    
        assetify.__core.restoreModel = function(...)
            return assetify.imports.call(assetify.imports.getResourceFromName(assetify.imports.resourceName), "restoreModel", ...)
        end
    
        assetify.__core.playSound = function(...)
            return assetify.imports.call(assetify.imports.getResourceFromName(assetify.imports.resourceName), "playSoundAsset", ...)
        end
    
        assetify.__core.playSound3D = function(...)
            return assetify.imports.call(assetify.imports.getResourceFromName(assetify.imports.resourceName), "playSoundAsset3D", ...)
        end
    end
    
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
    if localPlayer then
        assetify.renderer.isVirtualRendering = function(...)
            return assetify.imports.call(assetify.imports.getResourceFromName(assetify.imports.resourceName), "isRendererVirtualRendering", ...)
        end

        assetify.renderer.setVirtualRendering = function(...)
            return assetify.imports.call(assetify.imports.getResourceFromName(assetify.imports.resourceName), "setRendererVirtualRendering", ...)
        end

        assetify.renderer.getVirtualSource = function(...)
            return assetify.imports.call(assetify.imports.getResourceFromName(assetify.imports.resourceName), "getRendererVirtualSource", ...)
        end

        assetify.renderer.getVirtualRTs = function(...)
            return assetify.imports.call(assetify.imports.getResourceFromName(assetify.imports.resourceName), "getRendererVirtualRTs", ...)
        end

        assetify.renderer.setTimeSync = function(...)
            return assetify.imports.call(assetify.imports.getResourceFromName(assetify.imports.resourceName), "setRendererTimeSync", ...)
        end

        assetify.renderer.setServerTick = function(...)
            return assetify.imports.call(assetify.imports.getResourceFromName(assetify.imports.resourceName), "setRendererServerTick", ...)
        end

        assetify.renderer.setMinuteDuration = function(...)
            return assetify.imports.call(assetify.imports.getResourceFromName(assetify.imports.resourceName), "setRendererMinuteDuration", ...)
        end
    end
]])

bundler.private:createBuffer("syncer", _, [[
    assetify.syncer = {
        setGlobalData = function(...)
            return assetify.imports.call(assetify.imports.getResourceFromName(assetify.imports.resourceName), "setGlobalData", ...)
        end,
    
        getGlobalData = function(...)
            return assetify.imports.call(assetify.imports.getResourceFromName(assetify.imports.resourceName), "getGlobalData", ...)
        end,
    
        setEntityData = function(...)
            return assetify.imports.call(assetify.imports.getResourceFromName(assetify.imports.resourceName), "setEntityData", ...)
        end,
    
        getEntityData = function(...)
            return assetify.imports.call(assetify.imports.getResourceFromName(assetify.imports.resourceName), "getEntityData", ...)
        end
    }
]])

bundler.private:createBuffer("attacher", _, [[
    assetify.attacher = {
        setAttachment = function(...)
            return assetify.imports.call(assetify.imports.getResourceFromName(assetify.imports.resourceName), "setAttachment", ...)
        end,

        setDetachment = function(...)
            return assetify.imports.call(assetify.imports.getResourceFromName(assetify.imports.resourceName), "setDetachment", ...)
        end,

        clearAttachment = function(...)
            return assetify.imports.call(assetify.imports.getResourceFromName(assetify.imports.resourceName), "clearAttachment", ...)
        end,

        setBoneAttach = function(...)
            return assetify.imports.call(assetify.imports.getResourceFromName(assetify.imports.resourceName), "setBoneAttachment", ...)
        end,
    
        setBoneDetach = function(...)
            return assetify.imports.call(assetify.imports.getResourceFromName(assetify.imports.resourceName), "setBoneDetachment", ...)
        end,
    
        setBoneRefresh = function(...)
            return assetify.imports.call(assetify.imports.getResourceFromName(assetify.imports.resourceName), "setBoneRefreshment", ...)
        end,
    
        clearBoneAttach = function(...)
            return assetify.imports.call(assetify.imports.getResourceFromName(assetify.imports.resourceName), "clearBoneAttachment", ...)
        end
    }
]])

bundler.private:createBuffer("lights", "light", [[
    assetify.light = {
        planar = {}
    }
    if localPlayer then
        assetify.light.planar.create = function(...)
            return assetify.imports.call(assetify.imports.getResourceFromName(assetify.imports.resourceName), "createPlanarLight", ...)
        end

        assetify.light.planar.setResolution = function(...)
            return assetify.imports.call(assetify.imports.getResourceFromName(assetify.imports.resourceName), "setPlanarLightResolution", ...)
        end

        assetify.light.planar.setTexture = function(...)
            return assetify.imports.call(assetify.imports.getResourceFromName(assetify.imports.resourceName), "setPlanarLightTexture", ...)
        end

        assetify.light.planar.setColor = function(...)
            return assetify.imports.call(assetify.imports.getResourceFromName(assetify.imports.resourceName), "setPlanarLightColor", ...)
        end
    end
]])