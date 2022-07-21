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
function bundler.private.public:import() return bundler end
bundler.private.rw = {}
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

function bundler.private:createUtils()
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
            end]]
        end
        bundler.private.utils = rw
    end
    return bundler.private.utils
end

function bundler.private:createModule(moduleName)
    if not moduleName then return false end
    local module = bundler.private.modules[moduleName]
    if not module then return false end
    if not bundler.private.rw[(module.module)] then
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
        rw = ((moduleName == "namespace") and string.gsub(rw, "class = {}", "local class = {}")) or rw
        for i = 1, #module.endpoints, 1 do
            local j = module.endpoints[i]
            rw = rw..[[
                assetify["]]..j..[["] = ]]..j..((bundler.private.modules[j] and bundler.private.modules[j].module and ".public") or "")..[[
            ]]
            rw = rw..[[
                _G["]]..j..[["] = nil
            ]]
        end
        bundler.private.rw[(module.module)] = {
            module = moduleName,
            rw = [[
            if not assetify.]]..moduleName..[[ then
                ]]..rw..[[
            end
            ]]
        }
    end
    return bundler.private.rw[(module.module)].rw
end
for i, j in imports.pairs(bundler.private.modules) do
    if j.module and j.endpoints then
        bundler.private:createModule(i)
    end
end

function import(...)
    local cArgs = table.pack(...)
    if cArgs[1] == true then
        table.remove(cArgs, 1)
        local buildImports, genImports, __genImports = {}, {}, {}
        local isCompleteFetch = false
        if (#cArgs <= 0) then
            table.insert(buildImports, "core")
        elseif cArgs[1] == "*" then
            isCompleteFetch = true
            for i, j in imports.pairs(bundler.private.rw) do
                table.insert(buildImports, i)
            end
        else
            buildImports = cArgs
        end
        for i = 1, #buildImports, 1 do
            local j = buildImports[i]
            if (j ~= "imports") and bundler.private.rw[j] and not __genImports[j] then
                __genImports[j] = true
                local module = bundler.private.rw[j].module or j
                table.insert(genImports, {
                    index = module,
                    rw = bundler.private.rw["imports"]..[[
                    ]]..bundler.private.rw[j].rw
                })
            end
        end
        if #genImports <= 0 then return false end
        return genImports, isCompleteFetch
    else
        cArgs = ((#cArgs > 0) and ", \""..table.concat(cArgs, "\", \"").."\"") or ""
        return [[
        local genImports, isCompleteFetch = call(getResourceFromName("]]..syncer.libraryName..[["), "import", true]]..cArgs..[[)
        if not genImports then return false end
        local genReturns = (not isCompleteFetch and {}) or false
        for i = 1, #genImports, 1 do
            local j = genImports[i]
            assert(loadstring(j.rw))()
            if genReturns then genReturns[(#genReturns + 1)] = assetify[(j.index)] end
        end
        if isCompleteFetch then return assetify
        else return table.unpack(genReturns) end
        ]]
    end
    return false
end