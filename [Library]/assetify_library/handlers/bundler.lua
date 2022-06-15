----------------------------------------------------------------
--[[ Resource: Assetify Library
     Script: handlers: bundler.lua
     Author: vStudio
     Developer(s): Aviril, Tron
     DOC: 19/10/2021
     Desc: Bundler Handler ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local imports = {
    type = type,
    pairs = pairs,
    table = table,
    file = file
}


-------------------
--[[ Variables ]]--
-------------------

local bundler = {}


-----------------------------------
--[[ Function: Imports Modules ]]--
-----------------------------------

function import(...)
    local args = {...}
    if args[1] == true then
        imports.table.remove(args, 1)
        local buildImports, genImports, __genImports = false, false, {}
        local isCompleteFetch = false
        if (#args <= 0) then
            imports.table.insert(buildImports, "core")
        elseif args[1] == "*" then
            buildImports = {}
            isCompleteFetch = true
            for i, j in imports.pairs(bundler) do
                imports.table.insert(buildImports, i)
            end
        else
            buildImports = args
        end
        for i = 1, #buildImports, 1 do
            local j = buildImports[i]
            if (j ~= "imports") and bundler[j] and not __genImports[j] then
                local cImport = {index = j}
                local isModule = imports.type(bundler[j]) == "table"
                cImport.module = (isModule and bundler[j].module) or false
                cImport.rw = (isModule and bundler["imports"]..bundler[j].rw) or bundler["imports"]..bundler[j]
                __genImports[j] = true
                imports.table.insert(genImports, cImport)
            end
        end
        if #genImports <= 0 then return false end
        return genImports, isCompleteFetch
    else
        local args = {...}
        args = ((#args > 0) and ", \""..imports.table.concat(args, "\", \"").."\"") or ""
        return [[
        local genImports, isCompleteFetch = call(getResourceFromName("]]..syncer.libraryName..[["), "import", true]]..args..[[)
        if not genImports then return false end
        local genReturns = (not isCompleteFetch and {}) or false
        for i = 1, #genImports, 1 do
            local j = genImports[i]
            loadstring(j.rw)()
            if not isCompleteFetch and j.index then
                if not j.module then
                    j.index = ((j.index == "core") and "__core") or j.index
                    table.insert(genReturns, assetify[(j.index)])
                else
                    table.insert(genReturns, _G[(j.module)])
                end
            end
        end
        if isCompleteFetch then return assetify
        else return unpack(genReturns) end
        ]]
    end
end


-----------------
--[[ Bundler ]]--
-----------------

bundler["imports"] = imports.file.read("utilities/shared.lua")..[[
    if not assetify then
        assetify = {
            imports = {
                resourceName = "]]..syncer.libraryName..[[",
                type = type,
                pairs = pairs,
                call = call,
                pcall = pcall,
                assert = assert,
                outputDebugString = outputDebugString,
                loadstring = loadstring,
                getResourceFromName = getResourceFromName,
                table = table
            }
        }
    end
]]

bundler["threader"] = {module = "thread", rw = imports.file.read("utilities/threader.lua")}
bundler["networker"] = {module = "network", rw = imports.file.read("utilities/networker.lua")}

bundler["core"] = [[
    assetify.__core = {}
    if localPlayer then
        assetify.__core.getProgress = function(...)
            return assetify.imports.call(assetify.imports.getResourceFromName(assetify.imports.resourceName), "getLibraryProgress", ...)
        end
    
        assetify.__core.getAssetID = function(...)
            return assetify.imports.call(assetify.imports.getResourceFromName(assetify.imports.resourceName), "getAssetID", ...)
        end
    
        assetify.__core.isAssetLoaded = function(...)
            return assetify.imports.call(assetify.imports.getResourceFromName(assetify.imports.resourceName), "isAssetLoaded", ...)
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
                    if not assetify.imports.pcall(assetify.imports.loadstring(rwData)) then
                        assetify.imports.outputDebugString("[Module: "..assetName.."] | Importing Failed: "..cAsset.manifestData.assetDeps.script[j][k].." ("..j..")")
                        assetify.imports.assert(assetify.imports.loadstring(rwData))
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

    for i, j in assetify.imports.pairs(assetify.__core) do
        assetify[i] = j
    end
]]

bundler["scheduler"] = [[
    if not threader then
    ]]..bundler["threader"].rw..[[
    end
    if not network then
    ]]..bundler["networker"].rw..[[
    end
    assetify.scheduler = {
        buffer = {execOnLoad = {}, execOnModuleLoad = {}},
        execOnLoad = function(execFunc)
            if not execFunc or (assetify.imports.type(execFunc) ~= "function") then return false end
            local isLoaded = assetify.isLoaded()
            if isLoaded then
                execFunc()
            else
                local execWrapper = nil
                execWrapper = function()
                    execFunc()
                    network:fetch("Assetify:onLoad"):off(execWrapper)
                end
                network:fetch("Assetify:onLoad", true):on(execWrapper)
            end
            return true
        end,

        execOnModuleLoad = function(execFunc)
            if not execFunc or (assetify.imports.type(execFunc) ~= "function") then return false end
            local isModuleLoaded = assetify.isModuleLoaded()
            if isModuleLoaded then
                execFunc()
            else
                local execWrapper = nil
                execWrapper = function()
                    execFunc()
                    network:fetch("Assetify:onModuleLoad"):off(execWrapper)
                end
                network:fetch("Assetify:onModuleLoad", true):on(execWrapper)
            end
            return true
        end,

        execScheduleOnLoad = function(execFunc)
            if not execFunc or (assetify.imports.type(execFunc) ~= "function") then return false end
            assetify.imports.table.insert(assetify.scheduler.buffer.execOnLoad, execFunc)
            return true
        end,

        execScheduleOnModuleLoad = function(execFunc)
            if not execFunc or (assetify.imports.type(execFunc) ~= "function") then return false end
            assetify.imports.table.insert(assetify.scheduler.buffer.execOnModuleLoad, execFunc)
            return true
        end,

        boot = function()
            for i, j in assetify.imports.pairs(assetify.scheduler.buffer) do
                if #j > 0 then
                    for k = 1, #j, 1 do
                        assetify.scheduler[i](j[k])
                    end
                    assetify.scheduler.buffer[i] = {}
                end
            end
            return true
        end
    }
]]

bundler["renderer"] = [[
    if localPlayer then
        assetify.renderer = {
            isVirtualRendering = function(...)
                return assetify.imports.call(assetify.imports.getResourceFromName(assetify.imports.resourceName), "isRendererVirtualRendering", ...)
            end,

            setVirtualRendering = function(...)
                return assetify.imports.call(assetify.imports.getResourceFromName(assetify.imports.resourceName), "setRendererVirtualRendering", ...)
            end,

            getVirtualSource = function(...)
                return assetify.imports.call(assetify.imports.getResourceFromName(assetify.imports.resourceName), "getRendererVirtualSource", ...)
            end,

            getVirtualRTs = function(...)
                return assetify.imports.call(assetify.imports.getResourceFromName(assetify.imports.resourceName), "getRendererVirtualRTs", ...)
            end,

            setTimeSync = function(...)
                return assetify.imports.call(assetify.imports.getResourceFromName(assetify.imports.resourceName), "setRendererTimeSync", ...)
            end,

            setServerTick = function(...)
                return assetify.imports.call(assetify.imports.getResourceFromName(assetify.imports.resourceName), "setRendererServerTick", ...)
            end,

            setMinuteDuration = function(...)
                return assetify.imports.call(assetify.imports.getResourceFromName(assetify.imports.resourceName), "setRendererMinuteDuration", ...)
            end
        }
    end
]]

bundler["syncer"] = [[
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
]]

bundler["attacher"] = [[
    assetify.attacher = {
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
]]

bundler["lights"] = [[
    if localPlayer then
        assetify.light = {
            planar = {
                create = function(...)
                    return assetify.imports.call(assetify.imports.getResourceFromName(assetify.imports.resourceName), "createPlanarLight", ...)
                end,

                setResolution = function(...)
                    return assetify.imports.call(assetify.imports.getResourceFromName(assetify.imports.resourceName), "setPlanarLightResolution", ...)
                end,

                setTexture = function(...)
                    return assetify.imports.call(assetify.imports.getResourceFromName(assetify.imports.resourceName), "setPlanarLightTexture", ...)
                end,

                setColor = function(...)
                    return assetify.imports.call(assetify.imports.getResourceFromName(assetify.imports.resourceName), "setPlanarLightColor", ...)
                end
            }
        }
    end
]]