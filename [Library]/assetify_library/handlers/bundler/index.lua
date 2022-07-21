----------------------------------------------------------------
--[[ Resource: Assetify Library
     Script: handlers: bundler: index.lua
     Author: vStudio
     Developer(s): Aviril, Tron, Mario, Аниса
     DOC: 19/10/2021
     Desc: Bundler Handler ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local imports = {
    type = type,
    pairs = pairs
}


------------------------
--[[ Class: Bundler ]]--
------------------------

local bundler = class:create("bundler")
function bundler.public:import() return bundler end
bundler.private.buffer = {}
bundler.private.platform = (localPlayer and "client") or "server"
bundler.private.utils = {
    "utilities/sandbox/index.lua",
    "utilities/sandbox/table.lua",
    "utilities/sandbox/math/index.lua",
    "utilities/sandbox/math/quat.lua",
    "utilities/sandbox/math/matrix.lua",
    "utilities/sandbox/string.lua"
}
bundler.private.modules = {
    ["namespace"] = {module = "namespacer", namespace = "assetify.namespace", path = "utilities/sandbox/namespacer.lua", endpoints = {"namespace", "class"}},
    ["class"] = {namespace = "assetify.class"},
    ["file"] = {module = "filesystem", namespace = "assetify.file", path = "utilities/sandbox/filesystem.lua", endpoints = {"file"}},
    ["timer"] = {module = "timer", namespace = "assetify.timer", path = "utilities/sandbox/timer.lua", endpoints = {"timer"}},
    ["thread"] = {module = "threader", namespace = "assetify.thread", path = "utilities/sandbox/threader.lua", endpoints = {"thread"}},
    ["network"] = {module = "networker", namespace = "assetify.network", path = "utilities/sandbox/networker.lua", endpoints = {"network"}}
}

function bundler.public:createUtils()
    if imports.type(bundler.private.utils) == "table" then
        local rw = ""
        for i = 1, #bundler.private.utils, 1 do
            local j = file:read(bundler.private.utils[i])
            for k, v in imports.pairs(bundler.private.modules) do
                j = string.gsub(j, k, v.namespace, _, true, "(", ".:)")
            end
            rw = rw..[[
            if true then
                ]]..j..[[
            end
            ]]
        end
        bundler.private.utils = rw
    end
    return bundler.private.utils
end

function bundler.private:createBuffer(index, name, rw)
    if bundler.private.buffer[index] then return false end
    bundler.private.buffer[index] = {module = name, rw = rw}
    return true
end

function bundler.public:createModule(name)
    if not name then return false end
    local module = bundler.private.modules[name]
    if not module then return false end
    if not bundler.private.buffer[(module.module)] then
        local rw = file:read(module.path)
        for i, j in imports.pairs(bundler.private.modules) do
            local isBlacklisted = false
            for k = 1, #module.endpoints, 1 do
                local v = module.endpoints[k]
                if i == v then
                    isBlacklisted = true
                    break
                end
            end
            if not isBlacklisted then rw = string.gsub(rw, i, j.namespace, _, true, "(", ".:)") end
        end
        rw = ((name == "namespace") and string.gsub(rw, "class = {}", "local class = {}")) or rw
        for i = 1, #module.endpoints, 1 do
            local j = module.endpoints[i]
            rw = rw..[[
            assetify["]]..j..[["] = ]]..j..((bundler.private.modules[j] and bundler.private.modules[j].module and ".public") or "")..[[
            _G["]]..j..[["] = nil
            ]]
        end
        bundler.private:createBuffer(module.module, name, [[
        if not assetify.]]..name..[[ then
            ]]..rw..[[
        end
        ]])
    end
    return bundler.private.buffer[(module.module)].rw
end
for i, j in imports.pairs(bundler.private.modules) do
    if j.module and j.endpoints then
        bundler.public:createModule(i)
    end
end

function bundler.private:createAPIs(exports)
    if not exports or (imports.type(exports) ~= "table") then return false end
    local rw = ""
    for i, j in imports.pairs(exports) do
        if (i == bundler.private.platform) or (i == "shared") then
            for k = 1, #j, 1 do
                local v = j[k]
                rw = rw..[[
                ]]..v.exportIndex..[[ = function(...)
                    return assetify.imports.call(assetify.imports.getResourceFromName(assetify.imports.resourceName), "]]..v.exportName..[[", ...)
                end
                ]]
            end
        end
    end
    return rw
end


-------------------------
--[[ Bundler Syncers ]]--
-------------------------

function import(...)
    local cArgs = table.pack(...)
    if cArgs[1] == true then
        table.remove(cArgs, 1)
        local buildImports, cImports, __cImports = {}, {}, {}
        local isCompleteFetch = false
        if (#cArgs <= 0) then
            table.insert(buildImports, "core")
        elseif cArgs[1] == "*" then
            isCompleteFetch = true
            for i, j in imports.pairs(bundler.private.buffer) do
                table.insert(buildImports, i)
            end
        else
            buildImports = cArgs
        end
        for i = 1, #buildImports, 1 do
            local j = buildImports[i]
            if (j ~= "imports") and bundler.private.buffer[j] and not __cImports[j] then
                __cImports[j] = true
                table.insert(cImports, {
                    index = bundler.private.buffer[j].module or j,
                    rw = bundler.private.buffer["imports"].rw..[[
                    ]]..bundler.private.buffer[j].rw
                })
            end
        end
        if #cImports <= 0 then return false end
        return cImports, isCompleteFetch
    else
        cArgs = ((#cArgs > 0) and ", \""..table.concat(cArgs, "\", \"").."\"") or ""
        return [[
        local cImports, isCompleteFetch = call(getResourceFromName("]]..syncer.libraryName..[["), "import", true]]..cArgs..[[)
        if not cImports then return false end
        local cReturns = (not isCompleteFetch and {}) or false
        for i = 1, #cImports, 1 do
            local j = cImports[i]
            assert(loadstring(j.rw))()
            if cReturns then cReturns[(#cReturns + 1)] = assetify[(j.index)] end
        end
        if isCompleteFetch then return assetify
        else return table.unpack(cReturns) end
        ]]
    end
    return false
end