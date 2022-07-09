-----------------
--[[ Imports ]]--
-----------------

local imports = {
    tonumber = tonumber,
    loadstring = loadstring,
    isElement = isElement,
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
        loadstring(exports.assetify_library:import("*"))()
        local imports = {}
    ]],
    CTickSyncer = nil,

    setGlobalData = function(data, value) imports.assetify.syncer.setGlobalData(data, value, true) end,
    setEntityData = function(element, data, value) imports.assetify.syncer.setEntityData(element, data, value, true) end,
    getGlobalData = imports.assetify.syncer.getGlobalData,
    getEntityData = imports.assetify.syncer.getEntityData,
    execOnLoad = imports.assetify.scheduler.execOnLoad,
    execOnModuleLoad = imports.assetify.scheduler.execOnModuleLoad,

    exportModule = function(name, methods)
        if not name or not methods then return false end
        CGame.CExports = CGame.CExports..[[
            ]]..name..[[ = ]]..name..[[ or {}
        ]]
        for i = 1, #methods, 1 do
            local j = methods[i]
            imports.loadstring([[
                assetify.network:create("]]..name..[[.]]..j..[[", true):on(function(...)
                    return ]]..name..[[.]]..j..[[(...)
                end)
            ]])()
            CGame.CExports = CGame.CExports..[[
                ]]..name..[[.]]..j..[[ = function(cThread, ...) return assetify.network:emitCallback(cThread, "]]..name..[[.]]..j..[[", false, ...) end
            ]]
        end
        return true
    end,

    getServerTick = function()
        local cTick = 0
        CGame.CTickSyncer = (CGame.CTickSyncer and imports.isElement(CGame.CTickSyncer) and CGame.CTickSyncer) or CGame.getGlobalData("Server:TickSyncer")
        if CGame.CTickSyncer then
            cTick = imports.tonumber(CGame.getEntityData(CGame.CTickSyncer, "Server:TickSyncer")) or 0
        end
        return cTick
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

    getRole = function(role)
        return (role and FRAMEWORK_CONFIGS["Templates"]["Roles"][role]) or false
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