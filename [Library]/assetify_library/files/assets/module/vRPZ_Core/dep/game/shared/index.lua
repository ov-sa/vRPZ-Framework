-----------------
--[[ Imports ]]--
-----------------

loadstring(exports.assetify_library:fetchThreader())()
loadstring(exports.assetify_library:fetchNetworker())()

local imports = {
    tonumber = tonumber,
    loadstring = loadstring,
    isElement = isElement,
    getElementsByType = getElementsByType,
    getElementData = getElementData,
    getWeather = getWeather,
    getTime = getTime,
    string = string,
    math = math,
    assetify = assetify
}


----------------------
--[[ Module: Game ]]--
----------------------

CGame = {
    CExports = [[
        loadstring(exports.assetify_library:fetchImports())()
        loadstring(exports.assetify_library:fetchThreader())()
        loadstring(exports.assetify_library:fetchNetworker())()
        local imports = {}
    ]],
    CTickSyncer = nil,
    execOnLoad = imports.assetify.execOnLoad,
    execOnModuleLoad = imports.assetify.execOnModuleLoad,

    exportModule = function(name, methods)
        if not name or not methods then return false end
        CGame.CExports = CGame.CExports..[[
            ]]..name..[[ = ]]..name..[[ or {}
        ]]
        for i = 1, #methods, 1 do
            local j = methods[i]
            imports.loadstring([[
                local cNetwork = network:create("]]..name..[[.]]..j..[[", true)
                cNetwork:on(function(...)
                    return ]]..name..[[.]]..j..[[(...)
                end)
            ]])()
            CGame.CExports = CGame.CExports..[[
                ]]..name..[[.]]..j..[[ = function(cThread, ...) return network:emitCallback(cThread, "]]..name..[[.]]..j..[[", false, ...) end
            ]]
        end
        return true
    end,

    getServerTick = function()
        local currentTick = 0
        if not CGame.CTickSyncer or not imports.isElement(CGame.CTickSyncer) then
            local tickSyncer = imports.getElementsByType("Server:TickSyncer", resourceRoot)
            CGame.CTickSyncer = tickSyncer[1]
        end
        if CGame.CTickSyncer and imports.isElement(CGame.CTickSyncer) then
            currentTick = imports.tonumber(imports.getElementData(CGame.CTickSyncer, "Server:TickSyncer")) or 0
        end
        return currentTick
    end,

    getNativeWeather = function()
        return imports.getWeather(), {imports.getTime()}
    end,

    getTime = function()
        local time = {imports.getTime()}
        return imports.string.format("%02d:%02d", time[1], time[2])
    end,

    formatMS = function(milliseconds)
        milliseconds = imports.tonumber(milliseconds)
        if not milliseconds then return false end
        local totalseconds = imports.math.floor(milliseconds/1000)
        local seconds = totalseconds%60
        local minutes = imports.math.floor(totalseconds/60)
        local hours = imports.math.floor(minutes/60)
        minutes = minutes%60
        return imports.string.format("%02d:%02d:%02d", hours, minutes, seconds)
    end,

    getLevelEXP = function(level)
        level = imports.tonumber(level)
        if not level then return false end
        local expMultiplier = FRAMEWORK_CONFIGS["Templates"]["Levels"].expMultiplier*0.001
        return imports.math.floor(FRAMEWORK_CONFIGS["Templates"]["Levels"].baseEXP + (imports.math.pow(FRAMEWORK_CONFIGS["Templates"]["Levels"].baseEXP, 2)*imports.math.pow(level, 2)*expMultiplier) + (expMultiplier*level))
    end,

    getLevelRank = function(level)
        level = imports.tonumber(level)
        if not level then return false end
        local rank = imports.math.max(1, imports.math.ceil((#FRAMEWORK_CONFIGS["Templates"]["Levels"]["Ranks"]/FRAMEWORK_CONFIGS["Templates"]["Levels"]["Max_Level"])*level))
        return rank, FRAMEWORK_CONFIGS["Templates"]["Levels"]["Ranks"][rank]
    end,

    generateSpawn = function()
        local point = FRAMEWORK_CONFIGS["Spawns"][(imports.math.random(1, #FRAMEWORK_CONFIGS["Spawns"]))]
        return {
            position = {point.x, point.y, point.z},
            rotation = {0, 0, imports.math.random(0, 360)}
        }
    end
}