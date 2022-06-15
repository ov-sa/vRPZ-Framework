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
        local genImports = {}
        local isCompleteFetch = false
        if args[2] and (args[2] == "*") then
            isCompleteFetch = true
            for i, j in imports.pairs(bundler) do
                if i ~= "imports" then
                    local cImport = {index = i}
                    if imports.type(j) == "table" then
                        cImport.module = j.module or false
                        cImport.rw = bundler["imports"]..j.rw
                    else
                        cImport.rw = bundler["imports"]..j
                    end
                    imports.table.insert(genImports, cImport)
                end
            end
        else
            local __genImports = {}
            for i = 2, #args, 1 do
                local j = args[i]
                if (j ~= "imports") and bundler[j] and not __genImports[j] then
                    local cImport = {index = j}
                    if imports.type(bundler[j]) == "table" then
                        cImport.module = bundler[j].module or false
                        cImport.rw = bundler["imports"]..bundler[j].rw
                    else
                        cImport.rw = bundler["imports"]..bundler[j]
                    end
                    __genImports[j] = true
                    imports.table.insert(genImports, cImport)
                end
            end
            __genImports = nil
        end
        return genImports, isCompleteFetch
    else
        local args = {...}
        args = ((#args > 0) and ", \""..imports.table.concat(args, "\", \"").."\"") or ""
        return [[
        local genImports, isCompleteFetch = call(getResourceFromName("]]..syncer.libraryName..[["), "import", true]]..args..[[)
        local genReturns = (not isCompleteFetch and {}) or false
        for i = 1, #genImports, 1 do
            local j = genImports[i]
            loadstring(j.rw)()
            if not isCompleteFetch and j.index then
                if not j.module then
                    table.insert(genReturns, assetify[(j.index)])
                else
                    table.insert(genReturns, _G[(j.module)])
                end
            end
        end
        if isCompleteFetch or (#genReturns <= 0) then return true
        else return unpack(genReturns) end
        ]]
    end
end


-----------------
--[[ Bundler ]]--
-----------------

bundler["imports"] = imports.file.read("utilities/shared.lua")..[[
    local imports = {
        isAssetifyImport = true,
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
]]

bundler["core"] = [[
    if not assetify then
        assetify = {}

        if localPlayer then
            assetify.getProgress = function(...)
                return imports.call(imports.getResourceFromName(imports.resourceName), "getLibraryProgress", ...)
            end

            assetify.getAssetID = function(...)
                return imports.call(imports.getResourceFromName(imports.resourceName), "getAssetID", ...)
            end

            assetify.isAssetLoaded = function(...)
                return imports.call(imports.getResourceFromName(imports.resourceName), "isAssetLoaded", ...)
            end

            assetify.loadAsset = function(...)
                return imports.call(imports.getResourceFromName(imports.resourceName), "loadAsset", ...)
            end

            assetify.unloadAsset = function(...)
                return imports.call(imports.getResourceFromName(imports.resourceName), "unloadAsset", ...)
            end

            assetify.loadAnim = function(...)
                return imports.call(imports.getResourceFromName(imports.resourceName), "loadAnim", ...)
            end

            assetify.unloadAnim = function(...)
                return imports.call(imports.getResourceFromName(imports.resourceName), "unloadAnim", ...)
            end

            assetify.createShader = function(...)
                return imports.call(imports.getResourceFromName(imports.resourceName), "createShader", ...)
            end

            assetify.clearWorld = function(...)
                return imports.call(imports.getResourceFromName(imports.resourceName), "clearWorld", ...)
            end

            assetify.restoreWorld = function(...)
                return imports.call(imports.getResourceFromName(imports.resourceName), "restoreWorld", ...)
            end

            assetify.clearModel = function(...)
                return imports.call(imports.getResourceFromName(imports.resourceName), "clearModel", ...)
            end

            assetify.restoreModel = function(...)
                return imports.call(imports.getResourceFromName(imports.resourceName), "restoreModel", ...)
            end

            assetify.playSound = function(...)
                return imports.call(imports.getResourceFromName(imports.resourceName), "playSoundAsset", ...)
            end

            assetify.playSound3D = function(...)
                return imports.call(imports.getResourceFromName(imports.resourceName), "playSoundAsset3D", ...)
            end
        end

        assetify.isLoaded = function()
            return imports.call(imports.getResourceFromName(imports.resourceName), "isLibraryLoaded")
        end

        assetify.isModuleLoaded = function()
            return imports.call(imports.getResourceFromName(imports.resourceName), "isModuleLoaded")
        end

        assetify.getAssets = function(...)
            return imports.call(imports.getResourceFromName(imports.resourceName), "getLibraryAssets", ...)
        end

        assetify.getAsset = function(...)
            return imports.call(imports.getResourceFromName(imports.resourceName), "getAssetData", ...)
        end

        assetify.getAssetDep = function(...)
            return imports.call(imports.getResourceFromName(imports.resourceName), "getAssetDep", ...)
        end

        assetify.loadModule = function(assetName, moduleTypes)
            local cAsset = assetify.getAsset("module", assetName)
            if not cAsset or not moduleTypes or (#moduleTypes <= 0) then return false end
            if not cAsset.manifestData.assetDeps or not cAsset.manifestData.assetDeps.script then return false end
            for i = 1, #moduleTypes, 1 do
                local j = moduleTypes[i]
                if cAsset.manifestData.assetDeps.script[j] then
                    for k = 1, #cAsset.manifestData.assetDeps.script[j], 1 do
                        local rwData = assetify.getAssetDep("module", assetName, "script", j, k)
                        if not imports.pcall(imports.loadstring(rwData)) then
                            imports.outputDebugString("[Module: "..assetName.."] | Importing Failed: "..cAsset.manifestData.assetDeps.script[j][k].." ("..j..")")
                            imports.assert(imports.loadstring(rwData))
                        end
                    end
                end
            end
            return true
        end

        assetify.setElementAsset = function(...)
            return imports.call(imports.getResourceFromName(imports.resourceName), "setElementAsset", ...)
        end

        assetify.getElementAssetInfo = function(...)
            return imports.call(imports.getResourceFromName(imports.resourceName), "getElementAssetInfo", ...)
        end

        assetify.createDummy = function(...)
            return imports.call(imports.getResourceFromName(imports.resourceName), "createAssetDummy", ...)
        end
    end
]]

bundler["threader"] = {module = "thread", rw = imports.file.read("utilities/threader.lua")}
bundler["networker"] = {module = "network", rw = imports.file.read("utilities/networker.lua")}

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
            if not execFunc or (imports.type(execFunc) ~= "function") then return false end
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
            if not execFunc or (imports.type(execFunc) ~= "function") then return false end
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
            if not execFunc or (imports.type(execFunc) ~= "function") then return false end
            imports.table.insert(assetify.scheduler.buffer.execOnLoad, execFunc)
            return true
        end,

        execScheduleOnModuleLoad = function(execFunc)
            if not execFunc or (imports.type(execFunc) ~= "function") then return false end
            imports.table.insert(assetify.scheduler.buffer.execOnModuleLoad, execFunc)
            return true
        end,

        boot = function()
            for i, j in imports.pairs(assetify.scheduler.buffer) do
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
                return imports.call(imports.getResourceFromName(imports.resourceName), "isRendererVirtualRendering", ...)
            end,

            setVirtualRendering = function(...)
                return imports.call(imports.getResourceFromName(imports.resourceName), "setRendererVirtualRendering", ...)
            end,

            getVirtualSource = function(...)
                return imports.call(imports.getResourceFromName(imports.resourceName), "getRendererVirtualSource", ...)
            end,

            getVirtualRTs = function(...)
                return imports.call(imports.getResourceFromName(imports.resourceName), "getRendererVirtualRTs", ...)
            end,

            setTimeSync = function(...)
                return imports.call(imports.getResourceFromName(imports.resourceName), "setRendererTimeSync", ...)
            end,

            setServerTick = function(...)
                return imports.call(imports.getResourceFromName(imports.resourceName), "setRendererServerTick", ...)
            end,

            setMinuteDuration = function(...)
                return imports.call(imports.getResourceFromName(imports.resourceName), "setRendererMinuteDuration", ...)
            end
        }
    end
]]

bundler["syncer"] = [[
    assetify.syncer = {
        setGlobalData = function(...)
            return imports.call(imports.getResourceFromName(imports.resourceName), "setGlobalData", ...)
        end,
    
        getGlobalData = function(...)
            return imports.call(imports.getResourceFromName(imports.resourceName), "getGlobalData", ...)
        end,
    
        setEntityData = function(...)
            return imports.call(imports.getResourceFromName(imports.resourceName), "setEntityData", ...)
        end,
    
        getEntityData = function(...)
            return imports.call(imports.getResourceFromName(imports.resourceName), "getEntityData", ...)
        end
    }
]]

bundler["attacher"] = [[
    assetify.attacher = {
        setBoneAttach = function(...)
            return imports.call(imports.getResourceFromName(imports.resourceName), "setBoneAttachment", ...)
        end,
    
        setBoneDetach = function(...)
            return imports.call(imports.getResourceFromName(imports.resourceName), "setBoneDetachment", ...)
        end,
    
        setBoneRefresh = function(...)
            return imports.call(imports.getResourceFromName(imports.resourceName), "setBoneRefreshment", ...)
        end,
    
        clearBoneAttach = function(...)
            return imports.call(imports.getResourceFromName(imports.resourceName), "clearBoneAttachment", ...)
        end
    }
]]

bundler["lights"] = [[
    if localPlayer then
        assetify.light = {
            planar = {
                create = function(...)
                    return imports.call(imports.getResourceFromName(imports.resourceName), "createPlanarLight", ...)
                end,

                setResolution = function(...)
                    return imports.call(imports.getResourceFromName(imports.resourceName), "setPlanarLightResolution", ...)
                end,

                setTexture = function(...)
                    return imports.call(imports.getResourceFromName(imports.resourceName), "setPlanarLightTexture", ...)
                end,

                setColor = function(...)
                    return imports.call(imports.getResourceFromName(imports.resourceName), "setPlanarLightColor", ...)
                end
            }
        }
    end
]]